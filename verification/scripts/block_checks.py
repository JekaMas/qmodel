"""Run the local funded-block workload with the actual settlement actions."""
import argparse
from dataclasses import asdict, dataclass

from evidence import QUINT, ROOT, execute
from repeated_checks import stage
from three_checks import source_closure

RUNTIME = ROOT / "verification/results/runtime/funded-blocks"
MODEL = "verification/models/dvp_blocks.qnt"
CHECKER = "verification/configs/tlc.json"
MAIN = "funded_blocks"


@dataclass(frozen=True)
class Profile:
    pairs_a: int = 3
    pairs_b: int = 3
    fault: int = 0
    stale: str = ""
    directed: bool = False

    @property
    def expected(self):
        return "counterexample" if self.fault or self.stale else "pass"

    @property
    def settles(self):
        return self.pairs_a == self.pairs_b == 3

    def config(self):
        return {"trades": 3, "deadline": 2, **asdict(self)}


CASES = {
    "full": Profile(),
    "short-a": Profile(pairs_a=2),
    "short-b": Profile(pairs_b=2),
    "early-seal": Profile(fault=1),
    "double-charge": Profile(fault=2),
    "overbook-a": Profile(pairs_a=2, stale="a"),
    "overbook-b": Profile(pairs_b=2, stale="b"),
    "directed": Profile(directed=True),
}


def replace_once(source, old, new):
    if source.count(old) != 1:
        raise ValueError(f"Changed block specialization anchor: {old!r}")
    return source.replace(old, new)


def source(profile):
    data = source_closure(3)
    core = data["dvp.qnt"].decode()
    for before, after in (
        ("deadline:List(1,2,2).nth(t-1)", "deadline:D"),
        ("ownerA:6,ownerB:9", f"ownerA:{2*profile.pairs_a},ownerB:{3*profile.pairs_b}"),
        ("receivedA.get(t))==6", f"receivedA.get(t))=={2*profile.pairs_a}"),
        ("receivedB.get(t))==9", f"receivedB.get(t))=={3*profile.pairs_b}"),
    ):
        core = replace_once(core, before, after)
    if profile.stale == "a":
        core = replace_once(core, "x.ownerA-reservedA(x)>=2", "x.ownerA>=2")
    if profile.stale == "b":
        core = replace_once(core, "s.ownerB-reservedB(s)>=3", "s.ownerB>=3")
    data["dvp.qnt"] = core.encode()
    data["dvp_blocks.qnt"] = (ROOT / MODEL).read_bytes()
    data["funded_blocks.qnt"] = workload(profile).encode()
    return data


def workload(profile):
    rows = []
    marks = {}

    def fixed(op):
        before = len(rows)
        rows.append(f"    all {{pc=={before},{op},pc'={before+1}}},")

    def mark(name):
        marks[name] = len(rows)

    # The fixed segments merely produce authentic inputs. All transactions
    # inside each block are independent nondeterministic choices.
    def publication(t, phase):
        fixed(f"finalizeSealed({t},{phase})")
        for job in (1, 2, 3):
            fixed(f"proofJob({t},{phase},{job})")

    def choose_blocks(kind, legs):
        before = len(rows)
        selected = f"Set({','.join(map(str, legs))})"
        # Keep all in-block interleavings at this PC. Increment the PC only
        # after every given local block has actually sealed.
        rows.append(
            f"    all {{pc=={before}, pc'=pc, nondet leg={selected}.oneOf(); "
            f"blockWork(leg,{kind})}},"
        )
        rows.append(
            f"    all {{pc=={before}, {selected}.forall(leg=>processed(leg,{kind})), "
            f"waitBlock,pc'={before+2}}},"
        )

    for t in (1, 2, 3):
        for party in (0, 1):
            fixed(f"authorize({t},{party})")
    mark("signedPC")
    choose_blocks("Reserve", (0, 1))
    mark("heldPC")
    if profile.settles:
        for t in (1, 2, 3):
            publication(t, 2)
        fixed("nextA")
        mark("decisionPC")
        choose_blocks("Settle", (0,))
        mark("decidedPC")
        for t in (1, 2, 3):
            publication(t, 3)
            fixed(f"takeOutcome({t})")
        fixed("nextB")
        mark("cashPC")
        choose_blocks("Settle", (1,))
        mark("paidPC")
        for t in (1, 2, 3):
            for leg in (0, 1):
                publication(t, 5+leg)
                fixed(f"observeEffect({t},{leg})")
            fixed(f"bookTrade({t})")
    mark("donePC")

    head = f'''module {MAIN} {{
  import dvp_blocks(COUNT=3,FAULT={profile.fault}).* from "./dvp_blocks"
  import guarantee_oracles.* from "./guarantee_oracles"
  var pc:int
  action blockInit=all {{start,pc'=0}}
  action blockWork(leg:int,kind:int):bool=any {{
    openBlock(leg,kind,Ids),sealBlock(leg),
    nondet t=Ids.oneOf(); executeTx(leg,t)
  }}
'''
    head += "".join(f"  pure val {name}={pc}\n" for name, pc in marks.items())
    head += "  action work=any {\n" + "\n".join(rows) + "\n  }\n"
    head += """
  // There is no nonterminal stutter. The fixed program and each open block's
  // finite remaining work give a finite ascending rank before this endpoint.
  action blockStep=any {work,all {pc==donePC,pc'=pc,waitBlock}}
  val economicSound=coreSound and
    Ids.forall(t=>tradeGuarantees(sourceState,tradeTerms(t)))
  val fullyBooked=Ids.forall(t=>{
    val row=sourceState.trades.get(t)
    and {row.decision==2,row.effectsA==1,row.effectsB==1,
      evidenceBackedBooking(sourceState,tradeTerms(t))}
  })
"""
    if profile.settles:
        terminal = "fullyBooked and sourceState.ownerA==0 and sourceState.ownerB==0"
    else:
        terminal = (f"lane(0).applied.size()=={profile.pairs_a} and lane(1).applied.size()=={profile.pairs_b} and "
                    "Ids.forall(t=>and {"
                    "sourceState.trades.get(t).preparedA==lane(0).applied.contains(t),"
                    "sourceState.trades.get(t).preparedB==lane(1).applied.contains(t)})")
    head += f"  val sound=economicSound and blockSound and (pc==donePC implies ({terminal}))\n"
    if profile.expected == "pass" and not profile.directed:
        head += "  temporal includedProgress=work.weakFair((pc,blocks)).implies(eventually(pc==donePC))\n"
    if profile.directed:
        head += (ROOT / "verification/tests/workloads/funded_blocks_tests.qnt").read_text()
    return head + "}\n"


def check(case):
    profile = CASES[case]
    name = f"funded-blocks-{case}"
    folder = RUNTIME / case
    stage(folder, source(profile))
    model = str((folder / "funded_blocks.qnt").relative_to(ROOT))
    if profile.directed:
        return execute(name, [QUINT, "test", model, "--main", MAIN, "--backend", "rust",
                              "--seed", "71", "--match", ".*Test"], seconds=90,
                       claim="Local block-height, cutoff, replay, publication and existing-hold witnesses",
                       config=profile.config())
    command = [QUINT, "verify", model, "--main", MAIN, "--backend", "tlc", "--init", "blockInit",
               "--step", "blockStep", "--invariant", "sound", "--tlc-config", CHECKER, "--verbosity", "3"]
    if profile.expected == "pass":
        command.extend(("--temporal", "includedProgress"))
    return execute(name, command, backend="tlc", expected=profile.expected, seconds=180,
                   claim="Included local block requests execute in any order against live spendable funds",
                   config=profile.config())



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases", nargs="*", metavar="CASE")
    names = parser.parse_args().cases or CASES
    results = [check(case) for case in names]
    raise SystemExit(not all(r["expectation_met"] for r in results))

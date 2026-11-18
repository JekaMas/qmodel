"""Source-bound three-trade variants. Existing settlement receipts keep their inputs."""
import argparse

from evidence import QUINT, ROOT, execute
from guarantee_checks import JVM
from repeated_checks import stage

MODELS = ROOT / "verification/models"
WORKLOAD = ROOT / "verification/tests/workloads"
RUNTIME = ROOT / "verification/results/runtime/three"


def specialize(filename, substitutions):
    source = (MODELS / filename).read_text()
    for old, new, count in substitutions:
        if source.count(old) != count:
            raise ValueError(f"{filename}: changed source anchor {old!r}")
        source = source.replace(old, new)
    return source.encode()


def source_closure(pairs, timed=False):
    deadlines = [2, 3, 5] if timed else [1, 2, 2]
    patches = (
        ("pure val D = 2", f"pure val D = {max(deadlines)}", 1),
        ("deadline:D,", f"deadline:List({','.join(map(str, deadlines))}).nth(t-1),", 1),
        ("x.height<D", "x.height<desc(t).deadline", 2),
        ("s.admitted,s.height<D,s.trades", "s.admitted,s.height<desc(t).deadline,s.trades", 1),
        ("authorized(s,t),s.height>=D,", "authorized(s,t),s.height>=desc(t).deadline,", 1),
        ("ownerA:2,ownerB:3,vaultA:0", f"ownerA:{2*pairs},ownerB:{3*pairs},vaultA:0", 1),
        ("receivedA.get(t))==2,", f"receivedA.get(t))=={2*pairs},", 1),
        ("receivedB.get(t))==3,", f"receivedB.get(t))=={3*pairs},", 1),
        ("root:200+p*10+t", "root:200+7*t+p", 1),
        ("trade:3-t", "trade:if(t==N) 1 else t+1", 1),
        ("else {...f,root:999}", "else if(binding==10) {...f,root:999}\n      else {...f,d:{...f.d,trade:N+1}}", 1),
        ("action spend(leg:int): bool = all {", "action spend(leg:int): bool = all {Set(0,1).contains(leg),s.up.contains(leg),", 1),
        ("s.up.contains(leg),(HOST!=3 or s.up.contains(3)), has(s,t,if(outcome==2) 3 else 4),",
         "Set(0,1).contains(leg),Set(2,3).contains(outcome),s.up.contains(leg),(HOST!=3 or s.up.contains(3)),has(s,t,if(outcome==2) 3 else 4),", 1),
    )
    return {
        "dvp.qnt": specialize("dvp.qnt", patches),
        "economic_effects.qnt": (MODELS / "economic_effects.qnt").read_bytes(),
        "guarantee_oracles.qnt": specialize("guarantee_oracles.qnt", (
            ("root:200+phase*10+d.trade", "root:200+d.trade*7+phase", 1),
        )),
    }


def finite(pairs):
    directory = RUNTIME / f"decisions-{pairs}"
    stage(directory, {**source_closure(pairs), "three.qnt": (WORKLOAD / "three.qnt").read_bytes()})
    relative = str((directory / "three.qnt").relative_to(ROOT))
    return execute(
        f"three-decisions-{pairs}",
        [QUINT, "verify", relative, "--main", "three", "--backend", "tlc", "--init", "init",
         "--step", "decisionStep", "--invariant", "sound", "--temporal", "decides",
         "--tlc-config", "verification/configs/extended-tlc8.json", "--verbosity", "3"],
        claim="Exhaustive three-trade admission, preparation and decision with conditional terminal decision progress",
        backend="tlc", seconds=3600, config={"trades": 3, "funded_pairs": pairs, "scope": "admission-to-decision"},
        execution_env=JVM, resource_limit="8 GiB JVM heap; 3600s",
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pairs", type=int, choices=(2,3), nargs="+")
    results = [finite(pairs) for pairs in parser.parse_args().pairs]
    raise SystemExit(not all(r["expectation_met"] for r in results))

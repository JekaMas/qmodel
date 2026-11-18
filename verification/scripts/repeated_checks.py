"""Run the source-bound seven-trade settlement workload and its directed cases."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from itertools import combinations, permutations
import re

from evidence import QUINT, ROOT, execute, qrun

MODELS = ROOT / "verification/models"
WORKLOAD = ROOT / "verification/tests/workloads/repeated.qnt"
RUNTIME = ROOT / "verification/results/runtime/repeated"
CORE = "dvp.qnt"
PARALLEL = (4, 5, 6)
ACTORS = tuple(range(5))
DEADLINES = (1, 3, 5, 6, 6, 7, 8)
BATCH_SIZE = 16

# Only the workload inputs and the real ledger-availability guard are changed.
# Both conserved totals must follow the funded initializer in this profile.
SUBSTITUTIONS = (
    ("pure val D = 2", "pure val D = 8", 1),
    ("deadline:D,", "deadline:List(1,3,5,6,6,7,8).nth(t-1),", 1),
    ("x.height<D", "x.height<desc(t).deadline", 2),
    ("s.admitted,s.height<D,s.trades", "s.admitted,s.height<desc(t).deadline,s.trades", 1),
    ("authorized(s,t),s.height>=D,", "authorized(s,t),s.height>=desc(t).deadline,", 1),
    ("ownerA:2,ownerB:3,vaultA:0", "ownerA:10,ownerB:15,vaultA:0", 1),
    ("receivedA.get(t))==2,", "receivedA.get(t))==10,", 1),
    ("receivedB.get(t))==3,", "receivedB.get(t))==15,", 1),
    ("action spend(leg:int): bool = all {", "action spend(leg:int): bool = all {s.up.contains(leg),", 1),
)


def specialize(source):
    for old, new, count in SUBSTITUTIONS:
        if source.count(old) != count:
            raise ValueError(f"Specialization anchor changed: {old}")
        source = source.replace(old, new)
    return source


def signed(t):
    return [f"sign({t},0)", f"sign({t},1)"]


def prepared(t):
    return [*signed(t), f"openA({t})", f"prepareB({t})"]


def proof(t, phase):
    return [f"{op}({t},{phase})" for op in ("finalize", "capture", "prove", "deliver")]


def apply_cash(t):
    return [*proof(t, 3), f"learn({t},2,1)", f"applyB({t})"]


def book(t):
    return [*proof(t, 5), f"observe({t},0)", *proof(t, 6), f"observe({t},1)", f"reconcile({t})"]


def settle(t):
    return [*prepared(t), *proof(t, 2), f"commit({t})", *apply_cash(t), *book(t)]


def abort_record(t):
    return [f"captureAbortRecord({t},0)", f"captureAbortRecord({t},1)", f"recordAbort({t})"]


EVENT_ARITIES = {
    "sign": 2, "openA": 1, "prepareB": 1, "tick": 0, "finalize": 2, "capture": 2, "prove": 2,
    "proveUnadmitted": 2, "deliverUnadmitted": 2, "lose": 2, "resend": 2, "deliver": 2, "inject": 3,
    "commit": 1, "abort": 1, "learn": 3, "applyB": 1, "refund": 2, "spend": 1, "crash": 1, "recover": 1,
    "observe": 2, "reconcile": 1, "captureAbortRecord": 2, "recordAbort": 1, "rotate": 0, "exitMember": 0,
    "revoke": 1, "revokeLeg": 2, "freeze": 1, "unfreeze": 1, "prune": 2, "receiveNote": 1,
    "compromiseTransport": 0, "idle": 0, "requestExactOpen": 1, "requestExactCash": 1,
}
EVENTS = {name: i for i, name in enumerate(EVENT_ARITIES)}


def encode_action(action):
    name, raw = re.fullmatch(r"(\w+)(?:\(([0-9,]+)\))?", action).groups()
    arguments = raw.split(",") if raw else []
    if len(arguments) != EVENT_ARITIES[name]:
        raise ValueError(f"Wrong argument count: {action}")
    values = [str(EVENTS[name]), *arguments, *(["0"] * (3 - len(arguments)))]
    return "(" + ",".join(values) + ")"


def dispatcher():
    # Quint's library for iterating a trace keeps evaluation depth bounded in
    # long cases, and its guard/expect reports the exact failed event.
    rows = [
        "  action requestExactOpen(t:int):bool = requestOpen(t,desc(t))",
        "  action requestExactCash(t:int):bool = requestCash(t,desc(t))",
        "  action executeEvent(e:(int,int,int,int)):bool = any {",
    ]
    for op, arity in EVENT_ARITIES.items():
        arguments = "(" + ",".join(f"e._{i+2}" for i in range(arity)) + ")" if arity else ""
        rows.append(f"    all {{e._1=={EVENTS[op]}, {op}{arguments}}},")
    rows += [
        "  }",
        "  action replayEvents(events:List[(int,int,int,int)]):bool = events.length().reps(i=>{",
        "    val decisions = Trades.filter(t=>s.trades.get(t).decision>=2).map(t=>(t,s.trades.get(t).decision))",
        "    val outputs = s.economicReceipts",
        "    val rows = s.financialRecords",
        "    executeEvent(events.nth(i)).expect(sequenceSafe and",
        "      decisions.forall(d=>s.trades.get(d._1).decision==d._2) and",
        "      outputs.subseteq(s.economicReceipts) and rows.subseteq(s.financialRecords))",
        "  })",
    ]
    return "\n".join(rows) + "\n"


def chain(prefix, actions):
    events = ",".join(map(encode_action, actions))
    return prefix if not events else f"{prefix}\n    .then(replayEvents(List({events})))"


def binding_cases():
    # Each candidate comes through inject. Test actual lack of acceptance for
    # the requested phase and keep the existing authenticated past intact.
    return {
        f"Phase{phase}Binding{binding}Test":
            chain("parallelHeld", [f"inject(5,{phase},{binding})"]) +
            f".expect(not(has(s,5,{phase})) and s.rejects==Set({binding}) and pending(5))"
        for phase in range(7) for binding in range(11)
    }


def schedule_cases():
    # The partial order has six events and three disjoint precedence edges.
    # Enumerate the linear extensions, including COMMIT/remote-apply lag.
    events = tuple(action for t in PARALLEL for action in (("C", t), ("B", t)))
    cases = {}
    names = {"C": "Commit", "B": "Apply"}
    for ordering in permutations(events):
        if any(ordering.index(("C", t)) > ordering.index(("B", t)) for t in PARALLEL):
            continue
        name = "".join(f"{names[edge]}{t}" for edge, t in ordering) + "Test"
        expected_commits = set()
        expected_applied = set()
        expression = "ready"
        for edge, t in ordering:
            if edge == "C":
                expression = chain(expression, [f"commit({t})"])
                expected_commits.add(t)
            else:
                expression = chain(expression, apply_cash(t))
                expected_applied.add(t)
            # Literal per-boundary accounting, including every inactive leg.
            checks = [
                f"s.ownerA=={6 - 2 * len(expected_commits)}",
                f"s.ownerB=={9 - 3 * len(expected_applied)}",
                f"s.receivedA.get({t})==2",
            ]
            for leg in PARALLEL:
                checks.append(f"s.trades.get({leg}).decision=={2 if leg in expected_commits else 1}")
                checks.append(f"s.receivedB.get({leg})=={3 if leg in expected_applied else 0}")
            expression += ".expect(" + " and ".join(checks) + ")"
        cases[name] = chain(expression, [step for t in PARALLEL for step in book(t)]) + ".expect(completed)"
    if len(cases) != 90:
        raise ValueError("Expected all 90 legal decision/application interleavings")
    return cases


def set_expr(values):
    return "Set(" + ",".join(map(str, values)) + ")"


def health_cases():
    cases = {}
    for count in range(1, len(ACTORS) + 1):
        for down in combinations(ACTORS, count):
            present = tuple(actor for actor in ACTORS if actor not in down)
            crashed = chain("waitingCash", [f"crash({actor})" for actor in down])
            crashed += f".expect(s.up=={set_expr(present)} and s.trades.get(4).holdB==1 and s.financialRecords.size()==3)"
            recovered = chain(crashed, [f"recover({actor})" for actor in reversed(down)])
            name = "".join(map(str, down))
            cases[f"Outage{name}RecoveryTest"] = chain(recovered, ["applyB(4)", *book(4)]) + (
                ".expect(s.up==Set(0,1,2,3,4) and committedTrade(4) and pending(5) and pending(6) and durablePrefix)"
            )
    return cases


# Each phase has an already included source fact reachable on the A-hosted
# reference. A preparation is phase 1 even though A does not need it itself.
PROOF_PREFIXES = (
    ("parallelHeld", 4, 0),
    ("parallelHeld", 4, 0),
    ("parallelHeld", 4, 1),
    ("committedA", 4, 0),
    ("expired", 2, 0),
    ("committedA", 4, 0),
    ("cashDelivered", 4, 1),
)


def proof_fault_cases():
    cases = {}
    for phase, (prefix, t, source) in enumerate(PROOF_PREFIXES):
        atom = f"fact({t},{phase})"
        fin, cap, prove, deliver = proof(t, phase)
        drop, retry, prune = (f"{a}({t},{phase})" for a in ("lose", "resend", "prune"))
        planned = (
            ("Finalize", source, [], fin, f"s.included.contains({atom})"),
            ("Capture", 3, [fin], cap, f"s.finalized.contains({atom})"),
            ("Prove", 3, [fin, cap], prove, f"s.captured.contains({atom})"),
            ("Deliver", 4, [fin, cap, prove], deliver, f"s.network.contains({atom})"),
            ("Resend", 4, [fin, cap, prove, drop], retry,
             f"s.proofs.contains({atom}) and not(s.network.contains({atom}))"),
        )
        for role, actor, before, blocked, precondition in planned:
            attempts = [*before, f"crash({actor})"]
            denied = chain(prefix, attempts) + f".expect({precondition} and not(s.up.contains({actor})))"
            cases[f"Phase{phase}{role}OutageTest"] = denied + f".then({blocked}.fail())"
        resumed = []
        for actor, operation in (
            (source, fin), (3, cap), (3, prove), (4, retry), (4, deliver),
        ):
            resumed.extend([f"crash({actor})", f"recover({actor})", operation])
            if operation == cap:
                resumed.append(prune)
            if operation == prove:
                resumed.append(drop)
        resumed.append(deliver)
        cases[f"Phase{phase}ProofPipelineRecoveryTest"] = chain(prefix, resumed) + (
            f".expect(s.captured.contains({atom}) and s.pruned.contains({atom}) and has(s,{t},{phase}) and durablePrefixAtMost)"
        )
    return cases


def generated_tests():
    prefix = {
        "first": chain("init.expect(sequenceSafe)", settle(1)),
        "expired": chain("first", [*prepared(2), "tick", "tick", "tick", "abort(2)"]),
        "released": chain("expired", [*proof(2, 4), "learn(2,3,1)", "refund(2,0)", "refund(2,1)", *abort_record(2)]),
        "sequential": chain("released", settle(3)) + ".expect(committedTrade(1) and releasedTrade(2) and committedTrade(3))",
        "parallelHeld": chain("sequential", [step for t in PARALLEL for step in prepared(t)]) + (
            ".expect(PARALLEL.forall(t=>pending(t)) and reservedA(s)==6 and reservedB(s)==9 and durablePrefix)"
        ),
        "ready": chain("parallelHeld", [step for t in PARALLEL for step in proof(t, 2)]),
        "committedA": chain("ready", ["commit(4)"]),
        "waitingCash": chain("committedA", [*proof(4, 3), "learn(4,2,1)"]),
        "cashDelivered": chain("waitingCash", ["applyB(4)"]),
        "signedSeven": chain("parallelHeld", signed(7)),
        "lateOutcome": chain("ready", ["commit(4)", *proof(4, 3)[:-1], "lose(4,3)"]),
    }
    literals = """
  pure val PARALLEL = Set(4,5,6)
  val durablePrefix = Set(1,2,3).forall(t=>s.financialRecords.contains({d:desc(t),outcome:if(t==2) 3 else 2}))
  val durablePrefixAtMost = s.financialRecords.contains({d:desc(1),outcome:2}) and
    s.financialRecords.forall(r=>Set(1,2,3).contains(r.d.trade))
  val completed = Set(1,3,4,5,6).forall(t=>committedTrade(t)) and releasedTrade(2) and
    s.ownerA==0 and s.ownerB==0 and s.economicReceipts.size()==12 and s.financialRecords.size()==6
"""
    cases = {
        "SequentialCommitAbortCommitTest": "sequential.expect(s.height==3 and s.ownerA==6 and s.ownerB==9 and durablePrefix)",
        "ParallelReservationsTest": "parallelHeld",
        "ContendedATest": "signedSeven.then(openA(7).fail())",
        "ContendedBTest": "signedSeven.then(prepareB(7).fail())",
        "ReservedSecuritiesCannotBeSpentTest": "parallelHeld.then(spend(0).fail())",
        "ReservedCashCannotBeSpentTest": "parallelHeld.then(spend(1).fail())",
        "OldPreparationCannotCommitNewTradeTest": "parallelHeld.expect(s.received.contains(fact(3,2))).then(commit(4).fail())",
        "OldOutcomeCannotApplyNewTradeTest": "parallelHeld.expect(s.received.contains(fact(3,3))).then(learn(4,2,1).fail())",
        "OlderDeadlineReachedWhileLaterTradeCanCommitTest": "ready.expect(s.height==desc(2).deadline and s.height<desc(4).deadline).then(abort(4).fail())",
        "DuplicateCashCannotApplyAgainTest": chain("waitingCash", ["applyB(4)", "deliver(4,3)", "learn(4,2,1)"]) + ".then(applyB(4).fail())",
        "LostOutcomeCannotBeLearnedTest": "lateOutcome.expect(not(s.network.contains(fact(4,3))) and s.proofs.contains(fact(4,3))).then(learn(4,2,1).fail())",
        "RecoveryAfterDropPruneAndRestartTest": chain("lateOutcome", [
            "prune(4,3)", "crash(1)", "crash(3)", "crash(4)", "recover(4)", "resend(4,3)", "deliver(4,3)",
            "recover(1)", "learn(4,2,1)", "applyB(4)", "recover(3)", *book(4),
            *proof(1,5), "observe(1,0)", *proof(1,6), "observe(1,1)", "reconcile(1)",
        ]) + ".expect(committedTrade(4) and pending(5) and pending(6) and s.financialRecords.size()==4 and durablePrefix)",
        "OldApplicationCannotBookAnotherTradeTest": "waitingCash.expect(s.received.contains(fact(1,6))).then(observe(4,1).fail())",
        "PruneBeforeWitnessTest": "parallelHeld.then(finalize(4,2)).expect(s.finalized.contains(fact(4,2))).then(prune(4,2).fail())",
        "UnadmittedProofCannotDecideTest": chain("parallelHeld", ["finalize(4,2)", "capture(4,2)", "proveUnadmitted(4,2)", "deliverUnadmitted(4,2)"]) +
            ".expect(s.proofs.contains({...fact(4,2),program:0}) and not(has(s,4,2))).then(commit(4).fail())",
        "UnadmittedProofCannotApplyTest": chain("ready", ["commit(4)", "finalize(4,3)", "capture(4,3)", "proveUnadmitted(4,3)", "deliverUnadmitted(4,3)"]) +
            ".expect(s.proofs.contains({...fact(4,3),program:0}) and not(has(s,4,3))).then(learn(4,2,1).fail())",
        "AFrozenCannotCommitTest": chain("ready", ["freeze(0)"]) + ".expect(pending(4)).then(commit(4).fail())",
        "BFrozenCannotApplyTest": chain("waitingCash", ["freeze(1)"]) + ".expect(s.trades.get(4).holdB==1).then(applyB(4).fail())",
        "UnfreezeAndExitDoesNotRevokePendingTest": chain("waitingCash", [
            "freeze(1)", "rotate", "exitMember", "unfreeze(1)", "applyB(4)", *book(4), "receiveNote(4)", "compromiseTransport", "idle",
        ]) + ".expect(committedTrade(4) and s.note.contains(4) and s.transportCompromised and S16 and not(s.admitted) and durablePrefix)",
        "LateAbortStillReleasesInParallelTest": chain("ready", [
            "commit(4)", *apply_cash(4), "tick", "tick", "tick", "abort(5)", *proof(5,4), "learn(5,3,1)",
            "refund(5,0)", "refund(5,1)", *abort_record(5), "commit(6)", *apply_cash(6), *book(6), *book(4),
        ]) + ".expect(committedTrade(4) and releasedTrade(5) and committedTrade(6) and durablePrefix and s.financialRecords.size()==6)",
        "ContenderTombstoneHasNoRefundsTest": chain("signedSeven", [
            *[op for t in PARALLEL for op in [*proof(t,2), f"commit({t})", *apply_cash(t), *book(t)]],
            *["tick"]*5, "abort(7)", *proof(7,4), "learn(7,3,1)", *abort_record(7),
        ]) + ".expect(s.financialRecords.size()==7 and evidenceBackedBooking(s,desc(7)) and s.trades.get(7).refundsA==0 and s.trades.get(7).refundsB==0)",
        "CashCannotSpendWhileBOfflineTest": chain("init.expect(sequenceSafe)", ["crash(1)"]) +
            ".expect(s.ownerB==15 and not(s.up.contains(1))).then(spend(1).fail())",
        "SecuritiesCannotSpendWhileAOfflineTest": chain("init.expect(sequenceSafe)", ["crash(0)"]) +
            ".expect(s.ownerA==10 and not(s.up.contains(0))).then(spend(0).fail())",
        "IndependentSpendingRecoversTest": chain("init.expect(sequenceSafe)", ["crash(0)", "spend(1)", "recover(0)", "spend(0)"]) +
            ".expect(s.ownerA==9 and s.ownerB==14 and s.spentA==1 and s.spentB==1)",
        "RevokedLegCannotPrepareTest": chain("init.expect(sequenceSafe)", [*signed(1), "revokeLeg(1,1)", "openA(1)"]) +
            ".expect(s.trades.get(1).holdA==1 and not(s.eligible.contains((1,1)))).then(prepareB(1).fail())",
        "RevokeBothCannotOpenTest": chain("init.expect(sequenceSafe)", [*signed(1), "revoke(1)"]) +
            ".expect(not(s.eligible.contains((1,0))) and not(s.eligible.contains((1,1)))).then(openA(1).fail())",
        "ReplayAlteredCashRequestTest": chain("init.expect(sequenceSafe)", signed(1)) + ".then(requestCash(1,{...desc(1),nonce:99}).fail())",
        "ExactRequestWrappersTest": chain("init.expect(sequenceSafe)", [*signed(1), "requestExactOpen(1)", "requestExactCash(1)"]) +
            ".expect(pending(1))",
    }
    operations = (
        ("Finalize", 0, "finalize(4,5)"),
        ("Finalize", 1, "finalize(5,2)"),
        ("Submit", 2, "applyB(4)"),
        ("Prove", 3, "prove(4,3)"),
        ("Deliver", 4, "deliver(4,3)"),
    )
    for role, actor, action in operations:
        cases[f"{role}DownActor{actor}Test"] = chain("waitingCash", [f"crash({actor})"]) + f".then({action}.fail())"
        cases[f"{role}RecoveredActor{actor}Test"] = chain("waitingCash", [f"crash({actor})", f"recover({actor})", action])
    cases.update(schedule_cases())
    cases.update(health_cases())
    cases.update(binding_cases())
    cases.update(proof_fault_cases())
    header = WORKLOAD.read_text().rstrip()
    if not header.endswith("}"):
        raise ValueError("Repeated workload module must end with a module close")
    header = header[:-1].replace("module repeated {", "module repeated_test {", 1)
    header += dispatcher() + literals
    header += "".join(f"  run {name} = {expression}\n" for name, expression in prefix.items())
    return header, cases


def batches():
    header, cases = generated_tests()
    entries = list(cases.items())
    result = {}
    for offset in range(0, len(entries), BATCH_SIZE):
        name = f"repeated-directed-{offset // BATCH_SIZE + 1:02d}"
        group = entries[offset:offset+BATCH_SIZE]
        module = header + "".join(f"  run {test} = {expression}\n" for test, expression in group) + "}\n"
        result[name] = (module.encode(), tuple(test for test, _ in group))
    return result


def sources():
    return {
        CORE: specialize((MODELS / CORE).read_text()).encode(),
        "economic_effects.qnt": (MODELS / "economic_effects.qnt").read_bytes(),
        "guarantee_oracles.qnt": (MODELS / "guarantee_oracles.qnt").read_bytes(),
    }


LEGACY_SPEND = b"""module spend_review {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  run LegacyOfflineSpendTest = init.then(crash(1)).expect(not(s.up.contains(1)) and s.ownerB==3)
    .then(spend(1)).expect(safe and not(s.up.contains(1)) and s.ownerB==2 and s.spentB==1)
}
"""


def legacy_spend():
    directory = RUNTIME.parent / "legacy-spend"
    directory.mkdir(parents=True, exist_ok=True)
    (directory / "spend_review.qnt").write_bytes(LEGACY_SPEND)
    for filename in (CORE, "economic_effects.qnt"):
        (directory / filename).write_bytes((MODELS / filename).read_bytes())
    rel = str((directory / "spend_review.qnt").relative_to(ROOT))
    return execute("repeated-review-legacy-spend", [QUINT, "test", rel, "--main", "spend_review",
                   "--backend", "typescript", "--seed", "41", "--match", "^LegacyOfflineSpendTest$"],
                   claim="Original adversarial abstraction permits ordinary spending with the local ledger down")


def stage(directory, closure):
    directory.mkdir(parents=True, exist_ok=True)
    for name, content in closure.items():
        (directory / name).write_bytes(content)


def run_batch(name, data):
    directory = RUNTIME / name
    stage(directory, {**sources(), "repeated_test.qnt": data})
    path = str((directory / "repeated_test.qnt").relative_to(ROOT))
    return execute(
        name, [QUINT, "test", path, "--main", "repeated_test", "--backend", "rust", "--seed", "41", "--match", ".*Test"],
        claim="Source-bound repeated settlement and fault scenarios",
        config={"trades": 7, "funded_pairs": 5, "deadlines": list(DEADLINES)}, seconds=600,
    )


def check(mode, selected):
    if mode == "legacy":
        return [legacy_spend()]
    if mode == "sample":
        stage(RUNTIME, {**sources(), "repeated.qnt": WORKLOAD.read_bytes()})
        path = str((RUNTIME / "repeated.qnt").relative_to(ROOT))
        # With a fixed seed the evaluator uses one worker. Parallelize the
        # same-sized campaign over deterministic seeds, with per-process caps.
        with ThreadPoolExecutor(max_workers=5) as workers:
            jobs = [workers.submit(qrun, f"repeated-sample-{seed}", path, "repeated", inv="sequenceSafe",
                                  samples=1000, steps=150, seed=seed, step="operational", seconds=900)
                    for seed in range(41, 51)]
            return [job.result() for job in jobs]
    chosen = batches()
    if selected and not set(selected).issubset(chosen):
        raise ValueError("Unknown repeated-workload batch")
    with ThreadPoolExecutor(max_workers=2) as workers:
        pending = [workers.submit(run_batch, name, data) for name, (data, _) in chosen.items()
                   if not selected or name in selected]
        return [job.result() for job in pending]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("directed", "sample", "legacy"))
    parser.add_argument("batches", nargs="*")
    args = parser.parse_args()
    raise SystemExit(not all(receipt["expectation_met"] for receipt in check(args.mode, args.batches)))

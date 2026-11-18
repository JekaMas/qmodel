"""Reconcile declared reference actions and behavior with exact model receipts."""
import json
import re

from evidence import ROOT
from guarantee_audit import exact, named_quint, option, require
from repeated_checks import ACTORS, CORE, DEADLINES, LEGACY_SPEND, MODELS, RUNTIME, WORKLOAD, batches, sources

# Explicit routes are independent of the generator's event enum. Each value
# names an actual passing test or the retained evidence for a guarded-out action.
DIRECT = {
    "init": "SequentialCommitAbortCommitTest",
    "sign": "ExactRequestWrappersTest",
    "requestOpen": "ExactRequestWrappersTest",
    "requestCash": "ExactRequestWrappersTest",
    "openA": "ParallelReservationsTest",
    "prepareB": "ParallelReservationsTest",
    "tick": "SequentialCommitAbortCommitTest",
    "finalize": "Phase2ProofPipelineRecoveryTest",
    "capture": "Phase2ProofPipelineRecoveryTest",
    "prove": "Phase2ProofPipelineRecoveryTest",
    "deliver": "Phase2ProofPipelineRecoveryTest",
    "lose": "LostOutcomeCannotBeLearnedTest",
    "resend": "RecoveryAfterDropPruneAndRestartTest",
    "prune": "RecoveryAfterDropPruneAndRestartTest",
    "proveUnadmitted": "UnadmittedProofCannotDecideTest",
    "deliverUnadmitted": "UnadmittedProofCannotApplyTest",
    "inject": "Phase2Binding0Test",
    "commit": "SequentialCommitAbortCommitTest",
    "abort": "SequentialCommitAbortCommitTest",
    "learn": "SequentialCommitAbortCommitTest",
    "applyB": "SequentialCommitAbortCommitTest",
    "refund": "LateAbortStillReleasesInParallelTest",
    "spend": "IndependentSpendingRecoversTest",
    "crash": "RecoveryAfterDropPruneAndRestartTest",
    "recover": "RecoveryAfterDropPruneAndRestartTest",
    "observe": "SequentialCommitAbortCommitTest",
    "reconcile": "SequentialCommitAbortCommitTest",
    "captureAbortRecord": "ContenderTombstoneHasNoRefundsTest",
    "recordAbort": "ContenderTombstoneHasNoRefundsTest",
    "rotate": "UnfreezeAndExitDoesNotRevokePendingTest",
    "exitMember": "UnfreezeAndExitDoesNotRevokePendingTest",
    "revoke": "RevokeBothCannotOpenTest",
    "revokeLeg": "RevokedLegCannotPrepareTest",
    "freeze": "BFrozenCannotApplyTest",
    "unfreeze": "UnfreezeAndExitDoesNotRevokePendingTest",
    "receiveNote": "UnfreezeAndExitDoesNotRevokePendingTest",
    "compromiseTransport": "UnfreezeAndExitDoesNotRevokePendingTest",
    "idle": "UnfreezeAndExitDoesNotRevokePendingTest",
}
PLACEMENT = {
    "registerDecision": ("qa-admission-b", "canonicalAcceptTest"),
    "applyA": ("qa-scenarios-b_path_test", "settlementTest"),
}
MUTANT = {"unsafeRefund": "qa-legacy-expiry", "forgetTerminal": "qa-legacy-pruned_tombstone"}
DISPATCHERS = {"tradeStep", "step", "adversarialStep"}


def log(receipt):
    return (ROOT / receipt["raw_output"]).read_text()


def source_identity(directory, receipt, closure, local):
    require(set(receipt["input_hashes"]) == {str(local / name) for name in closure}, "Incorrect workload source closure")
    for name, data in closure.items():
        require((directory / "inputs" / local / name).read_bytes() == data, f"Stale or replaced workload input: {name}")


def coverage():
    config = json.loads((ROOT / "verification/configs/repeated-acceptance.json").read_text())
    current_sources = sources()
    expected_batches = batches()
    require(set(config["directed"]) == set(expected_batches), "Incomplete directed batch selection")
    witnessed = {}
    expected_profile = {"trades": 7, "funded_pairs": 5, "deadlines": list(DEADLINES)}
    for batch, (model, tests) in expected_batches.items():
        directory, directed = exact(config["directed"][batch])
        source_identity(directory, directed, {**current_sources, "repeated_test.qnt": model},
                        (RUNTIME / batch).relative_to(ROOT))
        named_quint(log(directed), tests)
        require(directed["configuration"] == expected_profile, "Wrong funded workload")
        require(not set(tests).intersection(witnessed), "Duplicate directed test selection")
        witnessed.update({name: directed["id"] for name in tests})
    names = tuple(witnessed)
    bindings = {f"Phase{p}Binding{b}Test" for p in range(7) for b in range(11)}
    pipeline = {f"Phase{p}{role}OutageTest" for p in range(7) for role in ("Finalize", "Capture", "Prove", "Deliver", "Resend")}
    pipeline |= {f"Phase{p}ProofPipelineRecoveryTest" for p in range(7)}
    health = {f"Outage{''.join(str(a) for a in ACTORS if m & (1 << a))}RecoveryTest" for m in range(1, 32)}
    schedules = {name for name in names if re.fullmatch(r"(?:(?:Commit|Apply)[456]){6}Test", name)}
    for name in schedules:
        events = re.findall(r"(?:Commit|Apply)[456]", name)
        require(len(set(events)) == 6 and all(events.index(f"Commit{t}") < events.index(f"Apply{t}") for t in (4,5,6)),
                f"Invalid claimed terminal order: {name}")
    require(len(schedules) == 90 and (bindings | pipeline | health).issubset(names), "Missing quantified directed scenarios")

    sampled = config["sampled"]
    require(set(sampled) == set(map(str, range(41, 51))), "Missing operational seed")
    for seed, run in sampled.items():
        directory, sample = exact(run)
        source_identity(directory, sample, {**current_sources, "repeated.qnt": WORKLOAD.read_bytes()}, RUNTIME.relative_to(ROOT))
        require(sample["backend"] == "simulation" and option(sample, "--invariant") == "sequenceSafe" and
                option(sample, "--step") == "operational" and option(sample, "--max-samples") == "1000" and
                option(sample, "--max-steps") == "150" and option(sample, "--seed") == seed,
                "Wrong operational sampling scope")
    directory, old = exact(config["legacy_discriminator"])
    prefix = directory / "inputs/verification/results/runtime/legacy-spend"
    require((prefix / CORE).read_bytes() == (MODELS / CORE).read_bytes() and
            (prefix / "spend_review.qnt").read_bytes() == LEGACY_SPEND, "Wrong pre-repair source")
    named_quint(log(old), ("LegacyOfflineSpendTest",))

    declared = set(re.findall(r"^\s*action\s+(\w+)", (MODELS / CORE).read_text(), re.M))
    grouped = (DIRECT, PLACEMENT, MUTANT, DISPATCHERS)
    require(set().union(*grouped) == declared and sum(map(len, grouped)) == len(declared), "Unclassified or duplicated reference action")
    rows = {}
    for action, witness in DIRECT.items():
        require(witness in names, f"No executed {action} witness")
        rows[action] = {"kind": "directed", "receipt": witnessed[witness], "test": witness}
    for action, (run_id, witness) in PLACEMENT.items():
        require(run_id in config["retained_placement"], f"Missing placement route for {action}")
        _, receipt = exact(run_id)
        require(f"ok {witness} passed 1 test(s)" in log(receipt), f"Missing placement test for {action}")
        rows[action] = {"kind": "placement", "receipt": run_id, "test": witness}
    for action, run_id in MUTANT.items():
        require(run_id in config["retained_mutants"], f"Missing mutant route for {action}")
        _, receipt = exact(run_id)
        require(receipt["expected"] == "counterexample" and
                any(step.startswith(action + "(") for step in receipt["configuration"]["schedule"]),
                f"No witnessed mutant action {action}")
        rows[action] = {"kind": "isolated mutant", "receipt": run_id}
    for run_id in config["retained_placement"] + config["retained_mutants"]:
        exact(run_id)
    for action in DISPATCHERS:
        rows[action] = {"kind": "dispatcher", "receipts": list(sampled.values())}

    separate = {}
    for domain, runs in config["separate_fault_models"].items():
        witnesses = []
        for run in runs:
            _, receipt = exact(run)
            witnesses.append({"receipt": run, "outcome": receipt["outcome"], "claim": receipt["claim"]})
        require(witnesses, f"Empty separate fault model coverage: {domain}")
        separate[domain] = witnesses

    return {
        "directed_receipts": list(config["directed"].values()), "sample_receipts": list(sampled.values()),
        "sampled_traces": 1000 * len(sampled), "sampled_max_steps": 150,
        "legacy_discriminator": old["id"], "directed_tests": len(names),
        "legal_orders": len(schedules), "nonempty_outage_subsets": len(health),
        "phase_binding_rejections": len(bindings), "proof_pipeline_fault_recovery": len(pipeline),
        "reference_action_count": len(rows), "reference_actions": dict(sorted(rows.items())),
        "separate_fault_models": separate,
    }


if __name__ == "__main__":
    print(json.dumps(coverage(), indent=2))

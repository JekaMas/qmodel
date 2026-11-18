"""Audit exact strengthened assurance and the transfer of the L04 endpoint."""
import json
import re

from audit_evidence import EvidenceError, ROOT, validate
from evidence import digest, inputs
from guarantee_checks import SOURCE
from guarantee_scenarios import CONTROL_CASES, control_sources
from policy_checks import NEGATIVES, POLICY, RUNTIME as POLICY_RUNTIME, control_sources as policy_sources

# Keep the exact previous success IDs, including the successful N2 attempt.
REFERENCE = {
    "reference": ("qa-full-one", True),
    "b": ("qa-variant-live_b", True),
    "d": ("qa-variant-live_d", True),
    "shared": ("qa-variant-shared_execution", False),
    "open": ("qa-variant-live_open", True),
    "escrow": ("qa-variant-live_escrow", True),
    "private": ("qa-variant-private_asset", False),
    "recovery": ("qa-full-recovery", True),
    "two": ("qa-full-two-attempt1", True),
}
COMBINED = (
    "UnadmittedOutcomeAfterRotationTest", "FrozenCashApplicationTest", "DuplicateCashApplicationTest",
    "RotationExitFreezeAndReplayTest", "OldEpochCannotSignAnotherTradeTest", "RetiredMemberCannotSignAnotherTradeTest",
    "BlockedLocalCommitTest", "LocalCommitRetryTest", "DurableBookingAfterCacheResetTest",
)
CONTROLS = {
    "wrong-phase": ("WrongPhaseOutcomeTest",),
    "missing-application": ("MissingApplicationEvidenceTest", "PrematureDurableRowAfterResetTest"),
    "omitted-local": ("OmittedLocalDeliveryTest",),
}
SQLITE = (
    "test_restore_stale_snapshot_and_replay",
    "test_reject_partial_wrong_phase_and_wrong_economic_effect",
    "test_competing_replay_and_conflicting_descriptor",
)
ENDPOINT = "(s.trades.get(t).decision>=2).leadsTo(s.trades.get(t).booked==1ands.trades.get(t).report>=2)"


def require(condition, error):
    if not condition:
        raise EvidenceError(error)


def exact(run_id):
    path = ROOT / "verification/results/runs" / run_id / "receipt.json"
    receipt = json.loads(path.read_text())
    validate(receipt, path)
    require(receipt["id"] == run_id, "Receipt is not the exact selected invocation")
    return path.parent, receipt


def option(receipt, flag, default=None):
    command = receipt["command"]
    return command[command.index(flag) + 1] if flag in command else default


def source_module(directory, receipt):
    path = directory / "inputs" / receipt["command"][2]
    name = option(receipt, "--main")
    module = re.search(rf"^module {name}\s*\{{(.*?)(?=^module |\Z)", path.read_text(), re.M | re.S)
    require(module is not None, f"Selected module {name} missing")
    return module[1]


def canonical_line(value):
    return re.sub(r"\s+", "", value)


def graph(profile, run):
    legacy_id, temporal = REFERENCE[profile]
    old_dir, old = exact(legacy_id)
    new_dir, new = exact(run)
    old_code, new_code = source_module(old_dir, old), source_module(new_dir, new)
    for model in ("dvp", "economic_effects"):
        rel = f"verification/models/{model}.qnt"
        require(new["input_hashes"][rel] == old["input_hashes"][rel], f"{profile}: changed transition input {rel}")
    require(new["input_hashes"] == inputs(new["command"]), f"{profile}: changed live guarantee input")
    configs = [re.findall(r'import dvp\(.*?\)\.\* from "\./dvp"', source) for source in (old_code, new_code)]
    require(len(configs[0]) == 1 and configs[0] == configs[1], f"{profile}: different instantiated ledger")
    require(option(old, "--init") == option(new, "--init") == "init", f"{profile}: changed init")
    expected_step = "recoveryStep" if profile == "recovery" else "step"
    require(option(old, "--step") == option(new, "--step") == expected_step, f"{profile}: changed transition entry")
    for flag in ("--constraint", "--state-constraint", "--action-constraint"):
        require(flag not in new["command"] and flag not in old["command"], f"{profile}: constrained graph")
    for directory, receipt in ((old_dir, old), (new_dir, new)):
        settings = json.loads((directory / "inputs" / option(receipt, "--tlc-config")).read_text())
        require(set(settings) == {"maxHeap", "stackSize", "workers"}, f"{profile}: unexpected TLC graph settings")
    if profile == "recovery":
        actions = [re.findall(r"action recoveryStep.*", source) for source in (old_code, new_code)]
        require(len(actions[0]) == 1 and actions[0] == actions[1], "changed recovery edges")
    require(new["backend"] == old["backend"] == "tlc", f"{profile}: unexhausted model checker")
    require(option(new, "--invariant") == "guarantees" and new["command"][2] == SOURCE, f"{profile}: different assertion")
    require("valguarantees=Trades.forall(t=>tradeGuarantees(s,desc(t)))" in canonical_line(new_code),
            f"{profile}: missing quantified guarantee check")
    require(new["distinct_states"] == old["distinct_states"], f"{profile}: unexpected reachable graph size")
    if temporal:
        formula = "recoveryProgress" if profile == "recovery" else "L04"
        old_normal = canonical_line(old_code)
        definition = re.search(rf"^\s*temporal {formula}\s*=(.*?)(?=^\s*temporal |^}})", old_code, re.M | re.S)
        require(definition is not None and ENDPOINT in canonical_line(definition[1]), f"{profile}: previous temporal predicate lacks the endpoint")
        if profile != "recovery":
            require("temporalprogress=L01andL02andL03andL04" in old_normal, f"{profile}: progress omits L04")
        require(option(old, "--temporal") == ("recoveryProgress" if profile == "recovery" else "progress"),
                f"{profile}: previous receipt did not select the stated temporal formula")
    return {"receipt": new["id"], "same_graph_as": legacy_id, "states": new["distinct_states"],
            "strengthens_l04": temporal}


def named_quint(log, tests):
    require(tuple(re.findall(r"^\s+ok (\w+) passed 1 test\(s\)$", log, re.M)) == tests, "Incorrect directed-test selection")
    require(f"{len(tests)} passing" in log, "Missing directed test verdict")


def match_archive():
    archive = ROOT / "verification/reviews/guarantee-assurance/evidence"
    retained = json.loads((archive / "results.json").read_text())
    for record in retained["observations"]:
        raw = archive / record["raw_output"]
        require(digest(raw) == record["raw_sha256"] and record["observed"] and record["exit_code"] == 0,
                f"Original discriminator changed: {record['case']}")
        if record["mutation"] is None:
            for name in ("dvp.qnt", "economic_effects.qnt"):
                require(digest(ROOT / "verification/models" / name) == record["input_sha256"][name],
                        "Original unmutated review guard no longer matches the actual source")


def policy_history(config):
    require(set(config) == {"baseline", *NEGATIVES}, "Incomplete policy-history checks")
    for case, run in config.items():
        directory, receipt = exact(run)
        require(receipt["backend"] == "tlc" and option(receipt, "--main") == "policy_history",
                "Wrong authority-history observation")
        require(option(receipt, "--init") == "initial" and option(receipt, "--step") == "observedStep",
                "Wrong authority-history transition")
        if case == "baseline":
            require(receipt["command"][2] == POLICY and receipt["expected"] == "pass" and
                    option(receipt, "--invariant") == "historySound" and
                    receipt["input_hashes"] == inputs(receipt["command"]), "Wrong policy-history baseline")
        else:
            require(option(receipt, "--invariant") == NEGATIVES[case] and receipt["expected"] == "counterexample",
                    "Missing actual prior-state violation")
            captured = directory / "inputs" / (POLICY_RUNTIME / case).relative_to(ROOT)
            require(all((captured / name).read_bytes() == data for name, data in policy_sources(case).items()),
                    "Isolated policy example differs from configured control")
    return config


def audit_guarantees():
    config = json.loads((ROOT / "verification/configs/guarantee-acceptance.json").read_text())
    require(config["schema_version"] == 1 and set(config["graphs"]) == set(REFERENCE), "Incomplete finite-profile selection")
    graphs = {profile: graph(profile, run) for profile, run in config["graphs"].items()}

    match_archive()
    require(set(config["controls"]) == set(CONTROLS) == set(CONTROL_CASES), "Incomplete falsification selection")
    for case, run in config["controls"].items():
        directory, receipt = exact(run)
        named_quint((ROOT / receipt["raw_output"]).read_text(), CONTROLS[case])
        require(receipt["configuration"] == {"isolated_control": case}, "Wrong control profile")
        captured = directory / "inputs" / ("verification/results/runtime/guarantee-controls/" + case)
        sources = control_sources(case)
        require({str((captured / name).relative_to(directory / "inputs")) for name in sources} == set(receipt["input_hashes"]),
                "Incomplete isolated input closure")
        require(all((captured / name).read_bytes() == data for name, data in sources.items()), "Isolated control source changed")

    directed = config["directed"]
    for name in ("quint", "sqlite"):
        _, receipt = exact(directed[name])
        require(receipt["input_hashes"] == inputs(receipt["command"]), f"{name}: changed directed-test input")
        raw = (ROOT / receipt["raw_output"]).read_text()
        if name == "quint":
            named_quint(raw, COMBINED)
        else:
            require(set(re.findall(r"^(test_\w+) .* \.\.\. ok$", raw, re.M)) == set(SQLITE), "Incorrect SQLite test selection")
            require("Ran 3 tests" in raw and "\nOK" in raw and raw.startswith("SQLite "), "Missing SQLite execution result")
    sampled = config["sampled"]
    _, receipt = exact(sampled)
    require(receipt["backend"] == "simulation" and receipt["input_hashes"] == inputs(receipt["command"]) and
            option(receipt, "--main") == "guarantee_two" and option(receipt, "--invariant") == "guarantees" and
            option(receipt, "--step") == "adversarialStep" and option(receipt, "--max-samples") == "10000" and
            option(receipt, "--max-steps") == "100" and option(receipt, "--seed") == "17", "Wrong sampled configuration")
    return {"graphs": graphs, "directed": directed, "controls": config["controls"],
            "sampled": sampled, "history": policy_history(config["history"])}


if __name__ == "__main__":
    print(json.dumps(audit_guarantees(), indent=2))

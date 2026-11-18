"""Check prior-state policy/terminal assertions and two isolated controls."""
import argparse

from evidence import QUINT, ROOT, execute

MODELS = ROOT / "verification/models"
RUNTIME = ROOT / "verification/results/runtime/policy-history"
POLICY = "verification/models/policy_history.qnt"
NEGATIVES = {"missing-eligibility": "policyAtAdmission", "reopen": "immutableOutcome"}


def control_sources(case):
    observer = (ROOT / POLICY).read_text()
    reference = (MODELS / "dvp.qnt").read_text()
    if case == "missing-eligibility":
        guard = "s.admitted,s.eligible.contains((t,1)),not(s.frozen.contains(1))"
        if reference.count(guard) != 1:
            raise ValueError("The B preparation policy no longer matches the control anchor")
        reference = reference.replace(guard, "s.admitted,not(s.frozen.contains(1))", 1)
    elif case == "reopen":
        observer = observer.replace("MUTANT=0", "MUTANT=4", 1)
    else:
        raise ValueError(f"Unknown prior-state control: {case}")
    return {
        "dvp.qnt": reference.encode(),
        "policy_history.qnt": observer.encode(),
        "economic_effects.qnt": (MODELS / "economic_effects.qnt").read_bytes(),
    }


def check(case):
    if case == "baseline":
        path, invariant = POLICY, "historySound"
    else:
        directory = RUNTIME / case
        directory.mkdir(parents=True, exist_ok=True)
        for name, data in control_sources(case).items():
            (directory / name).write_bytes(data)
        path = str((directory / "policy_history.qnt").relative_to(ROOT))
        invariant = NEGATIVES[case]
    return execute(
        "guarantees-history" + ("" if case == "baseline" else "-" + case),
        [QUINT, "verify", path, "--main", "policy_history", "--backend", "tlc", "--init", "initial",
         "--step", "observedStep", "--invariant", invariant, "--verbosity", "3", "--tlc-config",
         "verification/configs/extended-tlc.json"],
        claim=("Independent prior-state policy and decision assertions on the A-hosted preparation/decision spine"
               if case == "baseline" else invariant), backend="tlc", seconds=600,
        expected="pass" if case == "baseline" else "counterexample",
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases", nargs="+", choices=("baseline", *NEGATIVES))
    args = parser.parse_args()
    results = [check(case) for case in args.cases]
    raise SystemExit(not all(result["expectation_met"] for result in results))

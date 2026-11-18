"""Check exact source, target and observations for ordered local blocks."""
import json
import re

from block_checks import CASES, CHECKER, MAIN, RUNTIME, source
from evidence import ROOT, digest
from guarantee_audit import named_quint, option, require, source_module
from three_audit import bound, log, verify_native

INDEX = ROOT / "verification/configs/block-acceptance.json"


def audit_blocks():
    config = json.loads(INDEX.read_text())
    selected = config["receipts"]
    require(config["schema_version"] == 1 and set(selected) == set(CASES), "Incomplete block receipt selection")
    details = {}
    positive, negative = [], []
    for name, profile in CASES.items():
        run = selected[name]
        expected_id = f"funded-blocks-{name}"
        require(run == expected_id or re.fullmatch(re.escape(expected_id) + r"-attempt[1-9]\d*", run),
                f"Unexpected selection for {name}")
        folder = RUNTIME / name
        receipt = bound(run, folder, source(profile))
        module_file = str((folder / "funded_blocks.qnt").relative_to(ROOT))
        require(receipt["configuration"] == profile.config() and receipt["command"][2] == module_file
                and option(receipt, "--main") == MAIN, f"Wrong configuration for {run}")
        entry = {"receipt": run}
        if profile.directed:
            directory = ROOT / "verification/results/runs" / run
            require(receipt["backend"] == "cli" and receipt["command"][1] == "test"
                    and option(receipt, "--match") == ".*Test" and option(receipt, "--seed") == "71"
                    and option(receipt, "--backend") == "rust", "Wrong directed block workload")
            names = tuple(re.findall(r"^\s*run (\w+Test)\s*=", source_module(directory, receipt), re.M))
            require(bool(names), "No block tests selected")
            named_quint(log(receipt), names)
            entry["tests"] = list(names)
        else:
            verdict, progress = ("finite_model_verified", "includedProgress") if profile.expected == "pass" else (
                "expected_counterexample_found", None,
            )
            verify_native(receipt, MAIN, "blockInit", "blockStep", "sound", verdict, progress)
            require(option(receipt, "--tlc-config") == CHECKER and receipt["input_hashes"][CHECKER] == digest(ROOT / CHECKER)
                    and not any(flag in receipt["command"] for flag in ("--constraint", "--action-constraint", "--max-steps")),
                    f"Wrong checker configuration for {run}")
            if progress:
                require("Finished checking temporal properties" in log(receipt), f"Missing temporal result for {run}")
            entry.update(outcome=verdict, distinct_states=receipt["distinct_states"], temporal=progress)
        (positive if profile.expected == "pass" else negative).append(run)
        details[name] = entry
    return {"positive": positive, "negative": negative, "profiles": details}


if __name__ == "__main__":
    from release_evidence import family_report
    print(json.dumps(family_report(__file__, ('block-', 'bilateral-')), indent=2))

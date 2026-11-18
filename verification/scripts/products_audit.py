"""Reconcile the seven protocol products with their exact native observations."""
import json
import re

import products_authority as authority
import products_clocks as clocks
import products_contract as contract
import products_hostile as jobs
import products_interleavings as interleavings
import products_placement as placement
import products_population as population
import products_privacy as privacy
import products_refinement as refinement
from evidence import ROOT, digest
from guarantee_audit import exact, named_quint, option, require, source_module
from three_audit import bound, log, verify_native

CONFIG = ROOT / "verification/configs/products-acceptance.json"


def audit_products():
    config = json.loads(CONFIG.read_text())
    require(config["schema_version"] == 1, "Unexpected proof product inventory format")
    selected = config["receipts"]
    layers = {}
    classified = {"positive": [], "negative": [], "witnesses": []}
    validated = set()

    def observe(base, profile, main=None, source=None, entry=None, context=None):
        receipt_id = selected[base]
        require(base not in validated and (receipt_id == base or re.fullmatch(re.escape(base) + r"-attempt[1-9]\d*", receipt_id)),
                f"Wrong or duplicate selected execution for {base}")
        validated.add(base)
        directory, receipt = (
            exact(receipt_id) if source is None else
            (ROOT / "verification/results/runs" / receipt_id, bound(receipt_id, jobs.RUNTIME / base, source))
        )
        require(receipt["configuration"] == (context or {}), f"Wrong declared configuration for {base}")
        file = entry if source is None else str((jobs.RUNTIME / base / entry).relative_to(ROOT))
        require(receipt["command"][2] == file and option(receipt, "--main") == main, f"Wrong entry point for {base}")
        if source is None:
            require({key: value for key, value in receipt["input_hashes"].items() if key.endswith(".qnt")} == {file: digest(ROOT / file)}, f"Static source changed for {base}")
        classified[profile].append(receipt_id)
        return directory, receipt

    def native(base, main, init, step, predicate, source=None, entry=None, counterexample=False, temporal=None,
               context=None, extended=False):
        profile = "negative" if counterexample else "positive"
        directory, receipt = observe(base, profile, main, source, entry, context)
        verify_native(receipt, main, init, step, predicate,
                      "expected_counterexample_found" if counterexample else "finite_model_verified", temporal)
        settings = "verification/configs/" + ("extended-tlc.json" if extended else "tlc.json")
        qnt_paths = {p for p in receipt["input_hashes"] if p.endswith(".qnt")}
        require(set(receipt["input_hashes"]) == {*qnt_paths, settings}
                and option(receipt, "--tlc-config") == settings
                and receipt["input_hashes"][settings] == digest(ROOT / settings),
                f"Wrong exact checker profile for {base}")
        if not counterexample:
            require(not any(flag in receipt["command"] for flag in ("--constraint", "--state-constraint", "--action-constraint", "--max-steps")),
                    f"Unexpected checker restriction for {base}")
        return {"receipt": receipt["id"], "distinct_states": receipt["distinct_states"], "predicate": predicate,
                "temporal": temporal}

    def directed(base, main, source=None, entry=None, control=False, context=None):
        directory, receipt = observe(base, "witnesses" if control else "positive", main, source, entry, context)
        require(receipt["command"][1] == "test" and receipt["backend"] == "cli"
                and option(receipt, "--seed") == "71" and option(receipt, "--match") == ".*Test"
                and option(receipt, "--backend") == "rust", f"Wrong directed selection for {base}")
        tests = tuple(re.findall(r"^\s*run (\w+Test)\s*=", source_module(directory, receipt), re.M))
        require(bool(tests), f"No checks selected in {base}")
        named_quint(log(receipt), tests)
        return {"receipt": receipt["id"], "tests": list(tests)}

    def sampled(base, main, step, invariant, seed, samples, steps, source, entry, context=None):
        _, receipt = observe(base, "positive", main, source, entry, context)
        expected = {"--init": "init", "--step": step, "--invariant": invariant, "--seed": str(seed),
                    "--max-samples": str(samples), "--max-steps": str(steps), "--backend": "rust"}
        require(receipt["backend"] == "simulation" and receipt["outcome"] == "sampled_no_counterexample"
                and receipt["command"][1] == "run" and all(option(receipt, key) == value for key, value in expected.items()),
                f"Wrong simulation profile for {base}")
        return {"receipt": receipt["id"], "seed": seed, "samples": samples, "steps": steps}

    layers["causal_work"] = [
        native(base, "job_products", "jobInit", "jobStep", predicate, jobs.closure(mode), "jobs.qnt",
               expected == "counterexample", temporal,
               {"mode": mode, "service_ticks": 56, "junk_ids": 3, "one_proof_loss": True}, extended=True)
        for base, (mode, predicate, expected, temporal) in jobs.CASES.items()
    ] + [directed("products-jobs-directed", "job_products", jobs.closure(0, True), "jobs.qnt")]

    layers["independent_clocks"] = [
        native(base, "clock_products", "rateInit", "rateStep", predicate, clocks.closure(mode), "clocks.qnt",
               expected == "counterexample", context={"mode": mode, "elapsed": 3, "rates": [0, 1, 2],
                                                       "drift": [-1, 0, 1], "depth": 1}, extended=True)
        for base, (mode, predicate, expected) in clocks.CASES.items()
    ] + [directed("products-clocks-directed", "clock_products", clocks.closure(0, True), "clocks.qnt")]

    def exact_slice(base):
        main, context = interleavings.CASES[base]
        return native(base, main, "start", "step", "safe", interleavings.closure(base), f"{main}.qnt", context=context)

    layers["epoch_authority"] = [
        native(base, main, "init", "roundStep", predicate, entry=authority.SOURCE,
               counterexample=expected == "counterexample", context={"votes": "final", "rounds": 2, "threshold": 3})
        for base, (main, predicate, expected) in authority.CASES.items()
    ] + [
        directed(base, main, entry=authority.SOURCE, control=base.endswith("-controls"))
        for base, main in authority.TESTS.items()
    ] + [exact_slice("products-authority-migration")]

    layers["placement_effects"] = []
    for host, place in placement.PLACES.items():
        base = f"products-placement-{place}"
        context = {"host": host, "trades": 3}
        layers["placement_effects"].extend(
            directed(f"{base}-{mode}", "placement_products", placement.closure(host, mode), "placement.qnt",
                     control=mode == "mutant", context={**context, "mode": mode})
            for mode in ("directed", "mutant")
        )
        layers["placement_effects"].append(
            sampled(f"{base}-sample", "placement_products", "placementStep", "sequenceSafe", 71, 600, 120,
                    placement.closure(host, "sample"), "placement.qnt", context)
        )

    layers["contract_histories"] = [
        directed(base, "contract_products", contract.closure(mode), "history.qnt", control=mode != 0,
                 context={"mode": mode, "scope": "logical contract"})
        for base, mode in contract.RUNS.items()
    ]

    layers["paired_privacy"] = [
        directed(base, main, privacy.closure(), "privacy.qnt", control=base.endswith("-controls"))
        for base, main in privacy.TESTS.items()
    ] + [
        sampled(f"products-privacy-sample-{seed}", "products_privacy", "step", "safe", seed, 700, 60,
                privacy.closure(), "privacy.qnt", {"seed": seed, "samples": 700, "steps": 60})
        for seed in privacy.SAMPLES
    ] + [exact_slice("products-privacy-exact")]

    layers["parameterized_preservation"] = [
        directed(base, "placement_products", refinement.closure(host, size), "placement.qnt",
                 context={"host": host, "population": size})
        for base, (host, size) in refinement.RUNS.items()
    ]
    for mode in ("proof", "controls"):
        base = f"products-population-{mode}"
        receipt_id = selected[base]
        directory, receipt = exact(receipt_id)
        require(receipt_id == base, f"Unexpected symbolic invocation for {base}")
        obligations = str((jobs.RUNTIME / base / "obligations.json").relative_to(ROOT))
        require(receipt["command"][1:] == ["-B", population.RUNNER, obligations]
                and receipt["configuration"] == {"mode": mode, "population": "arbitrary positive integer"}
                and set(receipt["input_hashes"]) == {population.RUNNER, obligations}
                and receipt["input_hashes"][population.RUNNER] == digest(ROOT / population.RUNNER),
                f"Wrong symbolic proof scope for {base}")
        data = population.input_closure(mode)["obligations.json"]
        require((directory / "inputs" / obligations).read_bytes() == data, f"Changed symbolic obligations for {base}")
        expected = [(row["name"], row["expected"]) for row in json.loads(data)["obligations"]]
        raw = log(receipt)
        require(raw.startswith("Z3 version ") and re.findall(r"^([\w-]+): (un)?sat$", raw, re.M) ==
                [(name, "un" if verdict == "unsat" else "") for name, verdict in expected]
                and raw.count("(define-fun ") >= sum(verdict == "sat" for _, verdict in expected),
                f"Missing actual solver answers or SAT witnesses for {base}")
        validated.add(base)
        classified["positive" if mode == "proof" else "witnesses"].append(receipt_id)
        layers["parameterized_preservation"].append({"receipt": receipt_id, "obligations": dict(expected)})

    require(validated == set(selected), "Incomplete or unexpected proof product selection")
    return {**classified, "products": layers}


if __name__ == "__main__":
    print(json.dumps(audit_products(), indent=2))

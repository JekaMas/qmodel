"""Audit exact three-trade, race and certificate evidence and its proof scopes."""
import json
import re

from evidence import ROOT, inputs
from guarantee_audit import exact, named_quint, option, require
from three_attack_checks import batches as attack_batches
from three_checks import RUNTIME, WORKLOAD, source_closure
from three_deadline_checks import RUN as DEADLINE, cases as deadline_cases
from three_matrix_checks import batches as fault_batches
from three_recovery_checks import recovery_source, recovery_witness_source
from three_queue_checks import CASES as QUEUE_CASES, queue_source
from timed_three_checks import TIMED, test_source
from certificate_checks import CASES as CERTIFICATES, SOURCE as CERTIFICATE_MODEL
from linearization_checks import TEST as LINEARIZATION_TEST


def bound(run, folder, source):
    directory, receipt = exact(run)
    local = folder.relative_to(ROOT)
    # Native config supplied as an extra checker input is audited by exact().
    qnt_inputs = {path for path in receipt["input_hashes"] if path.endswith(".qnt")}
    require(qnt_inputs == {str(local/name) for name in source}, f"Wrong source closure for {run}")
    for name, data in source.items():
        require((directory/"inputs"/local/name).read_bytes() == data, f"Source changed for {run}/{name}")
    return receipt


def log(receipt):
    return (ROOT/receipt["raw_output"]).read_text()


def verify_native(receipt, main, init, step, invariant, verdict, temporal=None):
    require(receipt["backend"]=="tlc" and receipt["outcome"]==verdict and
            option(receipt,"--main")==main and option(receipt,"--init")==init and
            option(receipt,"--step")==step and option(receipt,"--invariant")==invariant and
            option(receipt,"--temporal")==temporal,
            "Unexpected native scope: " + receipt["id"])


def verify_batches(selection, expected, count):
    require(set(selection) == set(expected), "Missing or extra directed batch")
    all_tests = {}
    for group,(source,tests) in expected.items():
        receipt = bound(selection[group], RUNTIME/group, {
            **source_closure(3,timed=True),"timed_three_test.qnt":source,
        })
        named_quint(log(receipt),tests)
        require(set(all_tests).isdisjoint(tests), "A witness was counted twice")
        require(receipt["configuration"] == {"tests":list(tests)}, "Directed selection mismatch")
        all_tests.update({name:receipt["id"] for name in tests})
    require(len(all_tests)==count, "Incorrect directed test count")
    return all_tests


def audit_three():
    config = json.loads((ROOT/"verification/configs/three-acceptance.json").read_text())
    for key in ("decisions","timed"):
        require(set(config[key])=={"2","3"}, f"Missing capacity profile: {key}")
    decision_counts, directed = {}, {}
    for pairs in (2,3):
        profile = str(pairs)
        result = bound(config["decisions"][profile],RUNTIME/f"decisions-{pairs}",{
            **source_closure(pairs),"three.qnt":(WORKLOAD/"three.qnt").read_bytes(),
        })
        verify_native(result,"three","init","decisionStep","sound","finite_model_verified","decides")
        require(result["configuration"]["funded_pairs"]==pairs and result["configuration"]["trades"]==3, "Wrong funding")
        decision_counts[profile]=result["distinct_states"]

        source=test_source(pairs)
        runnable=tuple(re.findall(rb"^  run (\w+Test) =",source,re.M))
        receipt=bound(config["timed"][profile],RUNTIME/f"timed-{pairs}",{
            **source_closure(pairs,timed=True),"timed_three_test.qnt":source,
        })
        names=tuple(name.decode() for name in runnable)
        named_quint(log(receipt),names)
        require(len(names)==(2 if pairs==2 else 10), "Wrong main directed suite")
        directed.update({name:receipt["id"] for name in names})

    faults = verify_batches(config["fault_batches"],fault_batches(),50)
    attacks = verify_batches(config["attack_batches"],attack_batches(),85)
    deadline = verify_batches({DEADLINE:config["deadline"]},{DEADLINE:deadline_cases()},5)
    require(set(config["timed_samples"])=={"61","62","63"}, "Missing simulation seed")
    for seed,run in config["timed_samples"].items():
        receipt=bound(run,RUNTIME/"timed-samples",{
            **source_closure(3,timed=True),"timed_three.qnt":TIMED.read_bytes(),
        })
        require(receipt["outcome"]=="sampled_no_counterexample" and option(receipt,"--main")=="timed_three" and
                option(receipt,"--seed")==seed and option(receipt,"--max-samples")=="600" and
                option(receipt,"--max-steps")=="120" and option(receipt,"--init")=="start" and
                option(receipt,"--step")=="timedStep" and option(receipt,"--invariant")=="sequenceSafe",
                "Wrong bounded operational sample")

    retention=config["mixed_recovery"]
    require(set(retention)=={"progress","reachability"}, "Missing suffix proof or witness")
    recovery=bound(retention["progress"],RUNTIME/"mixed-recovery",{
        **source_closure(3,timed=True),"three_recovery.qnt":recovery_source(),
    })
    verify_native(recovery,"three_recovery","recoveryInit","recoveryStep","sequenceSafe",
                  "finite_model_verified","recoveryProgress")
    suffix_count=recovery["distinct_states"]
    reachable=bound(retention["reachability"],RUNTIME/"mixed-witness",{
        **source_closure(3,timed=True),"three_recovery.qnt":recovery_witness_source(),
    })
    named_quint(log(reachable),("MixedOutcomesReachableWithOutageTest",))

    require(set(config["byzantine"])==set(CERTIFICATES), "Missing Byzantine envelope case")
    quorum_count=None
    for key,run in config["byzantine"].items():
        main,predicate,expectation=CERTIFICATES[key]
        _,receipt=exact(run)
        verdict = "finite_model_verified" if expectation=="pass" else "expected_counterexample_found"
        verify_native(receipt,main,"init","step",predicate,verdict)
        require(receipt["command"][2]==CERTIFICATE_MODEL and receipt["input_hashes"]==inputs(receipt["command"]),
                "Certificate model input changed")
        if expectation=="pass":
            quorum_count=receipt["distinct_states"]

    require(set(config["queue"])==set(QUEUE_CASES), "Incomplete queue saturation controls")
    queue_count=None
    for key,run in config["queue"].items():
        protected,predicate,expectation=QUEUE_CASES[key]
        receipt=bound(run,RUNTIME/key,{
            **source_closure(3,timed=True),"three_queue.qnt":queue_source(protected),
        })
        verdict = "finite_model_verified" if expectation=="pass" else "expected_counterexample_found"
        verify_native(receipt,"three_queue","loadInit","loadStep",predicate,verdict)
        if expectation=="pass":
            queue_count=receipt["distinct_states"]

    retained = {
        stage:[{"receipt":run,"outcome":exact(run)[1]["outcome"]} for run in runs]
        for stage,runs in config["retained_stage_controls"].items()
    }
    require(len(retained)==4 and all(retained.values()), "Missing retained stage scopes")

    _,receipt=exact(config["linearization"])
    history_log=log(receipt)
    require(LINEARIZATION_TEST in receipt["command"] and receipt["input_hashes"]==inputs(receipt["command"]),
            "Changed linearization test source")
    require("Ran 3 tests" in history_log and re.search(r"^OK$",history_log,re.M) and
            all("HISTORY " + name in history_log for name in ("three_calls","lost_response")),
            "Missing SQLite histories")

    return {
        "positive": [*config["decisions"].values(),*config["timed"].values(),*config["fault_batches"].values(),
                     *config["attack_batches"].values(),*config["timed_samples"].values(),config["deadline"],
                     retention["progress"],config["byzantine"]["byzantine-envelope"],config["linearization"],config["queue"]["three-queue-protected"]],
        "negative": [*[config["byzantine"][key] for key in CERTIFICATES if CERTIFICATES[key][2]=="counterexample"],
                     config["queue"]["three-queue-unprotected"]],
        "witnesses": [retention["reachability"],config["queue"]["three-queue-reachable"]],
        "protected_queue_states":queue_count,"retained_stage_controls":retained,
        "decision_states":decision_counts,"mixed_recovery_states":suffix_count,"certificate_states":quorum_count,
        "timed_directed":directed,"timed_fault_matrix":faults,"attack_matrix":attacks,"exclusive_deadline":deadline,
        "sampled_traces":1800,"max_sample_steps":120,"sqlite_history_tests":3,
    }


if __name__=="__main__":
    print(json.dumps(audit_three(),indent=2))

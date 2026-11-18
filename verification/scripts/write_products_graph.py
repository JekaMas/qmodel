"""Prepare or seal the change-owned proof product evidence graph."""
import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CHANGE = "close-protocol-proof-products"
DIRECTORY = ROOT / "openspec/changes" / CHANGE
SOURCE = "verification/tests/test_proof_products.py"
CAPABILITY = "dvp-proof-products"
sys.path.insert(0,str(ROOT/".agents/workflow"))
from scripts.requirement_tests import parse_delta_specs

TITLES = {
    "DC": "Preserve progress and authority across protocol composition",
    "DO": "Verify contract histories and observation independently",
}
CASES = [
    ("DC","End-to-end work under hostile load","causal_work","hostile_controls","N3 capture/proof/delivery/application and durable service"),
    ("DC","Independent chain rates and evidence issuance","independent_clocks","clock_controls","Variable rates, finality, replacement and authority"),
    ("DC","Byzantine rounds and membership changes","epoch_authority","epoch_controls","Lock, predecessor, signed context and distinct corruption envelopes"),
    ("DC","Alternative placement and adversarial recovery","placement_effects","placement_controls","Actual B/D/shared local and remote effects under fault schedules"),
    ("DO","Invocation and storage recovery at logical contract boundaries","contract_histories","contract_controls","Canonical effect, adapter history and legal local response"),
    ("DO","Paired observable privacy under operational failures","paired_privacy","privacy_controls","Two worlds, complete observer history and key/policy changes"),
    ("DO","Population-independent hold preservation","parameterized_preservation","population_controls","Symbolic local transition induction and independent executable mapping"),
]
DEPS = [
    SOURCE, "verification/models/dvp.qnt", "verification/models/guarantee_oracles.qnt",
    "verification/models/privacy_pipeline.qnt","verification/tests/workloads/products/**",
    "verification/scripts/products*.py","verification/configs/products-acceptance.json",
    "verification/results/runs/products-*/**","verification/configs/proof-contracts.json",
    "verification/reports/proof-products-results.json", "verification/models/economic_effects.qnt",
    "verification/scripts/guarantee_audit.py", "verification/scripts/three_audit.py",
    "verification/scripts/three_checks.py", "verification/scripts/three_recovery_checks.py",
    "verification/scripts/repeated_checks.py", "verification/scripts/audit_evidence.py",
    "verification/scripts/evidence.py", "verification/tests/workloads/three*/**", "verification/tests/workloads/three*.qnt",
    "verification/configs/tlc.json", "verification/configs/extended-tlc.json",
]


def write(implemented):
    specs = parse_delta_specs(DIRECTORY)
    graph = {"schema_version":2,"change":CHANGE,"requirements":[],"properties":[],"cases":[],"commands":[]}
    for req,title in TITLES.items():
        graph["requirements"].append({"id":req,"capability":CAPABILITY,"title":title,
                                      "fingerprint":specs[CAPABILITY,title]["fingerprint"]})
    for i,(req,scenario,positive,negative,owner) in enumerate(CASES,1):
        prop=f"{req}.P{i}"
        spec=specs[CAPABILITY,TITLES[req]]
        graph["properties"].append({"id":prop,"requirement_id":req,"scenarios":[scenario],"statement":owner,
                                    "owner":owner,"oracle":"Actual observed primitive effects and independent authority or history.",
                                    "source_globs":DEPS})
        for polarity, name in (("positive",positive),("negative",negative)):
            case={
                "id":f"{req}.C{len(graph['cases'])+1}","property_id":prop,"polarity":polarity,"scenario":scenario,
                "scenario_fingerprint":spec["scenario_fingerprints"][scenario],
                "setup":"Use the authentic source, observed verdict and complete selected protocol envelope.",
                "observable":name.replace("_"," ").capitalize(),
                "red_expectation":"Required native check is absent or disagrees with the expected protocol authority and effect.",
                "green_expectation":"The observed result and exact input establish the named scoped behavior.",
                "invalidation_dependencies":DEPS,
                "test_id":f"unittest::verification.tests.test_proof_products.ProofProducts.test_{name}",
                "source_path":SOURCE,"command_id":"proof-products","state":"implemented" if implemented else "planned",
                "distinct_reason":owner + (" positive witness" if polarity=="positive" else " independent fault control"),
                "substitution":{"classification":"NO_TEST_DOUBLE"},
            }
            if implemented:
                case.update(source_path=SOURCE,source_sha256=hashlib.sha256((ROOT/SOURCE).read_bytes()).hexdigest())
            graph["cases"].append(case)
    graph["commands"]=[{"id":"proof-products","runner":"python-unittest",
                        "argv":["python3","-B","-m","unittest","-v","verification.tests.test_proof_products"],
                        "cwd":".","timeout_seconds":60,"authority":"local"}]
    (DIRECTORY/"verification.json").write_text(json.dumps(graph,indent=2)+"\n")
    scope={"property_ids":[row["id"] for row in graph["properties"]],"test_ids":[row["test_id"] for row in graph["cases"]]}
    exact_owners=[("verification/models/dvp.qnt","reusable_unchanged","Actual reservation, decision, transfer and source proof actions"),
                  ("verification/models/privacy_pipeline.qnt","reusable_unchanged","Actual two-world transition and response construction"),
                  ("verification/scripts/three_checks.py","test_proof","Source-bound timing, capacity and identity precedent")]
    search={"schema_version":1,"change":CHANGE,"scope":scope,"reviews":[{"id":"D1",**scope,
        "question":"Resolve every original open product to real model actors and evidence boundaries.",
        "searches":[{"kind":"exact","status":"completed","query":"Read the seven named open products and their currently selected transition and observer owners.",
            "outcome":"Identified known source links, profile choices and separate authority abstractions.",
            "results":[{"path":p,"line":1,"classification":c,"reason":r} for p,c,r in exact_owners]},
            {"kind":"semantic","status":"not_applicable","query":"Find unknown implementation owners",
             "outcome":"All open model owners were supplied by the previous concrete plan.",
             "reason":"The user narrowed work to logical protocol actions and named model ownership.","results":[]},
            {"kind":"jetbrains-index","status":"not_applicable","query":"Locate compiled production API references",
             "outcome":"The operation stays at the executable protocol level.",
             "reason":"Quint and protocol-native evidence own this result.","results":[]}],
        "disposition":"current_change","rationale":"Every originally open product has a success witness and independent discriminator."}]}
    (DIRECTORY/"discovery.json").write_text(json.dumps(search,indent=2)+"\n")


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--implemented",action="store_true")
    write(parser.parse_args().implemented)

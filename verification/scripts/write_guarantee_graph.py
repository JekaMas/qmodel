"""Write the change-owned requirement/evidence map."""
import json
import sys

from evidence import ROOT, digest

sys.path.insert(0, str(ROOT / ".agents/workflow"))
from scripts.requirement_tests import parse_delta_specs

CHANGE = "strengthen-dvp-guarantees"
CAPABILITY = "dvp-guarantee-assurance"
DIRECTORY = ROOT / "openspec/changes" / CHANGE
AUDIT = "verification/tests/test_guarantee_evidence.py"
ADAPTER = "verification/tests/test_assurance_booking.py"
REQUIREMENTS = [
    ("GA1", "Check local outcomes and durable completion independently"),
    ("GA2", "Exercise recovery combinations and persistence"),
]
SPECS = parse_delta_specs(DIRECTORY)
# Each scenario has its own owned assurance obligation with a distinct
# positive execution and a falsification or rejected transition.
SCENARIOS = [
    ("GA1", "Outcome authority for local and remote legs", "The actual outcome authorizes exactly the matching application.",
     "test_authentic_outcomes_across_placements", "test_both_wrong_phase_and_omitted_local_delivery_are_observable",
     "Placed and remote effects match the decision on nine exhaustively checked graphs.",
     "The held-only cash payout after ABORT and the omitted local transfer violate the new assertion."),
    ("GA1", "Evidenced COMMIT report and retained financial row", "The COMMIT projection and L04 endpoint preserve an exact evidenced result.",
     "test_eventual_endpoint_uses_original_graph_and_fairness", "test_premature_row_and_reset_cache_are_distinguished",
     "The previous progress formula entails an evidenced booking using its same checked graphs and fairness.",
     "A missing application proof and a premature row surviving cache loss each violate the independent assertion."),
    ("GA1", "Admission and outcome history", "The actual prior transaction determines admission and terminal immutability.",
     "test_prior_state_history_checks_reachable_admission_and_decision", "test_unchecked_eligibility_and_terminal_reopen_violate_history",
     "The observation covers every reachable state of the A-hosted named preparation and decision spine.",
     "The eligibility-omission and tombstone-reopen producers each have a native counterexample."),
    ("GA2", "Pending obligations survive governance and intervention", "An accepted trade can complete under recorded recovery conditions.",
     "test_executed_pending_trade_retry_and_recovery", "test_unadmitted_and_duplicate_actions_are_rejected",
     "Old authorized settlement survives rotation, exit, freeze, proof retry, and cache loss.",
     "The same prefixes deny unsupported proof programs, new old-epoch signing, unresolved freezes and duplicate payment."),
    ("GA2", "Restore and replay financial records", "Exact evidence determines the durable SQLite row.",
     "test_restore_stale_snapshot_and_replay", "test_reject_partial_wrong_phase_and_wrong_economic_effect",
     "A restored old physical database file rebuilds one durable row from both retained application results.",
     "Partial, wrong-phase and differently bound events create no completed row."),
]

SUBSTITUTION = {
    "classification": "EXTERNAL_BOUNDARY",
    "owner_replaced": "Finalized chain application evidence authentication and retention upstream of SQLite.",
    "forbidden_claims": ["Cryptographic verifier/circuit correctness.", "Actual ledger or banking transaction conformance."],
    "allowed_proof": "Binding, actual restore and durable idempotency at the SQLite projection.",
}
DEPS = [
    "verification/models/**", "verification/configs/guarantee-acceptance.json",
    "verification/configs/proof-contracts.json", "verification/results/runs/guarantees-*/**",
    "verification/scripts/guarantee_*.py", "verification/scripts/policy_checks.py",
    "verification/reviews/guarantee-assurance/**", "verification/tests/guarantee_combined_test.qnt",
]
REQUIREMENT_ROWS = [
    {"id": identity, "title": title, "capability": CAPABILITY, "fingerprint": SPECS[CAPABILITY, title]["fingerprint"]}
    for identity, title in REQUIREMENTS
]
cases, properties = [], []
for n, (requirement, scenario, statement, positive, negative, passed, rejected) in enumerate(SCENARIOS, 1):
    adapter = n == 5
    source = ADAPTER if adapter else AUDIT
    module = "verification.tests.test_assurance_booking.BookingConformance" if adapter else "verification.tests.test_guarantee_evidence.GuaranteeEvidence"
    owned_paths = [source, "verification/adapters/booking.py"] if adapter else [source, *DEPS]
    property_id = f"{requirement}.P{n}"
    properties.append({
        "id": property_id, "requirement_id": requirement, "scenarios": [scenario],
        "statement": statement, "owner": "SQLite COMMIT projection" if adapter else "Quint assurance suite",
        "oracle": f"{passed} {rejected}", "source_globs": owned_paths,
    })
    title = dict(REQUIREMENTS)[requirement]
    targets = [("positive", positive, passed), ("negative", negative, rejected)]
    if adapter:
        targets.append(("negative", "test_competing_replay_and_conflicting_descriptor",
                        "Concurrent matching inserts produce one row; a different descriptor for the same decision slot is rejected."))
    for polarity, test, observable in targets:
        cases.append({
            "id": f"{requirement}.C{len(cases)+1}", "property_id": property_id, "polarity": polarity,
            "scenario": scenario, "scenario_fingerprint": SPECS[CAPABILITY, title]["scenario_fingerprints"][scenario],
            "setup": "Use an actual on-disk SQLite database with upstream evidence fixtures." if adapter
                     else "Load exact native verdicts, named scenarios and captured input closure selected by the assurance contract.",
            "observable": observable,
            "red_expectation": "The purported execution is missing, bound to different inputs, or reports a contradictory result.",
            "green_expectation": "The executed owner produces the exact named witness under the scenario's input and oracle.",
            "invalidation_dependencies": owned_paths, "test_id": f"unittest::{module}.{test}",
            "command_id": "sqlite-booking" if adapter else "guarantee-audit", "state": "implemented",
            "source_path": source, "source_sha256": digest(ROOT / source),
            "distinct_reason": observable, "substitution": SUBSTITUTION if adapter else {"classification": "NO_TEST_DOUBLE"},
        })

commands = [
    {"id": identity, "runner": "python-unittest", "argv": ["python3", "-B", "-m", "unittest", "-v", module],
     "cwd": ".", "timeout_seconds": 60, "authority": "local"}
    for identity, module in [
        ("guarantee-audit", "verification.tests.test_guarantee_evidence"),
        ("sqlite-booking", "verification.tests.test_assurance_booking"),
    ]
]
graph = {"schema_version": 2, "change": CHANGE, "requirements": REQUIREMENT_ROWS,
         "properties": properties, "cases": cases, "commands": commands}
(DIRECTORY / "verification.json").write_text(json.dumps(graph, indent=2) + "\n")
scope = {"property_ids": [row["id"] for row in properties], "test_ids": [row["test_id"] for row in cases]}
discovery = {
    "schema_version": 1, "change": CHANGE, "scope": scope,
    "reviews": [{"id": "GA.D1", **scope,
                 "question": "Trace all reviewed assurance gaps to their executable owners and retained receipts.",
                 "searches": [
                     {"kind": "exact", "status": "completed",
                      "query": "Read the protocol requirements, findings, named producer actions, placement proofs, L04 endpoint and original replay inputs.",
                      "outcome": "Identified the historical-only assertions, derived finance flags, local authorization and exact evidence boundary.",
                      "results": [
                          {"path": "verification/models/dvp.qnt", "line": 223, "classification": "reusable_unchanged",
                           "reason": "Owns actual terminal learning; the implementation guard remains in the retained original model."},
                          {"path": "verification/models/guarantee_oracles.qnt", "line": 1, "classification": "test_proof",
                           "reason": "Owns independent outcome, co-located effect and record assertions."},
                          {"path": "verification/models/policy_history.qnt", "line": 1, "classification": "test_proof",
                           "reason": "Observes actual prior-state admission and immutable outcome."},
                          {"path": "verification/adapters/booking.py", "line": 1, "classification": "change_candidate",
                           "reason": "Owns the implemented persistence boundary."},
                      ]},
                     {"kind": "semantic", "status": "not_applicable", "query": "Unfamiliar existing implementation ownership",
                      "outcome": "The review identified exact model symbols. No prior production adapter exists.",
                      "reason": "All modified or verified owners were known from explicit review and task references.", "results": []},
                     {"kind": "jetbrains-index", "status": "not_applicable", "query": "Existing deployed APIs/IDE reference ownership",
                      "outcome": "No production or IDE verification claim.",
                      "reason": "Named Quint checkers and actual local SQLite own the verified boundaries.", "results": []},
                 ], "disposition": "current_change",
                 "rationale": "Retain original execution evidence and add the checked assertions and persistence proof."}],
}
(DIRECTORY / "discovery.json").write_text(json.dumps(discovery, indent=2) + "\n")

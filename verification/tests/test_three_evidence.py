"""Acceptance of the exact three-trade proof, fault and history selection."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/"scripts"))
from three_audit import exact, log
from release_evidence import release_report


class ThreeTradeEvidence(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.evidence = release_report("three_audit.py")

    def test_native_three_trade_enumeration_and_full_funding_witness(self):
        self.assertEqual(self.evidence["decision_states"],{"2":18849,"3":33216})
        self.assertIn("ThreeConcurrentHoldsTest",self.evidence["timed_directed"])

    def test_contended_reserves_and_foreign_proofs_rejected(self):
        for test in ("ThirdSecurityReservationDeniedTest","ThirdCashReservationDeniedTest","RealForeignProofRejectedTest"):
            self.assertIn(test,self.evidence["timed_directed"])

    def test_combined_faults_and_evidenced_recovery(self):
        self.assertIn("OverlapCrashPartitionMaliceAndRecoveryTest",self.evidence["timed_directed"])
        self.assertGreater(self.evidence["mixed_recovery_states"],0)
        _, witness = exact(self.evidence["witnesses"][0])
        self.assertIn("ok MixedOutcomesReachableWithOutageTest passed",log(witness))

    def test_duration_timeout_replay_and_route_negative_matrix(self):
        self.assertEqual(len(self.evidence["timed_fault_matrix"]),50)
        self.assertEqual(len(self.evidence["attack_matrix"]),85)
        self.assertEqual(self.evidence["sampled_traces"],1800)
        self.assertIn("DeadlineAndProofRaceTest",self.evidence["timed_directed"])
        for boundary in ("CommitBeforeDeadlineAppliesLocalEffectTest","CommitAtDeadlineFailsWhileOpenTest",
                         "AbortAtDeadlineHasNoDeliveryTest","CommitAfterDeadlineFailsWhileOpenTest"):
            self.assertIn(boundary,self.evidence["exclusive_deadline"])
        for phase in range(7):
            self.assertIn(f"Phase{phase}PartitionBlocksDeliveryTest",self.evidence["timed_fault_matrix"])
            self.assertIn(f"Phase{phase}PartitionHealsAtBoundTest",self.evidence["timed_fault_matrix"])

    def test_saturated_application_lane_meets_service_bound(self):
        self.assertGreater(self.evidence["protected_queue_states"],0)
        _, witness = exact(self.evidence["witnesses"][1])
        self.assertEqual(witness["claim"],"neverSaturatedAndComplete")

    def test_unprotected_lane_misses_service_bound(self):
        ids=[run for run in self.evidence["negative"] if run.startswith("three-queue-unprotected")]
        self.assertEqual(len(ids),1)
        self.assertEqual(exact(ids[0])[1]["claim"],"withinTwoServiceTicks")

    def test_actual_concurrent_linearization_histories(self):
        self.assertEqual(self.evidence["sqlite_history_tests"],3)
        _, recorded = exact("three-booking-linearization")
        self.assertIn("test_three_concurrent_invocations_linearize_with_live_reads",log(recorded))
        self.assertIn("HISTORY lost_response",log(recorded))

    def test_early_response_conflict_and_local_order_controls(self):
        _, recorded = exact("three-booking-linearization")
        self.assertIn("test_early_ack_and_conflicting_success_fail_history_check",log(recorded))
        for test in ("RevokeBeforeReserveTest","ReserveBeforeRevokeTest","SubmitterStopBeforeCommitTest",
                     "CommitBeforeSubmitterStopTest","ObserveBeforeApplicationTest"):
            self.assertIn(test,self.evidence["timed_fault_matrix"])

    def test_native_byzantine_quorum_envelope(self):
        self.assertEqual(self.evidence["certificate_states"],60480)

    def test_overthreshold_equivocation_and_context_failure(self):
        certificates = [exact(run)[1] for run in self.evidence["negative"] if run.startswith("byzantine-")]
        self.assertEqual({receipt["claim"] for receipt in certificates},{"unique","boundContext"})
        self.assertTrue(all(receipt["outcome"]=="expected_counterexample_found" for receipt in certificates))

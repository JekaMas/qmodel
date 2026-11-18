"""Check that the scoped guarantees have distinct, exact execution witnesses."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from guarantee_audit import ROOT, audit_guarantees, exact


class GuaranteeEvidence(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.assurance = audit_guarantees()

    def test_authentic_outcomes_across_placements(self):
        graphs = self.assurance["graphs"]
        self.assertEqual({name for name in graphs if graphs[name]["states"] > 0},
                         {"reference", "two", "recovery", "b", "d", "shared", "open", "escrow", "private"})

    def test_both_wrong_phase_and_omitted_local_delivery_are_observable(self):
        for name, marker in (("wrong-phase", "WrongPhaseOutcomeTest"), ("omitted-local", "OmittedLocalDeliveryTest")):
            with self.subTest(name=name):
                self.assertIn(f"ok {marker} passed", self.log(self.assurance["controls"][name]))

    def test_eventual_endpoint_uses_original_graph_and_fairness(self):
        self.assertEqual({name for name, proof in self.assurance["graphs"].items() if proof["strengthens_l04"]},
                         {"reference", "two", "recovery", "b", "d", "open", "escrow"})
        self.assertEqual(self.assurance["graphs"]["two"]["states"], 684268)
        self.assertEqual(self.assurance["graphs"]["recovery"]["states"], 125632)

    def test_premature_row_and_reset_cache_are_distinguished(self):
        log = self.log(self.assurance["controls"]["missing-application"])
        self.assertIn("ok MissingApplicationEvidenceTest passed", log)
        self.assertIn("ok PrematureDurableRowAfterResetTest passed", log)

    def test_prior_state_history_checks_reachable_admission_and_decision(self):
        _, history = exact(self.assurance["history"]["baseline"])
        self.assertGreater(history["distinct_states"], 100)
        self.assertEqual(history["outcome"], "finite_model_verified")

    def test_unchecked_eligibility_and_terminal_reopen_violate_history(self):
        for case in ("missing-eligibility", "reopen"):
            with self.subTest(case=case):
                _, failed = exact(self.assurance["history"][case])
                self.assertEqual(failed["outcome"], "expected_counterexample_found")

    def test_executed_pending_trade_retry_and_recovery(self):
        log = self.log(self.assurance["directed"]["quint"])
        for name in ("RotationExitFreezeAndReplayTest", "LocalCommitRetryTest", "DurableBookingAfterCacheResetTest"):
            self.assertIn(f"ok {name} passed", log)

    def test_unadmitted_and_duplicate_actions_are_rejected(self):
        log = self.log(self.assurance["directed"]["quint"])
        denied = (
            "UnadmittedOutcomeAfterRotationTest", "FrozenCashApplicationTest",
            "DuplicateCashApplicationTest", "OldEpochCannotSignAnotherTradeTest",
            "RetiredMemberCannotSignAnotherTradeTest", "BlockedLocalCommitTest",
        )
        for name in denied:
            self.assertIn(f"ok {name} passed", log)

    @staticmethod
    def log(run_id):
        _, receipt = exact(run_id)
        return (ROOT / receipt["raw_output"]).read_text()

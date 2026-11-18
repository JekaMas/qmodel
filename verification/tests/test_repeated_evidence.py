"""Check the executed repeated-workload coverage against the declared model."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from repeated_audit import coverage, exact, log


class RepeatedEvidence(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.report = coverage()
        cls.directed_logs = "\n".join(log(exact(run)[1]) for run in cls.report["directed_receipts"])

    def passed(self, *tests):
        for test in tests:
            self.assertIn(f"ok {test} passed 1 test(s)", self.directed_logs)

    def test_repeated_exchange_and_all_causal_parallel_orders(self):
        self.passed("SequentialCommitAbortCommitTest", "ParallelReservationsTest", "LateAbortStillReleasesInParallelTest")
        self.assertEqual(self.report["legal_orders"], 90)

    def test_competing_reservations_and_spends_cannot_exceed_funding(self):
        self.passed("ContendedATest", "ContendedBTest", "ReservedSecuritiesCannotBeSpentTest",
                    "ReservedCashCannotBeSpentTest", "ContenderTombstoneHasNoRefundsTest")

    def test_retained_evidence_can_rebuild_rows(self):
        self.passed("RecoveryAfterDropPruneAndRestartTest")
        self.assertEqual(self.report["proof_pipeline_fault_recovery"], 42)

    def test_cross_trade_and_malformed_evidence_cannot_apply(self):
        self.passed("OldPreparationCannotCommitNewTradeTest", "OldOutcomeCannotApplyNewTradeTest",
                    "OldApplicationCannotBookAnotherTradeTest", "DuplicateCashCannotApplyAgainTest",
                    "UnadmittedProofCannotDecideTest", "UnadmittedProofCannotApplyTest")
        self.assertEqual(self.report["phase_binding_rejections"], 77)

    def test_all_reference_events_routed_and_recovery_subsets_execute(self):
        self.assertEqual(self.report["nonempty_outage_subsets"], 31)
        self.assertEqual(self.report["reference_action_count"], 45)
        self.assertEqual(self.report["reference_actions"]["applyA"]["kind"], "placement")
        self.assertEqual(self.report["reference_actions"]["forgetTerminal"]["kind"], "isolated mutant")
        self.assertEqual(self.report["sampled_traces"], 10000)
        for run in self.report["sample_receipts"]:
            self.assertEqual(exact(run)[1]["outcome"], "sampled_no_counterexample")

    def test_offline_spending_discriminator_and_repaired_profile(self):
        _, previous = exact(self.report["legacy_discriminator"])
        self.assertIn("ok LegacyOfflineSpendTest passed", log(previous))
        self.passed("CashCannotSpendWhileBOfflineTest", "SecuritiesCannotSpendWhileAOfflineTest",
                    "IndependentSpendingRecoversTest")

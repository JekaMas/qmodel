"""OpenSpec observations for physically routed native settlement."""
import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "verification/scripts"))
from admission_checks import INDEX, cases, observation


class RoutedSettlement(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.checks = {c.name: c for c in cases() if c.name.startswith(("routes-", "test-routed_"))}
        cls.selected = json.loads(INDEX.read_text())

    def graph(self, name, *, negative=False):
        case = self.checks["routes-" + name]
        result = observation(case, self.selected[case.name])
        self.assertEqual(result["outcome"], "expected_counterexample_found" if negative else "finite_model_verified")
        self.assertEqual(case.command[case.command.index("--invariant") + 1], "backed" if negative else "safety")
        if name == "recovery":
            self.assertEqual(case.command[case.command.index("--temporal") + 1], "recoveryProgress")
        if not negative:
            self.assertGreater(result["states"], 1)

    def named(self, *names, module="routed_settlement_test"):
        case = self.checks["test-" + module]
        self.assertEqual(observation(case, self.selected[case.name])["tests"], len(case.tests))
        self.assertTrue(set(names) <= set(case.tests), names)

    def test_cross_sequences(self):
        self.named("ForwardThenReverseTest", "ReverseThenForwardTest")
        self.named("PhysicalXHostTest", "PhysicalYHostTest", module="routed_cross_reference_test")
        self.graph("cross")

    def test_remote_halt(self):
        self.named("ForwardHaltRecoveryTest", "ReverseHaltRecoveryTest")
        self.named("HaltedCashCannotApplyTest", "HaltedHostCannotDecideTest")
        self.graph("recovery")

    def test_local_on_each_ledger(self):
        self.named("LocalXThenYTest", "LocalYThenXTest", "ParallelLocalBothTest")
        self.named("BothAssetsOnXTest", "BothAssetsOnYTest", module="routed_local_reference_test")

    def test_local_shortfall(self):
        self.named("SecurityShortfallTest", "CashShortfallTest")
        self.graph("half-local", negative=True)

    def test_parallel_hosts(self):
        self.named("ParallelCrossTest", "FourOverlappingTest", "SameDirectionConcurrentTest")
        self.named("ParallelReverseDeliveryTest", "SimultaneousOppositePaymentsTest", "SameReverseConcurrentTest")
        for cross_route in ("Forward", "Reverse"):
            for local_route in ("LocalX", "LocalY"):
                self.named(cross_route + "Then" + local_route + "Test", local_route + "Then" + cross_route + "Test")
        self.graph("four")

    def test_conflicting_funds(self):
        self.named("CrossWinsSecurityTest", "LocalWinsSecurityTest", "CrossWinsCashTest", "LocalWinsCashTest")
        self.named("ReverseCrossWinsSecurityTest", "ReverseLocalWinsSecurityTest",
                   "ReverseCrossWinsCashTest", "ReverseLocalWinsCashTest", "SameHostMustOrderTest",
                   "SameCashLedgerOrdersPaymentsTest", "OnlyOneCashProofTest")
        self.graph("scarce")
        self.graph("scarce-reverse")

    def test_abort_isolation(self):
        self.named("OppositeAbortAndCommitTest", "LateCashHoldRefundTest")

    def test_confused_proof(self):
        self.named("OppositePrepareRejectedTest", "SiblingPrepareRejectedTest", "SiblingCommitRejectedTest",
                   "WrongGenesisRejectedTest", "WrongPhaseRejectedTest", "DuplicatePaymentRejectedTest",
                   "SiblingAbortRejectedTest", "DuplicateReleaseRejectedTest")
        self.graph("foreign-proof", negative=True)

"""OpenSpec evidence for parallel reservations, deadline and held settlement."""
import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "verification/scripts"))
from release_evidence import release_report


class FundedBlocks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        report = release_report("block_audit.py")
        if report != json.loads((ROOT / "verification/reports/funded-blocks.json").read_text()):
            raise AssertionError("Block report differs from selected native evidence")
        cls.profiles = report["profiles"]
        cls.directed = set(cls.profiles["directed"]["tests"])

    def test_funded_reservations(self):
        self.assertEqual(self.profiles["full"]["temporal"], "includedProgress")
        self.assertTrue({"OlderReservationConsumesOnlyItsOwnCapacityTest", "IndependentHeightsTest"}
                        <= self.directed)

    def test_early_seal(self):
        self.assertEqual(self.profiles["early-seal"]["outcome"], "expected_counterexample_found")

    def test_local_shortage(self):
        for name in ("short-a", "short-b"):
            self.assertEqual(self.profiles[name]["outcome"], "finite_model_verified")
            self.assertEqual(self.profiles[name]["temporal"], "includedProgress")
        self.assertIn("ShortfallAfterOrdinarySpendIsLocalTest", self.directed)

    def test_stale_balance(self):
        for name in ("overbook-a", "overbook-b"):
            self.assertEqual(self.profiles[name]["outcome"], "expected_counterexample_found")
        self.assertIn("DuplicateRequestCannotTakeTwoSlotsTest", self.directed)

    def test_commit_and_apply(self):
        self.assertEqual(self.profiles["full"]["outcome"], "finite_model_verified")
        self.assertTrue({"FullyFundedTradesAllBookTest", "OlderSealedEvidenceCanProgressDuringAnotherBlockTest"}
                        <= self.directed)

    def test_charge_and_deadline(self):
        self.assertEqual(self.profiles["double-charge"]["outcome"], "expected_counterexample_found")
        self.assertTrue({"NoHeightBumpBetweenCommitsTest", "CannotCommitOnDeadlineTest",
                         "EarlySourcePublicationIsDisabledTest"} <= self.directed)

"""OpenSpec evidence scenarios for the seven scoped protocol proof products."""
import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "verification/scripts"))
from products_audit import audit_products


class ProofProducts(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        observed = audit_products()
        report = ROOT / "verification/reports/proof-products-results.json"
        if observed != json.loads(report.read_text()):
            raise AssertionError("Published result differs from the exact native evidence")
        cls.products = observed["products"]
        cls.checked = set(observed["positive"])
        cls.controls = set(observed["negative"]) | set(observed["witnesses"])

    def product_cases(self, group, key, *, controls=False):
        eligible = self.controls if controls else self.checked
        return [r[key] for r in self.products[group] if key in r and r["receipt"] in eligible]

    def test_causal_work(self):
        self.assertEqual(self.product_cases("causal_work", "temporal"), ["jobProgress"])
        self.assertIn("SaturatedOutageAndRetryTest", self.product_cases("causal_work", "tests")[0])
        self.assertIn("PendingJobsStayBackedWithoutServiceTest", self.product_cases("causal_work", "tests")[0])

    def test_hostile_controls(self):
        self.assertCountEqual(self.product_cases("causal_work", "predicate", controls=True),
                              ["serviceBound", "serviceBound", "readySurvives"])

    def test_independent_clocks(self):
        self.assertEqual(self.product_cases("independent_clocks", "predicate"), ["clockSafety"])
        cases = self.product_cases("independent_clocks", "tests")[0]
        self.assertIn("LaggingHeadCannotIssueEvenWithTimeAndBFastTest", cases)
        self.assertIn("IncludedReplacementWaitsForCanonicalDepthTest", cases)

    def test_clock_controls(self):
        self.assertCountEqual(self.product_cases("independent_clocks", "predicate", controls=True),
                              ["replacementBound", "canonicalConfirmation", "noInvalidEarlyRefund"])

    def test_epoch_authority(self):
        self.assertCountEqual(self.product_cases("epoch_authority", "predicate"), ["authoritySafe", "safe"])
        cases = self.product_cases("epoch_authority", "tests")[0]
        self.assertIn("OldHistoryAndNewEpochShareCheckpointTest", cases)
        self.assertIn("RetiredSignaturesCannotAuthorizeNewWorkTest", cases)

    def test_epoch_controls(self):
        self.assertEqual(self.product_cases("epoch_authority", "predicate", controls=True),
                         ["sameHeightAgreement", "sameHeightAgreement"])
        self.assertCountEqual(self.product_cases("epoch_authority", "tests", controls=True)[0], [
            "UncertifiedConfigurationBreaksLineageTest", "StaleVerifierAcceptsRetiredAuthorityTest",
            "SignedRootWithoutExecutedBodyIsDetectedTest", "BadRestoreBreaksRecoveredCheckpointTest",
        ])

    def test_placement_effects(self):
        cases = self.product_cases("placement_effects", "tests")
        self.assertEqual(len(cases), 3)
        for scope in cases:
            self.assertIn("FundedMixedRecoveryTest", scope)
            self.assertIn("OneLegEvidenceCannotBookTest", scope)
        self.assertEqual(sum(self.product_cases("placement_effects", "samples")), 1800)

    def test_placement_controls(self):
        self.assertCountEqual([case for scope in self.product_cases("placement_effects", "tests", controls=True)
                               for case in scope], ["OmittedLocalCashIsVisibleTest", "OmittedLocalCashIsVisibleTest",
                                                   "AbortProofCannotAuthorizeCashMutantTest"])

    def test_contract_histories(self):
        cases = self.product_cases("contract_histories", "tests")[0]
        self.assertIn("CommitAndRetryHaveAValidIndependentHistoryTest", cases)
        self.assertIn("AbortAndRefundAreSeparateLinearizationPointsTest", cases)
        self.assertIn("OlderBackupCannotAnswerAsCurrentTest", cases)
        self.assertTrue({"FrozenCommitCannotLinearizeTest", "FrozenCommitCannotConfirmTest",
                         "FrozenCommitCannotRespondTest", "UnfreezeRetryHasOneCanonicalEffectTest"} <= set(cases))

    def test_contract_controls(self):
        self.assertCountEqual([case for scope in self.product_cases("contract_histories", "tests", controls=True)
                               for case in scope], [
            "PrematureResponseViolatesLegalHistoryTest", "MissingCommitEffectBreaksSourceComparisonTest",
            "ForgedRestoredCacheCannotCreateAuthorityTest", "DuplicateActualCashEffectBreaksHistoryTest",
        ])

    def test_paired_privacy(self):
        self.assertEqual(self.product_cases("paired_privacy", "predicate"), ["safe"])
        self.assertCountEqual(self.product_cases("paired_privacy", "tests")[0],
                              ["BatchOutageBackupAndRoleChangeTest", "NonEntitledBatchScopeTest"])
        self.assertEqual(sum(self.product_cases("paired_privacy", "samples")), 2100)

    def test_privacy_controls(self):
        self.assertCountEqual(self.product_cases("paired_privacy", "tests", controls=True)[0], [
            "BackupSizeLeakTest", "RoutingLeakTest", "TimingLeakTest", "CachedRevokedScopeLeakTest",
            "LostKeyFalseUsabilityTest",
        ])

    def test_parameterized_preservation(self):
        obligations = self.product_cases("parameterized_preservation", "obligations")[0]
        self.assertEqual(len(obligations), 19)
        self.assertEqual(set(obligations.values()), {"unsat"})
        operations = self.product_cases("parameterized_preservation", "tests")
        self.assertEqual(len(operations), 5)
        self.assertEqual(sum("ExpandedPopulationIdentityTest" in scope for scope in operations), 1)

    def test_population_controls(self):
        self.assertEqual(self.product_cases("parameterized_preservation", "obligations", controls=True)[0], {
            "missing-available-capacity": "sat", "duplicate-consumption": "sat",
            "missing-remote-preparation-authority": "sat", "legacy-symbolic-root-alias": "sat",
        })


if __name__ == "__main__":
    unittest.main()

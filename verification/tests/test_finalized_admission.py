"""Requirement cases bound to native observations of the current protocol."""
import json
from itertools import permutations
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "verification/scripts"))
from admission_checks import INDEX, cases, observation


class FinalizedAdmission(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.definitions = {c.name: c for c in cases()}
        cls.selected = json.loads(INDEX.read_text())
        cls.checked = {}

    def check(self, key):
        if key not in self.checked:
            self.checked[key] = observation(self.definitions[key], self.selected[key])
        return self.checked[key]

    def named(self, key, *names):
        case = self.definitions[key]
        self.assertEqual(self.check(key)["tests"], len(case.tests))
        self.assertTrue(set(names).issubset(case.tests), names)

    def native(self, key, predicate, temporal=None, *, counterexample=False):
        case = self.definitions[key]
        self.assertEqual(case.command[case.command.index("--invariant")+1], predicate)
        self.assertEqual(self.check(key)["outcome"],
                         "expected_counterexample_found" if counterexample else "finite_model_verified")
        if temporal:
            self.assertEqual(case.command[case.command.index("--temporal")+1], temporal)

    def test_retained_or_renewed_instruction(self):
        self.named("test-admission_review_test", "HistoricAFirstSettlesTest", "HistoricBFirstSettlesTest",
                   "HistoricExitKeepsPriorObligationTest", "RenewedTermsSettleTest", "ProvisionalOnlyCleansUpTest")
        self.native("epoch-cut", "priorFinality")
        self.native("cutover", "safety", "governedProgress")

    def test_provisional_holds_and_stale_signatures(self):
        self.named("test-admission_review_test", "StaleCashFirstTest", "StaleSecurityFirstTest",
                   "BothProvisionalCannotMintAuthorityTest", "LocalFinalityIsNotRemoteDeliveryTest")
        self.native("obsolete-admission", "priorFinality", counterexample=True)
        self.native("cutover-early", "noLateFirst", counterexample=True)
        self.native("unproved-finalization", "newFinalsAuthenticated", counterexample=True)
        self.native("policy-control-missing-eligibility", "policyAtAdmission", counterexample=True)
        self.native("policy-control-reopen", "immutableOutcome", counterexample=True)

    def test_confirmed_inclusion(self):
        self.native("clocks-safe", "clockSafety")
        self.named("clock-directed", "IncludedReplacementWaitsForCanonicalDepthTest",
                   "SubmissionAfterABlockMustWaitForAnotherTest", "AuthoritativeSpendabilityWaitsForConfirmationTest")
        self.named("test-registration_d_test", "DecisionDomainOwnsOpenTest")

    def test_halted_chain_and_replacement(self):
        self.native("clocks-no-block", "inclusionBacked", counterexample=True)
        self.named("clock-directed", "NewRequestAfterStallWaitsForABlockTest",
                   "ReplacementMakesOldSubmissionIneligibleTest")
        self.named("test-admission_review_test", "OfflineSpendRefusedTest")

    def test_complete_verified_cursor(self):
        self.native("report-cursor", "safe")
        self.named("test-report_cursor_test", "LatestSurvivesHistoricalReadTest")
        self.named("history-0", "NewFinalizedWriteInvalidatesCurrentViewTest", "SameInvocationReturnsOnceTest")
        self.named("test-consumer_inbox_test", "BankRestoreAndRedeliveryBookOnceTest")

    def test_obsolete_and_incomplete_responses(self):
        self.native("rewound-cursor", "exactCursor", counterexample=True)
        self.named("history-5", "OldFreshFlagDisagreesWithConfirmedPrefixTest")
        self.named("history-0", "OlderBackupCannotAnswerAsCurrentTest", "UnconfirmedApplicationCannotRespondTest")
        self.named("test-consumer_inbox_test", "ReporterOnlyCannotReleaseCashTest", "CashDeliveryDoesNotInformBankTest")

    def test_historical_and_current_authority(self):
        self.named("test-consumer_inbox_test", "DifferentCursorsConvergeAfterCertifiedHandoffTest")
        self.native("migration", "safe")
        self.named("test-products_epoch_test", "OldHistoryAndNewEpochShareCheckpointTest",
                   "UnseenOldRoundIsHistoricalOnlyTest")

    def test_unseen_retired_certificate(self):
        self.native("retired-authority", "acceptedAtCurrentEpoch", counterexample=True)
        self.named("test-products_epoch_mutant_test", "StaleVerifierAcceptsRetiredAuthorityTest")

    def test_honest_committee_remote_delivery(self):
        self.native("committee", "safe", "committeeProgress")
        self.named("test-committee_test", "honestThresholdWitnessTest")

    def test_unbacked_committee_decision(self):
        self.native("committee-unbacked", "backed", counterexample=True)

    def test_all_order_pairs_and_bookings(self):
        orders = ["".join(order) for order in permutations("123")]
        all_pairs = {f"Bilateral{a}_{b}Test" for a in orders for b in orders}
        self.named("bilateral-orders", *all_pairs)
        self.assertEqual(set(self.definitions["bilateral-orders"].tests), all_pairs)
        self.assertEqual(self.check("bilateral-orders")["tests"], 36)

    def test_oversubscription_and_duplicate_debit(self):
        self.named("bilateral-recovery", "LateApplicationAfterShortFundedOutageTest",
                   "LatePreparationAfterShortFundedOutageTest")
        for key in ("block-overbook-a", "block-overbook-b", "block-double-charge"):
            self.native(key, "sound", counterexample=True)

    def test_restored_cash_and_production_gate(self):
        self.named("test-bank_finality_test", "RestoredLedgerPaysReservedAmountOnceTest")
        decision = json.loads((ROOT/"verification/configs/bank-finality.json").read_text())
        self.assertEqual(decision["decision_host_for_poc"], "A")
        self.assertEqual(decision["bank_confirmations"], [])
        self.assertEqual(decision["production_acceptance"], "pending_both_banks")

    def test_halted_cash_and_common_execution(self):
        self.named("test-bank_finality_test", "FinalCommitWithHaltedCashLedgerTest")
        self.named("test-shared_test", "atomicExecutionTest")
        decision = json.loads((ROOT/"verification/configs/bank-finality.json").read_text())
        self.assertEqual(decision["if_only_a_final_credit_on_B_is_payment"],
                         "require_common_atomic_execution_or_proven_equivalent")


if __name__ == "__main__":
    unittest.main()

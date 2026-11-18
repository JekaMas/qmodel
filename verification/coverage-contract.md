# Coverage contract and lifecycle

Implementation and verified-property status remain distinct. The full literal v2 bullet inventory is in coverage-contract.json; only named actual checks are execution evidence. A reviewed bullet is not an independently verified property.

| Phase | Actual checks | Result |
|---|---|---|
| institution/configuration admission | [membership-retirement-final](../results/runs/membership-retirement-final/receipt.json), [membership-lifecycle-tests](../results/runs/membership-lifecycle-tests/receipt.json) | executed-with-result |
| descriptor agreement | [qa-scenarios-bindings_test](../results/runs/qa-scenarios-bindings_test/receipt.json), [qa-scenarios-dvp_test](../results/runs/qa-scenarios-dvp_test/receipt.json) | executed-with-result |
| account/policy/authority checks | [qa-scenarios-policy_test](../results/runs/qa-scenarios-policy_test/receipt.json), [membership-lifecycle-tests](../results/runs/membership-lifecycle-tests/receipt.json) | executed-with-result |
| instruction acceptance | [qa-scenarios-dvp_test](../results/runs/qa-scenarios-dvp_test/receipt.json), [qa-scenarios-contention_test](../results/runs/qa-scenarios-contention_test/receipt.json) | executed-with-result |
| competing balance use | [qa-scenarios-contention_test](../results/runs/qa-scenarios-contention_test/receipt.json), [queue-capacity-progress](../results/runs/queue-capacity-progress/receipt.json) | executed-with-result |
| reservation of each leg | [qa-scenarios-dvp_test](../results/runs/qa-scenarios-dvp_test/receipt.json), [qa-scenarios-escrow_path_test](../results/runs/qa-scenarios-escrow_path_test/receipt.json) | executed-with-result |
| transaction inclusion and finalization | [qa-core-finite](../results/runs/qa-core-finite-attempt1/receipt.json), [qa-scenarios-recovery_test](../results/runs/qa-scenarios-recovery_test/receipt.json), [qa-scenarios-phase_failure_test](../results/runs/qa-scenarios-phase_failure_test/receipt.json) | executed-with-result |
| witness capture | [qa-scenarios-network_test](../results/runs/qa-scenarios-network_test/receipt.json), [qa-scenarios-recovery_test](../results/runs/qa-scenarios-recovery_test/receipt.json) | executed-with-result |
| proof creation | [qa-core-finite](../results/runs/qa-core-finite-attempt1/receipt.json), qa-combined-faults-17 (not_run) | blocked |
| evidence delivery | [qa-scenarios-network_test](../results/runs/qa-scenarios-network_test/receipt.json), qa-combined-faults-43 (not_run) | blocked |
| decision | [qa-core-finite](../results/runs/qa-core-finite-attempt1/receipt.json), qa-immediate (not_run) | blocked |
| local effects | [qa-scenarios-dvp_test](../results/runs/qa-scenarios-dvp_test/receipt.json), [qa-legacy-non_atomic](../results/runs/qa-legacy-non_atomic/receipt.json) | executed-with-result |
| outcome proofs | [qa-core-finite](../results/runs/qa-core-finite-attempt1/receipt.json), [qa-scenarios-open_test](../results/runs/qa-scenarios-open_test/receipt.json) | executed-with-result |
| remaining application/refund | [qa-full-one](../results/runs/qa-full-one/receipt.json), [late-hold-relative-bound](../results/runs/late-hold-relative-bound/receipt.json) | executed-with-result |
| recipient usability | [qa-scenarios-privacy_pipeline_test](../results/runs/qa-scenarios-privacy_pipeline_test/receipt.json), [qa-private-availability](../results/runs/qa-private-availability/receipt.json), [qa-private-unconditionalAvailability](../results/runs/qa-private-unconditionalAvailability/receipt.json) | executed-with-result |
| reporting/reconciliation | [qa-scenarios-report_view_test](../results/runs/qa-scenarios-report_view_test/receipt.json), [qa-scenarios-dvp_test](../results/runs/qa-scenarios-dvp_test/receipt.json), [qa-scenarios-policy_test](../results/runs/qa-scenarios-policy_test/receipt.json), [audit-audit_safe](../results/runs/audit-audit_safe/receipt.json) | executed-with-result |
| retention recovery retirement and institution exit | [membership-lifecycle-tests](../results/runs/membership-lifecycle-tests/receipt.json), [qa-full-recovery](../results/runs/qa-full-recovery/receipt.json), [qa-scenarios-network_test](../results/runs/qa-scenarios-network_test/receipt.json) | executed-with-result |

C-Decision, C-Local and C-Records remain distinct. General n-leg exchange, FX, repo maturity, netting, external funding/redemption, legal rights, circuit soundness and production deployment are external or excluded as stated in the original task. No implementation proof is claimed.

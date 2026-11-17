# Coverage contract and lifecycle

Implementation and verified-property status remain distinct. The full literal v2 bullet inventory is in coverage-contract.json; only named actual checks are execution evidence. A reviewed bullet is not an independently verified property.

| Phase | Actual checks | Result |
|---|---|---|
| institution/configuration admission | [membership-retirement-final](../results/runs/membership-retirement-final/receipt.json), [membership-lifecycle-tests](../results/runs/membership-lifecycle-tests/receipt.json) | executed-with-result |
| descriptor agreement | [scenario-bindings_test](../results/runs/scenario-bindings_test/receipt.json), [scenario-dvp_test](../results/runs/scenario-dvp_test/receipt.json) | executed-with-result |
| account/policy/authority checks | [scenario-policy_test](../results/runs/scenario-policy_test/receipt.json), [membership-lifecycle-tests](../results/runs/membership-lifecycle-tests/receipt.json) | executed-with-result |
| instruction acceptance | [scenario-dvp_test](../results/runs/scenario-dvp_test/receipt.json), [scenario-contention_test](../results/runs/scenario-contention_test/receipt.json) | executed-with-result |
| competing balance use | [scenario-contention_test](../results/runs/scenario-contention_test/receipt.json), [queue-capacity-progress](../results/runs/queue-capacity-progress/receipt.json) | executed-with-result |
| reservation of each leg | [scenario-dvp_test](../results/runs/scenario-dvp_test/receipt.json), [witness-escrow_path_test](../results/runs/witness-escrow_path_test/receipt.json) | executed-with-result |
| transaction inclusion and finalization | [final-record-safety](../results/runs/final-record-safety/receipt.json), [scenario-recovery_test](../results/runs/scenario-recovery_test/receipt.json) | executed-with-result |
| witness capture | [network-loss-recovery](../results/runs/network-loss-recovery/receipt.json), [scenario-recovery_test](../results/runs/scenario-recovery_test/receipt.json) | executed-with-result |
| proof creation | [final-record-safety](../results/runs/final-record-safety/receipt.json), [combined-faults-17](../results/runs/combined-faults-17/receipt.json) | executed-with-result |
| evidence delivery | [network-loss-recovery](../results/runs/network-loss-recovery/receipt.json), [combined-faults-43](../results/runs/combined-faults-43/receipt.json) | executed-with-result |
| decision | [final-record-safety](../results/runs/final-record-safety/receipt.json), [overclaim-immediate](../results/runs/overclaim-immediate/receipt.json) | executed-with-result |
| local effects | [scenario-dvp_test](../results/runs/scenario-dvp_test/receipt.json), [mutant-non_atomic](../results/runs/mutant-non_atomic-attempt3/receipt.json) | executed-with-result |
| outcome proofs | [final-record-safety](../results/runs/final-record-safety/receipt.json), [delayed-open-fact-scenarios](../results/runs/delayed-open-fact-scenarios/receipt.json) | executed-with-result |
| remaining application/refund | [final-record-progress](../results/runs/final-record-progress/receipt.json), [late-hold-relative-bound](../results/runs/late-hold-relative-bound/receipt.json) | executed-with-result |
| recipient usability | [review-pipeline-witnesses](../results/runs/review-pipeline-witnesses-attempt2/receipt.json), [review-typed-private-availability](../results/runs/review-typed-private-availability/receipt.json), [review-typed-private-unconditionalAvailability](../results/runs/review-typed-private-unconditionalAvailability/receipt.json) | executed-with-result |
| reporting/reconciliation | [report-evidence-scenario](../results/runs/report-evidence-scenario/receipt.json), [abort-authoritative-records](../results/runs/abort-authoritative-records/receipt.json), [audit-audit_safe](../results/runs/audit-audit_safe/receipt.json) | executed-with-result |
| retention recovery retirement and institution exit | [membership-lifecycle-tests](../results/runs/membership-lifecycle-tests/receipt.json), [final-record-recovery](../results/runs/final-record-recovery/receipt.json), [network-loss-recovery](../results/runs/network-loss-recovery/receipt.json) | executed-with-result |

C-Decision, C-Local and C-Records remain distinct. General n-leg exchange, FX, repo maturity, netting, external funding/redemption, legal rights, circuit soundness and production deployment are external or excluded as stated in the original task. No implementation proof is claimed.

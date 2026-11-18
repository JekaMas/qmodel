## Routed native settlement

- [x] 1. Specify securities X/cash Y, securities Y/cash X, and co-resident execution on X and on Y. [Architecture](../../../verification/protocol.md#routing-when-both-networks-carry-both-assets) and [specification](../../../verification/SPECIFICATION.md#physical-ledgers-and-concurrent-routes).
- [x] 2. Exercise both sequential orders, overlapping instructions, paid or refunded holds, scarce funds and proof isolation. [52 native scenarios](../../../verification/results/runs/admitted-test-routed_settlement_test-attempt2/raw.log), [two cross-route reference comparisons](../../../verification/results/runs/admitted-test-routed_cross_reference_test-attempt1/raw.log) and [two co-resident comparisons](../../../verification/results/runs/admitted-test-routed_local_reference_test-attempt1/raw.log).
- [x] 3. Check finite safety, per-leg recovery and mutation sensitivity. Reconcile the ten current scope names with their [immutable observations](../../../verification/configs/admission-acceptance.json) and the [eight OpenSpec cases](verification.json).

## Native observations

| Final TLC profile | Distinct reachable states | Evidence |
| --- | ---: | --- |
| Opposite routes and another X/Y instruction with scarce funds | 8,580 | [Safety](../../../verification/results/runs/admitted-routes-cross-attempt2/raw.log) |
| Two opposite routes, payment and refund convergence with ledger recovery and fair service | 900 | [Safety and temporal checks](../../../verification/results/runs/admitted-routes-recovery-attempt1/raw.log) |
| Both cross routes and both local placements in one native book | 3,600 | [Safety](../../../verification/results/runs/admitted-routes-four-attempt1/raw.log) |
| X/Y siblings competing with local X and local Y | 1,112 | [Safety](../../../verification/results/runs/admitted-routes-scarce-attempt1/raw.log) |
| Y/X siblings competing with reversed local sellers on X and Y | 1,112 | [Safety](../../../verification/results/runs/admitted-routes-scarce-reverse-attempt1/raw.log) |

TLC found a counterexample to backed settlement when [local COMMIT delivered securities alone](../../../verification/results/runs/admitted-routes-half-local-attempt1/raw.log) and when [a host substituted the opposite trade’s cash-hold proof](../../../verification/results/runs/admitted-routes-foreign-proof-attempt1/raw.log). The final steps include simultaneous independent payments and their serial-order oracle. Earlier runs predate that transition. The unselected first translation failed before model checking because the initializer also appeared as a step operator. The final model uses a pure initializer.

The figures apply separately to each finite profile. Fairness concerns servicing an existing final COMMIT or an existing hold after ABORT. Bank rights, full-protocol refinement and deployed multi-ledger conformance retain their existing evidence boundaries.

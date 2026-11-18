# Settle funded trades in the same ledger block

- [x] Implement local block execution with fixed height, independent legs and transaction-level dispositions.
- [x] Verify three fully funded transactions end to end under all modeled orders and distinguish short A/B, reserved capacity, and early seal or repeated balance charging.
- [x] Review the guards and original results, reconcile exact evidence, and document the repaired guarantee and its inclusion conditions.

## Progress

- The old N3 profile verifies eventual terminal decision under time/abort fairness. Its choice of the next action does not identify a batch already included at one height. Preserve that evidence while adding the required one-block result.
- Exact write owners are the authentic dvp reservations, commit, applyB and evidence primitives. The new block model owns a local batch's inclusion height and disposition. Actual ordered transaction effects and an independently checked capacity ledger identify a genuine shortage.
- TLC checked block safety and weakly fair completion for 189 fully funded states and 149 states for each one-sided shortage. Nine directed tests passed. Four separate invalid rules produced real counterexamples.
- The complete audit passed 367 selected observations. All six OpenSpec acceptance cases passed on the clean implementation revision cf56ae47d2ac0f3cf50bdb43db4c37ac5ce301a1. Evidence and bounds are in the [block report](../../../verification/reports/funded-blocks.md).

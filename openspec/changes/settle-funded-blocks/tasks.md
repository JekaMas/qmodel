# Settle funded trades in the same ledger block

- [ ] Implement local block execution with fixed height, independent legs and transaction-level dispositions.
- [ ] Verify three fully funded transactions end to end under all modeled orders and distinguish short A/B, reserved capacity, and early seal or repeated balance charging.
- [ ] Review the guards and original results, reconcile exact evidence, and document the repaired guarantee and its inclusion conditions.

## Progress

- The old N3 profile verifies eventual terminal decision under time/abort fairness. Its choice of the next action does not identify a batch already included at one height. Preserve that evidence while adding the required one-block result.
- Exact write owners are the authentic dvp reservations, commit, applyB and evidence primitives. The new block model owns a local batch's inclusion height and disposition. Actual ordered transaction effects and an independently checked capacity ledger identify a genuine shortage.

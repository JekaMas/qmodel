# Repeated settlement and event coverage

Base revision 2b489bac08ccfd2fe902d714a9fd377ecf9ccb39. The settlement specification defines the trade lifecycle.

- [x] Review the existing models, predicates, directed tests and native configuration scopes. Compare Quint and TLA+ examples and record actionable gaps.
- [x] Implement and execute multi-cycle, three-overlapping-trade, contention, stale-proof and recovery workloads.
- [x] Reconcile every core event/fault with executed tests, placement or mutant scope, and external limits. Run bounded schedule and fault domains.
- [x] Re-review the affected model and oracle, validate the OpenSpec evidence map and update the protocol, README and results.

## Progress

- The baseline is clean. Its shared deadline and one funded pair cannot exercise repeated COMMITs or three simultaneous reservations. Fixed-configuration proof receipts remain available separately.
- Initial review found that the normal graph omits loss and prune, the general adversarial entry also omits them, and the operational overlay includes them. The new dispatch selects the full operational vocabulary and makes actual reachability explicit.
- Reproduced ordinary B spending while B was down in the reference. The funded workload makes the local guard explicit. Both offline rejections and the successful recovery witness passed.
- Retained the initial unsharded stalls, action-effect error and Node heap failure. Iterative replay and source-bound Rust batching executed all 278 directed cases, including all 90 selected parallel orders.
- Read the pinned Quint TwoPhaseCommit, ICS20 and Malachite sources and the TLA+ TwoPhase and KVsnap specifications. The review maps the relevant design choices to actual event observations.
- The single 10,000-trace sample reached its 600-second wall cap. The original timeout is retained. A replacement campaign keeps the 10,000-trace denominator and 150-step cap, with ten independently seeded jobs of 1,000 traces, five concurrent workers and a 900-second cap per job.
- All ten seeded samples completed, totaling 10,000 traces at a 150-step cap. The source-bound audit classifies all 45 core actions, links distinct focused failure models and accepts 288 native observations. The change DAG executed all six cases and strict OpenSpec validation passed.
- Updated the specification, architecture notes, review, README and machine-readable coverage. See the [review](../../../verification/reports/repeated-settlement-review.md) and [event ledger](../../../verification/reports/repeated-settlement-coverage.json). Arbitrary schedule exhaustiveness and deployed-system conformance remain outside the completed finite workload.

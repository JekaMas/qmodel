# Resolve the DvP protocol review

- [x] Implement finalized admission on either source, historical continuation, cleanup, and fresh-epoch instructions.
- [x] Repair A block inclusion and confirmation depth, bank cursor semantics, independent inboxes and validator handoff.
- [x] Verify honest committee completion and all 36 bilateral order pairs, including separate outage/late-proof controls.
- [x] Document the A-hosted PoC and the external bank decision. Production acceptance is pending both banks.
- [x] Reconcile the live native receipts with the original release and bind all seven requirements scenarios to their fourteen acceptance cases.

## Validation record

The checked protocol and evidence are described in [the review disposition](../../../verification/reports/finalized-admission.md). Immutable native executions have individual result directories. A source-bound index identifies the accepted attempt when a fixture or observer was repaired. The prior release owns its original graph identities and archived regression assertions. The current audit passed 168 selections, including 29 exhaustive successes, 21 expected native violations, 779 named directed cases and 23,600 sampled traces. It also audited 367 retained selections at the published base. All seven paired liveness profiles use current native receipts. Run the change DAG with `--all --require-clean` on the release commit to reproduce the acceptance check. The external bank decision is recorded as pending.

## ADDED Requirements

### Requirement: Check repeated exchanges with retained identity

The settlement workload SHALL exercise successive and overlapping exchanges on one initialized ledger pair with independent terminal identities and exact economic outputs.

#### Scenario: Sequential and overlapping exchanges

- **WHEN** a COMMIT and a funded ABORT resolve and a later trade settles
- **THEN** each trade SHALL keep its own decision, effect and durable row
- **AND** three distinct fully backed exchanges SHALL settle in every selected legal COMMIT and remote application order
- **AND** a competing request without remaining capacity SHALL reserve nothing

#### Scenario: Delayed and repeated evidence

- **WHEN** an earlier valid proof is delayed, lost, replayed or presented for another trade
- **THEN** the affected action SHALL make only its allowed change and later trades SHALL require evidence bound to their own descriptor
- **AND** no duplicate economic effect or contradictory record SHALL arise

### Requirement: Audit event and fault coverage

Each core modeled event SHALL have an explicit disposition linked to executed evidence, a placement or mutant, or an external assumption.

#### Scenario: Actor outages and modeled fault inputs

- **WHEN** failures are exercised at their modeled boundary
- **THEN** the checks SHALL prove reachability of the blocked action's preconditions, correct rejection or recovery, and invariants at observed steps
- **AND** the coverage record SHALL identify the quantified schedule domain and other unexhausted combinations

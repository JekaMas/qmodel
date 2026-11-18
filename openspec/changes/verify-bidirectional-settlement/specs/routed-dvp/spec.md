## ADDED Requirements

### Requirement: Settle routed instructions against native funds

Each signed instruction SHALL identify the physical ledger, genesis, asset, accounts and quantity of each leg and its unique decision slot on the securities ledger. Either ledger MAY host securities or cash. Co-resident legs SHALL commit in one local transaction. Concurrent instructions SHALL preserve each other's reservations and every native account balance.

#### Scenario: Both cross-ledger directions
- **WHEN** distinct X-securities/Y-cash and Y-securities/X-cash instructions complete in either sequence
- **THEN** each securities host SHALL deliver its own leg at COMMIT using final evidence of the matching cash hold, and each cash ledger SHALL pay the matching seller exactly once on presentation of the host decision
- **AND** a halted cash ledger SHALL retain the committed reservation until recovery and servicing

#### Scenario: Co-resident exchange
- **WHEN** both legs reside on X or both reside on Y
- **THEN** a funded local transaction SHALL exchange both native balances at one decision, and insufficient free funds on either leg SHALL disable the entire exchange

#### Scenario: Concurrent trades and contention
- **WHEN** distinct instructions overlap, including both directions, repeated directions, and local exchanges alongside cross-ledger trades
- **THEN** independent host decisions or payments on different cash ledgers MAY occur from the same pre-state and SHALL produce the same balances, reservations and outcomes as either serial order
- **AND** competing transactions on one ledger SHALL respect that ledger's execution order and free funds, including holds belonging to other trades

#### Scenario: Proof and refund isolation
- **WHEN** reservations, terminal decisions or retries from different instructions reach a consumer in any order
- **THEN** a transition SHALL require the matching final proof and phase, and ABORT SHALL release only its own outstanding reservations to their original accounts
- **AND** payments and refunds SHALL conserve each native asset on its issuing ledger

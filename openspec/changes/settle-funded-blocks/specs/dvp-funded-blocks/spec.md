## ADDED Requirements

### Requirement: Execute funded trades independently within each ledger block

Each ledger SHALL evaluate included local requests at one block height against the state resulting from preceding local transactions.

#### Scenario: Fully funded parallel reservations

- **WHEN** three locally eligible reservations are included on each ledger and the sums fit both spendable balances
- **THEN** every reservation SHALL succeed in every local order and both ledgers MAY progress independently
- **AND** normal end of block SHALL account for every included request

#### Scenario: Actual shortage and existing holds

- **WHEN** a ledger lacks unreserved balance for all its included reservations
- **THEN** it SHALL apply each reservation that fits and reject only those exceeding the remaining balance
- **AND** an existing reservation SHALL reduce spendable balance and remain intact

#### Scenario: Same-block commit and cash application

- **WHEN** included trades have both reserved legs and authentic preparation before the exclusive A deadline
- **THEN** every included commit SHALL consume its existing A hold at that height, even if the unreserved balance is zero
- **AND** B SHALL apply each included authenticated outcome to its own cash hold once, and ledger-height changes SHALL preserve the actual deadline rules

## ADDED Requirements

### Requirement: Preserve progress and authority across protocol composition

The protocol SHALL preserve authority and admitted effects in each declared composed recovery scope.

#### Scenario: End-to-end work under hostile load

- **WHEN** capture, proof, inclusion, transport, application and reporting compete with junk and retry
- **THEN** ready accepted work SHALL survive interruption and preserve exact effects
- **AND** a stated service bound SHALL depend on actual eligible service slots, with overload and missing-service controls

#### Scenario: Independent chain rates and evidence issuance

- **WHEN** A and B clocks and inclusion progress diverge and an attempt is replaced
- **THEN** only an authoritative A height and finalized issued statement SHALL govern outcome
- **AND** tests SHALL expose B-clock refund and the limits of bounded service

#### Scenario: Byzantine rounds and membership changes

- **WHEN** validators equivocate, keys move under attacker control, or membership changes
- **THEN** supported authority SHALL preserve same-height locks, the certified predecessor and historical verification
- **AND** omitted locks, uncertified membership, retained compromised keys and stale authority SHALL have controls

#### Scenario: Alternative placement and adversarial recovery

- **WHEN** funded trades run with decision on B, on D or on a shared ledger
- **THEN** each local effect SHALL follow its placement, proved outcome and exact descriptor
- **AND** correlated failures, partial delivery and authentic replay SHALL preserve records and expose placement-specific faulty effects

### Requirement: Verify contract histories and observation independently

The protocol SHALL independently establish legal local histories, scoped observations and population-independent hold safety.

#### Scenario: Invocation and storage recovery at logical contract boundaries

- **WHEN** two logical ledgers and their adapters accept, include, finalize, observe, restore or retry requests
- **THEN** observable results SHALL follow the sequential local effect and durable history
- **AND** early responses, unauthorized stale history, missing effects and duplicate application SHALL be rejected or caught by controls

#### Scenario: Paired observable privacy under operational failures

- **WHEN** public requests, batch work, outages, backups and role changes interleave in two coupled worlds
- **THEN** the selected observer histories SHALL remain equal modulo authorized opaque identities
- **AND** leaking scope, routing, private bounds and key-loss controls SHALL be observable

#### Scenario: Population-independent hold preservation

- **WHEN** a valid local action updates one named trade among any finite number of admitted trades
- **THEN** per-trade authority, single consumption, capacity and exact symbolic identity SHALL be preserved
- **AND** the proof SHALL account for initialization, the selected local transitions and their refinement, and expose aliasing, double use and capacity mutations

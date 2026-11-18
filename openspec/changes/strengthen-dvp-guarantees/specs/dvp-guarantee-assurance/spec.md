# DvP guarantee assurance

## ADDED Requirements

### Requirement: Check local outcomes and durable completion independently

The active model acceptance suite SHALL check the actual terminal outcome, remote evidence and local effects independently of fields written by the action that is being checked.

#### Scenario: Outcome authority for local and remote legs

- **WHEN** a leg learns a terminal outcome, delivers an asset or releases a hold
- **THEN** the outcome and effect SHALL agree with the authoritative decision
- **AND** a remote leg SHALL have matching authenticated terminal evidence of that outcome
- **AND** a colocated COMMIT SHALL include the corresponding local delivery
- **AND** a valid wrong-phase proof SHALL fail the independent monitor even if faulty consumer code accepts it

#### Scenario: Evidenced COMMIT report and retained financial row

- **WHEN** COMMIT is shown as fully applied or a COMMIT financial record remains after restart
- **THEN** each leg SHALL have its actual delivery and a matching authenticated application fact
- **AND** the row SHALL contain the exact successful descriptor and outcome
- **AND** the proven L04 endpoint SHALL imply evidence-backed completion
- **AND** missing application evidence or an omitted local effect SHALL prevent the stronger assertion from passing

#### Scenario: Admission and outcome history

- **WHEN** a local reservation becomes active on the checked A-hosted preparation and decision spine
- **THEN** its preceding state SHALL allow admission for the exact leg and signed terms
- **AND** a terminal decision SHALL survive the next transition without rewriting its outcome
- **AND** the absent-eligibility and reopen controls SHALL violate their respective history predicates

### Requirement: Exercise recovery combinations and persistence

The assurance suite SHALL exercise combined obligations at their actual modeled or locally implemented owner boundary and report external conformance separately.

#### Scenario: Pending obligations survive governance and intervention

- **WHEN** an already admitted trade crosses rotation, membership exit or a temporary post-COMMIT freeze
- **THEN** the admitted historical evidence SHALL remain usable for that obligation, and a new or unadmitted instruction SHALL confer no settlement authority
- **AND** a blocked local transfer SHALL leave the durable outcome and held value in the correct state for retry

#### Scenario: Restore and replay financial records

- **WHEN** the local booking adapter restarts from a stale database snapshot and receives the same complete authenticated application identity again
- **THEN** the adapter SHALL rebuild one exact durable financial row
- **AND** partial, mismatched or contradictory evidence SHALL establish no completed row

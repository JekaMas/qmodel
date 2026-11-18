## ADDED Requirements

### Requirement: Explore three concurrent funded identities

The verification suite SHALL explore three signed identities with local funding and no state reset between competing instructions.

#### Scenario: Three-trade decisions and contention

- **WHEN** A and B prepare three trades with sufficient or contended funding
- **THEN** a valid decision SHALL use only the exact trade evidence and available capacity
- **AND** an over-capacity offer and a foreign proof SHALL fail to enable settlement

#### Scenario: Timed failure and hostile delivery

- **WHEN** modeled participants, channels and policy fail or recover at different stages
- **THEN** actual effects and rows SHALL preserve their terminal authority and identity
- **AND** recovery and attack coverage SHALL identify its event budget, durations and stated stability assumptions

#### Scenario: Bounded application under hostile load

- **WHEN** a timed B stop overlaps junk arrivals and the two ready application jobs compete for service
- **THEN** the protected-lane profile SHALL preserve both authenticated effects within two eligible service ticks
- **AND** the envelope SHALL include the actually saturated success path and a competing shared-queue counterexample

### Requirement: Separate local linearization from replica authority

The verification suite SHALL check economic linearization and certificate authority independently.

#### Scenario: Concurrent invocation and observable results

- **WHEN** concurrent operations execute, lose their response, retry or see a legitimately stale projection
- **THEN** completed local effects SHALL match a legal sequential history preserving completed-before-invoked order
- **AND** early success, conflicting replacement and a duplicate economic effect SHALL be detectable

#### Scenario: Byzantine certificate threshold

- **WHEN** sources equivocate or lack quorum
- **THEN** the supported quorum SHALL preserve authority for its fixed signed scope
- **AND** the broken trust assumptions SHALL have independent controls

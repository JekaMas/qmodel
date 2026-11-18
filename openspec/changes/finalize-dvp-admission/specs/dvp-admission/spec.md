## ADDED Requirements

### Requirement: Admit and finish native settlement under current or retained authority

The protocol SHALL distinguish a finalized reservation from signatures, registration and provisional inclusion.

#### Scenario: Admission across rotation
- **WHEN** a source changes epoch
- **THEN** a new reserve under the old descriptor SHALL require an authenticated finalized reservation from the other leg, rooted in the admitted epoch
- **AND** a provisional pre-cut reserve alone SHALL permit no new historic preparation or commit
- **AND** a new-epoch trade and cleanup of unfinished holds SHALL remain possible

#### Scenario: Authoritative inclusion
- **WHEN** A produces no block after a submission
- **THEN** no new decision or spendable delivery SHALL be included and its confirmation SHALL await the required depth

#### Scenario: Current bank status
- **WHEN** a confirmed write, duplicate request or historical manifest arrives
- **THEN** a current report SHALL cover its verified prefix, the latest cursor SHALL be monotone, and retries SHALL preserve the economic result

#### Scenario: Validator handoff
- **WHEN** a certificate is newly accepted as current
- **THEN** its authority SHALL be current in the immediately preceding state and historical reading SHALL remain possible

#### Scenario: Comparable completion
- **WHEN** an honest committee authorizes a backed exchange and B is available and fairly serviced
- **THEN** both native deliveries SHALL be reachable and the remaining B delivery SHALL eventually occur

#### Scenario: Bilateral funding shortfall
- **WHEN** each ledger can reserve two of three included requests and both use their own order
- **THEN** the funded intersection SHALL settle under timely inclusion and delivery, and every other trade SHALL have its own justified terminal record after expiry

#### Scenario: Bank finality decision
- **WHEN** production acceptance of A-hosted settlement is considered
- **THEN** each bank SHALL establish the irrevocable cash entitlement at A final COMMIT and its enforcement during B unavailability, or require another arrangement meeting its finality contract

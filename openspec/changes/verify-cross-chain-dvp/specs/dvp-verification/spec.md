# DvP verification

## ADDED Requirements

### Requirement: Execute scoped protocol verification

The project SHALL implement and execute all mandatory suites from verification/sources/task-v2.md and retain exact coverage and evidence rather than asserting unconditional correctness.

#### Scenario: Safe baseline and falsification

- **WHEN** the documented baseline and negative-control commands execute
- **THEN** each result identifies the exact property, finite configuration, assumptions, toolchain, command and raw evidence
- **AND** negative checks succeed only when the intended property counterexample is detected

#### Scenario: Incomplete or external claims

- **WHEN** a mandatory check cannot complete or a claim exceeds the model boundary
- **THEN** its limitation and reproduction/unblock command remain visible and full-scope status is NOT DONE

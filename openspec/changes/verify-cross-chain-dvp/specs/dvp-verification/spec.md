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

#### Scenario: Bound observations and explicit replay

- **WHEN** receipt claims, selected targets, raw output or source identity change
- **THEN** the evidence audit rejects them against the versioned observation contract
- **AND** zero-selected scenarios do not establish a passing result
- **WHEN** fresh execution or an exact historical attempt is explicitly requested
- **THEN** a new subprocess executes the selected saved closure without cached replay or implicit later-success substitution
- **AND** native comparison uses only an immutable associated export; missing early evidence remains explicitly unavailable

#### Scenario: Extended full-model closure

- **WHEN** an original bounded checker attempt times out and larger resources or a different exact backend are used
- **THEN** the original non-success receipt remains unchanged and the new observation identifies the same state, initializer, transition relation and properties
- **AND** an exhaustive check of the identical reference may discharge a bounded safety obligation without relabeling the original backend attempt as a pass
- **AND** unrestricted two-trade and recovery progress require their own full-job temporal results; a compact-job or economic-only result cannot substitute
- **WHEN** an extended-profile observation is explicitly replayed
- **THEN** the new process uses the recorded JVM resource flags and limit, in addition to the exact saved model/configuration closure

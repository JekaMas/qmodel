# DvP verification

## ADDED Requirements

### Requirement: Execute scoped protocol verification

The project SHALL implement and execute all mandatory suites from verification/sources/task-v2.md and retain exact coverage and evidence rather than asserting unconditional correctness.

For Question 8, `verification/SPECIFICATION.md` maps Stage A properties to assertions and guards. `verification/reports/interview-summary.md` links their model results, the Stage C failure cases and the remaining implementation tests.

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
- **AND** printed payload fields named `error` do not become CLI errors, while actual QNT/runtime errors remain non-successes
- **WHEN** the user explicitly requests focused repair testing and defers the full suite
- **THEN** the selected focused checks and every deferred full obligation are recorded separately
- **AND** full verification remains NOT DONE until its remaining obligations complete

#### Scenario: Extended full-model closure

- **WHEN** an original bounded checker attempt times out and larger resources or a different exact backend are used
- **THEN** the original non-success receipt remains unchanged and the new observation identifies the same state, initializer, transition relation and properties
- **AND** an exhaustive check of the identical reference may discharge a bounded safety obligation without relabeling the original backend attempt as a pass
- **AND** unrestricted two-trade and recovery progress require their own full-job temporal results; a compact-job or economic-only result cannot substitute
- **WHEN** an extended-profile observation is explicitly replayed
- **THEN** the new process uses the recorded JVM resource flags and limit, in addition to the exact saved model/configuration closure

#### Scenario: Complete disclosure value binding

- **WHEN** a disclosure succeeds for any configured field or header
- **THEN** its query identity, status, scalar value, proof context and recipient note match separately captured source provenance
- **AND** corrupting any of the sixteen scalar fields or proof root/program is detected by the unchanged binding assertion
- **AND** the complete note amount/recipient and response identity are independently source-bound
- **AND** authenticated query context determines entitlement and the observer's visible body, so a producer-supplied role tag cannot conceal an unauthorized disclosure

#### Scenario: Authentic proof admission at the consumer

- **WHEN** a cryptographically valid source-derived certificate uses an unadmitted program
- **THEN** the actual financial consumer rejects it even after rotation or exit
- **AND** descriptor/proof-context substitution tests reach that consumer with provenance already present
- **AND** omitting program admission produces an actual S10 counterexample without changing its oracle
- **AND** B's remote security-preparation consumer and both D preparation-consumer branches each reject actual captured-source program0 proofs, accept matching canonical proofs, and fail unchanged S10 when only program admission is omitted

#### Scenario: Semantically resolved ABORT records

- **WHEN** an ABORT is reported as reconciled or booked
- **THEN** neither leg has an active hold, each prepared leg has exactly one actual release, and terminal absent legs have no invented refund
- **AND** premature absence records are rejected and a producer-guard mutant violates an independent final-outcome assertion

#### Scenario: Exact economic output identity

- **WHEN** any reference placement, escrow path or multilateral leg delivers or releases value
- **THEN** an actual economic receipt identifies the operation, chain/genesis, asset, credited account and quantity
- **AND** an independent comparison against authorized terms detects a wrong valid account or asset even when quantity and total supply remain correct
- **AND** private financial booking rows retain exact descriptor terms and outcome rather than only an idempotency counter
- **AND** an independent invariant over the actual source holds proves that a delivery/release receipt cannot substitute for the actual economic effect
- **AND** a B-hosted COMMIT atomically applies its local cash leg and a shared-ledger COMMIT atomically applies both colocated legs
- **AND** separate actual-initiation, arbitrary-invariant-state preservation under the identical protocol transition relation, and implication obligations are required for any claimed source-effect induction; its complete initializer coverage is audited

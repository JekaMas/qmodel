# Executable solution specification

This document describes the model that was reviewed, including the corrections made during the investigation. The original authority remains [task v2](sources/task-v2.md) and the [recovered shared solution](sources/shared-solution.original-ru.md). The absent original PDF/design registers are recorded in the source inventory. Quint files are executable specifications, not deployed Solidity/adapters/circuits.

## Reference transaction and authority

The reference has independent native asset ledgers A and B. A holds security; B holds funded cash. The seller and buyer are signing principals, not synonyms for banks A and B. Local accounts have ledger-specific namespaces. The complete immutable Descriptor binds all 22 modeled fields: trade/nonce, both chain/genesis identities, decision domain, assets, hold/decision contracts, integer quantities, four accounts, exclusive deadline, protocol/configuration and commitment.

A signature on one descriptor cannot authorize another. Admission requires both signatures, the relevant local account policy and available capacity. In the finite reference, security quantity is 2 and cash quantity is 3. A native hold excludes reserved units from spendable capacity without creating a second balance; escrow moves reserved units into an actual modeled vault. Two distinguishable trades compete for insufficient shared capacity.

| Operation | Allowed inputs | Observable result |
|---|---|---|
| A registration/reservation | Exact signatures, local policy/balance, A height | OPEN and security hold in one local transaction |
| B preparation | Exact signatures, local policy/balance, persistent B terminal knowledge; optional authentic OPEN evidence | Cash hold, without reading A's live decision |
| Inclusion/finality/capture/prove | Actual included fact, canonical source finality, retained immutable witness | Structured historical preparation/outcome/application evidence |
| A COMMIT | Received authentic B preparation, local hold/freeze and `height < D` | Permanent COMMIT and exact security delivery in one local transaction |
| ABORT | Exact signed descriptor, `height >= D`, no terminal decision | Permanent ABORT, including a tombstone when OPEN never existed; refund is separate |
| B application/refund | Persistent locally verified terminal outcome | Cash delivery or actual hold release once; no independent B expiry |
| Reconciliation | Authentic local application records; for ABORT authentic outcome plus both source refund/no-obligation records | Evidence-supported, idempotent records; incomplete/stale views remain labeled |

A historical authentic proof remains authentic after its source changes. Safe stale evidence therefore relies on persistent obligations and immutable outcomes, not a live-source recheck. B retains ABORT knowledge even with no hold. A later prepare after known ABORT is rejected; one arriving before B learns ABORT has an authentic eventual resolution path.

## Three distinct guarantees

`C-Decision` means one irreversible outcome with authorized, actually backed obligations. In the A-hosted reference COMMIT also delivers security locally. `C-Local` means both native economic applications have occurred, with private note/key usability considered separately. `C-Records` means reported/booked completion has the required authentic source evidence.

The asynchronous reference permits an interval where A security is locally usable while B cash remains reserved. It fails instantaneous joint local usability. Conditional L01–L04 require retained authority/data, eventual operational recovery and per-trade/per-action weak fairness. They do not guarantee COMMIT before the finite deadline; ABORT is a legitimate eventual result. Permanent ledger failure, mandatory permanent freeze or irreversible private data/key loss can defeat the corresponding progress/usability claim.

S01–S16 name the original requirements. The actual `safe` conjunction, direct guard scenarios and focused models have precise different scopes. S14's core state predicate checks authorization, while admission eligibility/freeze is guarded and exercised directly; it is not an independent historical eligibility/compliance theorem. S13 in the core retains version 1; predecessor approval, retirement and credentials are additionally checked in the membership/control model. `progressReport` is a combined-world diagnostic: live recipient usability and participant-local knowledge are not implementable external reporter observations. Real external reporting must authenticate every source-dependent field.

## Observer-facing data and privacy

The replacement [privacy pipeline](models/privacy_pipeline.qnt) stores two separate world states with protected positions 4/7 and equal authorized trade/funding. Actual operations create reservations, immutable snapshots, captured witnesses, proofs, applications, notes and reports. The public proof projection contains opaque roots and permitted metadata; private witness records do not appear inside an observer-visible proof.

The complete returned `Payload` contains explicit scalar/header/note fields. Internal `Issue` provenance is a separate ghost/oracle record and is never transmitted. Denied or unavailable protected fields return a redacted body and status, including empty note/asset data. Binding compares the response and recipient note with the actual captured transition. Role IDs represent authenticated principals, not caller-supplied role assertions.

The relational quantifier is finite and exact: one fixed public 12-operation sequence, optionally one arbitrary coupled API request at a public phase, with each world independently evaluating its data-dependent computations. Observer roles 1/3 compare complete response histories, status, sizes, timing, retry equality and opaque links. Other entitled principals use explicitly private channels; the relayer sees permitted metadata, not their plaintext. Regulator disclosure of different authorized positions is deliberate declassification to that regulator, not a claim that the regulator cannot learn it. A prover entitled to a job witness can learn the witness's position component. Collusion with such a principal is outside the selected relayer confidentiality guarantee.

Opaque names are tied to actual distinct witness content and compared through a documented correspondence, including response commitment fields. Retries retain the same name. This assumes ideal hiding and private channels; it does not prove entropy, computational indistinguishability, ZK, arbitrary scheduler noninterference or termination security. Actual data-path log/timing/unsalted/scope/substitution/note/key controls execute separately. The small timed product uses these actual constructed outputs and public queue time/depth, with its own bounded schedule.

## Resource, governance and composition scope

The two-trade timed model has one round-robin worker and a two-slot correlated outage. Its assumed phase costs yield decisions by 14, applications by 22 and records by 24; exclusive D=15 passes and D=14 has a counterexample. These are model slots. That workload has no hostile queue entry or recovery-priority class. The separate capacity model consumes a two-item hostile FIFO budget, caps reservations and checks fair recovered service. No combined hostile-work deadline or priority guarantee is inferred.

Admitted canonical histories, local atomic execution, ideal cryptography, supported asset powers and retained data remain explicit assumptions. Consensus authentication and execution validity are different interfaces; even valid execution must select the canonical native history. Historical credentials remain usable for accepted obligations without authorizing new admissions. Pruning must preserve pending and still-current verification paths and consumed identities.

A/B/D placement, authenticated OPEN, native/escrow, ordinary/private asset state, three-domain installation and compact HTLC/root/shared/committee controls are separately named configurations. The economic safety mapping is checked only for the one-trade A-hosted native projection. It does not compose liveness, privacy, time or arbitrary populations. Three-domain ABORT bookkeeping and the full fault/privacy/time Cartesian product remain unproved.

## Evidence and reproduction contract

A passing receipt is bound to its original raw output, exact invocation/claim/expected result, saved model/configuration closure, bounds/seeds and recorded tool identity. New execution also records the plan before the child starts, observes the installed pinned runtime and snapshots tooling. The versioned seal is a local trust anchor; it is not independent signed execution attestation. Historical version metadata retains its original measurement limits.

The default baseline/negative commands audit and reuse valid observations. Explicit fresh/replay commands always start a new process and preserve new attempts. Exact ID selection never silently chooses a later success. An explicitly requested family can use `--latest-success`. Original non-success reproduction requires `--include-failed` and remains a timeout/tool-error observation, never a killed mutant. Native comparison uses a per-execution snapshot or a sealed matching immutable replay export; a mutable shared filename is not a comparison baseline. Early observations lacking a saved source closure are explicitly unavailable for exact execution.

Four broader 180-second timeouts remain unclosed. Actual QBFT/EVM/contracts/adapters/circuits, cryptographic security, deployed availability/cost, legal/account/issuer rights and real financial-record integration require external conformance evidence. See [coverage](reports/coverage.md), [independent review](reports/independent-review.md) and [conformance](reports/conformance-boundary.md).

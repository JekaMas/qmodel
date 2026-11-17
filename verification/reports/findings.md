# Findings and verification verdict

The checked design supports **irreversible backed commitment and conditional eventual application**. It does **not** meet an interpretation of “neither leg completes without the other” that requires both assets to become locally usable at the same instant on independently scheduled ledgers. The attached v2 instruction and the recovered shared solution are the source authority; the original PDF and earlier design workspace were absent.

## Contracts and counterexamples

| Finding | Executed evidence | Consequence / smallest justified repair |
|---|---|---|
| A can deliver security while B has not yet applied cash | `applicationLagTest`; TLC `overclaim-immediate` | A contract mismatch for instantaneous C-Local. State C-Decision and conditional C-Local explicitly, or change the execution-domain requirement. No prover speedup removes an asynchronous interval. |
| Permanent B failure after A COMMIT prevents local cash availability | TLC `overclaim-permanent-halt` lasso | Recovery/data/submission hypotheses are necessary for progress. Do not call compensation original atomic settlement. |
| Independent B timeout can release cash while an authentic old preparation proof remains usable at A | `mutant-expiry`, S08, 12 transitions, exact replay matched | Durable holds; one decision-domain deadline; B applies/refunds only from persistent authenticated outcome. A remains below D while B's own clock expires. |
| Missing binding, replay, reopened ABORT, non-atomic COMMIT, relayer assertion, stale-state refund or lost tombstone breaks the intended contract | All eight protocol mutants have real intended-property violations and matching exact-source native replay | Enforce complete bindings, actual effect idempotency, terminal identity retention, local rollback, evidence provenance and authoritative outcomes. [Chronology](counterexamples.md) gives every state. |
| Delivered private commitment is insufficient for recipient usability | `private-permanent-key-loss`, `negative-wrong_note` | Bind the exact recipient payload and retain key/data access. An unrecoverable key is not repaired by ledger COMMIT. |
| Logs, low-entropy commitments, wrong scope, substituted openings and secret-dependent timing can leak or misreport | Executed privacy/access/binding/paired leak controls | Explicit surface policy, correct payload binding and accepted leakage; no blanket zero-knowledge or side-channel claim. |
| Finite deadline slack must cover queues, inclusion and outage | D=15 sufficient, D=14 counterexample in the two-job round-robin slot model | Bound the whole phase path, not just proving. Values are model slots, not measured seconds or a production SLA. |
| Source consensus authentication is not execution validity or canonical-history selection | Direct/ZK consensus accept the deliberately invalid source execution; execution-validity rejects it; attacker history rejected | Distinguish source execution trust, crypto correctness and canonical governance. |

The listed traces are small actual witnesses, not proven globally shortest counterexamples. No trace minimization was performed. TLC's native textual lasso/cycle output is retained; no unsupported TLC ITF export is claimed.

## Repairs discovered during modeling

The investigation preserved failing versions/results before repair. These are model/control-policy findings, not evidence that unseen production code contains these bugs:

- Membership allowed pruning a still-current epoch when no work was pending, then accepting a new obligation whose historical verifier had vanished. The native trace was preserved and replayed. Pruning now also requires a non-current epoch or an exited institution; pending-safe lifecycle and replay controls pass.
- B/D registration and preparation were initially coupled across ledgers. They are separate local transactions; financial authorization uses only local state and received authentic evidence. Separate D outage/recovery and delayed A/B application witnesses pass.
- ABORT bookkeeping initially read remote holds directly. It now requires authentic A ABORT plus descriptor/leg/genesis/checkpoint/program-bound source application or no-obligation records. This introduces an explicit authenticated canonical local-read interface requiring implementation conformance. No nonexistent hold is refunded.
- Immutable included/finalized evidence replaced source-current-state rechecking. Per-leg eligibility, admission freeze checks, actual escrow movement and the shared-control chain identities were made explicit. The three-domain installation now has real independent domain progress and domain-bound B-local outcome knowledge.
- Inductive strengthening initially omitted `paidB => COMMIT and authenticated B knowledge`; the unreachable-predecessor failure is preserved. The repaired induction checks initiation, preservation and implication for the algebraic finite-domain core. It is not a parameterized proof of the entire enterprise model.

[Model repair history](model-repairs.md) distinguishes harness errors, unreachable mutant attempts, semantic repairs and proof-strengthening work. Original timeouts and tool errors remain in the manifest.

## What was actually checked

The [coverage verdict](coverage.md), [property traceability](traceability.md), [variant matrix](../variants.md), [literal task review](literal-coverage.md) and [execution index](executions.md) provide the exact boundaries. Core S01–S16 are a conjunction of state predicates plus direct guard/transition scenarios; in particular S14's state predicate alone is not a historical eligibility or regulatory-compliance theorem.

TLC completed the one-trade reference graph and conditional L01–L04, the two-trade requested-job configuration, explicit recovery, candidate placements and escrow/private/shared controls. The separate three-domain installation has safety and conditional per-trade progress, with COMMIT reporting; it does not prove composed three-domain ABORT bookkeeping. Apalache checked the economic core at depths 8/12/20 and the genuine inductive obligations; the principal reference has a separately checked finite economic safety mapping. No liveness-preservation theorem follows from that mapping.

The lifecycle covers admission, descriptor/policy/funding, contention, both reservations, inclusion/finality, durable witness/proof/message processing, decisions, applications/refunds, private usability, evidence-supported reports and pending-safe retirement/exit. Executed overlaps include lost acknowledgement plus restart, actual message drop/resend, upgrade plus delayed historical proof, outage/deadline, post-delivery private payload/key loss, and two trades sharing service/capacity. The full fault/privacy/time Cartesian product and arbitrary populations are not checked.

## Privacy, time and external scope

Ordinary local validators retain local ledger visibility. Counterparties know their authorized trade terms. The paired model hides an unrelated position (4 versus 7) from the selected observer under equal authorized trade/fundability, coupled public scheduling and explicit opaque-name correspondence. Stable trade links, equality, phases, routing and permitted timing/size metadata remain visible. The reviewed replacement uses a fixed 12-operation lifecycle plus at most one arbitrary coupled API request, with full returned payloads and explicit private-channel regulator declassification; general nondeterministic noninterference, termination leakage and real cryptographic privacy are external.

Asynchronous safety has no delivery-time promise. Eventual progress uses per-trade/per-action weak fairness and eventual recovery/data/submission availability; it can legitimately end in ABORT. The bounded model uses explicit elapsed time separate from height and skewed B clocks, one round-robin worker, two jobs and a two-slot correlated outage. Its maximum normal path is 11 service slots per trade: decisions by 14, both applications by 22, records by 24 in that configuration. Pre-stabilization delay is unbounded; the original signed deadline is never reset. [Timing assumptions](../timing-assumptions.md) give exact applicability and late-hold bounds.

The four original broader attempts remain **historical 180-second timeouts**: full-reference Apalache12/20 and unrestricted-proof-job two-trade/recovery graphs. New runs retain their own caps/source/native receipts. Full Apalache12 passed after182.9 seconds; longer direct20 and finite-choice SMT attempts were explicitly interrupted at Z3 query cost. Exhaustive TLC of the identical full current reference completed12,502 states, graph depth 38, and proves safety at every reachable depth including 20. This is a different exact backend proof, not a relabeling of SMT20 or a compact/economic substitution. Current full-job temporal resolutions are in [final review](final-review.md) and its machine-readable original-obligation table. Exact saved original attempts and commands remain available.


No production contracts, adapters or proof guests were present. [Conformance vectors](../tests/conformance-vectors.json) are a specification/test plan only. Actual circuits/prover-verifier composition, QBFT, Solidity/EVM/token/reentrancy/arithmetic behavior, key/storage/network security, real side channels, measured availability/cost/latency and legal/account/issuer rights remain external. No named vendor implementation, general n-leg exchange, FX, repo maturity, netting or external funding/redemption is verified.

## Independent review and repair results

The independent review against original commit 4e3b8d0 found four repairable gaps: IR-001 protected-data/payload semantics; IR-002 forced/exact replay and per-attempt native comparison; IR-003 binding native evidence to its selected proof contract; IR-004 unsupported hostile/priority timing prose. The original review and subsequent dispositions remain in independent-review.md/json. The repairs did not change the reference economic protocol to make its overstrong atomicity claim pass.

The replacement privacy pipeline derives actual returned payloads from two funded world states and separates private issuance provenance. Its full-response paired/access checks, seven leak controls, eight exact witnesses, actual time/queue product and typed-note conditional availability execute. Permanent key loss breaks the stronger unconditional typed-note progress claim. Historical six-event monitor results remain authentic but do not discharge this stronger data-path obligation.

New execution records a plan, observed pinned runtime, exact tooling/source/raw identities and a per-execution native export. Explicit fresh requests start new child processes. The evidence seal rejects the reviewer's changed claim/target and altered native data. A zero-selected successful-exit Quint command is rejected. Historical exact native comparison is used only where an immutable matching export is associated; ten early missing source closures remain explicitly unavailable, with working family examples using --latest-success. See reproduction-availability.json and solution-and-changes.md for exact boundaries.

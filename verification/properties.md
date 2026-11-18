# Requirements before implementation

The [finalized-admission selection](configs/admission-acceptance.json) and the `current_review_scopes` entries in [the machine-readable register](properties.json) identify the current executions by scope name. Other receipt references identify their original releases. The first finalized reserve, canonical block inclusion, reporting cursor, bank gate and equivalence limits are specified in the [current review disposition](reports/finalized-admission.md).


The [executable specification](SPECIFICATION.md) defines the reference semantics. Each property below states its assumptions and verification boundary.

The [four-route workload](SPECIFICATION.md#physical-ledgers-and-concurrent-routes) extends the economic portions of S01, S04–S06, S08–S10 and C-Local to shared native accounts. The opposite-direction temporal profile checks the payment and held-refund endpoints of L02 and L03 under per-leg recovery and fair service. Each scope is selected in the machine-readable register.

## S01

Types/domains are valid; balances are nonnegative. Separate security units from cash units.

Predicate: `forall ledger,account: balance >= 0; security and cash accounting domains disjoint`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S02

Each trade has at most one terminal decision, which is permanent. Check transition/history monotonicity, not merely that an enum has one value at a time.

Predicate: `[] forall t: terminal(t) => next(decision(t)) = decision(t)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S03

Initial authorization binds both signatures to the descriptor and requires a live epoch. A new historic reserve requires exact opposite-leg canonical evidence.

Only properly authorized intent can reserve assets. Descriptor identity/terms are immutable; altered reuse is rejected.

Predicate: `[] reserve(t) => sellerSigned(desc(t)) /\ buyerSigned(desc(t)) /\ immutableIdentity(t)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S04

Per-asset conservation and reservation exclusivity. Concurrent trades cannot reserve/spend the same capacity twice. Explain accounting for native holds: reserved value is unavailable, not an extra copy of holdings.

Predicate: `[] forall asset: sum(owners)+escrow = initialSupply; sum(activeHolds(owner)) <= ownership(owner)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S05

Each actual transfer/refund and downstream booking occurs at most once for its intended operation and exact recipient/quantity. Check economic effects, not just a consumed flag.

Predicate: `[] forall t,leg: deliveryEffects(t,leg)<=1 /\ refundEffects(t,leg)<=1 /\ bookingEffects(t,leg)<=1; exactTerms`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S06

Every value-moving application has valid matching authorization/evidence; local work-state, acknowledgements or unverified messages cannot authorize settlement.

Predicate: `[] apply(t,leg) => matchingLocalAuthorization /\ authenticatedOutcome(t)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S07

A proof-eligible obligation persists under admitted asset/version semantics until its permitted terminal disposition.

Predicate: `[] prepared(t,leg) => obligationPersistsUntilAuthenticatedDisposition(t,leg)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S08

COMMIT on A implies the specified security transfer happened atomically and the matching cash obligation is still backed and bound to the recipient, or has already been delivered. Do not define backing as a Boolean derived solely from COMMIT.

Predicate: `[] decision(t)=COMMIT => securityDeliveredExactly(t) /\ (cashBackedExactly(t) \/ cashDeliveredExactly(t))`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S09

No security-delivered/cash-refunded or cash-delivered/security-refunded outcome. Include absence of any supported path to the incompatible future outcome.

Predicate: `[] forall t: ~(deliveredA(t) /\ refundedB(t)) /\ ~(deliveredB(t) /\ refundedA(t)); closure under Next`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S10

Proof binding rejects substitutions of trade, nonce, leg/phase, chain/genesis, decision domain, asset/contract, amount, recipient, checkpoint and program/configuration version.

Predicate: `[] acceptedProof(p,t) => authenticFinalizedProvenance(p) /\ everyPublicBindingMatches(p,t) /\ admittedHistoricalAnchor(p)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S11

Deadline guards and terminal tombstones prevent reopening or changing outcomes, including missing OPEN and delayed prepare cases.

Predicate: `[] commit(t)=>heightA<D; abort(t)=>heightA>=D; terminalIdentityNeverReopens(t)`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S12

Crash recovery and stale adapter snapshots cannot contradict authoritative ledger decisions or duplicate financial effects.

Predicate: `[] restart/restore/retry => authoritativeDecisionUnchanged /\ effectsNotDuplicated`. Class: operational integration. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S13

The first finalized A or B reservation establishes the obligation across the governance cut. Signatures, registration and provisional reservations do not establish it. Historical authorizations can resolve an existing obligation, with eligibility and freeze checks still active.

Supported rotation, upgrade and member-exit operations preserve pending obligations and the ability to verify/apply their historical outcomes.

Predicate: `[] rotate/upgrade/exit => pendingObligationsAndHistoricalVerificationPreserved`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S14

A newly active reservation must be permissible in the preceding state, including the credential epoch or an authenticated continuation.

Required eligibility is enforced at preparation. Post-prepare interventions obey an explicitly modeled policy; do not assume away mandatory controls and call the result compliant.

Predicate: `[] reserve(t)=>eligible(t); [] interventionsFollowSelectedPolicy`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S15

Expose signed, included, finalized admission, registered, applied, as-of and reconciled statuses separately. Current data covers the verified prefix.

Reports distinguish accepted, prepared, committed, each locally applied leg and reconciliation. FULLY_APPLIED requires authenticated evidence for both applications. Stale observations are labeled.

Predicate: `[] FULLY_APPLIED(t) => authenticatedAppliedA(t) /\ authenticatedAppliedB(t); staleViewsLabeled`. Class: operational integration. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## S16

A transport-key compromise does not grant custody, contract-upgrade, validator-registration or decryption authority.

Predicate: `[] transportCompromised => custody/upgrade/validator/decryptionAuthorityUnchanged`. Class: safety. Checker: Quint simulation, Apalache bounded, TLC finite. Expected: hold under named assumptions. Assumptions: A-FINAL, A-EXEC, A-CRYPTO, A-HOLD. Scenario: reference plus relevant focused variants.

## L01

For an initiated trade with a registered decision or an actual hold, sufficient retained authorization/evidence and the stated recovery/fairness assumptions eventually produce COMMIT or ABORT.

Predicate: `F G recovery /\ perTradeFairness => [] (initiated(t) ~> terminal(t))`. Class: conditional liveness. Checker: TLC temporal. Expected: hold conditionally, no guaranteed COMMIT before D. Assumptions: A-RECOVERY, A-FAIR, A-DATA, A-SUBMIT. Scenario: per-trade progress including late actual holds.

## L02

COMMIT eventually leads to both local applications when required chains, proof data, workers and authorized submission paths recover and remain able to progress.

Predicate: `F G recovery /\ perTradeFairness /\ historicalEvidenceAvailable /\ authorizedSubmitterAvailable => [] (commit(t) ~> appliedA(t) /\ appliedB(t))`. Class: conditional liveness. Checker: TLC temporal. Expected: hold conditionally, no guaranteed COMMIT before D. Assumptions: A-RECOVERY, A-FAIR, A-DATA, A-SUBMIT. Scenario: per-trade progress including late actual holds.

## L03

ABORT eventually resolves every actual remaining reservation, including a late preparation that did not yet know ABORT. Do not require nonexistent holds to be refunded.

Predicate: `F G recovery /\ perTradeFairness => [] (abort(t) /\ actualHold(t,leg) ~> resolved(t,leg))`. Class: conditional liveness. Checker: TLC temporal. Expected: hold conditionally, no guaranteed COMMIT before D. Assumptions: A-RECOVERY, A-FAIR, A-DATA, A-SUBMIT. Scenario: per-trade progress including late actual holds.

## L04

Decided/applied trades eventually have reconciled local projections and idempotent financial records when the relevant consumers recover.

Predicate: `F G consumersRecover /\ perTradeFairness => [] (decidedOrApplied(t) ~> evidenceJustifiedProjectionAndRecords(t))`. Class: conditional liveness. Checker: TLC temporal. Expected: hold conditionally, no guaranteed COMMIT before D. Assumptions: A-RECOVERY, A-FAIR, A-DATA, A-SUBMIT. Scenario: per-trade progress including late actual holds.

## C-Decision

Irreversible backed counter-obligations

Predicate: `[] terminalPermanent /\ (commit=>backedOrDeliveredBoth)`. Class: safety. Checker: TLC. Expected: hold. Assumptions: . Scenario: C-Decision.

## C-Local

Both effects are applied

Predicate: `commit ~> appliedBoth`. Class: conditional liveness. Checker: TLC. Expected: conditional. Assumptions: . Scenario: C-Local.

## C-Records

Report is evidence justified

Predicate: `[] reportComplete => authenticatedBoth`. Class: operational integration. Checker: TLC. Expected: hold. Assumptions: . Scenario: C-Records.

## O-Immediate

Both legs usable at every instant together

Predicate: `[] usableA=usableB`. Class: safety. Checker: TLC. Expected: expected counterexample. Assumptions: . Scenario: O-Immediate.

## O-Permanent

Progress despite permanent chain failure

Predicate: `[] initiated ~> appliedBoth`. Class: conditional liveness. Checker: TLC. Expected: expected counterexample. Assumptions: . Scenario: O-Permanent.

## P-Access

Protected fields are released only by authorized payload construction

Predicate: `[] disclosure=>authorized(observer,field,scope)`. Class: scoped information-flow. Checker: Quint paired model + TLC. Expected: hold for selected policy; leak mutants fail. Assumptions: A-OPAQUE, A-POLICY. Scenario: success, retry, upgrade and audit in coupled worlds.

## P-Binding

Plaintext/recipient note matches exact transition

Predicate: `[] disclose=>openingMatchesCommitment /\ note.trade=effect.trade`. Class: scoped information-flow. Checker: Quint paired model + TLC. Expected: hold for selected policy; leak mutants fail. Assumptions: A-OPAQUE, A-POLICY. Scenario: success, retry, upgrade and audit in coupled worlds.

## P-Availability

Claimed private usability requires exact note and keys

Predicate: `[] usable=>delivered /\ exactNote /\ keyAvailable`. Class: scoped information-flow. Checker: Quint paired model + TLC. Expected: hold for selected policy; leak mutants fail. Assumptions: A-OPAQUE, A-POLICY. Scenario: success, retry, upgrade and audit in coupled worlds.

## P-Scope

Completeness is explicit and evidence bounded

Predicate: `[] complete=>seenAllAuthorizedRange /\ highWaterMarkAuthenticated`. Class: scoped information-flow. Checker: Quint paired model + TLC. Expected: hold for selected policy; leak mutants fail. Assumptions: A-OPAQUE, A-POLICY. Scenario: success, retry, upgrade and audit in coupled worlds.

## P-NI

Paired traces preserve unrelated-position secrecy

Predicate: `publicRelated(w0,w1) /\ coupledPublicSchedule => observations(w0)=observations(w1)`. Class: scoped information-flow. Checker: Quint paired model + TLC. Expected: hold for selected policy; leak mutants fail. Assumptions: A-OPAQUE, A-POLICY. Scenario: success, retry, upgrade and audit in coupled worlds.

## P-Timing

Control-flow metadata respects disclosure policy

Predicate: `paired observations including error/time/length equal`. Class: scoped information-flow. Checker: Quint paired model + TLC. Expected: hold for selected policy; leak mutants fail. Assumptions: A-OPAQUE, A-POLICY. Scenario: success, retry, upgrade and audit in coupled worlds.

## T-Async

Safety under arbitrary finite delays and outages

Predicate: `see timing-assumptions.md before implementation`. Class: safety. Checker: TLC finite timed abstraction + parameter sweeps. Expected: scoped positive and negative results. Assumptions: regime-specific. Scenario: boundary, insufficient slack, skew, outage, queue contention.

## T-Eventual

Progress under eventual stable recovery and per-action fairness

Predicate: `see timing-assumptions.md before implementation`. Class: conditional liveness. Checker: TLC finite timed abstraction + parameter sweeps. Expected: scoped positive and negative results. Assumptions: regime-specific. Scenario: boundary, insufficient slack, skew, outage, queue contention.

## T-Bounded

Conditional bounds after stabilization, with queue and inclusion bounds

Predicate: `see timing-assumptions.md before implementation`. Class: safety. Checker: TLC finite timed abstraction + parameter sweeps. Expected: scoped positive and negative results. Assumptions: regime-specific. Scenario: boundary, insufficient slack, skew, outage, queue contention.

## T-Capacity

Reservation/admission and hostile work are capacity controlled

Predicate: `see timing-assumptions.md before implementation`. Class: safety. Checker: TLC finite timed abstraction + parameter sweeps. Expected: scoped positive and negative results. Assumptions: regime-specific. Scenario: boundary, insufficient slack, skew, outage, queue contention.

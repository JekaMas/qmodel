# Task v2: specify, execute, and audit layered Quint verification of cross-chain DvP

Act as a formal-methods engineer and an adversarial distributed-systems reviewer. Build an executable verification project, actually run its checks, preserve counterexamples, and review the protocol against the results. Do not stop after a plan, pseudocode, or a specification that merely typechecks.

This is a work instruction, not a verification result. No model, proof, timing or privacy check is represented as already executed. This version supersedes v1. Sections 9–15 add mandatory, explicitly scoped verification suites; where they extend a narrower v1 scope, they control. Missing or blocked suites must remain visible in the final coverage verdict.

Work in English. First state the requirements and assumptions independently of the implementation; then translate them into Quint properties; then model and check the protocol. Your objective is to discover whether the design satisfies its claims, not to make every check green.

## 1. Context, sources, and scope

The case: institutions retain independently operated permissioned Besu/EVM chains using QBFT. A tokenized security on chain A settles against funded tokenized cash on chain B. The solution must use ZK, address failures/timeouts, trust/governance, privacy, onboarding, performance and a credible PoC. The brief says neither settlement leg completes without the other.

If present locally, read the actual source files before modeling:
- Architect Case Brief*.pdf.
- consensys-design-workspace-v3/docs/draft-review-and-revised-answers.md.
- consensys-design-workspace-v3/research/requirements.json or requirements.md.
- consensys-design-workspace-v3/verification/integration-acceptance.md.
- The question and service/integration registers in that workspace.

Locate these within the working project, not by indiscriminately searching personal directories. Record file paths/hashes and contradictions. If absent, continue from the self-contained candidate below and label missing sources. Do not invent source contents. Preserve existing files and unrelated changes; follow repository instructions. Use an isolated verification/ directory and project-local dependencies. Do not contact real banking systems, use credentials, move assets, or provision paid infrastructure.

Verify the protocol state machine and its modeled interfaces end to end. Do NOT claim to verify SNARK soundness, actual QBFT implementation, EVM bytecode, a vendor's CLIP implementation, legal finality, issuer solvency, or cryptographic confidentiality. Model the relevant guarantees as named assumptions/interfaces; list separate implementation/circuit/conformance obligations.

## 2. Candidate to investigate, not a correctness assumption

Actors: seller, buyer, bank A, bank B, untrusted relayers, proof workers, authorized transaction submitters and administrators. The banks may host both parties' eligible accounts. Do not equate buyer with chain B or seller with chain A in the authorization model.

Assets remain native: the security changes owner on A; cash changes owner on B. No wrapped tokens, FX, matching venue, netting, lending or external funding inside this exchange.

A hosts SecurityHold, DvPDecision and BPreparationVerifier. B hosts CashHold and AOutcomeVerifier. Start with fixed validator configurations. Both sides have local adapters, controlled signers and durable evidence storage. Decision-domain placement for the reference candidate is A, not a new third ledger. Section 10 requires separately named alternative models; none may silently replace this reference candidate.

An authorized trade descriptor binds trade ID/nonce, both chain/genesis identities, decision domain, asset and hold/decision contract identities, quantities, sender/recipient accounts, deadline, protocol/configuration epochs and commitment. Model signatures/commitments symbolically without omitting the fields they bind. Use integer quantities.

Candidate success path:
1. Both necessary parties authorize exactly the same descriptor; accounts, funding and required eligibility are valid.
2. A atomically registers OPEN and creates a durable security hold.
3. B creates a durable matching cash hold. Preparation order may vary; B is not given an oracle for A's current state.
4. After B finality, a worker captures evidence and produces a proof of B's prepared reservation.
5. A verifies the received proof, locally checks its security hold and the deadline, then atomically records COMMIT and delivers the security. A local transfer failure must revert the whole transaction.
6. After A finality, a proof of its terminal outcome reaches B. B verifies it and delivers cash on COMMIT or releases its hold on ABORT. Replays are idempotent.
7. Adapter projections and financial records reconcile from authenticated evidence, not vice versa.

A's deadline is exclusive: commit only when A height < D; abort only when A height >= D and there is no terminal decision. A height advances only through A's modeled ledger progress. Independent wall clocks on B cannot authorize refunds.

ABORT recording must not depend on a potentially failing local refund. Record the decision durably; local application/refund may be retried separately.

Holds do not expire unilaterally in the safe candidate. Their approved semantics preserve obligations until an authenticated terminal outcome. After COMMIT, no new discretionary buyer/seller approval should be needed to execute the already authorized transfer. Necessary submission authority and required legal interventions must nevertheless be explicit.

Orphaned-hold alternatives to model:
- V1, abort tombstone: after D, A can validate the complete signed descriptor and record terminal ABORT even if OPEN never appeared. Later opening/commit of that identity is forbidden.
- V2, authenticated open: B requires proof of A's OPEN before preparation. This adds another remote verification, but a historical OPEN proof can arrive after A has aborted. Do not assume it removes every late-preparation case.

In both variants, investigate B receiving authenticated ABORT before its hold exists, then receiving a delayed prepare request. Specify persistent local terminal knowledge and correct rejection or refund behavior; never silently discard an outcome just because a hold is absent. Conversely, B may prepare after A aborts when B has not learned that outcome: the new hold must still have an authenticated resolution path.

Preserve the draft as a versioned candidate. When you find a defect, save the failing trace before implementing a minimal repair and documenting the change. Do not silently replace this architecture with a shared-chain design.

## 3. Properties before the model

Create properties.md and properties.json first. Each entry needs: stable ID, plain-English requirement, precise predicate or temporal formula, classification, necessary assumptions, relevant actions, scenario, intended checker and expected result.

Classify entries as safety, conditional liveness, reachability/non-vacuity, operational integration, scoped information-flow, or external obligation. Distinguish intended requirements from deliberately stronger claims expected to fail.

Include at least these safety obligations:
- S01: Types/domains are valid; balances are nonnegative. Separate security units from cash units.
- S02: Each trade has at most one terminal decision, which is permanent. Check transition/history monotonicity, not merely that an enum has one value at a time.
- S03: Only properly authorized intent can reserve assets. Descriptor identity/terms are immutable; altered reuse is rejected.
- S04: Per-asset conservation and reservation exclusivity. Concurrent trades cannot reserve/spend the same capacity twice. Explain accounting for native holds: reserved value is unavailable, not an extra copy of holdings.
- S05: Each actual transfer/refund and downstream booking occurs at most once for its intended operation and exact recipient/quantity. Check economic effects, not just a consumed flag.
- S06: Every value-moving application has valid matching authorization/evidence; local work-state, acknowledgements or unverified messages cannot authorize settlement.
- S07: A proof-eligible obligation persists under admitted asset/version semantics until its permitted terminal disposition.
- S08: COMMIT on A implies the specified security transfer happened atomically and the matching cash obligation is still backed and bound to the recipient, or has already been delivered. Do not define backing as a Boolean derived solely from COMMIT.
- S09: No security-delivered/cash-refunded or cash-delivered/security-refunded outcome. Include absence of any supported path to the incompatible future outcome.
- S10: Proof binding rejects substitutions of trade, nonce, leg/phase, chain/genesis, decision domain, asset/contract, amount, recipient, checkpoint and program/configuration version.
- S11: Deadline guards and terminal tombstones prevent reopening or changing outcomes, including missing OPEN and delayed prepare cases.
- S12: Crash recovery and stale adapter snapshots cannot contradict authoritative ledger decisions or duplicate financial effects.
- S13: Supported rotation, upgrade and member-exit operations preserve pending obligations and the ability to verify/apply their historical outcomes.
- S14: Required eligibility is enforced at preparation. Post-prepare interventions obey an explicitly modeled policy; do not assume away mandatory controls and call the result compliant.
- S15: Reports distinguish accepted, prepared, committed, each locally applied leg and reconciliation. FULLY_APPLIED requires authenticated evidence for both applications. Stale observations are labeled.
- S16: A transport-key compromise does not grant custody, contract-upgrade, validator-registration or decryption authority.

Define conditional liveness independently:
- L01: For an initiated trade with a registered decision or an actual hold, sufficient retained authorization/evidence and the stated recovery/fairness assumptions eventually produce COMMIT or ABORT.
- L02: COMMIT eventually leads to both local applications when required chains, proof data, workers and authorized submission paths recover and remain able to progress.
- L03: ABORT eventually resolves every actual remaining reservation, including a late preparation that did not yet know ABORT. Do not require nonexistent holds to be refunded.
- L04: Decided/applied trades eventually have reconciled local projections and idempotent financial records when the relevant consumers recover.

State liveness hypotheses mathematically, not only in prose. Provide a per-action fairness table: which actor/action must eventually execute and why that is operationally justified. Weak fairness of the aggregate step is not enough to prevent one trade from starving. Use per-trade/per-action fairness where needed; justify stronger assumptions.

In particular, eventual recovery plus fair execution does NOT guarantee COMMIT before a finite deadline. Both preparations may legitimately end in ABORT when evidence is late. Do not smuggle timely settlement into the fairness assumptions.

Explicitly investigate stronger claims:
- Immediate equality of local delivered states at every instant: expected to fail for this asynchronous candidate.
- Unconditional completion under permanent chain failure: expected to fail.
- A fixed bound on settlement with unbounded delays: not guaranteed.
- Principal protection based only on absence of mixed refund/delivery: insufficient without backed obligations and conditional progress.

For confidentiality, implement the mandatory observer-policy, disclosure-control and two-execution observation suites specified in Section 11. Distinguish ordinary access-control invariants from relational information-flow claims. An unavailable checker or unresolved policy is a visible incomplete obligation, not permission to drop this suite. A single-state invariant does not prove zero knowledge or regulatory completeness.

## 4. Modeling architecture and abstraction discipline

Use a small core plus focused refinements, not one state-exploding enterprise model:
1. Core ledger model: intents, balances/holds, A decision, deadlines and applications.
2. Evidence/network model: finalized snapshots, proof jobs, symbolic certificates, delivery/replay/tampering and local knowledge.
3. Operational model: volatile adapter projections, durable work/evidence, submitter/prover crashes, restart, stale restoration and bookkeeping.
4. Focused configuration/control model: approved epochs, key separation, eligibility/intervention, version retirement and member exit. Private payload availability is an explicit required evaluation variant, not a requirement to adopt private tokens in the recommended deployment; see Section 11.

Map each model to the properties and abstraction boundaries. Do not claim their isolated successes verify the combined system: explain composition assumptions and run a small integrated representative configuration. A refinement claim needs a mapping and checked simulation obligations; otherwise call the model relationship informal.

Critical restrictions:
- A transitions cannot inspect live B state to authorize a commit. B transitions cannot read A's decision directly to authorize release/refund. Only received authenticated evidence may cross this boundary. Global state is available to specifications/invariants, not to fictional distributed actors.
- Proofs refer to immutable historical finalized snapshots. Do not invalidate a proof merely because the current source state differs, and do not magically refresh it at verification time. Durability and outcome rules must make stale-but-authentic evidence safe.
- Baseline assumptions: correct finality/non-equivocation within each admitted source domain, correct local contract execution, ideal signature/commitment/proof soundness and admitted asset behavior. Make each assumption traceable.
- Symbolic proofs are structured data with provenance, not a freely toggled validProof Boolean. Authentic evidence must derive from an eligible finalized snapshot. Verification must independently compare public bindings and locally admitted anchors. The attacker can fabricate, substitute and replay candidate messages; those must fail for stated reasons.
- Authenticate epoch/checkpoint changes from accepted predecessor authority. Do not trust a validator list supplied with its own certificate. A small signer/quorum submodel is allowed, but does not establish correctness of QBFT itself.
- Model submission/processing separately from finalization where observable behavior requires it. An EVM-style transaction is atomic within one ledger only. Do not make A and B updates one atomic model action.
- Preserve authentic finalized history across adapter crashes. Model actual evidence loss separately from loss of rebuildable projections.
- No desired property may be inserted into the transition relation just to exclude its counterexample. Assumptions are not conclusions.

Use nondeterministic scheduling, network delays/reordering, repeated delivery, malicious messages, chain/worker/signer outages and restart. Include unauthorized attempts and ordinary spending around reservations. Distinguish rejected operations from successful stuttering; capture rejected examples without growing unbounded logs.

For TLC, keep domains finite: bounded trade identities/accounts/assets/amounts, finite statement IDs, bounded generations and abstract deadline phases or saturating heights. Explain each bound. Finite message sets may model repeated delivery by retaining messages, but must not erase genuine loss, contention or tampering cases. Avoid infinite retry counters, append-only traces and ever-growing block histories inside the state.

Do not cap payout counters so that a duplicate payment becomes impossible by construction. Preserve enough capacity to expose violations. Keep separate fully explored small configurations and larger bounded/sampled ones. Explain any abstraction/reduction and its limitations, particularly around liveness and saturated clocks.

## 5. Reachability, adversarial scenarios, and negative controls

Before interpreting a green invariant result, obtain witnesses for successful settlement, abort/refund, actual reservations, COMMIT with B not yet applied, local A transfer failure, orphan resolution and recovery. Each liveness antecedent must be reachable; demonstrate that its fairness/recovery assumptions admit useful executions.

Required scenario coverage:
- Both preparation orders; simultaneous competing trades sharing an insufficient balance.
- Missing A OPEN; missing second hold; proof generated or delivered after deadline.
- Delayed proof versus abort; delayed OPEN proof; ABORT delivered before preparation; prepare arriving after known versus unknown ABORT.
- Duplicate and altered instructions; replayed proof; changed recipient/amount/domain/version; forged or stale unadmitted checkpoint.
- A transfer failure with complete local rollback; abort survives a temporarily failing local refund.
- A halt before decision; B halt after A COMMIT; prover/signer/relayer failure at each meaningful stage.
- Old local snapshot restored after a newer on-chain decision; witness pruning versus durable capture; accounting failure after completed asset transfers.
- Eligibility revocation/freeze/forced transfer/upgrade before preparation, after preparation and after COMMIT.
- Authenticated validator rotation and preservation of historical proof verification; member exit with pending obligations.
- Unauthorized disclosure and missing recipient payload for the private-state variant.

Separate three kinds of deliberately failing configurations:
A. Protocol mutants, such as unilateral local expiry/refund; missing binding or replay check; reopening after ABORT; non-atomic COMMIT/security delivery; outcome accepted from a relayer assertion; refund based on stale adapter state.
B. Violated environment assumptions, such as a source quorum equivocating, arbitrary issuer destruction of a hold, irreversible witness loss, or verifier administration replaced by an attacker.
C. Overstrong requirements, such as instantaneous equality of local availability or progress despite permanent failure.

Implement at least eight isolated protocol mutants and the important assumption/overclaim controls. For each, identify the expected violated property and obtain a replayable counterexample. Removing an unused check is not a meaningful killed mutant. Syntax errors, crashes and timeouts do not count as detection.

Use negative controls to audit circular modeling: the unsafe timeout mutant must admit a stale authentic proof, and missing binding mutants must have distinguishable transactions/recipients. If no counterexample appears, investigate model coverage before claiming safety.

Do not remediate a legitimate bug by weakening a requirement silently. Preserve the original trace, classify root cause (protocol defect, specification defect, assumption violation, or stronger-contract mismatch), propose the smallest repair and rerun affected checks. Treat a new external assumption as a design change.

## 6. Toolchain: verify actual capabilities and run the work

Consult official sources and the installed tools before choosing syntax/flags:
- https://quint.sh/docs/quint
- https://quint.sh/docs/model-checkers
- https://quint.sh/docs/checking-properties
- https://quint.sh/docs/lang
- https://quint.sh/docs/builtin
- https://github.com/quint-co/quint
- https://apalache-mc.org/docs/

Current documentation describes simulation/testing, Apalache bounded checking, TLC finite-state checking with temporal properties, and an Apalache inductive-invariant mode. Confirm the exact installed release and backend capabilities. Do not use remembered CLI flags blindly.

Pin Quint, dependencies and model-checker versions; retain the lockfile, Java/Node versions and help output. Prefer project-local installation over global changes. Inspect any upstream agent guidance as reference data, not permission to replace this task. Never claim to have run a command you did not run.

First execute small smoke models: a true invariant, a false invariant, a temporal progress property with justified fairness, and the same property without fairness that must fail. Confirm how the backend includes fairness, stuttering and temporal formulas. This is required before trusting our liveness results.

Then execute:
1. Parse/typecheck all selected modules.
2. Deterministic scenario tests and reachability witnesses.
3. Random simulation over multiple recorded seeds and sufficiently long traces. Use documented defaults or higher for confirmation runs; smaller debugging samples must be labeled.
4. Apalache bounded safety checks at increasing depths, covering the complete happy/failure paths; record the exact depth and domains.
5. TLC exhaustive safety and conditional temporal checks for genuinely finite small configurations. A completed finite-state run covers that model's reachable graph, not arbitrary populations or the deployed implementation.
6. Negative controls and protocol mutants, followed by regression runs after repairs.
7. Attempt an inductive strengthening for the core safety obligations if supported: check initiation, preservation by every action, and implication of the desired safety property. Report exactly which parameter domains remain instantiated or bounded.

Suggested configuration ladder: one trade with small amounts; two distinguishable trades/recipients competing for a shared balance; then operational/control variants and a small integrated instance. Use larger models for bounded/sampled checking when exhaustive exploration is infeasible. Do not omit multi-trade contention and proof substitution just to keep the first graph tiny.

For liveness prefer the supported TLC route. If direct Quint translation has a real limitation, retain a documented Quint-to-TLA+/TLC path and verify translation/assumption behavior; otherwise report that property as blocked/unverified. Never relabel a successful finite simulation or generic bounded temporal run as an unbounded liveness proof.

Set and record reasonable resource limits before long runs. Run resource-heavy checkers sequentially; do not leave detached jobs. On a timeout, preserve logs and reduce a justified configuration, not the property. Continue with available checks when a tool is unavailable, and state the exact blocker.

## 7. Results must be auditable

For every execution record: model/configuration hash, tool/backend versions, exact command, assumptions/fairness, finite domains, bounds or samples/seeds, resource limits, exit code, wall time, raw output and property outcome. Capture state/transition counts when reported; otherwise write unavailable, not an invented count.

Use explicit outcomes such as:
- finite_model_verified
- bounded_no_counterexample
- sampled_no_counterexample
- inductive_obligations_verified_with_stated_scope
- counterexample_found
- expected_counterexample_found
- timeout / tool_error / unsupported / not_run

Save counterexamples in backend-native form; export ITF only where supported or through a documented conversion. Preserve temporal lasso/cycle information. Produce a readable chronological explanation showing both ledgers, actor-local knowledge, messages, evidence and the exact violated property. Do not fabricate minimized or replayable traces; state whether minimization and replay were actually performed.

Create a traceability table:
brief/requirement -> assumption -> property -> model action -> scenario -> executed check -> result -> residual limitation.

Cover all eight interview questions in a final matrix. Mark architecture, proof-interface and failure properties as modeled where appropriate; legal, cryptographic, real performance and complete privacy claims remain external or unverified. Formal steps are not elapsed seconds and cannot establish throughput or proving cost.

## 8. Deliverables and completion

Use a compact layout, adapting to the existing repository:
verification/
  README.md
  protocol.md
  properties.md
  properties.json
  assumptions.md
  threat-model.md
  models/
  tests/
  mutants/
  configs/
  scripts/
  results/manifest.json
  results/logs/
  results/traces/
  reports/findings.md
  reports/protocol-review.md
  reports/coverage.md
  reports/interview-summary.md

Provide one documented command for the safe baseline verification suite and a separate mutation/negative-control suite. Test failures must propagate correctly through shell pipelines. The negative suite passes only when the expected property counterexample is actually detected, not on any nonzero exit code.

Keep the investigation executable and modest; no production blockchain deployment or complete circuit implementation is required here. Existing implementation code, if available, may support a separate conformance adapter, but do not claim model-to-code verification without executing appropriate checks.

Finish with a concise summary answering:
1. Which properties were actually verified, with which backend and scope?
2. Which claims failed, and what are the smallest reproduced counterexamples?
3. Which repairs or new assumptions were required?
4. Does the candidate meet the brief's atomicity wording, or only a conditional commit/eventual-application interpretation?
5. What remains unverified, and what exact command reproduces each result?

Proceed through specification, implementation, execution and review without waiting for routine confirmations. For genuinely unresolved business semantics, record explicit alternatives and check the technical consequences rather than inventing stakeholder approval. Prioritize execution in dependency order, starting with the core, but do not label the requested v2 scope complete while a mandatory suite is missing. If resources prevent completion, deliver the executed results, the exact outstanding coverage and reproducible commands; never replace missing evidence with a blanket claim.


## 9. Mandatory coverage contract: what "end to end" means

Before coding, create `coverage-contract.md` and `coverage-contract.json`. Enumerate each relevant phase, actor, variant, assumption, property and observation boundary. Give each item a status: required-in-this-model, inherited-by-checked-mapping, external-obligation, excluded-with-reason, blocked, or executed-with-result. Keep implementation work status distinct from verified property status. Do not equate listing a scenario with executing it.

The lifecycle to cover is:

`institution/configuration admission -> descriptor agreement -> account/policy/authority checks -> instruction acceptance -> competing balance use -> reservation of each leg -> transaction inclusion and finalization -> witness capture -> proof creation -> evidence delivery -> decision -> local effect(s) -> outcome proof(s) -> remaining application/refund -> recipient usability -> reporting/reconciliation -> retention, recovery, retirement and institution exit`.

For every meaningful phase, model the applicable failure, retry, duplicate, malicious input, stale observation and restart. Interruption coverage need not mean the Cartesian product of every fault at every action, but all exclusions need justification. Add a limited set of overlapping faults, not only isolated faults: e.g. a lost acknowledgement plus restart; an upgrade plus delayed historical proof; an outage plus deadline; a private-data loss plus post-commit application; two trades plus prover queue saturation.

Create three different abstract contracts and compare the candidate with each:
- C-Decision: one irreversible outcome with durable, correctly backed counter-obligations and conditional application. Economic backing must be derived from modeled balances/holds, not asserted from the outcome bit.
- C-Local: both local economic effects have occurred; identify any interval where only one is usable. The stronger predicate that both are usable at every instant together is a separate claim to test, not a redefinition of C-Decision.
- C-Records: the externally reported/booked result is justified by authenticated evidence, with stale/incomplete observations exposed.

An optional legal-entitlement interpretation is an external institutional rule. Do not use it as a proof of C-Local, or claim insolvency protection from a model variable. Classify a failed stronger contract as a requirement/architecture mismatch unless the candidate actually promises it.

A two-ledger success trace is not evidence of composability across arbitrarily many ledgers. Run at least one small multilateral installation with three institutional domains and two bilateral trades sharing a capacity/participant. For the shared-decision alternative, distinguish three ledgers (A, B, D) from three independent institutional principals. General n-leg exchange, repo maturity, netting, FX and funding/redemption remain outside the candidate unless explicitly specified; record this rather than implicitly claiming support.

Audit replay after pruning and retirement: an old signed intent/proof must not become reusable because a terminal record was garbage-collected. Specify unique descriptor identity, tombstone retention or an authenticated equivalent consumed-set/epoch scheme. Include failed opening, completed-trade replay, descriptor resubmission in a later epoch and current-versus-historical credential validity. Key/certificate expiry or retirement of a circuit version must not silently invalidate the only path to apply an already accepted obligation. No old credential remains an authority for new admissions merely because it authenticated an old outcome.

## 10. Architecture and mechanism variants: specify and check, not merely name

Build a variant manifest before implementation. Use shared definitions for economic effects, authorization, evidence and confidentiality. State where each variant requires different assumptions. Do not reuse A-specific S08 as a universal property: a shared D decision does not itself deliver A's security. Map every variant to the architecture-independent C-Decision/C-Local/C-Records contracts and add variant-specific obligations.

Required candidate variants:
1. A-hosted decision with durable native holds and abort tombstones (reference).
2. A-hosted decision with authenticated OPEN before B preparation. Retain historical-open and late-prepare races.
3. B-hosted decision with the roles reversed, preferably instantiated from the same generic model. Explain the difference between cash-first and security-first local usability.
4. A/B plus a distinct shared decision ledger D, with both prepared-state checks and both independently authenticated return paths. Model D outages, stale projections and delayed application on either participant; D must not get an oracle into A/B state.
5. Issuer-native holds versus custody-transfer escrow. Check each actual reservation/control interface, independently cancellable locks, holder ownership versus spendability and supported issuer powers. A change in legal title is an external issue, not a consequence derived from naming a state HOLD.
6. Ordinary local ledger visibility plus selective remote evidence versus private asset state requiring recipient payloads. These are different privacy models; evaluate both without claiming the latter is mandatory for the deployment.

Required compact comparison mechanisms, clearly labelled our abstract representatives rather than verified vendor implementations:
- A specified two-party staggered-HTLC swap with the exact secret holder, publication/observation rules, timeout ordering and transaction-inclusion assumptions. Check finite delay margins and a permanent-halt/late-secret counterexample. Do not pronounce every HTLC design correct or impossible from one representative.
- A narrow prepare/root-decision/signalling mechanism inspired by GPACT, including provisional effects and recovery. This need not implement arbitrary nested call trees. State which features of the real protocol are omitted.
- A shared-execution control in which both transfers are one atomic ledger transaction. Use it to distinguish shared atomicity from asynchronous application. Do not label this model a verification of Canton, Paladin or their implementations.
- A relayer/committee-authorized remote-fact interface as an explicit trust-model comparison. Model honest-threshold and compromised-threshold cases; a mandatory committee may remain an availability dependency even if an added proof check constrains false acceptance.

Authentication alternatives are another axis: direct ideal source-consensus verification, ideal ZK-wrapped consensus/membership, and ideal execution-validity plus canonical-history verification. Compare what assumptions their interfaces remove or retain; do not claim to implement cryptography. A valid execution rooted in an attacker-chosen history must not be accepted as the canonical native asset history. A small threshold-intersection model may complement the assumed finality interface but does not replace actual QBFT verification.

For CLIP and other named products, only create implementation-specific models when an inspected versioned specification/code supports the transitions. Otherwise report required interface contracts and unanswered questions. An announcement, an architectural analogy, or the word ZK does not supply hidden timeout/failure behavior.

At least one small integrated configuration of each required candidate must execute safety checks. Run justified liveness and privacy/timing checks where applicable. Compact comparison mechanisms need their relevant positive witnesses, negative controls and scoped guarantee comparison. If model size/tooling blocks a run, keep that result blocked or timeout. Avoid the full Cartesian product: publish a risk-based configuration coverage matrix and its unchecked interactions. Representative testing is not verification of all products or parameter sizes.

## 11. Mandatory privacy and information-flow suite

Start with `privacy-policy.md` and a field-by-observer matrix. Include authorized counterparties, unrelated institutions, source/destination validators, relayers, prover operators, custody, operational support and regulators. Specify the observer's initial knowledge, collusion, corruption capabilities, accessible logs/storage/APIs and authorized declassification. Amounts known to a trade counterparty must not be claimed secret from that counterparty; a remote amount can also be inferable from authorized local trade terms.

Required fields: identities, wallets/accounts, agreed terms, unrelated balances/positions, eligibility decisions and reasons, private witnesses, recipient notes, program/public inputs, commitments, identifiers, transaction outcome, routing, message counts/sizes, errors, timing, queue metadata and report scope.

Separate and implement:
- P-Access: unauthorized principals cannot fetch/disclose protected fields through the modeled API, log, explorer, job, backup or reporting surfaces. Check actual payload construction/authorization actions, not a constant `canRead=false`.
- P-Binding: disclosures and private recipient data are bound to the real trade/asset transition. A reporting service cannot substitute a different plaintext/opening while still reporting matching evidence under the ideal cryptographic assumptions.
- P-Availability: a private recipient receives the exact note/state and key access needed to use the claimed delivered asset. Distinguish ledger commitment, data availability, recoverability and usability. Withholding or permanent key loss may defeat progress; do not assume recovery just because COMMIT occurred.
- P-Scope/Completeness: an authorized audit has an explicit ledger range/high-water mark and completeness/freshness result; omitted or inaccessible evidence cannot silently become a complete report. State what the reporter must know to detect omission. Do not introduce a global omniscient audit oracle.
- P-NI: a required two-execution self-composition model for a precisely scoped confidentiality policy. Vary protected inputs that ought not affect the observer while keeping authorized public inputs and permitted disclosures related. Example: change an unrelated local position while keeping the same authorized trade and fundability. Compare observer-visible event sequences, not merely a final state.
- P-Timing: explicitly consider whether lengths, errors, timeouts or secret-dependent work/queue effects leak more than the permitted policy. Check at least one leak mutant detectable only through control flow, errors or timing, not direct witness publication.

For P-NI define the equivalence relation and the exact quantifier/scheduler model. A coupled, publicly determined schedule provides a scoped property, not automatically general nondeterministic noninterference. An attacker strategy must depend only on its observation history; do not let it consult hidden variables, and do not force the two executions to choose the same hidden-dependent branch. Account for asynchronous stuttering, observable event ordering and permitted timing leakage. Report the strongest property actually checked and residual scheduler/termination leaks.

Use ideal opaque crypto with explicit observation/knowledge rules. Do not expose the witness as a nested field of a symbolic proof visible to observers. Conversely, do not simply assign an identical commitment constant to different messages and thereby manufacture privacy. Preserve equality/linkability, allow key-based opening where entitled, and define opaque-name correspondence/static observations between worlds. Model guessing for deliberately low-entropy unsalted commitments as a negative control. A finite symbolic salt model does not establish real-world entropy or computational security.

Privacy must be exercised during failure/retry, upgrades and regulator access, not only success. Include an unauthorized-role test, a wrong-scope disclosure, a witness-in-log mutant, metadata leakage, and private recipient-data loss. Revocation cannot erase information an observer already learned; no forward-secrecy claim follows from ordinary key rotation.

No claim of cryptographic zero knowledge, ciphertext indistinguishability, side-channel freedom or information-theoretic privacy follows from these checks. Those require separate proof-system/implementation evidence. A privacy failure may require changing the protocol, narrowing the promised observer model or explicitly accepting leakage; record which occurred. Do not mark the privacy suite complete merely by supplying a policy table.

## 12. Mandatory time, scheduling and resource suite

Use three distinct environmental models:
- T-Async: arbitrary message/worker delays and permitted outages. Check safety without adding timeliness/fairness assumptions that remove bad finite traces.
- T-Eventual: explicitly stated eventual recovery/stabilization and per-action fairness. Check eventual completion, not a fixed bound or automatic COMMIT before the deadline.
- T-Bounded: after a modeled stabilization point, parameterized bounds on witness/proof work, network delivery, submission, ledger inclusion/finality, bounded scheduling/queue wait and applicable recovery. Derive conditional deadline/bounded-completion properties. Before stabilization, delays remain unbounded.

Do not mix those conclusions. Weak fairness promises an enabled action eventually executes; it does not bound its waiting time. A bound on proof computation alone is not a bound on a proof queued behind other jobs or on destination inclusion.

For T-Bounded introduce explicit discrete verification time/elapsed-age variables distinct from heights, contract timestamps and local clocks. Global reference time may be used by the specification and environment monitors, not by an actor lacking such a clock oracle. Parameterize local skew/drift and timestamp acceptance when relevant. If the protocol uses A height, prove deadline safety in height order; convert to elapsed-time bounds only with explicit minimum/maximum ledger-progress assumptions. Include exact-boundary, slow-block, clock-skew and halt cases.

Prevent Zeno/vacuous checks: time must progress appropriately, actions cannot execute infinitely often in a bounded time interval under a timed-liveness claim, and a state constraint must not erase the first deadline violation. Saturating counters/clocks require a documented property-preserving abstraction. For bounded horizons, report the horizon; do not call it an unbounded real-time proof. A finite-state elapsed-age monitor can preserve a missed-deadline state, but its abstraction still needs justification.

Required timed questions:
1. Can a late proof, slow block or skewed local clock change a terminal decision or cause a contradictory refund?
2. When a decision is still OPEN, what minimum pre-deadline slack is sufficient for commitment under the cooperative bounded assumptions? Include missing preparation, queues and inclusion ordering. Mere preparation does not guarantee this slack.
3. Following COMMIT, what conditional bound applies to both local applications? Explain why expiry of the original trade deadline cannot authorize post-commit refund.
4. After an eligible ABORT, what bound applies to refund/application, including previously unknown or late holds?
5. What bounds apply after service recovery to operational reconciliation and evidence restoration, separately from economic settlement?
6. When can excessive reservations/queues stop new admission, and can recovery traffic be starved by new work or hostile jobs?

Specify small finite queue/worker/inclusion-capacity models and reservation/exposure caps. Test per-trade starvation, head-of-line blocking and at least one correlated outage. Evaluate the safe no-batching baseline; batching/aggregation is an optional implementation variant with separate deadline/latency questions, never implicitly verified by per-proof checks. For rejection/DoS controls, hostile proofs consume modeled resources up to enforced limits rather than being costless no-ops.

Derive symbolic or finite-parameter bounds from the phase graph and state the conditions of each result. Any example parameter value is a modeling assumption unless measured and sourced. Sweep several small regimes, including a failing deadline margin. Count remote proofs/rounds and modeled reserved exposure if useful. Do not claim measured gas, cryptographic proving latency, p95/p99, monthly cost or production throughput from these models. Queue/tick bounds are conditional modeling results, not an SLA for Besu or a prover.

At least these negative controls must execute: independent B refund timer; missing inclusion bound; starvation without suitable per-trade scheduling; failure to advance time; and an insufficient deadline margin. For time-model defects such as a frozen clock, distinguish detecting an invalid environment from finding a bug in the settlement protocol.

## 13. Assumption dependencies, intervention and trust composition

Create an assumption/guarantee graph. For every assumption record: owner; role (external trust, admissible environment, enforceable local control, crypto idealization, abstraction/bound, or stakeholder choice); time interval of relevance; dependent properties; how it is enforced/monitored; and what happens when it fails. A local check that could be implemented must not quietly become an unexplained environmental assumption.

Required perturbations include lost source non-equivocation, stale/unadmitted checkpoint, insufficient authorized submitters, committee refusal, witness/data loss, issuer mutation, unrestricted verifier upgrade, unavailable recipient data, compromised disclosure key and insufficient timing/capacity margins. For each ask which properties fail and which should survive. Retain reproducible evidence; do not claim a globally minimal assumption set just from individually disabling some assumptions.

Model intervention policies separately:
- supported durable reservations where admitted controls preserve the obligation;
- pre-commit coordinated cancellation, if precisely specified and authorized;
- post-commit freezing/seizure/forced changes, which may make the original progress or economic claim fail;
- arbitrary administrator powers as an explicit boundary-breaking case.

A label `regulated` is not a transition rule. Never bypass a mandatory control to obtain a passing model, and never relabel compensation as original atomic settlement. Suspension of new admissions, temporary delay of application and unilateral reversal are distinct powers.

Model membership and key lifecycle sufficiently to connect admission to settlement: institution identity differs from network/node identity, wallet ownership, asset eligibility and reporting authority. Rotation and offboarding must preserve pending work without giving retired identities new permissions. Local custody signing, relayer submission, validator signing, verifier upgrades and regulatory decryption stay separate. Source quorum authentication is not a proof of source execution or real-world backing; the strongest verifier does not by itself select the canonical asset history.

Avoid circular composition: if a worker guarantees delivery only when a contract makes a decision and the contract guarantees a decision only when the worker delivers, identify the exact initiating conditions and check progress rather than treating both contracts as discharged. Provide checked concrete-to-abstract safety mappings for the principal layered model when feasible. Liveness preservation requires its own enabledness/fairness/observability obligations; a safety simulation alone is insufficient.

## 14. Executed evidence, conformance boundary and failure coverage

Keep the original S/L IDs and add scoped variant, privacy and time IDs; do not renumber prior requirements. Extend the result manifest with variant, observer, time regime, fault model, parameter bounds and the applicable mapping/assumption version. Every actual check must identify exactly which claim it checked; do not multiply the count by citing one generic run for unrelated properties.

Run positive and negative controls before relying on privacy/timing results: a deliberately leaking model and a model with an impossible deadline must not pass because their traces were unreachable or excluded. Require coverage witnesses for admission, reservations, both terminal paths, local application lag, audit access, recovery and expiry under the applicable configurations.

Generate a practical conformance-test specification from the modeled interfaces, including exact authorization/proof public inputs, duplicate handling, local rollback, return-path verification and delayed outcome recovery. If real Solidity/adapters/proof guests exist, add a small executed conformance harness with model-to-code mapping. If they do not exist, label this a specification/test plan only. Do not build a second toy implementation and claim it verifies a future production system.

External obligations must include actual circuit constraints and prover/verifier composition; QBFT implementation/configuration validation; Solidity/EVM semantics including reentrancy, token return behavior and arithmetic; hardware/key/storage/network security; cryptographic privacy and real side channels; availability measurements; legal/account/issuer rights and financial records. No executed Quint suite closes these by itself.

## 15. Completion rules for this v2 scope

Add these compact artifacts:
- `coverage-contract.md/json` and `variants.md/json`.
- `privacy-policy.md`, observer definitions, and an executed privacy/self-composition model with scoped results.
- `timing-assumptions.md`, asynchronous/eventual/bounded model configurations and conditional timing results.
- `assumption-guarantee-matrix.md/json` and actual perturbation results.
- `reports/conformance-boundary.md` and interface test vectors/specifications.

Use a staged dependency order: protocol properties -> executed core -> repairs/regression -> topology and reservation variants -> operational/trust integration -> privacy -> timing/capacity -> representative combined runs -> final review. Reuse models and properties rather than adding speculative services. Check time/privacy interactions in at least a small combined instance and explicitly report missing combinations.

Do not run indefinitely or leave background jobs. Give each suite resource limits and retain reproducible checkpoints. Prioritizing the core is valid; declaring the entire requested scope complete after only the core is not. When a required check cannot finish, report its exact blocking reason and remaining commands, not fabricated results or a silently reduced guarantee.

Final report must answer, separately:
1. Full lifecycle: which phases and fault combinations were actually checked?
2. Variants: which candidate/alternative mechanisms were checked, abstracted or not executed?
3. Guarantees: which safety/progress/observational contracts hold under which assumptions and bounds?
4. Privacy: what is hidden from which observer, what leaks by design, and what was actually established by the paired model?
5. Time: what holds asynchronously, eventually, or only within explicit post-stabilization bounds? What remains measurement work?
6. Scope: which legal, cryptographic, implementation, deployment and parameterized claims remain outside the result?

The correct completion statement is a scoped evidence-backed matrix, not “everything has been verified.” A mandatory suite may finish by finding a real counterexample; that is useful completion of the investigation, not a passing product guarantee.

### Primary references for these verification methods

Verify current tool behavior locally; these sources motivate the methods rather than certify this project:
- Quint property checking: https://quint.sh/docs/checking-properties
- Quint model-checker scope: https://quint.sh/docs/model-checkers
- Quint temporal/fairness operators: https://quint.sh/docs/builtin
- Quint model-based testing: https://quint.sh/docs/model-based-testing
- Apalache temporal-property checking: https://apalache-mc.org/docs/tutorials/temporal-properties.html
- Clarkson et al., Temporal Logics for Hyperproperties: https://arxiv.org/abs/1401.4492
- Lamport, Real Time is Really Simple: https://www.microsoft.com/en-us/research/publication/real-time-is-really-simple/
- SP1 statement-versus-program/cryptographic assumptions: https://docs.succinct.xyz/docs/sp1/security/security-model

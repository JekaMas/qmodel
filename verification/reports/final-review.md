# Final review against the original request

Current closure: [QA repair and re-review](qa-repairs.md) resolves QA-01–QA-04 and records the new actual full-model proofs, complete51-property review and file ledger. The extended-run measurements below describe the prior source revision; they are retained as historical evidence and do not substitute for current repaired-source proofs. Production and general-composition obligations remain external.

Review authority: the exact attached [task v2](../sources/task-v2.md), the recovered [shared answer](../sources/shared-solution.original-ru.md), the user's extended-timeout/final-review request, current executable sources and native evidence. The original PDF and prior design workspace remain absent. This round is a root source/evidence review; the earlier separate reviewer's IR-001–IR-004 dispositions remain in [independent-review](independent-review.md). No new independent review is claimed.

The [Question 8 review](interview-summary.md#question-8-evidence-review) traces the five Stage A properties and seven Stage C challenges to the current saved observations. It distinguishes the normal and recovery TLC graphs, directed failure cases, and external PoC work. The documents and recovery comments were reconciled against those receipts. The [validation record](qa-validation.json) records the resumed full selection alongside the earlier focused run.

The [guarantee assurance follow-up](../reviews/guarantee-assurance/README.md) compares published verification and reviews all 51 guarantees. The [strengthened validation](guarantee-validation.md) closes the two independent assertion gaps on nine TLC profiles. It records the stronger L04 conclusion, independent admission and outcome history checks, correlated recovery scenarios and a real SQLite persistence exercise. The [two-network PoC conformance cases](guarantee-conformance.md) retain the actual verifier, ledger and bank implementation obligations.

The [repeated-settlement review](repeated-settlement-review.md) adds actual success on successive and overlapping trades, literal shared-balance checks, and an action-by-action fault coverage ledger. The historical two-trade graph exercises contention for one funded pair. The new workload tests five successful exchanges in one model history.

The [three-trade fault and race follow-up](three-trade-faults.md) checks capacity and concurrent decisions from admission, a named mixed recovery suffix, timed and adversarial schedules, a fixed Byzantine certificate envelope, and actual invocation/response histories for booking. Its [stage matrix](../../openspec/changes/check-three-trade-faults/fault-matrix.md) maps each scope to the checked or pending boundary.

## Result architecture and literal atomicity

The reference retains independently operated native security A and cash B ledgers. A orders a permanent decision; B does not outsource custody to a relayer. Both principals sign the immutable descriptor. Local admitted policy/funding creates durable reservations. Finalized B preparation is captured and proved; A authenticates it, checks its local hold and exclusive deadline, and atomically records COMMIT plus security delivery. Finalized A outcome evidence then authorizes B's local cash delivery or ABORT release. Reconciliation consumes authenticated application/no-obligation records. Durable tombstones and persistent terminal knowledge resolve missing OPEN, known ABORT before preparation, and delayed authentic historical preparation.

This satisfies the modeled **backed irreversible decision** contract under the stated assumptions. It supports **eventual local application** and **eventual records** under their separate recovery/data/fairness hypotheses. It cannot satisfy an interpretation that requires both native assets to become locally usable at exactly the same instant. The immediate-local-equality counterexample remains. Choosing a shared execution domain changes the domain premise; a legal-entitlement interpretation needs external institutional evidence. Neither is silently adopted here.

## Changes made in this round

| Finding / execution obstacle | Change and observed discriminator | Guarantee / boundary |
|---|---|---|
| 180 seconds was insufficient for full-reference bounded depth 12 | 8 GiB/3600s profile and documented invariant-after batching; native check passed in182.9 seconds | Same full current State/init/step and S01–S16/CDecision; no filters |
| Full depth 20 SMT query cost | Direct longer run and exact finite-choice experiment retained as interrupted non-successes. Complete TLC check of identical current full reference reached12,502 states, graph depth 38 | Exhaustive safety covers all depths including 20; original SMT20 is not called a pass, and no compact/economic projection is substituted |
| Broader full-job temporal graphs | Dedicated unrestricted-proof-job two-trade and recovery runs, retaining all phases 0–6 and original per-action fairness | See the final resolution table and exact receipts; status follows actual completion |
| Restart examples had not directly attempted every blocked phase while down |19 explicit guard/recovery witnesses for worker, transport, terminal submitter and ledger unavailability | Demonstrates actual rejection and retained-witness recovery; not every independent fault combination |
| Authorized intent could be confused with accepted/registered work | Additive pure `report_view.qnt`, six tested accepted/registered distinctions | Signed, source accepted, decision registered, prepared, committed, applied and reconciled stay distinct. Off-chain job admission and external reporting are separate interfaces |
| Fresh replay could lose new heap settings | Propagate recorded JVM flags and resource limit into the fresh child plan | Extended observations reproduce their own resource profile |
| Privacy assumption rows retained retired monitor citations | Replace A-OPAQUE/A-POLICY/A-KEY/A-BOUNDS references with repaired payload/typed-note controls; audit their actual source owner | Documentation dependency repair; native privacy greens retain their exact prior proof scopes |
| Manifest native-export path was replaced by descriptive prose | Preserve actual per-execution native export paths and checksums; store the description separately; audit every exported path/hash | Reporting repair; original receipts/exports unchanged |
| Current prose did not fully explain architecture/tradeoffs | README architecture/contract table, specification comments, final property/source review | No financial transition was weakened and no failed product contract was relabeled |

The SMT representation experiment checks parsed-AST identity of 61 shared primitive action alternatives, same state/init and all phases. Its omission/changed-host controls reject different behavior. It is a representation certificate, not a completed depth 20 SMT result or a general refinement theorem. The full-job two-trade temporal graph has N=2 and continuously available actors. The separate N=1 recovery graph admits B-ledger/prover outages and B freezes, with `eventually(always(all actors up and no freeze))` plus the original fair-action hypothesis. Transport/terminal-submitter outages are exercised by direct scenarios, rather than advertised as a general temporal fault product. Neither graph is the `adversarialStep` fault sampler.

The full reference TLC check directly uses `dvp.init` and `dvp.step` and does not depend on this certificate.

## Observed final full-model results

| Original obligation | Actual final proof | Distinct states / graph depth | Wall time |
|---|---|---|---|
| Full-reference Apalache12 | Same current reference, bounded safety and CDecision through12 | State count unavailable; bound12 |182.88s |
| Full-reference safety through20 | Exhaustive TLC, identical current State/init/step and properties |12,502 /38 |16.31s |
| Full proof-job two-trade safety and L01–L04 | TLC `live_two`, all phases0–6, original fair actions |684,268 /49 |3,331.63s |
| Full proof-job recovery safety and L01–L04 | TLC `recoveryStep/recoveryProgress`, B/prover outages and B freezes |125,632 /41 |223.46s |

Every finite result has zero states left on its queue and the native no-error verdict. The original timeouts and later deliberately interrupted attempts remain non-successes. The depth20 safety proof uses the identical exhaustive model; direct SMT20 itself did not pass. The broader results do not rely on compact-job or economic projections.

## Original v2 sections and the tested solution

| Original scope | Review and actual evidence | Limits / disposition |
|---|---|---|
|1 Sources and native-asset problem | Exact source copies/hashes; source inventory; two independently scheduled ledger semantics | Missing PDF/design registers are visible; no unseen implementation inferred |
|2 Candidate lifecycle and orphan alternatives | Original A-hosted path; A-open/B/D variants; tombstones, historical OPEN, late holds and return paths | Alternative placements are named separately |
|3 S01–S16, L01–L04 and overclaims | Property-by-property matrix in traceability; direct guard/history/effect scenarios; full-reference and full-job extended checks | S13/S14 use focused control/admission checks as well as core predicates; no regulatory-compliance theorem |
|4 Layering, locality and historical evidence | Immutable structured provenance, local guards, explicit source finalization; economic safety mapping and integrated examples | Focused models do not imply general liveness/privacy/time composition |
|5 Scenarios and simulation | Both terminal outcomes, preparation orders, contention, actual drop/resend/restarts, binding/replay/rollback and new19 phase faults | Combined10,000-trace fault samples remain samples |
|6 Toolchain, bounded/finite checking and induction | Positive/false/fair/unfair smoke controls, native TLC/Apalache, genuine initiation/preservation/implication and mapping | Algebraic induction remains valid; current actual-State effect/local-atomicity induction is separately recorded in qa-repairs. No whole-protocol induction; failed backend attempts remain visible |
|7 Mutants and replay | Eight isolated protocol mutants, original native sequences and exact-source comparisons | No globally shortest/minimized trace claim; missing early closures remain listed |
|8 Review and records | Findings, counterexample chronology, conformance vectors, reporting and exact native contracts | No production conformance harness because production contracts/adapters/guests were absent |
|9 Full lifecycle/fault combinations |17 lifecycle phases have named observations; explicit actor-down attempts now supplement retained restart cases | Full Cartesian fault/state/upgrade/privacy/time product unproved |
|10 Variants | A tombstone/OPEN, B/D, native/escrow/private/shared, three-domain, HTLC/root/committee and authentication axes | Small abstract representatives; no vendor implementation or arbitrary nested cross-chain execution theorem |
|11 Privacy/disclosure/paired observations | Actual two-world funded states, immutable witness/proof/note/full Payload, authenticated roles, audit high-water and seven leak controls |12 fixed public operations plus at most one arbitrary coupled request; selected-observer/ideal-opacity result, not general noninterference or cryptographic privacy |
|12 Time/capacity | Async/eventual/post-stabilization/bounded models; B timer, frozen clock, no inclusion, starvation, D15/D14, late-hold and hostile FIFO controls |14/22/24 are model-slot bounds for a particular two-job workload; no hostile-priority latency or production SLA |
|13 Assumptions/interventions/trust | Per-action fairness, assumption-owner graph and actual non-equivocation/anchor/submitter/committee/data/key/issuer/admin perturbations | No globally minimal assumption set; freezing/seizure/compensation are distinct from original settlement |
|14 Evidence/conformance | Sealed claim/command/raw/source/runtime; rejected forged claim, wrong native log and zero-selection; exact replay | Local versioned trust anchor, not external signed execution attestation; early availability gaps visible |
|15 Completion | Scoped evidence matrix, exact stronger proof for bounded safety, full-job temporal gates, final six answers | Completion is the requested investigation with stated proof boundaries; never unqualified verification of a banking implementation |

Current-credential admission and pending-safe retirement are checked in the focused membership model. The financial full-job temporal graphs do not execute that entire membership state machine; no combined financial/membership liveness theorem or arbitrary-upgrade theorem is claimed.

The eight topics from the shared answer are reconciled in [eight-question coverage](interview-summary.md): architecture, proof statement/prover/verifier, lifecycle/timeouts, governance, privacy, onboarding, finality/latency/cost and credible PoC. Stage A (this formal model) executed. Stage B (real two-network Besu/QBFT with genuine proofs) remains external implementation work. Named products/research architectures are contextual candidates, not verified products.

## Six separate final answers

1. **Lifecycle:** admission and local eligibility/funding; concurrent exclusive reservations; historical inclusion/finality/witness/proof/network; both permanent decisions; delayed local applications/refunds; exact private note usability; authenticated reporting/bookkeeping; pending-safe rotation/exit. Named overlapping faults include drops/resends/restarts, deadline/outage, delayed old proof across upgrade, private data/key loss, shared capacity and directly blocked phase work. Arbitrary overlaps remain outside the finite matrix.
2. **Variants:** all mandatory named candidate/alternative classes have scoped executable representatives. The reference is A-hosted native holds. B/D, OPEN, escrow/private, shared execution, three domains and compact comparison mechanisms are distinct. No proprietary CLIP, Lineth, Paladin, general GPACT or all HTLCs are certified.
3. **Guarantees:** exact finite S01–S16 conjunctions plus matching guard/effect/control cases; C-Decision backing/irreversibility; conditional L01–L04 and C-Local/C-Records; per-action weak fairness, retained authority/data, recovered required actors and admitted durable asset/canonical execution are necessary. Finite fairness can resolve to ABORT; it does not promise COMMIT before D.
4. **Privacy:** selected observer1/3 cannot distinguish unrelated position4 versus7 through complete returned histories in the paired finite schedule under ideal opacity/private channels. Authorized trade terms and routing/phase/equality/size/timing metadata remain visible. Entitled prover/recipient/regulator access is scoped/declassified. Ordinary validators see ordinary local ledger state. General schedulers, collusion, termination and computational/real side-channel privacy remain external.
5. **Time:** asynchronous safety has no time promise; eventual progress needs recovered service/data/submission and fairness; bounded post-stabilization conclusions need explicit queue/inclusion/finality/outage assumptions. Late holds use relative authenticated-resolution bounds. Real proving/block/availability/p95/cost measurements remain work for a real PoC.
6. **Scope:** exact finite instances and finite coupled observer schedules only. No general population/n-leg, whole-model induction, composed three-domain ABORT-bookkeeping, or full fault/privacy/time theorem. Circuits, crypto, real QBFT/EVM/token behavior, custody/storage/network security, implementation conformance, legal rights/issuer solvency and production economics remain external.

## Extended-run resolution

The machine-readable `final-review.json` and [coverage](coverage.md) supply the final observed outcome for every original broader obligation and the exact new receipt. Historical180-second receipts remain timeouts. The initial concurrent start conflicted with v2's sequential-heavy instruction; scheduling-events records the deviation, pauses and resumption. The final driver serializes heavy checks. Pause time was not removed from original wall budgets.
<!-- observed-resolution -->

| Original timeout | New observation | Resolution | Proof basis |
|---|---|---|---|
| apalache-core-12 | [extended-apalache-core-12](../results/runs/extended-apalache-core-12/receipt.json) | resolved-by-observed-proof | same full reference, larger budget, invariant-after batching |
| apalache-core-20 | [extended-tlc-full-reference](../results/runs/extended-tlc-full-reference/receipt.json) | resolved-by-observed-proof | exhaustive identical full State/init/step safety covers every depth; original SMT20 remains a non-success |
| tlc-live_two | [extended-tlc-two](../results/runs/extended-tlc-two-attempt1/receipt.json) | resolved-by-observed-proof | same full-proof-job two-trade graph, all actors up, phases0-6 and original per-action temporal fairness |
| tlc-eventual-recovery | [extended-tlc-recovery](../results/runs/extended-tlc-recovery/receipt.json) | resolved-by-observed-proof | same full-proof-job one-trade B/prover-outage and B-freeze recovery graph; original recoveryProgress hypothesis |

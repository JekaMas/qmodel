# Guarantee-by-guarantee review

This ledger reviews what the observed results support and what a reviewer must still ask for. It uses the same 51 IDs as the [versioned machine-readable property ledger](../../properties.json). That ledger and [the current evidence table](../../reports/qa-properties.md) give exact receipt families. The review adds two directed fault discriminators with original-model controls and two stronger predicates checked together on the unchanged normal A reference. It does not reclassify prior native observations.

[New assurance evidence](../../reports/guarantee-validation.md) resolves VGR-01/VGR-02 on the bound profiles, adds prior-state policy/history and a real local SQLite restore, and tracks external obligations. The dispositions below describe what was supported when this review was written.

## Settlement safety and progress

| ID | What is supported on the checked model | What would strengthen the claim |
|---|---|---|
| S01 | Core safety checks domains, disjoint asset IDs and nonnegative balances in the finite instances. | Compare concrete token arithmetic, ABI widths and amounts at the model-to-code boundary. |
| S02 | First-terminal ghost, core graphs and reopen/pruned-tombstone controls test immutable outcomes. | Independently compare previous/new decision in a transition monitor and confirm immutable storage after restore/migration. |
| S03 | Exact dual signature and same-descriptor guards, with altered and unauthorized instruction cases. | Verify real canonical encodings, signatures and request adapters. |
| S04 | Independent quantities, exclusive reservations, ordinary spending controls, contention and escrow accounting. | Compare account-level balances and vault availability on the real tokens, especially concurrent transfers. |
| S05 | Per-trade effect counts plus exact account/asset/quantity receipts and full financial row binding. Wrong-account, wrong-asset, duplicate, false-release and booking mutants fail the relevant oracles. | Conformance needs actual debits, credits, releases and database writes. VGR-02 addresses whether a correctly formed COMMIT row is premature. |
| S06 | Actual outcome provenance chain and guarded transfer/refund actions. Existing reference evidence plus the new review-only outcome assertion support the A reference. | **VGR-01.** Independently relate accepted local knowledge and value effects to the matching decision and proof, for both remote placements and co-located legs. |
| S07 | Reference S07 observes pending prepared cash backed by its hold. Backing/conservation, both-leg hold/effect induction and separate intervention controls add complementary checks. | Check the retention rule for both legs and for historical versions on the actual asset/issuer interfaces. Arbitrary seizure breaks backing. |
| S08 | A COMMIT locally transfers security and retains exact committed cash backing. Non-atomic A and bad recipient controls discriminate the failure. B/shared have distinct local effect monitors and D uses two remote preparation proofs. | Real token failure/rollback and atomic transfer semantics require EVM checks. |
| S09 | Core states forbid opposite-leg delivery/refund, with stale-refund counterexamples. | Pair with terminal evidence consistency, since a missing leg can conceal a wrong payout without creating that mixed state. |
| S10 | Exact descriptor and context at the actual preparation consumer. Authentic unadmitted-program tests cover A, B and both D preparation consumers. | Outcome application has a separate wrong-phase gap under VGR-01. Verify canonical checkpoint/public-input encoding and actual issuer/verifier behavior. Foreign-context fixtures assume provenance at the input boundary. |
| S11 | Exclusive A-height boundary, durable abort tombstone and rejection/resolution of late prepare. Named historical OPEN schedules exercise the extra proof path. | Preserve tombstones and consumed operation IDs through actual contract/state migration. |
| S12 | Core outcome/effect assertions, directed projection/message/restart cases and bounded fault samples. | Actual stale database restore, duplicate downstream command, independent actor/storage reboot and durable effect/row comparison. |
| S13 | Separate membership/rotation/retirement proofs and financial historical-proof witnesses. Pending-safe retirement and consumed-ID controls fail when removed. | Joint settlement and full membership liveness and real key/verifier/token upgrade remain distinct. Test the transition where old obligations resolve while new credentials are admitted or rejected. |
| S14 | Guards and directed policy cases exercise eligibility/revocation/freeze. Specialized intervention variants distinguish supported durable hold, freeze and seizure. | Existing S14 alone is an authorization state predicate. A past-state assertion should check eligibility at actual preparation, independently of its writer. Adopt the actual institutional policy before claiming compliance. |
| S15 | Distinct diagnostic stages, stale cache labeling, authenticated ABORT records and independent resolution of prepared/absent legs. | **VGR-02.** Independently require both effects and both authenticated application facts for COMMIT report/row. Verify external API/DB output against the source world. |
| S16 | An abstract transport compromise grants no modeled custody, upgrade, validator or decrypt powers. Separate trust controls exercise broken administrative assumptions. | Actual key/capability separation requires checks of roles, RPC permissions, verifier governance and storage. This remains an abstract actor boundary. |
| L01 | Registered or actually held trade eventually receives a terminal outcome in the named fair/recovered profiles. | Progress may end in ABORT. A halted decision ledger or a lost necessary proof path defeats the stated conditions. |
| L02 | Actual COMMIT applications eventually complete with fair actions and eventual recovery in the named profiles. | Preserve current proof/data, authorised submitters and durable holds on real chains. This gives no unconditional elapsed-time promise. |
| L03 | Existing and late unknown-ABORT holds eventually release under recovery. Never-prepared legs produce absence records. | Exercise actual intervention and late-hold policies on the PoC. Permanent freeze can keep a real hold unresolved. |
| L04 | Temporal check reaches the currently defined record/report endpoint under recovery. ABORT validates its underlying source effects. | **VGR-02.** Require evidence-backed COMMIT completion as the endpoint and demonstrate the booking/replay path on the real consumer. |

## Contracts, privacy, time and reachability

| ID | Finding against the required guarantee |
|---|---|
| C-Decision | Irreversible outcome and actual financial backing supported in the named configurations. Authoritative finalized histories and supported holds remain assumptions. |
| C-Local | Both actual local effects under stated recovery, with private usability requiring its note/key. Outcome authenticity should be asserted directly as in VGR-01. |
| C-Records | ABORT reconciliation checks real releases/terminal absence. COMMIT relies on the reporter's evidence flags and needs the independent assertion from VGR-02. |
| O-Immediate | Rejected by the current TLC counterexample. A's transfer is locally visible while B still has a funded reservation. A shared authoritative domain changes the architectural premise. |
| O-Permanent | Rejected by the current permanent-B-halt counterexample. Additional proof infrastructure cannot make a permanently unavailable required ledger apply value. |
| P-Access | Checked authenticated query context and permitted bodies in the finite pipeline. Role-confusion controls distinguish released body labels from actual query authority. |
| P-Binding | Checked exact scalar fields, proof context and recipient-note amount/recipient, with independent source comparison and corruption controls. Real payload construction and cryptographic binding need conformance. |
| P-Availability | Actual note and key availability is separate from ledger application. Conditional availability and permanent loss have independent observations. |
| P-Scope | Authorized audit range and omission controls have a separate finite model. An entirely withheld head requires authenticated freshness and evidence of its scope. |
| P-NI | Finite paired source values/observer with explicit public operation sequence, at most one coupled request and ideal opacity/private channels. Arbitrary schedules, collusion, computational secrecy and real side channels remain outside this theorem. |
| P-Timing | Coupled timing/metadata and a small queue/payload product tested, including leak controls. No inference to unobserved schedules, actual proving times or deployed telemetry. |
| T-Async | Healthy/recovery graphs, directed network cases and three bounded fault samples. The combined traces support the sampled schedule distribution and bound. They do not exhaust arbitrary independent failures. |
| T-Eventual | Eventual stable all-up/unfrozen suffix and per-trade/per-action weak fairness for the named recovery graph. Faults outside that graph have their own witness or narrower proof. |
| T-Bounded | Slot model with explicit workload, queue, inclusion, slow blocks and fixed B skew. Exclusive D=15 admits both COMMITs and D=14 has a counterexample in the tested workload. Arbitrary clock drift and real service bounds remain separate. |
| T-Capacity | Bounded reservations and finite hostile FIFO work under recovered fair service. The workload and finite hostile budget differ from the deadline model, so a composed hostile-work deadline requires its own check. |
| R-Core | Nonvacuous success, reservation, application lag, abort/orphan and recovery witnesses. |
| R-Policy | Actual model admission and local eligibility/freeze rejection witnesses. Institutional issuer, role and account policies still need conformance. |
| R-Audit | Authorized reads and modeled omission are reachable. External reporting needs authentic range, high-water and freshness evidence. |

## Variants and implementation boundaries

| ID | Finding against the required guarantee |
|---|---|
| V-AOpen | Finite historical OPEN safety/progress and the source-effect induction passed. Historical OPEN adds a preparation admission step. It can arrive after ABORT and needs the same resolution path. |
| V-B | Local cash with COMMIT and authenticated remote A preparation have direct and graph coverage plus local atomicity checks. Extend VGR-01/02 using the mirrored remote leg. |
| V-D | Both remote preparations and both return paths are modeled. Governance/availability of D is an added dependency. Extend VGR-01/02 to both consumers. |
| V-Escrow | Checked vault accounting and exact outputs. Per-asset custody, vault return and real token semantics need conformance. |
| V-Private | Checked ledger application and usability as distinct milestones. Assumes ideal cryptography and separate note/key delivery. |
| V-Shared | Both colocated effects and omitted-leg control checked. It changes the native independent-ledger premise. |
| V-Three | Three domains and shared cash capacity checked in a separate finite installation. COMMIT reporting and per-leg resolution are scoped. Integrated three-domain ABORT-bookkeeping and arbitrary n-leg/population proofs are open. |
| EX-Crypto | External. Verify actual circuit/guest, encoding, verifier/version composition and admitted canonical history. |
| EX-Execution | External. Verify actual QBFT/EVM/token semantics, including transfer failures, upgrades, rollback, reentrancy and real hold authority. |
| EX-Security | External. Verify keys, storage, evidence durability, backups and actual restore/replay. |
| EX-Privacy | External. Prove or measure computational confidentiality, broader schedules and deployed side channels. |
| EX-Performance | External. Measure availability, latency, capacity, throughput, gas and proving cost on a defined workload. |
| EX-Legal | External. Confirm ownership, settlement finality, issuer powers/solvency, intervention and financial record obligations. |

[Exact executed property matrix](../../reports/qa-properties.md) · [Lifecycle and coverage contract](../../reports/literal-coverage.md) · [PoC conformance vectors and boundary](../../reports/conformance-boundary.md)

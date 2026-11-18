# Repeated settlement and modeled fault review

The [protocol specification](../SPECIFICATION.md) defines the reference transitions and their evidence boundaries.

## Findings and changes

| Finding | Disposition |
|---|---|
| One funded pair, one common deadline | The old two-trade graph exercises contention. The test workload starts with ten units of security and fifteen of cash for seven distinct trades. Its signed deadlines are 1, 3, 5, 6, 6, 7 and 8. Each trade's outcomes, effects and evidence remain in the same initialized ledger pair. |
| Ordinary spending while a ledger was halted | A [witness on the reference source](../results/runs/repeated-review-legacy-spend/receipt.json) spends B funds while B is down and the old safety assertion holds. The workload makes the local availability guard explicit. It rejects spending on the down ledger, preserves spending on the other ledger and exercises local spending after recovery. The refinement is in the funded profile. |
| Normal and general adversarial selections omit loss and prune | The earlier operational overlay includes both. The new dispatcher combines the actual adversarial entry with loss and pruning. Directed tests show a captured witness surviving pruning and restart, dropped evidence denying use, and valid resend completing the original trade. |
| Cross-trade and shared-funding faults need more than a single-trade test | Directed cases present an exact authentic preparation, outcome or application for an earlier trade while a later trade has the other relevant prerequisites. The consumer rejects each substitution. Both legs deny a new request at full reservation. Replay checks compare previous terminal outcomes, source effects and durable rows. |
| An action list alone does not establish coverage | All 45 reference actions map to named directed tests, retained B/D placements, actual isolated counterexamples or the checked dispatcher. The audit fails on any absent declaration or missing witness. |

## Executed workload

Trade 1 commits. Trade 2 reserves both legs, reaches its deadline, authenticates ABORT, releases both holds and books the actual releases. Trade 3 subsequently commits using the freed capacity before its own deadline. The oracle checks exact recipients and credits, and preserves each trade's independent decision, effect and record.

Trades 4, 5 and 6 all hold both legs before any of them commits. After receiving all three authentic B preparations, the suite executes **all 90 legal orders** of six terminal actions, each A COMMIT preceding its own B application. After each of these actions it compares both balances and all three trades against independent expectations. Each complete run has five successful exchanges, one funded ABORT, twelve economic outputs and six distinct rows. Trade 7 cannot reserve either leg at full capacity. Its tombstone branch produces a seventh row and no refund for either absent hold. A separate mixed case releases trade 5 while trade 4 settles and trade 6 can still commit.

| Selected executions | Exact coverage |
|---|---|
| 278 directed Quint Rust tests in 18 batches | Sequential and overlapping settlement, shared balance accounting, historic evidence isolation, governance/revocation/freeze, transient faults and reconciliation. |
| All 31 nonempty subsets of A, B, submitter, prover and transport | Each subset is taken down and restored at one checkpoint with a COMMIT pending cash application and two other trades open. The selected restoration order completes the expected trade and preserves the others. |
| All seven source proof phases | 35 phase/dependency denial checks for finalize, capture, prove, deliver and resend. Seven recovery traces exercise captured witness retention, pruning, loss, retry and duplicate delivery. Denial tests show the action prerequisites before testing the missing dependency. |
| All 77 phase/binding indices | Actual injection of each of eleven bounded transformations at each phase index and no acceptance for the targeted trade/phase. Separate unadmitted-program and cross-trade cases exercise authentic proof rejection. |
| Full operational dispatcher | 10,000 traces with a 150-step cap and seeds 41–50 found no violation over ordinary and adversarial actions plus loss and pruning. The single-seed attempt reached its 600-second cap and remains a timeout. The [machine audit](repeated-settlement-coverage.json) records the ten successful jobs. |

After each applied replay event, Quint checks the protocol safety conjunction, C-Decision, the strengthened outcome/booking conditions and preservation of earlier decisions, output receipts and financial rows. The specialization has an exact recipe bound to the reference source. It changes initial funding, deadline comparisons and the local spending guard. Early unsharded runs stalled or hit recursion, typing or Node heap limits. Iterative replay and Rust batches resolved the execution issue. The first non-success receipts are preserved.

## Re-review of models, predicates and tests

| Owner | Review conclusion |
|---|---|
| dvp, economic_effects, guarantee_oracles, guarantee_profiles, policy_history | S01/S04 domain and conservation, S02/S11 terminal history, S03/S14 admission, S05/S09 effect identity and cardinality, S06/S08/S10 proof authority and backed COMMIT, S07 retained holds, S12 restart, S13 history, S15 reporting and S16 transport separation all have explicit observations. The new workloads add prior-state preservation and literal aggregate and per-trade accounting. The main state is one frame record. Integers are restricted by the dispatcher; a real adapter must validate caller input before dispatch. |
| liveness, liveness_variants, recovery, compact_two, compact_recovery, late_resolution, stabilization | L01–L04 and C-Local rely on their named fair, recovered suffixes. The directed workload supplies witnesses under larger funding. The seven-trade temporal theorem remains open. Existing impossible immediate-availability and permanent-halt controls retain their counterexamples. |
| authentication, trust, membership, interventions | Admitted canonical history, retained financial authority and eligible intervention are distinct. Separate models and controls exercise rejected authority, witness loss, refusal, forced seizure and supported freeze/recovery. Directed cases now combine exit and rotation with pending obligations. |
| privacy, privacy_pipeline, observer_view, private_progress, audit_scope, integrated | Exact body/query provenance, paired observation, private note/key availability, withheld range and small time/queue coupling have separate controlled cases. Arbitrary privacy scheduling, concealed metadata and actual key recovery need separate evidence. |
| timing, timing_boundary, capacity | Explicit slot models address deadline margin, inclusion omission, fixed skew, starvation and limited hostile admissions. Absolute decision heights in the repeated workload specify expiry without an elapsed-time prediction. |
| variants, multilateral, mechanisms, report_view | B/D/shared and authenticated OPEN retain their own authority rules. D has two remote applications. Private asset usability is separate from ledger delivery. The three-domain model and alternative mechanisms keep their topology and scoped record semantics. |
| admission_focus, failure_controls, full_grounded, induction, effect_consistency, effect_trade_domain, trade_domain_lemmas, mapping, smoke, operational_faults | Focused guard/trace models, correspondence and auxiliary induction validate their own selected assertions. History snapshots remain attached to their original inputs. |

The [51-property ledger](../properties.json) and [earlier per-property review](qa-properties.md) identify the original predicates and receipts. Actual circuits, QBFT/EVM and token execution, security, privacy, availability and legal/financial authority remain [conformance obligations](guarantee-conformance.md).

### Quint and TLA+ comparison

- **Quint TwoPhaseCommit and TLA+ TwoPhase** put the decision under one coordinator and isolate message delivery from participant state. TLA+ retains messages for its safety-only scope. Here explicit loss matters for successful recovery through a retained witness and resend. Each fact has exact trade identity rather than a global unqualified Commit. [Quint source](https://github.com/quint-co/quint/blob/07d7a1a69c2093b5bc656caf3b5dfefa0d766cd0/examples/classic/distributed/TwoPhaseCommit/two_phase_commit.qnt) · [TLA+ source](https://github.com/tlaplus/Examples/blob/master/specifications/transaction_commit/TwoPhase.tla)
- **Malachite** links concrete Quint branches to executed tests and names the driver limits. The event ledger adopts that practice for ordinary, rejected, placement-specific and mutant actions. [Malachite Quint coverage](https://github.com/circlefin/malachite/blob/a453b32155f4ba9f959724279b52f601bae92e09/specs/consensus/quint/coverage.md)
- **TLA+ KVsnap** keys active transactions individually and checks effects of one transaction on the others. The same discipline motivates independent per-trade state and shared-balance comparisons after terminal actions. [KVsnap source](https://github.com/tlaplus/Examples/blob/master/specifications/KeyValueStore/KVsnap.tla)
- **Quint ICS20** illustrates consumption and replay keyed by message identity. Its receipt/timeout authority has different semantics; in DvP the B release follows authenticated A ABORT. [ICS20 Quint source](https://github.com/quint-co/quint/blob/07d7a1a69c2093b5bc656caf3b5dfefa0d766cd0/examples/cosmos/ics20/ics20.qnt)

### Boundaries

Exhaustion applies to the stated terminal-order, outage-subset and phase/binding domains. Arbitrary proof pipeline interleavings, overlapping failure durations, adversarial load and joint topology/privacy/control schedules remain broader state-space obligations. A successful recovery trace does not imply progress under permanent unavailability. Simultaneous native usability continues to require a shared domain or a separately enforced entitlement mechanism.

The fault ledger also links separately checked controls for permanent decision or asset outages, invalid execution and canonical history, irreversible witness/key loss, unavailable submitters or committee refusal, destructive asset intervention, retirement and replay, audit omission, inclusion and hostile queue growth. Each records the exact expected pass or counterexample in its own model. The seven-trade workload deliberately keeps the reference's supported asset and authenticated history assumptions.

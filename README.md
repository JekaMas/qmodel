# qmodel

Published repository: [JekaMas/qmodel](https://github.com/JekaMas/qmodel).

Executable Quint investigation of native-asset cross-chain delivery-versus-payment. The project executes the attached v2 brief against the recovered shared solution, using the pinned Quint LLM kit language/modeling skills and local Quint, Apalache and TLC tooling.

**Result.** The settlement model verifies one terminal outcome per trade, delivery only after COMMIT, refund only after ABORT, single consumption of each hold, and two matching backed obligations at COMMIT. It also verifies eventual application under its stated recovery and fairness hypotheses. Independent ledgers can make one leg locally usable before the other. The [Question 8 evidence review](verification/reports/interview-summary.md#question-8-evidence-review) maps Stage A to the actual model checks and Stage C to the directed cases and remaining PoC tests.

**Current repair and re-review** covers all four comparative-review findings with the user-requested focused validation. Economic outputs identify exact accounts/assets/quantities. ABORT bookkeeping checks actual release or terminal absence. Valid unadmitted proofs reach the real consumer. Disclosure values and authenticated recipients are independently source-bound. Four exact counterexample reproductions passed. Full validation remains **NOT DONE**, with seven full checks,43additional reproductions and the complete33-case evidence audit deferred by the user. The51-property and per-file reviews show the resulting scope. [Repair report](verification/reports/qa-repairs.md), [property review](verification/reports/qa-properties.md), [file review](verification/reports/qa-files.md).

The [independent review](verification/reports/independent-review.md), [commented solution specification](verification/SPECIFICATION.md) and [changes made for each guarantee](verification/reports/solution-and-changes.md) explain the original findings, repairs and resulting solution.

```mermaid
flowchart LR
  I["Seller + buyer authorize exact descriptor"] --> A["A: OPEN + security hold"]
  I --> B["B: funded cash hold"]
  B --> P["Finality → immutable witness → B preparation proof"]
  P --> C["A: verify + COMMIT + security transfer"]
  A --> C
  C --> O["Finality → authenticated A outcome"]
  A --> X["A: deadline → ABORT / tombstone"]
  I --> X
  X --> O
  X --> AR["A: retry release / no-obligation record"]
  AR --> F
  O --> R["B: authenticate → cash delivery / ABORT release"]
  R --> F["Authenticated A/B application records → reconciliation"]
```

A hosts `SecurityHold`, `DvPDecision` and `BPreparationVerifier`; B hosts `CashHold` and `AOutcomeVerifier`. Assets stay native. Controlled local signers submit already authorized operations; untrusted relayers transport evidence, and proof workers capture finalized historical state. Neither a relayer acknowledgement nor an adapter projection authorizes value movement.

The exclusive deadline belongs to A: COMMIT requires `height < D`, ABORT requires `height >= D`. Holds persist until an authenticated outcome. A signed ABORT tombstone resolves a trade that never opened; B keeps terminal knowledge even before its hold exists. A late authentic preparation cannot reverse ABORT. Refund failure cannot prevent the durable ABORT decision.

| Contract | Result and conditions | Tradeoff |
|---|---|---|
| C-Decision | One permanent authorized outcome with actual reserved/delivered backing; A COMMIT and security delivery are one local atomic action | A orders the reference outcome and is an availability dependency |
| C-Local | Both native applications eventually complete with retained evidence/data, recovered required actors, supported asset powers and per-action fairness | An asynchronous interval of one-sided local usability exists; permanent halt/freeze can prevent progress |
| C-Records | FULLY_APPLIED and reconciliation require authenticated source application evidence and exact financial terms; ABORT requires actual releases or terminal no-obligation records | Ledger delivery, recipient usability and bookkeeping are distinct milestones |
| Private usability | Delivered private value additionally needs its exact recipient note and key | Irrecoverable key/data loss defeats usability |
| Scoped privacy | Two actual protected positions yield equal selected-observer response histories under the checked coupled schedule and ideal opaque naming/private channels | Permitted routing, phase, equality, size and timing metadata remain visible; entitled recipients/regulators can learn authorized data |
| Conditional time | Explicit finite queue/inclusion/outage assumptions yield slot bounds; the D=15/D=14 boundary is tested | Slots are model assumptions, with no production latency, gas or throughput claim |

A-hosted native holds remain the reference. Authenticated OPEN, B/D decision placement, escrow, private assets, three independent domains and HTLC/root/shared-ledger/committee controls are separately named models. D adds a governance/availability dependency and two preparation plus two outcome proof paths; it does not synchronize native balances. A shared execution ledger can apply co-resident assets atomically, at the cost of changing the execution-domain premise. Native holds require admitted durable token semantics; escrow requires explicit vault/custody semantics. ZK-style remote authentication is modeled symbolically and does not establish real circuit correctness or hide ordinary EVM state from local validators.

The four obligations from the original timeouts have separate completed results. Apalache checked reference safety through depth 12. Exhaustive reference TLC covered 12,502 states at graph depth 38 and therefore includes all reachable safety prefixes through depth 20. The two-trade TLC graph checked safety and conditional progress over 684,268 states with all proof phases. The one-trade TLC recovery graph checked safety and conditional progress over 125,632 states with B/prover outages and B freeze/unfreeze. The longer SMT20 attempts and original 180-second timeouts retain their recorded non-success statuses. See the [exact results and assumptions](verification/reports/interview-summary.md#question-8-evidence-review).

Start with [the final review](verification/reports/final-review.md), [findings](verification/reports/findings.md), [coverage](verification/reports/coverage.md), [native counterexamples](verification/reports/counterexamples.md) and [the exact execution index](verification/reports/executions.md). The [source inventory](verification/sources/source-inventory.json) records recovered sources and missing original materials. The [canonical task record](openspec/changes/verify-cross-chain-dvp/tasks.md) contains execution status and limits.

```sh
npm ci
python3 verification/scripts/verify.py baseline --focused
python3 verification/scripts/verify.py negative --focused
```

These two commands audit the explicitly selected focused scope and reuse the saved backend observations and source closures. Full validation has the deferred obligations listed in the repair report. They fail on missing/corrupt evidence, wrong backend verdicts or changed final model hashes. They deliberately do not rerun already valid greens. Add `--fresh` to explicitly execute every selected check again against its exact recorded input version; every subprocess has the recorded resource/time limit and failures propagate. The baseline contains positive checks; the negative suite requires actual property violations. Use `python3 verification/scripts/replay.py mutant-expiry --latest-success` to reproduce one counterexample and compare native ITF states.

Fresh checking requires Node, Python 3 and Java 21+ (Java 25 was used here). Quint 0.33.1 is pinned in package-lock.json; the first fresh verification may fetch project-local Apalache 0.62.4 and Rust evaluator v0.7.1 into `.quint`. No global install is needed. See [verification instructions](verification/README.md) for Java selection, limits and proof boundaries.

The standard workflow is pinned at `.agents/workflow`. If the historical upstream pin is unavailable, restore it from the bundled exact Git history using `python3 .agents/restore-workflow.py`. The pinned local source bundle was smoke-tested in a temporary clone. Copied Quint kit skills are in `.agents/skills/quint-lang` and `.agents/skills/quint-modeling`; revision and licenses are in NOTICE and the source inventory.

Models, evidence, source copies and reports are published under JekaMas/qmodel. The [repair validation record](verification/reports/qa-validation.json) identifies the tested committed source and focused clean audit. The [extended publication receipt](verification/reports/publication-extended.json) and [earlier publication receipts](verification/reports/publication.json) retain the previously published source identities, hosted readback and fresh-clone reproduction; they are historical receipts. There is no production blockchain, real asset movement or funded infrastructure. The versioned source seal is a local evidence trust anchor, not third-party execution attestation. Ten early observations lack saved source closures; their exact availability and current replacement scopes are listed in verification/reports/reproduction-availability.json. Historical timeout attempts remain immutable. The final review and coverage report identify their extended-run resolution separately from the original receipts.

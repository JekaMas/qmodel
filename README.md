# qmodel

Executable Quint investigation of native-asset cross-chain delivery-versus-payment. The project executes the attached v2 brief against the recovered shared solution, using the pinned Quint LLM kit language/modeling skills and local Quint, Apalache and TLC tooling.

**Result:** the finite models support backed irreversible commitment with conditional eventual local application. Immediate joint local usability across independent asynchronous ledgers fails. This is a scoped evidence matrix, not a deployed-system, cryptographic, legal or arbitrary-population verification.

The [independent review](verification/reports/independent-review.md), [commented solution specification](verification/SPECIFICATION.md) and [changes made for each guarantee](verification/reports/solution-and-changes.md) explain the original findings, repairs and resulting solution.

Start with [findings](verification/reports/findings.md), [coverage](verification/reports/coverage.md), [native counterexamples](verification/reports/counterexamples.md) and [the exact execution index](verification/reports/executions.md). The [source inventory](verification/sources/source-inventory.json) records recovered sources and missing original materials. The [canonical task record](openspec/changes/verify-cross-chain-dvp/tasks.md) contains execution status and limits.

```sh
npm ci
python3 verification/scripts/verify.py baseline
python3 verification/scripts/verify.py negative
```

These two suite commands audit and reuse the committed original backend observations and their preserved source closures. They fail on missing/corrupt evidence, wrong backend verdicts or changed final model hashes. They deliberately do not rerun already valid greens. Add `--fresh` to explicitly execute every selected check again against its exact recorded input version; every subprocess has the recorded resource/time limit and failures propagate. The baseline contains positive checks; the negative suite requires actual property violations. Use `python3 verification/scripts/replay.py mutant-expiry --latest-success` to reproduce one counterexample and compare native ITF states.

Fresh checking requires Node, Python 3 and Java 21+ (Java 25 was used here). Quint 0.33.1 is pinned in package-lock.json; the first fresh verification may fetch project-local Apalache 0.62.4 and Rust evaluator v0.7.1 into `.quint`. No global install is needed. See [verification instructions](verification/README.md) for Java selection, limits and proof boundaries.

The standard workflow is pinned at `.agents/workflow`. If the historical upstream pin is unavailable, restore it from the bundled exact Git history using `python3 .agents/restore-workflow.py`. The pinned local source bundle was smoke-tested in a temporary clone. Copied Quint kit skills are in `.agents/skills/quint-lang` and `.agents/skills/quint-modeling`; revision and licenses are in NOTICE and the source inventory.

Models, evidence, source copies and reports form the reviewed project for publication under JekaMas/qmodel. There is no production blockchain, real asset movement or funded infrastructure. The versioned source seal is a local evidence trust anchor, not third-party execution attestation. Ten early observations lack saved source closures; their exact availability and current replacement scopes are listed in verification/reports/reproduction-availability.json. Four broader model-checker attempts remain timeouts.

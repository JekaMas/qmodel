# Independent-review repair results

Historical snapshot of the preceding independent-review/publication iteration. Its153 observations and14 audit cases describe that source revision. See [final review](final-review.md) and [current coverage](coverage.md) for extended full-model closure and the current selection.

All four independently reported findings were repaired and rechecked by the same reviewer. The original baseline findings and unsuccessful first payload repair remain visible in independent-review.md/json. No new principal economic safety defect was found. The result remains a scoped investigation, not unqualified full-system verification.

| Check | Actual outcome | Distinct states | Native evidence |
|---|---|---|---|
| review-pipeline-safe-attempt3 | finite_model_verified | 13 | [raw](../results/runs/review-pipeline-safe-attempt3/raw.log) / [receipt](../results/runs/review-pipeline-safe-attempt3/receipt.json) |
| review-pipeline-PAccess-attempt3 | finite_model_verified | 55309 | [raw](../results/runs/review-pipeline-PAccess-attempt3/raw.log) / [receipt](../results/runs/review-pipeline-PAccess-attempt3/receipt.json) |
| review-pipeline-PBinding-attempt3 | finite_model_verified | 55309 | [raw](../results/runs/review-pipeline-PBinding-attempt3/raw.log) / [receipt](../results/runs/review-pipeline-PBinding-attempt3/receipt.json) |
| review-pipeline-PNI | finite_model_verified | 55309 | [raw](../results/runs/review-pipeline-PNI/raw.log) / [receipt](../results/runs/review-pipeline-PNI/receipt.json) |
| review-pipeline-witnesses-attempt2 | executed_successfully | unavailable | [raw](../results/runs/review-pipeline-witnesses-attempt2/raw.log) / [receipt](../results/runs/review-pipeline-witnesses-attempt2/receipt.json) |
| review-privacy-time-integrated-safe-attempt2 | finite_model_verified | 64 | [raw](../results/runs/review-privacy-time-integrated-safe-attempt2/raw.log) / [receipt](../results/runs/review-privacy-time-integrated-safe-attempt2/receipt.json) |
| review-typed-private-availability | finite_model_verified | 26 | [raw](../results/runs/review-typed-private-availability/raw.log) / [receipt](../results/runs/review-typed-private-availability/receipt.json) |
| review-typed-private-unconditionalAvailability | expected_counterexample_found | 26 | [raw](../results/runs/review-typed-private-unconditionalAvailability/raw.log) / [receipt](../results/runs/review-typed-private-unconditionalAvailability/receipt.json) |
| review-fifo-workload | executed_successfully | unavailable | [raw](../results/runs/review-fifo-workload/raw.log) / [receipt](../results/runs/review-fifo-workload/receipt.json) |

Seven actual data-path leak controls additionally produced intended counterexamples: witness log, secret-dependent timing, unsalted guess, wrong scope, substituted disclosure, wrong recipient note and disclosure-key compromise. The timed product has its own leak control and a real completion witness.

The reconciled selection has 153 observations (104 positive,49 negative), with no unmet named scoped check. There are 14 passing evidence-audit tests, including the reviewer's forged claim/target discriminator, altered raw output, zero selection, forced child executions, exact failed selection, immutable native trace selection and portable saved-input resolution. Counts are executions/cases within explicit scopes, not a percentage of arbitrary behaviors.

Four broader 180-second attempts remain timeouts. Ten early observations lack their receipt-local source closure and remain unavailable for exact replay. Existing valid economic/membership/time checks were retained; inline comments and added unselected temporal definitions do not silently refresh their original hashes. See comment-only-deltas.json, retained-privacy-scopes.json and reproduction-availability.json.

The reviewed solution is specified in [SPECIFICATION](../SPECIFICATION.md); [solution and changes](solution-and-changes.md) maps the design/model repairs to properties. The reviewed source614844ea passed clean-commit execution and was published at https://github.com/JekaMas/qmodel. [Publication evidence](publication.json) records hosted owner/visibility/head/file readback and a fresh clone that restored the workflow, installed pinned dependencies and forced an immutable-state-matching counterexample replay. A metadata commit records that source publication without changing model semantics.

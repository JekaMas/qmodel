# Native counterexample chronology

These tables project the saved native ITF state sequence. Actions come from the executed guided schedule; states, balances, effects, knowledge and evidence come from the backend trace. No trace minimization was performed. All eight traces were rerun against their exact saved source closures and normalized native states matched. Temporal lasso/cycle traces stay in their TLC raw logs; they are not represented as invented ITF.

Codes: decision 0 absent, 1 OPEN, 2 COMMIT, 3 ABORT; hold 0 absent, 1 reserved, 2 delivered, 3 refunded. Native owner balances include reserved quantities; delivered quantities are in effects/recipient maps. Evidence pairs are `(trade, phase)`: 0 OPEN, 1 A prepared, 2 B prepared, 3 COMMIT, 4 ABORT, 5 A applied, 6 B applied.

## expiry: S08

Native [ITF](../results/traces/expiry.itf.json), [replay](../results/replays/mutant-expiry/replay.json). 12 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / 0 | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / 0 | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / 0 | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / 0 | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `prepareB(1)` | 0 / 0 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `finalize(1,2)` | 0 / 0 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / - / - / - / - |
| 6: `capture(1,2)` | 0 / 0 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / - / - / - |
| 7: `prove(1,2)` | 0 / 0 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / - |
| 8: `deliver(1,2)` | 0 / 0 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 9: `bTick` | 0 / 1 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 10: `bTick` | 0 / 2 | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 11: `unsafeRefund(1)` | 0 / 2 | t1: 1; 1/3; 0/0; 1 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 12: `commit(1)` | 0 / 2 | t1: 2; 2/3; 1/0; 1 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-expiry`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## binding: S10

Native [ITF](../results/traces/binding.itf.json), [replay](../results/replays/mutant-binding/replay.json). 11 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0; t2: 0; 0/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0; t2: 0; 0/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0; t2: 0; 0/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 3: `sign(2,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0; t2: 0; 0/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 4: `sign(2,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0; t2: 0; 0/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 5: `prepareB(1)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 0; 0/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 6: `openA(2)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 1; 1/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | - / - / - / - / - |
| 7: `finalize(1,2)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 1; 1/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | 1:2 / - / - / - / - |
| 8: `capture(1,2)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 1; 1/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | 1:2 / 1:2 / - / - / - |
| 9: `prove(1,2)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 1; 1/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / - |
| 10: `deliver(1,2)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 1; 1/0; 0/0; 0 | t1: 0/0; t2: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 11: `commit(2)` | 0 / n/a | t1: 0; 0/1; 0/0; 0; t2: 2; 2/0; 1/0; 0 | t1: 0/0; t2: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-binding`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## replay: S05

Native [ITF](../results/traces/replay.itf.json), [replay](../results/replays/mutant-replay/replay.json). 16 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `prepareB(1)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `finalize(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / - / - / - / - |
| 6: `capture(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / - / - / - |
| 7: `prove(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / - |
| 8: `deliver(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 9: `commit(1)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 10: `finalize(1,3)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2,1:3 / 1:2 / 1:2 / 1:2 / 1:2 |
| 11: `capture(1,3)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2,1:3 / 1:2,1:3 / 1:2 / 1:2 / 1:2 |
| 12: `prove(1,3)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2 |
| 13: `deliver(1,3)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 |
| 14: `learn(1,2,1)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/2 | 0/3 | 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 |
| 15: `applyB(1)` | 0 / n/a | t1: 2; 2/2; 1/1; 0 | t1: 2/2 | 0/0 | 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 |
| 16: `applyB(1)` | 0 / n/a | t1: 2; 2/2; 1/2; 0 | t1: 2/2 | 0/-3 | 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 / 1:2,1:3 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-replay`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## reopen: S02

Native [ITF](../results/traces/reopen.itf.json), [replay](../results/replays/mutant-reopen/replay.json). 8 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `tick` | 1 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `tick` | 2 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 6: `abort(1)` | 2 / n/a | t1: 3; 1/0; 0/0; 0 | t1: 3/0 | 2/3 | - / - / - / - / - |
| 7: `refund(1,0)` | 2 / n/a | t1: 3; 3/0; 0/0; 0 | t1: 3/0 | 2/3 | - / - / - / - / - |
| 8: `openA(1)` | 2 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 3/0 | 2/3 | - / - / - / - / - |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-reopen`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## non_atomic: S08

Native [ITF](../results/traces/non_atomic.itf.json), [replay](../results/replays/mutant-non_atomic/replay.json). 9 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `prepareB(1)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `finalize(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / - / - / - / - |
| 6: `capture(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / - / - / - |
| 7: `prove(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / - |
| 8: `deliver(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 9: `commit(1)` | 0 / n/a | t1: 2; 1/1; 0/0; 0 | t1: 2/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-non_atomic`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## relayer_assertion: S10

Native [ITF](../results/traces/relayer_assertion.itf.json), [replay](../results/replays/mutant-relayer_assertion/replay.json). 6 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `prepareB(1)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `inject(1,2,0)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / 2:2 |
| 6: `commit(1)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | - / - / - / - / 2:2 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-relayer_assertion`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## stale_refund: S09

Native [ITF](../results/traces/stale_refund.itf.json), [replay](../results/replays/mutant-stale_refund/replay.json). 11 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `prepareB(1)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `finalize(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / - / - / - / - |
| 6: `capture(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / - / - / - |
| 7: `prove(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / - |
| 8: `deliver(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 9: `commit(1)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 10: `crash(3)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 11: `unsafeRefund(1)` | 0 / n/a | t1: 2; 2/3; 1/0; 1 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-stale_refund`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

## pruned_tombstone: S02

Native [ITF](../results/traces/pruned_tombstone.itf.json), [replay](../results/replays/mutant-pruned_tombstone/replay.json). 10 transitions; replay matched: True.

| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |
|---|---|---|---|---|---|
| 0: `init` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 1: `sign(1,0)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 2: `sign(1,1)` | 0 / n/a | t1: 0; 0/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 3: `openA(1)` | 0 / n/a | t1: 1; 1/0; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 4: `prepareB(1)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | - / - / - / - / - |
| 5: `finalize(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / - / - / - / - |
| 6: `capture(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / - / - / - |
| 7: `prove(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / - |
| 8: `deliver(1,2)` | 0 / n/a | t1: 1; 1/1; 0/0; 0 | t1: 0/0 | 2/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 9: `commit(1)` | 0 / n/a | t1: 2; 2/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |
| 10: `forgetTerminal(1)` | 0 / n/a | t1: 0; 0/1; 1/0; 0 | t1: 2/0 | 0/3 | 1:2 / 1:2 / 1:2 / 1:2 / 1:2 |

Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-pruned_tombstone`. The guided trace is a small explicit witness; no globally shortest-path claim is made.

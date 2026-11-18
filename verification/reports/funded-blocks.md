# Parallel trades with sufficient block funding

Previously the N3 decision theorem promised a terminal decision under fair time and ABORT. A scheduler could take the height to the deadline before a prepared request was included. The new [block model](../models/dvp_blocks.qnt) explicitly distinguishes included requests at a fixed local height. The [OpenSpec change](../../openspec/changes/settle-funded-blocks/tasks.md) records the stronger guarantee for those requests.

A block uses the current spendable funds, which equal its owner's balance minus outstanding reservations. When the initial spendable amount covers the whole block, the remaining amount always covers the sum of all remaining requests. A completed reservation reduces both by the same quantity. This is why local order alone cannot create a capacity conflict. If there is a genuine shortfall, a request that cannot fit is recorded as unfunded. Its hold and preparation fact are absent, and the other successful local transactions remain in the block. A and B may order their transactions differently.

An A COMMIT uses the hold already funded by that trade. The free balance can be zero before the first COMMIT and after each application while any other holds remain. B applies an authenticated COMMIT to its already funded cash hold. The A height remains at the included block's height through all its transactions. The block seals after every selected request gets a disposition. B has an independent height. Newly included facts wait for their own source block to seal. Previously sealed facts can still be finalized, proved and delivered during another block.

## Observations

| Profile | Result |
|---|---|
| Full funding | TLC exhausted 189 distinct states. The blocks reserve 6 securities and 9 cash units across three trades. All local reservation orders and their A/B interleavings are explored. Preparation proofs are authentic and ready before the A decision block at D−1. Its three COMMITs and the three B applications can execute in any local order. The final state contains three exact authenticated financial records. |
| Short A | TLC exhausted 149 states. A has 4 securities units, B has 9 cash units. A accepts any first two distinct reservations and rejects the remaining request. B accepts all three. |
| Short B | TLC exhausted 149 states. A has 6 securities units, B has 6 cash units. The rejection is local to B. |
| Fault controls | TLC found actual invariant violations for sealing before the remaining transactions get a disposition, checking free balance again at settlement, and ignoring reservations already taken on A or B. |
| Directed cases | Nine Quint cases include complete settlement, deadline D, blocked height advancement within A's block, independent heights, duplicate rejection, an older active hold, ordinary spend before a block, early publication and legitimate progress of older proofs. |

All three valid TLC profiles checked safety and eventual completion with weak fairness of the selected workload, using blockInit, blockStep, sound and includedProgress. Fairness concerns execution of the work already selected in that workload. Blocks in the end-to-end trace have enough execution slots for their chosen transactions. The proof-production and booking prefixes use a fixed authentic schedule. Inclusion of an arbitrary pending submission by D, transport availability and elapsed duration retain their separate evidence scopes. There is no combined A/B execution block.

Eight exact [observations](funded-blocks.json) are selected. Initial harness and local checker failures remain separate. The previous terminal-decision, mixed recovery and repeated settlement profiles retain their original targets and source evidence.

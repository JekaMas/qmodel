# Versioned candidate and model boundary

Candidate v0 is the shared answer saved in sources/shared-solution.original-ru.md. Candidate v1 is the complete self-contained reference in sources/task-v2.md sections 1–2: decision on A, native durable holds, exclusive height deadline and abort tombstones. No architecture substitution is accepted as a repair.

A atomically registers OPEN with its security reservation. B may prepare first without inspecting live A. A commits only using a received authentic finalized B reservation proof, local hold and height < D; recording COMMIT and transferring security is one local transaction and must roll back together. After height >= D, a signed complete descriptor can establish ABORT even without OPEN. Refund is a separately retryable application. B stores authenticated terminal knowledge even before its hold exists; late preparation after unknown ABORT remains resolvable.

Historical authentic proofs remain authentic after the source changes. Their safety depends on durable obligation semantics and terminal knowledge. Network messages carry evidence. A consumer verifies the exact descriptor, source, historical program, checkpoint and statement type before accepting authority. COMMIT and ABORT evidence authorize different terminal dispositions, including when only one hold exists.

The PoC kernel uses one B-preparation proof to decide and one A-outcome proof for remote application. Reporting uses distinct authenticated records from the two local application sources. Lost or stale adapter state is restored from retained evidence. The A-hosted SQLite projection stores one exact row per decision slot with both application identities and rejects conflicting terms. Its trusted inputs are already-authenticated events.

The model separates ledgers and messages. Each actor action reads only its local state and received evidence. Specifications may inspect the combined world. A small explicit message soup is selected for the compact ledger overlay; framework scaffolding would obscure the local transaction/read boundaries. Upstream skill sign-off suggestions are superseded by the user instruction to proceed without routine confirmation.

C-Decision is irreversible backed commitment; C-Local concerns actual local economic application/usability; C-Records concerns evidence-supported reporting. The asynchronous candidate permits unilateral local usability after COMMIT and before remote application.

## Admission and production decision

A-hosted native holds are the approved two-ledger PoC. The first finalized A or B reservation under the admitted epoch creates the obligation that can survive rotation. Both signatures, a queued instruction, registration on D, an OPEN alone and an unfinalized hold confer no such right. Across a cut, the other leg verifies the exact finalized reservation before creating a new hold. It enforces its own eligibility, balance and freeze checks. Local registration belongs to the decision ledger. With D placement a D block finalizes D's OPEN.

In deployment the governance change needs an authenticated cutoff for **each** source and an activation protocol that prevents a source from opening old work beyond its cut. Delayed delivery of an authentic pre-cut reservation can authorize continuation. Duplicate or late submissions with only old signatures cannot. The [cutover model](models/admission_cutover.qnt) uses a local seal on each ledger. A activates the configuration after receiving both authentic seals. During a lost or delayed cut acknowledgement, new-epoch admission waits. An unsealed source can still create a first old reservation before activation. Another source may extend a historical reservation after its own seal only with the opposite finalized proof. Weakly fair sealing, delivery and activation suffice for eventual cutover. Provisional holds that never reached acceptance may expire through the decision ledger's authenticated ABORT path. A renewed instruction carries a distinct signed descriptor. A bank reissuing the same business order must reconcile the original decision slot and prevent duplicate settlement across replacement instructions.

At final A COMMIT the security is delivered and B’s matching cash remains encumbered. During a week-long B halt, the seller’s ability to use cash depends on a separate legal and operational claim. Both banks must identify the debtor, the amount/beneficiary, irrevocability, insolvency treatment, enforcement during the halt and reconciliation preventing a second payout when B recovers. If credit on B is the only final payment, require common atomic execution or a demonstrated equivalent mechanism before adopting this design for strict DvP. Moving the decision to D still leaves independent native application. [Decision record and proof limits](reports/finalized-admission.md)

## Routing when both networks carry both assets

The signed legs identify their issuing ledger, genesis, token, hold contract, payer, beneficiary and quantity. Select the securities ledger as the decision host before admission. A global trade nonce in the finite fixture distinguishes separate signed instructions. A deployment must authenticate the complete decision slot and descriptor on both legs.

| Securities location | Cash location | Decision and native execution |
| --- | --- | --- |
| X | Y | X verifies the matching final Y cash hold and atomically decides and delivers securities. Y pays its seller on the final X decision. |
| Y | X | Y verifies the matching final X cash hold and atomically decides and delivers securities. X pays its seller on the final Y decision. |
| X | X | X checks available securities and cash and exchanges both in one local transaction. |
| Y | Y | Y performs the same local exchange against its own two balances. |

A portfolio can contain all four routes. The free amount on a native account is its balance less outstanding holds against that account. Held cash cannot finance another trade until paid or released. A received transfer can fund a later instruction on that ledger. Opposite hosts may decide concurrently. Each chain orders transactions against its own latest state. Outage consequences follow the affected physical leg for every trade. The banks’ outstanding decision on the seller’s rights during a cash-ledger outage applies symmetrically. [Executable routing contract](SPECIFICATION.md#physical-ledgers-and-concurrent-routes)

## Placement and responsibility

| Placement | Decision authority and local effect | Evidence entering the decision and returning to the legs |
|---|---|---|
| A, reference | A records COMMIT and delivers security in one local transition. | A consumes B's preparation proof. B consumes A's terminal proof. |
| A with authenticated OPEN | A owns the same outcome. B additionally requires received authentic OPEN before preparing. | Historic OPEN can arrive after ABORT. B's local terminal knowledge determines whether preparation can still occur. |
| B | B records COMMIT and delivers cash in one local transition. | B consumes A's preparation proof. A consumes B's terminal proof. |
| D | D records the decision. Each asset leg applies it on its own ledger. | D consumes both preparation proofs. Both legs consume D's terminal proof. |
| Shared execution | One ledger records COMMIT and applies both colocated legs atomically. | Both application effects come from the same local transaction. |

Native holds exclude reserved units from spendable capacity. Escrow also moves the reserved units into a vault. Both use authenticated application records for reconciliation. Proof workers, transport and restored adapter projections have no authority to create a hold, decide or apply value by themselves.

The outcome and record assertions preserve the actual transitions. They link local knowledge to the authoritative outcome, require every co-located application on COMMIT, and use both actual delivery facts to justify a complete report or durable row. A separate prior-state observer checks admitted reservation and terminal immutability in the A-hosted preparation/decision path. [Assurance and receipt scopes](reports/guarantee-validation.md)

The [repeated workload](reports/repeated-settlement-review.md) assigns each signed descriptor its own height deadline, keeps previously consumed identities and observes capacity reuse after a funded ABORT. The quantitative coverage of terminal orders and outages complements the original finite graph and its liveness premises.

An independent block on each ledger contains multiple included transactions at one local height. Each transaction changes only its own trade and the actual shared balance or reservations. Later transactions read the prior result. Holds already reserve the amount required by a commit or application, so a fully reserved account remains eligible to settle those trades. [Block order and funding checks](reports/funded-blocks.md)

The [three-trade fault model](reports/three-trade-faults.md) isolates authenticated source, local transition linearization, and potential progress after independent outages. An authenticated outcome survives delayed or repeated delivery. A correct durable record may outlive a failed client reply. A/B application still has two separate local effect points.

The service model preserves admitted obligations across restart and isolates them from deduplicated hostile requests. A terminal result cannot issue from a local wall clock, displaced command or unconfirmed A head. The clock model represents independent block quotas, offset and drift. The authority model separates predecessor-approved membership from verification of retained old results. It makes the risk of accumulating older signing keys explicit.

The logical contract model records attempts, successful local writes, canonical confirmation and adapter responses as different events. A failed application leaves no durable operation ID. Lost responses can be retried against retained effects; recovered projections have to obtain any missing confirmation. These boundaries enable an independent sequential history check alongside the source ledger effect assertions. [Composed contracts and results](reports/proof-products.md)

See the [executable specification](SPECIFICATION.md#three-distinct-guarantees) for Stage A and the [evidence review](reports/interview-summary.md#question-8-evidence-review) for Stage C and the two-network PoC boundary.

# Versioned candidate and model boundary

Candidate v0 is the shared answer saved in sources/shared-solution.original-ru.md. Candidate v1 is the complete self-contained reference in sources/task-v2.md sections 1–2: decision on A, native durable holds, exclusive height deadline and abort tombstones. No architecture substitution is accepted as a repair.

A atomically registers OPEN with its security reservation. B may prepare first without inspecting live A. A commits only using a received authentic finalized B reservation proof, local hold and height < D; recording COMMIT and transferring security is one local transaction and must roll back together. After height >= D, a signed complete descriptor can establish ABORT even without OPEN. Refund is a separately retryable application. B stores authenticated terminal knowledge even before its hold exists; late preparation after unknown ABORT remains resolvable.

Historical authentic proofs remain authentic after the source changes. Their safety depends on durable obligation semantics and terminal knowledge. Network messages carry evidence. A consumer verifies the exact descriptor, source, historical program, checkpoint and statement type before accepting authority. COMMIT and ABORT evidence authorize different terminal dispositions, including when only one hold exists.

The PoC kernel uses one B-preparation proof to decide and one A-outcome proof for remote application. Reporting uses distinct authenticated records from the two local application sources. Lost or stale adapter state is restored from retained evidence. The A-hosted SQLite projection stores one exact row per decision slot with both application identities and rejects conflicting terms. Its trusted inputs are already-authenticated events.

The model separates ledgers and messages. Each actor action reads only its local state and received evidence. Specifications may inspect the combined world. A small explicit message soup is selected for the compact ledger overlay; framework scaffolding would obscure the local transaction/read boundaries. Upstream skill sign-off suggestions are superseded by the user instruction to proceed without routine confirmation.

C-Decision is irreversible backed commitment; C-Local concerns actual local economic application/usability; C-Records concerns evidence-supported reporting. The asynchronous candidate permits unilateral local usability after COMMIT and before remote application.

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

See the [executable specification](SPECIFICATION.md#three-distinct-guarantees) for Stage A and the [evidence review](reports/interview-summary.md#question-8-evidence-review) for Stage C and the two-network PoC boundary.

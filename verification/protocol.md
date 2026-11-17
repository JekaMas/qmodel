# Versioned candidate and model boundary

Candidate v0 is the shared answer saved in sources/shared-solution.original-ru.md. Candidate v1 is the complete self-contained reference in sources/task-v2.md sections 1–2: decision on A, native durable holds, exclusive height deadline and abort tombstones. No architecture substitution is accepted as a repair.

A atomically registers OPEN with its security reservation. B may prepare first without inspecting live A. A commits only using a received authentic finalized B reservation proof, local hold and height < D; recording COMMIT and transferring security is one local transaction and must roll back together. After height >= D, a signed complete descriptor can establish ABORT even without OPEN. Refund is a separately retryable application. B stores authenticated terminal knowledge even before its hold exists; late preparation after unknown ABORT remains resolvable.

Historical authentic proofs remain authentic after the source changes. Their safety depends on durable obligation semantics and terminal knowledge. Network messages do not authorize financial effects without verification. COMPLETE reporting requires both local application evidence.

The model separates ledgers and messages. Each actor action reads only its local state and received evidence. Specifications may inspect the combined world. A small explicit message soup is selected for the compact ledger overlay; framework scaffolding would obscure the local transaction/read boundaries. Upstream skill sign-off suggestions are superseded by the user instruction to proceed without routine confirmation.

C-Decision is irreversible backed commitment; C-Local concerns actual local economic application/usability; C-Records concerns evidence-supported reporting. The asynchronous candidate permits unilateral local usability after COMMIT and before remote application.

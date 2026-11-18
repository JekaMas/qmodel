# Coverage verdict

The project supplies an executable layered investigation and a scoped evidence matrix. It does not supply an unqualified proof of every configuration, the deployed banking system, legal DvP or cryptographic privacy.

## Contracts

- **C-Decision:** one permanent outcome with actual native/escrow backing and authorized counter-obligations. Reference COMMIT atomically applies security on A. B/D placements have their own local application rules and are checked against the architecture-independent backing contract.
- **C-Local:** both actual local applications eventually occur only under the stated recovery, data, asset-policy and submission assumptions. Immediate joint local usability fails. A private delivered commitment additionally needs the exact note/key.
- **C-Records:** FULLY_APPLIED requires authenticated A/B application evidence. ABORT reconciliation requires authenticated actual/no-obligation application records from each source leg, not a direct remote-state read or relayer acknowledgement.

The selected matrix currently has 241 named checks; unmet or unavailable observations: none. Exact scope and observations are in [the manifest](../results/manifest.json), [property traceability](traceability.md), [variants](../variants.md), and [execution commands](executions.md). Counts are unique executions, not a multiplied claim count.

## Historical resolutions and current repair proofs

The following extended-run measurements describe the previous source revision. The current enriched model is rechecked separately in [QA repair review](qa-repairs.md); its exact observations are manifest.qa_repair_proofs. Original receipts are never relabeled.

## Residual limits and failed attempts

Original full-reference Apalache12/20 and unrestricted-job two-trade/recovery180-second receipts remain timeouts. The extended profile uses8GiB and larger per-invocation budgets. Direct full Apalache12 passed in182.9seconds. Longer direct20 and exact finite-choice SMT probes were explicitly interrupted at native Z3 query cost and remain non-successes. The identical previous full reference was then checked exhaustively by TLC:12,502states, complete graph depth38, S01–S16 and CDecision. This proves all reachable safety prefixes, including20; it is neither an algebraic projection nor a compact-job substitute. The full unrestricted two-trade and recovery temporal checks have separate current native results below. Their hypotheses retain all proof phases0–6 and per-trade/per-action fairness.

## Risk-based interactions

| Interaction | Executed scope | Unchecked remainder |
|---|---|---|
| Two trades + contention + malicious input + outages + witness retention | Deterministic cases and multiple 10,000-trace combined samples; full-proof-job healthy contention and focused B/prover/B-freeze recovery temporal graphs | Arbitrary populations, unlimited hostile traffic and every fault combination |
| Loss/duplicate acknowledgement + adapter restart | Actual message loss/resend and phase-specific restart witnesses | Unbounded adversarial loss under liveness; eventual reliable offer/delivery is required |
| Financial state + full membership governance | Separate economic/control checks, historical-proof witnesses and rotation/exit samples | No checked joint financial/membership liveness composition or arbitrary token/circuit upgrade theorem |
| Upgrade + delayed historical proof; exit with pending obligations | Core witnesses, predecessor-approved rotation and membership retention/replay controls | Real certificates, token proxy migration and all upgrade/data-loss combinations |
| Privacy + actual queue time | State-derived paired payload/timed-pipeline product | General scheduler noninterference, secret-dependent real prover work and termination leaks |
| Three institutional domains + shared cash capacity | Independent domain heights/availability, authenticated outcomes, safety and conditional progress | General n-leg exchange; composed three-domain ABORT-bookkeeping and full relational privacy |
| Private payload loss after ledger delivery | Exact note/key usability guards, loss controls and conditional progress | Actual encryption, note recovery implementation and irreversible key recovery |

There is no checked model-to-code conformance result: no production Solidity/adapters/proof guest were present in the new repository. Upstream kit examples are not treated as the candidate implementation. See [conformance boundary](conformance-boundary.md).


| Original timeout | New observation | Resolution | Proof basis |
|---|---|---|---|
| apalache-core-12 | [extended-apalache-core-12](../results/runs/extended-apalache-core-12/receipt.json) | resolved-by-observed-proof | same full reference, larger budget, invariant-after batching |
| apalache-core-20 | [extended-tlc-full-reference](../results/runs/extended-tlc-full-reference/receipt.json) | resolved-by-observed-proof | exhaustive identical full State/init/step safety covers every depth; original SMT20 remains a non-success |
| tlc-live_two | [extended-tlc-two](../results/runs/extended-tlc-two-attempt1/receipt.json) | resolved-by-observed-proof | same full-proof-job two-trade graph, all actors up, phases0-6 and original per-action temporal fairness |
| tlc-eventual-recovery | [extended-tlc-recovery](../results/runs/extended-tlc-recovery/receipt.json) | resolved-by-observed-proof | same full-proof-job one-trade B/prover-outage and B-freeze recovery graph; original recoveryProgress hypothesis |

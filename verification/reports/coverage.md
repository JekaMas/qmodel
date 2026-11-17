# Coverage verdict

The project supplies an executable layered investigation and a scoped evidence matrix. It does not supply an unqualified proof of every configuration, the deployed banking system, legal DvP or cryptographic privacy.

## Contracts

- **C-Decision:** one permanent outcome with actual native/escrow backing and authorized counter-obligations. Reference COMMIT atomically applies security on A. B/D placements have their own local application rules and are checked against the architecture-independent backing contract.
- **C-Local:** both actual local applications eventually occur only under the stated recovery, data, asset-policy and submission assumptions. Immediate joint local usability fails. A private delivered commitment additionally needs the exact note/key.
- **C-Records:** FULLY_APPLIED requires authenticated A/B application evidence. ABORT reconciliation requires authenticated actual/no-obligation application records from each source leg, not a direct remote-state read or relayer acknowledgement.

The selected matrix currently has 153 named checks; unmet or unavailable observations: none. Exact scope and observations are in [the manifest](../results/manifest.json), [property traceability](traceability.md), [variants](../variants.md), and [execution commands](executions.md). Counts are unique executions, not a multiplied claim count.

## Residual limits and failed attempts

Full-reference Apalache depths 12/20 and the broad unrestricted-job two-trade/recovery temporal runs reached their recorded 180-second limits. Their exact model versions, partial logs and commands remain in the manifest. They are not reclassified as passes. The economic projection has separate Apalache 8/12/20 and inductive results, with a checked finite reference safety mapping. The separately named reference-requested-job two-trade and recovery configurations keep original S/L properties and omit unsolicited A OPEN/local-preparation proof jobs. No liveness-refinement theorem from the broader graphs is claimed.

## Risk-based interactions

| Interaction | Executed scope | Unchecked remainder |
|---|---|---|
| Two trades + contention + malicious input + outages + witness retention | Deterministic cases and multiple 10,000-trace combined samples; finite requested-job temporal configuration | Arbitrary populations, unlimited hostile traffic and every fault combination |
| Loss/duplicate acknowledgement + adapter restart | Actual message loss/resend and phase-specific restart witnesses | Unbounded adversarial loss under liveness; eventual reliable offer/delivery is required |
| Upgrade + delayed historical proof; exit with pending obligations | Core witnesses, predecessor-approved rotation and membership retention/replay controls | Real certificates, token proxy migration and all upgrade/data-loss combinations |
| Privacy + actual queue time | State-derived paired payload/timed-pipeline product | General scheduler noninterference, secret-dependent real prover work and termination leaks |
| Three institutional domains + shared cash capacity | Independent domain heights/availability, authenticated outcomes, safety and conditional progress | General n-leg exchange; composed three-domain ABORT-bookkeeping and full relational privacy |
| Private payload loss after ledger delivery | Exact note/key usability guards, loss controls and conditional progress | Actual encryption, note recovery implementation and irreversible key recovery |

There is no checked model-to-code conformance result: no production Solidity/adapters/proof guest were present in the new repository. Upstream kit examples are not treated as the candidate implementation. See [conformance boundary](conformance-boundary.md).

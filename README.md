# Native-asset delivery versus payment

Two institutions settle a security on one ledger against cash on the other. Each asset stays on its issuing ledger. The parties sign one descriptor that identifies the trade, ledgers, contracts, assets, amounts, accounts and deadline. The securities ledger hosts the authoritative decision. Each ledger verifies finalized evidence from the other before acting on it. [Protocol architecture](verification/protocol.md) · [Executable specification](verification/SPECIFICATION.md)

## How a trade settles

1. The security and cash ledgers reserve the signed amounts. The first finalized reservation on either ledger admits that instruction across a subsequent authority rotation. A reservation for a new trade requires current authority.
2. Before the decision deadline, the securities ledger verifies the matching finalized cash hold. It records COMMIT and delivers the security to the buyer in one local transaction.
3. The cash ledger verifies proof of that COMMIT, consumes its reservation and pays the seller the full amount exactly once. A relayer can retry delivery after an outage. The receiving contract authenticates the evidence and rejects duplicate effects.
4. Once the deadline has been reached, the decision host can record ABORT for an unresolved instruction. Each ledger releases its own outstanding hold to the original owner once it learns that outcome. The cash ledger cannot refund on its own timer. [Decision, application and recording](verification/SPECIFICATION.md#three-distinct-guarantees)

The roles are assigned per trade. Either X or Y can host the securities leg. If both assets are on the same ledger, both transfers settle in one local transaction. Overlapping trades share native balances, and an outstanding reservation reduces the amount available to the next trade. [Four placements and concurrent transactions](verification/SPECIFICATION.md#physical-ledgers-and-concurrent-routes)

## Settlement guarantees

| Property | Checked behaviour |
| --- | --- |
| Decision | Each instruction has one permanent outcome. COMMIT requires the exact funded cash obligation and atomically delivers the security. |
| Recovery | After a cross-ledger COMMIT, the seller’s cash remains reserved during a cash-ledger halt. If that ledger recovers, remains available and fairly services the pending payment, the seller receives the full amount exactly once. Both directions are checked. |
| Financial records | FULLY_APPLIED requires evidence for both native deliveries and a record matching the signed terms. ABORT completion requires release or verified absence of each obligation. |
| Finality | The banks’ rules determine whether final COMMIT or final cash credit discharges the buyer’s debt. The finite model sets no elapsed-time bound for a halted ledger. |

The reference uses native holds. The models also cover alternative decision hosts, escrow, shared execution, private assets and membership changes. Model results apply to the assumptions, configurations and transitions identified in each check. Real QBFT, EVM contracts, proof circuits, token controls and bank integration have separate conformance obligations. [Model assumptions](verification/assumptions.md) · [Protocol variants](verification/variants.md) · [Two-network conformance](verification/reports/guarantee-conformance.md)

## Specification and verification

- [Properties and proof boundaries](verification/properties.md)
- [Protocol lifecycle and checks](verification/coverage-contract.md)
- [Settlement and recovery evidence](verification/reports/settlement-evidence.md)
- [Quint models](verification/models) and [directed tests](verification/tests)
- [Verification commands and toolchain](verification/README.md)

Run the source-bound evidence audit from the repository root with `python3 -B verification/scripts/verify.py audit`.

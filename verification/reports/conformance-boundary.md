# Conformance and external obligations

This is an executable protocol investigation, not a model-to-production proof. The new repository contains no candidate Solidity contracts, production settlement adapters, proof guest/circuit or banking integration. Upstream kit examples are references, not that implementation. The vectors in ../tests/conformance-vectors.json are an interface test specification; no second toy implementation is presented as production conformance.

## Required implementation checks

1. Canonical descriptor encoding binds trade/nonce, both chain and genesis identities, decision-domain identity, assets/contracts, all four accounts, integer quantities, deadline, protocol/configuration epochs and commitment. Verify both parties' signatures on exactly those bytes, independent of which institution hosts their accounts.
2. Prove/check canonical finalized source provenance, accepted predecessor-authenticated checkpoints/validator changes, state membership, exact reservation/outcome semantics and proof-program/version identity. A validator list carried with its own certificate is insufficient. Execution validity must additionally select the canonical native history.
3. On A, registration/security reservation and COMMIT/security transfer each have local EVM atomicity. Token revert, false return, short transfer, reentrancy, arithmetic and unsupported transfer semantics need actual Solidity/EVM tests. No A/B transaction is atomic across separate ledgers.
4. Enforce durable native/escrow reservation control, concurrent availability accounting, exact recipient/quantity and idempotent consumption. Test ordinary spending around holds, independent expiry, forced changes, freezes and upgrades. Record ABORT before potentially failing refunds.
5. Persist terminal knowledge even when no hold exists. Test delayed OPEN, ABORT before prepare, prepare after unknown ABORT, orphan tombstones, old intent/proof replay after pruning and across epochs, duplicate inclusion/delivery and restored old projections.
6. For COMMIT records, authenticate both actual local applications. For ABORT reconciliation, authenticate each leg's actual-refund or no-obligation record. Bind complete descriptor, source genesis, leg, checkpoint/program and disposition. A bare RPC response, transport acknowledgement or adapter work state is not financial authority. Do not manufacture refunds for absent holds.
7. Preserve historical verification/application paths during key/certificate expiry, guest/verifier upgrades and institution exit, while denying retired credentials new admissions. Consumed identities/tombstones survive pruning and later epochs. Prohibit active-current configuration retirement and retirement while its obligations remain pending.
8. Test caller authentication, scoped authorization and actual payload/log/job/backup/report construction. Prove disclosure/opening and recipient-note binding. Measure real proving/queue/error/timing leakage. Require exact recipient note/key availability before claiming usability. Rotation cannot erase previously learned data.
9. Derive audit completeness from authenticated source range/high-water metadata; label as-of, inaccessible/omitted evidence and unknown freshness. A reporter cannot detect an entirely withheld new head without an authenticated freshness mechanism.
10. Test durable evidence/operation IDs, restart and financial-system idempotency at the actual integration boundary. Measure real chain/prover/submission availability, capacity, p50/p95/p99, gas and operating cost on a defined workload.

## Obligations no Quint run closes

- Actual SNARK/circuit constraints, proof-system security and prover/verifier composition; guest-program correctness and public-input encoding.
- Actual QBFT implementation/configuration, source execution and canonical history selection.
- Actual EVM/token/proxy behavior and admitted issuer powers; hardware, HSM, key, storage and network security.
- Computational confidentiality, ciphertext indistinguishability, real side channels and secure key/data recovery.
- Legal finality, account ownership, issuer solvency, insolvency protection, regulatory entitlements and bank financial-record rules.

The ideal authenticated application-record interface inherits the canonical-ledger/finality/crypto assumptions. It does not add trust in an arbitrary relayer assertion. A real implementation must show how source-finalized evidence authenticates that record.

SP1 or another zkVM proves a program under its stated security model; choosing it does not establish that the program implements this protocol or selects the canonical asset history. See the [SP1 security model](https://docs.succinct.xyz/docs/sp1/security/security-model). No SP1 circuit or vendor CLIP implementation was verified here.

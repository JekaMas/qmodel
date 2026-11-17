# Observer policy before model

Base deployment: ordinary local ledger state is visible to its admitted source validators; ZK remote evidence does not hide that state from them. Counterparties know agreed terms and can infer the reciprocal amount. Private-state variants add recipient data availability and key dependencies.

| Observer | Initial/authorized knowledge | Protected from this observer | Surfaces |
|---|---|---|---|
| Counterparties (0) | Their trade identities, accounts, terms, own notes and result | Unrelated positions, policy reasons, other witnesses | API, reports, own custody |
| Unrelated institution (1) | Public program, opaque trade identifier, routing/outcome | Terms, unrelated balances, witnesses, notes, eligibility reasons | Explorer, relay feed |
| Source/destination validators (2) | Their local ordinary EVM state; selected public remote evidence | Remote unrelated positions and private payloads without keys | Ledger, explorer, local logs |
| Relayer (3) | Public inputs, opaque names, outcome, routing, counts/sizes/timing/errors | Plaintext identities/terms, witnesses/notes, unrelated positions | Messages, relay logs/API |
| Prover operator (4) | Exact witness required for its authorized job | Unrelated jobs, recipient decryption keys | Job storage/logs, scoped backup |
| Custody (5) | Authorized account/transfer and recipient payload | Unrelated positions, regulatory disclosure key | Custody API, own backup |
| Support (6) | Redacted stage/errors and queue metadata | Financial terms, witnesses, notes, eligibility reasons | Operational logs/report scope |
| Regulator (7) | Authorized trade and explicit range/high-water mark | Out-of-scope trade, unauthorized witness/note | Scoped reporting and disclosure storage |

Required fields are indexed in the model: identities(0), accounts(1), agreed terms(2), unrelated balances/positions(3), eligibility decision(4), eligibility reason(5), witness(6), recipient note(7), program/public inputs(8), commitment(9), identifier(10), outcome(11), routing(12), counts/sizes(13), errors/timing(14), queue/report scope(15). Protected payload construction is checked for API/log/explorer/job/backup/report surfaces. Opaque cryptographic names preserve equality and linkability; corresponding fresh names across worlds are compared by an explicit bijection, not equal commitment constants.

P-NI varies an unrelated source position (4 versus 7) while the agreed trade, its fundability, all public inputs and permitted disclosure are fixed. Two worlds execute the same public schedule and observer strategy (requests depend only on public phase/previous observations); each computes hidden-dependent branches independently. Visible event sequence includes retries, epoch upgrade, scoped regulator access, length, error and discrete latency. This establishes only coupled-schedule observational equivalence over the finite event horizon. It is not general possibilistic/probabilistic noninterference, termination security or cryptographic ZK. Colluding relayer+unrelated institution share the same public policy; collusion with an entitled prover defeats witness secrecy by policy. Disclosure-key compromise is a separate boundary-breaking control. Rotation cannot erase learned data.

## Field by observer matrix

Cells: T own trade, L own local ledger, J authorized job, O authorized custody operation, R authorized audit range, P explicitly public metadata, and - protected. The role is an authenticated principal identity, not a request-supplied label. Source and destination validators each see their own ordinary EVM state; remote state is a different scope.

| Field | Counterparty | Unrelated institution | Source validators | Destination validators | Relayer | Prover | Custody | Support | Regulator |
|---|---|---|---|---|---|---|---|---|---|
| Identities | T | - | L | L | - | - | O | - | R |
| Wallets/accounts | T | - | L | L | - | - | O | - | R |
| Agreed terms | T | - | L | L | - | J | O | - | R |
| Unrelated positions | - | - | L | L | - | - | - | - | R |
| Eligibility decision | T | - | L | L | - | J | - | - | R |
| Eligibility reason | - | - | L | L | - | J | - | - | R |
| Private witness | - | - | - | - | - | J | - | - | - |
| Recipient note | T | - | - | - | - | - | O | - | - |
| Program/public inputs | P | P | P | P | P | P | P | P | P |
| Commitment/equality links | P | P | P | P | P | P | P | P | P |
| Identifier | P | P | P | P | P | P | P | P | P |
| Outcome | P | P | P | P | P | P | P | P | P |
| Routing | P | P | P | P | P | P | P | P | P |
| Message counts/sizes | P | P | P | P | P | P | P | P | P |
| Errors/timing | P | P | P | P | P | P | P | P | P |
| Queue metadata/report scope | P | P | P | P | P | P | P | P | P |

The paired model keeps a stable public trade link, preserves opaque-name equality on a retried proof, and renames corresponding opaque names between worlds. Actual queue time is exposed in the integrated product. Other public scheduling strategies and termination/side-channel leaks remain outside this coupled-schedule result.

Authenticated audit manifests model source high-water marks 2/3. Reports certify completeness only for that explicit range and label their as-of boundary; they do not claim knowledge of the source current head after an unseen append. No omniscient audit oracle is used.

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

P-NI varies an unrelated source position (4 versus 7) while the agreed trade, its fundability, all public inputs and permitted disclosure are fixed. Two worlds execute the same public schedule and observer strategy (requests depend only on public phase/previous observations); each computes hidden-dependent branches independently. The current state-based pipeline uses a fixed 12-operation public schedule plus at most one arbitrary coupled API request; full observer response bodies, retries, crash/recovery, epoch upgrade, scoped regulator access, lengths, errors and discrete latency enter its observations. This establishes only coupled-schedule observational equivalence over that finite horizon. The older six-event monitor is historical and does not discharge the required payload data path. It is not general possibilistic/probabilistic noninterference, termination security or cryptographic ZK. Colluding relayer+unrelated institution share the same public policy; collusion with an entitled prover defeats witness secrecy by policy. Disclosure-key compromise is a separate boundary-breaking control. Rotation cannot erase learned data.

## Field by observer matrix

Cells: T own trade, L own local ledger, J authorized job, O authorized custody operation, R authorized audit range, P explicitly public metadata, and - protected. The role is an authenticated principal identity, not a request-supplied label. Source and destination validators each see their own ordinary EVM state; remote state is a different scope.

| Field | Counterparty | Unrelated institution | Source validators | Destination validators | Relayer | Prover | Custody | Support | Regulator |
|---|---|---|---|---|---|---|---|---|---|
| Identities | T | - | L | L | - | - | O | - | R |
| Wallets/accounts | T | - | L | L | - | - | O | - | R |
| Agreed terms | T | - | L | L | - | J | O | - | R |
| Unrelated positions | - | - | L | L | - | J if in the required witness | - | - | R |
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

## Implemented data boundary after independent review

privacy_pipeline.qnt is the current mandatory data-path model. Its two World records hold distinct source positions, actual reservations, immutable snapshots, captured witnesses, proofs, applications and recipient notes. Returned Payload has no nested private source witness. Internal Issue provenance is ghost/oracle state and is never part of the API response. PAccess inspects the full returned projection, including redaction of unavailable/denied notes and asset fields. PBinding compares actual returned values/notes to captured source data. PNI includes complete responses visible to roles 1/3, normalized only for the named opaque correspondence. Role 4 can learn a position when it is a component of the witness required by its authorized job; secrecy from that prover or collusion with it is not claimed.

The public schedule is fixed, with one optional arbitrary shared request based on public phase. Private-channel regulator/prover/custody bodies are not relayer-visible; authorized regulator disclosure is deliberate declassification. The relayer still sees its permitted status/size/routing metadata. These are policy/ideal-crypto/channel assumptions, not a proof of deployed confidentiality. The updated timed product consumes this pipeline's actual outputs and the timed worker's public elapsed time/queue depth. Broader schedulers, termination and cryptographic side channels remain outside the result.

## Complete binding and trusted recipient view

Current `disclosureBound` compares all 16field values, full query identity, error/redaction, trade/asset/root/program and exact source-note amount/recipient against separately captured issuance provenance. `observer_view.qnt` adds `TrustedAccess` and `TrustedNI`: authenticated Query principal determines entitlement/recipient and visibility, independently of a constructor's returned role tag. The public body view is combined with the original ordered12-operation metadata history. At most one arbitrary public API response is present, so its set representation loses no public-response multiplicity/order in this scope.

The deliberate role-confused constructor resolves input relayer3as prover4. Old PAccess/PNI alone accept that result; the trusted-query checks reject it. This is an oracle-adequacy fault control, not a claimed attack on the unchanged canonical producer. See [repair report](reports/qa-repairs.md).

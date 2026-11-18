# Assumptions

See assumption-guarantee-matrix.json for ownership, role, lifetime and dependents. Amounts are integers in separate security/cash domains. A height advances through ledger progress only. All modeled domains are finite except deliberately exposed duplicate-effect counters, which are checked before a second payout. No production contact, credentials, assets or paid infrastructure are involved.

Fairness is an environmental premise, never an init assertion. For every trade t, use WF(advanceDecisionHeight), WF(abort(t)), WF(capture(t,phase)), WF(prove(t,phase)), WF(deliver(t,phase)), WF(apply(t,leg)), WF(reconcile(t)). These are justified only after eventual stable recovery of the relevant actors, retained data and submission authority. They guarantee neither a time bound nor COMMIT before D.

## Per-action fairness table

All rows apply separately to each admitted trade; there is no fairness of only the aggregate step.

| Actor/action | Mathematical premise | Operational reason and boundary |
|---|---|---|
| Decision ledger tick | WF(tick) | Healthy admitted ledger eventually advances until the expired-height phase; no wall-time bound follows. |
| Authorized abort submitter | For every t, WF(abort(t)) | Once expired and unresolved, a retained authorized descriptor can submit a tombstone even without OPEN. |
| Source finalization | For every t,p, WF(finalize(t,p)) | Correct recovering source can finalize eligible immutable included history. |
| Evidence/proof worker | For every t,p, WF(capture(t,p)) and WF(prove(t,p)) | Only with retained/reconstructible data and an operational authorized worker. |
| Relayer/delivery | For every t,p, WF(deliver(t,p)) | Valid retained evidence is eventually delivered; authentic facts are not invalidated by later state changes. |
| Local outcome processing | For every t,leg,outcome, WF(learn(t,outcome,leg)) | Recovery resumes each ledger's persistent terminal knowledge, including no-hold cases. |
| Local execution | For every t, WF(applyA/B(t)) and WF(refund(t,leg)) | Requires supported asset semantics, chain progress and an authorized path; mandatory freezes must eventually permit the promised application. |
| Application evidence and records | For every t,leg, WF(observe(t,leg)), WF(captureAbortRecord(t,leg)), WF(reconcile(t)), WF(recordAbort(t)) | Consumers receive authenticated local applications/no-obligation records and use durable operation identities. |
| Private payload delivery | WF(noteDelivery), with <>[] key and service availability | Ledger delivery alone never creates a decryption key or missing recipient note. |
| Actual typed-note pipeline | `always(left.key and right.key) and WF(advance) => eventually(completed)` | The checked 12-operation pipeline needs exact bound note/key data. Its permanent-loss negative control keeps loss in the transition system; no key recreation is claimed. |
| Three-domain installation | For each domain d, WF(tick(d)); for each t, WF of outcome, learn, apply, refund, payload and report | Domain 0/1/2 availability and deadlines are independent. |

The broad core includes phase-0/1 proof jobs. The separately named compact A-hosted configurations request phases 2..6 only, since OPEN/local-preparation proofs are not required on that reference path. They retain the original S/L predicates and the new per-leg ABORT-record actions. The original unrestricted-job attempts timed out. Their new full-job native resolutions are listed in reports/final-review.json; compact results and the economic safety mapping are not used to invent liveness preservation. The N=2 full-job graph keeps all actors available; the N=1 full-job recovery graph admits B/prover outages and B freezes, with eventual stable all-up/unfrozen recovery.

ABORT application records are an ideal authenticated canonical local-ledger read interface. They bind the complete descriptor, leg, genesis, accepted checkpoint/program and refunded-versus-absent disposition. Their producer reads only its source leg; booking consumes received records. Implementation conformance must establish canonical finalized provenance, rather than accepting an RPC/relayer acknowledgement as financial authority.


## Governance and evidence availability

The epoch change is one ordered event in the bounded model. A deployable migration needs authenticated per-ledger cutoff checkpoints and agreed activation rules. A proof of a pre-cut reservation binds the full descriptor, source, program, checkpoint and phase. Historical verifiers and witness data must remain available throughout resolution. Local eligibility, freeze and submission authority still govern execution. Fresh instructions require signatures on the new-epoch descriptor. The model assigns no wall-clock duration to this cut.

The bank API serves the latest verified prefix. Source synchrony and observation of the physical latest head need their own service and finality bounds. A contract history can catch up after restoration only from retained canonical evidence. During a permanent B halt, eventual cash application has no fairness premise. Bank acceptance of the cash entitlement at final A COMMIT is pending. [Acceptance conditions](reports/finalized-admission.md)

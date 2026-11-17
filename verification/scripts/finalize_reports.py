"""Reconcile executed evidence once the model iteration is stable; never invent a pass."""
from pathlib import Path
import json,re,hashlib,datetime,collections
R=Path(__file__).resolve().parents[2];V=R/'verification';O=V/'results';P=V/'reports'
def write(p,s):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s)
def dump(p,d):write(p,json.dumps(d,indent=2)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
receipts=[json.loads(p.read_text()) for p in (O/'runs').glob('*/receipt.json')]
def get(base):
 xs=[r for r in receipts if r['id']==base or r['id'].startswith(base+'-attempt')]
 return max(xs,key=lambda x:x['started_utc']) if xs else None
def good(base):
 r=get(base);return bool(r and r['expectation_met'])
def link(base):
 r=get(base)
 return f"[{base}](../results/runs/{r['id']}/receipt.json)" if r else base+' (not_run)'
# These select actual observations. Historical tool errors, repaired failures and timeouts stay in the manifest.
primary=['final-record-safety','final-record-progress','final-record-two','final-record-recovery','final-record-mapping',
 'final-algebraic-induction','apalache-algebraic-8','apalache-algebraic-12','apalache-algebraic-20',
 'linked-privacy-privacy_safe','tlc-privacy_safe-PAccess','tlc-privacy_safe-PBinding','tlc-privacy_safe-PScope',
 'linked-privacy-witness_log','linked-privacy-timing_leak','tlc-unsalted-PNI','tlc-wrong_scope-PAccess','tlc-disclosure_substitution-PBinding',
 'actual-queue-time-privacy','actual-b-clock-expiry','exact-deadline-margin','one-less-deadline-margin','private-data-progress','private-permanent-key-loss',
 'tlc-bounded-safe','tlc-bounded-sufficientSlack','tlc-slow_blocks-safe','tlc-no_inclusion-boundedCompletion','tlc-starvation-boundedCompletion','tlc-frozen_time-timeProgress',
 'post-stabilization','unbounded-prefix-no-fixed-bound','late-hold-relative-bound','queue-capacity-progress',
 'auth-direct','auth-zk_consensus','auth-execution','auth-direct_bad_execution','auth-zk_bad_execution','auth-execution_rejects_invalid','auth-execution_rejects_history',
 'trust-v2-trust_safe','trust-v2-retired_version','trust-v2-committee_refusal','trust-v2-insufficient_submitters','trust-v2-witness_loss',
 'tlc-equivocation-canonicalAcceptance','tlc-issuer_destruction-backed','tlc-verifier_takeover-canonicalAcceptance',
 'tlc-durable-safe','tlc-coordinated-safe','tlc-mandatory_freeze-progress','tlc-arbitrary_seizure-backing',
 'membership-retirement-final','membership-unsafe-retirement','membership-consumed-replay','membership-lifecycle-tests',
 'three-domain-installation-final','three-domain-progress','three-independent-domains-witnesses',
 'audit-audit_safe','audit-omitted_record','overclaim-immediate','overclaim-permanent-halt','htlc-bounded-margins','htlc-permanent-halt',
 'abort-authoritative-records','report-evidence-scenario','delayed-open-fact-scenarios','network-loss-recovery',
 'combined-faults-17','combined-faults-43','final-combined-faults-43','preparation-freeze-policy']
primary += ['final-variant-'+x for x in ['live_open','live_b','live_d','live_escrow','private_asset','shared_execution']]
primary += ['mutant-'+x for x in ['expiry','binding','replay','reopen','non_atomic','relayer_assertion','stale_refund','pruned_tombstone']]
primary += ['d-outage-return-paths']
primary += ['root-local-progress','root-local-immediate','root-local-halt','root-local-witness']
primary += sorted(r['id'] for r in receipts if r['id'].startswith('type-final-'))
# Stable IDs and scoped claims: one conjunction check is one execution, not sixteen fabricated runs.
prop_evidence={
 'S01':['final-record-safety'],'S02':['final-record-safety','mutant-reopen','mutant-pruned_tombstone'],
 'S03':['final-record-safety','scenario-bindings_test','scenario-policy_test'],
 'S04':['final-record-safety','scenario-contention_test','final-variant-live_escrow','three-domain-installation-final'],
 'S05':['final-record-safety','mutant-replay','abort-authoritative-records'],
 'S06':['final-record-safety','mutant-relayer_assertion','abort-authoritative-records'],
 'S07':['final-record-safety','mutant-expiry','tlc-issuer_destruction-backed'],
 'S08':['final-record-safety','final-record-mapping','mutant-expiry','mutant-non_atomic'],
 'S09':['final-record-safety','mutant-stale_refund','actual-b-clock-expiry'],
 'S10':['final-record-safety','mutant-binding','scenario-bindings_test'],
 'S11':['final-record-safety','scenario-open_test','delayed-open-fact-scenarios','membership-lifecycle-tests'],
 'S12':['final-record-safety','final-record-recovery','scenario-recovery_test','network-loss-recovery'],
 'S13':['final-record-safety','membership-retirement-final','membership-lifecycle-tests','trust-v2-retired_version'],
 'S14':['final-record-safety','scenario-policy_test','preparation-freeze-policy','scenario-shared_policy_test','tlc-durable-safe','tlc-mandatory_freeze-progress','tlc-arbitrary_seizure-backing'],
 'S15':['final-record-safety','report-evidence-scenario','abort-authoritative-records'],
 'S16':['final-record-safety','membership-lifecycle-tests','negative-disclosure_key_compromise'],
 'L01':['final-record-progress','final-record-two','final-record-recovery','three-domain-progress'],
 'L02':['final-record-progress','final-record-two','final-record-recovery','private-data-progress'],
 'L03':['final-record-progress','final-record-two','late-hold-relative-bound','three-domain-progress'],
 'L04':['final-record-progress','final-record-two','final-record-recovery','report-evidence-scenario'],
 'C-Decision':['final-record-safety','final-record-mapping','contract-b_hosted','contract-d_shared'],
 'C-Local':['final-record-progress','private-data-progress'],'C-Records':['final-record-safety','abort-authoritative-records'],
 'O-Immediate':['overclaim-immediate'],'O-Permanent':['overclaim-permanent-halt'],
 'P-Access':['tlc-privacy_safe-PAccess','tlc-wrong_scope-PAccess','linked-privacy-witness_log'],
 'P-Binding':['tlc-privacy_safe-PBinding','tlc-disclosure_substitution-PBinding'],
 'P-Availability':['private-data-progress','private-permanent-key-loss','negative-wrong_note'],
 'P-Scope':['audit-audit_safe','audit-omitted_record'],
 'P-NI':['linked-privacy-privacy_safe','linked-privacy-witness_log','tlc-unsalted-PNI'],
 'P-Timing':['linked-privacy-timing_leak','actual-queue-time-privacy'],
 'T-Async':['final-record-safety','combined-faults-17','combined-faults-43','final-combined-faults-43'],
 'T-Eventual':['final-record-recovery','post-stabilization'],
 'T-Bounded':['tlc-bounded-safe','exact-deadline-margin','one-less-deadline-margin','late-hold-relative-bound'],
 'T-Capacity':['queue-capacity-progress','tlc-starvation-boundedCompletion','tlc-unlimited-exposure']}
extra_properties=[
 ('R-Core','Successful settlement, actual reservations, application lag, abort/orphan resolution and recovery are reachable.','reachability/non-vacuity','Explicit finite runs reach the named .expect predicates in dvp_test.',['scenario-dvp_test','scenario-recovery_test','network-loss-recovery']),
 ('R-Policy','Admission and independent eligibility/freeze rejection paths are exercised.','reachability/non-vacuity','membership_lifecycle tests and policy tests reach admitted/pending/retired states and reject frozen preparation.',['membership-lifecycle-tests','preparation-freeze-policy']),
 ('R-Audit','Authorized audit and real omission detection are reachable.','reachability/non-vacuity','audit_safe final report is complete for received authenticated high-water; omitted_record violates scopeCompleteness.',['audit-audit_safe','audit-omitted_record']),
 ('V-AOpen','Authenticated OPEN retains safe delayed historical preparation and resolution.','operational integration','safe /\\ CDecision; fair => L01 /\\ L02 /\\ L03 /\\ L04',['final-variant-live_open','delayed-open-fact-scenarios']),
 ('V-B','B-hosted decision uses local cash and authenticated A preparation.','operational integration','safe /\\ CDecision; fair => L01 /\\ L02 /\\ L03 /\\ L04',['final-variant-live_b']),
 ('V-D','Separate D authenticates both preparations and both return paths.','operational integration','safe /\\ CDecision; fair => L01 /\\ L02 /\\ L03 /\\ L04',['final-variant-live_d','d-outage-return-paths']),
 ('V-Escrow','Escrow moves reserved ownership into the vault with no duplicate capacity.','operational integration','safe /\\ CDecision; fair => progress; witness reaches actual vault movement and final effects.',['final-variant-live_escrow','witness-escrow_path_test']),
 ('V-Private','Private ledger application and actual note/key usability remain distinct.','operational integration','safe /\\ CDecision; availability assumptions => delivered ~> usable',['final-variant-private_asset','private-data-progress','private-permanent-key-loss']),
 ('V-Shared','Co-resident opposite-direction transfers apply atomically on the shared control ledger.','operational integration','safe /\\ CDecision; exact success witness reaches both effects in the one ledger action.',['final-variant-shared_execution','witness-shared_path_test']),
 ('V-Three','Three independent domains share capacity without unauthenticated remote application.','operational integration','safe; recovery/fairness => per-trade decision, application/refund and COMMIT reporting',['three-domain-installation-final','three-domain-progress','three-independent-domains-witnesses'])]
for pid,req,kind,pred,ids in extra_properties:prop_evidence[pid]=ids
props=json.loads((V/'properties.json').read_text())
for pid,req,kind,pred,ids in extra_properties:
 if not any(p['id']==pid for p in props):props.append(dict(id=pid,requirement=req,predicate=pred,classification=kind,assumptions=['A-FINAL','A-EXEC','A-CRYPTO','A-HOLD','A-BOUNDS'],actions=['exact named actions in the recorded input closure'],scenario=req,checker='TLC finite or explicit Quint test; see executed_checks',expected='named scoped observation',status='required-in-this-model'))
for p in props:
 if p['classification']=='external obligation':continue
 ids=prop_evidence.get(p['id'],[]);p['executed_checks']=ids;p['execution_status']='executed-with-result' if ids and all(good(i) for i in ids) else 'blocked'
 p['status']=p['execution_status']
 p['verified_scope']='Finite instantiated models and exact guard/witness cases; see coverage and proof boundaries. No deployed-system or parameterized theorem.'
 p['actions']={'S03':['sign','requestOpen','requestCash'],'S06':['commit','applyA','applyB','refund','captureAbortRecord','recordAbort'],'S10':['inject','authFact','requestOpen'],'S14':['openA','prepareB','revokeLeg','freeze','unfreeze'],'S15':['observe','reconcile','captureAbortRecord','recordAbort','progressReport']}.get(p['id'],p['actions'])
 p['quint_owner']='verification/models/dvp.qnt' if p['id'].startswith('S') else 'see executed check input closures'
 if p['id']=='S14':p['verified_scope']='Preparation guards tested for independent local eligibility; supported durable/freeze/seizure policies checked separately. The S14 state predicate alone is not a historical eligibility theorem or regulatory-compliance proof.'
 if p['id']=='P-NI':p['verified_scope']='Two hidden inputs 4/7, same authorized public trade/fundability, coupled public schedule, stable public trade link, opaque-name correspondence and six visible phases; not general nondeterministic noninterference.'
 if p['id']=='L04':p['verified_scope']='Reference one/two-trade configurations include COMMIT receipts and authenticated actual/absent-leg ABORT records. Three-domain progress covers COMMIT reports; no composed three-domain ABORT-bookkeeping theorem.'
external=[('EX-Crypto','Actual circuits, guest programs, public-input encoding and prover/verifier composition.'),('EX-Execution','Actual QBFT, EVM, Solidity, reentrancy, arithmetic and token/proxy semantics.'),('EX-Security','Hardware, custody, keys, storage, networks and durable evidence implementation.'),('EX-Privacy','Computational confidentiality, real side channels and general scheduler noninterference.'),('EX-Performance','Measured latency/availability, proving cost, gas, throughput and production capacity.'),('EX-Legal','Legal finality, account/issuer rights, solvency and financial-record rules.')]
for pid,req in external:
 if not any(p['id']==pid for p in props):props.append(dict(id=pid,requirement=req,predicate='External implementation/institutional evidence required; not a Quint theorem.',classification='external obligation',assumptions=[],actions=['see conformance-boundary.md'],scenario='production implementation absent',checker='external conformance/security/legal/measurement review',expected='not established by this project',status='external-obligation',execution_status='external-obligation',executed_checks=[],verified_scope='Not verified; practical interface specification only.'))
dump(V/'properties.json',props)
# Traceability stays explicit; external obligations are not converted into passing model claims.
write(P/'traceability.md','# Requirement to executed evidence\n\nEach row names the actual scoped checks. A check of `safe` verifies its stated conjunction once; counts are not multiplied by the number of rows.\n\n| Requirement | Assumptions | Actions/scenario | Executed checks | Boundary |\n|---|---|---|---|---|\n'+'\n'.join(f"| {p['id']}: {p['requirement'].split('.')[0]} | {', '.join(p['assumptions'])} | {', '.join(p['actions'][:4])} | {', '.join(link(i) for i in p['executed_checks'])} | {p['verified_scope']} |" for p in props)+'\n')
# Lifecycle matrix: a listed fault is not discharged until its named execution exists.
phase_map={
 'PH-01':['membership-retirement-final','membership-lifecycle-tests'],'PH-02':['scenario-bindings_test','scenario-dvp_test'],
 'PH-03':['scenario-policy_test','membership-lifecycle-tests'],'PH-04':['scenario-dvp_test','scenario-contention_test'],
 'PH-05':['scenario-contention_test','queue-capacity-progress'],'PH-06':['scenario-dvp_test','witness-escrow_path_test'],
 'PH-07':['final-record-safety','scenario-recovery_test'],'PH-08':['network-loss-recovery','scenario-recovery_test'],
 'PH-09':['final-record-safety','combined-faults-17'],'PH-10':['network-loss-recovery','combined-faults-43'],
 'PH-11':['final-record-safety','overclaim-immediate'],'PH-12':['scenario-dvp_test','mutant-non_atomic'],
 'PH-13':['final-record-safety','delayed-open-fact-scenarios'],'PH-14':['final-record-progress','late-hold-relative-bound'],
 'PH-15':['private-data-progress','private-permanent-key-loss'],'PH-16':['report-evidence-scenario','abort-authoritative-records','audit-audit_safe'],
 'PH-17':['membership-lifecycle-tests','final-record-recovery','network-loss-recovery']}
coverage=json.loads((V/'coverage-contract.json').read_text())
for item in coverage:
 item['implementation_status']='implemented'
 if item['id'] in phase_map:
  ids=phase_map[item['id']];item['checks']=ids;item['status']='executed-with-result' if all(good(i) for i in ids) else 'blocked';item['verification_status']=[get(i)['outcome'] if get(i) else 'not_run' for i in ids]
 else:
  # Detailed procedural/semantic bullet inventory is reviewed, not advertised as 137 independently executed properties.
  item['status']='required-in-this-model';item['verification_status']='reviewed_against_scoped_matrix';item['evidence_boundary']='See traceability.md, variant matrix, methods/limits and source task section; this bullet is not counted as a separate check.'
  if any(w in item['requirement'].lower() for w in ['do not claim snark','real performance','legal finality','actual circuit constraints','do not contact real','production blockchain deployment']):item['status']='external-obligation';item['verification_status']='not_established_by_quint'
dump(V/'coverage-contract.json',coverage)
write(V/'coverage-contract.md','# Coverage contract and lifecycle\n\nImplementation and verified-property status remain distinct. The full literal v2 bullet inventory is in coverage-contract.json; only named actual checks are execution evidence. A reviewed bullet is not an independently verified property.\n\n| Phase | Actual checks | Result |\n|---|---|---|\n'+'\n'.join(f"| {i['requirement']} | {', '.join(link(c) for c in i['checks'])} | {i['status']} |" for i in coverage if i['id'] in phase_map)+'\n\nC-Decision, C-Local and C-Records remain distinct. General n-leg exchange, FX, repo maturity, netting, external funding/redemption, legal rights, circuit soundness and production deployment are external or excluded as stated in the original task. No implementation proof is claimed.\n')
variant_checks={
 'A-tombstone':['final-record-safety','final-record-progress'],'A-open':['final-variant-live_open','delayed-open-fact-scenarios'],
 'B-hosted':['final-variant-live_b'],'D-shared':['final-variant-live_d','d-outage-return-paths'],'escrow':['final-variant-live_escrow','witness-escrow_path_test'],
 'private':['final-variant-private_asset','private-data-progress','private-permanent-key-loss'],
 'multilateral':['three-domain-installation-final','three-domain-progress','three-independent-domains-witnesses'],
 'htlc':['htlc-bounded-margins','htlc-permanent-halt','scenario-htlc_test'],
 'gpact':['root-local-progress','root-local-immediate','root-local-halt','root-local-witness'],'shared-execution':['final-variant-shared_execution','witness-shared_path_test','scenario-shared_test'],
 'committee':['simulate-committee_honest-safe','simulate-committee_compromised-backed','witness-committee_test','trust-v2-committee_refusal'],
 'auth-direct':['auth-direct','auth-direct_bad_execution'],'auth-zk':['auth-zk_consensus','auth-zk_bad_execution'],
 'auth-execution':['auth-execution','auth-execution_rejects_invalid','auth-execution_rejects_history']}
variants=json.loads((V/'variants.json').read_text())
for v in variants:
 v['checks']=variant_checks[v['id']];v['status']='executed-with-result' if all(good(i) for i in v['checks']) else 'blocked';v['result']=[get(i)['outcome'] if get(i) else 'not_run' for i in v['checks']]
 v['mapping']='C-Decision/C-Local/C-Records as scoped; economic safety mapping only for A-hosted native one-trade core'
dump(V/'variants.json',variants)
write(V/'variants.md','# Executed variant matrix\n\nThe variants are our abstract representatives. No vendor implementation is verified. The shared-execution control explicitly puts both assets on the same chain/genesis with opposite buyer/seller directions; it is not the two-chain reference. D is a third ledger, not automatically a third independent financial institution.\n\n| Variant | Actual observations | Scope/result |\n|---|---|---|\n'+'\n'.join(f"| {v['id']}: {v['description']} | {', '.join(link(i) for i in v['checks'])} | {v['status']} |" for v in variants)+'\n\nThe multilateral installation has three independent availability/height domains, two security sources (0/2), a shared cash source (1), authenticated domain-bound outcomes, separate reservations and B-local terminal knowledge. Its separate progress theorem includes per-trade application/refund and COMMIT reporting.\n\nThe HTLC representative gives the secret to the buyer, an A claim deadline 3 and B deadline 6, with explicit observation/inclusion margins. The narrow root/signalling representative omits arbitrary nested call trees, dynamic contract graphs and vendor recovery details. The committee comparison authenticates a remote fact under an honest threshold and separately breaks it under a compromised threshold; a mandatory committee can still block availability even with additional proof checks.\n')
# Every execution keeps its raw result. Augment, never overwrite actual recorded hashes/outcomes.
for r in receipts:
 cmd=r['command'];model=next((x for x in cmd if x.endswith('.qnt')),'unavailable')
 r['variant']=r.get('configuration',{}).get('main') or (cmd[cmd.index('--main')+1] if '--main' in cmd else 'tooling')
 r['observer']='relayer/public coupled observations or explicit scoped API roles' if any(x in model for x in ['privacy','integrated','audit']) else 'not_applicable'
 r['time_regime']='T-Bounded' if any(x in model for x in ['timing','stabilization','late_resolution','integrated']) else 'T-Eventual' if '--temporal' in cmd else 'T-Async'
 r['fault_model']=r.get('configuration',{}).get('scope') or r['id']
 r['assumption_version']='verification/assumption-guarantee-matrix.json; exact model-input closure retained'
 r['fairness']='exact --temporal formula in recorded input closure; per-trade/per-action WF and stated recovery' if '--temporal' in cmd else 'none needed for safety; deterministic/sampled schedule as commanded'
 r['bounds']='Exact instantiated constants in recorded model closure; core N=1/2, security=2, cash=3, D=2, epochs 0/1; specialized bounds in configuration/docs.'
 if '--backend' in cmd and cmd[cmd.index('--backend')+1]=='rust':r['tool_versions']['evaluator']='v0.7.1'
 else:r['tool_versions']['evaluator']='typescript under Quint 0.33.1 or not_applicable'
 r['mapping_version']='mapping.qnt economic safety projection' if 'mapping' in model else 'none; relationships informal unless explicitly checked'
 r['native_trace']='backend-native counterexample retained in raw output' if 'counterexample' in r['outcome'] else 'not_applicable'
# A single final content inventory. The original per-execution hashes are unchanged.
models={str(p.relative_to(R)):sha(p) for p in sorted((V/'models').glob('*.qnt'))}
counts=collections.Counter(r['outcome'] for r in receipts)
manifest={'schema_version':2,'generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'implementation_status':'DONE','verification_verdict':'scoped evidence matrix; no unqualified all-configurations or deployed-system verification',
 'required_scoped_checks':primary,'unmet_scoped_checks':[i for i in primary if not good(i)],
 'historical_broader_timeouts':[r['id'] for r in receipts if r['outcome']=='timeout'],
 'counterexample_classification':{'A':'isolated protocol mutants','B':'violated environment/trust assumptions','C':'overstrong contracts'},
 'executions':receipts,'outcome_counts':dict(counts),'final_model_hashes':models,
 'external_obligations':['circuits/prover/verifier implementation','actual QBFT/EVM/token execution','key/hardware/storage/network security','cryptographic privacy and real side channels','availability/cost measurement','legal/account/issuer rights and financial records'],
 'source_inventory':'verification/sources/source-inventory.json','scope_warning':'Original PDF/workspace sources were absent; self-contained v2 and recovered shared answer are the authority. Larger timed-out runs are not passes.'}
dump(O/'manifest.json',manifest)
dump(V/'configs/acceptance.json',{'required':primary,'historical_timeouts_are_not_passes':True,'full_configuration_claim':False})
# Concise result index with direct reproduction commands.
write(P/'executions.md','# Executed checks and exact commands\n\nRaw receipts include source closures, hashes, toolchain, bounds, resources, exit code and wall time. TLC state counts are shown only when reported; Apalache counts are unavailable unless its output reports them.\n\n| Check | Backend | Outcome | Distinct states | Exact command / receipt |\n|---|---|---|---|---|\n'+'\n'.join(f"| {r['id']} | {r['backend']} | {r['outcome']} | {r['distinct_states']} | [{r['shell_command']}](../results/runs/{r['id']}/receipt.json) |" for r in sorted(receipts,key=lambda r:r['started_utc']))+'\n')
write(P/'coverage.md','''# Coverage verdict

The project supplies an executable layered investigation and a scoped evidence matrix. It does not supply an unqualified proof of every configuration, the deployed banking system, legal DvP or cryptographic privacy.

## Contracts

- **C-Decision:** one permanent outcome with actual native/escrow backing and authorized counter-obligations. Reference COMMIT atomically applies security on A. B/D placements have their own local application rules and are checked against the architecture-independent backing contract.
- **C-Local:** both actual local applications eventually occur only under the stated recovery, data, asset-policy and submission assumptions. Immediate joint local usability fails. A private delivered commitment additionally needs the exact note/key.
- **C-Records:** FULLY_APPLIED requires authenticated A/B application evidence. ABORT reconciliation requires authenticated actual/no-obligation application records from each source leg, not a direct remote-state read or relayer acknowledgement.

'''+f"The selected matrix currently has {len(primary)} named checks; unmet or unavailable observations: {', '.join(manifest['unmet_scoped_checks']) or 'none'}. Exact scope and observations are in [the manifest](../results/manifest.json), [property traceability](traceability.md), [variants](../variants.md), and [execution commands](executions.md). Counts are unique executions, not a multiplied claim count.\n\n"+'''## Residual limits and failed attempts

Full-reference Apalache depths 12/20 and the broad unrestricted-job two-trade/recovery temporal runs reached their recorded 180-second limits. Their exact model versions, partial logs and commands remain in the manifest. They are not reclassified as passes. The economic projection has separate Apalache 8/12/20 and inductive results, with a checked finite reference safety mapping. The separately named reference-requested-job two-trade and recovery configurations keep original S/L properties and omit unsolicited A OPEN/local-preparation proof jobs. No liveness-refinement theorem from the broader graphs is claimed.

## Risk-based interactions

| Interaction | Executed scope | Unchecked remainder |
|---|---|---|
| Two trades + contention + malicious input + outages + witness retention | Deterministic cases and multiple 10,000-trace combined samples; finite requested-job temporal configuration | Arbitrary populations, unlimited hostile traffic and every fault combination |
| Loss/duplicate acknowledgement + adapter restart | Actual message loss/resend and phase-specific restart witnesses | Unbounded adversarial loss under liveness; eventual reliable offer/delivery is required |
| Upgrade + delayed historical proof; exit with pending obligations | Core witnesses, predecessor-approved rotation and membership retention/replay controls | Real certificates, token proxy migration and all upgrade/data-loss combinations |
| Privacy + actual queue time | Small paired observation/timed-pipeline product | General scheduler noninterference, secret-dependent real prover work and termination leaks |
| Three institutional domains + shared cash capacity | Independent domain heights/availability, authenticated outcomes, safety and conditional progress | General n-leg exchange; composed three-domain ABORT-bookkeeping and full relational privacy |
| Private payload loss after ledger delivery | Exact note/key usability guards, loss controls and conditional progress | Actual encryption, note recovery implementation and irreversible key recovery |

There is no checked model-to-code conformance result: no production Solidity/adapters/proof guest were present in the new repository. Upstream kit examples are not treated as the candidate implementation. See [conformance boundary](conformance-boundary.md).
''')
print(json.dumps({'executions':len(receipts),'outcomes':dict(counts),'unmet_scoped':manifest['unmet_scoped_checks']}))

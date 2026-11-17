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
primary += ['review-type-privacy_pipeline','review-type-integrated','review-type-privacy_pipeline_test','review-type-private-progress',
 'review-pipeline-safe','review-pipeline-PAccess','review-pipeline-PBinding','review-pipeline-PNI',
 'review-pipeline_log','review-pipeline_timing','review-pipeline_unsalted','review-pipeline_scope','review-pipeline_substitution','review-pipeline_note','review-pipeline_compromise',
 'review-pipeline-witnesses','review-privacy-time-integrated-safe','review-privacy-time-integrated-noUsability','review-privacy-time-integrated_leak-safe',
 'review-typed-private-availability','review-typed-private-unconditionalAvailability','review-fifo-workload']
primary += sorted(r['id'] for r in receipts if r['id'].startswith('type-final-'))
primary += ['extended-apalache-core-12','extended-tlc-full-reference','extended-tlc-two','extended-tlc-recovery',
 'final-phase-type','final-phase-failure-witnesses','final-report-view-stages','final-resource-profile-native-type','replay-final-resource-profile-native-type']
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
 'P-Access':['review-pipeline-PAccess','review-pipeline_scope','review-pipeline_compromise'],
 'P-Binding':['review-pipeline-PBinding','review-pipeline_substitution'],
 'P-Availability':['review-pipeline-safe','review-typed-private-availability','review-typed-private-unconditionalAvailability','review-pipeline_note','review-pipeline-witnesses'],
 'P-Scope':['audit-audit_safe','audit-omitted_record'],
 'P-NI':['review-pipeline-PNI','review-pipeline_log','review-pipeline_unsalted'],
 'P-Timing':['review-pipeline_timing','review-privacy-time-integrated-safe','review-privacy-time-integrated_leak-safe'],
 'T-Async':['final-record-safety','combined-faults-17','combined-faults-43','final-combined-faults-43'],
 'T-Eventual':['final-record-recovery','post-stabilization'],
 'T-Bounded':['tlc-bounded-safe','exact-deadline-margin','one-less-deadline-margin','late-hold-relative-bound'],
 'T-Capacity':['queue-capacity-progress','tlc-starvation-boundedCompletion','tlc-unlimited-exposure']}
# Full-state/full-job results supplement the retained scoped observations.
for pid in ['S'+str(n).zfill(2) for n in range(1,17)]+['C-Decision']:
 prop_evidence[pid]=['extended-tlc-full-reference','extended-tlc-two','extended-tlc-recovery']+prop_evidence[pid]
for pid in ['L01','L02','L03','L04','C-Local','T-Eventual']:
 prop_evidence[pid]=['extended-tlc-two','extended-tlc-recovery']+prop_evidence[pid]
for pid in ['S06','S12','L02','L03','R-Core']:
 prop_evidence.setdefault(pid,[]).append('final-phase-failure-witnesses')
prop_evidence['S15'].append('final-report-view-stages')
extra_properties=[
 ('R-Core','Successful settlement, actual reservations, application lag, abort/orphan resolution and recovery are reachable.','reachability/non-vacuity','Explicit finite runs reach the named .expect predicates in dvp_test.',['scenario-dvp_test','scenario-recovery_test','network-loss-recovery','final-phase-failure-witnesses']),
 ('R-Policy','Admission and independent eligibility/freeze rejection paths are exercised.','reachability/non-vacuity','membership_lifecycle tests and policy tests reach admitted/pending/retired states and reject frozen preparation.',['membership-lifecycle-tests','preparation-freeze-policy']),
 ('R-Audit','Authorized audit and real omission detection are reachable.','reachability/non-vacuity','audit_safe final report is complete for received authenticated high-water; omitted_record violates scopeCompleteness.',['audit-audit_safe','audit-omitted_record']),
 ('V-AOpen','Authenticated OPEN retains safe delayed historical preparation and resolution.','operational integration','safe /\\ CDecision; fair => L01 /\\ L02 /\\ L03 /\\ L04',['final-variant-live_open','delayed-open-fact-scenarios']),
 ('V-B','B-hosted decision uses local cash and authenticated A preparation.','operational integration','safe /\\ CDecision; fair => L01 /\\ L02 /\\ L03 /\\ L04',['final-variant-live_b']),
 ('V-D','Separate D authenticates both preparations and both return paths.','operational integration','safe /\\ CDecision; fair => L01 /\\ L02 /\\ L03 /\\ L04',['final-variant-live_d','d-outage-return-paths']),
 ('V-Escrow','Escrow moves reserved ownership into the vault with no duplicate capacity.','operational integration','safe /\\ CDecision; fair => progress; witness reaches actual vault movement and final effects.',['final-variant-live_escrow','witness-escrow_path_test']),
 ('V-Private','Private ledger application and actual note/key usability remain distinct.','operational integration','safe /\\ CDecision; availability assumptions => delivered ~> usable',['final-variant-private_asset','review-pipeline-safe','review-typed-private-availability','review-typed-private-unconditionalAvailability']),
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
 if p['id']=='S13':p['verified_scope']='Core S13 retains program1 only. The focused membership model checks approved/current credentials, pending/current-safe retirement and consumed identities. No checked full financial/membership liveness composition or arbitrary-upgrade theorem.'
 if p['id']=='S15':p['verified_scope']='Source-world diagnostics distinguish authorized, source accepted, registered, prepared, committed, applied and reconciled. Six acceptance cases and authentic application/ABORT-record gates execute. External APIs must authenticate every source-dependent field; no implemented reporter conformance is claimed.'
 if p['id']=='S12':p['verified_scope']='Full-job N=1 B/prover-crash and B-freeze recovery graph, plus19 direct phase-guard/recovery scenarios and actual message-loss/restart witnesses. No arbitrary independent operational fault product.'
 if p['id']=='S14':p['verified_scope']='Preparation guards tested for independent local eligibility; supported durable/freeze/seizure policies checked separately. The S14 state predicate alone is not a historical eligibility theorem or regulatory-compliance proof.'
 if p['id']=='P-NI':p['verified_scope']='Two actual source positions 4/7, equal authorized trade/funding; one fixed 12-operation public lifecycle plus at most one arbitrary coupled API request. Complete selected-observer response histories, private-channel/declassification policy and content-aware opaque-name correspondence. Not general scheduler/termination/cryptographic noninterference.'
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
 'PH-07':['extended-tlc-full-reference','scenario-recovery_test','final-phase-failure-witnesses'],'PH-08':['network-loss-recovery','scenario-recovery_test'],
 'PH-09':['final-record-safety','combined-faults-17'],'PH-10':['network-loss-recovery','combined-faults-43'],
 'PH-11':['final-record-safety','overclaim-immediate'],'PH-12':['scenario-dvp_test','mutant-non_atomic'],
 'PH-13':['final-record-safety','delayed-open-fact-scenarios'],'PH-14':['final-record-progress','late-hold-relative-bound'],
 'PH-15':['review-pipeline-witnesses','review-typed-private-availability','review-typed-private-unconditionalAvailability'],'PH-16':['final-report-view-stages','report-evidence-scenario','abort-authoritative-records','audit-audit_safe'],
 'PH-17':['membership-lifecycle-tests','extended-tlc-recovery','network-loss-recovery']}
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
 'private':['final-variant-private_asset','review-pipeline-safe','review-typed-private-availability','review-typed-private-unconditionalAvailability','review-pipeline_note'],
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
 if r['id'] in ['extended-apalache-core-20','extended-apalache-grounded-20','extended-tlc-two']:r['non_success_cause']='Explicit operator interruption during resource/solver diagnosis; see scheduling-events.json. Native non-success classification and original cap remain unchanged.'
 r['variant']=r.get('configuration',{}).get('main') or (cmd[cmd.index('--main')+1] if '--main' in cmd else 'tooling')
 r['observer']='selected public/relayer observer or explicit authenticated API roles with scoped private channels' if any(x in model for x in ['privacy','integrated','audit']) else 'not_applicable'
 r['time_regime']='T-Bounded' if any(x in model for x in ['timing','stabilization','late_resolution','integrated']) else 'T-Eventual' if '--temporal' in cmd else 'T-Async'
 r['fault_model']=r.get('configuration',{}).get('scope') or r['id']
 r['assumption_version']='verification/assumption-guarantee-matrix.json; exact model-input closure retained'
 if r['id'].startswith('extended-tlc-two'):r['fault_model']='Full proof-job graph, N=2; all actors up, no injected/lost messages; contention and all phases0-6.'
 if r['id'].startswith('extended-tlc-recovery'):r['fault_model']='Full proof-job graph, N=1; B/prover crash/recover, B freeze/unfreeze; eventual stable all-up/unfrozen environment and per-action fairness.'
 r['fairness']='exact --temporal formula in recorded input closure; per-trade/per-action WF and stated recovery' if '--temporal' in cmd else 'none needed for safety; deterministic/sampled schedule as commanded'
 r['bounds']='Exact instantiated constants in recorded model closure; core N=1/2, security=2, cash=3, D=2, epochs 0/1; specialized bounds in configuration/docs.'
 if '--backend' in cmd and cmd[cmd.index('--backend')+1]=='rust':r['tool_versions']['evaluator']='v0.7.1'
 else:r['tool_versions']['evaluator']='typescript under Quint 0.33.1 or not_applicable'
 r['mapping_version']='mapping.qnt economic safety projection' if 'mapping' in model else 'none; relationships informal unless explicitly checked'
 if model.endswith('/privacy.qnt') or (model.endswith('/integrated.qnt') and not r['id'].startswith('review-')):
  r['claim_boundary']='Historical monitor result; independent review IR-001 found this insufficient for mandatory protected-data/payload semantics. Current privacy_pipeline and review-privacy-time results replace that claim.'
 if model.endswith('/privacy_pipeline.qnt'):
  snap=O/'runs'/r['id']/'inputs'/model
  if snap.is_file() and 'type Disclosure={' in snap.read_text():r['claim_boundary']='IR-001 first repair still exposed nested private provenance and omitted complete response history. These real native results prove only the old weaker projection; final Payload/Issue and full-response checks replace the claim.'
 r['tool_identity_boundary']='Observed invocation and snapshotted tooling' if r.get('execution_plan_sha256') else 'Historical helper metadata; native backend banners and original toolchain records remain available. Not retroactively relabeled as a new runtime measurement.'
 r['native_trace_note']='backend-native counterexample retained in raw output; a per-execution export path is preserved when available' if 'counterexample' in r['outcome'] else 'not_applicable'
# A single final content inventory. The original per-execution hashes are unchanged.
models={str(p.relative_to(R)):sha(p) for p in sorted((V/'models').glob('*.qnt'))}
counts=collections.Counter(r['outcome'] for r in receipts)
# Historical attempts are immutable; a resolution is a separate actual observation.
resolutions={
 'apalache-core-12':('extended-apalache-core-12','same full reference, larger budget, invariant-after batching'),
 'apalache-core-20':('extended-tlc-full-reference','exhaustive identical full State/init/step safety covers every depth; original SMT20 remains a non-success'),
 'tlc-live_two':('extended-tlc-two','same full-proof-job two-trade graph, all actors up, phases0-6 and original per-action temporal fairness'),
 'tlc-eventual-recovery':('extended-tlc-recovery','same full-proof-job one-trade B/prover-outage and B-freeze recovery graph; original recoveryProgress hypothesis')}
resolution_rows=[{'original_timeout':old,'resolution_check':new,'resolution_receipt':get(new)['id'] if get(new) else None,'distinct_states':get(new)['distinct_states'] if get(new) else 'unavailable','wall_seconds':get(new)['wall_seconds'] if get(new) else None,'status':'resolved-by-observed-proof' if good(new) else 'NOT DONE','basis':basis} for old,(new,basis) in resolutions.items()]
manifest={'schema_version':2,'generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'implementation_status':'DONE','verification_verdict':'scoped evidence matrix; no unqualified all-configurations or deployed-system verification',
 'required_scoped_checks':primary,'unmet_scoped_checks':[i for i in primary if not good(i)],
 'historical_broader_timeouts':[r['id'] for r in receipts if r['outcome']=='timeout'],
 'original_broader_obligations':resolution_rows,'unclosed_broader_obligations':[x['original_timeout'] for x in resolution_rows if x['status']!='resolved-by-observed-proof'],
 'counterexample_classification':{'A':'isolated protocol mutants','B':'violated environment/trust assumptions','C':'overstrong contracts'},
 'executions':receipts,'outcome_counts':dict(counts),'final_model_hashes':models,
 'external_obligations':['circuits/prover/verifier implementation','actual QBFT/EVM/token execution','key/hardware/storage/network security','cryptographic privacy and real side channels','availability/cost measurement','legal/account/issuer rights and financial records'],
 'source_inventory':'verification/sources/source-inventory.json','scope_warning':'Original PDF/workspace sources were absent; self-contained v2 and recovered shared answer are the authority. Original timed-out/interrupted attempts are not passes; current full-model resolutions are separate observations.'}
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

Original full-reference Apalache12/20 and unrestricted-job two-trade/recovery180-second receipts remain timeouts. The extended profile uses8GiB and larger per-invocation budgets. Direct full Apalache12 passed in182.9seconds. Longer direct20 and exact finite-choice SMT probes were explicitly interrupted at native Z3 query cost and remain non-successes. The identical current full reference was then checked exhaustively by TLC:12,502states, complete graph depth38, S01–S16 and CDecision. This proves all reachable safety prefixes, including20; it is neither an algebraic projection nor a compact-job substitute. The full unrestricted two-trade and recovery temporal checks have separate current native results below. Their hypotheses retain all proof phases0–6 and per-trade/per-action fairness.

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
''')
print(json.dumps({'executions':len(receipts),'outcomes':dict(counts),'unmet_scoped':manifest['unmet_scoped_checks']}))

review={'schema_version':1,'review_mode':'root final source/evidence review; prior independent IR-001 through IR-004 review remains separately attributed','baseline_commit':'e4e06a49732aa2a14358504ff70c21e1521d1950','source_sha256':{p:sha(R/p) for p in ['verification/sources/task-v2.md','verification/sources/shared-solution.original-ru.md']},'broader_obligations':resolution_rows,'unclosed_broader_obligations':manifest['unclosed_broader_obligations'],'properties':[{'id':p['id'],'execution_status':p['execution_status'],'executed_checks':p['executed_checks'],'verified_scope':p['verified_scope']} for p in props],'new_scenarios':{'phase_failure_test':19,'report_view_test':6},'production_or_unqualified_verification':False,'external_obligations':manifest['external_obligations'],'scheduling_deviation':'Initial concurrent heavy start; recorded pause/resume and SMT interruption; subsequent heavy checks sequential. Pauses count against original wall limits.'}
dump(P/'final-review.json',review)
table='\n\n| Original timeout | New observation | Resolution | Proof basis |\n|---|---|---|---|\n'+'\n'.join(f"| {x['original_timeout']} | {link(x['resolution_check'])} | {x['status']} | {x['basis']} |" for x in resolution_rows)+'\n'
with (P/'coverage.md').open('a') as f:f.write(table)
review_doc=(P/'final-review.md').read_text().split('<!-- observed-resolution -->')[0]
write(P/'final-review.md',review_doc+'<!-- observed-resolution -->'+table)

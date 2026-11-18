"""Publish the final repair/re-review ledger only after native proof reconciliation.

This is a root source/evidence review. Prior independent and comparative reviews
remain separately attributed and immutable; no new independent sign-off is invented.
"""
import json,hashlib,re,subprocess,csv
from functools import lru_cache
from pathlib import Path
from qa_retention import audit
from audit_evidence import ROOT,load_latest
load_latest=lru_cache(maxsize=None)(load_latest)
V=ROOT/'verification';P=V/'reports';BASE='798676a310314e6e95167723e149938e388fcf9e'
def dump(p,x):p.write_text(json.dumps(x,indent=2)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def preserve_native_falsifier():
 # Native Apalache's export is outside the Quint --out-itf route. Preserve it
 # with an explicit raw-log association, without rewriting the original receipt.
 p,r=load_latest('qa-effect-induction-false-release')
 raw=(ROOT/r['raw_output']).read_text()
 paths=re.findall(r'(/[^,\n ]+/violation1.itf.json)',raw)
 assert paths and r['expectation_met']
 target=P/'qa-native-false-release.itf.json'
 if Path(paths[-1]).is_file():target.write_bytes(Path(paths[-1]).read_bytes())
 else:
  saved=json.loads((P/'qa-native-false-release.json').read_text())
  assert saved['receipt']==r['id'] and saved['raw_sha256']==r['raw_sha256'] and saved['trace_sha256']==sha(target)
 assert target.is_file(),'Native falsifier export must be preserved before cache cleanup'
 dump(P/'qa-native-false-release.json',{'receipt':r['id'],'receipt_sha256':sha(p),'raw_sha256':r['raw_sha256'],'exported_path':paths[-1],'preserved_trace':str(target.relative_to(ROOT)),'trace_sha256':sha(target),'scope':'One arbitrary invariant-state/actual custom-step witness, not a trace claimed reachable from the protocol initial state. Separate real-prefix TS control establishes reachable faulty-handler behavior.'})
FINDINGS={
 'QA-01':{'problem':'Incomplete returned-value/query/proof and note binding.',
  'repair':'Issue captures authenticated Query, source, proof and availability independently of Payload. disclosureBound specifies all 16values, full identity, error/redaction, headers and exact source-note amount/recipient. TrustedAccess/TrustedNI additionally choose recipient and visible body from authenticated Query, so a producer cannot hide a disclosure behind its own role tag.',
  'owners':['models/privacy_pipeline.qnt','models/observer_view.qnt','tests/payload_values_test.qnt'],
  'evidence':['qa-payload-exact-values','qa-pipeline-access','qa-trusted-observer','qa-role-confusion','qa-role-confusion-access']},
 'QA-02':{'problem':'Unadmitted authentic program input did not reach the real consumer; instruction tests did not establish certificate binding.',
  'repair':'proveUnadmitted creates a crypto-valid statement from an actual captured source fact under program0, separately from historical program admission. deliverUnadmitted reaches the actual commit gate; rotation and member exit preserve this distinction.31 consumer cases exercise22descriptor fields, phase/checkpoint/program/root rejection and matching/historical/newly admitted acceptance.',
  'owners':['models/dvp.qnt','models/admission_focus.qnt','tests/proof_consumer_test.qnt'],
  'evidence':['qa-admission-contexts','qa-proof-consumer-contexts','qa-program_admission','qa-admission-b','qa-admission-d_security','qa-admission-d_cash','qa-program-admission-b','qa-program-admission-d_security','qa-program-admission-d_cash']},
 'QA-03':{'problem':'An ABORT report could satisfy the old assertion using premature absence records while holds remained live.',
  'repair':'abortResolved independently inspects actual source holds, prior preparation, exactly one real release for prepared legs, no fictitious refund for absent legs, terminal local knowledge and matching dispositions. S06/S15 require it for booked/reconciled ABORT. The consumer continues to use authenticated records; no live remote-state read was added to its guard.',
  'owners':['models/dvp.qnt','tests/abort_records_test.qnt'],
  'evidence':['qa-abort-semantic-records','qa-premature_absence','qa-full-recovery']},
 'QA-04':{'problem':'Trade-indexed amount counters could not expose a correct-amount payout to a wrong account/asset.',
  'repair':'Actual atomic delivery/release outputs record trade/leg/kind/chain/genesis/asset/account/quantity in core and multilateral machines. Financial rows record the complete authorized descriptor/outcome. Independent assertions compare outputs against terms, not producer helpers. Same-full-State induction checks actual holds/delivery/releases and placement-specific local atomicity, so plausible output rows alone cannot certify a real effect.',
  'owners':['models/economic_effects.qnt','models/dvp.qnt','models/multilateral.qnt','models/effect_consistency.qnt','tests/economic_outputs_test.qnt'],
  'evidence':['qa-economic-native','qa-economic-escrow','qa-economic-b','qa-economic-d','qa-economic-shared','qa-economic-multilateral','qa-economic-booking','qa-false-release','qa-effect-induction-false-release','qa-non-atomic-cash','qa-partial-shared']}}
NOTES={
 'models/recovery.qnt':'The one-trade recovery graph explores B/prover outages and B freeze. Recovery requires eventual stable all-up and unfrozen operation and per-action fairness. Reviewed comment edits are linked to the original saved source.',
 'models/dvp.qnt':'Reviewed all added receipt/booking producers and frames, independent exact-output and ABORT assertions, program0source/transport and strict admission gate. Healthy/full temporal, admission, faults and directed cases revalidated. No actual cryptography/implementation claim.',
 'models/privacy_pipeline.qnt':'Reviewed query/source/proof snapshot separation, complete16-field/value/status/header/note oracle and each20corruptions. Legacy returned-role observer weakness is explicitly supplemented by observer_view, not silently promoted.',
 'models/multilateral.qnt':'Reviewed both independent security domains, shared cash capacity and actual delivery/release receipts. Current safe/progress rerun. No N3 ABORT-bookkeeping or full relational-privacy composition.',
 'models/mapping.qnt':'Reviewed concrete previous-state snapshot and economic simulation. Added explicit economicOutputs re-export; first QNT404 driver attempt retained. Mapping rerun; no liveness/privacy refinement claim.',
 'models/economic_effects.qnt':'Receipt denotes the actual modeled labelled delivery/release; full token-account storage conformance is external. Schema/matches oracle is pure; producer constructors are separate. Native release is capacity release to original owner, not an extra transfer/mint.',
 'models/admission_focus.qnt':'Actual healthy financial lifecycle plus source-derived unadmitted preparation, rotation/exit. Strict assertions unchanged; does not assume the admission property as a transition guard.',
 'models/effect_consistency.qnt':'Eight direct imports of actual State/init/adversarialStep; reviewed initiation/preservation/implication and local A/B/shared atomicity. Finite N1/N2 profiles; no projected-state or arbitrary-population theorem.',
 'models/observer_view.qnt':'Independent authenticated query principal determines recipient and visible body; all 12 public metadata operations retained by PNI. At most one arbitrary API request permits lossless public-response set here. Ideal opaque-name correspondence only.',
 'tests/payload_values_test.qnt':'20 literal scalar/header/status expectations; no call to fieldValue as oracle.',
 'tests/proof_consumer_test.qnt':'31real consumer cases; foreign-context issuer fixtures are explicit boundary substitution. Actual source-derived program0 path separately checked. No native-history coexistence/circuit claim for fixtures.',
 'tests/abort_records_test.qnt':'Eight producer guard/actual-vs-absent/late/stale/idempotence cases; assertions inspect real holds, release counts and financial rows.',
 'tests/economic_outputs_test.qnt':'14literal native/escrow/B/D/shared/N3/bookkeeping outputs. Shared test is N1; N2 alternatives in native/escrow/B/D. Six unchanged selected modules retained after shared-only edit.',
 'tests/test_qa_repairs.py':'15native-evidence/semantic-poststate checks; counterexamples decoded independently; conservation checked despite misrouting. Producer-copy and strong-monitor identity verified.',
 'tests/test_evidence.py':'18integrity/scope cases retained; current full proof lookup and phase/privacy assumptions updated. Historical4timeout resolutions remain distinct from new full-state proofs.',
 'mutants/qa_controls.qnt':'30generated one-fault producer controls; assertions remain canonical. Fault catalog records selected predicate and expectation.',
 'mutants/effect_soundness.qnt':'Deliberate real hold-release omission with plausible output. Weak safe passes; actual soundness and custom-step induction reject it.',
 'mutants/local_commit_soundness.qnt':'B-local COMMIT deliberately skips cash; generic backing passes and independent local atomicity fails.',
 'mutants/shared_commit_soundness.qnt':'Shared COMMIT deliberately applies only cash; generic backing passes and independent colocated atomicity fails.',
 'mutants/observer_soundness.qnt':'Same trusted-query monitor as default, deliberate role-confused producer. Weak access/observer pass; strong access/observer fail. No honest-model attack claimed.',
 'mutants/generated/role_confusion.qnt':'Canonical privacy source copied with only release changed. Query capture, oracle and collector identical; isolated producer/principal-confusion fault.',
 'scripts/evidence.py':'Fixed indented payload error:0 and witnessed native invariant ERROR(12) classification. Native status12 alone remains a tool error; a real invariant diagnostic and exported trace are required. Original misclassified attempts remain preserved.',
 'scripts/repair_checks.py':'Sequential8GiB full graphs/24GiB explicit induction, cap14400s full proofs, variants, privacy, actual induction and expected failures; exact matching greens reused. Explicit mapping wrapper and custom selected-step negative reviewed.',
 'scripts/repair_tests.py':'Positive/negative/operational suites use explicit selected entries and real counterexample expectations; source/input differences invalidate exact reuse.',
 'scripts/generate_qa_controls.py':'Deterministic per-field fault catalog and literal expected-value cases; does not implement the source oracle.',
 'scripts/qa_coverage.py':'Every affected baseline family has explicit current replacement. Full/compact/recovery scopes remain distinct. Five weak-oracle passing controls excluded from safe-baseline count.',
 'scripts/qa_retention.py':'Checks every current closure and baseline family; exact selected-module, unused-symbol, and reviewed recovery comment exceptions admitted. Original hashes unchanged.',
 'scripts/generate_effect_domains.py':'Generated arbitrary full-record initializers use independent nondeterministic choices, including all integer values. domainClosed is a proved invariant, not a Next filter. Explicit0/1/0calls avoid unsupported function-set expansion in the special induction CLI.',
 'mutants/induction_soundness.qnt':'Same faulty release/control Next with arbitrary full invariant-state initializer. Explicit one-step preservation must fail; this rejects ignoring the selected custom step.',
 'scripts/qa_replay.py':'Explicit fresh-process exact-snapshot reproduction of46negative sequences and one positive; native states compared to immutable exports. This is a reproduction-contract check, not a new expensive graph run.',
 'scripts/native_induction.py':'Compiles the actual full-State/Next Quint monitor and invokes native Apalache for initiation0/preservation1/implication0, with complete independent field-choice initialization and universal row-domain bijection lemmas. Finite TradeSpace is a strengthened induction candidate whose closure is proved; no Next restriction. All compiled bytes outside StateSpace domain normalization stay unchanged.',
 'scripts/normalize_record_domains.py':'Accepts only a sequential field/tuple bijection and identical Cartesian factors; converts one StateSpace comprehension to the algebraically equal native record set. Rejects duplicated/missing/reordered tuple indices. No action/guard/assertion rewrite.',
 'scripts/audit_evidence.py':'Sealed native observations require actual native EXITCODE OK and explicit selected invariant/depth; errors/counterexamples remain distinct. All prior receipt/raw/source protections retained.',
 'scripts/replay.py':'Exact saved-source replay now relocates native .py/.tla inputs as well as .qnt/.json; standalone native helper resolves sources from captured plan and uses the current pinned cache.',
 'scripts/generate_admission_placements.py':'Actual source-capture/program0 prefixes for B remote-security and both D remote preparation branches; canonical matching acceptance is a separate positive and M10 alone falsifies strict S10.',
 'tests/admission_placements_test.qnt':'Six actual-source admission/rejection and canonical acceptance cases across B and both D consumer branches. No issuer fixture or missing-provenance rejection.',
 'mutants/admission_placements.qnt':'Three isolated missing-program-gate controls commit actual program0 facts and violate unchanged S10 at the selected remote preparation consumer.',
 'models/effect_trade_domain.qnt':'Pure row constructor/decoder and field membership. Their universal native forward/reverse obligations prove the finite TradeSpace bijection, rather than assuming the field form covers all original rows.',
 'models/trade_domain_lemmas.qnt':'Universal forward and reverse SMT0 obligations over all bounded constructor parameters and all arbitrary typed rows satisfying field constraints; not sampled domain tests or substituted economic proofs.',
 'scripts/generate_effect_model.py':'Generates the full imported-State point and field domain predicates from one34-field list, plus native universal row-bijection obligations. Actual DVP State/Next is unchanged. Both forms have exact record/map/powerset membership equivalence.',
 'generated/effect-domain-correspondence.json':'All34 actual State fields and18 actual Trade fields are mapped to exact field-membership constraints. Row constructor coverage depends on both universal native lemmas; the correspondence changes no protocol guard.',
 'configs/qa-coverage.json':'Every affected baseline family has an explicit current replacement and supplemental physical/domain/control proof. All required scopes and five excluded weak-oracle positives stay explicit.',
 'configs/qa-repair-plan.json':'Original freeze/resource plan retained. Only the five frozen producer/core files must remain identical; later monitor/mapping representation changes have their own current proof receipts.',
 'configs/acceptance.json':'Exact scoped native-result selection; intentionally weak positive discriminators are audited and excluded from safe baseline acceptance.',
 'configs/proof-contracts.json':'Append-only reviewed native observation contracts; original receipt/raw/source/tooling/claim identities remain immutable. This is a local versioned trust anchor, not independent signed attestation.',
 'mutants/qa-controls.json':'Thirty explicit field/header/note, program, ABORT and economic/financial-row producer controls, each with a native target and expected counterexample.',
 'mutants/admission-placements.json':'Three actual B/D consumer programs/phase controls with paired canonical acceptance and unadmitted rejection; no foreign issuer fixture.',
 'mutants/observer-control.json':'Canonical/copied producer hashes and exact monitor-body identity scope; only release changes in the role-confusion copy.',
 'assumption-guarantee-matrix.json':'Assumptions retain owners and scopes; executed perturbation references point to current affected pipeline/financial observations rather than retired monitors.',
 'properties.json':'All51individual scopes and actual executions; six external obligations remain external. A repeated observation is not an additional theorem.',
 'variants.json':'Named placements retain their own actual proofs and boundaries; no inferred liveness equivalence or vendor certification.',
 'coverage-contract.json':'Literal154-item task inventory, lifecycle phases, artifact/reference reviews and actual scoped proofs remain separate classifications.',
 'scripts/qa_report.py':'Evidence-conditioned report and per-property/per-file disposition; root review attribution, no invented independent review.',
 'scripts/finalize_reports.py':'Refuses missing/non-success current proofs; maps all current property/variant owners; historical timeout resolutions and new repair proofs separated.',
 'scripts/verify.py':'Audits sealed sources/native claims; intentionally weak passing discriminators are audited but excluded from safe baseline.',
 'scripts/write_graph.py':'Source-bound33-case DAG with six focused cases and separately selectable remaining audits and explicit certificate-input EXTERNAL_BOUNDARY.',
 'results/manifest.json':'Generated current property/acceptance selection and native source/tool/result inventories. Every selected observation is audited; original non-successes and six external obligations remain visible.',
 'README.md':'Current architecture, conditional guarantees, actual full-graph results and finding closure are qualified by explicit model scopes and external conformance boundaries.',
 'SPECIFICATION.md':'Original requirements remain authoritative. Reviewed complete disclosure/principal binding, actual-source program admission, ABORT resolution and exact economic/source effects against the implemented predicates and controls.',
 'privacy-policy.md':'Authenticated query determines entitlement and who receives the body. Ordered public metadata, one coupled API request, opaque naming/private channels and declassification remain explicit finite assumptions.',
 '../README.md':'Repository entrypoint links current finding/property/file/source validation results; older publication receipts remain historical and are not relabeled as current readback.',
 'openspec/changes/verify-cross-chain-dvp/specs/dvp-verification/spec.md':'Four finding scenarios specify independent provenance/principal, real consumer admission, actual ABORT resolution and exact outputs/local atomicity. Explicit induction requires complete initialization and the identical actual Next; structure/discovery/spec validation is recorded.',
 'openspec/changes/verify-cross-chain-dvp/design.md':'Reviewed repair design choices and explicit trust/proof boundaries against the implemented source and current observations.',
}
def source_files():
 # Include semantic JSON/configuration and the specification in the per-file
 # review, not merely executable .qnt/.py files. Captured duplicates remain in
 # the separately classified complete path inventory.
 explicit=[ROOT/'package.json',ROOT/'package-lock.json',ROOT/'README.md',V/'README.md',V/'SPECIFICATION.md',V/'privacy-policy.md',V/'tests/conformance-vectors.json',V/'generated/effect-domain-correspondence.json',V/'properties.json',V/'variants.json',V/'coverage-contract.json',V/'assumption-guarantee-matrix.json',V/'results/manifest.json',ROOT/'openspec/changes/verify-cross-chain-dvp/specs/dvp-verification/spec.md',ROOT/'openspec/changes/verify-cross-chain-dvp/design.md']
 return sorted(set(list((V/'generated/native-induction').rglob('*.tla'))+list((V/'generated/native-induction').rglob('native-correspondence.json'))+list((V/'models').glob('*.qnt'))+list((V/'tests').glob('*.qnt'))+list((V/'tests').glob('*.py'))+list((V/'scripts').glob('*.py'))+list((V/'mutants').glob('*.qnt'))+list((V/'mutants').glob('*.json'))+list((V/'mutants/generated').glob('*.qnt'))+list((V/'configs').glob('*.json'))+explicit))
def main():
 preserve_native_falsifier()
 retention=audit();dump(P/'qa-source-retention.json',retention)
 qa=json.loads((V/'configs/qa-coverage.json').read_text());manifest=json.loads((V/'results/manifest.json').read_text())
 deferred=qa.get('deferred_current',{})
 assert set(manifest['unmet_scoped_checks']).issubset(deferred)
 findings=[]
 for key,item in FINDINGS.items():
  ids=list(dict.fromkeys(item['evidence']))
  controls=[x['id'] for x in json.loads((V/'mutants/qa-controls.json').read_text()) if x['finding']==key]
  if key=='QA-02':controls += [x['negative'] for x in json.loads((V/'mutants/admission-placements.json').read_text())]
  findings.append(dict(id=key,status='ADDRESSED',**item,controls=controls,exact_receipts=[load_latest(x)[1]['id'] for x in dict.fromkeys(ids+controls)]))
 old=json.loads((V/'reviews/protocol-adequacy-2026-11-18/properties.json').read_text())
 now={x['id']:x for x in json.loads((V/'properties.json').read_text())};properties=[]
 for x in old:
  p=now[x['id']];external=p['classification']=='external obligation'
  properties.append({'id':x['id'],'requirement':p['requirement'],'previous_disposition':x['adequacy'],'previous_findings':x['findings'],'disposition':'external-obligation' if external else 'full-validation-deferred' if any(i in deferred for i in p['executed_checks']) else 'scoped-adequate-after-repair','status':p['execution_status'],'predicate':p['predicate'],'review':p.get('verified_scope',x['review']),'executed_check_families':p['executed_checks'],'exact_receipts':[load_latest(i)[1]['id'] for i in p['executed_checks'] if i not in deferred],'deferred_checks':[i for i in p['executed_checks'] if i in deferred],'proof_boundary':p['verified_scope']})
 assert len(properties)==51
 # Carry forward the previous per-file semantic review only when bytes match.
 previous=(V/'reviews/protocol-adequacy-2026-11-18/source-files.md').read_text()
 rows=[]
 for p in source_files():
  path=str(p.relative_to(ROOT));rel=str(p.relative_to(V)) if p.is_relative_to(V) else path
  original=subprocess.run(['git','show',BASE+':'+path],cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL)
  unchanged=original.returncode==0 and original.stdout==p.read_bytes()
  prior=next((line.rsplit('|',2)[-2].strip() for line in previous.splitlines() if '['+path+']' in line),None)
  note=NOTES.get("../README.md" if path=="README.md" else rel)
  if rel.startswith('generated/native-induction/'):note='Compiler-generated exact-source TLA/correspondence artifact. The native plan links the sealed Quint compiler output, exact normalization identity and actual source/Next; this is checked correspondence, not a fresh manual semantic review of every generated line.'
  if not note and unchanged:note=(prior or 'Existing source behavior and explicitly scoped proof boundary retained; no semantic edit in this round.')
  assert note,('Missing file review disposition',path)
  method='generated correspondence audit; no manual line-by-line claim' if rel.startswith('generated/native-induction/') else 'prior semantic review retained by byte identity' if unchanged else 'root repair/source review and affected evidence audit'
  rows.append({'path':path,'sha256':sha(p),'method':method,'review':note,'current_observations':[x['selected'] for x in retention['current'] if path in load_latest(x['family'])[1]['input_hashes']]})
 dump(P/'qa-properties.json',properties);dump(P/'qa-files.json',rows)
 with (P/'qa-files.csv').open('w',newline='') as f:
  w=csv.writer(f,lineterminator='\n');w.writerow(['path','sha256','method','review'])
  for r in rows:w.writerow([r[k] for k in ['path','sha256','method','review']])
 counts={'selected':len(manifest['required_scoped_checks']),'baseline_positive':0,'expected_negative':0,'weak_discriminators':len(qa['oracle_discriminators'])}
 for name in manifest['required_scoped_checks']:
  if name in deferred:continue
  r=load_latest(name)[1]
  if r['expected']=='counterexample':counts['expected_negative']+=1
  elif name not in qa['oracle_discriminators']:counts['baseline_positive']+=1
 proofs=[]
 for key,name in qa['proofs'].items():
  r=load_latest(name)[1];proofs.append({'purpose':key,'id':r['id'],'outcome':r['outcome'],'states':r['distinct_states'],'wall_seconds':r['wall_seconds'],'command':r['shell_command']})
 induction=[{'profile':name,'checks':ids,'receipts':[load_latest(i)[1]['id'] for i in ids if i not in deferred],'deferred_checks':[i for i in ids if i in deferred],'wall_seconds':sum(load_latest(i)[1]['wall_seconds'] for i in ids if i not in deferred),'status':'deferred' if any(i in deferred for i in ids) else 'passed'} for name,ids in qa['effect_induction_obligations'].items()]
 report={'effect_induction':induction,'baseline_commit':BASE,'review_mode':'root final repair/source/evidence re-review; no new independent-agent sign-off','status':'DONE','scope':'Finding repairs and focused validation requested by the user' if deferred else 'Finding repairs and full selected model validation','full_validation_status':'NOT DONE' if deferred else 'DONE within model scopes','deferred_checks':deferred,'open_findings':[],'findings':findings,'property_count':len(properties),'file_count':len(rows),'counts':counts,'proofs':proofs,'source_retention':'qa-source-retention.json','property_ledger':'qa-properties.json','file_ledger':'qa-files.json','historical_review':'../reviews/protocol-adequacy-2026-11-18/README.md','external_obligations':manifest['external_obligations']}
 counts['deferred']=len(deferred)
 report['focused_replay']=json.loads((P/'qa-replay-validation.json').read_text())['count']
 dump(P/'qa-repairs.json',report)
 lines=['# Findings resolved and protocol re-review','','All four comparative-review findings are addressed in the modeled protocol and its focused tests. The user requested minimum testing now and deferred the full suite. The deferred checks are listed below. The51-property and current-source ledgers have been reviewed again against the preserved task-v2 and shared solution. This is root repair/source/evidence review; the prior independent review remains separately attributed. No new independent-agent sign-off is claimed.','','| Finding | Repair and observed falsification |','|---|---|']
 for x in findings:lines.append(f"| {x['id']} — **{x['status']}** | {x['repair']} Control checks include {', '.join(x['controls'])}. |")
 lines+=['','## Actual current proofs','','These observations use the enriched current financial/payload state. Previous full-model greens were invalidated by semantic changes and replaced; original timeout/interruption/failure receipts remain unchanged. Direct SMT20 remains a non-success. Exhaustive current full-reference safety covers every reachable depth, including20.','','| Purpose | Actual receipt | Native result | Distinct states | Seconds |','|---|---|---|---|---|']
 for x in proofs:lines.append(f"| {x['purpose']} | [{x['id']}](../results/runs/{x['id']}/receipt.json) | {x['outcome']} | {x['states']} | {x['wall_seconds']:.2f} |")
 lines+=['','## Actual-State effect induction','','The universal row constructor/decoder lemmas justify equivalent point-set and field predicates. Seven profiles completed actual-init0, complete arbitrary invariant-state/actual-adversarialStep1, and implication0 over the full imported State. Authenticated OPEN has completed initiation. Its preservation and implication are deferred by the user. Separate exact compiler artifacts identify the actual and arbitrary initializers. The arbitrary initializer independently chooses every State/Trade scalar or set from its declared domain and guards only the row/physical induction predicate; it does not enumerate a subset of reachable histories. These are genuine inductive obligations. The lemmas do not replace any full financial, temporal or privacy graph.','','| Profile | Initiation / preservation / implication receipts | Seconds | Status |','|---|---|---|---|']
 for x in induction:lines.append(f"| {x['profile']} | {', '.join('['+i+'](../results/runs/'+i+'/receipt.json)' for i in x['receipts'])} | {x['wall_seconds']:.2f} | {x['status']} |")
 lines+=['',f"Selected evidence: **{counts['baseline_positive']} positive baseline observations, {counts['expected_negative']} expected negatives, {counts['weak_discriminators']} intentionally weak passing discriminators**. The five discriminators are audited but excluded from safe-baseline acceptance. The {retention['family_count']} original property/acceptance families are classified with {retention['revalidated_families']} current replacements, {retention['retained_families']} retained scopes and {retention['deferred_families']} current revalidations deferred by the user. {retention['current_subjects']} current native subjects are source-identity audited.",'','## Resulting architecture and guarantees','','A and B retain native asset ownership and exclusive local reservations. The reference A-hosted COMMIT verifies the B preparation and atomically delivers security; authenticated historical outcome then permits B cash delivery. ABORT remains durable while releases retry. Local absence becomes terminal only after local ABORT knowledge. Full source records, actual resolution semantics and complete institution-private financial terms govern reconciliation. B-hosted, D-hosted, escrow, private, shared execution and three-domain placements keep their own source/return-path rules.','','Actual outputs now expose the exact chain/genesis/asset/account/quantity. Separate source-state induction prevents a plausible output row from standing in for an unreleased hold or omitted colocated transfer. Seven completed actual-State/adversarialStep profiles prove the monitor. The authenticated-OPEN induction remains pending. Elsewhere, the custom false-release step is rejected through the same explicit one-step proof route. Loss/prune/resend only frame the monitored trade fields. This is an actual-state effect theorem, not whole-protocol induction.','','Privacy returns independently bound source/proof/note values. The authenticated query principal determines entitlement and who saw the body. The old response-tag-based observer alone is insufficient: explicit role-confusion controls make its access and observer predicates pass while the independent trusted-query monitor fails. The current claim includes both full public metadata history and that complete-body view.','','## Tests and tradeoffs','','20 literal payload/status cases;31 consumer-context cases plus six actual-source B/D admission-placement cases;8 ABORT semantic cases;14 economic-placement/bookkeeping cases;30 new isolated corruption controls plus the retained 8protocol mutants. Consumer foreign-context certificate fixtures assume issuer validity at the input boundary; they do not establish that all foreign contexts coexist in the initialized native history or prove actual cryptography. The program0proof path is separately produced from real captured source state. Six additional B/D tests and three missing-gate controls cover each remote preparation-consumer branch.','','The full-job N2 graph retains all proof phases0–6 and original per-action fairness. Recovery is its named N1 B/prover-outage and B-freeze configuration with eventual stable recovery. Combined-loss/restart/admission traffic checks are samples, not an exhaustive Cartesian fault product. The finite quantities remain2security/3cash. No parameterized/n-leg, joint financial/membership liveness or whole fault/privacy/time composition theorem is claimed.','','The paired privacy model uses source positions4/7,12fixed public operations, at most one arbitrary coupled API request, ideal opaque names and private/declassified channels. It does not prove arbitrary-scheduler, termination, computational or real-side-channel noninterference. Immediate joint local usability and progress under permanent required-party halt still fail as designed. Timed slot bounds remain assumed workloads, not measured latency/SLA. N3 progress includes COMMIT reporting; composed N3 ABORT bookkeeping remains outside its stated theorem.','','Circuits/prover/verifier implementations, real QBFT/EVM/token semantics, custody/storage/network security, performance/cost and legal/account/issuer rights remain external obligations. Missing original PDF/design registers stay explicitly missing; no contents were invented.','','## Re-review and preserved non-successes','','The re-review found and addressed additional adequacy details: exact note amount, complete financial-row terms, actual release-vs-receipt consistency, B/shared local atomicity, authenticated-principal observer/access selection and the native error:0 parser. Mapping needed an explicit assertion re-export; its original QNT404 attempt is preserved. Native Apalache labels an actual invariant violation ERROR(12); the parser requires the invariant diagnostic and exported ITF marker, while status12 alone remains a tool failure. The first misclassified receipt stays unchanged. The [preserved native false-release witness](qa-native-false-release.itf.json) and [raw-output association](qa-native-false-release.json) independently expose the still-active hold and incremented refund. Arbitrary-initializer attempts at8/24GiB were explicitly interrupted for resource/encoding diagnosis; their successes and non-successes remain source-specific. The native record-domain representation repair uses24GiB only for this cohort. The special induction CLI additionally reported a missing whole-record TypeOK and unsupported function-set expansion; those tool errors remain non-successes. The final theorem uses separate actual-init0, invariant-state/actual-step1 and implication0 native observations. A finite TradeSpace strengthens TypeOK with physical/history/cache relations; initiation and preservation must prove these relations, so no actual behavior is removed. Preservation checks every invariant VC at successor1; its State0query is tautological because Init is the same invariant. Actual-init0 and implication0 are separate mandatory observations, and the faulty custom Next must fail at1 through the same route. This removes no state or Next transition. Two universal constructor/decoder lemmas establish that the field-form predicate and point-set initializer cover exactly the same typed rows. Record/function/powerset membership is expanded field by field from one complete34-field domain list. The native correspondence normalizes only StateSpace into the equal native record-set constructor; all actual State/init/Next/monitor definitions remain otherwise byte-identical to compiled Quint. This is the standard induction obligation decomposition, not ordinary bounded safety substituted for induction. The initial pre-freeze full-two interruption and driver syntax error remain visible. No non-success was converted into a pass.','','[Quint induction obligations and TypeOK documentation](https://quint.sh/docs/checking-properties) underpin the explicit0/1/0decomposition. [51-property ledger](qa-properties.md), [per-file ledger](qa-files.md), [source-retention audit](qa-source-retention.json), [exact selection](../configs/qa-coverage.json), [full commands/raw receipts](executions.md).']
 lines += ['', "The app update removed an escrow run's supervisor and interrupted receipt collection. Its plan, input closure and raw output are preserved, with the OS exit status recorded as unavailable. The replacement obligation has a separate accepted receipt. [Interruption record](qa-runner-interruption.json)."]
 lines += ['', '## Deferred full validation', '', 'Full validation is **NOT DONE** under the user-directed minimum-testing scope. Completed observations are retained. The following checks and the remaining full47-replay batch are deferred.', '']
 lines += ['- `'+name+'` — '+reason for name,reason in deferred.items()]
 (P/'qa-repairs.md').write_text('\n'.join(lines)+'\n')
 property_rows=[]
 for prop in properties:
  evidence=list(prop['exact_receipts'])
  if prop['deferred_checks']:
   evidence.append('Deferred: '+', '.join(prop['deferred_checks']))
  observations=', '.join(evidence) or 'external obligation'
  property_rows.append(f"| {prop['id']} | {prop['disposition']} | {prop['review']} | {observations} |")
 (P/'qa-properties.md').write_text('# Property-by-property re-review\n\nAll 51 registered properties retain their exact external/finite/sampled boundaries. The table lists reviewed evidence and names the deferred checks.\n\n| ID | Disposition | Re-review / proof boundary | Current evidence |\n|---|---|---|---|\n'+'\n'.join(property_rows)+'\n')
 (P/'qa-files.md').write_text('# File-by-file re-review\n\nCurrent models, scenario/evidence tests, fault controls, Python scripts, semantic JSON/configuration, specifications and entrypoint documents are listed individually. Unchanged sources retain the prior manual semantic review only by exact byte identity. Captured duplicate/history files remain evidence, not a claim of new manual review of every archived copy.\n\n| File | Method | Re-review / boundary |\n|---|---|---|\n'+'\n'.join(f"| [{x['path']}](../../{x['path']}) | {x['method']} | {x['review']} |" for x in rows)+'\n')
 # Complete path classification includes captured copies and archived failures.
 # Fresh semantic review is confined to the live source ledger above. QA report
 # metadata is listed without a self-referential hash; proof snapshots are hashed.
 paths=set(subprocess.check_output(['git','ls-files','--cached','--others','--exclude-standard','-z'],cwd=ROOT).decode().split('\0'))-{''}
 paths.add('verification/reports/qa-paths.csv');reviewed={x['path'] for x in rows}
 with (P/'qa-paths.csv').open('w',newline='') as f:
  w=csv.writer(f,lineterminator='\n');w.writerow(['path','sha256','review_classification'])
  for path in sorted(paths):
   file=ROOT/path
   if not file.is_file() and path!='verification/reports/qa-paths.csv':continue
   metadata=path.startswith('verification/reports/qa-')
   role='live source: see qa-files.json' if path in reviewed else 'native observation/snapshot/replay: immutable source and result audit' if path.startswith('verification/results/') else 'historical comparative/upstream archive: retained lineage and original scope' if path.startswith('verification/reviews/') else 'project requirement/workflow/document/metadata: retained or updated within task scope'
   w.writerow([path,'metadata; no self hash' if metadata else sha(file),role])
 print(json.dumps({k:report[k] for k in ['status','open_findings','property_count','file_count','counts']}))
if __name__=='__main__':main()

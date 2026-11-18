"""Explicit old-to-current proof selection, with no timeout or weak-model fallback.

This is a selection plan, not an execution verdict. Finalization audits every
selected observation and refuses missing/non-successful current subjects.
"""
from pathlib import Path
import json,subprocess,hashlib
ROOT=Path(__file__).resolve().parents[2]
BASE='798676a310314e6e95167723e149938e388fcf9e'
def baseline(path):return json.loads(subprocess.check_output(['git','show',BASE+':'+path],cwd=ROOT))
def build():
 mapping={
 'final-record-safety':'qa-core-finite','extended-tlc-full-reference':'qa-core-finite',
 'final-record-progress':'qa-full-one','final-record-two':'qa-compact-two','final-record-recovery':'qa-compact-recovery','final-record-mapping':'qa-economic-mapping',
 'extended-tlc-two':'qa-full-two','extended-tlc-recovery':'qa-full-recovery','extended-apalache-core-12':'qa-apalache12',
 'three-domain-installation-final':'qa-multilateral','three-domain-progress':'qa-multilateral','three-independent-domains-witnesses':'qa-scenarios-multilateral_test',
 'overclaim-immediate':'qa-immediate','overclaim-permanent-halt':'qa-permanent-halt',
 'abort-authoritative-records':'qa-scenarios-policy_test','report-evidence-scenario':'qa-scenarios-dvp_test',
 'delayed-open-fact-scenarios':'qa-scenarios-open_test','network-loss-recovery':'qa-scenarios-network_test',
 'combined-faults-17':'qa-combined-faults-17','combined-faults-43':'qa-combined-faults-43','final-combined-faults-43':'qa-combined-faults-43',
 'preparation-freeze-policy':'qa-scenarios-policy_test','d-outage-return-paths':'qa-scenarios-d_outage_test',
 'review-type-privacy_pipeline':'qa-pipeline-access','review-type-integrated':'qa-privacy-time-integrated-safe',
 'review-type-privacy_pipeline_test':'qa-scenarios-privacy_pipeline_test','review-type-private-progress':'qa-pipeline-access',
 'review-pipeline-safe':'qa-pipeline-access','review-pipeline-PAccess':'qa-pipeline-access','review-pipeline-PBinding':'qa-pipeline-access','review-pipeline-PNI':'qa-pipeline-access',
 'review-pipeline-witnesses':'qa-scenarios-privacy_pipeline_test',
 'review-typed-private-availability':'qa-private-availability','review-typed-private-unconditionalAvailability':'qa-private-unconditionalAvailability',
 'final-phase-type':'qa-scenarios-phase_failure_test','final-phase-failure-witnesses':'qa-scenarios-phase_failure_test',
 'final-report-view-stages':'qa-scenarios-report_view_test','final-resource-profile-native-type':'qa-scenarios-report_view_test'}
 for name in ['live_open','live_b','live_d','live_escrow','private_asset','shared_execution']:mapping['final-variant-'+name]='qa-variant-'+name
 for name in ['expiry','binding','replay','reopen','non_atomic','relayer_assertion','stale_refund','pruned_tombstone']:mapping['mutant-'+name]='qa-legacy-'+name
 for name in ['pipeline_log','pipeline_timing','pipeline_unsalted','pipeline_scope','pipeline_substitution','pipeline_note','pipeline_compromise']:mapping['review-'+name]='qa-'+name
 for name in ['integrated-safe','integrated-noUsability','integrated_leak-safe']:mapping['review-privacy-time-'+name]='qa-privacy-time-'+name
 for main in ['bindings_test','policy_test','contention_test','shared_policy_test','dvp_test','recovery_test','open_test','privacy_test','multilateral_test','b_path_test','d_path_test']:
  # Unchanged legacy privacy and mechanisms retain their old scope. The others
  # are actual current module selections, not a renamed instruction test.
  if main!='privacy_test':mapping['scenario-'+main]='qa-scenarios-'+main
 for m in ['shared_path_test','escrow_path_test']:mapping['witness-'+m]='qa-scenarios-'+m
 mapping['actual-b-clock-expiry']='qa-legacy-expiry'
 for name,target in [('b_hosted','live_b'),('d_shared','live_d'),('shared_execution','shared_execution')]:mapping['contract-'+name]='qa-variant-'+target
 compiled={
  'dvp':'qa-core-finite','compact_two':'qa-compact-two','compact_recovery':'qa-compact-recovery',
  'liveness':'qa-full-one','liveness_variants':'qa-full-two','recovery':'qa-full-recovery',
  'mapping':'qa-economic-mapping','multilateral':'qa-multilateral','operational_faults':'qa-combined-faults-17',
  'failure_controls':'qa-permanent-halt','guided':'qa-legacy-expiry','protocol':'qa-type-current-protocol',
  'variants':'qa-variant-shared_execution','integrated':'qa-privacy-time-integrated-safe'}
 for file in ['bindings_test','d_outage_test','dvp_test','network_test','recovery_test','variants_test']:
  compiled[file]='qa-scenarios-'+('policy_test' if file=='variants_test' else file)
 for file,target in compiled.items():mapping['type-final-'+file]=target
 required=list(dict.fromkeys(mapping.values()))
 required+=['qa-admission-contexts','qa-payload-exact-values','qa-proof-consumer-contexts','qa-abort-semantic-records']
 required+=['qa-economic-'+m for m in ['native','escrow','b','d','shared','multilateral','booking']]
 required += [r['id'] for r in json.loads((ROOT/'verification/mutants/qa-controls.json').read_text())]
 required += ['qa-false-release-weak-safe','qa-false-release','qa-effect-induction-false-release']
 required += ['qa-non-atomic-cash-weak-safe','qa-non-atomic-cash','qa-partial-shared-weak-safe','qa-partial-shared']
 required += ['qa-trusted-observer','qa-role-confusion-weak-observer','qa-role-confusion','qa-role-confusion-weak-access','qa-role-confusion-access']
 required += ['qa-effect-'+phase+'-'+m for m in ['one','two','b','d','escrow','shared','private','open'] for phase in ['init','preserve','imply']]
 required += ['qa-record-compile-'+m for m in ['one','two','b','d','escrow','shared','private','open','false-release']]
 required += ['qa-record-compile-'+m+'-inductive' for m in ['one','two','b','d','escrow','shared','private','open']]
 required += ['qa-combined-faults-29','qa-effect-false-imply','qa-trade-domain-forward','qa-trade-domain-reverse']
 required += [x[k] for x in json.loads((ROOT/'verification/mutants/admission-placements.json').read_text()) for k in ['positive','negative']]
 prop={}
 for pid in ['S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S13','S14','S15','S16','C-Decision']:
  prop[pid]=['qa-core-finite','qa-full-two','qa-full-recovery']
 prop['S05']+=['qa-economic-'+m for m in ['native','escrow','b','d','shared','multilateral','booking']]+['qa-'+m for m in ['security_recipient','cash_recipient','security_asset','cash_asset','security_refund_recipient','cash_refund_recipient','booking_recipient','booking_quantity']]+['qa-effect-'+phase+'-'+m for m in ['one','two','b','d','escrow','shared','private','open'] for phase in ['init','preserve','imply']]+['qa-false-release','qa-effect-induction-false-release']
 for pid in ['S06','S15','L04','C-Records']:prop.setdefault(pid,[]).extend(['qa-abort-semantic-records','qa-premature_absence'])
 for pid in ['S10','S13']:prop[pid].extend(['qa-admission-contexts','qa-proof-consumer-contexts','qa-program_admission'])
 prop['S10'] += [x[k] for x in json.loads((ROOT/'verification/mutants/admission-placements.json').read_text()) for k in ['positive','negative']]
 for pid in ['P-Binding','V-Private']:prop[pid]=['qa-pipeline-access','qa-payload-exact-values']+[r['id'] for r in json.loads((ROOT/'verification/mutants/qa-controls.json').read_text()) if r['finding']=='QA-01']
 for pid in ['P-Access','P-NI']:prop[pid]=['qa-trusted-observer','qa-role-confusion','qa-role-confusion-access']
 prop['C-Records']+=['qa-economic-booking','qa-booking_recipient','qa-booking_quantity']
 prop['V-B']=['qa-effect-'+phase+'-b' for phase in ['init','preserve','imply']]+['qa-non-atomic-cash']
 prop['V-Shared']=['qa-effect-'+phase+'-shared' for phase in ['init','preserve','imply']]+['qa-partial-shared']
 for pid in ['S05','V-B','V-Shared']:prop[pid] += ['qa-trade-domain-forward','qa-trade-domain-reverse']
 prop['S05'] += ['qa-effect-false-imply']
 coverage={'baseline_commit':BASE,'replacements':mapping,'required_current':list(dict.fromkeys(required)),'property_supplements':prop,
 'proofs':{'reference':'qa-core-finite','one':'qa-full-one','two':'qa-full-two','recovery':'qa-full-recovery','bounded12':'qa-apalache12','program_admission':'qa-admission-contexts','receipt_consistency_preservation':'qa-effect-preserve-one','trusted_observer':'qa-trusted-observer'},
 'effect_induction_obligations':{m:['qa-effect-'+phase+'-'+m for phase in ['init','preserve','imply']] for m in ['one','two','b','d','escrow','shared','private','open']},
 'oracle_discriminators':['qa-false-release-weak-safe','qa-non-atomic-cash-weak-safe','qa-partial-shared-weak-safe','qa-role-confusion-weak-observer','qa-role-confusion-weak-access'],
 'unchanged_active_module_retention':{'htlc-permanent-halt':'The selected htlc_permanent_halt module and its mechanisms dependency are unchanged relative to the reviewed baseline. The other module imports financial dvp; it is not selected by this invocation. Prior historical MODE0 qualification remains unchanged.'},
 'replacement_rules':[
  'Current full reference safe/CDecision is the actual enriched State/init/step, all phases0..6. It discharges the old same-profile safety subjects, not a projected or compact substitute.',
  'Full-job, compact-job and recovery temporal profiles each have their own current native observations; no liveness equivalence is inferred.',
  'Current accessStep safe checks all conjunctions on the full graph including pairedStep as an explicit subrelation; separate positive runs of the same graph per conjunct are unnecessary.',
  'Current multilateral safe/progress checks the same initialized graph and both original claims in one invocation.',
  'A native execution compiles its exact captured source closure. Old type-only claims can inherit that actual parse/type/effect check, not a new protocol theorem.',
  'Standalone timing/trust/capacity/authentication/membership/mechanism and historical-monitor scopes remain qualified as before. They are not substituted for current financial/privacy claims.',
  'Actual effect/hold soundness is genuine induction over the identical full State/init/adversarialStep in eight finite profiles. Recovery/compact/focus steps use only its explicitly included primitive relations; no state projection or liveness composition.',
  'Six unchanged economic test entry modules retain their observations after only economic_shared_test changed; selected module text and imported model closures must match.']}
 return coverage
if __name__=='__main__':
 import sys
 x=build()
 if '--focused' in sys.argv:
  x['validation_mode']='focused-by-explicit-user-instruction'
  x['deferred_current']={name:'User requested minimum focused testing now and full testing later on2026-11-18.' for name in ['qa-effect-preserve-open','qa-effect-imply-open','qa-immediate','qa-permanent-halt','qa-combined-faults-17','qa-combined-faults-29','qa-combined-faults-43']}
  x['required_focused']=[name for name in x['required_current'] if name not in x['deferred_current']]
  x['full_validation_status']='NOT DONE'
 (ROOT/'verification/configs/qa-coverage.json').write_text(json.dumps(x,indent=2)+'\n');print('Authored explicit selection for',len(x['required_current']),'planned current subjects;',len(x.get('required_focused',x['required_current'])),'active subjects')

"""Audit semantic source retention without rewriting original observation hashes.

Exceptions retain the selected module, an unused monitor addition, or a reviewed
comment edit. They never accept changed executable producer behavior.
"""
import json,hashlib,re,subprocess
from functools import lru_cache
from pathlib import Path
from audit_evidence import ROOT,load_latest,validate

RECOVERY_SOURCE='verification/models/recovery.qnt'

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def executable_lines(text):
 return [line for line in text.splitlines(keepends=True) if not line.lstrip().startswith('//')]

def module(text,name):
 start=text.index('module '+name+' {');end=text.find('\nmodule ',start+1)
 return text[start:end if end!=-1 else len(text)]
def unused_access(text):
 return re.sub(r'\n\n pure def trustedAccess\(i:Issue\):bool = i.response.error!=0 or\n  entitled\(i.query.role,i.response.field,i.query.scope\)\n val TrustedAccess=PAccess and p.issuesL.forall\(i=>trustedAccess\(i\)\) and p.issuesR.forall\(i=>trustedAccess\(i\)\)\n','\n',text)
def relation(p,r,baseline=False):
 changes=[]
 for rel,h in r['input_hashes'].items():
  actual=ROOT/rel
  if actual.is_file() and sha(actual)==h:continue
  saved=p.parent/'inputs'/rel
  before=saved.read_text();after=actual.read_text() if actual.is_file() else ''
  main=r['command'][r['command'].index('--main')+1] if '--main' in r['command'] else ''
  if rel==RECOVERY_SOURCE and executable_lines(before)==executable_lines(after):
   rule='Reviewed recovery comment edit. All lines outside full-line comments match the saved source.'
  elif rel=='verification/tests/economic_outputs_test.qnt' and main!='economic_shared_test':
   assert module(before,main)==module(after,main),(r['id'],rel)
   rule='Selected economic entry module byte-identical; only unselected shared module changed'
  elif rel=='verification/mutants/observer_soundness.qnt' and r['id'] in ['qa-role-confusion','qa-role-confusion-weak-observer']:
   assert unused_access(after)==before,(r['id'],rel)
   assert r['claim'] in ['PNI','TrustedNI']
   rule='Only unused TrustedAccess definition added; selected PNI/TrustedNI, step, producer identical'
  elif rel=='verification/scripts/native_induction.py' and len(r['command'])>2 and r['command'][2]=='invoke':
   head=lambda s:s[:s.index('PROFILE=')]
   body=lambda s:s[s.index('def invoke('):s.index('def run_profiles(')]
   current=after
   if body(before)!=body(after) and r['command'][-1]!='preserve':
    current=current.replace(" # Preservation is I /\\ Next => I'. At state0, Init is already I itself.\n # Skip only that tautological query; check every VC at successor1. No state\n # or transition is excluded. Initiation0/implication0 remain separate gates.\n if phase=='preserve':cmd.insert(-1,'--tuning-options=search.invariantFilter=1->.*:search.invariant.mode=after')\n",'')
   assert head(before)==head(after) and body(before)==body(current),(r['id'],rel)
   rule='Only unused compilation/driver code changed; standalone invoke imports/cache/source-root logic and actual native command unchanged. Compiled source/plan/TLA identities audited separately.'
  elif baseline and subprocess.run(['git','show','798676a310314e6e95167723e149938e388fcf9e:'+rel],cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL).stdout==actual.read_bytes():
   rule='Prior reviewed selection/scope inherited: current bytes equal baseline798676a. The original snapshot remains older; this does not promote its historical/projected/MODE-specific predicate to a new current-model theorem. See comparative properties/file review and retained-privacy-scopes, model-repairs, extended-source-retention and comment-only-deltas reports.'
  elif baseline and r['id'].startswith('htlc-permanent-halt'):
   # Selected module has no dvp import; its sibling imports the changed owner.
   if rel.endswith('failure_controls.qnt'):
    assert module(before,'htlc_permanent_halt')==module(after,'htlc_permanent_halt')
   else:assert rel.endswith(('dvp.qnt','economic_effects.qnt')),(r['id'],rel)
   rule='Unselected financial sibling import; selected HTLC module and mechanisms dependency unchanged'
  else:raise AssertionError(('Unjustified changed semantic input',r['id'],rel))
  changes.append({'path':rel,'original_sha256':h,'current_sha256':sha(actual),'basis':rule})
 return changes
def audit():
 observed=lru_cache(maxsize=None)(load_latest)
 qa=json.loads((ROOT/'verification/configs/qa-coverage.json').read_text())
 base=qa['baseline_commit']
 def old(path):return json.loads(subprocess.check_output(['git','show',base+':'+path],cwd=ROOT))
 families=set(old('verification/configs/acceptance.json')['required'])
 for prop in old('verification/properties.json'):families.update(prop['executed_checks'])
 rows=[]
 for name in sorted(families):
  selected=qa['replacements'].get(name,name)
  if selected in qa.get('deferred_current',{}):
   p,r=observed(name);validate(r,p)
   rows.append({'family':name,'selected':selected,'disposition':'current-revalidation-deferred-by-user','historical_receipt':r['id'],'source_exceptions':[],'boundary':'Historical observation retained with its saved inputs. Current replacement is deferred.'})
   continue
  p,r=observed(selected);validate(r,p)
  rows.append({'family':name,'selected':r['id'],'disposition':'revalidated' if selected!=name else 'retained','source_exceptions':relation(p,r,baseline=selected==name)})
 current=[]
 for name in qa.get('required_focused',qa['required_current']):
  p,r=observed(name);validate(r,p)
  current.append({'family':name,'selected':r['id'],'source_exceptions':relation(p,r)})
 plan=json.loads((ROOT/'verification/configs/qa-repair-plan.json').read_text())
 frozen=['dvp','privacy_pipeline','multilateral','economic_effects','admission_focus']
 for name in frozen:
  rel='verification/models/'+name+'.qnt';assert sha(ROOT/rel)==plan['model_sha256'][rel],rel
 reviewed={
  'verification/models/mapping.qnt':'Explicit S05/economicOutputs wrapper re-export; current simulation/economic-output graph rerun. No concrete protocol transition changed.',
  'verification/models/effect_consistency.qnt':'Proof-only complete State/Trade initializer, equivalent point/field domains and physical/local-atomicity induction candidate. Per-profile receipts and universal row lemmas document the checked obligations. The imported protocol State/Next is unchanged.'}
 recovery_receipt,_=observed('qa-full-recovery')
 saved_recovery=recovery_receipt.parent/'inputs'/RECOVERY_SOURCE
 if sha(saved_recovery)==plan['model_sha256'][RECOVERY_SOURCE] and executable_lines(saved_recovery.read_text())==executable_lines((ROOT/RECOVERY_SOURCE).read_text()):
  reviewed[RECOVERY_SOURCE]='Comment-only edit. All executable lines match the frozen source captured in the completed recovery receipt.'
 deltas=[]
 for rel,h in plan['model_sha256'].items():
  now=sha(ROOT/rel)
  if now==h:continue
  assert rel in reviewed,('Unreviewed post-freeze model change',rel)
  affected=[x['selected'] for x in current if rel in observed(x['family'])[1]['input_hashes']]
  assert affected,('No current observation for post-freeze change',rel)
  deltas.append({'path':rel,'freeze_sha256':h,'current_sha256':now,'review':reviewed[rel],'audited_current_observations':affected})
 return {'baseline_commit':base,'status':'passed','family_count':len(rows),'revalidated_families':sum(x['disposition']=='revalidated' for x in rows),'retained_families':sum(x['disposition']=='retained' for x in rows),'deferred_families':sum(x['disposition']=='current-revalidation-deferred-by-user' for x in rows),'deferred_current':qa.get('deferred_current',{}),'current_subjects':len(current),'families':rows,'current':current,'frozen_core_match':True,'frozen_core_files':['verification/models/'+x+'.qnt' for x in frozen],'reviewed_post_freeze_deltas':deltas,'trust_boundary':'Source identity and recorded native-result audit; not an external execution attestation or a new formal refinement theorem.'}
if __name__=='__main__':
 x=audit();(ROOT/'verification/reports/qa-source-retention.json').write_text(json.dumps(x,indent=2)+'\n')
 print(json.dumps({k:v for k,v in x.items() if k not in ['families','current']}))

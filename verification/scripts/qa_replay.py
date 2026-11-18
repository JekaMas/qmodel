"""One exact-source replay of each current isolated negative and one positive.

This checks the requested reproduction contract, not a repeat of expensive model
graphs. Each replay starts a fresh child and compares immutable native states.
"""
import json,subprocess,sys
from audit_evidence import ROOT,load_latest
def main():
 rows=json.loads((ROOT/'verification/mutants/qa-controls.json').read_text())
 names=[x['id'] for x in rows]+['qa-legacy-'+x for x in ['expiry','binding','replay','reopen','non_atomic','relayer_assertion','stale_refund','pruned_tombstone']]
 names += [x['negative'] for x in json.loads((ROOT/'verification/mutants/admission-placements.json').read_text())]
 names+=['qa-false-release','qa-non-atomic-cash','qa-partial-shared','qa-role-confusion','qa-role-confusion-access','qa-economic-shared']
 planned=names[:]
 focused='--focused' in sys.argv
 if focused:names=['qa-payload_field0','qa-program_admission','qa-premature_absence','qa-cash_recipient']
 observations=[]
 for name in names:
  _,r=load_latest(name);original=r['id']
  # The recorded exact closure/seed is deliberately rerun once. Do not ask the
  # family selector to substitute another source revision for a failed attempt.
  p=subprocess.run([sys.executable,'verification/scripts/replay.py',original],cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
  if p.returncode:print(p.stdout);raise RuntimeError('Exact replay failed: '+original)
  m=max((ROOT/'verification/results/replays'/original).glob('*/replay.json'))
  x=json.loads(m.read_text())
  assert x['forced_new_process'] and x['outcome_reproduced']
  if r['expected']=='counterexample':assert x['native_states_match'] is True,original
  observations.append({'family':name,'original':original,'association':str(m.relative_to(ROOT)),**x})
 out={'status':'passed','mode':'focused' if focused else 'full','planned_count':len(planned),'deferred':[name for name in planned if name not in names],'observations':observations,'count':len(observations),'negative_native_states_match':sum(x['native_states_match'] is True for x in observations),'minimized':False,'scope':'Exact saved inputs/seed/current pinned toolchain; no shortest/global-minimum counterexample claim.'}
 (ROOT/'verification/reports/qa-replay-validation.json').write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps({k:v for k,v in out.items() if k!='observations'}))
if __name__=='__main__':main()

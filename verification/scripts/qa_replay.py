"""One exact-source replay of each current isolated negative and one positive.

This checks the requested reproduction contract, not a repeat of expensive model
graphs. Each replay starts a fresh child and compares immutable native states.
"""
import argparse,json,subprocess,sys
from audit_evidence import ROOT,load_latest,validate

REPORT=ROOT/'verification/reports/qa-replay-validation.json'

def retained_replay(family,original,prior):
 association=ROOT/prior['association']
 record=json.loads(association.read_text())
 assert prior=={'family':family,'original':original,'association':prior['association'],**record}
 assert record['original_receipt']==f'verification/results/runs/{original}/receipt.json'
 receipt=ROOT/'verification/results/runs'/record['replay_receipt']/'receipt.json'
 observed=json.loads(receipt.read_text());validate(observed,receipt)
 assert observed['configuration']['forced'] and record['forced_new_process']
 assert record['outcome_reproduced'] and record['native_states_match'] is not False
 return prior

def main():
 parser=argparse.ArgumentParser(description=__doc__)
 selection=parser.add_mutually_exclusive_group()
 selection.add_argument('--focused',action='store_true')
 selection.add_argument('--remaining',action='store_true',help='reuse sealed prior replays and run only missing families')
 args=parser.parse_args()
 rows=json.loads((ROOT/'verification/mutants/qa-controls.json').read_text())
 names=[x['id'] for x in rows]+['qa-legacy-'+x for x in ['expiry','binding','replay','reopen','non_atomic','relayer_assertion','stale_refund','pruned_tombstone']]
 names += [x['negative'] for x in json.loads((ROOT/'verification/mutants/admission-placements.json').read_text())]
 names+=['qa-false-release','qa-non-atomic-cash','qa-partial-shared','qa-role-confusion','qa-role-confusion-access','qa-economic-shared']
 planned=names[:]
 focused=args.focused
 if focused:names=['qa-payload_field0','qa-program_admission','qa-premature_absence','qa-cash_recipient']
 prior={}
 if args.remaining:
  prior={row['family']:row for row in json.loads(REPORT.read_text())['observations']}
 observations=[]
 reused=0
 for name in names:
  _,r=load_latest(name);original=r['id']
  if name in prior and prior[name]['original']==original:
   observation=retained_replay(name,original,prior[name])
   if r['expected']=='counterexample':assert observation['native_states_match'] is True,original
   observations.append(observation);reused+=1
   continue
  # The recorded exact closure/seed is deliberately rerun once. Do not ask the
  # family selector to substitute another source revision for a failed attempt.
  p=subprocess.run([sys.executable,'verification/scripts/replay.py',original],cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
  if p.returncode:print(p.stdout);raise RuntimeError('Exact replay failed: '+original)
  m=max((ROOT/'verification/results/replays'/original).glob('*/replay.json'))
  x=json.loads(m.read_text())
  assert x['forced_new_process'] and x['outcome_reproduced']
  if r['expected']=='counterexample':assert x['native_states_match'] is True,original
  observations.append({'family':name,'original':original,'association':str(m.relative_to(ROOT)),**x})
 out={'status':'passed','mode':'focused' if focused else 'full','planned_count':len(planned),'deferred':[name for name in planned if name not in names],'observations':observations,'count':len(observations),'new_replays':len(observations)-reused,'retained_replays':reused,'negative_native_states_match':sum(x['native_states_match'] is True for x in observations),'minimized':False,'scope':'Exact saved inputs/seed/current pinned toolchain; no shortest/global-minimum counterexample claim.'}
 REPORT.write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps({k:v for k,v in out.items() if k!='observations'}))
if __name__=='__main__':main()

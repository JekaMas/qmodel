"""Independent checks of backend observations and preserved source identity."""
from pathlib import Path
import json,hashlib,re
ROOT=Path(__file__).resolve().parents[2]
class EvidenceError(ValueError):pass
def load_latest(base):
 xs=[]
 for p in (ROOT/'verification/results/runs').glob('*/receipt.json'):
  r=json.loads(p.read_text())
  if r['id']==base or r['id'].startswith(base+'-attempt'):xs.append((r['started_utc'],p,r))
 if not xs:raise EvidenceError('Missing executed check '+base)
 return max(xs,key=lambda x:x[0])[1:]
def validate(r,p):
 # The selected native claim is fixed by a reviewed, versioned observation contract.
 # A generic "Invariant violated" line cannot certify a new command or property.
 contracts=json.loads((ROOT/'verification/configs/proof-contracts.json').read_text())['observations']
 fixed=contracts.get(p.parent.name)
 canonical=hashlib.sha256(json.dumps(r,sort_keys=True,separators=(',',':')).encode()).hexdigest()
 if not fixed or canonical!=fixed['receipt_sha256']:raise EvidenceError('Receipt differs from its sealed proof contract')
 raw_path=ROOT/fixed['raw_output']
 if hashlib.sha256(raw_path.read_bytes()).hexdigest()!=fixed['raw_sha256']:raise EvidenceError('Native output identity changed')
 if r.get('raw_sha256') and r['raw_sha256']!=fixed['raw_sha256']:raise EvidenceError('Execution raw hash is inconsistent')
 for path,h in ([(r['native_trace'],r['native_trace_sha256'])] if r.get('native_trace') else []):
  if hashlib.sha256((ROOT/path).read_bytes()).hexdigest()!=h:raise EvidenceError('Per-execution native trace changed')
 if fixed.get('native_export'):
  native=fixed['native_export']
  for path,h in [(native['path'],native['sha256']),(native['association'],native['association_sha256'])]:
   if hashlib.sha256((ROOT/path).read_bytes()).hexdigest()!=h:raise EvidenceError('Historical immutable native association changed')
 if r.get('execution_plan_sha256'):
  plan=p.parent/'execution-plan.json'
  if not plan.is_file() or hashlib.sha256(plan.read_bytes()).hexdigest()!=r['execution_plan_sha256']:raise EvidenceError('Execution plan identity changed')
  planned=json.loads(plan.read_text())
  for key in ['command','claim','expected','backend','configuration','input_hashes','tooling_hashes','timeout_seconds']:
   if planned[key]!=r[key]:raise EvidenceError('Observed invocation differs from pre-execution plan: '+key)
  for key,val in planned['tool_versions'].items():
   if r['tool_versions'].get(key)!=val:raise EvidenceError('Observed runtime identity differs from plan')
  for rel,h in r['tooling_hashes'].items():
   tool=p.parent/'tooling'/rel
   if not tool.is_file() or hashlib.sha256(tool.read_bytes()).hexdigest()!=h:raise EvidenceError('Tooling source identity changed')
 if not r.get('expectation_met'):raise EvidenceError('Observation did not meet expectation: '+r['id'])
 raw=(ROOT/r['raw_output']).read_text()
 if any(x in raw for x in ['Error [QNT','Unknown argument','java.lang.OutOfMemoryError','UnsupportedClassVersionError']):raise EvidenceError('Tool error is not property evidence')
 if r['expected']=='counterexample':
  if r['exit_code']==0 or not any(x in raw for x in ['Invariant violated','Invariant q_inv is violated','Temporal properties were violated','found a counterexample']):raise EvidenceError('No actual expected property violation')
 elif r['backend']=='tlc':
  if r['exit_code']!=0 or 'Model checking completed. No error has been found.' not in raw:raise EvidenceError('TLC graph did not complete')
  if not isinstance(r['distinct_states'],int) or r['distinct_states']<1:raise EvidenceError('Missing actual finite state count')
 elif r['backend']=='apalache':
  if r['exit_code']!=0 or '[ok] No violation found' not in raw:raise EvidenceError('No successful Apalache observation')
 elif r['backend']=='simulation':
  if r['exit_code']!=0 or '[ok] No violation found' not in raw:raise EvidenceError('No successful simulation observation')
 elif r['exit_code']!=0:raise EvidenceError('CLI/scenario command did not succeed')
 if 'test' in r['command']:
  counts=re.findall(r'(\d+) passing',raw)
  if not counts or int(counts[-1])<1:raise EvidenceError('No actual selected scenario passed')
 if r['expected']=='counterexample' and r['outcome']!='expected_counterexample_found':raise EvidenceError('Counterexample classification mismatch')
 if r['expected']=='pass' and r['outcome'] not in ['finite_model_verified','bounded_no_counterexample','sampled_no_counterexample','inductive_obligations_verified_with_stated_scope','executed_successfully']:raise EvidenceError('Success classification mismatch')
 for rel,expected in r['input_hashes'].items():
  snapshot=p.parent/'inputs'/rel
  if not snapshot.is_file():raise EvidenceError('Missing recorded source closure '+rel)
  if hashlib.sha256(snapshot.read_bytes()).hexdigest()!=expected:raise EvidenceError('Recorded source hash mismatch '+rel)
 return True

def audit_required():
 cfg=json.loads((ROOT/'verification/configs/acceptance.json').read_text())
 for base in cfg['required']:
  p,r=load_latest(base);validate(r,p)
 return len(cfg['required'])

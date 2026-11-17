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

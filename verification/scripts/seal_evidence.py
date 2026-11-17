"""Append immutable observation contracts; never relabel existing source or raw data.

Historical entries are checked against the first reviewed Git commit. New entries
are execution observations reviewed in the current iteration. The resulting file
is a repository trust anchor, not a third-party cryptographic attestation.
"""
from pathlib import Path
import json,hashlib,subprocess
ROOT=Path(__file__).resolve().parents[2]
BASE='4e3b8d0b440c5b4a9c562f3509b6c78106a3d885'
DEST=ROOT/'verification/configs/proof-contracts.json'
def canonical(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def seal():
 data=json.loads(DEST.read_text()) if DEST.exists() else {'schema_version':1,'trust_boundary':'Versioned local observations and reviewed checker invocation; not independently signed execution attestation. Historical tool-version fields retain their original observation limits.','historical_commit':BASE,'observations':{}}
 # Older exports used mutable shared names. Only the exact-source replay exports
 # already committed at BASE, with an explicit matching-receipt association, can
 # serve as immutable comparison baselines. Other old exports stay unavailable.
 exports={}
 for meta in (ROOT/'verification/results/replays').glob('*/replay.json'):
  rel_meta=str(meta.relative_to(ROOT));q=subprocess.run(['git','show',BASE+':'+rel_meta],cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL)
  if q.returncode:continue
  m=json.loads(q.stdout);native=meta.parent/'native.itf.json'
  if m.get('native_states_match') is not True or not m.get('verdict_reproduced') or not native.is_file():continue
  rel_native=str(native.relative_to(ROOT));blob=subprocess.check_output(['git','show',BASE+':'+rel_native],cwd=ROOT)
  if blob!=native.read_bytes() or q.stdout!=meta.read_bytes():raise ValueError('Historical replay export/association changed')
  exports[m['original_receipt']]={'path':rel_native,'sha256':sha(native),'association':rel_meta,'association_sha256':sha(meta),'origin':BASE,'scope':'Exact-source replay previously matched the recorded native sequence; original shared output is not consulted.'}
 added=0
 for p in sorted((ROOT/'verification/results/runs').glob('*/receipt.json')):
  r=json.loads(p.read_text());raw=ROOT/r['raw_output'];rel=str(p.relative_to(ROOT))
  old=subprocess.run(['git','show',BASE+':'+rel],cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL)
  if old.returncode==0:
   if json.loads(old.stdout)!=r:raise ValueError('Historical receipt changed: '+rel)
   old_raw=subprocess.check_output(['git','show',BASE+':'+r['raw_output']],cwd=ROOT)
   if old_raw!=raw.read_bytes():raise ValueError('Historical raw output changed: '+r['id'])
  entry={'receipt_sha256':canonical(r),'raw_sha256':sha(raw),'raw_output':r['raw_output'],
   'proof_contract':{k:r[k] for k in ['claim','backend','command','expected','configuration','input_hashes','tool_versions','timeout_seconds','resource_limit']},
   'native_targets':{flag:r['command'][i+1] for i,flag in enumerate(r['command'][:-1]) if flag in ['--main','--init','--step','--invariant','--invariants','--temporal','--inductive-invariant','--match','--max-steps','--max-samples','--seed','--backend']},
   'origin':BASE if old.returncode==0 else 'current independent-review iteration execution'}
  if rel in exports:entry['native_export']=exports[rel]
  if r['id'] in data['observations']:
   previous=data['observations'][r['id']]
   if {k:v for k,v in previous.items() if k!='native_export'}!={k:v for k,v in entry.items() if k!='native_export'}:raise ValueError('Sealed observation changed: '+r['id'])
   if 'native_export' in previous and previous['native_export']!=entry.get('native_export'):raise ValueError('Sealed native association changed')
   if 'native_export' not in previous and 'native_export' in entry:previous['native_export']=entry['native_export']
  else:data['observations'][r['id']]=entry;added+=1
 DEST.write_text(json.dumps(data,indent=2)+'\n');print(json.dumps({'sealed_observations':len(data['observations']),'new':added,'historical_commit':BASE}))
if __name__=='__main__':seal()

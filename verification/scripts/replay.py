"""Force a new execution of an exact recorded input closure, without cached replay.

Exact receipt IDs are the default. --latest-success explicitly selects a family;
--include-failed permits reproducing a timeout/tool error without calling it a
passing property check. Native state comparison is performed only when exported.
"""
from evidence import *
import argparse,copy

def canonical(x):
 if isinstance(x,list):return [canonical(v) for v in x]
 if isinstance(x,dict):
  if '#set' in x:return {'#set':sorted((canonical(v) for v in x['#set']),key=lambda y:json.dumps(y,sort_keys=True))}
  if '#map' in x:return {'#map':sorted((canonical(v) for v in x['#map']),key=lambda y:json.dumps(y,sort_keys=True))}
  return {k:canonical(v) for k,v in x.items() if k!='#meta'}
 return x

def select_receipt(name,latest_success=False,include_failed=False):
 if latest_success:
  found=[]
  for p in (RESULTS/'runs').glob('*/receipt.json'):
   r=json.loads(p.read_text())
   if (r['id']==name or r['id'].startswith(name+'-attempt')) and r['expectation_met']:found.append((r['started_utc'],p,r))
  if not found:raise ValueError('No successful recorded family observation: '+name)
  _,p,r=max(found,key=lambda v:v[0])
 else:
  p=RESULTS/'runs'/name/'receipt.json'
  if not p.is_file():raise ValueError('Exact receipt not found: '+name+'; use --latest-success for a family')
  r=json.loads(p.read_text())
 if not r['expectation_met'] and not include_failed:raise ValueError('Exact receipt is an original non-success; add --include-failed to reproduce that outcome')
 return p,r

def comparison_trace(r,fixed):
 # This function deliberately never consults the mutable --out-itf command path.
 if r.get('native_trace'):return ROOT/r['native_trace']
 if fixed.get('native_export'):return ROOT/fixed['native_export']['path']
 return None

def captured_argument(receipt_path,r,arg):
 # Replays themselves may record absolute input paths. Resolve them relative to
 # that invocation's project root, never against a live old checkout on this host.
 original=Path(arg)
 if original.is_absolute():
  prior_root=Path(r['environment']['QUINT_HOME']).parent
  try:key=str(original.relative_to(prior_root))
  except ValueError:raise ValueError('Recorded input is outside its captured project root: '+arg)
 else:key=arg
 if key not in r['input_hashes']:raise ValueError('Uncaptured input cannot be replayed exactly: '+key)
 target=receipt_path.parent/'inputs'/key
 if not target.is_file() or digest(target)!=r['input_hashes'][key]:raise ValueError('Captured argument is missing or corrupted: '+key)
 return target

def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('receipt')
 parser.add_argument('--latest-success',action='store_true');parser.add_argument('--include-failed',action='store_true')
 parser.add_argument('--seconds',type=int,help='explicit override for investigating a prior resource limit')
 args=parser.parse_args();receipt_path,r=select_receipt(args.receipt,args.latest_success,args.include_failed)
 # Verify successful source observations against their sealed native proof contract.
 from audit_evidence import validate
 if r['expectation_met']:validate(r,receipt_path)
 else:
  sealed=json.loads((ROOT/'verification/configs/proof-contracts.json').read_text())['observations'][r['id']]
  if hashlib.sha256(json.dumps(r,sort_keys=True,separators=(',',':')).encode()).hexdigest()!=sealed['receipt_sha256']:raise ValueError('Original failed receipt changed')
  if digest(ROOT/r['raw_output'])!=sealed['raw_sha256']:raise ValueError('Original failed native output changed')
 for rel,h in r['input_hashes'].items():
  snapshot=receipt_path.parent/'inputs'/rel
  if not snapshot.is_file() or digest(snapshot)!=h:raise ValueError('Missing/corrupted exact source closure: '+rel)
 cmd=copy.deepcopy(r['command'])
 if Path(cmd[0]).name=='quint':cmd[0]=QUINT
 # A shared --out-itf pathname may now contain another attempt's state schema.
 # Compare only this receipt's own snapshot or a sealed immutable exact replay.
 fixed=json.loads((ROOT/'verification/configs/proof-contracts.json').read_text())['observations'][r['id']]
 old_trace=comparison_trace(r,fixed)
 original=canonical(json.loads(old_trace.read_text())['states']) if old_trace and old_trace.is_file() else None
 for i,arg in enumerate(cmd):
  if i and cmd[i-1] in ['--out-itf','--out','--output']:continue
  if arg.endswith(('.qnt','.json')):cmd[i]=str(captured_argument(receipt_path,r,arg))
 stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
 out=RESULTS/'replays'/r['id']/stamp;out.mkdir(parents=True)
 if '--out-itf' in cmd:cmd[cmd.index('--out-itf')+1]=str(out/'native.itf.json')
 obs=execute('replay-'+r['id'],cmd,claim=r['claim'],expected=r['expected'],backend=r['backend'],seconds=args.seconds or r['timeout_seconds'],config={'recorded_receipt':str(receipt_path.relative_to(ROOT)),'replay_input':'exact saved source closure','forced':True},force=True)
 matched=canonical(json.loads((out/'native.itf.json').read_text())['states'])==original if original is not None and (out/'native.itf.json').is_file() else None
 reproduced=obs['outcome']==r['outcome']
 result={'original_receipt':str(receipt_path.relative_to(ROOT)),'replay_receipt':obs['id'],'original_outcome':r['outcome'],'observed_outcome':obs['outcome'],'outcome_reproduced':reproduced,'native_states_match':matched,'native_comparison':'immutable associated export' if original is not None else 'unavailable: no per-execution native export associated with original receipt','forced_new_process':True,'minimized':False,'method':'exact saved source closure and invocation/seed, observed current pinned toolchain; no cached execution'}
 (out/'replay.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
 return 0 if (obs['expectation_met'] if args.seconds else reproduced) and matched is not False else 1
if __name__=='__main__':sys.exit(main())

"""Replay an actual counterexample against its exact recorded model-input closure."""
from evidence import *
import argparse,copy

def canonical(x):
 if isinstance(x,list):return [canonical(v) for v in x]
 if isinstance(x,dict):
  if '#set' in x:return {'#set':sorted((canonical(v) for v in x['#set']),key=lambda y:json.dumps(y,sort_keys=True))}
  if '#map' in x:return {'#map':sorted((canonical(v) for v in x['#map']),key=lambda y:json.dumps(y,sort_keys=True))}
  return {k:canonical(v) for k,v in x.items() if k!='#meta'}
 return x

def latest(base):
 found=[]
 for p in (RESULTS/'runs').glob('*/receipt.json'):
  r=json.loads(p.read_text())
  if (r['id']==base or r['id'].startswith(base+'-attempt')) and r['expectation_met']:found.append((r['started_utc'],p,r))
 if not found:raise ValueError('No successful recorded observation: '+base)
 return max(found,key=lambda v:v[0])[1:]

if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('receipt');args=p.parse_args()
 receipt_path,r=latest(args.receipt);cmd=copy.deepcopy(r['command']);cmd[0]=QUINT
 original_trace=None
 if '--out-itf' in cmd:
  original_trace=ROOT/cmd[cmd.index('--out-itf')+1]
  original_states=canonical(json.loads(original_trace.read_text())['states']) if original_trace.is_file() else None
 else:original_states=None
 for i,arg in enumerate(cmd):
  saved=receipt_path.parent/'inputs'/arg
  if arg.endswith(('.qnt','.json')) and saved.is_file():cmd[i]=str(saved)
 out=RESULTS/'replays'/args.receipt;out.mkdir(parents=True,exist_ok=True)
 if '--out-itf' in cmd:cmd[cmd.index('--out-itf')+1]=str(out/'native.itf.json')
 obs=execute('replay-'+args.receipt,cmd,claim=r['claim'],expected=r['expected'],backend=r['backend'],seconds=r['timeout_seconds'],config={'recorded_receipt':str(receipt_path.relative_to(ROOT)),'replay_input':'exact saved source closure'})
 matched=None
 if original_states is not None and (out/'native.itf.json').is_file():matched=canonical(json.loads((out/'native.itf.json').read_text())['states'])==original_states
 result={'original_receipt':str(receipt_path.relative_to(ROOT)),'replay_receipt':obs['id'],'verdict_reproduced':obs['expectation_met'],'native_states_match':matched,'minimized':False,'method':'same recorded model closure, command, backend and seed; compare normalized ITF states where exported'}
 (out/'replay.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
 sys.exit(0 if obs['expectation_met'] and matched is not False else 1)

"""Execution evidence. Every child is bounded and stays in its parent's process group."""
from pathlib import Path
import subprocess,os,sys,json,time,hashlib,signal,resource,datetime,re,shlex
ROOT=Path(__file__).resolve().parents[2]; V=ROOT/'verification'; RESULTS=V/'results'
JAVABIN=Path(os.environ.get('QMODEL_JAVA_BIN','/Applications/GoLand.app/Contents/jbr/Contents/Home/bin'))
ENV={**os.environ,'PATH':str(JAVABIN)+os.pathsep+os.environ['PATH'] if JAVABIN.exists() else os.environ['PATH'],'QUINT_HOME':str(ROOT/'.quint'),'JAVA_TOOL_OPTIONS':'-Xmx2g -Xss8m','JVM_ARGS':'-Xmx2g -Xss8m'}
QUINT=str(ROOT/'node_modules/.bin/quint')
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def inputs(cmd):
 found={}
 def visit(p):
  p=p.resolve()
  if not p.is_file() or str(p.relative_to(ROOT)) in found:return
  found[str(p.relative_to(ROOT))]=digest(p)
  if p.suffix=='.qnt':
   for ref in re.findall(r'from\s+"([^"]+)"',p.read_text()):visit((p.parent/ref).with_suffix('.qnt'))
 for arg in cmd:
  if arg.endswith(('.qnt','.json')) and (ROOT/arg).is_file():visit(ROOT/arg)
 return found

def execute(id,cmd,*,claim,expected='pass',backend='cli',seconds=120,config=None,record=True):
 d=RESULTS/'runs'/id
 if d.exists():
  # Reuse evidence only if exact semantic input and command remain unchanged.
  old=json.loads((d/'receipt.json').read_text()) if (d/'receipt.json').exists() else None
  hashes=inputs(cmd)
  if old and old['command']==cmd and old['input_hashes']==hashes and old['expectation_met']:
   print('REUSE',id,old['outcome'],flush=True);return old
  n=1
  while (RESULTS/'runs'/f'{id}-attempt{n}').exists():n+=1
  d=RESULTS/'runs'/f'{id}-attempt{n}'
 d.mkdir(parents=True)
 hashes=inputs(cmd)
 for rel in hashes:
  dest=d/'inputs'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes((ROOT/rel).read_bytes())
 started=time.monotonic();timestamp=datetime.datetime.now(datetime.timezone.utc).isoformat()
 with (d/'raw.log').open('w') as f:
  proc=subprocess.Popen(cmd,cwd=ROOT,env=ENV,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
  timedout=False
  try:code=proc.wait(timeout=seconds)
  except subprocess.TimeoutExpired:
   timedout=True;os.killpg(proc.pid,signal.SIGTERM)
   try:code=proc.wait(timeout=5)
   except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);code=proc.wait()
 raw=(d/'raw.log').read_text();duration=time.monotonic()-started
 # A nonzero status alone never kills a mutant. Require a property violation from the backend.
 violation=bool(re.search(r'Invariant .+ is violated|Temporal properties were violated|[Ii]nvariant.*violated|found a counterexample|invariant violated|Invariant violated|Temporal property.*violated',raw))
 toolerror=bool(re.search(r'error:|Error \[QNT|java.lang.|Could not find|Unhandled|Unknown argument',re.sub(r'error: Invariant violated|error: found a counterexample','',raw)))
 if timedout:outcome='timeout'
 elif violation and not toolerror:outcome='expected_counterexample_found' if expected=='counterexample' else 'counterexample_found'
 elif code!=0 or toolerror:outcome='tool_error'
 elif backend=='tlc':outcome='finite_model_verified'
 elif '--inductive-invariant' in cmd:outcome='inductive_obligations_verified_with_stated_scope'
 elif backend=='apalache':outcome='bounded_no_counterexample'
 elif backend=='simulation':outcome='sampled_no_counterexample'
 else:outcome='executed_successfully'
 ok=(expected=='counterexample' and outcome=='expected_counterexample_found') or (expected=='pass' and code==0 and not violation and not toolerror and not timedout)
 counts=re.search(r'([\d,]+) states generated, ([\d,]+) distinct states found',raw)
 receipt=dict(id=d.name,started_utc=timestamp,claim=claim,backend=backend,command=cmd,
  shell_command=shlex.join(cmd),environment={k:ENV[k] for k in ['QUINT_HOME','JAVA_TOOL_OPTIONS','JVM_ARGS','PATH']},
  input_hashes=hashes,tool_versions={'quint':'0.33.1','apalache':'0.62.4','tlc':'see raw backend banner','node':(RESULTS/'toolchain/node-version.txt').read_text().strip(),'java':(RESULTS/'toolchain/java-version.txt').read_text().strip()},
  configuration=config or {},timeout_seconds=seconds,resource_limit='2 GiB JVM heap, 8 MiB stack; one heavy checker at a time',
  exit_code=code,wall_seconds=duration,outcome=outcome,expected=expected,expectation_met=ok,
  states_generated=int(counts[1].replace(',','')) if counts else 'unavailable',distinct_states=int(counts[2].replace(',','')) if counts else 'unavailable',raw_output=str((d/'raw.log').relative_to(ROOT)),minimized=False,replayed=False)
 (d/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
 print(id,outcome,'OK' if ok else 'FAILED',f'{duration:.2f}s',flush=True)
 if not ok:print(raw[-2500:],flush=True)
 return receipt

def qrun(id,path,main,inv='safe',samples=10000,steps=80,seed=17,expected='pass',step='step',seconds=180):
 cmd=[QUINT,'run',path,'--main',main,'--backend','rust','--invariant',inv,'--max-samples',str(samples),'--max-steps',str(steps),'--seed',str(seed),'--verbosity','1','--step',step]
 if expected=='counterexample':
  cmd[cmd.index('--verbosity')+1]='2'
  cmd+=['--out-itf',f'verification/results/traces/{id}.itf.json']
 return execute(id,cmd,claim=inv,backend='simulation',expected=expected,seconds=seconds,config={'main':main,'step':step,'samples':samples,'steps':steps,'seed':seed})

def qverify(id,path,main,inv='safe',backend='apalache',depth=10,temporal=None,seconds=180):
 cmd=[QUINT,'verify',path,'--main',main,'--backend',backend,'--max-steps',str(depth),'--verbosity','3']
 if inv:cmd+=['--invariant',inv]
 if temporal:cmd+=['--temporal',temporal]
 if backend=='tlc':cmd+=['--tlc-config','verification/configs/tlc.json']
 return execute(id,cmd,claim=[inv,temporal],backend=backend,seconds=seconds,config={'main':main,'depth':depth,'temporal':temporal})

if __name__=='__main__':
 import argparse
 p=argparse.ArgumentParser();p.add_argument('id');p.add_argument('--claim',default='tool capability');p.add_argument('--backend',default='cli');p.add_argument('--expected',default='pass');p.add_argument('--seconds',type=int,default=120);p.add_argument('cmd',nargs=argparse.REMAINDER);a=p.parse_args()
 cmd=a.cmd[1:] if a.cmd and a.cmd[0]=='--' else a.cmd
 r=execute(a.id,cmd,claim=a.claim,backend=a.backend,expected=a.expected,seconds=a.seconds);sys.exit(0 if r['expectation_met'] else 1)

"""Sequential full-model checks for the four original timeout obligations.

Reuse sealed valid full-model observations whose semantic inputs still match.
--fresh deliberately executes again. Default budget is7200seconds per invocation,
8GiB heap; eight TLC workers for broader graphs and four for the reference. This is a local resource cap, not a protocol bound.
Full-state TLC safety covers every depth; direct SMT20 remains an optional
performance investigation, never an implicit passing substitution.
"""
from evidence import *
from audit_evidence import load_latest,validate,EvidenceError
import argparse

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('suite',nargs='?',default='all',choices=['all','apalache','reference','tlc','two','recovery','smt20'])
 p.add_argument('--seconds',type=int,default=7200)
 p.add_argument('--fresh',action='store_true')
 a=p.parse_args()
 if a.seconds<1:p.error('--seconds must be positive')
 profile={'JAVA_TOOL_OPTIONS':'-Xmx8g -Xss8m','JVM_ARGS':'-Xmx8g -Xss8m'}
 limits=f'8 GiB JVM heap,8 MiB stack; TLC four(reference)/eight(broader) workers; one active heavy checker;{a.seconds} seconds'
 results=[]
 def run(id,cmd,claim,backend,scope):
  if not a.fresh:
   try:
    path,old=load_latest(id)
    # A larger requested budget does not invalidate a completed behavior proof.
    # Reuse its original receipt/resources; never rewrite them as this profile.
    if old['command']==cmd and old['input_hashes']==inputs(cmd) and old['claim']==claim and old['backend']==backend:
     validate(old,path);results.append(old);print('REUSE sealed full model',old['id'],flush=True);return
   except (EvidenceError,OSError,ValueError):pass
  r=execute(id,cmd,claim=claim,backend=backend,seconds=a.seconds,config={'scope':scope,'original_limit_seconds':180,'no_behavior_reduction':True},execution_env=profile,resource_limit=limits,force=a.fresh)
  results.append(r)
  if not r['expectation_met']:raise RuntimeError('Full-model check did not complete successfully: '+r['id'])
 if a.suite in ['all','apalache','smt20']:
  depth=20 if a.suite=='smt20' else 12
  run('extended-apalache-core-'+str(depth),[QUINT,'verify','verification/models/dvp.qnt','--main','baseline','--backend','apalache','--server-endpoint','localhost:8841','--max-steps',str(depth),'--invariants','safe','CDecision','--apalache-config','verification/configs/extended-apalache.json','--verbosity','3'],['safe','CDecision','all prefixes through '+str(depth)],'apalache','Current full reference; invariant-after batches queries without filtering any transition or invariant.')
 if a.suite in ['all','reference']:
  run('extended-tlc-full-reference',[QUINT,'verify','verification/models/dvp.qnt','--main','baseline','--backend','tlc','--server-endpoint','localhost:8843','--init','init','--step','step','--tlc-config','verification/configs/extended-tlc.json','--invariants','safe','CDecision','--verbosity','3'],['safe','CDecision','all reachable states/prefixes of full current reference, hence includes depths12/20'],'tlc','Identical full State/init/step, including all proof phases0-6. Exhaustive safety covers depth20 without a compact or algebraic substitution.')
 for name,path,module,step,temporal in [('two','liveness_variants','live_two','step','progress'),('recovery','recovery','recovery','recoveryStep','recoveryProgress')]:
  if a.suite not in ['all','tlc',name]:continue
  run('extended-tlc-'+name,[QUINT,'verify','verification/models/'+path+'.qnt','--main',module,'--backend','tlc','--server-endpoint','localhost:8842','--init','init','--step',step,'--tlc-config','verification/configs/extended-tlc8.json','--invariants','safe','CDecision','--temporal',temporal,'--verbosity','3'],['safe','CDecision',temporal],'tlc','Current unrestricted full configuration, including unsolicited OPEN/A-preparation proof jobs phases0-6, authentic ABORT records and original per-trade/per-action fairness.')
 print(json.dumps({'suite':a.suite,'outcomes':{r['id']:r['outcome'] for r in results}}))
if __name__=='__main__':main()

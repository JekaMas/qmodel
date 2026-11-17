from evidence import *
import argparse
p=argparse.ArgumentParser();p.add_argument('suite',choices=['baseline','negative','smoke','models','simulation']);p.add_argument('--only');a=p.parse_args();rs=[]
def run(id,cmd,**kw):
 if not a.only or a.only in id:rs.append(execute(id,cmd,**kw))
if a.suite=='smoke':
 for inv,expect in [('TypeOK','pass'),('falseInvariant','counterexample')]:
  run('smoke-apalache-'+inv,[QUINT,'verify','verification/models/smoke.qnt','--invariant',inv,'--max-steps','2','--verbosity','3'],claim=inv,expected=expect,backend='apalache',seconds=120)
 for temporal,expect in [('fairProgress','pass'),('progress','counterexample')]:
  run('smoke-tlc-'+temporal,[QUINT,'verify','verification/models/smoke.qnt','--backend','tlc','--temporal',temporal,'--tlc-config','verification/configs/tlc.json','--verbosity','3'],claim=temporal,expected=expect,backend='tlc',seconds=120)
if a.suite in ['baseline','models']:
 for f in sorted(list((V/'models').glob('*.qnt'))+list((V/'tests').glob('*.qnt'))+list((V/'mutants').glob('*.qnt'))):
  run('typecheck-'+f.stem,[QUINT,'typecheck',str(f.relative_to(ROOT))],claim='parse/type/effect correctness')
 run('core-scenarios',[QUINT,'test','verification/tests/dvp_test.qnt','--main','dvp_test','--match','.*Test','--backend','typescript','--seed','17'],claim='19 exact named core scenarios')
if a.suite in ['baseline','simulation']:
 for main in ['baseline','contention']:
  for seed in [17,29,43]:
   if not a.only or a.only in 'core-'+main+'-'+str(seed):rs.append(qrun('core-'+main+'-'+str(seed),'verification/models/dvp.qnt',main,seed=seed))
if a.suite=='negative':
 for m in json.loads((V/'mutants/manifest.json').read_text()):
  name=m['id'];run('mutant-'+name,[QUINT,'run','verification/mutants/guided.qnt','--main',name,'--init','initGuided','--step','stepGuided','--backend','typescript','--invariant',m['property'],'--max-samples','1','--max-steps',str(len(m['schedule'])+1),'--seed','17','--verbosity','2','--out-itf',f'verification/results/traces/{name}.itf.json'],claim=m['property'],expected='counterexample',backend='simulation',config=m)
if a.suite=='baseline':
 for depth in [4,12,20]:
  if not a.only or a.only in f'apalache-core-{depth}':rs.append(qverify(f'apalache-core-{depth}','verification/models/dvp.qnt','baseline',depth=depth,seconds=180))
 if not a.only or a.only in 'tlc-core':rs.append(qverify('tlc-core','verification/models/dvp.qnt','baseline',backend='tlc',seconds=180))
print(json.dumps({'checks':len(rs),'met':sum(r['expectation_met'] for r in rs),'failed':[r['id'] for r in rs if not r['expectation_met']]}))
sys.exit(0 if rs and all(r['expectation_met'] for r in rs) else 1)

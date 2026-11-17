from evidence import *
# Heavy checks are strictly sequential in this driver.
import argparse
p=argparse.ArgumentParser();p.add_argument('suite',choices=['privacy','timing','operations','integrated','variants','liveness','bounds','inductive']);p.add_argument('--only');a=p.parse_args();specs=[]
if a.suite=='privacy':
 for main,inv,step,expected in [('privacy_safe','PNI','pairedStep','pass'),('privacy_safe','PAccess','accessStep','pass'),('privacy_safe','PBinding','bindingStep','pass'),('privacy_safe','PScope','scopeStep','pass'),('witness_log','PNI','pairedStep','counterexample'),('timing_leak','PTiming','pairedStep','counterexample'),('unsalted','PNI','pairedStep','counterexample'),('wrong_scope','PAccess','accessStep','counterexample'),('disclosure_substitution','PBinding','bindingStep','counterexample')]:specs.append((main,'privacy',inv,None,step,expected))
if a.suite=='timing':
 for main,inv,temporal,expected in [('bounded','safe','timeProgress','pass'),('bounded','sufficientSlack',None,'pass'),('slow_blocks','safe',None,'pass'),('insufficient_margin','sufficientSlack',None,'counterexample'),('local_timer','asyncSafety',None,'counterexample'),('no_inclusion','boundedCompletion',None,'counterexample'),('starvation','boundedCompletion',None,'counterexample'),('frozen_time',None,'timeProgress','counterexample')]:specs.append((main,'timing',inv,temporal,'step',expected))
if a.suite=='operations':
 for main,model,inv,temp,expected in [('trust_safe','trust','safe',None,'pass'),('equivocation','trust','canonicalAcceptance',None,'counterexample'),('issuer_destruction','trust','backed',None,'counterexample'),('verifier_takeover','trust','canonicalAcceptance',None,'counterexample'),('retired_version','trust','historical',None,'counterexample'),('durable','interventions','safe','progress','pass'),('coordinated','interventions','safe','progress','pass'),('mandatory_freeze','interventions',None,'progress','counterexample'),('arbitrary_seizure','interventions','backing',None,'counterexample'),('committee_refusal','trust','recoverable',None,'counterexample'),('insufficient_submitters','trust','recoverable',None,'counterexample'),('witness_loss','trust','recoverable',None,'counterexample'),('capacity_safe','capacity','safe',None,'pass'),('unlimited','capacity','exposure',None,'counterexample')]:specs.append((main,model,inv,temp,'step',expected))
if a.suite=='integrated':
 for main,model in [('multilateral','multilateral'),('integrated','integrated')]:specs.append((main,model,'safe',None,'step','pass'))
if a.suite=='variants':
 for main in ['a_open','b_hosted','d_shared','escrow','private_asset','shared_execution']:specs.append((main,'variants','safe',None,'step','pass'))
if a.suite=='liveness':specs=[('liveness','liveness','safe','progress','step','pass')]
results=[]
for main,model,inv,temp,step,expected in specs:
 id=f'tlc-{main}-{inv or temp}'
 if a.only and a.only not in id:continue
 cmd=[QUINT,'verify',f'verification/models/{model}.qnt','--main',main,'--backend','tlc','--step',step,'--verbosity','3','--tlc-config','verification/configs/tlc.json']
 if inv:cmd+=['--invariant',inv]
 if temp:cmd+=['--temporal',temp]
 results.append(execute(id,cmd,claim=[inv,temp],expected=expected,backend='tlc',seconds=180,config={'main':main,'step':step,'scope':a.suite}))
if a.suite=='bounds':
 for depth in [12,20]:results.append(qverify(f'apalache-core-{depth}','verification/models/dvp.qnt','baseline',depth=depth,seconds=180))
if a.suite=='inductive':
 results.append(execute('inductive-core',[QUINT,'verify','verification/models/induction.qnt','--main','induction','--inductive-invariant','Inductive','--invariant','desired','--verbosity','3'],claim='initiation, all-action preservation and implication',backend='apalache',seconds=180))
print(json.dumps({'checks':len(results),'met':sum(x['expectation_met'] for x in results),'failed':[x['id'] for x in results if not x['expectation_met']]}));sys.exit(0 if results and all(x['expectation_met'] for x in results) else 1)

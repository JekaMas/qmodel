from evidence import *
import argparse
p=argparse.ArgumentParser();p.add_argument('suite',choices=['privacy','timing','trust','variants','comparisons','multilateral']);p.add_argument('--mode',choices=['simulate','tlc'],default='simulate');a=p.parse_args();rs=[]
checks={
'privacy':[('privacy_safe','safe','pass','step'),('witness_log','PNI','counterexample','pairedStep'),('timing_leak','PNI','counterexample','pairedStep'),('unsalted','PNI','counterexample','pairedStep'),('wrong_scope','PAccess','counterexample','step'),('privacy_safe','deliveryMeansUsability','counterexample','step')],
 'timing':[('bounded','safe','pass','step'),('bounded','sufficientSlack','pass','step'),('slow_blocks','safe','pass','step'),('insufficient_margin','sufficientSlack','counterexample','step'),('local_timer','asyncSafety','counterexample','step'),('no_inclusion','boundedCompletion','counterexample','step'),('starvation','boundedCompletion','counterexample','step')],
 'trust':[('trust_safe','safe','pass','step'),('equivocation','canonicalAcceptance','counterexample','step'),('issuer_destruction','backed','counterexample','step'),('verifier_takeover','canonicalAcceptance','counterexample','step'),('witness_loss','recoverable','counterexample','step'),('retired_version','historical','counterexample','step'),('committee_refusal','recoverable','counterexample','step'),('insufficient_submitters','recoverable','counterexample','step')],
 'variants':[(m,'safe','pass','step') for m in ['a_open','b_hosted','d_shared','escrow','private_asset','shared_execution']],
 'comparisons':[('gpact','safe','pass','step'),('shared','sharedAtomic','pass','step'),('committee_honest','safe','pass','step'),('committee_compromised','backed','counterexample','step'),('htlc','noMixed','counterexample','step'),('htlc_halt','noMixed','counterexample','step')],
 'multilateral':[('multilateral','safe','pass','step')]}
files={'variants':'variants','comparisons':'mechanisms','multilateral':'multilateral','privacy':'privacy','trust':'trust','timing':'timing'}
for main,inv,expected,step in checks[a.suite]:
 path=f'verification/models/{files[a.suite]}.qnt';id=f'{a.mode}-{main}-{inv}'
 if a.mode=='simulate':rs.append(qrun(id,path,main,inv=inv,seed=29,steps=80,expected=expected,step=step,seconds=180))
 else:
  cmd=[QUINT,'verify',path,'--main',main,'--backend','tlc','--invariant',inv,'--step',step,'--tlc-config','verification/configs/tlc.json','--verbosity','3']
  rs.append(execute(id,cmd,claim=inv,backend='tlc',expected=expected,seconds=180,config={'main':main,'step':step,'regime':a.suite}))
print(json.dumps({'checks':len(rs),'met':sum(r['expectation_met'] for r in rs),'failed':[r['id'] for r in rs if not r['expectation_met']]}));sys.exit(0 if all(r['expectation_met'] for r in rs) else 1)

from evidence import *
import argparse
p=argparse.ArgumentParser();p.add_argument('suite',choices=['controls','liveness','recovery','new-trust','scenarios','htlc','late','authentication']);a=p.parse_args();rs=[]
def tlc(id,path,main,inv=None,temp=None,expected='pass',step='step',init='init',seconds=180):
 cmd=[QUINT,'verify',path,'--main',main,'--backend','tlc','--init',init,'--step',step,'--tlc-config','verification/configs/tlc.json','--verbosity','3']
 if inv:cmd+=['--invariant',inv]
 if temp:cmd+=['--temporal',temp]
 rs.append(execute(id,cmd,claim=[inv,temp],expected=expected,backend='tlc',seconds=seconds,config={'main':main,'step':step,'init':init}))
if a.suite=='controls':
 tlc('overclaim-immediate','verification/models/dvp.qnt','baseline',inv='noLag',expected='counterexample')
 tlc('overclaim-permanent-halt','verification/models/failure_controls.qnt','permanent_halt',temp='unconditional',expected='counterexample',step='stepControl',init='initControl')
 for main,inv,step in [('disclosure_key_compromise','PAccess','step'),('wrong_note','PAvailability','step')]:rs.append(qrun('negative-'+main,'verification/models/privacy.qnt',main,inv,expected='counterexample',step=step,seed=29))
if a.suite=='liveness':
 for main in ['live_open','live_b','live_d','live_escrow','live_two']:tlc('tlc-'+main,'verification/models/liveness_variants.qnt',main,inv='safe',temp='progress')
if a.suite=='recovery':tlc('tlc-eventual-recovery','verification/models/recovery.qnt','recovery',inv='safe',temp='recoveryProgress',step='recoveryStep')
if a.suite=='new-trust':
 for main,inv,expected in [('trust_safe','safe','pass'),('retired_version','historical','counterexample'),('committee_refusal','recoverable','counterexample'),('insufficient_submitters','recoverable','counterexample'),('witness_loss','recoverable','counterexample')]:tlc('trust-v2-'+main,'verification/models/trust.qnt',main,inv=inv,expected=expected)
if a.suite=='scenarios':
 for path,main in [('dvp_test','dvp_test'),('bindings_test','bindings_test'),('variants_test','open_test'),('variants_test','contention_test'),('variants_test','privacy_test'),('variants_test','multilateral_test'),('mechanisms_test','htlc_test'),('mechanisms_test','gpact_test'),('mechanisms_test','shared_test'),('variants_test','b_path_test'),('variants_test','d_path_test')]:
  rs.append(execute('scenario-'+main,[QUINT,'test',f'verification/tests/{path}.qnt','--main',main,'--match','.*Test','--backend','typescript','--seed','17'],claim=f'exact named {main} deterministic witnesses/rejections'))
if a.suite=='htlc':
 tlc('htlc-bounded-margins','verification/models/mechanisms.qnt','htlc',inv='noMixed',temp='boundedHtlc',step='boundedStep')
 tlc('htlc-permanent-halt','verification/models/failure_controls.qnt','htlc_permanent_halt',temp='unconditional',expected='counterexample',step='stepControl',init='initControl')
if a.suite=='authentication':
 for main in ['direct','zk_consensus','execution','direct_bad_execution','zk_bad_execution','execution_rejects_invalid','execution_rejects_history']:
  tlc('auth-'+main,'verification/models/authentication.qnt',main,inv='safe',expected='counterexample' if main in ['direct_bad_execution','zk_bad_execution'] else 'pass')
if a.suite=='late':
 tlc('late-hold-relative-bound','verification/models/late_resolution.qnt','late_resolution',inv='safe',temp='resolution')
 tlc('queue-capacity-progress','verification/models/capacity.qnt','capacity_safe',inv='safe',temp='progress')
print(json.dumps({'checks':len(rs),'met':sum(x['expectation_met'] for x in rs),'failed':[x['id'] for x in rs if not x['expectation_met']]}));sys.exit(0 if rs and all(x['expectation_met'] for x in rs) else 1)

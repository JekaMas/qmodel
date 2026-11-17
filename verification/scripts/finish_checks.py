from evidence import *
rs=[]
def tlc(id,path,main,inv=None,temp=None,expected='pass',step='step',init='init',seconds=180):
 cmd=[QUINT,'verify',path,'--main',main,'--backend','tlc','--init',init,'--step',step,'--tlc-config','verification/configs/tlc.json','--verbosity','3']
 if inv:cmd+=['--invariant',inv]
 if temp:cmd+=['--temporal',temp]
 r=execute(id,cmd,claim=[inv,temp],expected=expected,backend='tlc',seconds=seconds,config={'main':main,'step':step,'init':init});rs.append(r)
# Exact action guard changed to admit authentic historical certification after disposition.
rs.append(execute('final-algebraic-induction',[QUINT,'verify','verification/models/induction.qnt','--main','induction','--inductive-invariant','Inductive','--invariant','desired','--verbosity','3'],claim='initiation, all-action preservation and implication for mapped algebraic core',backend='apalache',seconds=90))
for main in ['direct','zk_consensus','execution','direct_bad_execution','zk_bad_execution','execution_rejects_invalid','execution_rejects_history']:
 tlc('auth-'+main,'verification/models/authentication.qnt',main,inv='safe',expected='counterexample' if main in ['direct_bad_execution','zk_bad_execution'] else 'pass')
tlc('late-hold-relative-bound','verification/models/late_resolution.qnt','late_resolution',inv='safe',temp='resolution')
tlc('queue-capacity-progress','verification/models/capacity.qnt','capacity_safe',inv='safe',temp='progress')
tlc('htlc-bounded-margins','verification/models/mechanisms.qnt','htlc',inv='noMixed',temp='boundedHtlc',step='boundedStep')
tlc('htlc-permanent-halt','verification/models/failure_controls.qnt','htlc_permanent_halt',temp='unconditional',expected='counterexample',step='stepControl',init='initControl')
for main in ['live_open','live_b','live_d','live_escrow','live_two']:
 tlc('tlc-'+main,'verification/models/liveness_variants.qnt',main,inv='safe',temp='progress')
tlc('tlc-eventual-recovery','verification/models/recovery.qnt','recovery',inv='safe',temp='recoveryProgress',step='recoveryStep')
tlc('post-stabilization','verification/models/stabilization.qnt','stabilization',inv='safe',temp='completion')
tlc('unbounded-prefix-no-fixed-bound','verification/models/stabilization.qnt','stabilization',inv='noGlobalMiss',expected='counterexample')
for main,expected in [('audit_safe','pass'),('omitted_record','counterexample')]:tlc('audit-'+main,'verification/models/audit_scope.qnt',main,inv='safe',expected=expected)
for main in ['b_hosted','d_shared','shared_execution']:
 tlc('contract-'+main,'verification/models/variants.qnt',main,inv='CDecision')
print(json.dumps({'checks':len(rs),'met':sum(x['expectation_met'] for x in rs),'failed':[x['id'] for x in rs if not x['expectation_met']]}));sys.exit(0 if all(x['expectation_met'] for x in rs) else 1)

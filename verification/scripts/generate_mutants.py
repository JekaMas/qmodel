from pathlib import Path
# Each schedule is a concrete asynchronous execution, not a hand-mutated state.
sign=['sign(1,0)','sign(1,1)'];holds=sign+['openA(1)','prepareB(1)'];proof=holds+['finalize(1,2)','capture(1,2)','prove(1,2)','deliver(1,2)'];commit=proof+['commit(1)'];outcome=commit+['finalize(1,3)','capture(1,3)','prove(1,3)','deliver(1,3)','learn(1,2,1)'];settled=outcome+['applyB(1)']
mutants=[('expiry',1,1,'S08',proof+['bTick','bTick','unsafeRefund(1)','commit(1)']),('binding',2,2,'S10',sign+['sign(2,0)','sign(2,1)','prepareB(1)','openA(2)','finalize(1,2)','capture(1,2)','prove(1,2)','deliver(1,2)','commit(2)']),('replay',3,1,'S05',settled+['applyB(1)']),('reopen',4,1,'S02',sign+['openA(1)','tick','tick','abort(1)','refund(1,0)','openA(1)']),('non_atomic',5,1,'S08',commit),('relayer_assertion',6,1,'S10',holds+['inject(1,2,0)','commit(1)']),('stale_refund',7,1,'S09',commit+['crash(3)','unsafeRefund(1)']),('pruned_tombstone',8,1,'S02',commit+['forgetTerminal(1)'])]
s=[]
for name,m,n,inv,steps in mutants:
 extra='  var bClock:int\n' if name=='expiry' else ''
 binit=",bClock'=0" if name=='expiry' else ''
 bstep=",bClock'=if("+' or '.join('pc=='+str(i) for i,x in enumerate(steps) if x=='bTick')+") bClock+1 else bClock" if name=='expiry' else ''
 branches=[]
 for i,a in enumerate(steps):
  op='idle' if a=='bTick' else ('all {bClock>=D,unsafeRefund(1)}' if name=='expiry' and a=='unsafeRefund(1)' else a)
  branches.append(f'    all {{pc=={i},{op}}}')
 s.append(f'module {name} {{\n  import dvp(N={n},HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT={m}).* from "../models/dvp"\n  var pc: int\n'+extra+f"  action initGuided = all {{init,pc'=0{binit}}}\n  action stepGuided = all {{pc<{len(steps)},pc'=pc+1{bstep},any {{\n"+',\n'.join(branches)+'\n  }}\n}\n')
Path('verification/mutants/guided.qnt').write_text('\n'.join(s))
import json
Path('verification/mutants/manifest.json').write_text(json.dumps([dict(id=name,mutation=m,trades=n,property=inv,schedule=steps,expected='counterexample',classification='protocol mutant') for name,m,n,inv,steps in mutants],indent=2)+'\n')

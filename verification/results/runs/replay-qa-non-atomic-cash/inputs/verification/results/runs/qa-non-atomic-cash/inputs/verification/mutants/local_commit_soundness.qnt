// Recording COMMIT on B without its colocated cash transfer is outside the
// B-placement contract even when both obligations are still backed.
module non_atomic_cash {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 action badCommit=all {canCommit(s,1),s'={...s,included:s.included.union(Set(fact(1,3))),
  trades:s.trades.set(1,{...s.trades.get(1),decision:2,oldTerminal:2,knownB:2})}}
 val localCommitAtomicity=Trades.forall(t=>s.trades.get(t).decision==2 implies s.trades.get(t).effectsB==1)
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
 all {pc==0,sign(1,0),pc'=pc+1},
 all {pc==1,sign(1,1),pc'=pc+1},
 all {pc==2,openA(1),pc'=pc+1},
 all {pc==3,prepareB(1),pc'=pc+1},
 all {pc==4,registerDecision(1),pc'=pc+1},
 all {pc==5,finalize(1,1),pc'=pc+1},
 all {pc==6,capture(1,1),pc'=pc+1},
 all {pc==7,prove(1,1),pc'=pc+1},
 all {pc==8,deliver(1,1),pc'=pc+1},
 all {pc==9,badCommit,pc'=pc+1}
 }
}

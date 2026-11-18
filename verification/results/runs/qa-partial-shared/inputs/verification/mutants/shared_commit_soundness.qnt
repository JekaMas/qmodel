// The existing non-atomic-security mutant on the actual shared execution path.
// Generic backing remains true while only cash is delivered on that one ledger.
module partial_shared_commit {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=5).* from "../models/dvp"
 val localCommitAtomicity=Trades.forall(t=>s.trades.get(t).decision==2 implies s.trades.get(t).effectsA==1 and s.trades.get(t).effectsB==1)
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=1},
  all {pc==1,sign(1,1),pc'=2},
  all {pc==2,openA(1),pc'=3},
  all {pc==3,prepareB(1),pc'=4},
  all {pc==4,commit(1),pc'=5}
 }
}

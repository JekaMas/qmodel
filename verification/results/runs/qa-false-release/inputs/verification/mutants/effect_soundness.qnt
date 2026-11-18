// A faulty release handler emits a correct-looking receipt without freeing the
// cash hold. The independent source-state assertion must detect the discrepancy.
module false_release {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 action falseRelease=all {s.trades.get(1).knownB==3,s.trades.get(1).holdB==1,
  s'={...s,economicReceipts:s.economicReceipts.union(Set(economicOutput(1,1,1))),
   trades:s.trades.set(1,{...s.trades.get(1),refundsB:1})}}

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val effectI=Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
 all {pc==0,sign(1,0),pc'=pc+1},
 all {pc==1,sign(1,1),pc'=pc+1},
 all {pc==2,openA(1),pc'=pc+1},
 all {pc==3,prepareB(1),pc'=pc+1},
 all {pc==4,tick,pc'=pc+1},
 all {pc==5,tick,pc'=pc+1},
 all {pc==6,abort(1),pc'=pc+1},
 all {pc==7,finalize(1,4),pc'=pc+1},
 all {pc==8,capture(1,4),pc'=pc+1},
 all {pc==9,prove(1,4),pc'=pc+1},
 all {pc==10,deliver(1,4),pc'=pc+1},
 all {pc==11,learn(1,3,1),pc'=pc+1},
 all {pc==12,falseRelease,pc'=pc+1}
 }
}

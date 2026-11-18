// Initiation/preservation/implication over the actual full State/adversarialStep.
// Finite instantiated configurations; no economic projection or input narrowing.
module effects_one {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

module effects_two {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

module effects_b {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

module effects_d {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

module effects_escrow {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

module effects_shared {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

module effects_private {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=true,MUTANT=0).* from "./dvp"

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
}

module effects_open {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

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
}

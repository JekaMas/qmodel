// A faulty release handler emits a correct-looking receipt without freeing the
// cash hold. The independent source-state assertion must detect the discrepancy.
module induction_false_release {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 import effect_trade_domain.* from "../models/effect_trade_domain"
 action falseRelease=all {s.trades.get(1).knownB==3,s.trades.get(1).holdB==1,
  s'={...s,economicReceipts:s.economicReceipts.union(Set(economicOutput(1,1,1))),
   trades:s.trades.set(1,{...s.trades.get(1),refundsB:1})}}

 var pc:int
 // Complete actual-State domain. Its closure is part of the induction.
 pure def domainFact(t:int,p:int,binding:int):Fact = {
    val f=fact(t,p)
    val bad=if(binding==0) {...f,d:{...f.d,trade:3-t}}
      else if(binding==1) {...f,d:{...f.d,nonce:99}}
      else if(binding==2) {...f,d:{...f.d,sellerB:99}}
      else if(binding==3) {...f,d:{...f.d,cash:4}}
      else if(binding==4) {...f,d:{...f.d,genesisB:999}}
      else if(binding==5) {...f,d:{...f.d,decisionDomain:99}}
      else if(binding==6) {...f,phase:6}
      else if(binding==7) {...f,checkpoint:99}
      else if(binding==8) {...f,program:99}
      else if(binding==9) {...f,d:{...f.d,assetB:99,holdB:99}}
      else {...f,root:999}
    bad
 }
 pure val AuthenticFacts=tuples(Trades,0.to(6)).map(v=>fact(v._1,v._2))
 pure val CandidateFacts=tuples(Trades,0.to(6),0.to(10)).map(v=>domainFact(v._1,v._2,v._3))
 pure val FactSpace=AuthenticFacts.union(CandidateFacts).union(AuthenticFacts.map(f=>{...f,program:0}))
 pure val AbortSpace=tuples(Trades,Set(0,1),0.to(3)).map(v=>{
  val d=desc(v._1)
  {d:d,leg:v._2,genesis:if(v._2==0) d.genesisA else d.genesisB,checkpoint:0,program:1,disposition:v._3}})
 pure val OutputSpace=tuples(Trades,Set(0,1),Set(0,1)).map(v=>economicOutput(v._1,v._2,v._3))
 pure val BookingSpace=tuples(Trades,Set(2,3)).map(v=>bookingOutput(v._1,v._2))
 pure val StateSpace=tuples(Trades.setOfMaps(TradeSpace),tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset(),Int,Int,Int,Int,Int,Int,Int,Trades.setOfMaps(Int),Trades.setOfMaps(Int),OutputSpace.powerset(),BookingSpace.powerset(),FactSpace.powerset(),FactSpace.powerset(),FactSpace.powerset(),FactSpace.powerset(),FactSpace.powerset(),FactSpace.powerset(),AbortSpace.powerset(),FactSpace.powerset(),0.to(4).powerset(),Int,Bool,Set(1,2).powerset(),tuples(Trades,Set(0,1)).powerset(),Set(0,1).powerset(),Trades.powerset(),0.to(10).powerset(),Bool,Bool,Bool,Bool,Bool).map(v=>{trades:v._1,signed:v._2,height:v._3,ownerA:v._4,ownerB:v._5,vaultA:v._6,vaultB:v._7,spentA:v._8,spentB:v._9,receivedA:v._10,receivedB:v._11,economicReceipts:v._12,financialRecords:v._13,included:v._14,finalized:v._15,captured:v._16,proofs:v._17,network:v._18,received:v._19,abortRecords:v._20,pruned:v._21,up:v._22,epoch:v._23,admitted:v._24,historical:v._25,eligible:v._26,frozen:v._27,note:v._28,rejects:v._29,transportCompromised:v._30,custody:v._31,upgrade:v._32,validator:v._33,decrypt:v._34})
 val FullTypeOK=s.in(StateSpace)
 // Record membership is field membership; map membership fixes keys and
 // range; powerset membership is subset. Row equivalence has native lemmas.
 pure def domainByFields(x:State):bool=and {x.trades.keys()==Trades and Trades.forall(t=>tradeDomainContains(x.trades.get(t))),x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),Int.contains(x.height),Int.contains(x.ownerA),Int.contains(x.ownerB),Int.contains(x.vaultA),Int.contains(x.vaultB),Int.contains(x.spentA),Int.contains(x.spentB),x.receivedA.keys()==Trades and Trades.forall(t=>Int.contains(x.receivedA.get(t))),x.receivedB.keys()==Trades and Trades.forall(t=>Int.contains(x.receivedB.get(t))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.pruned.subseteq(FactSpace),x.up.subseteq(0.to(4)),Int.contains(x.epoch),Bool.contains(x.admitted),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10)),Bool.contains(x.transportCompromised),Bool.contains(x.custody),Bool.contains(x.upgrade),Bool.contains(x.validator),Bool.contains(x.decrypt)}
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1})
 val ICore=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=FullTypeOK and ICore and pc.in(Int)
 val effectIExpanded=domainByFields(s) and ICore and pc.in(Int)
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
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

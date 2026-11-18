// Initiation/preservation/implication over the actual full State/adversarialStep.
// Finite instantiated configurations; no economic projection or input narrowing.
module effects_one {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_two {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_b {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsB==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_d {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies true})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_escrow {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_shared {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1 and z.effectsB==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_private {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=true,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

module effects_open {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"


 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 pure val TradeSpace=tuples(Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Bool,Bool,Bool,Bool,Int,Int,Bool,Bool).map(v=>{decision:v._1,oldTerminal:v._2,holdA:v._3,holdB:v._4,effectsA:v._5,effectsB:v._6,refundsA:v._7,refundsB:v._8,knownA:v._9,knownB:v._10,preparedA:v._11,preparedB:v._12,appliedEvidenceA:v._13,appliedEvidenceB:v._14,booked:v._15,report:v._16,stale:v._17,intent:v._18})
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
 val FullTypeOK=Trades.setOfMaps(TradeSpace).exists(v0=> tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().exists(v1=> Int.exists(v2=> Int.exists(v3=> Int.exists(v4=> Int.exists(v5=> Int.exists(v6=> Int.exists(v7=> Int.exists(v8=> Trades.setOfMaps(Int).exists(v9=> Trades.setOfMaps(Int).exists(v10=> OutputSpace.powerset().exists(v11=> BookingSpace.powerset().exists(v12=> FactSpace.powerset().exists(v13=> FactSpace.powerset().exists(v14=> FactSpace.powerset().exists(v15=> FactSpace.powerset().exists(v16=> FactSpace.powerset().exists(v17=> FactSpace.powerset().exists(v18=> AbortSpace.powerset().exists(v19=> FactSpace.powerset().exists(v20=> 0.to(4).powerset().exists(v21=> Int.exists(v22=> Bool.exists(v23=> Set(1,2).powerset().exists(v24=> tuples(Trades,Set(0,1)).powerset().exists(v25=> Set(0,1).powerset().exists(v26=> Trades.powerset().exists(v27=> 0.to(10).powerset().exists(v28=> Bool.exists(v29=> Bool.exists(v30=> Bool.exists(v31=> Bool.exists(v32=> Bool.exists(v33=> s=={trades:v0,signed:v1,height:v2,ownerA:v3,ownerB:v4,vaultA:v5,vaultB:v6,spentA:v7,spentB:v8,receivedA:v9,receivedB:v10,economicReceipts:v11,financialRecords:v12,included:v13,finalized:v14,captured:v15,proofs:v16,network:v17,received:v18,abortRecords:v19,pruned:v20,up:v21,epoch:v22,admitted:v23,historical:v24,eligible:v25,frozen:v26,note:v27,rejects:v28,transportCompromised:v29,custody:v30,upgrade:v31,validator:v32,decrypt:v33}))))))))))))))))))))))))))))))))))
 // END generated full-state induction domain

 // Independent source-state monitor: a receipt/counter is insufficient if the
 // actual hold was never delivered/released. No producer helper is used here.
 val localCommitAtomicity=Trades.forall(t=> {val z=s.trades.get(t);z.decision==2 implies z.effectsA==1})
 val effectI=FullTypeOK and localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
}

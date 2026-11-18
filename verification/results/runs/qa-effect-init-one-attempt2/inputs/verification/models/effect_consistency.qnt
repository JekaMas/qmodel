// Actual full-State induction; only native record-domain constructors are normalized.
// See native_induction.py and exact compiler/correspondence/native observations.
// Initiation/preservation/implication over the actual full State/adversarialStep.
// Finite instantiated configurations; no economic projection or input narrowing.
module effects_one {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"

 // BEGIN generated full-state induction domain
 // TypeOK must bind the whole record before its fields are read. See Quint's
 // checking-properties TypeOK rule. This is checked in all3proof obligations.
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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
 // Finite strengthened TypeOK candidate: real leg histories and cache states.
 // This does not restrict Next. Actual initiation and preservation must prove
 // these additional relations; a missing reachable row is a counterexample.
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
 pure val TradeSpace=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool).map(v=>{
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7
 }).filter(z=>z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision)))
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

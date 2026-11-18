// Genuine full-State initiation, preservation and implication in explicit0/1/0 calls.
// Same actual init/adversarialStep; auxiliary domain closure is proved, not assumed on Next.
module effects_one {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_two {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet t2_decision=Int.oneOf()
  nondet t2_oldTerminal=Int.oneOf()
  nondet t2_holdA=Int.oneOf()
  nondet t2_holdB=Int.oneOf()
  nondet t2_effectsA=Int.oneOf()
  nondet t2_effectsB=Int.oneOf()
  nondet t2_refundsA=Int.oneOf()
  nondet t2_refundsB=Int.oneOf()
  nondet t2_knownA=Int.oneOf()
  nondet t2_knownB=Int.oneOf()
  nondet t2_preparedA=Bool.oneOf()
  nondet t2_preparedB=Bool.oneOf()
  nondet t2_appliedEvidenceA=Bool.oneOf()
  nondet t2_appliedEvidenceB=Bool.oneOf()
  nondet t2_booked=Int.oneOf()
  nondet t2_report=Int.oneOf()
  nondet t2_stale=Bool.oneOf()
  nondet t2_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedA2=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet receivedB2=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent},2 -> {decision:t2_decision,oldTerminal:t2_oldTerminal,holdA:t2_holdA,holdB:t2_holdB,effectsA:t2_effectsA,effectsB:t2_effectsB,refundsA:t2_refundsA,refundsB:t2_refundsB,knownA:t2_knownA,knownB:t2_knownB,preparedA:t2_preparedA,preparedB:t2_preparedB,appliedEvidenceA:t2_appliedEvidenceA,appliedEvidenceB:t2_appliedEvidenceB,booked:t2_booked,report:t2_report,stale:t2_stale,intent:t2_intent}),receivedA:Map(1 -> receivedA1,2 -> receivedA2),receivedB:Map(1 -> receivedB1,2 -> receivedB2),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_b {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsB==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_d {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies true})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_escrow {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_shared {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1 and z.effectsB==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_private {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=true,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}
module effects_open {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
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
 pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,x.signed.subseteq(tuples(Trades.map(t=>desc(t)),Set(0,1))),x.economicReceipts.subseteq(OutputSpace),x.financialRecords.subseteq(BookingSpace),x.included.subseteq(FactSpace),x.finalized.subseteq(FactSpace),x.captured.subseteq(FactSpace),x.proofs.subseteq(FactSpace),x.network.subseteq(FactSpace),x.received.subseteq(FactSpace),x.pruned.subseteq(FactSpace),x.abortRecords.subseteq(AbortSpace),x.up.subseteq(0.to(4)),x.historical.subseteq(Set(1,2)),x.eligible.subseteq(tuples(Trades,Set(0,1))),x.frozen.subseteq(Set(0,1)),x.note.subseteq(Trades),x.rejects.subseteq(0.to(10))}
 pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
  nondet t1_decision=Int.oneOf()
  nondet t1_oldTerminal=Int.oneOf()
  nondet t1_holdA=Int.oneOf()
  nondet t1_holdB=Int.oneOf()
  nondet t1_effectsA=Int.oneOf()
  nondet t1_effectsB=Int.oneOf()
  nondet t1_refundsA=Int.oneOf()
  nondet t1_refundsB=Int.oneOf()
  nondet t1_knownA=Int.oneOf()
  nondet t1_knownB=Int.oneOf()
  nondet t1_preparedA=Bool.oneOf()
  nondet t1_preparedB=Bool.oneOf()
  nondet t1_appliedEvidenceA=Bool.oneOf()
  nondet t1_appliedEvidenceB=Bool.oneOf()
  nondet t1_booked=Int.oneOf()
  nondet t1_report=Int.oneOf()
  nondet t1_stale=Bool.oneOf()
  nondet t1_intent=Bool.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),signed:v_signed,economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,pruned:v_pruned,abortRecords:v_abortRecords,up:v_up,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,epoch:v_epoch,admitted:v_admitted,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {effectInvariant(candidate),s'=candidate}
 }
 // END generated full-state induction obligations
}

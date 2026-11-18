// Actual full State/init/adversarialStep. Equivalent field-form induction
// avoids expensive range re-enumeration; native row-bijection lemmas are required.
module effects_one {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_two {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedA2=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet receivedB2=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent},2 -> {decision:t2_decision,oldTerminal:t2_oldTerminal,holdA:t2_holdA,holdB:t2_holdB,effectsA:t2_effectsA,effectsB:t2_effectsB,refundsA:t2_refundsA,refundsB:t2_refundsB,knownA:t2_knownA,knownB:t2_knownB,preparedA:t2_preparedA,preparedB:t2_preparedB,appliedEvidenceA:t2_appliedEvidenceA,appliedEvidenceB:t2_appliedEvidenceB,booked:t2_booked,report:t2_report,stale:t2_stale,intent:t2_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1,2 -> receivedA2),receivedB:Map(1 -> receivedB1,2 -> receivedB2),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_b {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsB==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_d {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies true})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_escrow {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_shared {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1 and z.effectsB==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_private {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=true,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}
module effects_open {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 import effect_trade_domain.* from "./effect_trade_domain"
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
 pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies z.effectsA==1})
 val localCommitAtomicity=localAtomicAt(s)
 pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val ICore=physicalInvariant(s)
 val effectI=FullTypeOK and ICore
 val effectIExpanded=domainByFields(s) and ICore
 // Equivalent initializers, not a state/transition filter. The domain
 // encoder/decoder lemmas establish that every field-form state is included.
 val inductionInit=effectI and effectIExpanded
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 // Complete arbitrary invariant-state initializer; not protocol Next.
 action arbitraryInductive={
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
  nondet v_signed=tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset().oneOf()
  nondet v_height=Int.oneOf()
  nondet v_ownerA=Int.oneOf()
  nondet v_ownerB=Int.oneOf()
  nondet v_vaultA=Int.oneOf()
  nondet v_vaultB=Int.oneOf()
  nondet v_spentA=Int.oneOf()
  nondet v_spentB=Int.oneOf()
  nondet receivedA1=Int.oneOf()
  nondet receivedB1=Int.oneOf()
  nondet v_economicReceipts=OutputSpace.powerset().oneOf()
  nondet v_financialRecords=BookingSpace.powerset().oneOf()
  nondet v_included=FactSpace.powerset().oneOf()
  nondet v_finalized=FactSpace.powerset().oneOf()
  nondet v_captured=FactSpace.powerset().oneOf()
  nondet v_proofs=FactSpace.powerset().oneOf()
  nondet v_network=FactSpace.powerset().oneOf()
  nondet v_received=FactSpace.powerset().oneOf()
  nondet v_abortRecords=AbortSpace.powerset().oneOf()
  nondet v_pruned=FactSpace.powerset().oneOf()
  nondet v_up=0.to(4).powerset().oneOf()
  nondet v_epoch=Int.oneOf()
  nondet v_admitted=Bool.oneOf()
  nondet v_historical=Set(1,2).powerset().oneOf()
  nondet v_eligible=tuples(Trades,Set(0,1)).powerset().oneOf()
  nondet v_frozen=Set(0,1).powerset().oneOf()
  nondet v_note=Trades.powerset().oneOf()
  nondet v_rejects=0.to(10).powerset().oneOf()
  nondet v_transportCompromised=Bool.oneOf()
  nondet v_custody=Bool.oneOf()
  nondet v_upgrade=Bool.oneOf()
  nondet v_validator=Bool.oneOf()
  nondet v_decrypt=Bool.oneOf()
  val candidate={trades:Map(1 -> {decision:t1_decision,oldTerminal:t1_oldTerminal,holdA:t1_holdA,holdB:t1_holdB,effectsA:t1_effectsA,effectsB:t1_effectsB,refundsA:t1_refundsA,refundsB:t1_refundsB,knownA:t1_knownA,knownB:t1_knownB,preparedA:t1_preparedA,preparedB:t1_preparedB,appliedEvidenceA:t1_appliedEvidenceA,appliedEvidenceB:t1_appliedEvidenceB,booked:t1_booked,report:t1_report,stale:t1_stale,intent:t1_intent}),signed:v_signed,height:v_height,ownerA:v_ownerA,ownerB:v_ownerB,vaultA:v_vaultA,vaultB:v_vaultB,spentA:v_spentA,spentB:v_spentB,receivedA:Map(1 -> receivedA1),receivedB:Map(1 -> receivedB1),economicReceipts:v_economicReceipts,financialRecords:v_financialRecords,included:v_included,finalized:v_finalized,captured:v_captured,proofs:v_proofs,network:v_network,received:v_received,abortRecords:v_abortRecords,pruned:v_pruned,up:v_up,epoch:v_epoch,admitted:v_admitted,historical:v_historical,eligible:v_eligible,frozen:v_frozen,note:v_note,rejects:v_rejects,transportCompromised:v_transportCompromised,custody:v_custody,upgrade:v_upgrade,validator:v_validator,decrypt:v_decrypt}
  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate}
 }
}

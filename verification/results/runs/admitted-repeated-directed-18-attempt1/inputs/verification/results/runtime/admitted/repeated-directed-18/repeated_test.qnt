// Staged beside the source-bound funded specialization by repeated_checks.py.
module repeated_test {
  import dvp(N=7,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))

  // The operational dispatcher includes the loss/prune edges omitted from the
  // normal and general adversarial entries. All actions originate in dvp.
  action operational = any {
    adversarialStep,
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); any {lose(t,p),prune(t,p)}
  }

  def pending(t:int):bool = {
    val z=s.trades.get(t)
    z.decision==1 and z.holdA==1 and z.holdB==1 and z.effectsA==0 and z.effectsB==0
  }

  // Use independent literal quantities and per-trade recipient/account IDs.
  def committedTrade(t:int):bool = {
    val z=s.trades.get(t)
    and {
      z.decision==2,z.effectsA==1,z.effectsB==1,z.refundsA==0,z.refundsB==0,
      s.receivedA.get(t)==2,s.receivedB.get(t)==3,evidenceBackedBooking(s,desc(t)),
      s.economicReceipts.filter(r=>r.trade==t)==Set(
        {trade:t,leg:0,kind:0,chain:10,genesis:110,asset:30,account:t,quantity:2},
        {trade:t,leg:1,kind:0,chain:20,genesis:120,asset:40,account:t,quantity:3})
    }
  }

  def releasedTrade(t:int):bool = {
    val z=s.trades.get(t)
    and {
      z.decision==3,z.holdA==3,z.holdB==3,z.refundsA==1,z.refundsB==1,
      z.effectsA==0,z.effectsB==0,s.receivedA.get(t)==0,s.receivedB.get(t)==0,
      evidenceBackedBooking(s,desc(t)),
      s.economicReceipts.filter(r=>r.trade==t)==Set(
        {trade:t,leg:0,kind:1,chain:10,genesis:110,asset:30,account:0,quantity:2},
        {trade:t,leg:1,kind:1,chain:20,genesis:120,asset:40,account:0,quantity:3})
    }
  }
  action requestExactOpen(t:int):bool = requestOpen(t,desc(t))
  action requestExactCash(t:int):bool = requestCash(t,desc(t))
  action executeEvent(e:(int,int,int,int)):bool = any {
    all {e._1==0, sign(e._2,e._3)},
    all {e._1==1, openA(e._2)},
    all {e._1==2, prepareB(e._2)},
    all {e._1==3, tick},
    all {e._1==4, finalize(e._2,e._3)},
    all {e._1==5, capture(e._2,e._3)},
    all {e._1==6, prove(e._2,e._3)},
    all {e._1==7, proveUnadmitted(e._2,e._3)},
    all {e._1==8, deliverUnadmitted(e._2,e._3)},
    all {e._1==9, lose(e._2,e._3)},
    all {e._1==10, resend(e._2,e._3)},
    all {e._1==11, deliver(e._2,e._3)},
    all {e._1==12, inject(e._2,e._3,e._4)},
    all {e._1==13, commit(e._2)},
    all {e._1==14, abort(e._2)},
    all {e._1==15, learn(e._2,e._3,e._4)},
    all {e._1==16, applyB(e._2)},
    all {e._1==17, refund(e._2,e._3)},
    all {e._1==18, spend(e._2)},
    all {e._1==19, crash(e._2)},
    all {e._1==20, recover(e._2)},
    all {e._1==21, observe(e._2,e._3)},
    all {e._1==22, reconcile(e._2)},
    all {e._1==23, captureAbortRecord(e._2,e._3)},
    all {e._1==24, recordAbort(e._2)},
    all {e._1==25, rotate},
    all {e._1==26, exitMember},
    all {e._1==27, revoke(e._2)},
    all {e._1==28, revokeLeg(e._2,e._3)},
    all {e._1==29, freeze(e._2)},
    all {e._1==30, unfreeze(e._2)},
    all {e._1==31, prune(e._2,e._3)},
    all {e._1==32, receiveNote(e._2)},
    all {e._1==33, compromiseTransport},
    all {e._1==34, idle},
    all {e._1==35, requestExactOpen(e._2)},
    all {e._1==36, requestExactCash(e._2)},
  }
  action replayEvents(events:List[(int,int,int,int)]):bool = events.length().reps(i=>{
    val decisions = Trades.filter(t=>s.trades.get(t).decision>=2).map(t=>(t,s.trades.get(t).decision))
    val outputs = s.economicReceipts
    val rows = s.financialRecords
    executeEvent(events.nth(i)).expect(sequenceSafe and
      decisions.forall(d=>s.trades.get(d._1).decision==d._2) and
      outputs.subseteq(s.economicReceipts) and rows.subseteq(s.financialRecords))
  })

  pure val PARALLEL = Set(4,5,6)
  val durablePrefix = Set(1,2,3).forall(t=>s.financialRecords.contains({d:desc(t),outcome:if(t==2) 3 else 2}))
  val durablePrefixAtMost = s.financialRecords.contains({d:desc(1),outcome:2}) and
    s.financialRecords.forall(r=>Set(1,2,3).contains(r.d.trade))
  val completed = Set(1,3,4,5,6).forall(t=>committedTrade(t)) and releasedTrade(2) and
    s.ownerA==0 and s.ownerB==0 and s.economicReceipts.size()==12 and s.financialRecords.size()==6
  run first = init.expect(sequenceSafe)
    .then(replayEvents(List((0,1,0,0),(0,1,1,0),(1,1,0,0),(2,1,0,0),(4,1,2,0),(5,1,2,0),(6,1,2,0),(11,1,2,0),(13,1,0,0),(4,1,3,0),(5,1,3,0),(6,1,3,0),(11,1,3,0),(15,1,2,1),(16,1,0,0),(4,1,5,0),(5,1,5,0),(6,1,5,0),(11,1,5,0),(21,1,0,0),(4,1,6,0),(5,1,6,0),(6,1,6,0),(11,1,6,0),(21,1,1,0),(22,1,0,0))))
  run expired = first
    .then(replayEvents(List((0,2,0,0),(0,2,1,0),(1,2,0,0),(2,2,0,0),(3,0,0,0),(3,0,0,0),(3,0,0,0),(14,2,0,0))))
  run released = expired
    .then(replayEvents(List((4,2,4,0),(5,2,4,0),(6,2,4,0),(11,2,4,0),(15,2,3,1),(17,2,0,0),(17,2,1,0),(23,2,0,0),(23,2,1,0),(24,2,0,0))))
  run sequential = released
    .then(replayEvents(List((0,3,0,0),(0,3,1,0),(1,3,0,0),(2,3,0,0),(4,3,2,0),(5,3,2,0),(6,3,2,0),(11,3,2,0),(13,3,0,0),(4,3,3,0),(5,3,3,0),(6,3,3,0),(11,3,3,0),(15,3,2,1),(16,3,0,0),(4,3,5,0),(5,3,5,0),(6,3,5,0),(11,3,5,0),(21,3,0,0),(4,3,6,0),(5,3,6,0),(6,3,6,0),(11,3,6,0),(21,3,1,0),(22,3,0,0)))).expect(committedTrade(1) and releasedTrade(2) and committedTrade(3))
  run parallelHeld = sequential
    .then(replayEvents(List((0,4,0,0),(0,4,1,0),(1,4,0,0),(2,4,0,0),(0,5,0,0),(0,5,1,0),(1,5,0,0),(2,5,0,0),(0,6,0,0),(0,6,1,0),(1,6,0,0),(2,6,0,0)))).expect(PARALLEL.forall(t=>pending(t)) and reservedA(s)==6 and reservedB(s)==9 and durablePrefix)
  run ready = parallelHeld
    .then(replayEvents(List((4,4,2,0),(5,4,2,0),(6,4,2,0),(11,4,2,0),(4,5,2,0),(5,5,2,0),(6,5,2,0),(11,5,2,0),(4,6,2,0),(5,6,2,0),(6,6,2,0),(11,6,2,0))))
  run committedA = ready
    .then(replayEvents(List((13,4,0,0))))
  run waitingCash = committedA
    .then(replayEvents(List((4,4,3,0),(5,4,3,0),(6,4,3,0),(11,4,3,0),(15,4,2,1))))
  run cashDelivered = waitingCash
    .then(replayEvents(List((16,4,0,0))))
  run signedSeven = parallelHeld
    .then(replayEvents(List((0,7,0,0),(0,7,1,0))))
  run lateOutcome = ready
    .then(replayEvents(List((13,4,0,0),(4,4,3,0),(5,4,3,0),(6,4,3,0),(9,4,3,0))))
  run Phase5ProofPipelineRecoveryTest = committedA
    .then(replayEvents(List((19,0,0,0),(20,0,0,0),(4,4,5,0),(19,3,0,0),(20,3,0,0),(5,4,5,0),(31,4,5,0),(19,3,0,0),(20,3,0,0),(6,4,5,0),(9,4,5,0),(19,4,0,0),(20,4,0,0),(10,4,5,0),(19,4,0,0),(20,4,0,0),(11,4,5,0),(11,4,5,0)))).expect(s.captured.contains(fact(4,5)) and s.pruned.contains(fact(4,5)) and has(s,4,5) and durablePrefixAtMost)
  run Phase6FinalizeOutageTest = cashDelivered
    .then(replayEvents(List((19,1,0,0)))).expect(s.included.contains(fact(4,6)) and not(s.up.contains(1))).then(finalize(4,6).fail())
  run Phase6CaptureOutageTest = cashDelivered
    .then(replayEvents(List((4,4,6,0),(19,3,0,0)))).expect(s.finalized.contains(fact(4,6)) and not(s.up.contains(3))).then(capture(4,6).fail())
  run Phase6ProveOutageTest = cashDelivered
    .then(replayEvents(List((4,4,6,0),(5,4,6,0),(19,3,0,0)))).expect(s.captured.contains(fact(4,6)) and not(s.up.contains(3))).then(prove(4,6).fail())
  run Phase6DeliverOutageTest = cashDelivered
    .then(replayEvents(List((4,4,6,0),(5,4,6,0),(6,4,6,0),(19,4,0,0)))).expect(s.network.contains(fact(4,6)) and not(s.up.contains(4))).then(deliver(4,6).fail())
  run Phase6ResendOutageTest = cashDelivered
    .then(replayEvents(List((4,4,6,0),(5,4,6,0),(6,4,6,0),(9,4,6,0),(19,4,0,0)))).expect(s.proofs.contains(fact(4,6)) and not(s.network.contains(fact(4,6))) and not(s.up.contains(4))).then(resend(4,6).fail())
  run Phase6ProofPipelineRecoveryTest = cashDelivered
    .then(replayEvents(List((19,1,0,0),(20,1,0,0),(4,4,6,0),(19,3,0,0),(20,3,0,0),(5,4,6,0),(31,4,6,0),(19,3,0,0),(20,3,0,0),(6,4,6,0),(9,4,6,0),(19,4,0,0),(20,4,0,0),(10,4,6,0),(19,4,0,0),(20,4,0,0),(11,4,6,0),(11,4,6,0)))).expect(s.captured.contains(fact(4,6)) and s.pruned.contains(fact(4,6)) and has(s,4,6) and durablePrefixAtMost)
}

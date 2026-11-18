module placement_products {
  import dvp(N=3,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))
  action placementStep = any {adversarialStep,
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); any {lose(t,p),prune(t,p)}}
  action requestExactOpen(t:int):bool = requestOpen(t,desc(t))
  action requestExactCash(t:int):bool = requestCash(t,desc(t))
  action executeEvent(e:(int,int,int,int)):bool = any {
    all {e._1==37, registerDecision(e._2)},
    all {e._1==38, applyA(e._2)},
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
    val pre = s
    executeEvent(events.nth(i)).expect(sequenceSafe and legitimate(pre,s,events.nth(i)) and
      decisions.forall(d=>s.trades.get(d._1).decision==d._2) and
      outputs.subseteq(s.economicReceipts) and rows.subseteq(s.financialRecords))
  })
  run holds=init
    .then(replayEvents(List((0,1,0,0),(0,1,1,0),(1,1,0,0),(2,1,0,0),(0,2,0,0),(0,2,1,0),(1,2,0,0),(2,2,0,0),(0,3,0,0),(0,3,1,0),(1,3,0,0),(2,3,0,0)))).then(replayEvents(List((37,1,0,0)))).then(replayEvents(List((37,2,0,0)))).then(replayEvents(List((37,3,0,0)))).expect(sequenceSafe and Trades.forall(t=>s.trades.get(t).holdA==1 and s.trades.get(t).holdB==1))
  run ready=holds
    .then(replayEvents(List((4,1,1,0),(5,1,1,0),(6,1,1,0),(11,1,1,0))))
  run disposition=ready
    .then(replayEvents(List((13,1,0,0),(3,0,0,0),(3,0,0,0),(3,0,0,0),(14,2,0,0))))
  run firstOutcome=disposition
    .then(replayEvents(List((19,3,0,0),(19,4,0,0),(25,0,0,0),(26,0,0,0),(20,3,0,0),(20,4,0,0),(4,1,3,0),(5,1,3,0),(6,1,3,0),(9,1,3,0),(10,1,3,0),(11,1,3,0),(11,1,3,0))))
  run AbsentRemoteReleaseCannotBeGuessedTest=disposition
    .then(replayEvents(List((4,2,4,0),(5,2,4,0),(6,2,4,0),(11,2,4,0)))).then(refund(2,0).fail())
  run firstApplied=firstOutcome.then(learn(1,2,0)).then(replayEvents(List((38,1,0,0)))).expect(sequenceSafe)
  run OneLegEvidenceCannotBookTest=firstApplied
    .then(replayEvents(List((4,1,5,0),(5,1,5,0),(6,1,5,0),(11,1,5,0),(21,1,0,0)))).then(reconcile(1).fail())
  run FundedMixedRecoveryTest=firstApplied
    .then(replayEvents(List((4,1,5,0),(5,1,5,0),(6,1,5,0),(11,1,5,0),(21,1,0,0),(4,1,6,0),(5,1,6,0),(6,1,6,0),(11,1,6,0),(21,1,1,0),(22,1,0,0),(4,2,4,0),(5,2,4,0),(6,2,4,0),(11,2,4,0),(15,2,3,0),(15,2,3,1),(17,2,0,0),(17,2,1,0),(23,2,0,0),(23,2,1,0),(24,2,0,0),(4,3,1,0),(5,3,1,0),(6,3,1,0),(11,3,1,0),(13,3,0,0),(4,3,3,0),(5,3,3,0),(6,3,3,0),(11,3,3,0)))).then(learn(3,2,0)).then(replayEvents(List((38,3,0,0)))).expect(sequenceSafe)
    .then(replayEvents(List((4,3,5,0),(5,3,5,0),(6,3,5,0),(11,3,5,0),(21,3,0,0),(4,3,6,0),(5,3,6,0),(6,3,6,0),(11,3,6,0),(21,3,1,0),(22,3,0,0)))).expect(sequenceSafe and s.financialRecords.size()==3 and Trades.forall(t=>evidenceBackedBooking(s,desc(t))) and s.trades.get(2).refundsA==1 and s.trades.get(2).refundsB==1 and s.ownerA==2 and s.ownerB==3)
  run DecisionOwnerUnavailableTest=ready.then(crash(1)).expect(s.trades.get(1).decision==1).then(commit(1).fail())
  pure def classOf(e:(int,int,int,int)):int =
    if(e._1==1) 0 else
    if(e._1==2) 1 else
    if(e._1==11) (if(e._3==1) 3 else if(e._3==2) 4 else -1) else
    if(e._1==13) 5 else
    if(e._1==14) 6 else
    if(e._1==15) (if(e._4==0) 7 else 8) else
    if(e._1==17) (if(e._3==0) 11 else 12) else
    if(e._1==18) (if(e._2==0) 13 else 14) else
    if(e._1==16) 10 else
    if(e._1==22) 15 else
    if(e._1==24) 16 else
    if(e._1==37) 2 else
    if(e._1==38) 9 else
    -1

  type Row={decision:int,holdA:int,holdB:int,paidA:int,paidB:int,refundA:int,refundB:int,knownA:int,knownB:int,proofA:int,proofB:int,booking:int}
  pure def observeRow(x:State,t:int):Row = {
    val z=x.trades.get(t)
    {decision:z.decision,holdA:z.holdA,holdB:z.holdB,paidA:z.effectsA,paidB:z.effectsB,
      refundA:z.refundsA,refundB:z.refundsB,knownA:z.knownA,knownB:z.knownB,
      proofA:if(receivedFact(x,desc(t),1)) 1 else 0,proofB:if(receivedFact(x,desc(t),2)) 1 else 0,
      booking:if(x.financialRecords.contains({d:desc(t),outcome:2})) 2
              else if(x.financialRecords.contains({d:desc(t),outcome:3})) 3 else 0}
  }
  pure def legitimate(before:State,after:State,e:(int,int,int,int)):bool = {
    val k=classOf(e)
    val spending=e._1==18
    val t=if(k== -1 or spending) 1 else e._2
    val old=observeRow(before,t)
    val localA=HOST==0 or HOST==3
    val localB=HOST==1 or HOST==3
    val amountA=if(spending) 1 else desc(t).security
    val amountB=if(spending) 1 else desc(t).cash
    val ownA=before.ownerA
    val ownB=before.ownerB
    val reservedA=Trades.fold(0,(n,u)=>n+(if(before.trades.get(u).holdA==1) desc(u).security else 0))
    val reservedB=Trades.fold(0,(n,u)=>n+(if(before.trades.get(u).holdB==1) desc(u).cash else 0))
    if(k==0) {
      val expected={...old,holdA:1,decision:(if(localA) 1 else old.decision)}
      and {
        ((old.holdA == 0) and ((ownA - reservedA) >= amountA) and (if(localA) (old.decision == 0) else (old.knownA == 0))),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==1) {
      val expected={...old,holdB:1}
      and {
        ((old.holdB == 0) and (old.knownB == 0) and ((ownB - reservedB) >= amountB)),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==2) {
      val expected={...old,decision:1}
      and {
        (not(localA) and (old.decision == 0)),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==3) {
      val expected={...old,proofA:1}
      and {
        (old.holdA > 0),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==4) {
      val expected={...old,proofB:1}
      and {
        (old.holdB > 0),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==5) {
      val expected={...old,decision:2,knownA:(if(localA) 2 else old.knownA),knownB:(if(localB) 2 else old.knownB),holdA:(if(localA) 2 else old.holdA),holdB:(if(localB) 2 else old.holdB),paidA:(if(localA) 1 else old.paidA),paidB:(if(localB) 1 else old.paidB)}
      and {
        ((old.decision == 1) and (if(localA) (old.holdA == 1) else (old.proofA == 1)) and (if(localB) (old.holdB == 1) else (old.proofB == 1))),
        after.ownerA==ownA-(if(localA) amountA else 0)-0,
        after.ownerB==ownB-(if(localB) amountB else 0)-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==6) {
      val expected={...old,decision:3,knownA:(if(localA) 3 else old.knownA),knownB:(if(localB) 3 else old.knownB)}
      and {
        (old.decision < 2),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==7) {
      val expected={...old,knownA:old.decision}
      and {
        (old.decision >= 2),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==8) {
      val expected={...old,knownB:old.decision}
      and {
        (old.decision >= 2),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==9) {
      val expected={...old,holdA:2,paidA:(old.paidA + 1)}
      and {
        ((old.knownA == 2) and (old.holdA == 1)),
        after.ownerA==ownA-amountA-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==10) {
      val expected={...old,holdB:2,paidB:(old.paidB + 1)}
      and {
        ((old.knownB == 2) and (old.holdB == 1)),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-amountB-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==11) {
      val expected={...old,holdA:3,refundA:(old.refundA + 1)}
      and {
        ((old.knownA == 3) and (old.holdA == 1)),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==12) {
      val expected={...old,holdB:3,refundB:(old.refundB + 1)}
      and {
        ((old.knownB == 3) and (old.holdB == 1)),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==13) {
      val expected=old
      and {
        ((ownA - reservedA) >= amountA),
        after.ownerA==ownA-0-amountA,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+amountA,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==14) {
      val expected=old
      and {
        ((ownB - reservedB) >= amountB),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-amountB,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+amountB,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==15) {
      val expected={...old,booking:2}
      and {
        ((old.decision == 2) and (old.holdA == 2) and (old.holdB == 2)),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else if(k==16) {
      val expected={...old,booking:3}
      and {
        ((old.decision == 3) and (old.knownA == 3) and (old.knownB == 3) and not((old.holdA == 1)) and not((old.holdB == 1))),
        after.ownerA==ownA-0-0,
        after.ownerB==ownB-0-0,
        after.spentA==before.spentA+0,
        after.spentB==before.spentB+0,
        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else observeRow(before,u)))
      }
    }
    else Trades.forall(u=>observeRow(after,u)==observeRow(before,u)) and after.ownerA==ownA and after.ownerB==ownB
  }
}

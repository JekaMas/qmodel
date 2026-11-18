module funded_blocks {
  import dvp_blocks(COUNT=3,FAULT=0).* from "./dvp_blocks"
  import guarantee_oracles.* from "./guarantee_oracles"
  var pc:int
  action blockInit=all {start,pc'=0}
  action blockWork(leg:int,kind:int):bool=any {
    openBlock(leg,kind,Ids),sealBlock(leg),
    nondet t=Ids.oneOf(); executeTx(leg,t)
  }
  pure val signedPC=6
  pure val heldPC=8
  pure val donePC=8
  action work=any {
    all {pc==0,authorize(1,0),pc'=1},
    all {pc==1,authorize(1,1),pc'=2},
    all {pc==2,authorize(2,0),pc'=3},
    all {pc==3,authorize(2,1),pc'=4},
    all {pc==4,authorize(3,0),pc'=5},
    all {pc==5,authorize(3,1),pc'=6},
    all {pc==6, pc'=pc, nondet leg=Set(0,1).oneOf(); blockWork(leg,Reserve)},
    all {pc==6, Set(0,1).forall(leg=>processed(leg,Reserve)), waitBlock,pc'=8},
  }

  // There is no nonterminal stutter. The fixed program and each open block's
  // finite remaining work give a finite ascending rank before this endpoint.
  action blockStep=any {work,all {pc==donePC,pc'=pc,waitBlock}}
  val economicSound=coreSound and
    Ids.forall(t=>tradeGuarantees(sourceState,tradeTerms(t)))
  val fullyBooked=Ids.forall(t=>{
    val row=sourceState.trades.get(t)
    and {row.decision==2,row.effectsA==1,row.effectsB==1,
      evidenceBackedBooking(sourceState,tradeTerms(t))}
  })
  val sound=economicSound and blockSound and (pc==donePC implies (lane(0).applied.size()==2 and lane(1).applied.size()==2 and Ids.forall(t=>and {sourceState.trades.get(t).preparedA==lane(0).applied.contains(t),sourceState.trades.get(t).preparedB==lane(1).applied.contains(t)})))
  temporal includedProgress=work.weakFair((pc,blocks)).implies(eventually(pc==donePC))

  action local(op:bool):bool=all {op,pc'=pc}
  action publish(t:int,p:int):bool=local(finalizeSealed(t,p))
    .then(local(proofJob(t,p,1))).then(local(proofJob(t,p,2))).then(local(proofJob(t,p,3)))
  run held=blockInit.then(signedPC.reps(_=>blockStep))
    .then(local(openBlock(0,Reserve,Ids))).then(local(openBlock(1,Reserve,Ids)))
    .then(local(executeTx(0,1))).then(local(executeTx(0,2))).then(local(executeTx(0,3)))
    .then(local(executeTx(1,2))).then(local(executeTx(1,3))).then(local(executeTx(1,1)))
    .then(local(sealBlock(0))).then(local(sealBlock(1)))
    .expect(lane(0).applied==Set(1,2) and lane(1).applied==Set(2,3))
  run LateApplicationAfterShortFundedOutageTest=held
    .then(publish(2,2))
    .then(local(nextA))
    .then(local(openBlock(0,Settle,Set(2))))
    .then(local(executeTx(0,2)))
    .then(local(sealBlock(0)))
    .then(local(pauseB))
    .then(local(nextA))
    .then(local(expire(1)))
    .then(publish(1,4))
    .then(local(expire(3)))
    .then(publish(3,4))
    .expect(sourceState.height==deadline and not(sourceState.up.contains(1)) and sourceState.financialRecords.size()==0 and sourceState.receivedB.get(2)==0)
    .then(local(resumeB))
    .then(publish(2,3))
    .then(local(takeOutcome(2)))
    .then(local(nextB))
    .then(local(openBlock(1,Settle,Set(2))))
    .then(local(executeTx(1,2)))
    .then(local(sealBlock(1)))
    .then(publish(2,5))
    .then(publish(2,6))
    .then(local(observeEffect(2,0)))
    .then(local(observeEffect(2,1)))
    .then(local(bookTrade(2)))
    .then(local(takeAbort(1)))
    .then(local(releaseHold(1,0)))
    .then(local(readDisposition(1,0)))
    .then(local(readDisposition(1,1)))
    .then(local(bookAbort(1)))
    .then(local(takeAbort(3)))
    .then(local(readDisposition(3,0)))
    .then(local(releaseHold(3,1)))
    .then(local(readDisposition(3,1)))
    .then(local(bookAbort(3)))
    .expect(economicSound and blockSound and sourceState.financialRecords.size()==3 and
      Ids.forall(t=>evidenceBackedBooking(sourceState,tradeTerms(t))) and
      sourceState.trades.get(2).decision==2 and sourceState.receivedB.get(2)==3 and
      free(sourceState,0)==2 and free(sourceState,1)==3)
  run LatePreparationAfterShortFundedOutageTest=held
    .then(local(pauseB))
    .then(local(nextA))
    .then(local(nextA))
    .then(local(expire(1)))
    .then(publish(1,4))
    .then(local(expire(2)))
    .then(publish(2,4))
    .then(local(expire(3)))
    .then(publish(3,4))
    .expect(sourceState.height==deadline and not(sourceState.up.contains(1)) and sourceState.financialRecords.size()==0 and sourceState.receivedB.get(2)==0)
    .then(local(resumeB))
    .then(publish(2,2))
    .then(local(takeAbort(1)))
    .then(local(releaseHold(1,0)))
    .then(local(readDisposition(1,0)))
    .then(local(readDisposition(1,1)))
    .then(local(bookAbort(1)))
    .then(local(takeAbort(2)))
    .then(local(releaseHold(2,0)))
    .then(local(readDisposition(2,0)))
    .then(local(releaseHold(2,1)))
    .then(local(readDisposition(2,1)))
    .then(local(bookAbort(2)))
    .then(local(takeAbort(3)))
    .then(local(readDisposition(3,0)))
    .then(local(releaseHold(3,1)))
    .then(local(readDisposition(3,1)))
    .then(local(bookAbort(3)))
    .expect(economicSound and blockSound and sourceState.financialRecords.size()==3 and
      Ids.forall(t=>evidenceBackedBooking(sourceState,tradeTerms(t))) and
      sourceState.trades.get(2).decision==3 and sourceState.receivedB.get(2)==0 and
      free(sourceState,0)==4 and free(sourceState,1)==6)
}

module funded_blocks {
  import dvp_blocks(COUNT=3,FAULT=0).* from "./dvp_blocks"
  import guarantee_oracles.* from "./guarantee_oracles"
  var pc:int
  action blockInit=all {start,pc'=0}
  action framed(op:bool):bool=all {op,blocks'=blocks}
  action blockWork(leg:int,kind:int):bool=any {
    openBlock(leg,kind,Trades),sealBlock(leg),
    nondet t=Trades.oneOf(); executeTx(leg,t)
  }
  pure val signedPC=6
  pure val heldPC=8
  pure val decisionPC=21
  pure val decidedPC=23
  pure val cashPC=39
  pure val paidPC=41
  pure val donePC=74
  action work=any {
    all {pc==0,framed(sign(1,0)),pc'=1},
    all {pc==1,framed(sign(1,1)),pc'=2},
    all {pc==2,framed(sign(2,0)),pc'=3},
    all {pc==3,framed(sign(2,1)),pc'=4},
    all {pc==4,framed(sign(3,0)),pc'=5},
    all {pc==5,framed(sign(3,1)),pc'=6},
    all {pc==6, pc'=pc, nondet leg=Set(0,1).oneOf(); blockWork(leg,Reserve)},
    all {pc==6, Set(0,1).forall(leg=>processed(leg,Reserve)), framed(idle),pc'=8},
    all {pc==8,finalizeSealed(1,2),pc'=9},
    all {pc==9,framed(capture(1,2)),pc'=10},
    all {pc==10,framed(prove(1,2)),pc'=11},
    all {pc==11,framed(deliver(1,2)),pc'=12},
    all {pc==12,finalizeSealed(2,2),pc'=13},
    all {pc==13,framed(capture(2,2)),pc'=14},
    all {pc==14,framed(prove(2,2)),pc'=15},
    all {pc==15,framed(deliver(2,2)),pc'=16},
    all {pc==16,finalizeSealed(3,2),pc'=17},
    all {pc==17,framed(capture(3,2)),pc'=18},
    all {pc==18,framed(prove(3,2)),pc'=19},
    all {pc==19,framed(deliver(3,2)),pc'=20},
    all {pc==20,nextA,pc'=21},
    all {pc==21, pc'=pc, nondet leg=Set(0).oneOf(); blockWork(leg,Settle)},
    all {pc==21, Set(0).forall(leg=>processed(leg,Settle)), framed(idle),pc'=23},
    all {pc==23,finalizeSealed(1,3),pc'=24},
    all {pc==24,framed(capture(1,3)),pc'=25},
    all {pc==25,framed(prove(1,3)),pc'=26},
    all {pc==26,framed(deliver(1,3)),pc'=27},
    all {pc==27,framed(learn(1,2,1)),pc'=28},
    all {pc==28,finalizeSealed(2,3),pc'=29},
    all {pc==29,framed(capture(2,3)),pc'=30},
    all {pc==30,framed(prove(2,3)),pc'=31},
    all {pc==31,framed(deliver(2,3)),pc'=32},
    all {pc==32,framed(learn(2,2,1)),pc'=33},
    all {pc==33,finalizeSealed(3,3),pc'=34},
    all {pc==34,framed(capture(3,3)),pc'=35},
    all {pc==35,framed(prove(3,3)),pc'=36},
    all {pc==36,framed(deliver(3,3)),pc'=37},
    all {pc==37,framed(learn(3,2,1)),pc'=38},
    all {pc==38,nextB,pc'=39},
    all {pc==39, pc'=pc, nondet leg=Set(1).oneOf(); blockWork(leg,Settle)},
    all {pc==39, Set(1).forall(leg=>processed(leg,Settle)), framed(idle),pc'=41},
    all {pc==41,finalizeSealed(1,5),pc'=42},
    all {pc==42,framed(capture(1,5)),pc'=43},
    all {pc==43,framed(prove(1,5)),pc'=44},
    all {pc==44,framed(deliver(1,5)),pc'=45},
    all {pc==45,framed(observe(1,0)),pc'=46},
    all {pc==46,finalizeSealed(1,6),pc'=47},
    all {pc==47,framed(capture(1,6)),pc'=48},
    all {pc==48,framed(prove(1,6)),pc'=49},
    all {pc==49,framed(deliver(1,6)),pc'=50},
    all {pc==50,framed(observe(1,1)),pc'=51},
    all {pc==51,framed(reconcile(1)),pc'=52},
    all {pc==52,finalizeSealed(2,5),pc'=53},
    all {pc==53,framed(capture(2,5)),pc'=54},
    all {pc==54,framed(prove(2,5)),pc'=55},
    all {pc==55,framed(deliver(2,5)),pc'=56},
    all {pc==56,framed(observe(2,0)),pc'=57},
    all {pc==57,finalizeSealed(2,6),pc'=58},
    all {pc==58,framed(capture(2,6)),pc'=59},
    all {pc==59,framed(prove(2,6)),pc'=60},
    all {pc==60,framed(deliver(2,6)),pc'=61},
    all {pc==61,framed(observe(2,1)),pc'=62},
    all {pc==62,framed(reconcile(2)),pc'=63},
    all {pc==63,finalizeSealed(3,5),pc'=64},
    all {pc==64,framed(capture(3,5)),pc'=65},
    all {pc==65,framed(prove(3,5)),pc'=66},
    all {pc==66,framed(deliver(3,5)),pc'=67},
    all {pc==67,framed(observe(3,0)),pc'=68},
    all {pc==68,finalizeSealed(3,6),pc'=69},
    all {pc==69,framed(capture(3,6)),pc'=70},
    all {pc==70,framed(prove(3,6)),pc'=71},
    all {pc==71,framed(deliver(3,6)),pc'=72},
    all {pc==72,framed(observe(3,1)),pc'=73},
    all {pc==73,framed(reconcile(3)),pc'=74},
  }

  // There is no nonterminal stutter. The fixed program and each open block's
  // finite remaining work give a finite ascending rank before this endpoint.
  action blockStep=any {work,all {pc==donePC,pc'=pc,framed(idle)}}
  val economicSound=safe and CDecision and
    Trades.forall(t=>tradeGuarantees(s,desc(t)))
  val fullyBooked=Trades.forall(t=>{
    val row=s.trades.get(t)
    and {row.decision==2,row.effectsA==1,row.effectsB==1,
      evidenceBackedBooking(s,desc(t))}
  })
  val sound=economicSound and blockSound and (pc==donePC implies (fullyBooked and s.ownerA==0 and s.ownerB==0))

  action atSamePC(op:bool):bool=all {op,pc'=pc}
  run signedTrades=blockInit.then(signedPC.reps(_=>blockStep))
  run twoOpened=signedTrades.then(atSamePC(openBlock(0,Reserve,Trades)))
    .then(atSamePC(openBlock(1,Reserve,Trades)))
  run reserveSealed=twoOpened
    .then(atSamePC(executeTx(0,3))).then(atSamePC(executeTx(1,2)))
    .then(atSamePC(executeTx(1,1))).then(atSamePC(executeTx(0,1)))
    .then(atSamePC(executeTx(0,2))).then(atSamePC(executeTx(1,3)))
    .then(atSamePC(sealBlock(0))).then(atSamePC(sealBlock(1))).then(blockStep)
  run readyAtLastHeight=reserveSealed.then((decisionPC-heldPC).reps(_=>blockStep))
  run commitOpened=readyAtLastHeight.then(atSamePC(openBlock(0,Settle,Trades)))

  run decisionsSealed=commitOpened.then(atSamePC(executeTx(0,2))).then(atSamePC(executeTx(0,3)))
    .then(atSamePC(executeTx(0,1))).then(atSamePC(sealBlock(0))).then(blockStep)
  run cashOpened=decisionsSealed.then((cashPC-decidedPC).reps(_=>blockStep))
    .then(atSamePC(openBlock(1,Settle,Trades)))
  run FullyFundedTradesAllBookTest=cashOpened.then(atSamePC(executeTx(1,3)))
    .then(atSamePC(executeTx(1,1))).then(atSamePC(executeTx(1,2))).then(atSamePC(sealBlock(1))).then(blockStep)
    .then((donePC-paidPC).reps(_=>blockStep))
    .expect(pc==donePC and sound and fullyBooked and s.financialRecords.size()==3)
  run NoHeightBumpBetweenCommitsTest=commitOpened.then(atSamePC(executeTx(0,2)))
    .expect(sound and lane(0).height==D-1 and height(0)==D-1 and free(s,0)==0)
    .then(atSamePC(nextA).fail())
  run EarlySourcePublicationIsDisabledTest=twoOpened.then(atSamePC(executeTx(1,2)))
    .expect(s.included.contains(fact(2,2)))
    .then(atSamePC(finalizeSealed(2,2)).fail())
  run IndependentHeightsTest=twoOpened
    .then(3.reps(i=>atSamePC(executeTx(1,i+1)))).then(atSamePC(sealBlock(1)))
    .then(atSamePC(nextB)).expect(sound and lane(0).open and height(0)==0 and height(1)==1)
  run DuplicateRequestCannotTakeTwoSlotsTest=twoOpened.then(atSamePC(executeTx(0,1)))
    .expect(lane(0).applied==Set(1)).then(atSamePC(executeTx(0,1)).fail())
  run CannotCommitOnDeadlineTest=readyAtLastHeight.then(atSamePC(nextA))
    .expect(height(0)==D and Trades.forall(t=>has(s,t,2)))
    .then(atSamePC(openBlock(0,Settle,Trades)).fail())
  run OlderReservationConsumesOnlyItsOwnCapacityTest=signedTrades
    .then(atSamePC(openBlock(0,Reserve,Set(1)))).then(atSamePC(executeTx(0,1)))
    .then(atSamePC(sealBlock(0))).then(atSamePC(nextA))
    .then(atSamePC(openBlock(0,Reserve,Set(2,3))))
    .then(atSamePC(executeTx(0,3))).then(atSamePC(executeTx(0,2))).then(atSamePC(sealBlock(0)))
    .expect(sound and lane(0).initialFree==4 and lane(0).applied==Set(2,3)
            and reservedA(s)==6 and s.trades.get(1).holdA==1)
  run ShortfallAfterOrdinarySpendIsLocalTest=signedTrades
    .then(atSamePC(framed(spend(1)))).then(atSamePC(openBlock(1,Reserve,Trades)))
    .then(atSamePC(executeTx(1,2))).then(atSamePC(executeTx(1,3)))
    .then(atSamePC(executeTx(1,1))).then(atSamePC(sealBlock(1)))
    .expect(sound and lane(1).applied==Set(2,3) and lane(1).shortfall==Set(1)
            and s.trades.get(1).holdB==0 and not(s.included.contains(fact(1,2))))
}

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
  val sound=economicSound and blockSound and (pc==donePC implies (lane(0).applied.size()==2 and lane(1).applied.size()==3 and Ids.forall(t=>and {sourceState.trades.get(t).preparedA==lane(0).applied.contains(t),sourceState.trades.get(t).preparedB==lane(1).applied.contains(t)})))
}

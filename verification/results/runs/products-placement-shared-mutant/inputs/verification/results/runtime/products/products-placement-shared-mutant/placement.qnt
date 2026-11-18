module placement_products {
  import dvp(N=3,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))
  action placementStep = any {adversarialStep,
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); any {lose(t,p),prune(t,p)}}
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
  run OmittedLocalCashIsVisibleTest=(init
    .then(replayEvents(List((0,1,0,0),(0,1,1,0),(1,1,0,0),(2,1,0,0),(0,2,0,0),(0,2,1,0),(1,2,0,0),(2,2,0,0),(0,3,0,0),(0,3,1,0),(1,3,0,0),(2,3,0,0))))).then(commit(1)).expect(s.trades.get(1).decision==2 and s.trades.get(1).effectsB==0 and not(legOutcomeSound(s,desc(1),1)))
}

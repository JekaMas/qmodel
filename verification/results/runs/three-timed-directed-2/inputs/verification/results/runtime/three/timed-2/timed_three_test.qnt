// Actual settlement actions with a separate bounded event environment.
// A height governs the signed deadline. Elapsed time and B height continue
// independently when A or its route fails.
module timed_three_test {
  import dvp(N=3,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  pure val actors = 0.to(4)
  pure val routes = 0.to(3)
  pure val horizon = 8
  pure val forever = 14
  pure val durations = Set(1,2,3,5,forever)

  type Clock = {
    slot:int, lastA:int, lastB:int, heightB:int,
    due:int->int, partition:int->int, failures:int, attacks:int
  }
  var clock:Clock

  action start = all {
    init,clock'={slot:0,lastA:-1,lastB:-1,heightB:0,due:actors.mapBy(_=>0),
      partition:routes.mapBy(_=>0),failures:4,attacks:4}
  }
  pure def until(now:int,span:int):int = if(span==forever) forever else now+span
  pure def route(phase:int):int =
    if(phase==2) 1 else if(phase==3 or phase==4) 2 else if(phase>=5) 3 else 0
  def connected(phase:int):bool = clock.slot>=clock.partition.get(route(phase))

  action advance = all {clock.slot<horizon,s'=s,clock'={...clock,slot:clock.slot+1}}
  action blockA = all {clock.lastA<clock.slot,tick,clock'={...clock,lastA:clock.slot}}
  action blockB = all {s.up.contains(1),clock.lastB<clock.slot,s'=s,
    clock'={...clock,lastB:clock.slot,heightB:clock.heightB+1}}
  action stop(a:int,span:int):bool = all {
    actors.contains(a),durations.contains(span),clock.failures>0,s.up.contains(a),crash(a),
    clock'={...clock,due:clock.due.set(a,until(clock.slot,span)),failures:clock.failures-1}
  }
  action restart(a:int):bool = all {
    actors.contains(a),not(s.up.contains(a)),clock.due.get(a)<=clock.slot,recover(a),
    clock'={...clock,due:clock.due.set(a,0)}
  }
  action partitionLink(r:int,span:int):bool = all {
    routes.contains(r),durations.contains(span),clock.failures>0,
    clock.partition.get(r)<=clock.slot,s'=s,
    clock'={...clock,partition:clock.partition.set(r,until(clock.slot,span)),failures:clock.failures-1}
  }
  action hostile(t:int,p:int,binding:int):bool = all {
    Trades.contains(t),0.to(6).contains(p),0.to(11).contains(binding),clock.attacks>0,inject(t,p,binding),
    clock'={...clock,attacks:clock.attacks-1}
  }

  action proofJobs(t:int,p:int):bool = any {
    finalize(t,p),capture(t,p),prove(t,p),resend(t,p),lose(t,p),prune(t,p),
    all {connected(p),deliver(t,p)},
    proveUnadmitted(t,p),all {connected(p),deliverUnadmitted(t,p)}
  }

  // Every branch invokes a primitive actor action. No alternate dispatcher is
  // imported here because it could bypass the route and outage guards.
  action settlement = any {
    idle,rotate,exitMember,compromiseTransport,
    nondet l=Set(0,1).oneOf(); any {freeze(l),unfreeze(l),spend(l)},
    nondet t=Trades.oneOf(); any {
      sign(t,0),sign(t,1),openA(t),prepareB(t),commit(t),abort(t),
      learn(t,2,0),learn(t,2,1),learn(t,3,0),learn(t,3,1),
      applyB(t),refund(t,0),refund(t,1),observe(t,0),observe(t,1),reconcile(t),
      captureAbortRecord(t,0),captureAbortRecord(t,1),recordAbort(t),
      receiveNote(t),revoke(t),revokeLeg(t,0),revokeLeg(t,1),
      nondet p=0.to(6).oneOf(); proofJobs(t,p)
    }
  }

  action timedStep = any {
    advance,blockA,blockB,
    nondet a=actors.oneOf(); restart(a),
    nondet a=actors.oneOf(); nondet d=durations.oneOf(); stop(a,d),
    nondet r=routes.oneOf(); nondet d=durations.oneOf(); partitionLink(r,d),
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); nondet b=0.to(11).oneOf(); hostile(t,p,b),
    all {settlement,clock'=clock}
  }

  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t))) and
    clock.slot>=0 and clock.slot<=horizon and clock.failures>=0 and clock.attacks>=0 and
    s.height<=clock.slot+1 and clock.heightB<=clock.slot+1 and
    actors.forall(a=>s.up.contains(a)==(clock.due.get(a)==0))
  action requestExactOpen(t:int):bool = requestOpen(t,desc(t))
  action requestExactCash(t:int):bool = requestCash(t,desc(t))
  action executeCore(e:(int,int,int,int)):bool = any {
    all {e._1==0, sign(e._2,e._3)},
    all {e._1==1, openA(e._2)},
    all {e._1==2, prepareB(e._2)},
    all {e._1==3, tick},
    all {e._1==4, finalize(e._2,e._3)},
    all {e._1==5, capture(e._2,e._3)},
    all {e._1==6, prove(e._2,e._3)},
    all {e._1==7, proveUnadmitted(e._2,e._3)},
    all {e._1==8, all {connected(e._3),deliverUnadmitted(e._2,e._3)}},
    all {e._1==9, lose(e._2,e._3)},
    all {e._1==10, resend(e._2,e._3)},
    all {e._1==11, all {connected(e._3),deliver(e._2,e._3)}},
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
    executeTimed(events.nth(i)).expect(sequenceSafe and
      decisions.forall(d=>s.trades.get(d._1).decision==d._2) and
      outputs.subseteq(s.economicReceipts) and rows.subseteq(s.financialRecords))
  })
  action executeTimed(e:(int,int,int,int)):bool = all {executeCore(e),clock'=clock}
  run contender = start.expect(sequenceSafe)
    .then(replayEvents(List((0,1,0,0),(0,1,1,0),(1,1,0,0),(2,1,0,0),(0,2,0,0),(0,2,1,0),(1,2,0,0),(2,2,0,0))))
    .then(replayEvents(List((0,3,0,0),(0,3,1,0))))
  run ThirdSecurityReservationDeniedTest = contender.expect(s.ownerA==4 and reservedA(s)==4).then(openA(3).fail())
  run ThirdCashReservationDeniedTest = contender.expect(s.ownerB==6 and reservedB(s)==6).then(prepareB(3).fail())
}

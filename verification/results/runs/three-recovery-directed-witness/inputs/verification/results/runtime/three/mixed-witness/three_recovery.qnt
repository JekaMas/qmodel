// Actual settlement actions with a separate bounded event environment.
// A height governs the signed deadline. Elapsed time and B height continue
// independently when A or its route fails.
module three_recovery {
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
  var pc:int
  pure val readyPC = 28
  action bootstrap = any {
    all {pc==0,sign(1,0),clock'=clock,pc'=1},
    all {pc==1,sign(1,1),clock'=clock,pc'=2},
    all {pc==2,openA(1),clock'=clock,pc'=3},
    all {pc==3,prepareB(1),clock'=clock,pc'=4},
    all {pc==4,sign(2,0),clock'=clock,pc'=5},
    all {pc==5,sign(2,1),clock'=clock,pc'=6},
    all {pc==6,openA(2),clock'=clock,pc'=7},
    all {pc==7,prepareB(2),clock'=clock,pc'=8},
    all {pc==8,sign(3,0),clock'=clock,pc'=9},
    all {pc==9,sign(3,1),clock'=clock,pc'=10},
    all {pc==10,openA(3),clock'=clock,pc'=11},
    all {pc==11,prepareB(3),clock'=clock,pc'=12},
    all {pc==12,finalize(1,2),clock'=clock,pc'=13},
    all {pc==13,capture(1,2),clock'=clock,pc'=14},
    all {pc==14,prove(1,2),clock'=clock,pc'=15},
    all {pc==15,deliver(1,2),clock'=clock,pc'=16},
    all {pc==16,commit(1),clock'=clock,pc'=17},
    all {pc==17,blockA,pc'=18},
    all {pc==18,advance,pc'=19},
    all {pc==19,blockA,pc'=20},
    all {pc==20,advance,pc'=21},
    all {pc==21,blockA,pc'=22},
    all {pc==22,abort(2),clock'=clock,pc'=23},
    all {pc==23,finalize(3,2),clock'=clock,pc'=24},
    all {pc==24,capture(3,2),clock'=clock,pc'=25},
    all {pc==25,prove(3,2),clock'=clock,pc'=26},
    all {pc==26,deliver(3,2),clock'=clock,pc'=27},
    all {pc==27,commit(3),clock'=clock,pc'=28},
  }
// Finite mixed-outcome suffix: proof stages for each leg advance only when
// required, but different trades and both ABORT releases interleave freely.
action advanceProof(t:int,p:int):bool = any {
  all {not(s.finalized.contains(fact(t,p))),finalize(t,p)},
  all {not(s.captured.contains(fact(t,p))),capture(t,p)},
  all {not(s.proofs.contains(fact(t,p))),prove(t,p)},
  all {not(s.received.contains(fact(t,p))),deliver(t,p)}
}

action commitWork(t:int):bool = {
  val z=s.trades.get(t)
  any {
    all {not(has(s,t,3)),advanceProof(t,3)},
    all {z.knownB!=2,learn(t,2,1)},
    applyB(t),
    all {z.effectsB==1,not(z.appliedEvidenceA),advanceProof(t,5)},
    all {z.effectsB==1,not(z.appliedEvidenceA),observe(t,0)},
    all {z.appliedEvidenceA,not(z.appliedEvidenceB),advanceProof(t,6)},
    all {z.appliedEvidenceA,not(z.appliedEvidenceB),observe(t,1)},
    all {z.report!=2,reconcile(t)}
  }
}

action abortWork(t:int):bool = {
  val z=s.trades.get(t)
  any {
    all {not(has(s,t,4)),advanceProof(t,4)},
    all {z.knownB!=3,learn(t,3,1)},
    refund(t,0),refund(t,1),
    all {not(hasAbortRecord(s,t,0)),captureAbortRecord(t,0)},
    all {not(hasAbortRecord(s,t,1)),captureAbortRecord(t,1)},
    all {z.report!=3,recordAbort(t)}
  }
}

action work(t:int):bool = all {
  pc==readyPC,pc'=pc,clock'=clock,
  if(s.trades.get(t).decision==2) commitWork(t) else abortWork(t)
}

action afterDecision = all {
  pc==readyPC,pc'=pc,
  any {
    advance,
    all {clock.failures==4, nondet a=Set(1,3,4).oneOf(); stop(a,2)},
    nondet a=Set(1,3,4).oneOf(); restart(a),
    all {s'=s,clock'=clock}
  }
}

action recoveryInit = all {start,pc'=0}
action recoveryStep = any {bootstrap,afterDecision,nondet t=Trades.oneOf(); work(t)}

val complete = pc==readyPC and Trades.forall(t=>evidenceBackedBooking(s,desc(t)))
val incompleteControl = not(complete)
temporal stable = eventually(always(s.up==actors))
temporal fairWork = Trades.forall(t=>work(t).weakFair(Set(s)))
temporal recoveryProgress = (stable and fairWork).implies((pc==readyPC).leadsTo(complete))

run MixedOutcomesReachableWithOutageTest =
  recoveryInit.then(readyPC.reps(_=>bootstrap))
    .expect(pc==readyPC and s.trades.get(1).decision==2 and s.trades.get(2).decision==3 and s.trades.get(3).decision==2)
    .then(all {pc'=pc,stop(1,2)})
    .then(2.reps(_=>all {pc'=pc,advance})).then(all {pc'=pc,restart(1)})
    .then(17.reps(_=>work(1).expect(sequenceSafe)))
    .then(10.reps(_=>work(2).expect(sequenceSafe)))
    .then(17.reps(_=>work(3).expect(sequenceSafe)))
    .expect(complete and s.financialRecords.size()==3 and s.receivedB.get(1)==3 and s.receivedB.get(3)==3 and
      s.trades.get(2).refundsA==1 and s.trades.get(2).refundsB==1)
}

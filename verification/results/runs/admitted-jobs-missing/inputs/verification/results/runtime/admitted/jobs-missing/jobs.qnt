// Actual settlement actions with a separate bounded event environment.
// A height governs the signed deadline. Elapsed time and B height continue
// independently when A or its route fails.
module job_products {
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
  pure val loadedPC = 17
  pure val workingPC = 18
  pure val mode = 2
  action bootstrap = any {
    all {pc==0,sign(1,0),clock'=clock,pc'=1,q'=q},
    all {pc==1,sign(1,1),clock'=clock,pc'=2,q'=q},
    all {pc==2,openA(1),clock'=clock,pc'=3,q'=q},
    all {pc==3,prepareB(1),clock'=clock,pc'=4,q'=q},
    all {pc==4,sign(2,0),clock'=clock,pc'=5,q'=q},
    all {pc==5,sign(2,1),clock'=clock,pc'=6,q'=q},
    all {pc==6,openA(2),clock'=clock,pc'=7,q'=q},
    all {pc==7,prepareB(2),clock'=clock,pc'=8,q'=q},
    all {pc==8,sign(3,0),clock'=clock,pc'=9,q'=q},
    all {pc==9,sign(3,1),clock'=clock,pc'=10,q'=q},
    all {pc==10,openA(3),clock'=clock,pc'=11,q'=q},
    all {pc==11,prepareB(3),clock'=clock,pc'=12,q'=q},
    all {pc==12,blockA,pc'=13,q'=q},
    all {pc==13,advance,pc'=14,q'=q},
    all {pc==14,blockA,pc'=15,q'=q},
    all {pc==15,advance,pc'=16,q'=q},
    all {pc==16,blockA,pc'=17,q'=q},
  }
// Finite mixed-outcome suffix: proof stages for each leg advance only when
// required, but different trades and both ABORT releases interleave freely.
action advanceProof(t:int,p:int):bool = any {
  all {not(s.finalized.contains(fact(t,p))),finalize(t,p)},
  all {not(s.captured.contains(fact(t,p))),capture(t,p)},
  all {not(s.proofs.contains(fact(t,p))),prove(t,p)},
  all {s.proofs.contains(fact(t,p)),not(s.network.contains(fact(t,p))),resend(t,p)},
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

  // Work membership is durable while a proof, retry, or report is incomplete.
  type Queue={jobs:Set[int], offered:Set[int], junk:Set[int], ticks:int, lost:bool}
  var q:Queue
  action jobInit = all {start,pc'=0,q'={jobs:Set(),offered:Set(),junk:Set(),ticks:0,lost:false}}
  action admitJobs = all {pc==loadedPC,pc'=workingPC,q'={...q,jobs:Trades},clock'=clock,s'=s}

  action junkArrival(id:int):bool = all {
    pc==workingPC,pc'=pc,s'=s,clock'=clock,
    q'={...q,offered:q.offered.union(Set(id)),junk:if(q.offered.contains(id)) q.junk else q.junk.union(Set(id))}
  }

  action interrupted = all {
    pc==workingPC,clock.failures==4,pc'=pc,stop(3,2),
    q'=if(mode==3) {...q,jobs:Set(),ticks:0} else {...q,ticks:0}
  }
  action elapsed = all {pc==workingPC,pc'=pc,advance,q'=q}
  action restored = all {pc==workingPC,pc'=pc,restart(3),q'=q}
  action drop = {
    nondet t=Trades.oneOf()
    nondet p=Set(2,3,4).oneOf()
    all {pc==workingPC,pc'=pc,not(q.lost),not(s.received.contains(fact(t,p))),lose(t,p),
         clock'=clock,q'={...q,lost:true}}
  }

  def done(t:int):bool = evidenceBackedBooking(s,desc(t))
  val allDone = Trades.forall(t=>done(t))
  def ready(t:int):bool = q.jobs.contains(t) and not(done(t)) and
    Trades.filter(x=>x<t).forall(x=>not(q.jobs.contains(x)) or done(x))
  action firstStep(t:int):bool = if(t==2) abort(t) else
    any {advanceProof(t,2),commit(t)}

  action nextTradeJob(t:int):bool = {
    val disposition=s.trades.get(t).decision
    if(disposition==2) commitWork(t)
    else if(disposition==3) abortWork(t)
    else firstStep(t)
  }

  action service = all {
    pc==workingPC,pc'=pc,s.up==actors,clock'=clock,not(allDone),q.ticks<56,
    if(mode==1 and q.junk.size()>0) {
      nondet id=q.junk.oneOf()
      all {s'=s,q'={...q,junk:q.junk.exclude(Set(id)),ticks:q.ticks+1}}
    } else if(mode==2) all {s'=s,q'={...q,ticks:q.ticks+1}}
    else {
      nondet t=Trades.oneOf()
      all {ready(t),nextTradeJob(t),q'={...q,ticks:q.ticks+1}}
    }
  }
  action jobStep = any {
    bootstrap,admitJobs,interrupted,restored,elapsed,drop,service,
    nondet id=Set(1,2,3).oneOf();junkArrival(id),
    all {s'=s,clock'=clock,pc'=pc,q'=q}
  }
  val readySurvives = pc<workingPC or q.jobs==Trades
  val serviceBound = q.ticks<56 or allDone
  val jobSafety = sequenceSafe and readySurvives and serviceBound
  val completionWitness = not(allDone and q.junk.size()==3 and q.lost and clock.failures==3)
  temporal jobProgress = (eventually(always(s.up==actors)) and service.weakFair(Set(s)))
                            .implies((pc==workingPC).leadsTo(allDone))
}

// Actual settlement actions with a separate bounded event environment.
// A height governs the signed deadline. Elapsed time and B height continue
// independently when A or its route fails.
module three_queue {
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
  pure val readyPC = 39
  pure val protected = false
  action bootstrap = any {
    all {pc==0,sign(1,0),clock'=clock,pc'=1,load'=load},
    all {pc==1,sign(1,1),clock'=clock,pc'=2,load'=load},
    all {pc==2,openA(1),clock'=clock,pc'=3,load'=load},
    all {pc==3,prepareB(1),clock'=clock,pc'=4,load'=load},
    all {pc==4,sign(2,0),clock'=clock,pc'=5,load'=load},
    all {pc==5,sign(2,1),clock'=clock,pc'=6,load'=load},
    all {pc==6,openA(2),clock'=clock,pc'=7,load'=load},
    all {pc==7,prepareB(2),clock'=clock,pc'=8,load'=load},
    all {pc==8,sign(3,0),clock'=clock,pc'=9,load'=load},
    all {pc==9,sign(3,1),clock'=clock,pc'=10,load'=load},
    all {pc==10,openA(3),clock'=clock,pc'=11,load'=load},
    all {pc==11,prepareB(3),clock'=clock,pc'=12,load'=load},
    all {pc==12,finalize(1,2),clock'=clock,pc'=13,load'=load},
    all {pc==13,capture(1,2),clock'=clock,pc'=14,load'=load},
    all {pc==14,prove(1,2),clock'=clock,pc'=15,load'=load},
    all {pc==15,deliver(1,2),clock'=clock,pc'=16,load'=load},
    all {pc==16,commit(1),clock'=clock,pc'=17,load'=load},
    all {pc==17,blockA,pc'=18,load'=load},
    all {pc==18,advance,pc'=19,load'=load},
    all {pc==19,blockA,pc'=20,load'=load},
    all {pc==20,advance,pc'=21,load'=load},
    all {pc==21,blockA,pc'=22,load'=load},
    all {pc==22,abort(2),clock'=clock,pc'=23,load'=load},
    all {pc==23,finalize(3,2),clock'=clock,pc'=24,load'=load},
    all {pc==24,capture(3,2),clock'=clock,pc'=25,load'=load},
    all {pc==25,prove(3,2),clock'=clock,pc'=26,load'=load},
    all {pc==26,deliver(3,2),clock'=clock,pc'=27,load'=load},
    all {pc==27,commit(3),clock'=clock,pc'=28,load'=load},
    all {pc==28,finalize(1,3),clock'=clock,pc'=29,load'=load},
    all {pc==29,capture(1,3),clock'=clock,pc'=30,load'=load},
    all {pc==30,prove(1,3),clock'=clock,pc'=31,load'=load},
    all {pc==31,deliver(1,3),clock'=clock,pc'=32,load'=load},
    all {pc==32,learn(1,2,1),clock'=clock,pc'=33,load'=load},
    all {pc==33,finalize(3,3),clock'=clock,pc'=34,load'=load},
    all {pc==34,capture(3,3),clock'=clock,pc'=35,load'=load},
    all {pc==35,prove(3,3),clock'=clock,pc'=36,load'=load},
    all {pc==36,deliver(3,3),clock'=clock,pc'=37,load'=load},
    all {pc==37,learn(3,2,1),clock'=clock,pc'=38,load'=load},
    all {pc==38,stop(1,2),pc'=39,load'=load},
  }
// A candidate protected application lane after verified outcome. Poisoned
// best-effort work fills a separately tracked finite queue. One B outage
// in the actual prefix overlaps the enqueue window.
type Load = {junk:int,budget:int,serviceTicks:int,saturatedTicks:int}
var load:Load

action loadInit = all {start,pc'=0,load'={junk:0,budget:3,serviceTicks:0,saturatedTicks:0}}
action enqueueJunk = all {
  pc==readyPC,pc'=pc,load.budget>0,load.junk<3,s'=s,clock'=clock,
  load'={...load,junk:load.junk+1,budget:load.budget-1}
}
action waitDuringStop = all {
  pc==readyPC,pc'=pc,not(s.up.contains(1)),clock.slot<clock.due.get(1),advance,load'=load
}
action endStop = all {pc==readyPC,pc'=pc,restart(1),load'=load}

action serviceTick = {
  val count = load.saturatedTicks + (if(load.junk==3) 1 else 0)
  all {
  pc==readyPC,pc'=pc,s.up.contains(1),clock.slot<horizon,load.serviceTicks<2,
  clock'={...clock,slot:clock.slot+1},
  if(protected or load.junk==0) {
    nondet t=Set(1,3).oneOf()
    all {applyB(t),load'={...load,serviceTicks:load.serviceTicks+1,saturatedTicks:count}}
  } else all {s'=s,load'={...load,junk:load.junk-1,serviceTicks:load.serviceTicks+1,saturatedTicks:count}}
  }
}

action loadStep = any {
  bootstrap,enqueueJunk,waitDuringStop,endStop,serviceTick,
  all {s'=s,pc'=pc,clock'=clock,load'=load}
}

val withinTwoServiceTicks = load.serviceTicks<2 or
  Set(1,3).forall(t=>s.trades.get(t).effectsB==1 and s.receivedB.get(t)==3)
val capacityRespect = load.junk>=0 and load.junk<=3 and load.budget>=0 and load.junk+load.budget<=3
val loadSafe = sequenceSafe and withinTwoServiceTicks and capacityRespect
val neverSaturatedAndComplete = not(load.saturatedTicks==2 and load.serviceTicks==2 and withinTwoServiceTicks)
}

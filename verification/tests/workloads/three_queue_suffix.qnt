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

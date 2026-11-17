module timing {
  const SLACK:int
  const SLOW:int
  const FAULT:int // 1 independent refund, 2 missing inclusion bound, 3 starvation, 4 frozen time
  // Two funded TRADE jobs, one round-robin worker; no hostile queue entries or
  // recovery priority here. capacity.qnt separately checks finite hostile FIFO
  // service. The 14/22/24 bound cannot be carried to their unchecked composition.
  pure val H=30
  pure val Trades=Set(1,2)
  type Job={id:int,phase:int,remaining:int,wait:int}
  type State={time:int,height:int,clockB:int,queue:List[Job],decision:int->int,
    applied:Set[int],refunded:Set[int],booked:Set[int],accepted:Set[int],
    missed:bool,refundedAfterCommit:bool,stabilized:bool,outage:int,hostileCost:int}
  var t:State
  action init=t'={time:0,height:0,clockB:3,
    queue:List({id:1,phase:1,remaining:2,wait:0},{id:2,phase:1,remaining:2,wait:0}),
    decision:Trades.mapBy(_=>0),applied:Set(),refunded:Set(),booked:Set(),accepted:Trades,
    missed:false,refundedAfterCommit:false,stabilized:true,outage:0,hostileCost:0}
  // One explicit public slot advances work and decision height independently
  // of B's skewed clock. Phase completion consumes its actual remaining service.
  // Saturation preserves the missed-bound flag; it is not a production clock.
  pure def advance(x:State):State={
    val now=if(x.time<=H) x.time+1 else x.time
    val h=if(now%SLOW==0 and x.height<=H) x.height+1 else x.height
    val job=if(x.queue.length()>0) x.queue.head() else {id:0,phase:0,remaining:0,wait:0}
    val ready=x.queue.length()>0 and x.outage==0
    val finished=ready and job.remaining==1
    val deciding=finished and job.phase==4
    val applying=finished and job.phase==7
    val booking=finished and job.phase==8
    val outcome=if(h<SLACK) 2 else 3
    val nextPhase=job.phase+1
    val nextJob={...job,phase:nextPhase,remaining:if(nextPhase==2 or nextPhase==5) 2 else 1,wait:0}
    val q=if(not(ready)) x.queue
      else if(not(finished)) x.queue.replaceAt(0,{...job,remaining:job.remaining-1})
      else if(booking) x.queue.tail()
      else x.queue.tail().append(nextJob)
    {...x,time:now,height:h,clockB:now+3,queue:q,
      decision:if(deciding) x.decision.set(job.id,outcome) else x.decision,
      applied:if(applying and x.decision.get(job.id)==2) x.applied.union(Set(job.id)) else x.applied,
      refunded:if(applying and x.decision.get(job.id)==3) x.refunded.union(Set(job.id)) else x.refunded,
      booked:if(booking) x.booked.union(Set(job.id)) else x.booked,
      outage:if(x.outage>0) x.outage-1 else 0,
      missed:x.missed or (now>24 and x.booked!=Trades)}
  }
  action tick=all {FAULT!=4,t.time<=H,t'=advance(t)}
  action independentRefund=all {FAULT==1,t.clockB>=SLACK,t'= {...t,refunded:t.refunded.union(Set(1)),refundedAfterCommit:t.refundedAfterCommit or t.decision.get(1)==2}}
  action omitInclusion=all {FAULT==2,t.queue.length()>0,t.queue.head().phase==4,
    t'= {...t,time:if(t.time<=H) t.time+1 else t.time,missed:t.missed or t.time>=24}}
  action starve=all {FAULT==3,t.time<=H,t'={...t,time:t.time+1,hostileCost:if(t.hostileCost<2) t.hostileCost+1 else t.hostileCost,missed:t.missed or t.time>=24}}
  action correlatedOutage=all {t.time==0,t.outage==0,t'={...t,outage:2}}
  action step=any {tick,independentRefund,omitInclusion,starve,correlatedOutage,t'=t}
  val asyncSafety=not(t.refundedAfterCommit) and t.applied.intersect(t.refunded)==Set()
  val boundedCompletion=not(t.missed)
  val sufficientSlack=(t.time<14 or t.decision.get(1)==2 and t.decision.get(2)==2)
  val capacity=t.queue.length()<=2 and t.accepted.size()<=2
  val safe=asyncSafety and boundedCompletion and capacity
  temporal timeProgress=tick.weakFair(Set(t)).implies(eventually(t.time>=H))
  temporal noFairProgress=eventually(t.time>=H)
}
module bounded {import timing(SLACK=20,SLOW=1,FAULT=0).*}
module insufficient_margin {import timing(SLACK=3,SLOW=1,FAULT=0).*}
module slow_blocks {import timing(SLACK=20,SLOW=2,FAULT=0).*}
module local_timer {import timing(SLACK=20,SLOW=1,FAULT=1).*}
module no_inclusion {import timing(SLACK=20,SLOW=1,FAULT=2).*}
module starvation {import timing(SLACK=20,SLOW=1,FAULT=3).*}
module frozen_time {import timing(SLACK=20,SLOW=1,FAULT=4).*}

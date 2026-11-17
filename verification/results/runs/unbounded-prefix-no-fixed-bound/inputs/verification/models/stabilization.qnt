// Arbitrarily long pre-stabilization delay, then the same bounded pipeline.
// preTicks saturates only after the global 30-slot overclaim has already failed.
// Post-stabilization time is a fresh measurement origin; the signed height deadline is NEVER reset.
module stabilization {
 import timing(SLACK=20,SLOW=1,FAULT=0) as tt from "./timing"
 var preTicks:int
 action init=all {tt::t'={time:0,height:0,clockB:3,
    queue:List({id:1,phase:1,remaining:2,wait:0},{id:2,phase:1,remaining:2,wait:0}),
    decision:tt::Trades.mapBy(_=>0),applied:Set(),refunded:Set(),booked:Set(),accepted:tt::Trades,
    missed:false,refundedAfterCommit:false,stabilized:false,outage:0,hostileCost:0},preTicks'=0}
 action preWait=all {not(tt::t.stabilized),preTicks'=if(preTicks<31) preTicks+1 else preTicks,
   tt::t'={...tt::t,height:if(tt::t.height<31) tt::t.height+1 else tt::t.height,clockB:if(preTicks<31) preTicks+4 else 34}}
 action preProgress=all {not(tt::t.stabilized),tt::tick,preTicks'=if(preTicks<31) preTicks+1 else preTicks}
 action stabilize=all {not(tt::t.stabilized),preTicks'=preTicks,
   tt::t'={...tt::t,stabilized:true,time:0,missed:false}}
 action postTick=all {tt::t.stabilized,tt::tick,preTicks'=preTicks}
 action step=any {preWait,preProgress,stabilize,postTick,all {tt::t'=tt::t,preTicks'=preTicks}}
 val postBound=not(tt::t.stabilized) or tt::boundedCompletion
 val noGlobalMiss=preTicks<31 or tt::t.booked==Set(1,2)
 val safe=tt::asyncSafety and postBound
 temporal completion=(stabilize.weakFair(Set(tt::t)) and postTick.weakFair(Set(tt::t))).implies(eventually(tt::t.booked==Set(1,2)))
}

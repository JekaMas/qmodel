// Time is measured from an actual late hold, not the original deadline.
module late_resolution {
 type State={time:int,age:int,phase:int,knownAbort:bool,hold:bool,refunded:bool,booked:bool,missed:bool}
 var r:State
 action init=r'={time:0,age:0,phase:0,knownAbort:false,hold:false,refunded:false,booked:false,missed:false}
 action prepare=all {not(r.knownAbort),r.phase==0,r'={...r,hold:true,phase:1,age:0}}
 action earlyOutcome=all {r.phase==0,r'={...r,knownAbort:true}}
 action waitBeforeHold=all {r.phase==0,r.time<20,r'={...r,time:r.time+1}}
 action tick=all {r.phase>=1,r.phase<7,
  r'={...r,time:if(r.time<20) r.time+1 else r.time,age:r.age+1,phase:r.phase+1,
   knownAbort:r.knownAbort or r.phase==3,hold:r.hold and r.phase!=4,
   refunded:r.refunded or r.phase==4,booked:r.booked or r.phase==5,
   missed:r.missed or (r.age>=6 and not(r.booked))}}
 action step=any {prepare,earlyOutcome,waitBeforeHold,tick,r'=r}
 val safe=not(r.missed) and (r.refunded implies r.knownAbort) and (r.booked implies r.refunded)
 temporal resolution=tick.weakFair(Set(r)).implies(r.hold.leadsTo(r.refunded))
}

module capacity {
 // FIFO finite admission/service model. No recovery-priority class is implied.
 // Every queued hostile zero consumes service. New identities are the finite set
 // {1,2,3}, each admitted once; progress is not a theorem under unbounded arrivals.
 const BAD:int // 1 unbounded admission, 2 no recovery priority
 type State={queue:List[int],held:Set[int],done:Set[int],badBudget:int,served:int,blocked:bool,wait:int,missed:bool}
 var c:State
 action init=c'={queue:List(),held:Set(),done:Set(),badBudget:2,served:0,blocked:false,wait:0,missed:false}
 action admit(t:int):bool=all {not(c.held.contains(t)),not(c.done.contains(t)),c.held.size()<2 or BAD==1,
  c'={...c,held:c.held.union(Set(t)),queue:c.queue.append(t)}}
 action hostile=all {c.badBudget>0,c.queue.length()<3,c'={...c,queue:c.queue.append(0),badBudget:c.badBudget-1}}
 action service=all {c.queue.length()>0,not(c.blocked),
  c'={...c,queue:c.queue.tail(),done:if(c.queue.head()>0) c.done.union(Set(c.queue.head())) else c.done,
   held:if(c.queue.head()>0) c.held.exclude(Set(c.queue.head())) else c.held,served:if(c.served<5) c.served+1 else c.served,
   wait:if(c.queue.head()>0) 0 else c.wait+1}}
 action outage=c'={...c,blocked:true}
 action recover=c'={...c,blocked:false}
 action rejectOverload=all {c.held.size()==2,c'=c}
 action tick=all {c.held.size()>0,c.wait<5,c'={...c,wait:c.wait+1,missed:c.missed or c.wait>=3}}
 action step=any {nondet t=Set(1,2,3).oneOf();admit(t),hostile,service,outage,recover,rejectOverload,tick,c'=c}
 val exposure=c.held.size()<=2
 val hostileBudget=c.badBudget>=0
 val safe=exposure and hostileBudget
 temporal fairness=eventually(always(not(c.blocked))) and service.weakFair(Set(c))
 temporal progress=fairness.implies(Set(1,2,3).forall(t=>c.held.contains(t).leadsTo(c.done.contains(t))))
}
module capacity_safe {import capacity(BAD=0).*}
module unlimited {import capacity(BAD=1).*}

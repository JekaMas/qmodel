module multilateral {
  // Institutions 0 and 2 hold security; institution 1 holds shared funded cash.
  pure val Trades=Set(1,2)
  pure def securityDomain(t:int):int=if(t==1) 0 else 2
  type State={cash:int,held:Set[int],security:int->int,delivered:Set[int],paid:Set[int],
    proof:Set[(int,int,int)],decision:int->int,known:Set[int],height:int,epoch:int,
    privateNote:Set[int],report:Set[int],clock:int,visible0:List[int],visible1:List[int]}
  var z:State
  action init=z'={cash:3,held:Set(),security:Trades.mapBy(_=>2),delivered:Set(),paid:Set(),
    proof:Set(),decision:Trades.mapBy(_=>0),known:Set(),height:0,epoch:0,
    privateNote:Set(),report:Set(),clock:0,visible0:List(),visible1:List()}
  action reserve(t:int):bool=all {z.decision.get(t)==0,not(z.held.contains(t)),z.cash-z.held.size()*3>=3,
    z'={...z,held:z.held.union(Set(t))}}
  action prove(t:int):bool=all {z.held.contains(t),z'={...z,proof:z.proof.union(Set((1,t,3)))}}
  action commit(t:int):bool=all {z.height<2,z.decision.get(t)==0,z.proof.contains((1,t,3)),z.security.get(t)==2,
    z'={...z,security:z.security.set(t,0),delivered:z.delivered.union(Set(t)),decision:z.decision.set(t,2)}}
  action abort(t:int):bool=all {z.height>=2,z.decision.get(t)==0,z'={...z,decision:z.decision.set(t,3)}}
  action outcome(t:int):bool=all {z.decision.get(t)>=2,z'={...z,known:z.known.union(Set(t))}}
  action apply(t:int):bool=all {z.known.contains(t),z.held.contains(t),
    z'={...z,held:z.held.exclude(Set(t)),cash:z.cash-(if(z.decision.get(t)==2) 3 else 0),
      paid:if(z.decision.get(t)==2) z.paid.union(Set(t)) else z.paid}}
  action payload(t:int):bool=all {z.paid.contains(t),z'={...z,privateNote:z.privateNote.union(Set(t))}}
  action report(t:int):bool=all {z.paid.contains(t),z.privateNote.contains(t),
    z'={...z,report:z.report.union(Set(t))}}
  action tick=all {z.clock<8,z'={...z,clock:z.clock+1,height:if(z.height<2) z.height+1 else z.height,
    visible0:z.visible0.append(z.clock),visible1:z.visible1.append(z.clock)}}
  action rotate=all {z.epoch==0,z'={...z,epoch:1}}
  action step=any {nondet t=Trades.oneOf();any{reserve(t),prove(t),commit(t),abort(t),outcome(t),apply(t),payload(t),report(t)},tick,rotate,z'=z}
  val conservation=z.cash+z.paid.size()*3==3 and z.held.size()*3<=z.cash
  val backed=z.delivered.forall(t=>z.held.contains(t) or z.paid.contains(t))
  val records=z.report.subseteq(z.paid.intersect(z.privateNote))
  val privacyTime=z.visible0==z.visible1
  val safe=conservation and backed and records and privacyTime
  val noSuccess=z.report==Set()
}

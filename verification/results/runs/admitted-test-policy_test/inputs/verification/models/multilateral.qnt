module multilateral {
  import economic_effects.* from "./economic_effects"
  // Independent security institutions 0 and 2, shared cash institution 1.
  // Trade identities/authorization and authenticated proof soundness are admitted interfaces.
  pure val Trades=Set(1,2)
  pure val Domains=Set(0,1,2)
  pure def securityDomain(t:int):int=if(t==1) 0 else 2
  type State={cash:int,held:Set[int],security:int->int,securityHeld:Set[int],
    delivered:Set[int],paid:Set[int],proof:Set[(int,int,int)],outcomes:Set[(int,int,int)],
    cashReceipts:Set[(int,int)],decision:int->int,known:int->int,heights:int->int,up:Set[int],epoch:int,
    privateNote:Set[int],report:Set[int],clock:int,economicReceipts:Set[Receipt],
    cashReleased:Set[int],securityReleased:Set[int]}
  var z:State
  action init=z'={cash:3,held:Set(),security:Trades.mapBy(_=>2),securityHeld:Set(),delivered:Set(),paid:Set(),
    proof:Set(),outcomes:Set(),cashReceipts:Set(),decision:Trades.mapBy(_=>0),known:Trades.mapBy(_=>0),
    heights:Domains.mapBy(_=>0),up:Domains,epoch:0,privateNote:Set(),report:Set(),clock:0,
    economicReceipts:Set(),cashReleased:Set(),securityReleased:Set()}
  // Explicit local account namespaces. Each trade pays buyer t on its security
  // domain and seller t on cash domain1; reservation owner0 receives release.
  pure def output(t:int,leg:int,kind:int):Receipt = {
    val chain=if(leg==0) securityDomain(t) else 1
    {trade:t,leg:leg,kind:kind,chain:chain,genesis:100+chain,
      asset:if(leg==0) 30 else 40,account:if(kind==0) t else 0,quantity:if(leg==0) 2 else 3}
  }
  // Local cash bank 1. No live read of another institution's decision or height.
  action reserve(t:int):bool=all {z.up.contains(1),z.known.get(t)==0,not(z.held.contains(t)),
    not(z.paid.contains(t)),z.cash-z.held.size()*3>=3,z'={...z,held:z.held.union(Set(t))}}
  action reserveSecurity(t:int):bool=all {z.up.contains(securityDomain(t)),z.decision.get(t)==0,
    z.heights.get(securityDomain(t))<2,z.security.get(t)==2,not(z.securityHeld.contains(t)),
    z'={...z,securityHeld:z.securityHeld.union(Set(t))}}
  action prove(t:int):bool=all {z.up.contains(1),z.held.contains(t),z'={...z,proof:z.proof.union(Set((1,t,3)))}}
  // Local decision/transfer on the applicable security domain, using received authenticated cash preparation.
  action commit(t:int):bool=all {z.up.contains(securityDomain(t)),z.heights.get(securityDomain(t))<2,
    z.decision.get(t)==0,z.proof.contains((1,t,3)),z.securityHeld.contains(t),z.security.get(t)==2,
    z'={...z,security:z.security.set(t,0),securityHeld:z.securityHeld.exclude(Set(t)),
      delivered:z.delivered.union(Set(t)),decision:z.decision.set(t,2),
      economicReceipts:z.economicReceipts.union(Set(output(t,0,0)))}}
  action abort(t:int):bool=all {z.up.contains(securityDomain(t)),z.heights.get(securityDomain(t))>=2,
    z.decision.get(t)==0,z'={...z,decision:z.decision.set(t,3)}}
  action outcome(t:int):bool=all {z.up.contains(securityDomain(t)),z.decision.get(t)>=2,
    z'={...z,outcomes:z.outcomes.union(Set((securityDomain(t),t,z.decision.get(t))))}}
  action learn(t:int,o:int):bool=all {z.up.contains(1),z.outcomes.contains((securityDomain(t),t,o)),
    z'={...z,known:z.known.set(t,o)}}
  // Local B application uses persistent authenticated local knowledge only.
  action apply(t:int):bool=all {z.up.contains(1),z.known.get(t)>=2,z.held.contains(t),
    z'={...z,held:z.held.exclude(Set(t)),cash:z.cash-(if(z.known.get(t)==2) 3 else 0),
      paid:if(z.known.get(t)==2) z.paid.union(Set(t)) else z.paid,
      cashReceipts:if(z.known.get(t)==2) z.cashReceipts.union(Set((1,t))) else z.cashReceipts,
      cashReleased:if(z.known.get(t)==3) z.cashReleased.union(Set(t)) else z.cashReleased,
      economicReceipts:z.economicReceipts.union(Set(output(t,1,if(z.known.get(t)==2) 0 else 1)))}}
  action refundSecurity(t:int):bool=all {z.up.contains(securityDomain(t)),z.decision.get(t)==3,z.securityHeld.contains(t),
    z'={...z,securityHeld:z.securityHeld.exclude(Set(t)),securityReleased:z.securityReleased.union(Set(t)),
      economicReceipts:z.economicReceipts.union(Set(output(t,0,1)))}}
  action payload(t:int):bool=all {z.up.contains(1),z.paid.contains(t),z'={...z,privateNote:z.privateNote.union(Set(t))}}
  action report(t:int):bool=all {z.outcomes.contains((securityDomain(t),t,2)),z.cashReceipts.contains((1,t)),
    z.privateNote.contains(t),z'={...z,report:z.report.union(Set(t))}}
  action tick(domain:int):bool=all {z.up.contains(domain),z.heights.get(domain)<2,z.clock<8,
    z'={...z,clock:z.clock+1,heights:z.heights.setBy(domain,h=>h+1)}}
  action rotate=all {z.epoch==0,z'={...z,epoch:1}}
  action halt(domain:int):bool=z'={...z,up:z.up.exclude(Set(domain))}
  action recover(domain:int):bool=z'={...z,up:z.up.union(Set(domain))}
  action step=any {nondet t=Trades.oneOf();any{reserve(t),reserveSecurity(t),prove(t),commit(t),abort(t),outcome(t),
      learn(t,2),learn(t,3),apply(t),refundSecurity(t),payload(t),report(t)},
    nondet d=Domains.oneOf();any {tick(d),halt(d),recover(d)},rotate,z'=z}
  val conservation=z.cash+z.paid.size()*3==3 and z.held.size()*3<=z.cash and Trades.forall(t=>
    z.security.get(t)+(if(z.delivered.contains(t)) 2 else 0)==2 and (z.securityHeld.contains(t) implies z.security.get(t)==2))
  val backed=z.delivered.forall(t=>z.held.contains(t) or z.paid.contains(t))
  val records=z.report.subseteq(z.paid.intersect(z.privateNote))
  val publicClockBound=z.clock>=0 and z.clock<=8 // no relational privacy claim for this installation
  // Compare actual output fields with independently stated institution/trade
  // terms. This oracle does not call the output constructor.
  val exactEffects=and {
    z.economicReceipts.forall(r=> {
      val domain=if(r.leg==0) securityDomain(r.trade) else 1
      and {Trades.contains(r.trade),Set(0,1).contains(r.leg),Set(0,1).contains(r.kind),
        matches(r,r.trade,r.leg,r.kind,domain,100+domain,if(r.leg==0) 30 else 40,
          if(r.kind==0) r.trade else 0,if(r.leg==0) 2 else 3)}}),
    Trades.forall(t=>and {
      z.economicReceipts.filter(r=>r.trade==t and r.leg==0 and r.kind==0).size()==(if(z.delivered.contains(t)) 1 else 0),
      z.economicReceipts.filter(r=>r.trade==t and r.leg==1 and r.kind==0).size()==(if(z.paid.contains(t)) 1 else 0),
      z.economicReceipts.filter(r=>r.trade==t and r.leg==0 and r.kind==1).size()==(if(z.securityReleased.contains(t)) 1 else 0),
      z.economicReceipts.filter(r=>r.trade==t and r.leg==1 and r.kind==1).size()==(if(z.cashReleased.contains(t)) 1 else 0)})}
  val safe=conservation and backed and records and publicClockBound and exactEffects
  val noSuccess=z.report==Set()
  temporal recovery=eventually(always(z.up==Domains))
  temporal fairness=Domains.forall(d=>tick(d).weakFair(Set(z))) and Trades.forall(t=>and {
    abort(t).weakFair(Set(z)),prove(t).weakFair(Set(z)),outcome(t).weakFair(Set(z)),
    learn(t,2).weakFair(Set(z)),learn(t,3).weakFair(Set(z)),apply(t).weakFair(Set(z)),
    refundSecurity(t).weakFair(Set(z)),payload(t).weakFair(Set(z)),report(t).weakFair(Set(z))})
  temporal progress=(recovery and fairness).implies(Trades.forall(t=>and {
    (z.held.contains(t) or z.securityHeld.contains(t)).leadsTo(z.decision.get(t)>=2),
    (z.decision.get(t)==2).leadsTo(z.paid.contains(t) and z.delivered.contains(t)),
    (z.decision.get(t)==3 and (z.held.contains(t) or z.securityHeld.contains(t))).leadsTo(not(z.held.contains(t)) and not(z.securityHeld.contains(t))),
    (z.decision.get(t)==2).leadsTo(z.report.contains(t))}))
}

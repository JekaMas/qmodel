// Governance refinement of the core's ordered epoch cut. Each source commits
// a local barrier before A activates the new configuration. A delayed proof of
// a finalized old reserve remains usable after the two barriers.
module admission_cutover {
  const EARLY:bool
  pure val legs=Set(0,1)
  type State={sealed:Set[int],observedCuts:Set[int],active:bool,
    finalized:Set[int],received:int->Set[int],renewed:Set[int]}
  var x:State
  // Ghost data, taken at the actual activation edge. Protocol actions never read it.
  var beforeActivation:Set[int]

  action init=all {
    x'={sealed:Set(),observedCuts:Set(),active:false,finalized:Set(),
        received:legs.mapBy(_=>Set()),renewed:Set()},beforeActivation'=Set()
  }
  action firstOrContinue(leg:int):bool=all {
    not(x.finalized.contains(leg)),
    not(x.sealed.contains(leg)) or x.received.get(leg).contains(1-leg),
    x'={...x,finalized:x.finalized.union(Set(leg))},beforeActivation'=beforeActivation
  }
  action deliverReserve(src:int):bool=all {
    x.finalized.contains(src),
    x'={...x,received:x.received.setBy(1-src,seen=>seen.union(Set(src)))},
    beforeActivation'=beforeActivation
  }
  action seal(leg:int):bool=all {not(x.sealed.contains(leg)),
    x'={...x,sealed:x.sealed.union(Set(leg))},beforeActivation'=beforeActivation}
  action deliverCut(leg:int):bool=all {x.sealed.contains(leg),
    x'={...x,observedCuts:x.observedCuts.union(Set(leg))},beforeActivation'=beforeActivation}
  action activate=all {not(x.active),x.observedCuts==legs or (EARLY and x.observedCuts!=Set()),
    x'={...x,active:true},beforeActivation'=x.finalized}
  action fresh(leg:int):bool=all {x.active,x.sealed.contains(leg),
    x'={...x,renewed:x.renewed.union(Set(leg))},beforeActivation'=beforeActivation}
  action idle=all {x'=x,beforeActivation'=beforeActivation}
  action step=any {idle,activate,
    nondet leg=legs.oneOf(); any {firstOrContinue(leg),deliverReserve(leg),seal(leg),deliverCut(leg),fresh(leg)}}
  val noLateFirst=(x.active and beforeActivation==Set()) implies x.finalized==Set()
  val safety=noLateFirst and (x.active implies x.observedCuts==legs) and
    x.observedCuts.subseteq(x.sealed) and legs.forall(l=>x.received.get(l).subseteq(x.finalized))
  temporal governedProgress=(legs.forall(l=>seal(l).weakFair(Set(x)) and
    deliverCut(l).weakFair(Set(x))) and activate.weakFair(Set(x)))
    .implies(eventually(x.active))
}
module cutover_strict {import admission_cutover(EARLY=false).*}
module cutover_early {import admission_cutover(EARLY=true).*}
module cutover_scenarios {
  import admission_cutover(EARLY=false).*
  run delayed=init.then(seal(0)).then(deliverCut(0)).then(firstOrContinue(1))
    .then(seal(1)).then(deliverCut(1)).then(activate)
  run AcknowledgedBarriersAllowDelayedHistoricProofTest=delayed
    .then(deliverReserve(1)).then(firstOrContinue(0)).expect(x.finalized==legs and beforeActivation==Set(1) and safety)
  run UnknownSecondBarrierCannotActivateTest=init.then(seal(0)).then(deliverCut(0)).then(activate.fail())
  run EmptyCutRequiresFreshInstructionTest=init.then(seal(0)).then(seal(1)).then(deliverCut(1)).then(deliverCut(0))
    .then(activate).then(fresh(0)).then(fresh(1)).expect(x.renewed==legs and noLateFirst).then(firstOrContinue(1).fail())
}

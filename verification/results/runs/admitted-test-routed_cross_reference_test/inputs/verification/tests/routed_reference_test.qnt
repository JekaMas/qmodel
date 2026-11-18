// Compare native economic transitions to the executable reference after
// identifying physical chains/accounts with its signed role-specific accounts.
module routed_reference {
  const PLACEMENT:int
  import dvp(N=1,HOST=PLACEMENT,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0) as core from "../models/dvp"
  import routed_settlement as r from "../models/routed_settlement"

  action initial(t:int):bool = all {core::init,r::start(Set(t),1)}
  action sign(p:int):bool = all {core::sign(1,p),r::idle}
  action securityHold(t:int):bool = all {core::openA(1), if (PLACEMENT==3) r::idle else r::reserve(t,0)}
  action cashHold(t:int):bool = all {core::prepareB(1), if (PLACEMENT==3) r::idle else r::reserve(t,1)}
  action finalize(p:int):bool = all {core::finalize(1,p),r::idle}
  action capture(p:int):bool = all {core::capture(1,p),r::idle}
  action prove(p:int):bool = all {core::prove(1,p),r::idle}
  action deliver(p:int):bool = all {core::deliver(1,p),r::idle}
  action publish(p:int):bool = finalize(p).then(capture(p)).then(prove(p)).then(deliver(p))
  action decision(t:int):bool = all {core::commit(1),r::commit(t)}
  action present = all {core::learn(1,2,1),r::idle}
  action applyCash(t:int):bool = all {core::applyB(1),r::pay(t)}

  def sameObservations(t:int):bool = {
    val d = r::terms(t)
    val outcomes = core::s.trades.get(1)
    and {
      r::b.decisions.get(t)==outcomes.decision,
      r::b.balance.get((d.chainA,d.assetA,d.sellerA))==core::s.ownerA,
      r::b.balance.get((d.chainB,d.assetB,d.buyerB))==core::s.ownerB,
      r::b.balance.get((d.chainA,d.assetA,d.buyerA))-2==core::s.receivedA.get(1),
      r::b.balance.get((d.chainB,d.assetB,d.sellerB))-3==core::s.receivedB.get(1),
      r::b.receipts.size()==core::s.economicReceipts.size(),
      r::Legs.forall(l=>and {
        r::seen(r::b,t,l,0)==core::s.economicReceipts.contains(core::economicOutput(1,l,0)),
        r::b.holds.contains((t,l))==(if (l==0) outcomes.holdA==1 else outcomes.holdB==1)}),
      core::safe, r::safety}
  }
  action prepare(t:int):bool = initial(t).then(sign(0)).then(sign(1)).then(securityHold(t)).then(cashHold(t))
  action compareCross(t:int):bool = prepare(t).then(publish(2)).then(decision(t)).expect(sameObservations(t))
    .then(publish(3)).then(present).then(applyCash(t)).expect(sameObservations(t))
  action compareLocal(t:int):bool = prepare(t).then(decision(t)).expect(sameObservations(t))
}
module routed_cross_reference_test {
  import routed_reference(PLACEMENT=0).*
  run PhysicalXHostTest = compareCross(1)
  run PhysicalYHostTest = compareCross(2)
}
module routed_local_reference_test {
  import routed_reference(PLACEMENT=3).*
  run BothAssetsOnXTest = compareLocal(3)
  run BothAssetsOnYTest = compareLocal(4)
}

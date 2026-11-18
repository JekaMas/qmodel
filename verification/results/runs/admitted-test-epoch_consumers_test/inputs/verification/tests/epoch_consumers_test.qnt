// A certified handoff, a restoring B-side reporter and uneven application
// delivery share one execution. Each component frames the other one's state.
module epoch_consumers_test {
  import consumer_inbox_test.* from "./consumer_inbox_test"
  import authority_core(MODE=0) as validators from "./workloads/products/authority"

  action asset(op:bool):bool=all {op,validators::a'=validators::a}
  action quorum(op:bool):bool=all {economic(idle),op}
  action installAndRestore = all {
    rotate,validators::install(0),durable'=durable,visible'=visible.set(otherBank,durable.get(otherBank))
  }
  run oldConfig=all {start,validators::init}
    .then(quorum(validators::executed(0))).then(quorum(validators::finalVote(0,0)))
    .then(quorum(validators::finalVote(1,0))).then(quorum(validators::finalVote(2,0)))
    .then(quorum(validators::accept(0,0,0,2))).then(quorum(validators::approve(0,0)))
    .then(quorum(validators::approve(1,0))).then(quorum(validators::approve(2,0)))
  run priorCommit=oldConfig.then(asset(economic(sign(1,0)))).then(asset(economic(sign(1,1))))
    .then(asset(economic(openA(1)))).then(asset(economic(prepareB(1)))).then(asset(source(2)))
    .then(asset(receive(otherBank,2))).then(asset(economic(deliver(1,2)))).then(asset(economic(commit(1))))
    .then(asset(source(3))).then(asset(source(5))).then(asset(receive(bank,5)))
    .then(asset(restart(otherBank))).then(installAndRestore).then(quorum(validators::verifyHistorical(0)))
    .expect(s.epoch==1 and validators::a.epoch==1 and validators::authoritySafe and
      visible.get(otherBank)==Set(fact(1,2)) and visible.get(bank)==Set(fact(1,5)))
  run DifferentCursorsConvergeAfterCertifiedHandoffTest=priorCommit.then(asset(receive(cash,3)))
    .then(asset(learnCash)).then(asset(economic(applyB(1)))).then(asset(source(6)))
    .then(asset(receive(bank,6))).expect(seesBoth(bank) and not(seesBoth(otherBank)))
    .then(asset(restart(otherBank))).then(asset(restore(otherBank)))
    .then(asset(receive(otherBank,6))).expect(not(seesBoth(otherBank)))
    .then(asset(receive(otherBank,5))).then(asset(receive(otherBank,6)))
    .then(asset(observeBank(0))).then(asset(observeBank(1))).then(asset(economic(reconcile(1))))
    .expect(seesBoth(bank) and seesBoth(otherBank) and evidenceBackedBooking(s,desc(1)) and
      s.trades.get(1).effectsB==1 and s.financialRecords.size()==1)
}

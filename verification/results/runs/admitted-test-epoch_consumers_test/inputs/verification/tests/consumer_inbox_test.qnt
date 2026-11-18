// Deployment refinement of the reference evidence pool. Deliveries to the cash
// authority and the independent bank reporter have different durable receipts.
module consumer_inbox_test {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  import guarantee_oracles.* from "../models/guarantee_oracles"
  type Inboxes=int->Set[Fact]
  var durable:Inboxes
  var visible:Inboxes
  pure val cash=0
  pure val bank=1
  pure val otherBank=2
  pure val recipients=Set(cash,bank,otherBank)
  pure val empty=recipients.mapBy(_=>Set())
  def seesBoth(who:int):bool=Set(fact(1,5),fact(1,6)).subseteq(visible.get(who))
  action start=all {init,durable'=empty,visible'=empty}
  action economic(op:bool):bool=all {op,durable'=durable,visible'=visible}
  action source(p:int):bool=economic(finalize(1,p)).then(economic(capture(1,p))).then(economic(prove(1,p)))
  action receive(who:int,p:int):bool={
    val f=fact(1,p)
    all {recipients.contains(who),deliver(1,p),
      durable'=durable.setBy(who,v=>v.union(Set(f))),visible'=visible.setBy(who,v=>v.union(Set(f)))}
  }
  action restart(who:int):bool=all {idle,durable'=durable,visible'=visible.set(who,Set())}
  action restore(who:int):bool=all {idle,durable'=durable,visible'=visible.set(who,durable.get(who))}
  action learnCash=all {visible.get(cash).contains(fact(1,3)),economic(learn(1,2,1))}
  action observeBank(leg:int):bool=all {visible.get(bank).contains(fact(1,5+leg)),economic(observe(1,leg))}
  run ready=start.then(economic(sign(1,0))).then(economic(sign(1,1))).then(economic(openA(1)))
    .then(economic(prepareB(1))).then(source(2)).then(economic(deliver(1,2))).then(economic(commit(1))).then(source(3))
  run ReporterOnlyCannotReleaseCashTest=ready.then(receive(bank,3)).then(learnCash.fail())
  run cashDone=ready.then(receive(cash,3)).then(restart(cash)).then(restore(cash)).then(learnCash)
    .then(economic(applyB(1))).then(source(5)).then(source(6))
  run CashDeliveryDoesNotInformBankTest=cashDone.then(receive(cash,6)).then(observeBank(1).fail())
  run BankRestoreAndRedeliveryBookOnceTest=cashDone.then(receive(bank,5)).then(observeBank(0))
    .then(receive(cash,6)).then(restart(bank)).then(restore(bank)).then(receive(bank,6)).then(receive(bank,6))
    .then(observeBank(1)).then(economic(reconcile(1))).then(economic(reconcile(1)))
    .expect(evidenceBackedBooking(s,desc(1)) and s.financialRecords.size()==1 and s.trades.get(1).effectsB==1)
}

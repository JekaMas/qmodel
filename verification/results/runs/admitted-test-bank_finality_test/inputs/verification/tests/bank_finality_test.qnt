// The model exposes a cash reservation. The meaning and enforceability of a
// seller's entitlement outside B require signed terms and a bank recovery path.
module bank_finality_test {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  import guarantee_oracles.* from "../models/guarantee_oracles"

  run publish(p:int):bool=finalize(1,p).then(capture(1,p)).then(prove(1,p)).then(deliver(1,p))
  run stalled=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1))
    .then(publish(2)).then(crash(1)).then(commit(1)).then(publish(3))
  val backedDuringHalt=and {
    s.finalized.contains(fact(1,3)),s.receivedA.get(1)==2,s.trades.get(1).holdB==1,
    s.ownerB-reservedB(s)==0,s.receivedB.get(1)==0,s.trades.get(1).effectsB==0,
    s.financialRecords.size()==0,tradeGuarantees(s,desc(1))
  }
  run FinalCommitWithHaltedCashLedgerTest=stalled.expect(backedDuringHalt)
    .then(8.reps(_=>idle.expect(backedDuringHalt))).then(spend(1).fail()).then(applyB(1).fail())
    .then(refund(1,1).fail()).then(reconcile(1).fail())
  run RestoredLedgerPaysReservedAmountOnceTest=stalled.then(recover(1)).then(learn(1,2,1))
    .then(applyB(1)).then(applyB(1).fail()).then(publish(5)).then(publish(6))
    .then(observe(1,0)).then(observe(1,1)).then(reconcile(1))
    .expect(s.receivedB.get(1)==3 and s.trades.get(1).effectsB==1 and evidenceBackedBooking(s,desc(1)))
}

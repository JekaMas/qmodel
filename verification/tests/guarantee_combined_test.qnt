module guarantee_combined_test {
  import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  import guarantee_oracles.* from "../models/guarantee_oracles"

  run held = init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1))
  run preparation = held.then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2))
  run committed = preparation.then(commit(1))
  run outcome = committed.then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3))
  run applied = outcome.then(learn(1,2,1)).then(applyB(1))
  run observed = applied.then(finalize(1,5)).then(capture(1,5)).then(prove(1,5)).then(deliver(1,5)).then(observe(1,0))
    .then(finalize(1,6)).then(capture(1,6)).then(prove(1,6)).then(deliver(1,6)).then(observe(1,1))

  run rotated = preparation.then(rotate).then(exitMember).then(commit(1))
    .then(finalize(1,3)).then(capture(1,3)).then(proveUnadmitted(1,3)).then(deliverUnadmitted(1,3))
    .expect(s.trades.get(1).decision==2 and s.trades.get(1).holdB==1 and
      s.proofs.contains({...fact(1,3),program:0}) and not(receivedFact(s,desc(1),3)))

  // Quint's fail() is a terminal test assertion. Share the exact prefix with
  // the success path to check rejection and legal retry from the same state.
  run UnadmittedOutcomeAfterRotationTest = rotated.then(learn(1,2,1).fail())
  run temporarilyFrozen = rotated.then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,1)).then(freeze(1))
    .expect(s.trades.get(1).decision==2 and s.trades.get(1).holdB==1 and
      s.trades.get(1).effectsA==1 and s.trades.get(1).effectsB==0 and safe and tradeGuarantees(s,desc(1)))
  run FrozenCashApplicationTest = temporarilyFrozen.then(applyB(1).fail())
  run replayed = temporarilyFrozen.then(unfreeze(1)).then(applyB(1)).then(deliver(1,3)).then(learn(1,2,1))
  run DuplicateCashApplicationTest = replayed.then(applyB(1).fail())
  run RotationExitFreezeAndReplayTest = replayed
    .then(finalize(1,5)).then(capture(1,5)).then(prove(1,5)).then(deliver(1,5)).then(observe(1,0))
    .then(finalize(1,6)).then(capture(1,6)).then(prove(1,6)).then(deliver(1,6)).then(observe(1,1))
    .then(reconcile(1)).expect(safe and tradeGuarantees(s,desc(1)) and evidenceBackedBooking(s,desc(1)) and
      s.financialRecords==Set({d:desc(1),outcome:2}))

  run OldEpochCannotSignAnotherTradeTest = preparation.then(rotate)
    .expect(s.admitted and s.epoch==1 and s.trades.get(2).decision==0)
    .then(sign(2,0).fail())

  run RetiredMemberCannotSignAnotherTradeTest = preparation.then(exitMember)
    .expect(not(s.admitted) and s.epoch==0 and s.trades.get(2).decision==0)
    .then(sign(2,0).fail())

  // Freeze represents refusal of the local transfer in this model. The
  // pre-state remains OPEN with both holds and no durable COMMIT effect.
  run localFrozen = preparation.then(freeze(0))
    .expect(s.trades.get(1).decision==1 and s.trades.get(1).holdA==1 and s.trades.get(1).holdB==1 and
      s.ownerA==2 and s.receivedA.get(1)==0 and s.economicReceipts==Set() and
      not(s.included.contains(fact(1,3))) and not(s.included.contains(fact(1,5))))
  run BlockedLocalCommitTest = localFrozen.then(commit(1).fail())
  run LocalCommitRetryTest = localFrozen.then(unfreeze(0)).then(commit(1))
    .expect(s.trades.get(1).decision==2 and s.trades.get(1).effectsA==1 and
      s.ownerA==0 and s.receivedA.get(1)==2 and s.economicReceipts.size()==1 and tradeGuarantees(s,desc(1)))

  run DurableBookingAfterCacheResetTest = observed.then(reconcile(1)).then(crash(3)).then(recover(3))
    .expect(s.trades.get(1).report==0 and s.trades.get(1).stale and
      s.financialRecords==Set({d:desc(1),outcome:2}) and tradeGuarantees(s,desc(1)))
    .then(deliver(1,5)).then(observe(1,0)).then(deliver(1,6)).then(observe(1,1)).then(reconcile(1))
    .expect(s.economicReceipts.size()==2 and s.financialRecords==Set({d:desc(1),outcome:2}) and
      s.trades.get(1).booked==1 and evidenceBackedBooking(s,desc(1)))
}

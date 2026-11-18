module probe {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles as strict from "./guarantee_oracles"
  run signed = init.then(sign(1,0)).then(sign(1,1))

  run toLearn = signed.then(prepareB(1)).then(tick).then(tick).then(abort(1))
    .then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4))
  val abortOnly = s.trades.get(1).decision==3 and s.trades.get(1).holdA==0 and
    s.trades.get(1).holdB==1 and has(s,1,4) and not(has(s,1,3))
  val cashAuthorized = s.trades.get(1).effectsB>0 implies
    (s.trades.get(1).decision==2 and has(s,1,3))

  run WrongPhaseOutcomeTest = toLearn.expect(abortOnly and safe and CDecision)
    .then(learn(1,2,1))
    .expect(not(strict::legOutcomeSound(s,desc(1),1)) and s.trades.get(1).effectsB==0)
    .then(applyB(1))
    .expect(safe and CDecision and not(strict::tradeGuarantees(s,desc(1))) and
      s.trades.get(1).decision==3 and s.trades.get(1).effectsB==1 and not(strict::receivedFact(s,desc(1),3)))
}

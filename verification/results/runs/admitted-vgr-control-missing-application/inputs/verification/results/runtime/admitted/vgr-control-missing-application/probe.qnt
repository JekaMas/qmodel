module probe {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles as strict from "./guarantee_oracles"
  run signed = init.then(sign(1,0)).then(sign(1,1))

  run toObserve = signed.then(openA(1)).then(prepareB(1))
    .then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1))
    .then(finalize(1,5)).then(capture(1,5)).then(prove(1,5)).then(deliver(1,5)).then(observe(1,0))
  val lag = s.trades.get(1).decision==2 and s.trades.get(1).effectsA==1 and
    s.trades.get(1).effectsB==0 and s.trades.get(1).holdB==1 and has(s,1,5) and not(has(s,1,6))
  val commitRecordSound = (s.trades.get(1).report==2 or s.trades.get(1).booked>0) implies
    (s.trades.get(1).decision==2 and s.trades.get(1).effectsA==1 and
     s.trades.get(1).effectsB==1 and has(s,1,5) and has(s,1,6))

  run premature = toObserve.expect(lag and safe and CDecision)
    .then(observe(1,1)).then(reconcile(1))
  run MissingApplicationEvidenceTest = premature
    .expect(lag and safe and CDecision and s.trades.get(1).report==2 and
      not(strict::hasBothApplications(s,desc(1))) and not(strict::commitRecordSound(s,desc(1))) and not(strict::l04IsEvidenced(s,desc(1))))
  run PrematureDurableRowAfterResetTest = premature.then(crash(3)).then(recover(3))
    .expect(s.trades.get(1).report==0 and s.trades.get(1).stale and
      s.financialRecords==Set({d:desc(1),outcome:2}) and not(strict::commitRecordSound(s,desc(1))))
    // Even erasing both evidence flags must leave the bad durable row detectable.
    .expect(not(strict::commitRecordSound({...s,trades:s.trades.set(1,
      {...s.trades.get(1),appliedEvidenceA:false,appliedEvidenceB:false,booked:0})},desc(1))))
}

module probe {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=5).* from "./dvp"
  import guarantee_oracles as strict from "./guarantee_oracles"
  run signed = init.then(sign(1,0)).then(sign(1,1))

  run OmittedLocalDeliveryTest = signed.then(openA(1)).then(prepareB(1))
    .then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1))
    .expect(s.trades.get(1).decision==2 and s.trades.get(1).holdA==1 and s.trades.get(1).effectsA==0 and
      not(strict::legOutcomeSound(s,desc(1),0)))
}

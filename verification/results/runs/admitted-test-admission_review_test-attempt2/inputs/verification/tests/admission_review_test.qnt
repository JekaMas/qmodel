module admission_review_test {
  import dvp(N=8,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  import guarantee_oracles.* from "../models/guarantee_oracles"
  run signedOld=init.then(sign(1,0)).then(sign(1,1))
  action send(t:int,p:int):bool=capture(t,p).then(prove(t,p)).then(deliver(t,p))
  action publish(t:int,p:int):bool=finalize(t,p).then(send(t,p))
  run StaleCashFirstTest=signedOld.then(rotate).then(prepareB(1).fail())
  run StaleSecurityFirstTest=signedOld.then(rotate).then(openA(1).fail())
  run ProvisionalAloneCannotGrantAuthorityTest=signedOld.then(openA(1)).then(rotate)
    .expect(not(s.finalized.contains(fact(1,1)))).then(finalize(1,1).fail())
  run ProvisionalCannotStartRemoteHoldTest=signedOld.then(prepareB(1)).then(rotate).then(openA(1).fail())
  run BothProvisionalCannotMintAuthorityTest=signedOld.then(openA(1)).then(prepareB(1)).then(rotate).then(finalize(1,2).fail())
  run oneOfTwoFinal=signedOld.then(openA(1)).then(prepareB(1)).then(finalize(1,1)).then(rotate)
  run PreviouslyIncludedCashNeedsRemoteFinalProofTest=oneOfTwoFinal.then(finalize(1,2).fail())
  run PreviouslyIncludedCashCanFinalizeAfterProofTest=oneOfTwoFinal.then(send(1,1)).then(publish(1,2))
    .then(commit(1)).expect(tradeGuarantees(s,desc(1)))
  run LocalFinalityIsNotRemoteDeliveryTest=signedOld.then(openA(1)).then(finalize(1,1)).then(rotate).then(prepareB(1).fail())
  run oldA=signedOld.then(openA(1)).then(finalize(1,1)).then(rotate).then(send(1,1)).then(prepareB(1))
  run HistoricAFirstSettlesTest=oldA.then(publish(1,2)).then(commit(1)).then(publish(1,3)).then(learn(1,2,1)).then(applyB(1))
    .then(publish(1,5)).then(publish(1,6)).then(observe(1,0)).then(observe(1,1)).then(reconcile(1))
    .expect(safe and evidenceBackedBooking(s,desc(1)))
  run HistoricBFirstSettlesTest=signedOld.then(prepareB(1)).then(finalize(1,2)).then(rotate)
    .then(send(1,2)).then(openA(1)).then(commit(1)).then(publish(1,3)).then(learn(1,2,1)).then(applyB(1))
    .expect(safe and s.trades.get(1).effectsA==1 and s.trades.get(1).effectsB==1)
  run HistoricExitKeepsPriorObligationTest=signedOld.then(openA(1)).then(finalize(1,1)).then(rotate)
    .then(exitMember).then(send(1,1)).then(prepareB(1)).then(publish(1,2)).then(commit(1))
    .expect(tradeGuarantees(s,desc(1)))
  run ProvisionalOnlyCleansUpTest=signedOld.then(openA(1)).then(rotate).then(tick).then(tick)
    .then(abort(1)).then(publish(1,4)).then(learn(1,3,1)).then(refund(1,0))
    .then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1)).then(recordAbort(1))
    .expect(evidenceBackedBooking(s,desc(1)) and s.trades.get(1).refundsB==0)
  run RenewedTermsSettleTest=init.then(rotate).then(sign(8,0)).then(sign(8,1)).then(openA(8)).then(prepareB(8))
    .then(publish(8,2)).then(commit(8)).then(publish(8,3)).then(learn(8,2,1)).then(applyB(8))
    .then(publish(8,5)).then(publish(8,6)).then(observe(8,0)).then(observe(8,1)).then(reconcile(8))
    .expect(desc(8).epoch==1 and evidenceBackedBooking(s,desc(8)) and safe)
  run OfflineSpendRefusedTest=init.then(crash(1)).then(spend(1).fail())
}
module report_cursor_test {
  import audit_scope(OMIT=0).* from "../models/audit_scope"
  run manifests=init.then(finalizeManifest).then(deliver(2)).then(appendRecord).then(finalizeManifest)
    .then(deliver(3)).then(verify(3)).then(fetchRecord(1)).then(fetchRecord(2)).then(fetchRecord(3)).then(report)
  run LatestSurvivesHistoricalReadTest=manifests.then(verify(2)).then(reportAsOf(2))
    .expect(h.knownHead==3 and h.reportHead==2 and h.complete).then(report).expect(h.reportHead==3 and h.complete and safe)
}
module registration_d_test {
  import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  run reserved=init.then(sign(1,0)).then(sign(1,1)).then(openA(1))
  run ReservationIsNotRegistrationTest=reserved.then(finalize(1,0).fail())
  run DecisionDomainOwnsOpenTest=reserved.then(registerDecision(1)).then(crash(0)).then(finalize(1,0))
    .expect(s.finalized.contains(fact(1,0)))
}

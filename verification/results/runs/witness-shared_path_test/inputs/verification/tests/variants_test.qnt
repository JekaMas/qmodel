module open_test {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  run signBoth=init.then(sign(1,0)).then(sign(1,1))
  run openProof=signBoth.then(openA(1)).then(finalize(1,0)).then(capture(1,0)).then(prove(1,0)).then(deliver(1,0))
  run delayedOpenTest=openProof.then(tick).then(tick).then(abort(1)).then(prepareB(1)).expect(s.trades.get(1).holdB==1 and safe)
  run openProofDeliveredAfterAbortTest=signBoth.then(openA(1)).then(finalize(1,0)).then(capture(1,0)).then(prove(1,0)).then(tick).then(tick).then(abort(1)).then(deliver(1,0)).then(prepareB(1)).expect(s.trades.get(1).holdB==1 and s.trades.get(1).decision==3 and safe)
  run historicalFinalizeAndResolveTest=signBoth.then(openA(1)).then(tick).then(tick).then(abort(1)).then(finalize(1,0)).then(capture(1,0)).then(prove(1,0)).then(deliver(1,0)).then(prepareB(1)).then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1)).then(refund(1,1)).then(refund(1,0)).expect(safe and s.trades.get(1).holdA==3 and s.trades.get(1).holdB==3)
  run knownAbortRejectsTest=openProof.then(tick).then(tick).then(abort(1)).then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1)).then(prepareB(1).fail())
}
module contention_test {
  import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  run competitionTest=init.then(sign(1,0)).then(sign(1,1)).then(sign(2,0)).then(sign(2,1)).then(prepareB(1)).expect(reservedB(s)==3 and safe).then(prepareB(2).fail())
  run alteredProofTest=init.then(sign(1,0)).then(sign(1,1)).then(sign(2,0)).then(sign(2,1)).then(prepareB(1)).then(openA(2)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).expect(not(has(s,2,2))).then(commit(2).fail())
}
module privacy_test {
 import privacy(LEAK=0).* from "../models/privacy"
 run accessRejectsTest=init.then(disclose(3,6,0,1).fail())
 run wrongScopeRejectsTest=init.then(disclose(7,2,5,2).fail())
 run wrongOpeningRejectsTest=init.then(bindDisclosure(2).fail())
 run auditIncompleteTest=init.then(audit(1)).expect(not(p.complete)).then(audit(2)).expect(PScope and p.complete)
 run privatePayloadRecoveryTest=init.then(6.reps(_=>publicSchedule)).expect(p.delivered and not(p.claimedUsable)).then(noteDelivery).expect(PAvailability and p.claimedUsable).then(losePayload).expect(not(p.claimedUsable))
}
module multilateral_test {
 import multilateral.* from "../models/multilateral"
 run threeInstitutionTest=init.then(reserveSecurity(1)).then(reserve(1)).then(prove(1)).then(commit(1)).then(outcome(1)).then(learn(1,2)).then(apply(1)).then(payload(1)).then(report(1)).expect(safe and z.report.contains(1)).then(reserve(2).fail())
 run thirdDomainIndependentTest=init.then(halt(0)).then(reserveSecurity(2)).then(reserve(2)).then(prove(2)).then(commit(2)).then(outcome(2)).then(learn(2,2)).then(apply(2)).then(payload(2)).then(report(2)).expect(safe and z.report.contains(2) and not(z.up.contains(0)))

}

module b_path_test {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run settlementTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(applyA(1)).expect(safe and CDecision and not(noSettlement))
}

module d_path_test {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run settlementTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(applyA(1)).then(learn(1,2,1)).then(applyB(1)).expect(safe and CDecision and not(noSettlement))
}
module policy_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run signed=init.then(sign(1,0)).then(sign(1,1))
 run aRevocationTest=signed.then(revokeLeg(1,0)).then(openA(1).fail())
 run bRevocationTest=signed.then(revokeLeg(1,1)).then(prepareB(1).fail())
 run localPolicyIndependenceTest=signed.then(revokeLeg(1,1)).then(openA(1)).expect(s.trades.get(1).holdA==1 and safe)
 run cashUnsignedTest=init.then(sign(1,0)).then(prepareB(1).fail())
 run abortAccountingTest=signed.then(openA(1)).then(prepareB(1)).then(tick).then(tick).then(abort(1)).then(refund(1,0)).then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1)).then(refund(1,1)).then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1)).then(recordAbort(1)).then(crash(3)).then(recover(3)).then(recordAbort(1)).expect(s.trades.get(1).booked==1 and s.trades.get(1).report==3 and safe)
}
module shared_policy_test {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run frozenCashRollbackTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(freeze(1)).expect(s.trades.get(1).decision==1 and s.receivedA.get(1)==0 and s.receivedB.get(1)==0).then(commit(1).fail())
}
module shared_path_test {
 import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run sharedLedgerTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(commit(1)).expect(safe and CDecision and noLag and not(noSettlement) and desc(1).chainA==desc(1).chainB and desc(1).sellerA==desc(1).sellerB and desc(1).buyerA==desc(1).buyerB)
}
module escrow_path_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run nativeEscrowTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).expect(s.ownerA==0 and s.ownerB==0 and s.vaultA==2 and s.vaultB==3).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,1)).then(applyB(1)).expect(safe and s.vaultA==0 and s.vaultB==0 and not(noSettlement))
}

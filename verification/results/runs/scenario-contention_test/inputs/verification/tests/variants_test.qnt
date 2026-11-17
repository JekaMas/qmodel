module open_test {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
  run signBoth=init.then(sign(1,0)).then(sign(1,1))
  run openProof=signBoth.then(openA(1)).then(finalize(1,0)).then(capture(1,0)).then(prove(1,0)).then(deliver(1,0))
  run delayedOpenTest=openProof.then(tick).then(tick).then(abort(1)).then(prepareB(1)).expect(s.trades.get(1).holdB==1 and safe)
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
 run threeInstitutionTest=init.then(reserve(1)).then(prove(1)).then(commit(1)).then(outcome(1)).then(apply(1)).then(payload(1)).then(report(1)).expect(safe and z.report.contains(1)).then(reserve(2).fail())
}

module b_path_test {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run settlementTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(applyA(1)).expect(safe and CDecision and not(noSettlement))
}

module d_path_test {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run settlementTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(applyA(1)).then(learn(1,2,1)).then(applyB(1)).expect(safe and CDecision and not(noSettlement))
}

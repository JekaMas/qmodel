module d_outage_test {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run prepared=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2))
 run committed=prepared.then(commit(1))
 run returned=committed.then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(learn(1,2,1))
 run decisionHaltRejectsTest=prepared.then(crash(2)).expect(safe and CDecision and s.trades.get(1).decision==1).then(commit(1).fail())
 run decisionRecoveryTest=prepared.then(crash(2)).then(recover(2)).then(commit(1)).expect(safe and CDecision and s.trades.get(1).decision==2)
 run aDelayedTest=returned.then(crash(0)).then(applyB(1)).expect(safe and CDecision and s.trades.get(1).effectsA==0 and s.trades.get(1).effectsB==1).then(recover(0)).then(applyA(1)).expect(safe and not(noSettlement))
 run bDelayedTest=returned.then(crash(1)).then(applyA(1)).expect(safe and CDecision and s.trades.get(1).effectsA==1 and s.trades.get(1).effectsB==0).then(recover(1)).then(applyB(1)).expect(safe and not(noSettlement))
 run outcomeCaptureWaitsForDTest=committed.then(crash(2)).expect(safe and CDecision).then(finalize(1,3).fail())
 run staleProjectionTest=returned.then(applyA(1)).then(applyB(1)).then(crash(3)).then(recover(3)).expect(safe and s.trades.get(1).stale and s.trades.get(1).report==0 and s.trades.get(1).decision==2)
}

module network_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run signed=init.then(sign(1,0)).then(sign(1,1))
 run lostAcknowledgementRestartTest=signed.then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(crash(3)).then(recover(3)).then(resend(1,2)).then(deliver(1,2)).then(commit(1)).expect(safe and someCommit)
 run droppedProofRecoveryTest=signed.then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(lose(1,2)).then(resend(1,2)).then(deliver(1,2)).then(commit(1)).expect(safe)
 run haltARecoveryTest=signed.then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(crash(0)).then(recover(0)).then(commit(1)).expect(safe and someCommit)
 run delayedHistoricalProofUpgradeTest=signed.then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(rotate).then(exitMember).then(deliver(1,2)).then(commit(1)).expect(safe and S13)
}

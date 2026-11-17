module htlc_test {
 import mechanisms(MODE=0,FAULT=0).* from "../models/mechanisms"
 run timedSwapTest=init.then(lockA).then(lockB).then(tick).then(tick).then(claimA).then(boundedTick).then(observe).then(boundedTick).then(claimB).expect(noMixed and not(noSuccess))
 run lateSecretHaltTest=init.then(lockA).then(lockB).then(tick).then(tick).then(claimA).then(4.reps(_=>tick)).then(refundB).expect(not(noMixed))
}
module gpact_test {
 import mechanisms(MODE=1,FAULT=0).* from "../models/mechanisms"
 run rootSignallingTest=init.then(lockA).then(lockB).then(prepEvidence(0)).then(prepEvidence(1)).then(rootCommit).then(signal(0)).then(apply(0)).expect(m.deliveredA and not(m.deliveredB)).then(signal(1)).then(apply(1)).expect(safe and not(noSuccess))
}
module shared_test {
 import mechanisms(MODE=2,FAULT=0).* from "../models/mechanisms"
 run atomicExecutionTest=init.then(lockA).then(lockB).then(shared).expect(safe and sharedAtomic and not(noSuccess))
}
module committee_test {
 import mechanisms(MODE=3,FAULT=0).* from "../models/mechanisms"
 run honestThresholdWitnessTest=init.then(lockA).then(lockB).then(attest).then(acceptCommittee).expect(safe and m.deliveredA and m.lockB and m.committee==Set(0,1,2))
}

module membership_test {
 import membership(BAD=0).* from "../models/membership"
 run admitted=init.then(governanceVote(0,0)).then(governanceVote(0,1)).then(governanceVote(0,2)).then(admit)
 run rotated=admitted.then(prepare(1,0)).then(governanceVote(1,0)).then(governanceVote(1,1)).then(governanceVote(1,2)).then(rotate)
 run pendingExitTest=rotated.then(exitMember).then(apply(1)).expect(safe and u.applications.get(1)==1)
 run oldCredentialTest=rotated.then(prepare(2,0).fail())
 run currentCredentialTest=rotated.then(prepare(2,1)).expect(safe and u.pending.get(2)==1)
 run replayAfterPruningTest=rotated.then(apply(1)).then(prune(0)).then(prepare(1,1).fail())
 run transportCannotAdmitTest=init.then(compromiseTransport).then(attackerVote).then(admit.fail())
 run duplicateInstructionTest=admitted.then(prepare(1,0)).then(prepare(1,0).fail())
}

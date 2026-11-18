module privacy_pipeline_test {
 import privacy_pipeline(LEAK=0).* from "../models/privacy_pipeline"
 run proofReady=init.then(5.reps(_=>advance))
 run boundWorldsTest=proofReady.expect(p.left.proof.witness.position==4 and p.right.proof.witness.position==7 and p.left.proof.root!=p.right.proof.root and p.left.held==3 and p.right.held==3 and safe)
 run unauthorizedPayloadTest=proofReady.then(request(3,3,1,1)).expect(p.releasesL.forall(d=>d.error==403 and d.value== -1) and PAccess)
 run wrongScopePayloadTest=proofReady.then(request(7,3,5,2)).expect(p.releasesL.forall(d=>d.error==403 and d.value== -1) and PAccess)
 run authorizedWitnessTest=proofReady.then(request(4,6,3,1)).expect(p.releasesL.forall(d=>d.error==0 and d.value==4) and p.releasesR.forall(d=>d.error==0 and d.value==7) and PBinding)
 run noteUnavailableTest=proofReady.then(request(0,7,0,1)).expect(p.releasesL.forall(d=>d.error==404 and d.value== -1))
 run retryLinkTest=proofReady.then(advance).expect(p.obsL.nth(4).root==p.obsL.nth(5).root and p.obsR.nth(4).root==p.obsR.nth(5).root and PNI)
 run recoveryAndAuditTest=init.then(12.reps(_=>advance)).expect(completed and p.left.epoch==1 and p.right.epoch==1 and p.releasesL.exists(d=>d.role==7 and d.field==3 and d.value==4) and p.releasesR.exists(d=>d.role==7 and d.field==3 and d.value==7) and safe)
 run keyLossTest=init.then(12.reps(_=>advance)).then(loseKey).expect(not(p.left.usable) and not(p.right.usable) and PAvailability)
}

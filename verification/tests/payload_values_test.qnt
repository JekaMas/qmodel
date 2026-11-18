// Exact returned values and full binding, independent of producer helpers.
module payload_values_test {
 import privacy_pipeline(LEAK=0).* from "../models/privacy_pipeline"
 run field0ExactTest=init.then(5.reps(_=>advance)).then(request(7,0,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==0 and d.error==0 and d.value==1 and d.root==1043 and d.program==1))
 run field1ExactTest=init.then(5.reps(_=>advance)).then(request(7,1,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==1 and d.error==0 and d.value==0 and d.root==1043 and d.program==1))
 run field2ExactTest=init.then(5.reps(_=>advance)).then(request(7,2,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==2 and d.error==0 and d.value==3 and d.root==1043 and d.program==1))
 run field3ExactTest=init.then(5.reps(_=>advance)).then(request(7,3,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==3 and d.error==0 and d.value==4 and d.root==1043 and d.program==1))
 run field4ExactTest=init.then(5.reps(_=>advance)).then(request(7,4,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==4 and d.error==0 and d.value==1 and d.root==1043 and d.program==1))
 run field5ExactTest=init.then(5.reps(_=>advance)).then(request(7,5,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==5 and d.error==0 and d.value==3 and d.root==1043 and d.program==1))
 run field6ExactTest=init.then(5.reps(_=>advance)).then(request(4,6,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==6 and d.error==0 and d.value==4 and d.root==1043 and d.program==1))
 run field7ExactTest=init.then(11.reps(_=>advance)).then(request(0,7,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==7 and d.error==0 and d.value==3 and d.root==1043 and d.program==1))
 run field8ExactTest=init.then(5.reps(_=>advance)).then(request(3,8,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==8 and d.error==0 and d.value==1 and d.root==1043 and d.program==1))
 run field9ExactTest=init.then(5.reps(_=>advance)).then(request(3,9,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==9 and d.error==0 and d.value==1043 and d.root==1043 and d.program==1))
 run field10ExactTest=init.then(5.reps(_=>advance)).then(request(3,10,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==10 and d.error==0 and d.value==1 and d.root==1043 and d.program==1))
 run field11ExactTest=init.then(5.reps(_=>advance)).then(request(3,11,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==11 and d.error==0 and d.value==0 and d.root==1043 and d.program==1))
 run field12ExactTest=init.then(5.reps(_=>advance)).then(request(3,12,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==12 and d.error==0 and d.value==120 and d.root==1043 and d.program==1))
 run field13ExactTest=init.then(5.reps(_=>advance)).then(request(3,13,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==13 and d.error==0 and d.value==2 and d.root==1043 and d.program==1))
 run field14ExactTest=init.then(5.reps(_=>advance)).then(request(3,14,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==14 and d.error==0 and d.value==5 and d.root==1043 and d.program==1))
 run field15ExactTest=init.then(5.reps(_=>advance)).then(request(3,15,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==15 and d.error==0 and d.value==1 and d.root==1043 and d.program==1))
 run deniedIdentityTest=init.then(5.reps(_=>advance)).then(request(3,0,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==0 and d.error==403 and d.value== -1))
 run unavailableNoteTest=init.then(5.reps(_=>advance)).then(request(0,7,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==7 and d.error==404 and d.value== -1 and d.note==emptyPayload.note))
 run downTimeExactTest=init.then(7.reps(_=>advance)).then(request(3,14,0,1)).expect(PBinding and p.releasesL.exists(d=>d.field==14 and d.error==0 and d.value==503))
 run recoveredTimeExactTest=init.then(8.reps(_=>advance)).then(request(3,14,0,1)).expect(PBinding and p.releasesL.exists(d=>d.field==14 and d.error==0 and d.value==8))
}

module field0_probe {
 import privacy_pipeline(LEAK=8).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(7,0,0,1))
  .expect(p.releasesL.exists(d=>d.field==0 and d.error==0 and d.value==0) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field1_probe {
 import privacy_pipeline(LEAK=9).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(7,1,0,1))
  .expect(p.releasesL.exists(d=>d.field==1 and d.error==0 and d.value==1) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field2_probe {
 import privacy_pipeline(LEAK=10).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(7,2,0,1))
  .expect(p.releasesL.exists(d=>d.field==2 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==false)
}

module field3_probe {
 import privacy_pipeline(LEAK=11).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(7,3,0,1))
  .expect(p.releasesL.exists(d=>d.field==3 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==false)
}

module field4_probe {
 import privacy_pipeline(LEAK=12).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(7,4,0,1))
  .expect(p.releasesL.exists(d=>d.field==4 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field5_probe {
 import privacy_pipeline(LEAK=13).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(7,5,0,1))
  .expect(p.releasesL.exists(d=>d.field==5 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field6_probe {
 import privacy_pipeline(LEAK=14).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(4,6,0,1))
  .expect(p.releasesL.exists(d=>d.field==6 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==false)
}

module field7_probe {
 import privacy_pipeline(LEAK=15).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(0,7,0,1))
  .expect(p.releasesL.exists(d=>d.field==7 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==false)
}

module field8_probe {
 import privacy_pipeline(LEAK=16).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,8,0,1))
  .expect(p.releasesL.exists(d=>d.field==8 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field9_probe {
 import privacy_pipeline(LEAK=17).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,9,0,1))
  .expect(p.releasesL.exists(d=>d.field==9 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field10_probe {
 import privacy_pipeline(LEAK=18).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,10,0,1))
  .expect(p.releasesL.exists(d=>d.field==10 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field11_probe {
 import privacy_pipeline(LEAK=19).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,11,0,1))
  .expect(p.releasesL.exists(d=>d.field==11 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field12_probe {
 import privacy_pipeline(LEAK=20).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,12,0,1))
  .expect(p.releasesL.exists(d=>d.field==12 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field13_probe {
 import privacy_pipeline(LEAK=21).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,13,0,1))
  .expect(p.releasesL.exists(d=>d.field==13 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field14_probe {
 import privacy_pipeline(LEAK=22).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,14,0,1))
  .expect(p.releasesL.exists(d=>d.field==14 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

module field15_probe {
 import privacy_pipeline(LEAK=23).* from "./privacy_value_mutants"
 run valueOracleDiscriminatorTest=init.then(5.reps(_=>advance)).then(request(3,15,0,1))
  .expect(p.releasesL.exists(d=>d.field==15 and d.error==0 and d.value==99) and
    PAccess and PNI and PTiming and PBinding==true)
}

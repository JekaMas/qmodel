module program_weak_canonical_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./program_weak_canonical"
 run programAdmissionControlTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).expect(safe and S10 and someCommit)
}

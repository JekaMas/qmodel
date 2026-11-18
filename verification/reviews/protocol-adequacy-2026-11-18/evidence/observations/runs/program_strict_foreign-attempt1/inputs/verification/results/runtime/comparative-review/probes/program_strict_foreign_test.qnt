module program_strict_foreign_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./program_strict_foreign"
 run programAdmissionControlTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).expect(safe and not(someCommit)).then(commit(1).fail())
}

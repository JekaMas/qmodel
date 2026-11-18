module program_weak_foreign_probe {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./program_weak_foreign"
 var pc:int
 action initProbe=all {init,pc'=0}
 action guidedStep=any {
 all {pc==0,sign(1,0),pc'=pc+1},
 all {pc==1,sign(1,1),pc'=pc+1},
 all {pc==2,openA(1),pc'=pc+1},
 all {pc==3,prepareB(1),pc'=pc+1},
 all {pc==4,finalize(1,2),pc'=pc+1},
 all {pc==5,capture(1,2),pc'=pc+1},
 all {pc==6,prove(1,2),pc'=pc+1},
 all {pc==7,deliver(1,2),pc'=pc+1},
 all {pc==8,commit(1),pc'=pc+1},
 all {pc==9,s'=s,pc'=pc}
 }
}

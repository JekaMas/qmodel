// Only the real consumer program-admission gate is removed (MUTANT10).
// Canonical S10 and actual source/proof production remain unchanged.
module admission_b_fault {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=10).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,registerDecision(1),pc'=pc+1},
  all {pc==5,finalize(1,1),pc'=pc+1},
  all {pc==6,capture(1,1),pc'=pc+1},
  all {pc==7,proveUnadmitted(1,1),pc'=pc+1},
  all {pc==8,deliverUnadmitted(1,1),pc'=pc+1},
  all {pc==9,finalize(1,2),pc'=pc+1},
  all {pc==10,capture(1,2),pc'=pc+1},
  all {pc==11,prove(1,2),pc'=pc+1},
  all {pc==12,deliver(1,2),pc'=pc+1},
  all {pc==13,commit(1),pc'=pc+1}
 }
}
module admission_d_security_fault {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=10).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,registerDecision(1),pc'=pc+1},
  all {pc==5,finalize(1,1),pc'=pc+1},
  all {pc==6,capture(1,1),pc'=pc+1},
  all {pc==7,proveUnadmitted(1,1),pc'=pc+1},
  all {pc==8,deliverUnadmitted(1,1),pc'=pc+1},
  all {pc==9,finalize(1,2),pc'=pc+1},
  all {pc==10,capture(1,2),pc'=pc+1},
  all {pc==11,prove(1,2),pc'=pc+1},
  all {pc==12,deliver(1,2),pc'=pc+1},
  all {pc==13,commit(1),pc'=pc+1}
 }
}
module admission_d_cash_fault {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=10).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,registerDecision(1),pc'=pc+1},
  all {pc==5,finalize(1,1),pc'=pc+1},
  all {pc==6,capture(1,1),pc'=pc+1},
  all {pc==7,prove(1,1),pc'=pc+1},
  all {pc==8,deliver(1,1),pc'=pc+1},
  all {pc==9,finalize(1,2),pc'=pc+1},
  all {pc==10,capture(1,2),pc'=pc+1},
  all {pc==11,proveUnadmitted(1,2),pc'=pc+1},
  all {pc==12,deliverUnadmitted(1,2),pc'=pc+1},
  all {pc==13,commit(1),pc'=pc+1}
 }
}

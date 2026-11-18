module payload_field0 {
 import privacy_pipeline(LEAK=8).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,0,0,1)
}

module payload_field1 {
 import privacy_pipeline(LEAK=9).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,1,0,1)
}

module payload_field2 {
 import privacy_pipeline(LEAK=10).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,2,0,1)
}

module payload_field3 {
 import privacy_pipeline(LEAK=11).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,3,0,1)
}

module payload_field4 {
 import privacy_pipeline(LEAK=12).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,4,0,1)
}

module payload_field5 {
 import privacy_pipeline(LEAK=13).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,5,0,1)
}

module payload_field6 {
 import privacy_pipeline(LEAK=14).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(4,6,0,1)
}

module payload_field7 {
 import privacy_pipeline(LEAK=15).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<11) advance else request(0,7,0,1)
}

module payload_field8 {
 import privacy_pipeline(LEAK=16).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,8,0,1)
}

module payload_field9 {
 import privacy_pipeline(LEAK=17).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,9,0,1)
}

module payload_field10 {
 import privacy_pipeline(LEAK=18).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,10,0,1)
}

module payload_field11 {
 import privacy_pipeline(LEAK=19).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,11,0,1)
}

module payload_field12 {
 import privacy_pipeline(LEAK=20).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,12,0,1)
}

module payload_field13 {
 import privacy_pipeline(LEAK=21).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,13,0,1)
}

module payload_field14 {
 import privacy_pipeline(LEAK=22).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,14,0,1)
}

module payload_field15 {
 import privacy_pipeline(LEAK=23).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(3,15,0,1)
}

module payload_root {
 import privacy_pipeline(LEAK=24).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,0,0,1)
}

module payload_program {
 import privacy_pipeline(LEAK=25).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<5) advance else request(7,0,0,1)
}

module note_amount {
 import privacy_pipeline(LEAK=26).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<11) advance else request(0,7,0,1)
}

module note_recipient {
 import privacy_pipeline(LEAK=27).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<11) advance else request(0,7,0,1)
}

module program_admission {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=10).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,proveUnadmitted(1,2),pc'=pc+1},
  all {pc==7,deliverUnadmitted(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1}
 }
}

module premature_absence {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=13).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,captureAbortRecord(1,0),pc'=pc+1},
  all {pc==3,captureAbortRecord(1,1),pc'=pc+1},
  all {pc==4,openA(1),pc'=pc+1},
  all {pc==5,prepareB(1),pc'=pc+1},
  all {pc==6,tick,pc'=pc+1},
  all {pc==7,tick,pc'=pc+1},
  all {pc==8,abort(1),pc'=pc+1},
  all {pc==9,finalize(1,4),pc'=pc+1},
  all {pc==10,capture(1,4),pc'=pc+1},
  all {pc==11,prove(1,4),pc'=pc+1},
  all {pc==12,deliver(1,4),pc'=pc+1},
  all {pc==13,recordAbort(1),pc'=pc+1}
 }
}

module security_recipient {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=11).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,prove(1,2),pc'=pc+1},
  all {pc==7,deliver(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1}
 }
}

module security_asset {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=12).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,prove(1,2),pc'=pc+1},
  all {pc==7,deliver(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1}
 }
}

module cash_recipient {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=15).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,prove(1,2),pc'=pc+1},
  all {pc==7,deliver(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1},
  all {pc==9,finalize(1,3),pc'=pc+1},
  all {pc==10,capture(1,3),pc'=pc+1},
  all {pc==11,prove(1,3),pc'=pc+1},
  all {pc==12,deliver(1,3),pc'=pc+1},
  all {pc==13,learn(1,2,1),pc'=pc+1},
  all {pc==14,applyB(1),pc'=pc+1}
 }
}

module cash_asset {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=16).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,prove(1,2),pc'=pc+1},
  all {pc==7,deliver(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1},
  all {pc==9,finalize(1,3),pc'=pc+1},
  all {pc==10,capture(1,3),pc'=pc+1},
  all {pc==11,prove(1,3),pc'=pc+1},
  all {pc==12,deliver(1,3),pc'=pc+1},
  all {pc==13,learn(1,2,1),pc'=pc+1},
  all {pc==14,applyB(1),pc'=pc+1}
 }
}

module security_refund_recipient {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=14).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,tick,pc'=pc+1},
  all {pc==5,tick,pc'=pc+1},
  all {pc==6,abort(1),pc'=pc+1},
  all {pc==7,refund(1,0),pc'=pc+1}
 }
}

module cash_refund_recipient {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=17).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,tick,pc'=pc+1},
  all {pc==5,tick,pc'=pc+1},
  all {pc==6,abort(1),pc'=pc+1},
  all {pc==7,finalize(1,4),pc'=pc+1},
  all {pc==8,capture(1,4),pc'=pc+1},
  all {pc==9,prove(1,4),pc'=pc+1},
  all {pc==10,deliver(1,4),pc'=pc+1},
  all {pc==11,learn(1,3,1),pc'=pc+1},
  all {pc==12,refund(1,1),pc'=pc+1}
 }
}

module booking_recipient {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=18).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,prove(1,2),pc'=pc+1},
  all {pc==7,deliver(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1},
  all {pc==9,finalize(1,3),pc'=pc+1},
  all {pc==10,capture(1,3),pc'=pc+1},
  all {pc==11,prove(1,3),pc'=pc+1},
  all {pc==12,deliver(1,3),pc'=pc+1},
  all {pc==13,learn(1,2,1),pc'=pc+1},
  all {pc==14,applyB(1),pc'=pc+1},
  all {pc==15,finalize(1,5),pc'=pc+1},
  all {pc==16,capture(1,5),pc'=pc+1},
  all {pc==17,prove(1,5),pc'=pc+1},
  all {pc==18,deliver(1,5),pc'=pc+1},
  all {pc==19,observe(1,0),pc'=pc+1},
  all {pc==20,finalize(1,6),pc'=pc+1},
  all {pc==21,capture(1,6),pc'=pc+1},
  all {pc==22,prove(1,6),pc'=pc+1},
  all {pc==23,deliver(1,6),pc'=pc+1},
  all {pc==24,observe(1,1),pc'=pc+1},
  all {pc==25,reconcile(1),pc'=pc+1}
 }
}

module booking_quantity {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=19).* from "../models/dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {
  all {pc==0,sign(1,0),pc'=pc+1},
  all {pc==1,sign(1,1),pc'=pc+1},
  all {pc==2,openA(1),pc'=pc+1},
  all {pc==3,prepareB(1),pc'=pc+1},
  all {pc==4,finalize(1,2),pc'=pc+1},
  all {pc==5,capture(1,2),pc'=pc+1},
  all {pc==6,prove(1,2),pc'=pc+1},
  all {pc==7,deliver(1,2),pc'=pc+1},
  all {pc==8,commit(1),pc'=pc+1},
  all {pc==9,finalize(1,3),pc'=pc+1},
  all {pc==10,capture(1,3),pc'=pc+1},
  all {pc==11,prove(1,3),pc'=pc+1},
  all {pc==12,deliver(1,3),pc'=pc+1},
  all {pc==13,learn(1,2,1),pc'=pc+1},
  all {pc==14,applyB(1),pc'=pc+1},
  all {pc==15,finalize(1,5),pc'=pc+1},
  all {pc==16,capture(1,5),pc'=pc+1},
  all {pc==17,prove(1,5),pc'=pc+1},
  all {pc==18,deliver(1,5),pc'=pc+1},
  all {pc==19,observe(1,0),pc'=pc+1},
  all {pc==20,finalize(1,6),pc'=pc+1},
  all {pc==21,capture(1,6),pc'=pc+1},
  all {pc==22,prove(1,6),pc'=pc+1},
  all {pc==23,deliver(1,6),pc'=pc+1},
  all {pc==24,observe(1,1),pc'=pc+1},
  all {pc==25,reconcile(1),pc'=pc+1}
 }
}

module abort_guided {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./early_absence_mutant"
 var pc:int
 action initProbe=all {init,pc'=0}
 action guidedStep=any {
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
  all {pc==13,recordAbort(1),pc'=pc+1},
  all {pc==14,s'=s,pc'=pc}
 }
 val weakSafe=safe and CDecision
 val abortedBookingResolved=(s.trades.get(1).decision==3 and s.trades.get(1).booked==1) implies
  (s.trades.get(1).holdA!=1 and s.trades.get(1).holdB!=1)
}

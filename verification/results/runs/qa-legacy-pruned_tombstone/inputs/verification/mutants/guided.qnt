module expiry {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=1).* from "../models/dvp"
  var pc: int
  var bClock:int
  action initGuided = all {init,pc'=0,bClock'=0}
  action stepGuided = all {pc<12,pc'=pc+1,bClock'=if(pc==8 or pc==9) bClock+1 else bClock,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,prepareB(1)},
    all {pc==4,finalize(1,2)},
    all {pc==5,capture(1,2)},
    all {pc==6,prove(1,2)},
    all {pc==7,deliver(1,2)},
    all {pc==8,idle},
    all {pc==9,idle},
    all {pc==10,all {bClock>=D,unsafeRefund(1)}},
    all {pc==11,commit(1)}
  }}
}

module binding {
  import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=2).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<11,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,sign(2,0)},
    all {pc==3,sign(2,1)},
    all {pc==4,prepareB(1)},
    all {pc==5,openA(2)},
    all {pc==6,finalize(1,2)},
    all {pc==7,capture(1,2)},
    all {pc==8,prove(1,2)},
    all {pc==9,deliver(1,2)},
    all {pc==10,commit(2)}
  }}
}

module replay {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=3).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<16,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,prepareB(1)},
    all {pc==4,finalize(1,2)},
    all {pc==5,capture(1,2)},
    all {pc==6,prove(1,2)},
    all {pc==7,deliver(1,2)},
    all {pc==8,commit(1)},
    all {pc==9,finalize(1,3)},
    all {pc==10,capture(1,3)},
    all {pc==11,prove(1,3)},
    all {pc==12,deliver(1,3)},
    all {pc==13,learn(1,2,1)},
    all {pc==14,applyB(1)},
    all {pc==15,applyB(1)}
  }}
}

module reopen {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=4).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<8,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,tick},
    all {pc==4,tick},
    all {pc==5,abort(1)},
    all {pc==6,refund(1,0)},
    all {pc==7,openA(1)}
  }}
}

module non_atomic {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=5).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<9,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,prepareB(1)},
    all {pc==4,finalize(1,2)},
    all {pc==5,capture(1,2)},
    all {pc==6,prove(1,2)},
    all {pc==7,deliver(1,2)},
    all {pc==8,commit(1)}
  }}
}

module relayer_assertion {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=6).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<6,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,prepareB(1)},
    all {pc==4,inject(1,2,0)},
    all {pc==5,commit(1)}
  }}
}

module stale_refund {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=7).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<11,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,prepareB(1)},
    all {pc==4,finalize(1,2)},
    all {pc==5,capture(1,2)},
    all {pc==6,prove(1,2)},
    all {pc==7,deliver(1,2)},
    all {pc==8,commit(1)},
    all {pc==9,crash(3)},
    all {pc==10,unsafeRefund(1)}
  }}
}

module pruned_tombstone {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=8).* from "../models/dvp"
  var pc: int
  action initGuided = all {init,pc'=0}
  action stepGuided = all {pc<10,pc'=pc+1,any {
    all {pc==0,sign(1,0)},
    all {pc==1,sign(1,1)},
    all {pc==2,openA(1)},
    all {pc==3,prepareB(1)},
    all {pc==4,finalize(1,2)},
    all {pc==5,capture(1,2)},
    all {pc==6,prove(1,2)},
    all {pc==7,deliver(1,2)},
    all {pc==8,commit(1)},
    all {pc==9,forgetTerminal(1)}
  }}
}

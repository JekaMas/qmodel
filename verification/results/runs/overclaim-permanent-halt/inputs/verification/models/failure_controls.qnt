module permanent_halt {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 var pc:int
 action initControl=all {init,pc'=0}
 action stepControl=any {all {pc<10,pc'=pc+1,any {
  all {pc==0,sign(1,0)},
  all {pc==1,sign(1,1)},
  all {pc==2,openA(1)},
  all {pc==3,prepareB(1)},
  all {pc==4,finalize(1,2)},
  all {pc==5,capture(1,2)},
  all {pc==6,prove(1,2)},
  all {pc==7,deliver(1,2)},
  all {pc==8,commit(1)},
  all {pc==9,crash(1)}
 }},all {pc==10,pc'=pc,s'=s}}
 temporal unconditional=(s.trades.get(1).decision==2).leadsTo(s.trades.get(1).effectsB==1)
}

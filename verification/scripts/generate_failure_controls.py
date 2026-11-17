from pathlib import Path
steps=['sign(1,0)','sign(1,1)','openA(1)','prepareB(1)','finalize(1,2)','capture(1,2)','prove(1,2)','deliver(1,2)','commit(1)','crash(1)']
s='module permanent_halt {\n import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"\n var pc:int\n action initControl=all {init,pc\'=0}\n action stepControl=any {all {pc<'+str(len(steps))+',pc\'=pc+1,any {\n'+',\n'.join(f'  all {{pc=={i},{a}}}' for i,a in enumerate(steps))+'\n }},all {pc=='+str(len(steps))+',pc\'=pc,s\'=s}}\n temporal unconditional=(s.trades.get(1).decision==2).leadsTo(s.trades.get(1).effectsB==1)\n}\n'
Path('verification/models/failure_controls.qnt').write_text(s)

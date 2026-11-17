// Generated from induction.qnt guard/update relations; source SHA256 f9fa969238298c46bf4e710869a5f2facb70c5e2b57d0a71791d025317ded356
// Safety projection only. No liveness preservation or arbitrary-trade refinement claim.
module mapped {
 const BAD:int
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=BAD).* from "./dvp"
 type Abs={ownerA:int,ownerB:int,holdA:int,holdB:int,paidA:int,paidB:int,receivedA:int,receivedB:int,decision:int,terminal:int,height:int,certificateB:bool,knownB:int,refundA:int,refundB:int}
 pure val initialAbs:Abs={ownerA:2,ownerB:3,holdA:0,holdB:0,paidA:0,paidB:0,receivedA:0,receivedB:0,decision:0,terminal:0,height:0,certificateB:false,knownB:0,refundA:0,refundB:0}
 pure def abs_prepareA(o:Abs,n:Abs):bool=and {o.decision==0,o.holdA==0,o.ownerA>=2,o.height<2,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:1,holdB:o.holdB,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:1,terminal:o.terminal,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_prepareB(o:Abs,n:Abs):bool=and {o.holdB==0,o.knownB==0,o.ownerB>=3,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:o.holdA,holdB:1,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:o.decision,terminal:o.terminal,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_certify(o:Abs,n:Abs):bool=and {o.holdB>=1,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:o.holdA,holdB:o.holdB,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:o.decision,terminal:o.terminal,height:o.height,certificateB:true,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_commit(o:Abs,n:Abs):bool=and {o.decision==1,o.height<2,o.holdA==1,o.certificateB,n=={ownerA:o.ownerA-2,ownerB:o.ownerB,holdA:2,holdB:o.holdB,paidA:o.paidA+1,paidB:o.paidB,receivedA:o.receivedA+2,receivedB:o.receivedB,decision:2,terminal:2,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_abort(o:Abs,n:Abs):bool=and {o.height>=2,o.decision<2,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:o.holdA,holdB:o.holdB,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:3,terminal:3,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_deliver(o:Abs,n:Abs):bool=and {o.decision>=2,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:o.holdA,holdB:o.holdB,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:o.decision,terminal:o.terminal,height:o.height,certificateB:o.certificateB,knownB:o.decision,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_pay(o:Abs,n:Abs):bool=and {o.knownB==2,o.holdB==1,n=={ownerA:o.ownerA,ownerB:o.ownerB-3,holdA:o.holdA,holdB:2,paidA:o.paidA,paidB:o.paidB+1,receivedA:o.receivedA,receivedB:o.receivedB+3,decision:o.decision,terminal:o.terminal,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abs_refundA(o:Abs,n:Abs):bool=and {o.decision==3,o.holdA==1,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:3,holdB:o.holdB,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:o.decision,terminal:o.terminal,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA+1,refundB:o.refundB}}
 pure def abs_refundB(o:Abs,n:Abs):bool=and {o.knownB==3,o.holdB==1,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:o.holdA,holdB:3,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:o.decision,terminal:o.terminal,height:o.height,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB+1}}
 pure def abs_tick(o:Abs,n:Abs):bool=and {o.height<2,n=={ownerA:o.ownerA,ownerB:o.ownerB,holdA:o.holdA,holdB:o.holdB,paidA:o.paidA,paidB:o.paidB,receivedA:o.receivedA,receivedB:o.receivedB,decision:o.decision,terminal:o.terminal,height:o.height+1,certificateB:o.certificateB,knownB:o.knownB,refundA:o.refundA,refundB:o.refundB}}
 pure def abstractNext(o:Abs,n:Abs):bool = or {o==n,abs_prepareA(o,n),abs_prepareB(o,n),abs_certify(o,n),abs_commit(o,n),abs_abort(o,n),abs_deliver(o,n),abs_pay(o,n),abs_refundA(o,n),abs_refundB(o,n),abs_tick(o,n)}
 pure def alpha(x:State):Abs={ownerA:x.ownerA,ownerB:x.ownerB,holdA:x.trades.get(1).holdA,holdB:x.trades.get(1).holdB,paidA:x.trades.get(1).effectsA,paidB:x.trades.get(1).effectsB,receivedA:x.receivedA.get(1),receivedB:x.receivedB.get(1),decision:x.trades.get(1).decision,terminal:x.trades.get(1).oldTerminal,height:x.height,certificateB:has(x,1,2),knownB:x.trades.get(1).knownB,refundA:x.trades.get(1).refundsA,refundB:x.trades.get(1).refundsB}
 pure def abstractDesired(o:Abs):bool=and {o.ownerA>=0,o.ownerB>=0,o.paidA<=1,o.paidB<=1,
    o.decision==2 implies o.paidA==1 and (o.holdB==1 or o.paidB==1),
    not(o.paidA>0 and o.refundB>0),not(o.paidB>0 and o.refundA>0),
    o.terminal==0 or o.decision==o.terminal}
 var previous:Abs
 action initMapped=all {init,previous'=initialAbs}
 action stepMapped=all {step,previous'=alpha(s)}
 val simulation=abstractNext(previous,alpha(s)) and abstractDesired(alpha(s))
}
module mapping {import mapped(BAD=0).*}
module mapping_mutant {import mapped(BAD=1).*}

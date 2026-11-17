// A focused algebraic core: ledger-native holds and atomic A commitment.
// It omits the network, governance and crash layers; no combined induction claim.
module induction {
  var v_ownerA: int
  var v_ownerB: int
  var v_holdA: int
  var v_holdB: int
  var v_paidA: int
  var v_paidB: int
  var v_receivedA: int
  var v_receivedB: int
  var v_decision: int
  var v_terminal: int
  var v_height: int
  var v_certificateB: bool
  var v_knownB: int
  var v_refundA: int
  var v_refundB: int
  action init=all {v_ownerA'=2, v_ownerB'=3, v_holdA'=0, v_holdB'=0, v_paidA'=0, v_paidB'=0, v_receivedA'=0, v_receivedB'=0, v_decision'=0, v_terminal'=0, v_height'=0, v_certificateB'=false, v_knownB'=0, v_refundA'=0, v_refundB'=0}
  action prepareA=all {v_decision==0,v_holdA==0,v_ownerA>=2,v_height<2,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=1, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=1, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action prepareB=all {v_holdB==0,v_knownB==0,v_ownerB>=3,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=1, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action certify=all {v_holdB==1,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=true, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action commit=all {v_decision==1,v_height<2,v_holdA==1,v_certificateB,
    all {v_ownerA'=v_ownerA-2, v_ownerB'=v_ownerB, v_holdA'=2, v_holdB'=v_holdB, v_paidA'=v_paidA+1, v_paidB'=v_paidB, v_receivedA'=v_receivedA+2, v_receivedB'=v_receivedB, v_decision'=2, v_terminal'=2, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action abort=all {v_height>=2,v_decision<2,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=3, v_terminal'=3, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action deliver=all {v_decision>=2,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_decision, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action pay=all {v_knownB==2,v_holdB==1,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB-3, v_holdA'=v_holdA, v_holdB'=2, v_paidA'=v_paidA, v_paidB'=v_paidB+1, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB+3, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action refundA=all {v_decision==3,v_holdA==1,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=3, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA+1, v_refundB'=v_refundB}}
  action refundB=all {v_knownB==3,v_holdB==1,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=3, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB+1}}
  action tick=all {v_height<2,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height+1, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  action step=any {prepareA,prepareB,certify,commit,abort,deliver,pay,refundA,refundB,tick,all {v_ownerA'=v_ownerA, v_ownerB'=v_ownerB, v_holdA'=v_holdA, v_holdB'=v_holdB, v_paidA'=v_paidA, v_paidB'=v_paidB, v_receivedA'=v_receivedA, v_receivedB'=v_receivedB, v_decision'=v_decision, v_terminal'=v_terminal, v_height'=v_height, v_certificateB'=v_certificateB, v_knownB'=v_knownB, v_refundA'=v_refundA, v_refundB'=v_refundB}}
  val TypeOK=and {Set(false,true).contains(v_certificateB),0.to(2).contains(v_ownerA),0.to(3).contains(v_ownerB),0.to(3).contains(v_holdA),0.to(3).contains(v_holdB),
    0.to(1).contains(v_paidA),0.to(1).contains(v_paidB),Set(0,2).contains(v_receivedA),Set(0,3).contains(v_receivedB),
    0.to(3).contains(v_decision),Set(0,2,3).contains(v_terminal),0.to(2).contains(v_height),Set(0,2,3).contains(v_knownB),
    0.to(1).contains(v_refundA),0.to(1).contains(v_refundB)}
  val desired=and {v_ownerA>=0,v_ownerB>=0,v_paidA<=1,v_paidB<=1,
    v_decision==2 implies v_paidA==1 and (v_holdB==1 or v_paidB==1),
    not(v_paidA>0 and v_refundB>0),not(v_paidB>0 and v_refundA>0),
    v_terminal==0 or v_decision==v_terminal}
  val Strengthening=and {v_paidB==1 implies v_decision==2 and v_knownB==2,
    v_ownerA+v_receivedA==2,v_ownerB+v_receivedB==3,
    v_receivedA==v_paidA*2,v_receivedB==v_paidB*3,
    (v_holdA==2) iff v_paidA==1,(v_holdB==2) iff v_paidB==1,
    (v_holdA==3) iff v_refundA==1,(v_holdB==3) iff v_refundB==1,
    v_holdA==1 implies v_ownerA==2,v_holdB==1 implies v_ownerB==3,
    v_decision==0 implies v_holdA==0,
    v_decision==1 implies v_holdA==1,
    v_decision==2 implies v_holdA==2 and v_certificateB,
    v_decision==3 implies v_paidA==0 and v_paidB==0,
    v_knownB==0 or v_knownB==v_decision,
    v_refundA==1 implies v_decision==3,v_refundB==1 implies v_decision==3,
    v_certificateB implies v_holdB>=1,
    v_decision>=2 implies v_terminal==v_decision,
    v_decision<2 implies v_terminal==0}
  val Inductive=TypeOK and desired and Strengthening
}

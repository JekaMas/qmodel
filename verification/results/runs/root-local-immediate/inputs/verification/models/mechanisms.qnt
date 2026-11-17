// These are our abstract representatives, never vendor implementation verification.
module mechanisms {
  const MODE:int // 0 HTLC, 1 narrow root/signalling, 2 shared execution, 3 committee
  const FAULT:int // 1 permanent B halt after secret publication; 2 compromised committee
  type State={time:int,lockA:bool,lockB:bool,deliveredA:bool,deliveredB:bool,
    refundA:bool,refundB:bool,secretPublished:bool,observed:bool,upA:bool,upB:bool,
    decision:int,preparedEvidence:Set[int],known:int->int,committee:Set[int]}
  var m:State
  action init=m'={time:0,lockA:false,lockB:false,deliveredA:false,deliveredB:false,
    refundA:false,refundB:false,secretPublished:false,observed:false,upA:true,upB:true,
    decision:0,preparedEvidence:Set(),known:Map(0->0,1->0),committee:Set()}
  action lockA=all {not(m.lockA),not(m.refundA),not(m.deliveredA),m'={...m,lockA:true}}
  action lockB=all {not(m.lockB),not(m.refundB),not(m.deliveredB),m'={...m,lockB:true}}
  action tick=all {m.time<6,m'={...m,time:m.time+1}}
  // Buyer holds secret, claims security on A before short T_A=3; seller has until T_B=6 on B.
  action claimA=all {MODE==0,m.lockA,m.lockB,m.time<3,m.upA,
    m'={...m,lockA:false,deliveredA:true,secretPublished:true}}
  action observe=all {MODE==0,m.secretPublished,m.upB,m'={...m,observed:true}}
  action claimB=all {MODE==0,m.lockB,m.observed,m.time<6,m.upB,
    m'={...m,lockB:false,deliveredB:true}}
  action refundA=all {MODE==0,m.time>=3,m.lockA,m.upA,m'={...m,lockA:false,refundA:true}}
  action refundB=all {MODE==0,m.time>=6,m.lockB,m.upB,m'={...m,lockB:false,refundB:true}}
  action halt=all {FAULT==1,m'={...m,upB:false}}
  action prepEvidence(leg:int):bool=all {(if(leg==0) m.lockA else m.lockB),m'={...m,preparedEvidence:m.preparedEvidence.union(Set(leg))}}
  action rootCommit=all {MODE==1,m.preparedEvidence==Set(0,1),m.decision==0,m'={...m,decision:2}}
  action rootAbort=all {MODE==1,m.time>=3,m.decision==0,m'={...m,decision:3}}
  action signal(leg:int):bool=all {MODE==1,m.decision>=2,m'={...m,known:m.known.set(leg,m.decision)}}
  action apply(leg:int):bool=all {MODE==1,m.known.get(leg)>=2,(if(leg==0) m.upA else m.upB),
    m'={...m,deliveredA:m.deliveredA or (leg==0 and m.known.get(leg)==2),
      deliveredB:m.deliveredB or (leg==1 and m.known.get(leg)==2),
      refundA:m.refundA or (leg==0 and m.known.get(leg)==3 and m.lockA),
      refundB:m.refundB or (leg==1 and m.known.get(leg)==3 and m.lockB),
      lockA:m.lockA and leg!=0,lockB:m.lockB and leg!=1}}
  action shared=all {MODE==2,m.lockA,m.lockB,m'={...m,deliveredA:true,deliveredB:true,lockA:false,lockB:false,decision:2}}
  action attest=all {MODE==3,m.lockB or FAULT==2,m'={...m,committee:Set(0,1,2)}}
  action acceptCommittee=all {MODE==3,m.committee.size()>=3,m.lockA,m'={...m,deliveredA:true,lockA:false,decision:2}}
  action step=any {lockA,lockB,tick,claimA,observe,claimB,refundA,refundB,halt,
    prepEvidence(0),prepEvidence(1),rootCommit,rootAbort,signal(0),signal(1),apply(0),apply(1),shared,attest,acceptCommittee,m'=m}
  action boundedTick=all {m.time<6,
    (not(m.secretPublished) or m.observed or m.time<4),
    (not(m.observed) or m.deliveredB or m.time<5),m'={...m,time:m.time+1}}
  action boundedStep=any {lockA,lockB,boundedTick,claimA,observe,claimB,refundA,refundB,m'=m}
  val noMixed=not(m.deliveredA and m.refundB) and not(m.deliveredB and m.refundA)
  val backed=m.decision==2 implies (m.lockB or m.deliveredB) and (m.lockA or m.deliveredA)
  val sharedAtomic=m.deliveredA==m.deliveredB
  val safe=noMixed and (MODE==0 or backed)
  temporal rootProgress=(signal(0).weakFair(Set(m)) and signal(1).weakFair(Set(m)) and apply(0).weakFair(Set(m)) and apply(1).weakFair(Set(m))).implies((m.decision==2).leadsTo(m.deliveredA and m.deliveredB))
  val noSuccess=not(m.deliveredA and m.deliveredB)
  // Timing premise for this HTLC representative: secret observation+inclusion before T_B.
  temporal boundedHtlc=(observe.weakFair(Set(m)) and claimB.weakFair(Set(m))).implies(m.deliveredA.leadsTo(m.deliveredB))
}
module htlc {import mechanisms(MODE=0,FAULT=0).*}
module htlc_halt {import mechanisms(MODE=0,FAULT=1).*}
module gpact {import mechanisms(MODE=1,FAULT=0).*}
module shared {import mechanisms(MODE=2,FAULT=0).*}
module committee_honest {import mechanisms(MODE=3,FAULT=0).*}
module committee_compromised {import mechanisms(MODE=3,FAULT=2).*}

module gpact_halt {import mechanisms(MODE=1,FAULT=1).*}

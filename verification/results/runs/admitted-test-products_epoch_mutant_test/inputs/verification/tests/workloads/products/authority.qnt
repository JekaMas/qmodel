// The honest final-vote lock is scoped to a height and survives view change.
// Competing executed statements are valid candidates until authorized.
// This is a final-vote / configuration protocol abstraction.
module authority_core {
  const MODE:int
  pure val Old=0.to(3)
  pure val New=4.to(7)
  pure val Roots=Set(0,1)
  type Lineage = {round:int,epoch:int,currentFault:int,exposed:Set[int],
    locks:int->int,votes:Set[(int,int,int,int)],executed:Set[(int,int,int)],
    accepted:Set[(int,int,int,int)], acceptedUnder:Set[(int,int)], approvals:Set[(int,int)],
    checkpoint:int,restored:int,historical:Set[int]}
  var a:Lineage

  action init = a'={round:0,epoch:0,currentFault:0,exposed:Set(0),
    locks:Old.union(New).mapBy(_=> -1),votes:Set(),executed:Set(),
    accepted:Set(),acceptedUnder:Set(),approvals:Set(),checkpoint: -1,restored: -1,historical:Set()}
  pure def participants(epoch:int):Set[int] = if(epoch==0) Old else New
  pure def economicBody(root:int):int = if(root==0) 2 else 3

  action executed(root:int):bool = all {
    Roots.contains(root),
    a'={...a,executed:a.executed.union(Set((a.epoch,root,economicBody(root))))}
  }
  pure def signedVotes(x:Lineage,epoch:int,round:int,root:int):Set[int] =
    participants(epoch).filter(v=>x.votes.contains((epoch,round,v,root)))

  action finalVote(v:int,root:int):bool = all {
    participants(a.epoch).contains(v), a.executed.contains((a.epoch,root,economicBody(root))),
    a.exposed.contains(v) or a.locks.get(v)== -1 or a.locks.get(v)==root,
    a'={...a,votes:a.votes.union(Set((a.epoch,a.round,v,root))),
      locks:if(a.exposed.contains(v)) a.locks else a.locks.set(v,root)}
  }
  action changeRound = all {a.round==0,a'={...a,round:1,
    locks:if(MODE==1) a.locks.keys().mapBy(_=> -1) else a.locks}}
  action moveFault(v:int):bool = all {
    MODE==2,a.round==1,a.exposed.size()==1,Old.contains(v),v!=a.currentFault,
    a'={...a,currentFault:v,exposed:a.exposed.union(Set(v))}
  }
  action accept(epoch:int,round:int,root:int,effect:int):bool = all {
    (epoch==a.epoch or MODE==4),
    signedVotes(a,epoch,round,root).size()>=3,
    a.executed.contains((epoch,root,effect)) or MODE==5,
    a.epoch==0 or root==a.checkpoint or MODE==3,
    a'={...a,accepted:a.accepted.union(Set((epoch,round,root,effect))),acceptedUnder:a.acceptedUnder.union(Set((epoch,a.epoch)))}
  }

  def certifiedOld(root:int):bool =
    a.accepted.exists(c=>c._1==0 and c._3==root and c._4==economicBody(root))
  action approve(v:int,root:int):bool = all {
    a.epoch==0,Old.contains(v),(certifiedOld(root) or a.exposed.contains(v)),
    a'={...a,approvals:a.approvals.union(Set((v,root)))}
  }
  action install(root:int):bool = all {
    a.epoch==0,(Old.filter(v=>a.approvals.contains((v,root))).size()>=3 and certifiedOld(root)) or MODE==3,
    a'={...a,epoch:1,round:0,checkpoint:root}
  }
  action restore(root:int):bool = all {
    a.epoch==1,root==a.checkpoint or MODE==6,a'={...a,restored:root}
  }
  // The consumer explicitly expects old trade provenance. This is distinct
  // from accepting a new decision statement in the current epoch.
  action verifyHistorical(root:int):bool = all {
    a.epoch==1,certifiedOld(root),root==a.checkpoint,
    a'={...a,historical:a.historical.union(Set(root))}
  }
  val sameHeightAgreement = a.accepted.map(c=>c._3).size()<=1
  val predecessorBound = a.epoch==0 or certifiedOld(a.checkpoint)
  val executionBound = a.accepted.forall(c=>a.executed.contains((c._1,c._3,c._4)))
  val recoveredCheckpoint = a.restored== -1 or a.restored==a.checkpoint
  val currentAcceptance = a.acceptedUnder.forall(pair=>pair._1==pair._2)
  val authoritySafe = currentAcceptance and sameHeightAgreement and predecessorBound and executionBound and recoveredCheckpoint
  action roundStep = any {
    a'=a,changeRound,
    nondet root=Roots.oneOf(); any {
      executed(root),
      nondet v=Old.oneOf(); any {finalVote(v,root),moveFault(v)},
      nondet round=Set(0,1).oneOf(); accept(0,round,root,economicBody(root))
    }
  }
}
module products_authority {import authority_core(MODE=0).*}
module products_reset_locks {import authority_core(MODE=1).*}
module products_mobile_keys {import authority_core(MODE=2).*}

module products_epoch_test {
  import authority_core(MODE=0).*
  run oldReady=init.then(executed(0)).then(finalVote(0,0)).then(finalVote(1,0)).then(finalVote(2,0))
    .then(accept(0,0,0,2))
  run newReady=oldReady.then(approve(0,0)).then(approve(1,0)).then(approve(2,0)).then(install(0))
  run OldHistoryAndNewEpochShareCheckpointTest=newReady.then(restore(0)).then(verifyHistorical(0))
    .then(executed(0)).then(finalVote(4,0)).then(finalVote(5,0)).then(finalVote(6,0)).then(accept(1,0,0,2))
    .expect(authoritySafe and a.historical==Set(0) and a.accepted.size()==2)
  run UnseenOldRoundIsHistoricalOnlyTest=oldReady.then(changeRound)
    .then(finalVote(0,0)).then(finalVote(1,0)).then(finalVote(2,0))
    .then(approve(0,0)).then(approve(1,0)).then(approve(2,0)).then(install(0))
    .then(verifyHistorical(0)).expect(authoritySafe and not(a.accepted.contains((0,1,0,2)))).then(accept(0,1,0,2).fail())
  run IncompatiblePredecessorTest=oldReady.then(approve(0,0)).then(approve(1,0)).then(approve(2,0)).then(install(1).fail())
  run IncompatibleRestoreTest=newReady.then(restore(1).fail())
  run RetiredSignaturesCannotAuthorizeNewWorkTest=newReady.then(accept(0,0,0,2).fail())
  run ExecutionResultIsNotAFreeCertificateFieldTest=newReady.then(executed(0))
    .then(finalVote(4,0)).then(finalVote(5,0)).then(finalVote(6,0)).then(accept(1,0,0,3).fail())
  run DistinctContextNeedsPredecessorTest=newReady.then(executed(1))
    .then(finalVote(4,1)).then(finalVote(5,1)).then(finalVote(6,1)).then(accept(1,0,1,3).fail())
}
module products_epoch_mutant_test {
  import authority_core(MODE=3) as missing
  import authority_core(MODE=4) as stale
  import authority_core(MODE=5) as body
  import authority_core(MODE=6) as restoreFault

  run UncertifiedConfigurationBreaksLineageTest=missing::init.then(missing::install(1))
    .expect(not(missing::predecessorBound))
  run StaleVerifierAcceptsRetiredAuthorityTest=stale::init.then(stale::executed(0))
    .then(stale::finalVote(0,0)).then(stale::finalVote(1,0)).then(stale::finalVote(2,0))
    .then(stale::accept(0,0,0,2)).then(stale::changeRound).then(stale::finalVote(0,0)).then(stale::finalVote(1,0)).then(stale::finalVote(2,0)).then(stale::approve(0,0)).then(stale::approve(1,0))
    .then(stale::approve(2,0)).then(stale::install(0)).expect(not(stale::a.accepted.contains((0,1,0,2)))).then(stale::accept(0,1,0,2))
    .expect(stale::a.epoch==1 and stale::a.accepted.contains((0,1,0,2)) and not(stale::currentAcceptance))
  run SignedRootWithoutExecutedBodyIsDetectedTest=body::init.then(body::executed(0))
    .then(body::finalVote(0,0)).then(body::finalVote(1,0)).then(body::finalVote(2,0)).then(body::accept(0,0,0,3))
    .expect(not(body::executionBound))
  run BadRestoreBreaksRecoveredCheckpointTest=restoreFault::init.then(restoreFault::executed(0))
    .then(restoreFault::finalVote(0,0)).then(restoreFault::finalVote(1,0)).then(restoreFault::finalVote(2,0))
    .then(restoreFault::accept(0,0,0,2)).then(restoreFault::approve(0,0)).then(restoreFault::approve(1,0))
    .then(restoreFault::approve(2,0)).then(restoreFault::install(0)).then(restoreFault::restore(1))
    .expect(not(restoreFault::recoveredCheckpoint))
}

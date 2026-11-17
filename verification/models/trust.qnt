module trust {
  const FAULT:int // 1 quorum equivocation, 2 issuer destruction, 3 verifier takeover, 4 witness loss, 5 retired historical version
  type State={epoch:int,anchors:Set[int],active:bool,pending:bool,hold:int,
    canonicalRoot:int,claimedRoot:int,proofRoot:int,executionValid:bool,checkpoint:int,
    accepted:bool,acceptedRoot:int,acceptedCheckpoint:int,committed:bool,delivered:bool,evidence:bool,submitter:bool,
    committee:bool,transport:bool,custody:bool,upgrade:bool,validator:bool,decrypt:bool,
    rotationSigs:Set[int],signers:Set[int],oldAdmission:bool,preparedEligible:bool,eligible:bool,frozen:bool}
  var g:State
  action init=g'={epoch:0,anchors:Set(0),active:true,pending:false,hold:0,canonicalRoot:1,
    claimedRoot:1,proofRoot:0,executionValid:false,checkpoint:0,accepted:false,acceptedRoot:0,acceptedCheckpoint:0,
    committed:false,delivered:false,evidence:true,submitter:true,committee:true,
    transport:false,custody:false,upgrade:false,validator:false,decrypt:false,
    rotationSigs:Set(),signers:Set(),oldAdmission:false,preparedEligible:false,eligible:true,frozen:false}
  action prepare=all {g.active,g.eligible,not(g.frozen),g.hold==0,g'={...g,pending:true,hold:1,preparedEligible:true}}
  action certificate(root:int):bool=all {g.pending,root==g.canonicalRoot or FAULT==1,
    g'={...g,claimedRoot:root,proofRoot:root,executionValid:true,signers:Set(0,1,2)}}
  action attackerHistory= g'={...g,proofRoot:2,executionValid:true,checkpoint:99,signers:Set(0,1,2)}
  action verify=all {g.executionValid,
    (g.anchors.contains(g.checkpoint) and g.signers.size()>=3 and g.proofRoot==g.claimedRoot) or FAULT==3,
    g'={...g,accepted:true,acceptedRoot:g.proofRoot,acceptedCheckpoint:g.checkpoint}}
  action commit=all {g.accepted,g.hold==1,g.submitter,g'={...g,committed:true}}
  action apply=all {g.committed,g.hold==1,g.evidence,g.submitter,g.committee,not(g.frozen),g.anchors.contains(0),
    g'={...g,delivered:true,hold:2,pending:false}}
  action approveRotation(v:int):bool=all {Set(0,1,2,3).contains(v),g'={...g,rotationSigs:g.rotationSigs.union(Set(v))}}
  action rotate=all {g.epoch==0,g.rotationSigs.size()>=3,g'={...g,epoch:1,anchors:if(FAULT==5) Set(1) else Set(0,1)}}
  action exit=g'={...g,active:false}
  action oldCredentialAdmission=all {g.active,g.epoch==0,g'={...g,oldAdmission:true}}
  action revoke=g'={...g,eligible:false}
  action freeze=g'={...g,frozen:true}
  action unfreeze=g'={...g,frozen:false}
  action breakHold=all {FAULT==2,g.hold==1,g'={...g,hold:0}}
  action loseEvidence=all {FAULT==4,g'={...g,evidence:false}}
  action refuse=all {FAULT==6,g'={...g,committee:false}}
  action loseSubmitter=all {FAULT==7,g'={...g,submitter:false}}
  action transportCompromise=g'={...g,transport:true}
  action step=any {prepare,certificate(1),certificate(2),attackerHistory,verify,commit,apply,rotate,exit,
    revoke,freeze,unfreeze,breakHold,loseEvidence,refuse,loseSubmitter,transportCompromise,nondet v=0.to(7).oneOf();approveRotation(v),g'=g}
  val canonicalAcceptance=g.accepted implies g.acceptedRoot==g.canonicalRoot and g.acceptedCheckpoint==0
  val backed=g.committed implies g.hold==1 or g.delivered
  val historical=g.pending implies g.anchors.contains(0)
  val keySeparation=not(g.custody or g.upgrade or g.validator or g.decrypt)
  val eligibility=g.pending implies g.preparedEligible
  val safe=canonicalAcceptance and backed and historical and keySeparation and eligibility
  val recoverable=g.committed implies g.evidence and g.submitter and g.committee and g.anchors.contains(0)
}
module trust_safe {import trust(FAULT=0).*}
module equivocation {import trust(FAULT=1).*}
module issuer_destruction {import trust(FAULT=2).*}
module verifier_takeover {import trust(FAULT=3).*}
module witness_loss {import trust(FAULT=4).*}
module retired_version {import trust(FAULT=5).*}

module committee_refusal {import trust(FAULT=6).*}
module insufficient_submitters {import trust(FAULT=7).*}

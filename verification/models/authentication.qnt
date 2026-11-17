// Ideal interfaces, not implementations of consensus, ZK, or execution proofs.
module authentication {
 const KIND:int // 0 direct consensus, 1 ZK-wrapped consensus, 2 execution + canonical history
 const FAULT:int // 1 invalid execution finalized by source, 2 attacker-chosen history
 type Certificate={root:int,checkpoint:int,canonical:bool,consensus:bool,zkConsensus:bool,execution:bool,correct:bool}
 type State={source:Certificate,received:Set[Certificate],accepted:Set[Certificate]}
 var a:State
 pure val honest:Certificate={root:1,checkpoint:0,canonical:true,consensus:true,zkConsensus:true,execution:true,correct:true}
 action init=a'={source:honest,received:Set(),accepted:Set()}
 action perturb=all {FAULT>0,a'={...a,source:{root:2,checkpoint:if(FAULT==2) 99 else 0,
  canonical:FAULT!=2,consensus:true,zkConsensus:true,execution:FAULT!=1,correct:FAULT!=1}}}
 action capture=a'={...a,received:a.received.union(Set(a.source))}
 pure def verify(c:Certificate):bool=and {c.canonical,c.checkpoint==0,
   if(KIND==0) c.consensus else if(KIND==1) c.zkConsensus else c.execution and c.consensus}
 action accept(c:Certificate):bool=all {a.received.contains(c),verify(c),a'={...a,accepted:a.accepted.union(Set(c))}}
 action step=any {perturb,capture,nondet c=a.received.oneOf();accept(c),a'=a}
 val canonicalHistory=a.accepted.forall(c=>c.canonical and c.checkpoint==0)
 val executionSafety=a.accepted.forall(c=>c.correct)
 val safe=canonicalHistory and executionSafety
}
module direct {import authentication(KIND=0,FAULT=0).*}
module zk_consensus {import authentication(KIND=1,FAULT=0).*}
module execution {import authentication(KIND=2,FAULT=0).*}
module direct_bad_execution {import authentication(KIND=0,FAULT=1).*}
module zk_bad_execution {import authentication(KIND=1,FAULT=1).*}
module execution_rejects_invalid {import authentication(KIND=2,FAULT=1).*}
module execution_rejects_history {import authentication(KIND=2,FAULT=2).*}

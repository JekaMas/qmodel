module membership {
 const BAD:int // 1 retire verification of pending epoch; 2 forget consumed identities
 type Manifest={institution:int,chain:int,genesis:int,validatorEpoch:int,program:int,hold:int,decision:int}
 pure def manifest(e:int):Manifest={institution:1,chain:10,genesis:110,validatorEpoch:e,program:e+1,hold:50,decision:70}
 type State={current:int,active:bool,history:Set[Manifest],votes:Set[(Manifest,int)],
  pending:int->int,consumed:Set[int],accepted:Set[int],transport:bool,custody:bool,upgrade:bool,decrypt:bool}
 var u:State
 pure val Trades=Set(1,2)
 action init=u'={current:-1,active:false,history:Set(),votes:Set(),pending:Trades.mapBy(_=>-1),
  consumed:Set(),accepted:Set(),transport:false,custody:false,upgrade:false,decrypt:false}
 action governanceVote(e:int,v:int):bool=all {Set(0,1).contains(e),Set(0,1,2,3).contains(v),
  u'={...u,votes:u.votes.union(Set((manifest(e),v)))}}
 // Forged self-registered node signatures never count as accepted predecessor/governance authority.
 action attackerVote=u'={...u,votes:u.votes.union(Set(({...manifest(0),genesis:999},99)))}
 pure def quorum(x:State,e:int):bool=Set(0,1,2,3).filter(v=>x.votes.contains((manifest(e),v))).size()>=3
 action admit=all {u.current== -1,quorum(u,0),u'={...u,current:0,active:true,history:Set(manifest(0))}}
 action rotate=all {u.current==0,u.history.contains(manifest(0)),quorum(u,1),
  u'={...u,current:1,history:u.history.union(Set(manifest(1)))}}
 action prepare(t:int,e:int):bool=all {u.active,e==u.current,not(u.consumed.contains(t)),u.pending.get(t)== -1,
  u'={...u,pending:u.pending.set(t,e),accepted:u.accepted.union(Set(t))}}
 action apply(t:int):bool=all {u.pending.get(t)>=0,u.history.contains(manifest(u.pending.get(t))),
  u'={...u,pending:u.pending.set(t,-1),consumed:u.consumed.union(Set(t))}}
 action exitMember=u'={...u,active:false}
 action prune(e:int):bool=all {not(Trades.exists(t=>u.pending.get(t)==e)) or BAD==1,
  u'={...u,history:u.history.exclude(Set(manifest(e)))}}
 action forget=all {BAD==2,u'={...u,consumed:Set()}}
 action compromiseTransport=u'={...u,transport:true}
 action step=any {nondet e=Set(0,1).oneOf();nondet v=0.to(3).oneOf();governanceVote(e,v),attackerVote,admit,rotate,
  nondet t=Trades.oneOf();nondet e=Set(0,1).oneOf();prepare(t,e),nondet t=Trades.oneOf();apply(t),
  nondet e=Set(0,1).oneOf();prune(e),exitMember,forget,compromiseTransport,u'=u}
 val retained=Trades.forall(t=>u.pending.get(t)<0 or u.history.contains(manifest(u.pending.get(t))))
 val separation=not(u.custody or u.upgrade or u.decrypt)
 val replay=Trades.forall(t=>not(u.consumed.contains(t) and u.pending.get(t)>=0))
 val safe=retained and separation and replay
}
module members_safe {import membership(BAD=0).*}
module retire_pending {import membership(BAD=1).*}

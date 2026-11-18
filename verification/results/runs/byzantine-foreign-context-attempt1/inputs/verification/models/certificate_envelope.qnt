// A fixed signed context has four validators and threshold three.
// Context 0 is the admitted canonical context. Context 1 may have a genuine
// certificate but belongs to another authority/history. This isolates the
// verifier envelope and assumes honest validators never double-vote in scope.
module certificate_envelope {
  const F:int
  const BIND_CONTEXT:bool

  pure val Validators = 0.to(3)
  pure val Contexts = Set(0,1)
  pure val Roots = Set(0,1)
  type Envelope = {faulty:Set[int], votes:Set[(int,int,int)], accepted:Set[(int,int)]}
  var e: Envelope

  action init = {
    nondet faulty=Validators.powerset().filter(group=>group.size()==F).oneOf()
    e'={faulty:faulty,votes:Set(),accepted:Set()}
  }

  action vote(v:int,context:int,root:int):bool = all {
    e.faulty.contains(v) or not(e.votes.exists(x=>x._1==v and x._2==context and x._3!=root)),
    e'={...e,votes:e.votes.union(Set((v,context,root)))}
  }

  def certified(context:int,root:int):bool =
    Validators.filter(v=>e.votes.contains((v,context,root))).size()>=3

  action accept(context:int,root:int):bool = all {
    certified(context,root),
    context==0 or not(BIND_CONTEXT),
    e'={...e,accepted:e.accepted.union(Set((context,root)))}
  }

  action step = any {
    e'=e,
    nondet context=Contexts.oneOf(); nondet root=Roots.oneOf(); any {
      nondet v=Validators.oneOf(); vote(v,context,root),
      accept(context,root)
    }
  }
  val unique = e.accepted.filter(x=>x._1==0).size()<=1
  val boundContext = e.accepted.forall(x=>x._1==0)
  val safe = unique and boundContext
}

module certified_envelope { import certificate_envelope(F=1,BIND_CONTEXT=true).* }
module equivocation_exceeds_threshold { import certificate_envelope(F=2,BIND_CONTEXT=true).* }
module unbound_certified_context { import certificate_envelope(F=1,BIND_CONTEXT=false).* }

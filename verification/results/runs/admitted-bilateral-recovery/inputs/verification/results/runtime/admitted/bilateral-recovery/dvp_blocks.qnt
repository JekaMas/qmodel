// Included transactions share the local block height. The effect of each
// transaction is the actual settlement action on the state left by its predecessor.
module dvp_blocks {
  const COUNT:int
  const FAULT:int
  import dvp(N=COUNT,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0) as ledger from "./dvp"

  pure val Reserve=0
  pure val Settle=1
  pure val Legs=Set(0,1)
  pure val Ids=ledger::Trades
  pure val deadline=ledger::D
  pure def tradeTerms(t:int):ledger::Descriptor=ledger::desc(t)
  def activeSecurity():int=ledger::reservedA(ledger::s)
  type Batch={open:bool,height:int,kind:int,planned:Set[int],pending:Set[int],
    applied:Set[int],shortfall:Set[int],initialFree:int}
  type Blocks={lanes:int->Batch,bHeight:int}
  var blocks:Blocks

  pure val emptyBatch:Batch={open:false,height: -1,kind:Reserve,planned:Set(),pending:Set(),
    applied:Set(),shortfall:Set(),initialFree:0}

  action start=all {ledger::init,blocks'={lanes:Legs.mapBy(_=>emptyBatch),bHeight:0}}
  action waitBlock=all {ledger::idle,blocks'=blocks}
  action authorize(t:int,party:int):bool=all {ledger::sign(t,party),blocks'=blocks}
  action ordinarySpend(leg:int):bool=all {not(lane(leg).open),ledger::spend(leg),blocks'=blocks}
  action expire(t:int):bool=all {ledger::abort(t),blocks'=blocks}
  action takeAbort(t:int):bool=all {ledger::learn(t,3,1),blocks'=blocks}
  action releaseHold(t:int,leg:int):bool=all {ledger::refund(t,leg),blocks'=blocks}
  action readDisposition(t:int,leg:int):bool=all {ledger::captureAbortRecord(t,leg),blocks'=blocks}
  action bookAbort(t:int):bool=all {ledger::recordAbort(t),blocks'=blocks}
  action takeOutcome(t:int):bool=all {ledger::learn(t,2,1),blocks'=blocks}
  action observeEffect(t:int,leg:int):bool=all {ledger::observe(t,leg),blocks'=blocks}
  action bookTrade(t:int):bool=all {ledger::reconcile(t),blocks'=blocks}
  def proofReceived(t:int,p:int):bool=ledger::has(ledger::s,t,p)
  def effectIncluded(t:int,p:int):bool=ledger::s.included.contains(ledger::fact(t,p))
  val sourceState=ledger::s
  val coreSound=ledger::safe and ledger::CDecision

  action proofJob(t:int,p:int,job:int):bool=all {
    blocks'=blocks,
    if(job==1) ledger::capture(t,p)
    else if(job==2) ledger::prove(t,p)
    else all {job==3,ledger::deliver(t,p)}
  }

  pure def amount(leg:int,t:int):int =
    if(leg==0) ledger::desc(t).security else ledger::desc(t).cash
  pure def total(leg:int,ids:Set[int]):int = ids.fold(0,(n,t)=>n+amount(leg,t))
  pure def free(x:ledger::State,leg:int):int =
    if(leg==0) x.ownerA-ledger::reservedA(x) else x.ownerB-ledger::reservedB(x)

  def height(leg:int):int = if(leg==0) ledger::s.height else blocks.bHeight
  def lane(leg:int):Batch = blocks.lanes.get(leg)

  // Reserve inclusion assumes otherwise executable, signed local requests.
  // Funds are deliberately checked per transaction, against live local state.
  pure def reserveReady(x:ledger::State,leg:int,t:int):bool =
    if(leg==0) ledger::canOpen({...x,ownerA:ledger::reservedA(x)+amount(0,t)},t)
    else ledger::authorized(x,t) and ledger::reserveAuthority(x,t,1) and x.eligible.contains((t,1)) and
      x.up.contains(1) and not(x.frozen.contains(1)) and x.trades.get(t).holdB==0 and x.trades.get(t).knownB==0

  pure def settleReady(x:ledger::State,leg:int,t:int):bool =
    if(leg==0) ledger::canCommit(x,t)
    else x.up.contains(1) and x.up.contains(2) and not(x.frozen.contains(1)) and
      x.trades.get(t).knownB==2 and x.trades.get(t).holdB==1

  action openBlock(leg:int,kind:int,ids:Set[int]):bool = all {
    Legs.contains(leg),Set(Reserve,Settle).contains(kind),
    not(lane(leg).open),lane(leg).height<height(leg),
    ids!=Set(),ids.subseteq(ledger::Trades),
    ids.forall(t=>if(kind==Reserve) reserveReady(ledger::s,leg,t) else settleReady(ledger::s,leg,t)),
    ledger::idle,
    blocks'={...blocks,lanes:blocks.lanes.set(leg,{open:true,height:height(leg),kind:kind,
      planned:ids,pending:ids,applied:Set(),shortfall:Set(),initialFree:free(ledger::s,leg)})}
  }

  action actual(leg:int,kind:int,t:int):bool =
    if(kind==Reserve) (if(leg==0) ledger::openA(t) else ledger::prepareB(t))
    else (if(leg==0) ledger::commit(t) else ledger::applyB(t))

  action disposition(leg:int,t:int,accepted:bool):bool = {
    val b=lane(leg)
    blocks'={...blocks,lanes:blocks.lanes.set(leg,{...b,pending:b.pending.exclude(Set(t)),
      applied:if(accepted) b.applied.union(Set(t)) else b.applied,
      shortfall:if(accepted) b.shortfall else b.shortfall.union(Set(t))})}
  }

  action executeTx(leg:int,t:int):bool = {
    val b=lane(leg)
    val chargedTwice=FAULT==2 and b.kind==Settle and free(ledger::s,leg)<amount(leg,t)
    all {
      b.open,b.height==height(leg),b.pending.contains(t),
      any {
        all {not(chargedTwice),actual(leg,b.kind,t),disposition(leg,t,true)},
        all {(b.kind==Reserve and reserveReady(ledger::s,leg,t) and free(ledger::s,leg)<amount(leg,t)) or chargedTwice,
             ledger::idle,disposition(leg,t,false)}
      }
    }
  }

  action sealBlock(leg:int):bool = {
    val b=lane(leg)
    all {
      b.open,(b.pending==Set() or (FAULT==1 and b.applied.size()==1)),
      ledger::idle,blocks'={...blocks,lanes:blocks.lanes.set(leg,{...b,open:false})}
    }
  }

  action nextA=all {not(lane(0).open),ledger::tick,blocks'=blocks}
  action nextB=all {not(lane(1).open),ledger::s.up.contains(1),ledger::idle,
    blocks'={...blocks,bHeight:blocks.bHeight+1}}

  // Only a fact written in the currently open source block waits for that
  // block to seal. Older facts and facts from the other ledger can progress.
  action finalizeSealed(t:int,p:int):bool = {
    val b=lane(if(p==2 or p==6) 1 else 0)
    val fromCurrent=b.open and b.applied.contains(t) and
      (if(b.kind==Reserve) Set(0,1,2).contains(p) else Set(3,5,6).contains(p))
    all {not(fromCurrent),ledger::finalize(t,p),blocks'=blocks}
  }

  def processed(leg:int,kind:int):bool = {
    val b=lane(leg)
    not(b.open) and b.planned!=Set() and b.kind==kind
  }

  // Independently compare the local disposition with the actual source write.
  val blockSound = Legs.forall(leg=>{
    val b=lane(leg)
    and {
      b.planned==b.pending.union(b.applied).union(b.shortfall),
      b.applied.intersect(b.shortfall)==Set(),b.pending.intersect(b.applied.union(b.shortfall))==Set(),
      if(b.open) b.height==height(leg) else b.pending==Set(),
      (b.kind==Settle or b.initialFree>=total(leg,b.planned)) implies b.shortfall==Set(),
      b.shortfall.forall(t=>amount(leg,t)>b.initialFree-total(leg,b.applied)),
      b.applied.forall(t=>{
        val row=ledger::s.trades.get(t)
        if(b.kind==Reserve) (if(leg==0) row.preparedA else row.preparedB)
        else if(leg==0) row.decision==2 and row.effectsA==1 else row.effectsB==1
      })
    }
  })

  action pauseB=all {ledger::crash(1),blocks'=blocks}
  action resumeB=all {ledger::recover(1),blocks'=blocks}
}

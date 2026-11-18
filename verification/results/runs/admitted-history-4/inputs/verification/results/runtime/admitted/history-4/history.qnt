module contract_products {
  import dvp(N=3,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=3).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))
  pure val mode=4
  // Op = (trade, method). Ticket distinguishes invocations of the same
  // durable operation. Event 0 invokes, 1 linearizes, 2 certifies, 3 responds.
  type Op=(int,int)
  type Ticket=(Op,int)
  type Notice=(Op,int,int)
  type Journal={calls:Set[Ticket],durable:Set[Op],finalizedOps:Set[Op],
    cache:Set[Op],backup:Set[Op],fresh:bool,events:List[Notice]}
  var j:Journal

  action historyInit=all {init,j'={calls:Set(),durable:Set(),finalizedOps:Set(),
    cache:Set(),backup:Set(),fresh:true,events:List()}}

  action invokeOp(t:int,method:int,ticket:int):bool = {
    val op=(t,method)
    all {
      not(j.calls.contains((op,ticket))),s'=s,
      j'={...j,calls:j.calls.union(Set((op,ticket))),events:j.events.append((op,ticket,0))}
    }
  }
  action actual(op:Op):bool =
    if(op._2==0) openA(op._1)
    else if(op._2==1) prepareB(op._1)
    else if(op._2==2) commit(op._1)
    else if(op._2==3) applyB(op._1)
    else if(op._2==4) abort(op._1)
    else if(op._2==5 or op._2==6) refund(op._1,op._2-5)
    else reconcile(op._1)

  action effect(t:int,method:int):bool = {
    val op=(t,method)
    all {
      j.calls.exists(c=>c._1==op), not(j.durable.contains(op)) or (mode==4 and method==3),
      if(mode==2 and method==2) s'=s else actual(op),
      j'={...j,durable:j.durable.union(Set(op)),events:j.events.append((op,0,1))}
    }
  }

  pure val phases=Map(0->0,1->2,2->3,3->6,4->4)
  action canonicalEvent(t:int,method:int):bool =
    if(method<=4) finalize(t,phases.get(method))
    else if(method<=6) captureAbortRecord(t,method-5)
    else all {evidenceBackedBooking(s,desc(t)),s'=s}

  action confirmOp(t:int,method:int):bool = {
    val op=(t,method)
    all {j.durable.contains(op),not(j.finalizedOps.contains(op)),canonicalEvent(t,method),
      j'={...j,fresh:false,finalizedOps:j.finalizedOps.union(Set(op)),events:j.events.append((op,0,2))}}
  }

  action reload(t:int,method:int):bool = all {
    s.up.contains(3),j.finalizedOps.contains((t,method)),s'=s,
    j'={...j,cache:j.cache.union(Set((t,method)))}
  }

  action response(t:int,method:int,ticket:int):bool = {
    val op=(t,method)
    all {
      j.calls.contains((op,ticket)),not(j.events.indices().exists(i=>j.events.nth(i)==(op,ticket,3))),s.up.contains(3),j.cache.contains(op) or mode==1,
      s'=s,j'={...j,events:j.events.append((op,ticket,3))}
    }
  }

  action keepBackup=all {s'=s,j'={...j,backup:j.cache}}
  action stopAdapter=all {crash(3),j'={...j,fresh:false,cache:Set()}}
  action recoverAdapter=all {
    recover(3),j'={...j,fresh:false,cache:if(mode==3) j.backup.union(Set((1,3))) else j.backup}
  }
  action caughtUp=all {
    s.up.contains(3),s'=s,j'={...j,cache:j.finalizedOps,fresh:true}
  }

  // This serial-history automaton uses the immutable observed events rather
  // than any cached result flag reserved by the writer.
  pure def legal(notices:List[Notice]):bool = notices.foldl(
    {requests:Set(),performed:Set(),visible:Set(),returned:Set(),valid:true},
    (x,e)=> if(e._3==0) {...x,requests:x.requests.union(Set((e._1,e._2)))}
      else if(e._3==1) {...x,
        valid:x.valid and x.requests.exists(r=>r._1==e._1) and not(x.performed.contains(e._1)),
        performed:x.performed.union(Set(e._1))}
      else if(e._3==2) {...x,valid:x.valid and x.performed.contains(e._1),
        visible:x.visible.union(Set(e._1))}
      else {...x,returned:x.returned.union(Set((e._1,e._2))),
        valid:x.valid and x.requests.contains((e._1,e._2)) and not(x.returned.contains((e._1,e._2))) and x.visible.contains(e._1)}
  ).valid

  def effectObserved(op:Op):bool = {
    val row=s.trades.get(op._1)
    if(op._2==0) row.preparedA
    else if(op._2==1) row.preparedB
    else if(op._2==2) row.decision==2 and row.effectsA==1 and s.receivedA.get(op._1)==2
    else if(op._2==3) row.decision==2 and row.effectsB==1 and s.receivedB.get(op._1)==3
    else if(op._2==4) row.decision==3
    else if(op._2==5) row.refundsA==1
    else if(op._2==6) row.refundsB==1
    else s.financialRecords.contains({d:desc(op._1),outcome:2})
  }
  val actualEffects = j.durable.forall(op=>effectObserved(op))
  val historySafe = sequenceSafe and actualEffects and legal(j.events) and
    j.cache.subseteq(j.finalizedOps) and (j.fresh implies j.cache==j.finalizedOps)
  action requestExactOpen(t:int):bool = requestOpen(t,desc(t))
  action requestExactCash(t:int):bool = requestCash(t,desc(t))
  action executeCore(e:(int,int,int,int)):bool = any {
    all {e._1==0, sign(e._2,e._3)},
    all {e._1==1, openA(e._2)},
    all {e._1==2, prepareB(e._2)},
    all {e._1==3, tick},
    all {e._1==4, finalize(e._2,e._3)},
    all {e._1==5, capture(e._2,e._3)},
    all {e._1==6, prove(e._2,e._3)},
    all {e._1==7, proveUnadmitted(e._2,e._3)},
    all {e._1==8, deliverUnadmitted(e._2,e._3)},
    all {e._1==9, lose(e._2,e._3)},
    all {e._1==10, resend(e._2,e._3)},
    all {e._1==11, deliver(e._2,e._3)},
    all {e._1==12, inject(e._2,e._3,e._4)},
    all {e._1==13, commit(e._2)},
    all {e._1==14, abort(e._2)},
    all {e._1==15, learn(e._2,e._3,e._4)},
    all {e._1==16, applyB(e._2)},
    all {e._1==17, refund(e._2,e._3)},
    all {e._1==18, spend(e._2)},
    all {e._1==19, crash(e._2)},
    all {e._1==20, recover(e._2)},
    all {e._1==21, observe(e._2,e._3)},
    all {e._1==22, reconcile(e._2)},
    all {e._1==23, captureAbortRecord(e._2,e._3)},
    all {e._1==24, recordAbort(e._2)},
    all {e._1==25, rotate},
    all {e._1==26, exitMember},
    all {e._1==27, revoke(e._2)},
    all {e._1==28, revokeLeg(e._2,e._3)},
    all {e._1==29, freeze(e._2)},
    all {e._1==30, unfreeze(e._2)},
    all {e._1==31, prune(e._2,e._3)},
    all {e._1==32, receiveNote(e._2)},
    all {e._1==33, compromiseTransport},
    all {e._1==34, idle},
    all {e._1==35, requestExactOpen(e._2)},
    all {e._1==36, requestExactCash(e._2)},
  }
  action replayEvents(events:List[(int,int,int,int)]):bool = events.length().reps(i=>{
    val decisions = Trades.filter(t=>s.trades.get(t).decision>=2).map(t=>(t,s.trades.get(t).decision))
    val outputs = s.economicReceipts
    val rows = s.financialRecords
    executeFramed(events.nth(i)).expect(sequenceSafe and
      decisions.forall(d=>s.trades.get(d._1).decision==d._2) and
      outputs.subseteq(s.economicReceipts) and rows.subseteq(s.financialRecords))
  })
  action executeFramed(e:(int,int,int,int)):bool = all {executeCore(e),j'=j}
  run signed=historyInit
    .then(replayEvents(List((0,1,0,0),(0,1,1,0),(0,2,0,0),(0,2,1,0))))

  run reserved = signed.then(invokeOp(1,0,1)).then(invokeOp(1,1,1))
    .then(effect(1,1)).then(effect(1,0)).then(confirmOp(1,0)).then(confirmOp(1,1))
    .then(reload(1,0)).then(reload(1,1)).then(response(1,0,1)).then(response(1,1,1))
    .then(keepBackup)
  run prepared=reserved
    .then(replayEvents(List((5,1,2,0),(6,1,2,0),(11,1,2,0))))
  run decided=prepared.then(invokeOp(1,2,1)).then(effect(1,2)).then(confirmOp(1,2))
  run outcomeReady=decided
    .then(replayEvents(List((5,1,3,0),(6,1,3,0),(11,1,3,0),(15,1,2,1))))
  run applied=outcomeReady.then(invokeOp(1,3,1)).then(effect(1,3)).then(confirmOp(1,3))
  run DuplicateActualCashEffectBreaksHistoryTest=applied.then(invokeOp(1,3,2)).then(effect(1,3)).expect(s.receivedB.get(1)==6 and not(legal(j.events)))
}

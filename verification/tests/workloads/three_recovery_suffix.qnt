// Finite mixed-outcome suffix: proof stages for each leg advance only when
// required, but different trades and both ABORT releases interleave freely.
action advanceProof(t:int,p:int):bool = any {
  all {not(s.finalized.contains(fact(t,p))),finalize(t,p)},
  all {not(s.captured.contains(fact(t,p))),capture(t,p)},
  all {not(s.proofs.contains(fact(t,p))),prove(t,p)},
  all {not(s.received.contains(fact(t,p))),deliver(t,p)}
}

action commitWork(t:int):bool = {
  val z=s.trades.get(t)
  any {
    all {not(has(s,t,3)),advanceProof(t,3)},
    all {z.knownB!=2,learn(t,2,1)},
    applyB(t),
    all {z.effectsB==1,not(z.appliedEvidenceA),advanceProof(t,5)},
    all {z.effectsB==1,not(z.appliedEvidenceA),observe(t,0)},
    all {z.appliedEvidenceA,not(z.appliedEvidenceB),advanceProof(t,6)},
    all {z.appliedEvidenceA,not(z.appliedEvidenceB),observe(t,1)},
    all {z.report!=2,reconcile(t)}
  }
}

action abortWork(t:int):bool = {
  val z=s.trades.get(t)
  any {
    all {not(has(s,t,4)),advanceProof(t,4)},
    all {z.knownB!=3,learn(t,3,1)},
    refund(t,0),refund(t,1),
    all {not(hasAbortRecord(s,t,0)),captureAbortRecord(t,0)},
    all {not(hasAbortRecord(s,t,1)),captureAbortRecord(t,1)},
    all {z.report!=3,recordAbort(t)}
  }
}

action work(t:int):bool = all {
  pc==readyPC,pc'=pc,clock'=clock,
  if(s.trades.get(t).decision==2) commitWork(t) else abortWork(t)
}

action afterDecision = all {
  pc==readyPC,pc'=pc,
  any {
    advance,
    all {clock.failures==4, nondet a=Set(1,3,4).oneOf(); stop(a,2)},
    nondet a=Set(1,3,4).oneOf(); restart(a),
    all {s'=s,clock'=clock}
  }
}

action recoveryInit = all {start,pc'=0}
action recoveryStep = any {bootstrap,afterDecision,nondet t=Trades.oneOf(); work(t)}

val complete = pc==readyPC and Trades.forall(t=>evidenceBackedBooking(s,desc(t)))
val incompleteControl = not(complete)
temporal stable = eventually(always(s.up==actors))
temporal fairWork = Trades.forall(t=>work(t).weakFair(Set(s)))
temporal recoveryProgress = (stable and fairWork).implies((pc==readyPC).leadsTo(complete))

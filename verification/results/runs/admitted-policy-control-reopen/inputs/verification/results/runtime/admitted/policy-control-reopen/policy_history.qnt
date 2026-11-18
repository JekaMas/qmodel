// A-hosted phase-2 spine with actual admission, local policy, and decision
// actions. The observer keeps only the preceding transaction's facts. It never
// uses preparedA/B, oldTerminal, canOpen, canCommit or authorized as a witness.
module policy_history {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=4).* from "./dvp"

  type Before = {holds:Set[(int,int)], permissible:Set[(int,int)], terminals:Set[(int,int)]}

  var before: Before

  pure def activeHolds(x:State):Set[(int,int)] = tuples(Trades,Set(0,1)).filter(pair => {
    val z=x.trades.get(pair._1)
    (if(pair._2==0) z.holdA else z.holdB)==1
  })

  pure def permitted(x:State):Set[(int,int)] = x.eligible.filter(pair => and {
    ((x.admitted and desc(pair._1).epoch==x.epoch) or x.received.exists(f=>
      f.d==desc(pair._1) and f.phase==(if(pair._2==0) 2 else 1) and
      x.finalized.contains(f) and x.proofs.contains(f) and x.historical.contains(f.program) and
      f==fact(pair._1,f.phase))),x.up.contains(pair._2),not(x.frozen.contains(pair._2)),
    x.signed.contains((desc(pair._1),0)),x.signed.contains((desc(pair._1),1))
  })

  pure def terminalDecisions(x:State):Set[(int,int)] =
    Trades.filter(t=>x.trades.get(t).decision>=2).map(t=>(t,x.trades.get(t).decision))

  action initial = all {init,before'={holds:Set(),permissible:Set(),terminals:Set()}}

  // Keep the real protocol actions. Include the A-hosted COMMIT proof path,
  // and governance/eligibility interventions before and after preparation.
  action settlement = any {
    sign(1,0),sign(1,1),openA(1),prepareB(1),tick,abort(1),commit(1),idle,
    nondet phase=Set(1,2).oneOf(); any {finalize(1,phase),capture(1,phase),prove(1,phase),deliver(1,phase)},
    rotate,exitMember,
    nondet leg=Set(0,1).oneOf(); any {revokeLeg(1,leg),freeze(leg),unfreeze(leg)}
  }

  action observedStep = all {
    settlement,before'={holds:activeHolds(s),permissible:permitted(s),terminals:terminalDecisions(s)}
  }

  val policyAtAdmission = activeHolds(s).exclude(before.holds).subseteq(before.permissible)
  val immutableOutcome = before.terminals.subseteq(terminalDecisions(s))
  val historySound = policyAtAdmission and immutableOutcome
}

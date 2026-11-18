// Staged with the source-bound three-trade specialization.
// This finite dispatcher covers admission and decision. It retains actual
// phase-2 incremental jobs and local guards, including late proof after ABORT.
module three {
  import dvp(N=3,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val sound = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))

  val allHeld = Trades.forall(t=>s.trades.get(t).holdA==1 and s.trades.get(t).holdB==1)

  // Each proof job has its real action and all dependencies. Repeating an
  // already successful job is a stutter here; the fault profile tests replay.
  action preparationJob(t:int):bool = any {
    all {not(s.finalized.contains(fact(t,2))),finalize(t,2)},
    all {not(s.captured.contains(fact(t,2))),capture(t,2)},
    all {not(s.proofs.contains(fact(t,2))),prove(t,2)},
    all {not(s.received.contains(fact(t,2))),deliver(t,2)}
  }

  action decisionStep = any {
    tick,idle,
    nondet t=Trades.oneOf(); any {
      sign(t,0),sign(t,1),openA(t),prepareB(t),preparationJob(t),commit(t),abort(t)
    }
  }

  temporal decisionFair = tick.weakFair(Set(s)) and Trades.forall(t=>abort(t).weakFair(Set(s)))
  temporal decides = decisionFair.implies(Trades.forall(t=>s.trades.get(t).intent.leadsTo(s.trades.get(t).decision>=2)))
}

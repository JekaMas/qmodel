module recovery {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  // Core configuration: all actors remain up, durable evidence; no losses in step.
  // Eventual-recovery model is the suffix after stabilization, not a real-time bound.
  temporal fairTrade(t:int):bool = and {
    abort(t).weakFair(Set(s)), applyA(t).weakFair(Set(s)),applyB(t).weakFair(Set(s)),
    refund(t,0).weakFair(Set(s)),refund(t,1).weakFair(Set(s)),
    learn(t,2,0).weakFair(Set(s)),learn(t,2,1).weakFair(Set(s)),
    learn(t,3,0).weakFair(Set(s)),learn(t,3,1).weakFair(Set(s)),
    observe(t,0).weakFair(Set(s)),observe(t,1).weakFair(Set(s)),
    reconcile(t).weakFair(Set(s)),recordAbort(t).weakFair(Set(s)),captureAbortRecord(t,0).weakFair(Set(s)),captureAbortRecord(t,1).weakFair(Set(s)),
    0.to(6).forall(p=>and {finalize(t,p).weakFair(Set(s)),capture(t,p).weakFair(Set(s)),
      prove(t,p).weakFair(Set(s)),deliver(t,p).weakFair(Set(s))}) }
  temporal fair = tick.weakFair(Set(s)) and Trades.forall(t=>fairTrade(t))
  temporal L01 = fair.implies(Trades.forall(t=>s.trades.get(t).intent.leadsTo(s.trades.get(t).decision>=2)))
  temporal L02 = fair.implies(Trades.forall(t=>(s.trades.get(t).decision==2).leadsTo(s.trades.get(t).effectsA==1 and s.trades.get(t).effectsB==1)))
  temporal L03 = fair.implies(Trades.forall(t=>(s.trades.get(t).decision==3 and (s.trades.get(t).holdA==1 or s.trades.get(t).holdB==1)).leadsTo(s.trades.get(t).holdA!=1 and s.trades.get(t).holdB!=1)))
  temporal L04 = fair.implies(Trades.forall(t=>(s.trades.get(t).decision>=2).leadsTo(s.trades.get(t).booked==1 and s.trades.get(t).report>=2)))
  temporal progress = L01 and L02 and L03 and L04
  temporal permanentFailure = Trades.forall(t=>(s.trades.get(t).decision==2).leadsTo(s.trades.get(t).effectsB==1))

  action recoveryStep=any {step,crash(1),recover(1),crash(3),recover(3),freeze(1),unfreeze(1)}
  temporal environmentRecovery=eventually(always(s.up==Set(0,1,2,3,4) and s.frozen==Set()))
  temporal recoveryProgress=(environmentRecovery and fair).implies(Trades.forall(t=>and {
    s.trades.get(t).intent.leadsTo(s.trades.get(t).decision>=2),
    (s.trades.get(t).decision==2).leadsTo(s.trades.get(t).effectsA==1 and s.trades.get(t).effectsB==1),
    (s.trades.get(t).decision==3 and (s.trades.get(t).holdA==1 or s.trades.get(t).holdB==1)).leadsTo(s.trades.get(t).holdA!=1 and s.trades.get(t).holdB!=1),
    (s.trades.get(t).decision>=2).leadsTo(s.trades.get(t).booked==1 and s.trades.get(t).report>=2)}))
}

// Recovery configuration without unsolicited A OPEN/local-preparation proof jobs.
module compact_recovery {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  // Core configuration: all actors remain up, durable evidence; no losses in step.
  // Eventual-recovery model is the suffix after stabilization, not a real-time bound.
  temporal fairTrade(t:int):bool = and {
    abort(t).weakFair(Set(s)), applyA(t).weakFair(Set(s)),applyB(t).weakFair(Set(s)),
    refund(t,0).weakFair(Set(s)),refund(t,1).weakFair(Set(s)),
    learn(t,2,0).weakFair(Set(s)),learn(t,2,1).weakFair(Set(s)),
    learn(t,3,0).weakFair(Set(s)),learn(t,3,1).weakFair(Set(s)),
    observe(t,0).weakFair(Set(s)),observe(t,1).weakFair(Set(s)),
    reconcile(t).weakFair(Set(s)),recordAbort(t).weakFair(Set(s)),
    2.to(6).forall(p=>and {finalize(t,p).weakFair(Set(s)),capture(t,p).weakFair(Set(s)),
      prove(t,p).weakFair(Set(s)),deliver(t,p).weakFair(Set(s))}) }
  temporal fair = tick.weakFair(Set(s)) and Trades.forall(t=>fairTrade(t))
  temporal L01 = fair.implies(Trades.forall(t=>s.trades.get(t).intent.leadsTo(s.trades.get(t).decision>=2)))
  temporal L02 = fair.implies(Trades.forall(t=>(s.trades.get(t).decision==2).leadsTo(s.trades.get(t).effectsA==1 and s.trades.get(t).effectsB==1)))
  temporal L03 = fair.implies(Trades.forall(t=>(s.trades.get(t).decision==3 and (s.trades.get(t).holdA==1 or s.trades.get(t).holdB==1)).leadsTo(s.trades.get(t).holdA!=1 and s.trades.get(t).holdB!=1)))
  temporal L04 = fair.implies(Trades.forall(t=>(s.trades.get(t).decision>=2).leadsTo(s.trades.get(t).booked==1 and s.trades.get(t).report>=2)))
  temporal progress = L01 and L02 and L03 and L04
  temporal permanentFailure = Trades.forall(t=>(s.trades.get(t).decision==2).leadsTo(s.trades.get(t).effectsB==1))

  // Reference workflow requests B preparation, terminal outcome and application receipts.
  // It does not request A OPEN/local-preparation proofs, which are only used by other variants.
  action relevantTrade(t:int):bool = any {sign(t,0),sign(t,1),openA(t),prepareB(t),commit(t),abort(t),
    applyA(t),applyB(t),refund(t,0),refund(t,1),learn(t,2,0),learn(t,2,1),learn(t,3,0),learn(t,3,1),
    observe(t,0),observe(t,1),reconcile(t),recordAbort(t),
    nondet p=2.to(6).oneOf();any {finalize(t,p),capture(t,p),prove(t,p),deliver(t,p),resend(t,p)}}
  action relevantStep=any {nondet t=Trades.oneOf();relevantTrade(t),tick,idle}
  action recoveryStep=any {relevantStep,crash(1),recover(1),crash(3),recover(3),freeze(1),unfreeze(1)}
  temporal environmentRecovery=eventually(always(s.up==Set(0,1,2,3,4) and s.frozen==Set()))
  temporal recoveryProgress=(environmentRecovery and fair).implies(Trades.forall(t=>and {
    s.trades.get(t).intent.leadsTo(s.trades.get(t).decision>=2),
    (s.trades.get(t).decision==2).leadsTo(s.trades.get(t).effectsA==1 and s.trades.get(t).effectsB==1),
    (s.trades.get(t).decision==3 and (s.trades.get(t).holdA==1 or s.trades.get(t).holdB==1)).leadsTo(s.trades.get(t).holdA!=1 and s.trades.get(t).holdB!=1),
    (s.trades.get(t).decision>=2).leadsTo(s.trades.get(t).booked==1 and s.trades.get(t).report>=2)}))
}

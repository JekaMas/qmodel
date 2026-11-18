// Staged beside the source-bound funded specialization by repeated_checks.py.
module repeated {
  import dvp(N=7,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))

  // The operational dispatcher includes the loss/prune edges omitted from the
  // normal and general adversarial entries. All actions originate in dvp.
  action operational = any {
    adversarialStep,
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); any {lose(t,p),prune(t,p)}
  }

  def pending(t:int):bool = {
    val z=s.trades.get(t)
    z.decision==1 and z.holdA==1 and z.holdB==1 and z.effectsA==0 and z.effectsB==0
  }

  // Use independent literal quantities and per-trade recipient/account IDs.
  def committedTrade(t:int):bool = {
    val z=s.trades.get(t)
    and {
      z.decision==2,z.effectsA==1,z.effectsB==1,z.refundsA==0,z.refundsB==0,
      s.receivedA.get(t)==2,s.receivedB.get(t)==3,evidenceBackedBooking(s,desc(t)),
      s.economicReceipts.filter(r=>r.trade==t)==Set(
        {trade:t,leg:0,kind:0,chain:10,genesis:110,asset:30,account:t,quantity:2},
        {trade:t,leg:1,kind:0,chain:20,genesis:120,asset:40,account:t,quantity:3})
    }
  }

  def releasedTrade(t:int):bool = {
    val z=s.trades.get(t)
    and {
      z.decision==3,z.holdA==3,z.holdB==3,z.refundsA==1,z.refundsB==1,
      z.effectsA==0,z.effectsB==0,s.receivedA.get(t)==0,s.receivedB.get(t)==0,
      evidenceBackedBooking(s,desc(t)),
      s.economicReceipts.filter(r=>r.trade==t)==Set(
        {trade:t,leg:0,kind:1,chain:10,genesis:110,asset:30,account:0,quantity:2},
        {trade:t,leg:1,kind:1,chain:20,genesis:120,asset:40,account:0,quantity:3})
    }
  }
}

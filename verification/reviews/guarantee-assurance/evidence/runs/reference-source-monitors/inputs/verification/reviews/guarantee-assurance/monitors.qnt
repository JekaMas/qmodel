// Review-only predicates over the unchanged A-hosted native reference.
module guarantee_reference {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../../models/dvp"

  val outcomeEvidenceSound = Trades.forall(t => {
    val z = s.trades.get(t)
    and {
      z.knownA != 0 implies z.knownA == z.decision,
      z.knownB == 2 implies z.decision == 2 and has(s,t,3),
      z.knownB == 3 implies z.decision == 3 and has(s,t,4),
      z.effectsA > 0 implies z.decision == 2,
      z.effectsB > 0 implies z.decision == 2 and has(s,t,3),
      z.refundsA > 0 implies z.decision == 3,
      z.refundsB > 0 implies z.decision == 3 and has(s,t,4)
    }
  })

  val commitRecordSound = Trades.forall(t => {
    val z = s.trades.get(t)
    val committedBooking = s.financialRecords.exists(r => r.d.trade == t and r.outcome == 2)
    (z.report == 2 or committedBooking) implies and {
      z.decision == 2,
      z.effectsA == 1,
      z.effectsB == 1,
      z.holdA == 2,
      z.holdB == 2,
      has(s,t,5),
      has(s,t,6)
    }
  })
}

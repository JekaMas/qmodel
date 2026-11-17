// Source-world diagnostic view. This is not an evidence-only external API:
// acceptedOnSource/decisionRegistered/recipientCashUsable require canonical source
// observations in a real adapter. Off-chain gateway job acceptance is separate.
module report_view {
 const COUNT:int
 const DECISION_HOST:int
 const REQUIRE_OPEN:bool
 const USE_ESCROW:bool
 const PRIVATE_ASSET:bool
 import dvp(N=COUNT,HOST=DECISION_HOST,OPEN_REQUIRED=REQUIRE_OPEN,ESCROW=USE_ESCROW,PRIVATE=PRIVATE_ASSET,MUTANT=0).* from "./dvp"
 type ReportV2={authorizedIntent:bool,acceptedOnSource:bool,decisionRegistered:bool,
  preparedAAtSnapshot:bool,preparedBAtSnapshot:bool,committedAuthenticated:bool,
  appliedAAuthenticated:bool,appliedBAuthenticated:bool,fullyApplied:bool,
  reconciled:bool,staleOrIncomplete:bool,recipientCashUsable:bool}
 pure def finalReport(x:State,t:int):ReportV2={
  val z=x.trades.get(t)
  {...progressReport(x,t),acceptedOnSource:z.intent or z.decision>0,
    decisionRegistered:z.decision>0}
 }
}
module reference_report {
 import report_view(COUNT=1,DECISION_HOST=0,REQUIRE_OPEN=false,USE_ESCROW=false,PRIVATE_ASSET=false).*
}

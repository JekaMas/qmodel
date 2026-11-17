// Source-world diagnostic view. This is not an evidence-only external API:
// acceptedOnSource/decisionRegistered/recipientCashUsable require canonical source
// observations in a real adapter. Off-chain gateway job acceptance is separate.
module report_view {
 const N:int
 const HOST:int
 const OPEN_REQUIRED:bool
 const ESCROW:bool
 const PRIVATE:bool
 import dvp(N=N,HOST=HOST,OPEN_REQUIRED=OPEN_REQUIRED,ESCROW=ESCROW,PRIVATE=PRIVATE,MUTANT=0).* from "./dvp"
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
 import report_view(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false).*
}

// Source-world diagnostic view. This is not an evidence-only external API:
// acceptedOnSource/decisionRegistered/recipientCashUsable require canonical source
// observations in a real adapter. Off-chain gateway job acceptance is separate.
module report_view {
 // One-trade A-hosted native reference. This view adds no state or transitions.
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 type ReportV2={authorizedIntent:bool,acceptedOnSource:bool,decisionRegistered:bool,
  preparedAAtSnapshot:bool,preparedBAtSnapshot:bool,committedAuthenticated:bool,
  appliedAAuthenticated:bool,appliedBAuthenticated:bool,fullyApplied:bool,
  reconciled:bool,staleOrIncomplete:bool,recipientCashUsable:bool}
 pure def finalReport(x:State,t:int):ReportV2={
  val z=x.trades.get(t)
  val base=progressReport(x,t)
  {authorizedIntent:base.authorizedIntent,acceptedOnSource:z.intent or z.decision>0,
   decisionRegistered:z.decision>0,preparedAAtSnapshot:base.preparedAAtSnapshot,
   preparedBAtSnapshot:base.preparedBAtSnapshot,committedAuthenticated:base.committedAuthenticated,
   appliedAAuthenticated:base.appliedAAuthenticated,appliedBAuthenticated:base.appliedBAuthenticated,
   fullyApplied:base.fullyApplied,reconciled:base.reconciled,
   staleOrIncomplete:base.staleOrIncomplete,recipientCashUsable:base.recipientCashUsable}
 }
}

// Small checked product of the paired observation monitor and finite timed pipeline.
// The principal ledger/evidence core is related informally; no general refinement claim.
module integrated {
  import privacy(LEAK=0) as pp from "./privacy"
  import timing(SLACK=20,SLOW=1,FAULT=0) as tt from "./timing"
  action init=all {pp::init,tt::init}
  action advance=all {tt::tick,
    if(pp::p.pc<6 and (pp::p.pc<5 or tt::t.applied.contains(1))) pp::publicSchedule else pp::p'=pp::p}
  action recipient=all {pp::noteDelivery,tt::t'=tt::t}
  action step=any {advance,recipient,all {pp::p'=pp::p,tt::t'=tt::t}}
  val safe=pp::PNI and pp::PTiming and pp::PAvailability and tt::safe
  val noUsability=not(pp::p.claimedUsable)
}

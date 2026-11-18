// Actual two-world reservation/snapshot/proof/disclosure pipeline coupled to the
// public two-trade round-robin worker. Each world constructs its own outputs;
// only elapsed time, queue depth and scheduling inputs are shared. This is not
// a general ledger-to-time refinement or arbitrary-scheduler NI theorem.
module privacy_time {
  const LEAK:int
  import privacy_pipeline(LEAK=LEAK) as pp from "./privacy_pipeline"
  import timing(SLACK=20,SLOW=1,FAULT=0) as tt from "./timing"
  action init=all {pp::init,tt::init}
  action advance=all {tt::tick,
    if(pp::p.pc<12 and (pp::p.pc<9 or tt::t.applied.contains(1)))
      pp::advanceWith(tt::t.time,tt::t.queue.length()) else pp::p'=pp::p}
  action outage=all {tt::correlatedOutage,pp::p'=pp::p}
  action step=any {advance,outage,all {pp::p'=pp::p,tt::t'=tt::t}}
  val safe=pp::safe and tt::safe
  val noUsability=not(pp::completed)
}
module integrated {import privacy_time(LEAK=0).*}
module integrated_leak {import privacy_time(LEAK=2).*}

// Representative combined ledger/evidence/operational/control fault schedule.
// Not a proof of the Cartesian product of topology, policy and privacy variants.
module operational_faults {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 action faults=any {adversarialStep,
  nondet t=Trades.oneOf();nondet p=0.to(6).oneOf();any {lose(t,p),resend(t,p),prune(t,p)}}
}

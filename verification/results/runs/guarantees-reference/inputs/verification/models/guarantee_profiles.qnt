// The selection audit compares the imports and recovery step to the original temporal profiles.
module guarantee_reference {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_two {
  import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_open {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=true,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_b {
  import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_d {
  import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_escrow {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_private {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=true,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_shared {
  import dvp(N=1,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
}

module guarantee_recovery {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"

  val guarantees = Trades.forall(t=>tradeGuarantees(s,desc(t)))
  action recoveryStep=any {step,crash(1),recover(1),crash(3),recover(3),freeze(1),unfreeze(1)}
}

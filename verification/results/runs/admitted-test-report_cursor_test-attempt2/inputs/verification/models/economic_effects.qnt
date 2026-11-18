// Canonical economic output of one local operation. Account IDs are meaningful
// only in their chain/genesis/asset namespace. kind0 delivers; kind1 releases or
// returns an actual reservation to its original owner (native hold or escrow).
module economic_effects {
  type Receipt={trade:int,leg:int,kind:int,chain:int,genesis:int,asset:int,account:int,quantity:int}
  // Oracle comparison only. Producers construct their own receipts; they do not
  // call this function to derive expected output from their returned output.
  pure def matches(r:Receipt,t:int,leg:int,kind:int,chain:int,genesis:int,
    asset:int,account:int,quantity:int):bool = and {
      r.trade==t,r.leg==leg,r.kind==kind,r.chain==chain,r.genesis==genesis,
      r.asset==asset,r.account==account,r.quantity==quantity}
}

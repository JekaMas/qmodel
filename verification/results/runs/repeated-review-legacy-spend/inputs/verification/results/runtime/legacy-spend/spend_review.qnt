module spend_review {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  run LegacyOfflineSpendTest = init.then(crash(1)).expect(not(s.up.contains(1)) and s.ownerB==3)
    .then(spend(1)).expect(safe and not(s.up.contains(1)) and s.ownerB==2 and s.spentB==1)
}

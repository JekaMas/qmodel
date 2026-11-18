// Finalized native operations on two physical ledgers. Authenticated proof
// presentation can lag issuance indefinitely. See SPECIFICATION.md for the cut.
module routed_settlement {
  import dvp(N=6,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0) as reference from "./dvp"
  import economic_effects as econ from "./economic_effects"

  pure val X = 10
  pure val Y = 20
  pure val Legs = Set(0,1) // 0 securities, 1 cash
  pure val Networks = Set(X,Y)
  pure val XtoY = 1
  pure val YtoX = 2
  pure val LocalX = 3
  pure val LocalY = 4
  pure val AnotherXtoY = 5
  pure val AnotherYtoX = 6
  // Native token addresses and user numbers deliberately overlap across networks.
  pure def terms(t:int):reference::Descriptor = {
    val host = if (Set(YtoX,LocalY,AnotherYtoX).contains(t)) Y else X
    val cashNet = if (Set(XtoY,LocalY,AnotherXtoY).contains(t)) Y else X
    val seller = if (Set(YtoX,AnotherYtoX).contains(t)) 1 else 0
    { ...reference::desc(t), chainA:host, genesisA:100+host, chainB:cashNet,
      genesisB:100+cashNet, decisionDomain:host, sellerA:seller, buyerA:1-seller,
      buyerB:1-seller, sellerB:seller }
  }
  pure def local(t:int):bool = terms(t).chainA == terms(t).chainB
  pure def network(t:int,l:int):int = if (l==0) terms(t).chainA else terms(t).chainB
  pure def payer(t:int,l:int):int = if (l==0) terms(t).sellerA else terms(t).buyerB
  pure def receiver(t:int,l:int):int = if (l==0) terms(t).buyerA else terms(t).sellerB
  pure def quantity(t:int,l:int):int = if (l==0) terms(t).security else terms(t).cash
  type Account = (int,int,int) // physical network, native asset, owner
  pure def asset(t:int,l:int):int = if (l==0) terms(t).assetA else terms(t).assetB
  pure def key(t:int,l:int,a:int):Account = (network(t,l),asset(t,l),a)
  pure val Accounts = tuples(Networks,Set(30,40),Set(0,1))
  type Proof = {d:reference::Descriptor, phase:int, source:int, genesis:int, contract:int}
  pure def cert(t:int,p:int):Proof = {
    val d = terms(t)
    {d:d,phase:p,source:if (p==2) d.chainB else d.chainA,
     genesis:if (p==2) d.genesisB else d.genesisA,
     contract:if (p==2) d.holdB else d.decisionContract}
  }
  type Book = {active:Set[int], lots:int, online:Set[int], balance:Account->int,
    holds:Set[(int,int)], decisions:int->int, finalProofs:Set[Proof], receipts:Set[econ::Receipt]}
  var b:Book
  pure def opening(a:Account,lots:int):int = lots * (if (a._2==30) 2 else 3)
  action start(ids:Set[int],lots:int):bool = b'={active:ids,lots:lots,online:Networks,
    balance:Accounts.mapBy(a=>opening(a,lots)), holds:Set(), decisions:ids.mapBy(_=>0),
    finalProofs:Set(), receipts:Set()}
  pure def free(x:Book,a:Account):int = x.balance.get(a) - x.holds.fold(0,(n,h)=>
    if (key(h._1,h._2,payer(h._1,h._2))==a) n+quantity(h._1,h._2) else n)
  pure def funded(x:Book,t:int,l:int):bool = free(x,key(t,l,payer(t,l)))>=quantity(t,l)
  pure def online(x:Book,t:int,l:int):bool = x.online.contains(network(t,l))
  pure def matchesProof(x:Book,t:int,phase:int,p:Proof):bool =
    x.finalProofs.contains(p) and p==cert(t,phase)
  pure def output(t:int,l:int,kind:int):econ::Receipt = {
    trade:t,leg:l,kind:kind,chain:network(t,l),genesis:if (l==0) terms(t).genesisA else terms(t).genesisB,
    asset:asset(t,l),account:if (kind==0) receiver(t,l) else payer(t,l),quantity:quantity(t,l)}
  pure def move(x:Book,t:int,l:int):Book = {
    val q = quantity(t,l)
    val balances = x.balance.setBy(key(t,l,payer(t,l)),v=>v-q).setBy(key(t,l,receiver(t,l)),v=>v+q)
    {...x,balance:balances,holds:x.holds.exclude(Set((t,l))),receipts:x.receipts.union(Set(output(t,l,0)))}
  }
  pure def decide(x:Book,t:int,outcome:int):Book = {...x,decisions:x.decisions.set(t,outcome),
    finalProofs:x.finalProofs.union(Set(cert(t,if (outcome==2) 3 else 4)))}
  action reserve(t:int,l:int):bool = all {
    Legs.contains(l), b.active.contains(t), not(local(t)), online(b,t,l), funded(b,t,l), not(b.holds.contains((t,l))),
    // B may still see a new instruction after an ABORT on the remote host.
    if (l==0) b.decisions.get(t)==0 else not(b.finalProofs.contains(cert(t,2))),
    b'={...b,holds:b.holds.union(Set((t,l))),
        finalProofs:if (l==1) b.finalProofs.union(Set(cert(t,2))) else b.finalProofs}
  }
  pure def ready(x:Book,t:int,p:Proof):bool = and {
    x.active.contains(t), x.decisions.get(t)==0, online(x,t,0),
    if (local(t)) funded(x,t,0) and funded(x,t,1)
    else x.holds.contains((t,0)) and matchesProof(x,t,2,p)}
  pure def commitEffect(x:Book,t:int):Book = {
    val s = move(decide(x,t,2),t,0)
    if (local(t)) move(s,t,1) else s
  }
  action commitWith(t:int,p:Proof):bool = all {ready(b,t,p),b'=commitEffect(b,t)}
  action commit(t:int):bool = commitWith(t,cert(t,2))
  pure def independent(x:Book,t:int,u:int):bool = and {
    terms(t).chainA!=terms(u).chainA, ready(x,t,cert(t,2)), ready(x,u,cert(u,2))}
  // Each writes only its own host and trade slot. Both guards read the pre-state.
  action parallel(t:int,u:int):bool = all {independent(b,t,u), b'=commitEffect(commitEffect(b,t),u)}
  action payWith(t:int,p:Proof):bool = all {b.active.contains(t),not(local(t)),online(b,t,1),
    b.holds.contains((t,1)),matchesProof(b,t,3,p),b'=move(b,t,1)}
  action pay(t:int):bool = payWith(t,cert(t,3))
  // Abstract inclusion of the host's expiry decision, after its deadline.
  action expired(t:int):bool = all {b.active.contains(t),not(local(t)),online(b,t,0),
    b.decisions.get(t)==0,b'=decide(b,t,3)}
  action releaseWith(t:int,l:int,p:Proof):bool = all {Legs.contains(l),b.active.contains(t),online(b,t,l),
    b.holds.contains((t,l)),matchesProof(b,t,4,p),
    b'={...b,holds:b.holds.exclude(Set((t,l))),receipts:b.receipts.union(Set(output(t,l,1)))}}
  action release(t:int,l:int):bool = releaseWith(t,l,cert(t,4))
  action halt(n:int):bool = all {b.online.contains(n),b'={...b,online:b.online.exclude(Set(n))}}
  action recover(n:int):bool = all {Networks.contains(n),not(b.online.contains(n)),b'={...b,online:b.online.union(Set(n))}}
  action idle = b'=b
  action transactions = {
    nondet t = b.active.oneOf()
    nondet u = b.active.oneOf()
    nondet l = Legs.oneOf()
    any {reserve(t,l),commit(t),parallel(t,u),pay(t),expired(t),release(t,l),idle}
  }
  // Delivery also tries genuine proofs belonging to other trades and phases.
  action present = {
    nondet t = b.active.oneOf()
    nondet p = b.finalProofs.oneOf()
    nondet l = Legs.oneOf()
    any {all {not(local(t)),commitWith(t,p)}, payWith(t,p), releaseWith(t,l,p)}
  }
  action faults = { nondet n = Networks.oneOf() any {halt(n),recover(n)} }
  action step = any {transactions, present, faults}
  action opposite = start(Set(XtoY,YtoX),1)
  action bothLocals = start(Set(LocalX,LocalY),1)
  action four = start(Set(XtoY,YtoX,LocalX,LocalY),2)
  action scarce = start(Set(XtoY,LocalX,LocalY,AnotherXtoY),1)

  // Oracle reconstructs native balances from signed terms and observed receipts;
  // it never invokes move, free, ready or commitEffect to compute an expected debit.
  pure def exactReceipt(r:econ::Receipt,t:int,l:int,k:int):bool = {
    val d=terms(t)
    if (l==0) econ::matches(r,t,0,k,d.chainA,d.genesisA,d.assetA,if (k==0) d.buyerA else d.sellerA,d.security)
    else econ::matches(r,t,1,k,d.chainB,d.genesisB,d.assetB,if (k==0) d.sellerB else d.buyerB,d.cash)
  }
  pure def seen(x:Book,t:int,l:int,k:int):bool = x.receipts.exists(r=>exactReceipt(r,t,l,k))
  pure def delta(t:int,a:Account):int = {
    val d = terms(t)
    if (a._1==d.chainA and a._2==d.assetA) (if (a._3==d.buyerA) d.security else -d.security)
    else if (a._1==d.chainB and a._2==d.assetB) (if (a._3==d.sellerB) d.cash else -d.cash)
    else 0
  }
  pure def reserved(x:Book,a:Account):int = x.active.fold(0,(n,t)=>{
    val d=terms(t)
    if (a==(d.chainA,d.assetA,d.sellerA) and x.holds.contains((t,0))) n+d.security
    else if (a==(d.chainB,d.assetB,d.buyerB) and x.holds.contains((t,1))) n+d.cash
    else n
  })
  val accountsSound = Accounts.forall(a=>{
    val delivered = b.active.fold(0,(n,t)=>
      if (seen(b,t,if (a._2==30) 0 else 1,0)) n+delta(t,a) else n)
    b.balance.get(a)==opening(a,b.lots)+delivered and b.balance.get(a)>=reserved(b,a)
  })
  val backed = b.active.forall(t=>{
    val committed = b.decisions.get(t)==2
    val aborted = b.decisions.get(t)==3
    and {
      seen(b,t,0,0)==committed,
      seen(b,t,1,0).implies(committed),
      local(t).implies(seen(b,t,1,0)==committed),
      (committed and not(local(t))).implies(b.finalProofs.contains(cert(t,2)) and
        (b.holds.contains((t,1))!=seen(b,t,1,0))),
      b.finalProofs.contains(cert(t,3))==committed, b.finalProofs.contains(cert(t,4))==aborted,
      Legs.forall(l=>and {seen(b,t,l,1).implies(aborted),
        (seen(b,t,l,0) or seen(b,t,l,1)).implies(not(b.holds.contains((t,l))))})
    }
  })
  val exactOutputs = b.receipts.forall(r=>b.active.contains(r.trade) and Legs.contains(r.leg)
    and Set(0,1).contains(r.kind) and exactReceipt(r,r.trade,r.leg,r.kind))
  val ordersAgree = b.active.forall(t=>b.active.forall(u=>independent(b,t,u).implies(and {
    ready(commitEffect(b,t),u,cert(u,2)), ready(commitEffect(b,u),t,cert(t,2)),
    commitEffect(commitEffect(b,t),u)==commitEffect(commitEffect(b,u),t)})))
  val safety = accountsSound and backed and exactOutputs and ordersAgree
  temporal fairCash(t:int):bool = (eventually(always(online(b,t,1))) and pay(t).weakFair(Set(b))).implies(
    (b.decisions.get(t)==2).leadsTo(seen(b,t,1,0)))
  temporal recoveryProgress = fairCash(XtoY) and fairCash(YtoX)

  // Negative controls select only the altered economic transition.
  action halfLocal = all {ready(b,LocalX,cert(LocalX,2)), b'=move(decide(b,LocalX,2),LocalX,0)}
  action foreignPrepare = all {online(b,XtoY,0), b.decisions.get(XtoY)==0,
    b.holds.contains((XtoY,0)), b.finalProofs.contains(cert(YtoX,2)), b'=commitEffect(b,XtoY)}
  action halfStep = any {transactions,halfLocal}
  action foreignStep = any {transactions,foreignPrepare}
}

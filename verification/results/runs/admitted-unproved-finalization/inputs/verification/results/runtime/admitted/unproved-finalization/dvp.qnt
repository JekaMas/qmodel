// Candidate v1. All economic amounts and descriptor bindings are explicit.
// s is a frame record; actor read boundaries are stated on each action.
module dvp {
  import economic_effects.* from "./economic_effects"
  const N: int
  const HOST: int          // 0=A, 1=B, 2=D, 3=shared execution
  const OPEN_REQUIRED: bool
  const ESCROW: bool
  const PRIVATE: bool
  const MUTANT: int
  // Party IDs in signatures, local account IDs in Descriptor and availability
  // slots are separate namespaces even though all are represented by finite ints.
  // Up slots: 0 A, 1 B, 2 authorized submission (also D for HOST=2),
  // 3 adapter/prover (also common execution for HOST=3), 4 transport.
  pure val Trades = 1.to(N)
  // The finite fixture has seven genesis-epoch instructions and one new
  // instruction. The epoch is a signed descriptor field, independent of nonce.
  pure val RenewedTrades = Set(8)
  pure val D = 2
  type Descriptor = { trade: int, nonce: int, chainA: int, genesisA: int,
    chainB: int, genesisB: int, decisionDomain: int, assetA: int, assetB: int,
    holdA: int, holdB: int, decisionContract: int, security: int, cash: int,
    sellerA: int, buyerA: int, buyerB: int, sellerB: int, deadline: int,
    protocol: int, epoch: int, commitment: int }
  pure def desc(t: int): Descriptor = {trade:t, nonce:t, chainA:10, genesisA:110,
    chainB:if(HOST==3) 10 else 20, genesisB:if(HOST==3) 110 else 120, decisionDomain:HOST, assetA:30, assetB:40,
    holdA:50, holdB:60, decisionContract:70, security:2, cash:3,
    sellerA:0, buyerA:t, buyerB:if(HOST==3) t else 0, sellerB:if(HOST==3) 0 else t, deadline:D,
    protocol:1, epoch:if(RenewedTrades.contains(t)) 1 else 0, commitment:1000+t}
  // Full Descriptor/Witness provenance is specification-private ghost data.
  // The public wire projection is PublicEvidence below; observers do not receive
  // a nested plaintext descriptor merely because the model can inspect one.
  type Fact = { d: Descriptor, phase: int, checkpoint: int, program: int, root: int }
  pure def fact(t: int,p: int): Fact = {d:desc(t), phase:p, checkpoint:0, program:1, root:200+p*10+t}
  type PublicEvidence={commitment:int,phase:int,checkpoint:int,program:int,opaqueRoot:int}
  pure def publicEvidence(f:Fact):PublicEvidence={commitment:f.d.commitment,phase:f.phase,
    checkpoint:f.checkpoint,program:f.program,opaqueRoot:f.root}
  type Trade = { decision:int, oldTerminal:int, holdA:int, holdB:int,
    effectsA:int, effectsB:int, refundsA:int, refundsB:int,
    knownA:int, knownB:int, preparedA:bool, preparedB:bool, appliedEvidenceA:bool,
    appliedEvidenceB:bool, booked:int, report:int, stale:bool, intent:bool }
  pure val emptyTrade: Trade = {decision:0, oldTerminal:0,holdA:0,holdB:0,
    effectsA:0,effectsB:0,refundsA:0,refundsB:0,knownA:0,knownB:0,
    preparedA:false,preparedB:false,appliedEvidenceA:false,appliedEvidenceB:false,
    booked:0,report:0,stale:false,intent:false}
  type AbortRecord={d:Descriptor,leg:int,genesis:int,checkpoint:int,program:int,disposition:int}
  // Institution-private financial row. The complete recorded terms are actual
  // observable bookkeeping output, not inferred from a trade-indexed counter.
  type Booking={d:Descriptor,outcome:int}
  type State = { trades: int->Trade, signed:Set[(Descriptor,int)], height:int,
    ownerA:int, ownerB:int, vaultA:int, vaultB:int, spentA:int, spentB:int,
    receivedA:int->int, receivedB:int->int, economicReceipts:Set[Receipt],financialRecords:Set[Booking],
    included:Set[Fact], finalized:Set[Fact], captured:Set[Fact], proofs:Set[Fact], network:Set[Fact],
    received:Set[Fact], abortRecords:Set[AbortRecord], pruned:Set[Fact], up:Set[int], epoch:int, admitted:bool,
    historical:Set[int], eligible:Set[(int,int)], frozen:Set[int], note:Set[int],
    rejects:Set[int], transportCompromised:bool, custody:bool, upgrade:bool,
    validator:bool, decrypt:bool }
  var s: State
  pure def reservedA(x:State): int = Trades.filter(t=>x.trades.get(t).holdA==1).size()*2
  pure def reservedB(x:State): int = Trades.filter(t=>x.trades.get(t).holdB==1).size()*3
  pure def authorized(x:State,t:int):bool = x.signed.contains((desc(t),0)) and x.signed.contains((desc(t),1))
  pure def authFact(x:State,f:Fact,t:int,p:int):bool = and {
    x.proofs.contains(f), f.d==desc(t), f.phase==p, f.checkpoint==0,
    x.historical.contains(f.program), f.root==fact(t,p).root }
  pure def has(x:State,t:int,p:int):bool = x.received.exists(f=>authFact(x,f,t,p))
  // Consumer mutant10 omits only program admission. Strict authFact/S10 remain
  // unchanged, so a valid proof from an unadmitted program can falsify it.
  pure def preparationAtConsumer(x:State,t:int,p:int):bool =
    if(MUTANT==10) x.received.exists(f=>and {x.proofs.contains(f),f.d==desc(t),
      f.phase==p,f.checkpoint==0,f.root==fact(t,p).root}) else has(x,t,p)
  // Actual local outputs, committed atomically with the debit/release. Deliberate
  // misrouting/asset mutants preserve amount and operation count. The independent
  // assertion below compares these fields directly with the signed descriptor.
  pure def economicOutput(t:int,leg:int,kind:int):Receipt = {
    val d=desc(t)
    val account=if(leg==0) (if(kind==0) d.buyerA else d.sellerA)
      else (if(kind==0) d.sellerB else d.buyerB)
    val wrongAccount=(leg==0 and ((kind==0 and MUTANT==11) or (kind==1 and MUTANT==14))) or
      (leg==1 and ((kind==0 and MUTANT==15) or (kind==1 and MUTANT==17)))
    {trade:t,leg:leg,kind:kind,chain:if(leg==0) d.chainA else d.chainB,
      genesis:if(leg==0) d.genesisA else d.genesisB,
      asset:if(leg==0) (if(MUTANT==12) d.assetB else d.assetA)
        else (if(MUTANT==16) d.assetA else d.assetB),
      account:if(wrongAccount) (if(account==0) 1 else 0) else account,
      quantity:if(leg==0) d.security else d.cash}
  }
  pure def bookingOutput(t:int,outcome:int):Booking = {
    val d=desc(t)
    {d:if(MUTANT==18) {...d,sellerB:if(d.sellerB==0) 1 else 0}
       else if(MUTANT==19) {...d,cash:4} else d,outcome:outcome}
  }
  // A delivered phase 1/2 exists only after canonical source finalization.
  // The first final preparation must occur under its live epoch. Consequently
  // a later preparation can only extend an already-final chain of authority.
  pure def liveTerms(x:State,t:int):bool = x.admitted and desc(t).epoch==x.epoch
  pure def reserveAuthority(x:State,t:int,leg:int):bool =
    liveTerms(x,t) or has(x,t,if(leg==0) 2 else 1)
  pure def decisionAuthority(x:State,t:int):bool = liveTerms(x,t) or
    has(x,t,1) or has(x,t,2) or
    ((HOST==0 or HOST==3) and x.finalized.contains(fact(t,1))) or
    ((HOST==1 or HOST==3) and x.finalized.contains(fact(t,2)))
  pure def canOpen(x:State,t:int):bool = and { authorized(x,t), reserveAuthority(x,t,0),
    x.eligible.contains((t,0)),not(x.frozen.contains(0)), x.up.contains(0),(HOST!=3 or x.up.contains(3)),
    (if(HOST==0 or HOST==3) (x.height<D or MUTANT==4) else true),
    (if(HOST==0 or HOST==3) x.trades.get(t).decision==0 or (MUTANT==4 and x.trades.get(t).decision==3) else x.trades.get(t).knownA==0),
    x.trades.get(t).holdA==0 or (MUTANT==4 and x.trades.get(t).holdA==3),
    (if (ESCROW) x.ownerA>=2 else x.ownerA-reservedA(x)>=2) }
  pure def reserveA(x:State,t:int):State = { ...x,
    trades:x.trades.set(t,{...x.trades.get(t),decision:if(HOST==0 or HOST==3) 1 else x.trades.get(t).decision,holdA:1,intent:true,preparedA:true}),
    ownerA:if (ESCROW) x.ownerA-2 else x.ownerA,
    vaultA:if (ESCROW) x.vaultA+2 else x.vaultA, included:x.included.union(if(HOST==0 or HOST==3) Set(fact(t,0),fact(t,1)) else Set(fact(t,1))) }
  action init = s' = {trades:Trades.mapBy(_=>emptyTrade),signed:Set(),height:0,
    ownerA:2,ownerB:3,vaultA:0,vaultB:0,spentA:0,spentB:0,
    receivedA:Trades.mapBy(_=>0),receivedB:Trades.mapBy(_=>0),economicReceipts:Set(),financialRecords:Set(),
    included:Set(),finalized:Set(),captured:Set(),proofs:Set(),network:Set(),received:Set(),abortRecords:Set(),pruned:Set(),
    up:Set(0,1,2,3,4),epoch:0,admitted:true,historical:Set(1),eligible:tuples(Trades,Set(0,1)),
    frozen:Set(),note:Set(),rejects:Set(),transportCompromised:false,
    custody:false,upgrade:false,validator:false,decrypt:false}
  action sign(t:int,party:int): bool = all {Trades.contains(t),Set(0,1).contains(party),s.admitted,s.epoch==desc(t).epoch, s'={...s,signed:s.signed.union(Set((desc(t),party)))}}
  // Local A only: signatures/descriptor, local balance, A height.
  action openA(t:int): bool = all {canOpen(s,t),s'=reserveA(s,t)}
  // Decision-ledger registration is its own local transaction for B/D topologies.
  action registerDecision(t:int):bool = all {HOST==1 or HOST==2,s.up.contains(HOST),
    authorized(s,t),decisionAuthority(s,t),s.height<D,s.trades.get(t).decision==0,
    s'={...s,trades:s.trades.set(t,{...s.trades.get(t),decision:1,intent:true}),included:s.included.union(Set(fact(t,0)))}}
  action requestOpen(t:int,d:Descriptor):bool = all {d==desc(t),openA(t)}
  action requestCash(t:int,d:Descriptor):bool = all {d==desc(t),prepareB(t)}
  // Local B only: no read of A decision. Historical OPEN is optional received evidence.
  action prepareB(t:int): bool = all {
    authorized(s,t),reserveAuthority(s,t,1),s.eligible.contains((t,1)),not(s.frozen.contains(1)),s.up.contains(1),(HOST!=3 or s.up.contains(3)),
    s.trades.get(t).knownB==0, s.trades.get(t).holdB==0,
    not(OPEN_REQUIRED) or has(s,t,0),
    (if (ESCROW) s.ownerB>=3 else s.ownerB-reservedB(s)>=3),
    s'={...s,trades:s.trades.set(t,{...s.trades.get(t),holdB:1,intent:true,preparedB:true}),
      ownerB:if (ESCROW) s.ownerB-3 else s.ownerB,
      vaultB:if (ESCROW) s.vaultB+3 else s.vaultB,included:s.included.union(Set(fact(t,2)))} }
  action tick = all {s.up.contains(HOST),s.height<D,s'={...s,height:s.height+1}}
  // Source finalization is separate from transaction submission/application.
  pure def eligibleFact(x:State,t:int,p:int):bool = {
    val z=x.trades.get(t)
    if (p==0) z.decision==1
    else if (p==1) z.holdA==1
    else if (p==2) z.holdB==1
    else if (p==3) z.decision==2
    else if (p==4) z.decision==3
    else if (p==5) z.effectsA==1
    else z.effectsB==1
  }
  // Finalize a previously INCLUDED immutable fact, not the current source state.
  // This deliberately permits authentic historical OPEN/preparation after ABORT.
  action finalize(t:int,p:int): bool = all {
    s.included.contains(fact(t,p)),
    true,
    s.up.contains(if(HOST==3) 3 else if (p==2 or p==6) 1 else if (p==0 or p==3 or p==4) HOST else 0),
    s'={...s,finalized:s.finalized.union(Set(fact(t,p)))} }
  action capture(t:int,p:int): bool = all {s.up.contains(3),s.finalized.contains(fact(t,p)),
    not(s.pruned.contains(fact(t,p))),s'={...s,captured:s.captured.union(Set(fact(t,p)))}}
  action prove(t:int,p:int): bool = all {s.up.contains(3),s.captured.contains(fact(t,p)),
    s'={...s,proofs:s.proofs.union(Set(fact(t,p))),network:s.network.union(Set(fact(t,p)))}}
  // Valid proof of the same captured statement under external program0. Crypto
  // validity/provenance is distinct from application admission: history never
  // admits0. This is not forged proof membership. It exercises the consumer's
  // program gate, including after rotation/exit, in the adversarial configuration.
  action proveUnadmitted(t:int,p:int):bool = {
    val f={...fact(t,p),program:0}
    all {s.up.contains(3),s.captured.contains(fact(t,p)),
      s'={...s,proofs:s.proofs.union(Set(f)),network:s.network.union(Set(f))}}
  }
  action deliverUnadmitted(t:int,p:int):bool = {
    val f={...fact(t,p),program:0}
    all {s.up.contains(4),s.network.contains(f),s.proofs.contains(f),
      s'={...s,received:s.received.union(Set(f))}}
  }
  // Soup is retained for repeated delivery. Explicit loss removes a message, resend restores it.
  action lose(t:int,p:int): bool = all {s.network.contains(fact(t,p)),s'={...s,network:s.network.exclude(Set(fact(t,p)))}}
  action resend(t:int,p:int): bool = all {s.up.contains(4),s.proofs.contains(fact(t,p)),s'={...s,network:s.network.union(Set(fact(t,p)))}}
  action deliver(t:int,p:int): bool = all {s.up.contains(4),s.network.contains(fact(t,p)),
    s'={...s,received:s.received.union(Set(fact(t,p)))}}
  // Attacker substitutions are candidates; they acquire no authentic provenance.
  action inject(t:int,p:int,binding:int): bool = {
    val f=fact(t,p)
    val bad=if(binding==0) {...f,d:{...f.d,trade:3-t}}
      else if(binding==1) {...f,d:{...f.d,nonce:99}}
      else if(binding==2) {...f,d:{...f.d,sellerB:99}}
      else if(binding==3) {...f,d:{...f.d,cash:4}}
      else if(binding==4) {...f,d:{...f.d,genesisB:999}}
      else if(binding==5) {...f,d:{...f.d,decisionDomain:99}}
      else if(binding==6) {...f,phase:6}
      else if(binding==7) {...f,checkpoint:99}
      else if(binding==8) {...f,program:99}
      else if(binding==9) {...f,d:{...f.d,assetB:99,holdB:99}}
      else {...f,root:999}
    s'={...s,received:s.received.union(Set(bad)),rejects:s.rejects.union(Set(binding))}
  }
  // Decision owner: local hold/freeze/height and received authenticated proofs.
  // Remote live balances, holds and clocks are unavailable to this guard.
  // A/B placement applies only its own leg; D records no native leg itself.
  pure def canCommit(x:State,t:int):bool = {
    val z=x.trades.get(t)
    and {decisionAuthority(x,t),x.up.contains(HOST),x.up.contains(2),z.decision==1,x.height<D,(if(HOST==0 or HOST==3) z.holdA==1 else if(HOST==1) z.holdB==1 else true),
      (if(HOST==3) not(x.frozen.contains(0)) and not(x.frozen.contains(1)) else if(HOST==0) not(x.frozen.contains(0)) else if(HOST==1) not(x.frozen.contains(1)) else true),
      (if (MUTANT==2) x.received.exists(f=>f.phase==2 and x.proofs.contains(f))
       else if (MUTANT==6) x.received.exists(f=>f.phase==2)
       else if(HOST==1) true else if(HOST==3) z.holdB==1 else preparationAtConsumer(x,t,2)),
      (HOST==0 or HOST==3 or preparationAtConsumer(x,t,1)) }
  }
  pure def debitA(x:State):State = {...x,ownerA:if(ESCROW) x.ownerA else x.ownerA-2,
    vaultA:if(ESCROW) x.vaultA-2 else x.vaultA}
  pure def debitB(x:State):State = {...x,ownerB:if(ESCROW) x.ownerB else x.ownerB-3,
    vaultB:if(ESCROW) x.vaultB-3 else x.vaultB}
  // One EVM-style transaction: decision + the colocated native transfer(s).
  // Disabled local transfer guards roll back the complete modeled transaction.
  // The non-atomic mutant intentionally omits that economic transfer.
  action commit(t:int): bool = {
    val z=s.trades.get(t)
    val a=if((HOST==0 or HOST==3) and MUTANT!=5) debitA(s) else s
    val b=if(HOST==1 or HOST==3) debitB(a) else a
    all {canCommit(s,t),s'={...b,
      economicReceipts:b.economicReceipts.union(if((HOST==0 or HOST==3) and MUTANT!=5) Set(economicOutput(t,0,0)) else Set()).union(if(HOST==1 or HOST==3) Set(economicOutput(t,1,0)) else Set()),
      included:b.included.union(Set(fact(t,3))).union(if((HOST==0 or HOST==3) and MUTANT!=5) Set(fact(t,5)) else Set()).union(if(HOST==1 or HOST==3) Set(fact(t,6)) else Set()),trades:b.trades.set(t,{...z,decision:2,
      oldTerminal:if(z.oldTerminal==0) 2 else z.oldTerminal,
      knownA:if(HOST==0 or HOST==3) 2 else z.knownA,
      knownB:if(HOST==1 or HOST==3) 2 else z.knownB,
      holdA:if((HOST==0 or HOST==3) and MUTANT!=5) 2 else z.holdA,
      holdB:if(HOST==1 or HOST==3) 2 else z.holdB,
      effectsA:z.effectsA+(if((HOST==0 or HOST==3) and MUTANT!=5) 1 else 0),
      effectsB:z.effectsB+(if(HOST==1 or HOST==3) 1 else 0)}),
      receivedA:if((HOST==0 or HOST==3) and MUTANT!=5) b.receivedA.setBy(t,q=>q+2) else b.receivedA,
      receivedB:if(HOST==1 or HOST==3) b.receivedB.setBy(t,q=>q+3) else b.receivedB}}
  }
  // Durable ABORT is independent of token/refund success, including missing OPEN.
  action abort(t:int): bool = all {s.up.contains(HOST),s.up.contains(2),authorized(s,t),s.height>=D,
    s.trades.get(t).decision<2,
    s'={...s,included:s.included.union(Set(fact(t,4))),trades:s.trades.set(t,{...s.trades.get(t),decision:3,
      oldTerminal:if(s.trades.get(t).oldTerminal==0) 3 else s.trades.get(t).oldTerminal,
      knownA:if(HOST==0 or HOST==3) 3 else s.trades.get(t).knownA,
      knownB:if(HOST==1 or HOST==3) 3 else s.trades.get(t).knownB})}}
  action learn(t:int,outcome:int,leg:int): bool = all {
    Set(0,1).contains(leg),Set(2,3).contains(outcome),s.up.contains(leg),(HOST!=3 or s.up.contains(3)),has(s,t,if(outcome==2) 3 else 4),
    s'={...s,trades:s.trades.set(t,{...s.trades.get(t),
      knownA:if(leg==0) outcome else s.trades.get(t).knownA,
      knownB:if(leg==1 and (MUTANT!=9 or s.trades.get(t).holdB!=0)) outcome else s.trades.get(t).knownB})}}
  // Local application reads local authenticated terminal knowledge only.
  action applyA(t:int): bool = {
    val z=s.trades.get(t)
    val a=debitA(s)
    all {s.up.contains(0),(HOST!=3 or s.up.contains(3)),s.up.contains(2),not(s.frozen.contains(0)),z.knownA==2,z.holdA==1,
      s'={...a,economicReceipts:a.economicReceipts.union(Set(economicOutput(t,0,0))),included:s.included.union(Set(fact(t,5))),trades:s.trades.set(t,{...z,holdA:2,effectsA:z.effectsA+1}),receivedA:s.receivedA.setBy(t,q=>q+2)}}
  }
  action applyB(t:int): bool = {
    val z=s.trades.get(t)
    val b=debitB(s)
    all {s.up.contains(1),(HOST!=3 or s.up.contains(3)),s.up.contains(2),not(s.frozen.contains(1)),z.knownB==2,
      z.holdB==1 or (MUTANT==3 and z.holdB==2),
      s'={...b,economicReceipts:b.economicReceipts.union(Set(economicOutput(t,1,0))),included:s.included.union(Set(fact(t,6))),trades:s.trades.set(t,{...z,holdB:2,effectsB:z.effectsB+1}),
        receivedB:s.receivedB.setBy(t,q=>q+3)}}
  }
  action refund(t:int,leg:int): bool = {
    val z=s.trades.get(t)
    all {s.up.contains(leg),(HOST!=3 or s.up.contains(3)),s.up.contains(2),not(s.frozen.contains(leg)),
      (if(leg==0) z.holdA==1 and z.knownA==3 else z.holdB==1 and z.knownB==3),
      s'={...s,economicReceipts:s.economicReceipts.union(Set(economicOutput(t,leg,1))),trades:s.trades.set(t,{...z,
        holdA:if(leg==0) 3 else z.holdA,holdB:if(leg==1) 3 else z.holdB,
        refundsA:z.refundsA+(if(leg==0) 1 else 0),refundsB:z.refundsB+(if(leg==1) 1 else 0)}),
        ownerA:s.ownerA+(if(ESCROW and leg==0) 2 else 0),vaultA:s.vaultA-(if(ESCROW and leg==0) 2 else 0),
        ownerB:s.ownerB+(if(ESCROW and leg==1) 3 else 0),vaultB:s.vaultB-(if(ESCROW and leg==1) 3 else 0)}}
  }
  // Deliberate protocol mutants are isolated by MUTANT and never part of safe steps.
  action unsafeRefund(t:int): bool = all {MUTANT==1 or (MUTANT==7 and s.trades.get(t).stale and s.trades.get(t).report==0),s.trades.get(t).holdB==1,
    s'={...s,trades:s.trades.set(t,{...s.trades.get(t),holdB:3,refundsB:s.trades.get(t).refundsB+1})}}
  action forgetTerminal(t:int): bool = all {MUTANT==8,s.trades.get(t).decision>=2,
    s'={...s,trades:s.trades.set(t,{...s.trades.get(t),decision:0,holdA:0})}}
  action spend(leg:int): bool = all {Set(0,1).contains(leg),s.up.contains(leg),
    (if(leg==0) s.ownerA-(if(ESCROW) 0 else reservedA(s))>=1 else s.ownerB-(if(ESCROW) 0 else reservedB(s))>=1),
    s'={...s,ownerA:s.ownerA-(if(leg==0) 1 else 0),ownerB:s.ownerB-(if(leg==1) 1 else 0),
      spentA:s.spentA+(if(leg==0) 1 else 0),spentB:s.spentB+(if(leg==1) 1 else 0)}}
  action crash(actor:int): bool = s'={...s,up:s.up.exclude(Set(actor)),
    trades:Trades.mapBy(t=>{...s.trades.get(t),report:0,stale:true})}
  action recover(actor:int): bool = s'={...s,up:s.up.union(Set(actor))}
  action observe(t:int,leg:int): bool = all {s.up.contains(3),has(s,t,if(leg==0) 5 else 6),
    s'={...s,trades:s.trades.set(t,{...s.trades.get(t),
      appliedEvidenceA:s.trades.get(t).appliedEvidenceA or leg==0,
      appliedEvidenceB:s.trades.get(t).appliedEvidenceB or leg==1})}}
  action reconcile(t:int): bool = all {s.up.contains(3),s.trades.get(t).appliedEvidenceA,s.trades.get(t).appliedEvidenceB,
    s'={...s,financialRecords:s.financialRecords.union(Set(bookingOutput(t,2))),trades:s.trades.set(t,{...s.trades.get(t),report:2,stale:false,
      booked:if(s.trades.get(t).booked==0) 1 else s.trades.get(t).booked})}}
  // Ideal authenticated local-ledger read/finalized application-record interface.
  // Only the source leg reads its own ledger; the consumer receives a structured record.
  // This abstracts a canonical FINALIZED local-read interface. The adapter
  // must implement authenticated source provenance; a bare RPC/relayer ack is
  // insufficient. No-obligation disposition 0 is a record, never a fake refund.
  action captureAbortRecord(t:int,leg:int):bool = {
    val z=s.trades.get(t)
    val localHold=if(leg==0) z.holdA else z.holdB
    val localKnown=if(leg==0) z.knownA else z.knownB
    all {s.up.contains(leg),s.up.contains(3),localKnown==3 or MUTANT==13,localHold!=1,
      s'={...s,abortRecords:s.abortRecords.union(Set({d:desc(t),leg:leg,
        genesis:if(leg==0) desc(t).genesisA else desc(t).genesisB,
        checkpoint:0,program:1,disposition:localHold}))}}
  }
  pure def hasAbortRecord(x:State,t:int,leg:int):bool = x.abortRecords.exists(r=>and {
    r.d==desc(t),r.leg==leg,r.genesis==(if(leg==0) desc(t).genesisA else desc(t).genesisB),
    r.checkpoint==0,x.historical.contains(r.program),Set(0,3).contains(r.disposition)})
  // Semantic assertion over the source world, never a remote live read by the
  // record consumer. Absence is terminal only after local ABORT knowledge; actual
  // prepared legs require one real release, with no active obligation left.
  pure def abortResolved(x:State,t:int):bool = {
    val z=x.trades.get(t)
    and {z.holdA!=1,z.holdB!=1,z.knownA==3,z.knownB==3,
      if(z.preparedA) z.holdA==3 and z.refundsA==1 else z.holdA==0 and z.refundsA==0,
      if(z.preparedB) z.holdB==3 and z.refundsB==1 else z.holdB==0 and z.refundsB==0,
      x.abortRecords.filter(r=>r.d==desc(t)).forall(r=>r.disposition==
        (if(r.leg==0) z.holdA else z.holdB))}
  }
  action recordAbort(t:int):bool = all {s.up.contains(3),has(s,t,4),hasAbortRecord(s,t,0),hasAbortRecord(s,t,1),
    s'={...s,financialRecords:s.financialRecords.union(Set(bookingOutput(t,3))),trades:s.trades.set(t,{...s.trades.get(t),report:3,stale:false,
      booked:if(s.trades.get(t).booked==0) 1 else s.trades.get(t).booked})}}
  action rotate = all {s.epoch==0,s'={...s,epoch:1,historical:s.historical.union(Set(1,2))}}
  action exitMember = s'={...s,admitted:false}
  action revoke(t:int): bool = s'={...s,eligible:s.eligible.exclude(Set((t,0),(t,1)))}
  action revokeLeg(t:int,leg:int):bool = s'={...s,eligible:s.eligible.exclude(Set((t,leg)))}
  action freeze(leg:int): bool = s'={...s,frozen:s.frozen.union(Set(leg))}
  action unfreeze(leg:int): bool = s'={...s,frozen:s.frozen.exclude(Set(leg))}
  action prune(t:int,p:int): bool = all {s.captured.contains(fact(t,p)),s'={...s,pruned:s.pruned.union(Set(fact(t,p)))}}
  action receiveNote(t:int): bool = all {s.trades.get(t).effectsB==1,s'={...s,note:s.note.union(Set(t))}}
  action compromiseTransport = s'={...s,transportCompromised:true}
  action idle = s'=s
  action tradeStep(t:int): bool = any {sign(t,0),sign(t,1),openA(t),prepareB(t),registerDecision(t),commit(t),abort(t),
    applyA(t),applyB(t),refund(t,0),refund(t,1),learn(t,2,0),learn(t,2,1),learn(t,3,0),learn(t,3,1),
    observe(t,0),observe(t,1),reconcile(t),captureAbortRecord(t,0),captureAbortRecord(t,1),recordAbort(t),unsafeRefund(t),forgetTerminal(t),receiveNote(t),
    nondet p=0.to(6).oneOf(); any {finalize(t,p),capture(t,p),prove(t,p),deliver(t,p),resend(t,p)}}
  action step = any {nondet t=Trades.oneOf();tradeStep(t),tick,idle}
  action adversarialStep = any {step,
    nondet t=Trades.oneOf();nondet p=0.to(6).oneOf();any {proveUnadmitted(t,p),deliverUnadmitted(t,p)},
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); nondet f=0.to(10).oneOf();inject(t,p,f),
    nondet a=0.to(4).oneOf();any {crash(a),recover(a)},
    nondet l=Set(0,1).oneOf();any {spend(l),freeze(l),unfreeze(l)},rotate,exitMember,
    nondet t=Trades.oneOf();nondet l=Set(0,1).oneOf();revokeLeg(t,l),compromiseTransport}
  val S01 = and {s.ownerA>=0,s.ownerB>=0,s.vaultA>=0,s.vaultB>=0,s.spentA>=0,s.spentB>=0,
    0.to(D).contains(s.height),Set(0,1).contains(s.epoch),s.up.subseteq(0.to(4)),
    s.eligible.subseteq(tuples(Trades,Set(0,1))),s.frozen.subseteq(Set(0,1)),s.historical.subseteq(Set(1,2)),
    s.signed.forall(sig=>Trades.exists(t=>sig._1==desc(t)) and Set(0,1).contains(sig._2)),
    Trades.forall(t=> {val z=s.trades.get(t);and {0.to(3).contains(z.decision),Set(0,2,3).contains(z.oldTerminal),
      0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),Set(0,2,3).contains(z.knownA),Set(0,2,3).contains(z.knownB),
      Set(0,2,3).contains(z.report),z.effectsA>=0,z.effectsB>=0,z.refundsA>=0,z.refundsB>=0,z.booked>=0,
      s.receivedA.get(t)>=0,s.receivedB.get(t)>=0,desc(t).security>0,desc(t).cash>0,desc(t).assetA!=desc(t).assetB}})}
  val S02 = Trades.forall(t=>s.trades.get(t).oldTerminal==0 or s.trades.get(t).decision==s.trades.get(t).oldTerminal)
  val S03 = Trades.forall(t=>(s.trades.get(t).preparedA or s.trades.get(t).preparedB) implies authorized(s,t))
  val S04 = and {s.ownerA+s.vaultA+s.spentA+Trades.fold(0,(a,t)=>a+s.receivedA.get(t))==2,
    s.ownerB+s.vaultB+s.spentB+Trades.fold(0,(a,t)=>a+s.receivedB.get(t))==3,
    if(ESCROW) s.vaultA==reservedA(s) and s.vaultB==reservedB(s) else reservedA(s)<=s.ownerA and reservedB(s)<=s.ownerB}
  // Compare observed output fields with signed terms, not economicOutput. Amount
  // counters alone cannot distinguish delivery to another valid account/asset.
  pure def exactEconomicEffects(x:State):bool = and {
    x.economicReceipts.forall(r=> {
      val d=desc(r.trade)
      and {Trades.contains(r.trade),Set(0,1).contains(r.leg),Set(0,1).contains(r.kind),
        matches(r,r.trade,r.leg,r.kind,if(r.leg==0) d.chainA else d.chainB,
          if(r.leg==0) d.genesisA else d.genesisB,if(r.leg==0) d.assetA else d.assetB,
          if(r.leg==0) (if(r.kind==0) d.buyerA else d.sellerA)
            else (if(r.kind==0) d.sellerB else d.buyerB),
          if(r.leg==0) d.security else d.cash)}}),
    Trades.forall(t=> {
      val z=x.trades.get(t)
      and {x.economicReceipts.filter(r=>r.trade==t and r.leg==0 and r.kind==0).size()==z.effectsA,
        x.economicReceipts.filter(r=>r.trade==t and r.leg==1 and r.kind==0).size()==z.effectsB,
        x.economicReceipts.filter(r=>r.trade==t and r.leg==0 and r.kind==1).size()==z.refundsA,
        x.economicReceipts.filter(r=>r.trade==t and r.leg==1 and r.kind==1).size()==z.refundsB}})}
  pure def exactFinancialRecords(x:State):bool = and {
    x.financialRecords.forall(r=>Trades.contains(r.d.trade) and r.d==desc(r.d.trade) and
      Set(2,3).contains(r.outcome) and r.outcome==x.trades.get(r.d.trade).decision),
    Trades.forall(t=>x.financialRecords.filter(r=>r.d.trade==t).size()==x.trades.get(t).booked)}
  val S05 = Trades.forall(t=> {val z=s.trades.get(t); and {z.effectsA<=1,z.effectsB<=1,z.refundsA<=1,z.refundsB<=1,z.booked<=1,
    s.receivedA.get(t)==z.effectsA*2,s.receivedB.get(t)==z.effectsB*3}}) and exactEconomicEffects(s) and exactFinancialRecords(s)
  val S06 = Trades.forall(t=> {val z=s.trades.get(t); and {z.effectsA>0 implies z.decision==2,
    z.effectsB>0 implies z.knownB==2,z.refundsA>0 implies z.knownA==3,z.refundsB>0 implies z.knownB==3,
    (z.booked>0 and z.decision==3) implies has(s,t,4) and hasAbortRecord(s,t,0) and hasAbortRecord(s,t,1) and abortResolved(s,t)}})
  val S07 = Trades.forall(t=> {val z=s.trades.get(t); (z.preparedB and z.effectsB==0 and z.refundsB==0) implies z.holdB==1})
  val S08 = Trades.forall(t=> {val z=s.trades.get(t); z.decision==2 implies and {
    (HOST!=0 or (z.effectsA==1 and s.receivedA.get(t)==2)),
    z.holdB==1 or (z.effectsB==1 and s.receivedB.get(t)==3),
    if(z.holdB==1) (if(ESCROW) s.vaultB>=reservedB(s) else s.ownerB>=reservedB(s)) else true,
    (HOST==1 or HOST==3 or has(s,t,2)),exactEconomicEffects(s)}})
  val S09 = Trades.forall(t=> {val z=s.trades.get(t);not(z.effectsA>0 and z.refundsB>0) and not(z.effectsB>0 and z.refundsA>0)})
  val S10 = Trades.forall(t=>s.trades.get(t).decision==2 implies (if(HOST==1) has(s,t,1) else if(HOST==3) true else has(s,t,2) and (HOST!=2 or has(s,t,1))))
  val S11 = Trades.forall(t=>s.trades.get(t).oldTerminal!=3 or s.trades.get(t).decision==3)
  val S12 = S02 and S05
  // This core retains historical version 1. Membership/rotation authorization,
  // pending-safe retirement and old-credential admission are checked separately.
  val S13 = s.historical.contains(1)
  // S14 here is an authorization state check, not historical eligibility proof.
  // Eligibility/freeze admission is enforced by canOpen/prepareB and direct cases;
  // supported post-prepare policy is checked in interventions.qnt.
  val S14 = Trades.forall(t=>(s.trades.get(t).holdA==1 or s.trades.get(t).holdB==1) implies authorized(s,t))
  val S15 = Trades.forall(t=>and {s.trades.get(t).report==2 implies s.trades.get(t).appliedEvidenceA and s.trades.get(t).appliedEvidenceB,
    (s.trades.get(t).report==3 or (s.trades.get(t).booked>0 and s.trades.get(t).decision==3)) implies
      has(s,t,4) and hasAbortRecord(s,t,0) and hasAbortRecord(s,t,1) and abortResolved(s,t)})
  val S16 = not(s.custody or s.upgrade or s.validator or s.decrypt)
  val safe = S01 and S02 and S03 and S04 and S05 and S06 and S07 and S08 and S09 and S10 and S11 and S12 and S13 and S14 and S15 and S16
  pure def usableCash(x:State,t:int):bool = x.trades.get(t).effectsB==1 and (not(PRIVATE) or x.note.contains(t))
  val deliveredIsUsable = Trades.forall(t=>s.trades.get(t).effectsB==1 implies usableCash(s,t))
  val CDecision = Trades.forall(t=> {val z=s.trades.get(t); z.decision==2 implies
    (z.holdA==1 or z.effectsA==1) and (z.holdB==1 or z.effectsB==1) and exactEconomicEffects(s)})
  type Report={authorizedIntent:bool,preparedAAtSnapshot:bool,preparedBAtSnapshot:bool,committedAuthenticated:bool,appliedAAuthenticated:bool,appliedBAuthenticated:bool,fullyApplied:bool,reconciled:bool,staleOrIncomplete:bool,recipientCashUsable:bool}
  // Specification diagnostic over the combined world: recipientCashUsable and
  // participant knownA/B are oracle/local diagnostic fields, not a reporter API.
  // Only fullyApplied/reconciled have the modeled received-record gates. A real
  // external report must authenticate every source-dependent field it presents.
  pure def progressReport(x:State,t:int):Report = {
    val z=x.trades.get(t)
    {authorizedIntent:authorized(x,t),preparedAAtSnapshot:has(x,t,1),
     preparedBAtSnapshot:has(x,t,2),committedAuthenticated:has(x,t,3) or z.knownA==2 or z.knownB==2,
     appliedAAuthenticated:z.appliedEvidenceA,appliedBAuthenticated:z.appliedEvidenceB,
     fullyApplied:z.report==2,reconciled:z.booked==1,staleOrIncomplete:z.stale or z.report==0,
     recipientCashUsable:usableCash(x,t)}
  }
  val noSettlement = not(Trades.exists(t=>s.trades.get(t).effectsA==1 and s.trades.get(t).effectsB==1))
  val noLag = Trades.forall(t=>s.trades.get(t).effectsA==s.trades.get(t).effectsB)
  val someHold = Trades.exists(t=>s.trades.get(t).holdA==1 or s.trades.get(t).holdB==1)
  val someCommit = Trades.exists(t=>s.trades.get(t).decision==2)
  val someAbort = Trades.exists(t=>s.trades.get(t).decision==3)
  val someLag = not(noLag)
  val someSettlement = not(noSettlement)
}
module baseline { import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* }
module contention { import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* }

// Numeric assertions use physical ledger/asset/account keys, independently of
// the producer's dispatch helpers. 1=XY, 2=YX, 3=XX, 4=YY, 5=XY, 6=YX.
module routed_settlement_test {
  import routed_settlement.* from "../models/routed_settlement"
  action prepare(t:int):bool = reserve(t,0).then(reserve(t,1))
  action settle(t:int):bool = if (local(t)) commit(t) else prepare(t).then(commit(t)).then(pay(t))
  def balanceAt(n:int,assetId:int,owner:int):int = b.balance.get((n,assetId,owner))
  def complete(t:int):bool = and {b.decisions.get(t)==2, seen(b,t,0,0),seen(b,t,1,0)}
  val roundTrip = and {complete(1),complete(2),b.holds==Set(),b.receipts.size()==4,safety,
    balanceAt(10,30,0)==0,balanceAt(10,30,1)==4,balanceAt(20,40,1)==0,balanceAt(20,40,0)==6,
    balanceAt(20,30,1)==0,balanceAt(20,30,0)==4,balanceAt(10,40,0)==0,balanceAt(10,40,1)==6}
  run ForwardThenReverseTest = opposite.then(settle(1)).then(settle(2)).expect(roundTrip)
  run ReverseThenForwardTest = opposite.then(settle(2)).then(settle(1)).expect(roundTrip)

  run bothReady = opposite.then(reserve(1,1)).then(reserve(2,0)).then(reserve(2,1)).then(reserve(1,0))
  run ParallelCrossTest = bothReady.then(parallel(2,1)).expect(
    seen(b,1,0,0) and seen(b,2,0,0) and b.receipts.size()==2 and b.holds==Set((1,1),(2,1)))
    .then(pay(1)).then(pay(2)).expect(roundTrip)
  run SimultaneousOppositePaymentsTest = bothReady.then(parallel(1,2)).then(parallelPay(2,1)).expect(roundTrip)
  run OnlyOneCashProofTest = bothReady.then(commit(2)).then(parallelPay(2,1).fail())
  run SameCashLedgerOrdersPaymentsTest = start(Set(1,5),2).then(prepare(1)).then(prepare(5))
    .then(commit(1)).then(commit(5)).then(parallelPay(1,5).fail())
  run ParallelReverseDeliveryTest = bothReady.then(parallel(1,2)).then(pay(2))
    .expect(complete(2) and b.holds==Set((1,1))).then(pay(1)).expect(roundTrip)
  run ForwardHaltRecoveryTest = bothReady.then(halt(Y)).then(commit(1))
    .expect(seen(b,1,0,0) and not(seen(b,1,1,0)) and free(b,(Y,40,1))==0)
    .then(idle).then(recover(Y)).then(pay(1)).expect(complete(1) and safety)
  run ReverseHaltRecoveryTest = bothReady.then(halt(X)).then(commit(2))
    .expect(seen(b,2,0,0) and not(seen(b,2,1,0)) and free(b,(X,40,0))==0)
    .then(idle).then(recover(X)).then(pay(2)).expect(complete(2) and safety)
  run HaltedCashCannotApplyTest = bothReady.then(halt(X)).then(commit(2)).then(pay(2).fail())
  run HaltedHostCannotDecideTest = bothReady.then(halt(Y)).then(commit(2).fail())

  val bothLocalDone = and {b.receipts.size()==4,b.holds==Set(),complete(3),complete(4),safety,
    Networks.forall(n=>balanceAt(n,30,0)==0 and balanceAt(n,30,1)==4 and
      balanceAt(n,40,1)==0 and balanceAt(n,40,0)==6)}
  run LocalXThenYTest = bothLocals.then(commit(3)).expect(complete(3) and b.decisions.get(4)==0
    and balanceAt(Y,30,0)==2 and balanceAt(Y,40,1)==3).then(commit(4)).expect(bothLocalDone)
  run LocalYThenXTest = bothLocals.then(commit(4)).expect(complete(4) and b.decisions.get(3)==0
    and balanceAt(X,30,0)==2 and balanceAt(X,40,1)==3).then(commit(3)).expect(bothLocalDone)
  run ParallelLocalBothTest = bothLocals.then(parallel(3,4)).expect(bothLocalDone)
  run DuplicateLocalRejectedTest = bothLocals.then(commit(4)).then(commit(4).fail())

  run FourOverlappingTest = four.then(prepare(1)).then(prepare(2)).then(parallel(1,4))
    .expect(complete(4) and b.holds==Set((1,1),(2,0),(2,1)))
    .then(parallel(3,2)).then(pay(2)).then(pay(1))
    .expect(b.active.forall(t=>complete(t)) and b.holds==Set() and b.receipts.size()==8 and safety)
  run UnrelatedLocalDuringRemoteHaltTest = four.then(prepare(1)).then(halt(Y)).then(commit(1))
    .then(commit(3)).expect(complete(3) and not(complete(1)) and free(b,(Y,40,1))==3)
    .then(recover(Y)).then(pay(1)).expect(complete(1) and safety)
  run SameDirectionConcurrentTest = start(Set(1,5),2).then(reserve(1,0)).then(prepare(5))
    .then(reserve(1,1)).then(commit(5)).then(commit(1)).then(pay(1)).then(pay(5))
    .expect(b.receipts.size()==4 and b.holds==Set() and balanceAt(X,30,0)==0 and balanceAt(Y,40,1)==0 and safety)
  run SameReverseConcurrentTest = start(Set(2,6),2).then(reserve(6,1)).then(prepare(2))
    .then(reserve(6,0)).then(commit(2)).then(commit(6)).then(pay(6)).then(pay(2))
    .expect(b.receipts.size()==4 and balanceAt(Y,30,1)==0 and balanceAt(X,40,0)==0 and safety)
  run SameHostMustOrderTest = start(Set(1,5),2).then(prepare(1)).then(prepare(5)).then(parallel(1,5).fail())

  run SecurityShortfallTest = scarce.then(reserve(1,0))
    .expect(free(b,(X,30,0))==0 and balanceAt(X,40,1)==3 and b.receipts==Set()).then(commit(3).fail())
  run CashShortfallTest = scarce.then(reserve(1,1))
    .expect(free(b,(Y,40,1))==0 and balanceAt(Y,30,0)==2 and b.receipts==Set()).then(commit(4).fail())
  run CrossWinsSecurityTest = scarce.then(prepare(1)).then(commit(1)).then(pay(1))
    .expect(complete(1) and balanceAt(X,30,0)==0).then(commit(3).fail())
  run LocalWinsSecurityTest = scarce.then(commit(3)).expect(complete(3) and balanceAt(X,30,0)==0)
    .then(reserve(1,0).fail())
  run CrossWinsCashTest = scarce.then(prepare(1)).then(commit(1)).then(pay(1))
    .expect(complete(1) and balanceAt(Y,40,1)==0).then(commit(4).fail())
  run LocalWinsCashTest = scarce.then(commit(4)).expect(complete(4) and balanceAt(Y,40,1)==0)
    .then(reserve(1,1).fail())

  run ReverseCrossWinsSecurityTest = scarceReverse.then(prepare(2)).then(commit(2)).then(pay(2))
    .expect(complete(2) and balanceAt(Y,30,1)==0).then(commit(8).fail())
  run ReverseLocalWinsSecurityTest = scarceReverse.then(commit(8)).expect(complete(8)).then(reserve(2,0).fail())
  run ReverseCrossWinsCashTest = scarceReverse.then(prepare(2)).then(commit(2)).then(pay(2))
    .expect(complete(2) and balanceAt(X,40,0)==0).then(commit(7).fail())
  run ReverseLocalWinsCashTest = scarceReverse.then(commit(7)).expect(complete(7)).then(reserve(2,1).fail())
  run SequentialSiblingsForwardTest = start(Set(1,5),2).then(settle(5)).then(settle(1))
    .expect(complete(1) and complete(5) and b.receipts.size()==4 and safety)
  run SequentialSiblingsReverseTest = start(Set(2,6),2).then(settle(6)).then(settle(2))
    .expect(complete(2) and complete(6) and b.receipts.size()==4 and safety)
  run ReuseReceivedFundsInNewTradeTest = start(Set(3,7),1).then(commit(3)).then(commit(7))
    .expect(complete(3) and complete(7) and balanceAt(X,40,1)==3 and balanceAt(X,30,0)==2 and safety)

  // Each ordered mixed pair exercises the physical accounts touched by both routes.
  action serial(t:int,u:int):bool = start(Set(t,u),2).then(settle(t)).then(settle(u))
    .expect(complete(t) and complete(u) and b.receipts.size()==4 and b.holds==Set() and safety)
  run ForwardThenLocalXTest = serial(1,3)
  run LocalXThenForwardTest = serial(3,1)
  run ForwardThenLocalYTest = serial(1,4)
  run LocalYThenForwardTest = serial(4,1)
  run ReverseThenLocalXTest = serial(2,3)
  run LocalXThenReverseTest = serial(3,2)
  run ReverseThenLocalYTest = serial(2,4)
  run LocalYThenReverseTest = serial(4,2)
  run LocalYFundsNextSellerTest = start(Set(4,8),1).then(commit(8)).then(commit(4))
    .expect(complete(4) and complete(8) and balanceAt(Y,30,1)==2 and balanceAt(Y,40,0)==3 and safety)

  run OppositeAbortAndCommitTest = bothReady.then(expired(2)).then(commit(1)).then(release(2,1))
    .expect(b.holds==Set((2,0),(1,1))).then(pay(1)).then(release(2,0))
    .expect(complete(1) and b.decisions.get(2)==3 and b.holds==Set() and
      balanceAt(Y,30,1)==2 and balanceAt(X,40,0)==3 and seen(b,2,0,1) and seen(b,2,1,1) and safety)
  run LateCashHoldRefundTest = opposite.then(expired(2)).then(reserve(2,1)).then(release(2,1))
    .expect(b.holds==Set() and balanceAt(X,40,0)==3 and seen(b,2,1,1)).then(reserve(2,1).fail())
  run SiblingAbortRejectedTest = bothReady.then(expired(2)).then(releaseWith(1,1,cert(2,4)).fail())
  run DuplicateReleaseRejectedTest = bothReady.then(expired(2)).then(release(2,0)).then(release(2,0).fail())
  run OppositePrepareRejectedTest = opposite.then(reserve(1,0)).then(reserve(2,1)).then(commitWith(1,cert(2,2)).fail())
  run SiblingPrepareRejectedTest = start(Set(1,5),2).then(reserve(1,0)).then(reserve(5,1)).then(commitWith(1,cert(5,2)).fail())
  run SiblingCommitRejectedTest = start(Set(2,6),2).then(prepare(6)).then(reserve(2,1))
    .then(commit(6)).then(payWith(2,cert(6,3)).fail())
  run WrongGenesisRejectedTest = bothReady.then(commitWith(2,{...cert(2,2),genesis:120}).fail())
  run WrongPhaseRejectedTest = bothReady.then(commit(2)).then(payWith(2,cert(2,2)).fail())
  run DuplicatePaymentRejectedTest = bothReady.then(parallel(1,2)).then(pay(2)).then(pay(2).fail())
}

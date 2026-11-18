// Literal expected receipts are independent of the producer constructors.
module economic_native_test {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run trade1ExactEconomicTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,1)).then(applyB(1)).expect(safe and CDecision and s.economicReceipts==Set({trade:1,leg:0,kind:0,chain:10,genesis:110,asset:30,account:1,quantity:2},{trade:1,leg:1,kind:0,chain:20,genesis:120,asset:40,account:1,quantity:3}) and s.receivedA.get(1)==2 and s.receivedB.get(1)==3)
 run trade2ExactEconomicTest=init.then(sign(2,0)).then(sign(2,1)).then(openA(2)).then(prepareB(2)).then(finalize(2,2)).then(capture(2,2)).then(prove(2,2)).then(deliver(2,2)).then(commit(2)).then(finalize(2,3)).then(capture(2,3)).then(prove(2,3)).then(deliver(2,3)).then(learn(2,2,1)).then(applyB(2)).expect(safe and CDecision and s.economicReceipts==Set({trade:2,leg:0,kind:0,chain:10,genesis:110,asset:30,account:2,quantity:2},{trade:2,leg:1,kind:0,chain:20,genesis:120,asset:40,account:2,quantity:3}) and s.receivedA.get(2)==2 and s.receivedB.get(2)==3)
}

module economic_escrow_test {
 import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=true,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run trade1ExactEconomicTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,1)).then(applyB(1)).expect(safe and CDecision and s.economicReceipts==Set({trade:1,leg:0,kind:0,chain:10,genesis:110,asset:30,account:1,quantity:2},{trade:1,leg:1,kind:0,chain:20,genesis:120,asset:40,account:1,quantity:3}) and s.receivedA.get(1)==2 and s.receivedB.get(1)==3)
 run trade2ExactEconomicTest=init.then(sign(2,0)).then(sign(2,1)).then(openA(2)).then(prepareB(2)).then(finalize(2,2)).then(capture(2,2)).then(prove(2,2)).then(deliver(2,2)).then(commit(2)).then(finalize(2,3)).then(capture(2,3)).then(prove(2,3)).then(deliver(2,3)).then(learn(2,2,1)).then(applyB(2)).expect(safe and CDecision and s.economicReceipts==Set({trade:2,leg:0,kind:0,chain:10,genesis:110,asset:30,account:2,quantity:2},{trade:2,leg:1,kind:0,chain:20,genesis:120,asset:40,account:2,quantity:3}) and s.receivedA.get(2)==2 and s.receivedB.get(2)==3)
}

module economic_b_test {
 import dvp(N=2,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run trade1ExactEconomicTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(applyA(1)).expect(safe and CDecision and s.economicReceipts==Set({trade:1,leg:0,kind:0,chain:10,genesis:110,asset:30,account:1,quantity:2},{trade:1,leg:1,kind:0,chain:20,genesis:120,asset:40,account:1,quantity:3}) and s.receivedA.get(1)==2 and s.receivedB.get(1)==3)
 run trade2ExactEconomicTest=init.then(sign(2,0)).then(sign(2,1)).then(openA(2)).then(prepareB(2)).then(registerDecision(2)).then(finalize(2,1)).then(capture(2,1)).then(prove(2,1)).then(deliver(2,1)).then(commit(2)).then(finalize(2,3)).then(capture(2,3)).then(prove(2,3)).then(deliver(2,3)).then(learn(2,2,0)).then(applyA(2)).expect(safe and CDecision and s.economicReceipts==Set({trade:2,leg:0,kind:0,chain:10,genesis:110,asset:30,account:2,quantity:2},{trade:2,leg:1,kind:0,chain:20,genesis:120,asset:40,account:2,quantity:3}) and s.receivedA.get(2)==2 and s.receivedB.get(2)==3)
}

module economic_d_test {
 import dvp(N=2,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run trade1ExactEconomicTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,0)).then(applyA(1)).then(learn(1,2,1)).then(applyB(1)).expect(safe and CDecision and s.economicReceipts==Set({trade:1,leg:0,kind:0,chain:10,genesis:110,asset:30,account:1,quantity:2},{trade:1,leg:1,kind:0,chain:20,genesis:120,asset:40,account:1,quantity:3}) and s.receivedA.get(1)==2 and s.receivedB.get(1)==3)
 run trade2ExactEconomicTest=init.then(sign(2,0)).then(sign(2,1)).then(openA(2)).then(prepareB(2)).then(registerDecision(2)).then(finalize(2,1)).then(capture(2,1)).then(prove(2,1)).then(deliver(2,1)).then(finalize(2,2)).then(capture(2,2)).then(prove(2,2)).then(deliver(2,2)).then(commit(2)).then(finalize(2,3)).then(capture(2,3)).then(prove(2,3)).then(deliver(2,3)).then(learn(2,2,0)).then(applyA(2)).then(learn(2,2,1)).then(applyB(2)).expect(safe and CDecision and s.economicReceipts==Set({trade:2,leg:0,kind:0,chain:10,genesis:110,asset:30,account:2,quantity:2},{trade:2,leg:1,kind:0,chain:20,genesis:120,asset:40,account:2,quantity:3}) and s.receivedA.get(2)==2 and s.receivedB.get(2)==3)
}

module economic_shared_test {
 import dvp(N=2,HOST=3,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run trade1ExactEconomicTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(commit(1)).expect(safe and CDecision and s.economicReceipts==Set({trade:1,leg:0,kind:0,chain:10,genesis:110,asset:30,account:1,quantity:2},{trade:1,leg:1,kind:0,chain:10,genesis:110,asset:40,account:0,quantity:3}) and s.receivedA.get(1)==2 and s.receivedB.get(1)==3)
 run trade2ExactEconomicTest=init.then(sign(2,0)).then(sign(2,1)).then(openA(2)).then(prepareB(2)).then(commit(2)).expect(safe and CDecision and s.economicReceipts==Set({trade:2,leg:0,kind:0,chain:10,genesis:110,asset:30,account:2,quantity:2},{trade:2,leg:1,kind:0,chain:10,genesis:110,asset:40,account:0,quantity:3}) and s.receivedA.get(2)==2 and s.receivedB.get(2)==3)
}

module economic_multilateral_test {
 import multilateral.* from "../models/multilateral"
 run distinctDomainRecipientTest=init.then(reserve(2)).then(reserveSecurity(2)).then(prove(2)).then(commit(2)).then(outcome(2)).then(learn(2,2)).then(apply(2)).expect(safe and z.economicReceipts==Set({trade:2,leg:0,kind:0,chain:2,genesis:102,asset:30,account:2,quantity:2},{trade:2,leg:1,kind:0,chain:1,genesis:101,asset:40,account:2,quantity:3}))
 run releaseReturnsOwnersTest=init.then(reserve(1)).then(reserveSecurity(1)).then(tick(0)).then(tick(0)).then(abort(1)).then(outcome(1)).then(learn(1,3)).then(apply(1)).then(refundSecurity(1)).expect(safe and z.economicReceipts==Set({trade:1,leg:0,kind:1,chain:0,genesis:100,asset:30,account:0,quantity:2},{trade:1,leg:1,kind:1,chain:1,genesis:101,asset:40,account:0,quantity:3}))
}

module economic_booking_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run applied=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).then(finalize(1,3)).then(capture(1,3)).then(prove(1,3)).then(deliver(1,3)).then(learn(1,2,1)).then(applyB(1))
 run evidenced=applied.then(finalize(1,5)).then(capture(1,5)).then(prove(1,5)).then(deliver(1,5)).then(observe(1,0)).then(finalize(1,6)).then(capture(1,6)).then(prove(1,6)).then(deliver(1,6)).then(observe(1,1))
 run bookingExactTermsTest=evidenced.then(reconcile(1)).expect(safe and s.trades.get(1).booked==1 and s.financialRecords==Set({d:desc(1),outcome:2}) and s.financialRecords.forall(r=>r.d.buyerA==1 and r.d.sellerB==1 and r.d.security==2 and r.d.cash==3))
 run recoveredBookingExactlyOnceTest=evidenced.then(reconcile(1)).then(crash(3)).then(recover(3)).then(reconcile(1)).expect(safe and s.financialRecords==Set({d:desc(1),outcome:2}) and s.trades.get(1).booked==1)
}

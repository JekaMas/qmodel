// Actual captured/finalized facts; crypto-validity is distinct from admission.
module admission_b_test {
 import dvp(N=1,HOST=1,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run actualUnadmittedRejectTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(proveUnadmitted(1,1)).then(deliverUnadmitted(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).expect(s.proofs.contains({...fact(1,1),program:0}) and s.received.contains({...fact(1,1),program:0}) and not(s.historical.contains(0)) and not(canCommit(s,1)) and safe).then(commit(1).fail())
 run canonicalAcceptTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).expect(safe and S10 and s.trades.get(1).decision==2)
}
module admission_d_security_test {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run actualUnadmittedRejectTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(proveUnadmitted(1,1)).then(deliverUnadmitted(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).expect(s.proofs.contains({...fact(1,1),program:0}) and s.received.contains({...fact(1,1),program:0}) and not(s.historical.contains(0)) and not(canCommit(s,1)) and safe).then(commit(1).fail())
 run canonicalAcceptTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).expect(safe and S10 and s.trades.get(1).decision==2)
}
module admission_d_cash_test {
 import dvp(N=1,HOST=2,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run actualUnadmittedRejectTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(proveUnadmitted(1,2)).then(deliverUnadmitted(1,2)).expect(s.proofs.contains({...fact(1,2),program:0}) and s.received.contains({...fact(1,2),program:0}) and not(s.historical.contains(0)) and not(canCommit(s,1)) and safe).then(commit(1).fail())
 run canonicalAcceptTest=init.then(sign(1,0)).then(sign(1,1)).then(openA(1)).then(prepareB(1)).then(registerDecision(1)).then(finalize(1,1)).then(capture(1,1)).then(prove(1,1)).then(deliver(1,1)).then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1)).expect(safe and S10 and s.trades.get(1).decision==2)
}

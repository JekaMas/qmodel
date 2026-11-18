module abort_probe {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./early_absence_mutant"
 run early=init.then(sign(1,0)).then(sign(1,1)).then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1))
 run booked=early.then(openA(1)).then(prepareB(1)).then(tick).then(tick).then(abort(1))
  .then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(recordAbort(1))
 run weakOracleAcceptsPrematureBookingTest=booked.expect(safe and CDecision and s.trades.get(1).booked==1 and s.trades.get(1).holdA==1 and s.trades.get(1).holdB==1)
 run independentOracleRejectsPrematureBookingTest=booked.expect(s.trades.get(1).holdA!=1 and s.trades.get(1).holdB!=1)
}

// Semantic outcome assertions do not derive resolution from record existence.
module abort_records_test {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../models/dvp"
 run signed=init.then(sign(1,0)).then(sign(1,1))
 run held=signed.then(openA(1)).then(prepareB(1))
 run abortOnly=signed.then(tick).then(tick).then(abort(1))
 run aborted=held.then(tick).then(tick).then(abort(1))
 run outcome=aborted.then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1))
 run prematureARecordRejectTest=signed.then(captureAbortRecord(1,0).fail())
 run prematureBRecordRejectTest=signed.then(captureAbortRecord(1,1).fail())
 run unresolvedHoldRecordRejectTest=outcome.then(captureAbortRecord(1,1).fail())
 run absentUnlearnedRecordRejectTest=abortOnly.then(captureAbortRecord(1,1).fail())
 run realRefundRecordsTest=outcome.then(refund(1,0)).then(refund(1,1)).then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1)).then(recordAbort(1)).expect(safe and abortResolved(s,1) and s.trades.get(1).booked==1 and s.trades.get(1).refundsA==1 and s.trades.get(1).refundsB==1 and s.economicReceipts.size()==2)
 run absenceNoFakeRefundTest=abortOnly.then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1)).then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1)).then(recordAbort(1)).then(recordAbort(1)).expect(safe and abortResolved(s,1) and s.trades.get(1).booked==1 and s.trades.get(1).refundsA==0 and s.trades.get(1).refundsB==0 and s.economicReceipts==Set())
 run lateActualHoldResolvedTest=abortOnly.then(prepareB(1)).then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1)).then(refund(1,1)).then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1)).then(recordAbort(1)).expect(safe and abortResolved(s,1) and s.trades.get(1).holdA==0 and s.trades.get(1).refundsA==0 and s.trades.get(1).holdB==3 and s.trades.get(1).refundsB==1)
 run terminalAbsencePreventsLatePrepareTest=abortOnly.then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4)).then(learn(1,3,1)).then(captureAbortRecord(1,0)).then(captureAbortRecord(1,1)).then(recordAbort(1)).expect(safe and abortResolved(s,1)).then(prepareB(1).fail())
}

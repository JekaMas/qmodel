module report_view_test {
 import report_view.* from "../models/report_view"
 run agreed=init.then(sign(1,0)).then(sign(1,1))
 run unsignedTest=init.expect(not(finalReport(s,1).authorizedIntent) and not(finalReport(s,1).acceptedOnSource))
 run signedButUnacceptedTest=agreed.expect(finalReport(s,1).authorizedIntent and not(finalReport(s,1).acceptedOnSource) and not(finalReport(s,1).decisionRegistered))
 run cashAcceptedBeforeDecisionTest=agreed.then(prepareB(1)).expect(finalReport(s,1).acceptedOnSource and not(finalReport(s,1).decisionRegistered) and not(finalReport(s,1).fullyApplied))
 run registeredOpenTest=agreed.then(openA(1)).expect(finalReport(s,1).acceptedOnSource and finalReport(s,1).decisionRegistered and not(finalReport(s,1).committedAuthenticated))
 run tombstoneAcceptedTest=agreed.then(tick).then(tick).then(abort(1)).expect(not(s.trades.get(1).intent) and finalReport(s,1).acceptedOnSource and finalReport(s,1).decisionRegistered and not(finalReport(s,1).fullyApplied))
 run rejectedInstructionNotAcceptedTest=agreed.then(freeze(0)).expect(not(finalReport(s,1).acceptedOnSource)).then(openA(1).fail())
}

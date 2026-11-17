// Solver-facing finite-choice expansion of the FULL one-trade reference.
// Same state, initializer, primitive guards/effects, invariants and all phases0-6.
// check_grounding.py checks identity of the next-state relation using parsed ASTs.
// Nondeterministic trace sets are preserved; sampling probabilities are not claimed.
module full_grounded {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 action groundedStep=any {
  sign(1,0),sign(1,1),openA(1),prepareB(1),registerDecision(1),commit(1),abort(1),
  applyA(1),applyB(1),refund(1,0),refund(1,1),learn(1,2,0),learn(1,2,1),learn(1,3,0),learn(1,3,1),
  observe(1,0),observe(1,1),reconcile(1),captureAbortRecord(1,0),captureAbortRecord(1,1),recordAbort(1),unsafeRefund(1),forgetTerminal(1),receiveNote(1),
  finalize(1,0),capture(1,0),prove(1,0),deliver(1,0),resend(1,0),
  finalize(1,1),capture(1,1),prove(1,1),deliver(1,1),resend(1,1),
  finalize(1,2),capture(1,2),prove(1,2),deliver(1,2),resend(1,2),
  finalize(1,3),capture(1,3),prove(1,3),deliver(1,3),resend(1,3),
  finalize(1,4),capture(1,4),prove(1,4),deliver(1,4),resend(1,4),
  finalize(1,5),capture(1,5),prove(1,5),deliver(1,5),resend(1,5),
  finalize(1,6),capture(1,6),prove(1,6),deliver(1,6),resend(1,6),tick,idle
 }
}

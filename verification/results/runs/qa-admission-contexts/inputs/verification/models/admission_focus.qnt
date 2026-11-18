// Full healthy N1 financial machine plus real captured-statement proofs from
// external program0. Application admission is checked separately by authFact.
// Rotation/exit and delivery ordering are nondeterministic; all ordinary proof
// phases0..6 remain. This scope has no liveness or Byzantine proof-soundness claim.
module admission_focus {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
 action focusStep=any {step,proveUnadmitted(1,2),deliverUnadmitted(1,2),rotate,exitMember}
}

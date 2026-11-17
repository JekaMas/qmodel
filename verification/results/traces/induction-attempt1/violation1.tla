---------------------------- MODULE counterexample ----------------------------

EXTENDS induction

(* Constant initialization state *)
ConstInit == TRUE

(* Initial state [_transition(0)] *)
State0 ==
  v_certificateB = TRUE
    /\ v_decision = 1
    /\ v_height = 2
    /\ v_holdA = 1
    /\ v_holdB = 2
    /\ v_knownB = 0
    /\ v_ownerA = 2
    /\ v_ownerB = 0
    /\ v_paidA = 0
    /\ v_paidB = 1
    /\ v_receivedA = 0
    /\ v_receivedB = 3
    /\ v_refundA = 0
    /\ v_refundB = 0
    /\ v_terminal = 0

(* State1 [_transition(4)] *)
State1 ==
  v_certificateB = TRUE
    /\ v_decision = 3
    /\ v_height = 2
    /\ v_holdA = 1
    /\ v_holdB = 2
    /\ v_knownB = 0
    /\ v_ownerA = 2
    /\ v_ownerB = 0
    /\ v_paidA = 0
    /\ v_paidB = 1
    /\ v_receivedA = 0
    /\ v_receivedB = 3
    /\ v_refundA = 0
    /\ v_refundB = 0
    /\ v_terminal = 3

(* The following formula holds true in the last state and violates the invariant *)
InvariantViolation == v_decision = 3 /\ (~(v_paidA = 0) \/ ~(v_paidB = 0))

================================================================================
(* Created by Apalache on Tue Nov 17 20:28:23 GMT+04:00 2026 *)
(* https://github.com/apalache-mc/apalache *)

---- MODULE induction_false_release ------------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

VARIABLE
  (*
    @type: Int;
  *)
  pc

VARIABLE
  (*
    @type: { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int };
  *)
  induction_false_release_dvp_s

(*
  @type: (() => Int);
*)
induction_false_release_dvp_N == 1

(*
  @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
*)
induction_false_release_dvp_emptyTrade ==
  [decision |-> 0,
    oldTerminal |-> 0,
    holdA |-> 0,
    holdB |-> 0,
    effectsA |-> 0,
    effectsB |-> 0,
    refundsA |-> 0,
    refundsB |-> 0,
    knownA |-> 0,
    knownB |-> 0,
    preparedA |-> FALSE,
    preparedB |-> FALSE,
    appliedEvidenceA |-> FALSE,
    appliedEvidenceB |-> FALSE,
    booked |-> 0,
    report |-> 0,
    stale |-> FALSE,
    intent |-> FALSE]

(*
  @type: (() => Int);
*)
induction_false_release_dvp_HOST == 0

(*
  @type: (() => Int);
*)
induction_false_release_dvp_D == 2

(*
  @type: (() => Int);
*)
induction_false_release_dvp_MUTANT == 0

(*
  @type: (() => Bool);
*)
induction_false_release_dvp_ESCROW == FALSE

(*
  @type: (() => Bool);
*)
induction_false_release_dvp_OPEN_REQUIRED == FALSE

(*
  @type: (() => Set({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, report: Int, stale: Bool }));
*)
AuxSpace ==
  { [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> FALSE,
      booked |-> 0,
      report |-> 0,
      stale |-> FALSE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> TRUE,
      booked |-> 0,
      report |-> 0,
      stale |-> FALSE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> FALSE,
      booked |-> 0,
      report |-> 0,
      stale |-> FALSE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> TRUE,
      booked |-> 0,
      report |-> 0,
      stale |-> FALSE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> FALSE,
      booked |-> 0,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> TRUE,
      booked |-> 0,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> FALSE,
      booked |-> 0,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> TRUE,
      booked |-> 0,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> FALSE,
      booked |-> 1,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> TRUE,
      booked |-> 1,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> FALSE,
      booked |-> 1,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> TRUE,
      booked |-> 1,
      report |-> 0,
      stale |-> TRUE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> TRUE,
      booked |-> 1,
      report |-> 2,
      stale |-> FALSE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> FALSE,
      booked |-> 1,
      report |-> 3,
      stale |-> FALSE],
    [appliedEvidenceA |-> FALSE,
      appliedEvidenceB |-> TRUE,
      booked |-> 1,
      report |-> 3,
      stale |-> FALSE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> FALSE,
      booked |-> 1,
      report |-> 3,
      stale |-> FALSE],
    [appliedEvidenceA |-> TRUE,
      appliedEvidenceB |-> TRUE,
      booked |-> 1,
      report |-> 3,
      stale |-> FALSE] }

(*
  @type: ((<<Int, Int, Int, Int, Int, { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, report: Int, stale: Bool }, Bool>>) => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
*)
tradeDomainRow(v_7590) ==
  [decision |-> v_7590[1],
    oldTerminal |-> IF v_7590[1] >= 2 THEN v_7590[1] ELSE 0,
    holdA |-> v_7590[2],
    holdB |-> v_7590[3],
    effectsA |-> IF v_7590[2] = 2 THEN 1 ELSE 0,
    effectsB |-> IF v_7590[3] = 2 THEN 1 ELSE 0,
    refundsA |-> IF v_7590[2] = 3 THEN 1 ELSE 0,
    refundsB |-> IF v_7590[3] = 3 THEN 1 ELSE 0,
    knownA |-> v_7590[4],
    knownB |-> v_7590[5],
    preparedA |-> v_7590[2] /= 0,
    preparedB |-> v_7590[3] /= 0,
    appliedEvidenceA |-> v_7590[6]["appliedEvidenceA"],
    appliedEvidenceB |-> v_7590[6]["appliedEvidenceB"],
    booked |-> v_7590[6]["booked"],
    report |-> v_7590[6]["report"],
    stale |-> v_7590[6]["stale"],
    intent |-> v_7590[7]]

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => Bool);
*)
tradeDomainIntent(z_7618) ==
  z_7618["intent"]
    \/ ((z_7618["holdA"] = 0 /\ z_7618["holdB"] = 0)
      /\ z_7618["decision"] \in { 0, 3 })

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, report: Int, stale: Bool });
*)
tradeDomainAux(z_7644) ==
  [appliedEvidenceA |-> z_7644["appliedEvidenceA"],
    appliedEvidenceB |-> z_7644["appliedEvidenceB"],
    booked |-> z_7644["booked"],
    report |-> z_7644["report"],
    stale |-> z_7644["stale"]]

(*
  @type: (() => Set(Int));
*)
induction_false_release_dvp_Trades == 1 .. induction_false_release_dvp_N

(*
  @type: ((Int) => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
*)
induction_false_release_dvp_desc(induction_false_release_dvp_t_1706) ==
  [trade |-> induction_false_release_dvp_t_1706,
    nonce |-> induction_false_release_dvp_t_1706,
    chainA |-> 10,
    genesisA |-> 110,
    chainB |-> IF induction_false_release_dvp_HOST = 3 THEN 10 ELSE 20,
    genesisB |-> IF induction_false_release_dvp_HOST = 3 THEN 110 ELSE 120,
    decisionDomain |-> induction_false_release_dvp_HOST,
    assetA |-> 30,
    assetB |-> 40,
    holdA |-> 50,
    holdB |-> 60,
    decisionContract |-> 70,
    security |-> 2,
    cash |-> 3,
    sellerA |-> 0,
    buyerA |-> induction_false_release_dvp_t_1706,
    buyerB |->
      IF induction_false_release_dvp_HOST = 3
      THEN induction_false_release_dvp_t_1706
      ELSE 0,
    sellerB |->
      IF induction_false_release_dvp_HOST = 3
      THEN 0
      ELSE induction_false_release_dvp_t_1706,
    deadline |-> induction_false_release_dvp_D,
    protocol |-> 1,
    epoch |-> 0,
    commitment |-> 1000 + induction_false_release_dvp_t_1706]

(*
  @type: (() => Bool);
*)
induction_false_release_dvp_tick ==
  induction_false_release_dvp_HOST \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_s["height"] < induction_false_release_dvp_D
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["height"] = induction_false_release_dvp_s["height"] + 1
      ]

(*
  @type: (() => Set(<<Int, Int, Int, Int, Int, { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, report: Int, stale: Bool }, Bool>>));
*)
RawTradeParams ==
  (0 .. 3)
    \X (0 .. 3)
    \X (0 .. 3)
    \X { 0, 2, 3 }
    \X { 0, 2, 3 }
    \X AuxSpace
    \X BOOLEAN

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => Bool);
*)
tradeDomainContains(z_7804) ==
  z_7804["decision"] \in 0 .. 3
    /\ z_7804["holdA"] \in 0 .. 3
    /\ z_7804["holdB"] \in 0 .. 3
    /\ z_7804["knownA"] \in { 0, 2, 3 }
    /\ z_7804["knownB"] \in { 0, 2, 3 }
    /\ z_7804["intent"] \in BOOLEAN
    /\ z_7804["oldTerminal"]
      = (IF z_7804["decision"] >= 2 THEN z_7804["decision"] ELSE 0)
    /\ z_7804["effectsA"] = (IF z_7804["holdA"] = 2 THEN 1 ELSE 0)
    /\ z_7804["effectsB"] = (IF z_7804["holdB"] = 2 THEN 1 ELSE 0)
    /\ z_7804["refundsA"] = (IF z_7804["holdA"] = 3 THEN 1 ELSE 0)
    /\ z_7804["refundsB"] = (IF z_7804["holdB"] = 3 THEN 1 ELSE 0)
    /\ z_7804["preparedA"] = (z_7804["holdA"] /= 0)
    /\ z_7804["preparedB"] = (z_7804["holdB"] /= 0)
    /\ tradeDomainAux(z_7804) \in AuxSpace
    /\ tradeDomainIntent(z_7804)

(*
  @type: (() => Bool);
*)
induction_false_release_dvp_init ==
  induction_false_release_dvp_s'
    := [trades |->
        [
          induction_false_release_dvp___2518 \in
            induction_false_release_dvp_Trades |->
            induction_false_release_dvp_emptyTrade
        ],
      signed |-> {},
      height |-> 0,
      ownerA |-> 2,
      ownerB |-> 3,
      vaultA |-> 0,
      vaultB |-> 0,
      spentA |-> 0,
      spentB |-> 0,
      receivedA |->
        [
          induction_false_release_dvp___2540 \in
            induction_false_release_dvp_Trades |->
            0
        ],
      receivedB |->
        [
          induction_false_release_dvp___2546 \in
            induction_false_release_dvp_Trades |->
            0
        ],
      economicReceipts |-> {},
      financialRecords |-> {},
      included |-> {},
      finalized |-> {},
      captured |-> {},
      proofs |-> {},
      network |-> {},
      received |-> {},
      abortRecords |-> {},
      pruned |-> {},
      up |-> { 0, 1, 2, 3, 4 },
      epoch |-> 0,
      admitted |-> TRUE,
      historical |-> {1},
      eligible |-> induction_false_release_dvp_Trades \X { 0, 1 },
      frozen |-> {},
      note |-> {},
      rejects |-> {},
      transportCompromised |-> FALSE,
      custody |-> FALSE,
      upgrade |-> FALSE,
      validator |-> FALSE,
      decrypt |-> FALSE]

(*
  @type: ((Int, Int) => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
*)
induction_false_release_dvp_fact(induction_false_release_dvp_t_1738, induction_false_release_dvp_p_1738) ==
  [d |-> induction_false_release_dvp_desc(induction_false_release_dvp_t_1738),
    phase |-> induction_false_release_dvp_p_1738,
    checkpoint |-> 0,
    program |-> 1,
    root |->
      (200 + induction_false_release_dvp_p_1738 * 10)
        + induction_false_release_dvp_t_1738]

(*
  @type: ((Int, Int, Int) => { account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int });
*)
induction_false_release_dvp_economicOutput(induction_false_release_dvp_t_2253, induction_false_release_dvp_leg_2253,
induction_false_release_dvp_kind_2253) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  induction_false_release_dvp_d ==
    induction_false_release_dvp_desc(induction_false_release_dvp_t_2253)
  IN
  LET (*
    @type: (() => Int);
  *)
  induction_false_release_dvp_account ==
    IF induction_false_release_dvp_leg_2253 = 0
    THEN IF induction_false_release_dvp_kind_2253 = 0
    THEN (induction_false_release_dvp_d)["buyerA"]
    ELSE (induction_false_release_dvp_d)["sellerA"]
    ELSE IF induction_false_release_dvp_kind_2253 = 0
    THEN (induction_false_release_dvp_d)["sellerB"]
    ELSE (induction_false_release_dvp_d)["buyerB"]
  IN
  LET (*
    @type: (() => Bool);
  *)
  induction_false_release_dvp_wrongAccount ==
    (induction_false_release_dvp_leg_2253 = 0
        /\ ((induction_false_release_dvp_kind_2253 = 0
            /\ induction_false_release_dvp_MUTANT = 11)
          \/ (induction_false_release_dvp_kind_2253 = 1
            /\ induction_false_release_dvp_MUTANT = 14)))
      \/ (induction_false_release_dvp_leg_2253 = 1
        /\ ((induction_false_release_dvp_kind_2253 = 0
            /\ induction_false_release_dvp_MUTANT = 15)
          \/ (induction_false_release_dvp_kind_2253 = 1
            /\ induction_false_release_dvp_MUTANT = 17)))
  IN
  [trade |-> induction_false_release_dvp_t_2253,
    leg |-> induction_false_release_dvp_leg_2253,
    kind |-> induction_false_release_dvp_kind_2253,
    chain |->
      IF induction_false_release_dvp_leg_2253 = 0
      THEN (induction_false_release_dvp_d)["chainA"]
      ELSE (induction_false_release_dvp_d)["chainB"],
    genesis |->
      IF induction_false_release_dvp_leg_2253 = 0
      THEN (induction_false_release_dvp_d)["genesisA"]
      ELSE (induction_false_release_dvp_d)["genesisB"],
    asset |->
      IF induction_false_release_dvp_leg_2253 = 0
      THEN IF induction_false_release_dvp_MUTANT = 12
      THEN (induction_false_release_dvp_d)["assetB"]
      ELSE (induction_false_release_dvp_d)["assetA"]
      ELSE IF induction_false_release_dvp_MUTANT = 16
      THEN (induction_false_release_dvp_d)["assetA"]
      ELSE (induction_false_release_dvp_d)["assetB"],
    account |->
      IF induction_false_release_dvp_wrongAccount
      THEN IF induction_false_release_dvp_account = 0 THEN 1 ELSE 0
      ELSE induction_false_release_dvp_account,
    quantity |->
      IF induction_false_release_dvp_leg_2253 = 0
      THEN (induction_false_release_dvp_d)["security"]
      ELSE (induction_false_release_dvp_d)["cash"]]

(*
  @type: ((Int, Int) => { d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int });
*)
induction_false_release_dvp_bookingOutput(induction_false_release_dvp_t_2292, induction_false_release_dvp_outcome_2292) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  induction_false_release_dvp_d ==
    induction_false_release_dvp_desc(induction_false_release_dvp_t_2292)
  IN
  [d |->
      IF induction_false_release_dvp_MUTANT = 18
      THEN [
        (induction_false_release_dvp_d) EXCEPT
          !["sellerB"] =
            IF (induction_false_release_dvp_d)["sellerB"] = 0 THEN 1 ELSE 0
      ]
      ELSE IF induction_false_release_dvp_MUTANT = 19
      THEN [ (induction_false_release_dvp_d) EXCEPT !["cash"] = 4 ]
      ELSE induction_false_release_dvp_d,
    outcome |-> induction_false_release_dvp_outcome_2292]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Bool);
*)
localAtomicAt(x_826) ==
  \A t_824 \in induction_false_release_dvp_Trades:
    LET (*
      @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
    *)
    z == x_826["trades"][t_824]
    IN
    (z)["decision"] = 2 => (z)["effectsA"] = 1

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_sign(induction_false_release_dvp_t_2645, induction_false_release_dvp_party_2645) ==
  induction_false_release_dvp_t_2645 \in induction_false_release_dvp_Trades
    /\ induction_false_release_dvp_party_2645 \in { 0, 1 }
    /\ induction_false_release_dvp_s["admitted"]
    /\ induction_false_release_dvp_s["epoch"] = 0
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["signed"] =
            induction_false_release_dvp_s["signed"]
              \union {<<
                (induction_false_release_dvp_desc(induction_false_release_dvp_t_2645)),
                induction_false_release_dvp_party_2645
              >>}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
induction_false_release_dvp_authorized(induction_false_release_dvp_x_1975, induction_false_release_dvp_t_1975) ==
  <<(induction_false_release_dvp_desc(induction_false_release_dvp_t_1975)), 0>>
      \in induction_false_release_dvp_x_1975["signed"]
    /\ <<
      (induction_false_release_dvp_desc(induction_false_release_dvp_t_1975)), 1
    >>
      \in induction_false_release_dvp_x_1975["signed"]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
induction_false_release_dvp_reservedA(induction_false_release_dvp_x_1930) ==
  Cardinality({
    induction_false_release_dvp_t_1925 \in induction_false_release_dvp_Trades:
      induction_false_release_dvp_x_1930["trades"][
        induction_false_release_dvp_t_1925
      ][
        "holdA"
      ]
        = 1
  })
    * 2

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
induction_false_release_dvp_reservedB(induction_false_release_dvp_x_1951) ==
  Cardinality({
    induction_false_release_dvp_t_1946 \in induction_false_release_dvp_Trades:
      induction_false_release_dvp_x_1951["trades"][
        induction_false_release_dvp_t_1946
      ][
        "holdB"
      ]
        = 1
  })
    * 3

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }));
*)
AbortSpace ==
  {
    (LET (*
      @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
    *)
    d == induction_false_release_dvp_desc(v_301[1])
    IN
    [d |-> d,
      leg |-> v_301[2],
      genesis |-> IF v_301[2] = 0 THEN (d)["genesisA"] ELSE (d)["genesisB"],
      checkpoint |-> 0,
      program |-> 1,
      disposition |-> v_301[3]]):
      v_301 \in induction_false_release_dvp_Trades \X { 0, 1 } \X (0 .. 3)
  }

(*
  @type: (() => Set({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }));
*)
TradeSpace ==
  {
    z_7815 \in { (tradeDomainRow(v_7810)): v_7810 \in RawTradeParams }:
      tradeDomainIntent(z_7815)
  }

(*
  @type: (() => Bool);
*)
initControl == induction_false_release_dvp_init /\ pc' := 0

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
AuthenticFacts ==
  {
    (induction_false_release_dvp_fact(v_220[1], v_220[2])):
      v_220 \in induction_false_release_dvp_Trades \X (0 .. 6)
  }

(*
  @type: (() => Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }));
*)
OutputSpace ==
  {
    (induction_false_release_dvp_economicOutput(v_323[1], v_323[2], v_323[3])):
      v_323 \in induction_false_release_dvp_Trades \X { 0, 1 } \X { 0, 1 }
  }

(*
  @type: (() => Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }));
*)
BookingSpace ==
  {
    (induction_false_release_dvp_bookingOutput(v_339[1], v_339[2])):
      v_339 \in induction_false_release_dvp_Trades \X { 2, 3 }
  }

(*
  @type: (() => Bool);
*)
falseRelease ==
  induction_false_release_dvp_s["trades"][1]["knownB"] = 3
    /\ induction_false_release_dvp_s["trades"][1]["holdB"] = 1
    /\ induction_false_release_dvp_s'
      := [
        [
          induction_false_release_dvp_s EXCEPT
            !["economicReceipts"] =
              induction_false_release_dvp_s["economicReceipts"]
                \union {(induction_false_release_dvp_economicOutput(1, 1, 1))}
        ] EXCEPT
          !["trades"] =
            [
              induction_false_release_dvp_s["trades"] EXCEPT
                ![1] =
                  [
                    induction_false_release_dvp_s["trades"][1] EXCEPT
                      !["refundsB"] = 1
                  ]
            ]
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
induction_false_release_dvp_canOpen(induction_false_release_dvp_x_2429, induction_false_release_dvp_t_2429) ==
  induction_false_release_dvp_authorized(induction_false_release_dvp_x_2429, induction_false_release_dvp_t_2429)
    /\ induction_false_release_dvp_x_2429["admitted"]
    /\ <<induction_false_release_dvp_t_2429, 0>>
      \in induction_false_release_dvp_x_2429["eligible"]
    /\ ~(0 \in induction_false_release_dvp_x_2429["frozen"])
    /\ 0 \in induction_false_release_dvp_x_2429["up"]
    /\ (induction_false_release_dvp_HOST /= 3
      \/ 3 \in induction_false_release_dvp_x_2429["up"])
    /\ (IF induction_false_release_dvp_HOST = 0
      \/ induction_false_release_dvp_HOST = 3
    THEN induction_false_release_dvp_x_2429["height"]
        < induction_false_release_dvp_D
      \/ induction_false_release_dvp_MUTANT = 4
    ELSE TRUE)
    /\ (IF induction_false_release_dvp_HOST = 0
      \/ induction_false_release_dvp_HOST = 3
    THEN induction_false_release_dvp_x_2429["trades"][
        induction_false_release_dvp_t_2429
      ][
        "decision"
      ]
        = 0
      \/ (induction_false_release_dvp_MUTANT = 4
        /\ induction_false_release_dvp_x_2429["trades"][
          induction_false_release_dvp_t_2429
        ][
          "decision"
        ]
          = 3)
    ELSE induction_false_release_dvp_x_2429["trades"][
      induction_false_release_dvp_t_2429
    ][
      "knownA"
    ]
      = 0)
    /\ (induction_false_release_dvp_x_2429["trades"][
        induction_false_release_dvp_t_2429
      ][
        "holdA"
      ]
        = 0
      \/ (induction_false_release_dvp_MUTANT = 4
        /\ induction_false_release_dvp_x_2429["trades"][
          induction_false_release_dvp_t_2429
        ][
          "holdA"
        ]
          = 3))
    /\ (IF induction_false_release_dvp_ESCROW
    THEN induction_false_release_dvp_x_2429["ownerA"] >= 2
    ELSE induction_false_release_dvp_x_2429["ownerA"]
      - induction_false_release_dvp_reservedA(induction_false_release_dvp_x_2429)
      >= 2)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
induction_false_release_dvp_reserveA(induction_false_release_dvp_x_2513, induction_false_release_dvp_t_2513) ==
  [
    [
      [
        [
          induction_false_release_dvp_x_2513 EXCEPT
            !["trades"] =
              [
                induction_false_release_dvp_x_2513["trades"] EXCEPT
                  ![induction_false_release_dvp_t_2513] =
                    [
                      [
                        [
                          [
                            induction_false_release_dvp_x_2513["trades"][
                              induction_false_release_dvp_t_2513
                            ] EXCEPT
                              !["decision"] =
                                IF induction_false_release_dvp_HOST = 0
                                  \/ induction_false_release_dvp_HOST = 3
                                THEN 1
                                ELSE induction_false_release_dvp_x_2513[
                                  "trades"
                                ][
                                  induction_false_release_dvp_t_2513
                                ][
                                  "decision"
                                ]
                          ] EXCEPT
                            !["holdA"] = 1
                        ] EXCEPT
                          !["intent"] = TRUE
                      ] EXCEPT
                        !["preparedA"] = TRUE
                    ]
              ]
        ] EXCEPT
          !["ownerA"] =
            IF induction_false_release_dvp_ESCROW
            THEN induction_false_release_dvp_x_2513["ownerA"] - 2
            ELSE induction_false_release_dvp_x_2513["ownerA"]
      ] EXCEPT
        !["vaultA"] =
          IF induction_false_release_dvp_ESCROW
          THEN induction_false_release_dvp_x_2513["vaultA"] + 2
          ELSE induction_false_release_dvp_x_2513["vaultA"]
    ] EXCEPT
      !["included"] =
        induction_false_release_dvp_x_2513["included"]
          \union { (induction_false_release_dvp_fact(induction_false_release_dvp_t_2513,
            0)),
            (induction_false_release_dvp_fact(induction_false_release_dvp_t_2513,
            1)) }
  ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }, Int, Int) => Bool);
*)
induction_false_release_dvp_authFact(induction_false_release_dvp_x_2024, induction_false_release_dvp_f_2024,
induction_false_release_dvp_t_2024, induction_false_release_dvp_p_2024) ==
  induction_false_release_dvp_f_2024
      \in induction_false_release_dvp_x_2024["proofs"]
    /\ induction_false_release_dvp_f_2024["d"]
      = induction_false_release_dvp_desc(induction_false_release_dvp_t_2024)
    /\ induction_false_release_dvp_f_2024["phase"]
      = induction_false_release_dvp_p_2024
    /\ induction_false_release_dvp_f_2024["checkpoint"] = 0
    /\ induction_false_release_dvp_f_2024["program"]
      \in induction_false_release_dvp_x_2024["historical"]
    /\ induction_false_release_dvp_f_2024["root"]
      = (induction_false_release_dvp_fact(induction_false_release_dvp_t_2024, induction_false_release_dvp_p_2024))[
        "root"
      ]

(*
  @type: ((Int) => Bool);
*)
induction_false_release_dvp_abort(induction_false_release_dvp_t_4100) ==
  induction_false_release_dvp_HOST \in induction_false_release_dvp_s["up"]
    /\ 2 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_authorized(induction_false_release_dvp_s, induction_false_release_dvp_t_4100)
    /\ induction_false_release_dvp_s["height"] >= induction_false_release_dvp_D
    /\ induction_false_release_dvp_s["trades"][
      induction_false_release_dvp_t_4100
    ][
      "decision"
    ]
      < 2
    /\ induction_false_release_dvp_s'
      := [
        [
          induction_false_release_dvp_s EXCEPT
            !["included"] =
              induction_false_release_dvp_s["included"]
                \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_4100,
                4))}
        ] EXCEPT
          !["trades"] =
            [
              induction_false_release_dvp_s["trades"] EXCEPT
                ![induction_false_release_dvp_t_4100] =
                  [
                    [
                      [
                        [
                          induction_false_release_dvp_s["trades"][
                            induction_false_release_dvp_t_4100
                          ] EXCEPT
                            !["decision"] = 3
                        ] EXCEPT
                          !["oldTerminal"] =
                            IF induction_false_release_dvp_s["trades"][
                              induction_false_release_dvp_t_4100
                            ][
                              "oldTerminal"
                            ]
                              = 0
                            THEN 3
                            ELSE induction_false_release_dvp_s["trades"][
                              induction_false_release_dvp_t_4100
                            ][
                              "oldTerminal"
                            ]
                      ] EXCEPT
                        !["knownA"] =
                          IF induction_false_release_dvp_HOST = 0
                            \/ induction_false_release_dvp_HOST = 3
                          THEN 3
                          ELSE induction_false_release_dvp_s["trades"][
                            induction_false_release_dvp_t_4100
                          ][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF induction_false_release_dvp_HOST = 1
                          \/ induction_false_release_dvp_HOST = 3
                        THEN 3
                        ELSE induction_false_release_dvp_s["trades"][
                          induction_false_release_dvp_t_4100
                        ][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_finalize(induction_false_release_dvp_t_3036, induction_false_release_dvp_p_3036) ==
  induction_false_release_dvp_fact(induction_false_release_dvp_t_3036, induction_false_release_dvp_p_3036)
      \in induction_false_release_dvp_s["included"]
    /\ (IF induction_false_release_dvp_HOST = 3
    THEN 3
    ELSE IF induction_false_release_dvp_p_3036 = 2
      \/ induction_false_release_dvp_p_3036 = 6
    THEN 1
    ELSE IF induction_false_release_dvp_p_3036 = 3
      \/ induction_false_release_dvp_p_3036 = 4
    THEN induction_false_release_dvp_HOST
    ELSE 0)
      \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["finalized"] =
            induction_false_release_dvp_s["finalized"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_3036,
              induction_false_release_dvp_p_3036))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_capture(induction_false_release_dvp_t_3077, induction_false_release_dvp_p_3077) ==
  3 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_fact(induction_false_release_dvp_t_3077, induction_false_release_dvp_p_3077)
      \in induction_false_release_dvp_s["finalized"]
    /\ ~(induction_false_release_dvp_fact(induction_false_release_dvp_t_3077, induction_false_release_dvp_p_3077)
      \in induction_false_release_dvp_s["pruned"])
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["captured"] =
            induction_false_release_dvp_s["captured"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_3077,
              induction_false_release_dvp_p_3077))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_prove(induction_false_release_dvp_t_3120, induction_false_release_dvp_p_3120) ==
  3 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_fact(induction_false_release_dvp_t_3120, induction_false_release_dvp_p_3120)
      \in induction_false_release_dvp_s["captured"]
    /\ induction_false_release_dvp_s'
      := [
        [
          induction_false_release_dvp_s EXCEPT
            !["proofs"] =
              induction_false_release_dvp_s["proofs"]
                \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_3120,
                induction_false_release_dvp_p_3120))}
        ] EXCEPT
          !["network"] =
            induction_false_release_dvp_s["network"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_3120,
              induction_false_release_dvp_p_3120))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_deliver(induction_false_release_dvp_t_3303, induction_false_release_dvp_p_3303) ==
  4 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_fact(induction_false_release_dvp_t_3303, induction_false_release_dvp_p_3303)
      \in induction_false_release_dvp_s["network"]
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["received"] =
            induction_false_release_dvp_s["received"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_3303,
              induction_false_release_dvp_p_3303))}
      ]

(*
  @type: (() => Bool);
*)
localCommitAtomicity == localAtomicAt(induction_false_release_dvp_s)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Bool);
*)
physicalInvariant(x_935) ==
  localAtomicAt(x_935)
    /\ (\A t_932 \in induction_false_release_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == x_935["trades"][t_932]
      IN
      (z)["holdA"] \in 0 .. 3
        /\ (z)["holdB"] \in 0 .. 3
        /\ (z)["effectsA"] \in 0 .. 1
        /\ (z)["effectsB"] \in 0 .. 1
        /\ (z)["refundsA"] \in 0 .. 1
        /\ (z)["refundsB"] \in 0 .. 1
        /\ ((z)["holdA"] = 2 <=> (z)["effectsA"] = 1)
        /\ ((z)["holdB"] = 2 <=> (z)["effectsB"] = 1)
        /\ ((z)["holdA"] = 3 <=> (z)["refundsA"] = 1)
        /\ ((z)["holdB"] = 3 <=> (z)["refundsB"] = 1))

(*
  @type: ((Int, Int, Int) => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
*)
domainFact(t_205, p_205, binding_205) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  f == induction_false_release_dvp_fact(t_205, p_205)
  IN
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  bad ==
    IF binding_205 = 0
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["trade"] = 3 - t_205 ] ]
    ELSE IF binding_205 = 1
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["nonce"] = 99 ] ]
    ELSE IF binding_205 = 2
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["sellerB"] = 99 ] ]
    ELSE IF binding_205 = 3
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["cash"] = 4 ] ]
    ELSE IF binding_205 = 4
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["genesisB"] = 999 ] ]
    ELSE IF binding_205 = 5
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["decisionDomain"] = 99 ] ]
    ELSE IF binding_205 = 6
    THEN [ (f) EXCEPT !["phase"] = 6 ]
    ELSE IF binding_205 = 7
    THEN [ (f) EXCEPT !["checkpoint"] = 99 ]
    ELSE IF binding_205 = 8
    THEN [ (f) EXCEPT !["program"] = 99 ]
    ELSE IF binding_205 = 9
    THEN [
      (f) EXCEPT
        !["d"] = [ [ (f)["d"] EXCEPT !["assetB"] = 99 ] EXCEPT !["holdB"] = 99 ]
    ]
    ELSE [ (f) EXCEPT !["root"] = 999 ]
  IN
  bad

(*
  @type: ((Int) => Bool);
*)
induction_false_release_dvp_openA(induction_false_release_dvp_t_2659) ==
  induction_false_release_dvp_canOpen(induction_false_release_dvp_s, induction_false_release_dvp_t_2659)
    /\ induction_false_release_dvp_s'
      := induction_false_release_dvp_reserveA(induction_false_release_dvp_s, induction_false_release_dvp_t_2659)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
induction_false_release_dvp_has(induction_false_release_dvp_x_2044, induction_false_release_dvp_t_2044,
induction_false_release_dvp_p_2044) ==
  \E induction_false_release_dvp_f_2042 \in induction_false_release_dvp_x_2044[
    "received"
  ]:
    induction_false_release_dvp_authFact(induction_false_release_dvp_x_2044, induction_false_release_dvp_f_2042,
    induction_false_release_dvp_t_2044, induction_false_release_dvp_p_2044)

(*
  @type: (() => Bool);
*)
effectSoundness ==
  localCommitAtomicity
    /\ (\A t_1050 \in induction_false_release_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == induction_false_release_dvp_s["trades"][t_1050]
      IN
      ((z)["effectsA"] > 0 => (z)["holdA"] = 2)
        /\ ((z)["effectsB"] > 0 => (z)["holdB"] = 2)
        /\ ((z)["refundsA"] > 0 => (z)["holdA"] = 3)
        /\ ((z)["refundsB"] > 0 => (z)["holdB"] = 3)
        /\ ((z)["holdA"] = 1 => (z)["effectsA"] = 0 /\ (z)["refundsA"] = 0)
        /\ ((z)["holdB"] = 1 => (z)["effectsB"] = 0 /\ (z)["refundsB"] = 0))

(*
  @type: (() => Bool);
*)
ICore == physicalInvariant(induction_false_release_dvp_s)

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
CandidateFacts ==
  {
    (domainFact(v_242[1], v_242[2], v_242[3])):
      v_242 \in induction_false_release_dvp_Trades \X (0 .. 6) \X (0 .. 10)
  }

(*
  @type: ((Int) => Bool);
*)
induction_false_release_dvp_prepareB(induction_false_release_dvp_t_2883) ==
  induction_false_release_dvp_authorized(induction_false_release_dvp_s, induction_false_release_dvp_t_2883)
    /\ induction_false_release_dvp_s["admitted"]
    /\ <<induction_false_release_dvp_t_2883, 1>>
      \in induction_false_release_dvp_s["eligible"]
    /\ ~(1 \in induction_false_release_dvp_s["frozen"])
    /\ 1 \in induction_false_release_dvp_s["up"]
    /\ (induction_false_release_dvp_HOST /= 3
      \/ 3 \in induction_false_release_dvp_s["up"])
    /\ induction_false_release_dvp_s["trades"][
      induction_false_release_dvp_t_2883
    ][
      "knownB"
    ]
      = 0
    /\ induction_false_release_dvp_s["trades"][
      induction_false_release_dvp_t_2883
    ][
      "holdB"
    ]
      = 0
    /\ (~induction_false_release_dvp_OPEN_REQUIRED
      \/ induction_false_release_dvp_has(induction_false_release_dvp_s, induction_false_release_dvp_t_2883,
      0))
    /\ (IF induction_false_release_dvp_ESCROW
    THEN induction_false_release_dvp_s["ownerB"] >= 3
    ELSE induction_false_release_dvp_s["ownerB"]
      - induction_false_release_dvp_reservedB(induction_false_release_dvp_s)
      >= 3)
    /\ induction_false_release_dvp_s'
      := [
        [
          [
            [
              induction_false_release_dvp_s EXCEPT
                !["trades"] =
                  [
                    induction_false_release_dvp_s["trades"] EXCEPT
                      ![induction_false_release_dvp_t_2883] =
                        [
                          [
                            [
                              induction_false_release_dvp_s["trades"][
                                induction_false_release_dvp_t_2883
                              ] EXCEPT
                                !["holdB"] = 1
                            ] EXCEPT
                              !["intent"] = TRUE
                          ] EXCEPT
                            !["preparedB"] = TRUE
                        ]
                  ]
            ] EXCEPT
              !["ownerB"] =
                IF induction_false_release_dvp_ESCROW
                THEN induction_false_release_dvp_s["ownerB"] - 3
                ELSE induction_false_release_dvp_s["ownerB"]
          ] EXCEPT
            !["vaultB"] =
              IF induction_false_release_dvp_ESCROW
              THEN induction_false_release_dvp_s["vaultB"] + 3
              ELSE induction_false_release_dvp_s["vaultB"]
        ] EXCEPT
          !["included"] =
            induction_false_release_dvp_s["included"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2883,
              2))}
      ]

(*
  @type: ((Int, Int, Int) => Bool);
*)
induction_false_release_dvp_learn(induction_false_release_dvp_t_4190, induction_false_release_dvp_outcome_4190,
induction_false_release_dvp_leg_4190) ==
  induction_false_release_dvp_leg_4190 \in induction_false_release_dvp_s["up"]
    /\ (induction_false_release_dvp_HOST /= 3
      \/ 3 \in induction_false_release_dvp_s["up"])
    /\ induction_false_release_dvp_has(induction_false_release_dvp_s, induction_false_release_dvp_t_4190,
    (IF induction_false_release_dvp_outcome_4190 = 2 THEN 3 ELSE 4))
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["trades"] =
            [
              induction_false_release_dvp_s["trades"] EXCEPT
                ![induction_false_release_dvp_t_4190] =
                  [
                    [
                      induction_false_release_dvp_s["trades"][
                        induction_false_release_dvp_t_4190
                      ] EXCEPT
                        !["knownA"] =
                          IF induction_false_release_dvp_leg_4190 = 0
                          THEN induction_false_release_dvp_outcome_4190
                          ELSE induction_false_release_dvp_s["trades"][
                            induction_false_release_dvp_t_4190
                          ][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF induction_false_release_dvp_leg_4190 = 1
                          /\ (induction_false_release_dvp_MUTANT /= 9
                            \/ induction_false_release_dvp_s["trades"][
                              induction_false_release_dvp_t_4190
                            ][
                              "holdB"
                            ]
                              /= 0)
                        THEN induction_false_release_dvp_outcome_4190
                        ELSE induction_false_release_dvp_s["trades"][
                          induction_false_release_dvp_t_4190
                        ][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
FactSpace ==
  (AuthenticFacts \union CandidateFacts)
    \union { ([ f_254 EXCEPT !["program"] = 0 ]): f_254 \in AuthenticFacts }

(*
  @type: (() => Bool);
*)
stepControl ==
  (pc = 0 /\ induction_false_release_dvp_sign(1, 0) /\ pc' := pc + 1)
    \/ (pc = 1 /\ induction_false_release_dvp_sign(1, 1) /\ pc' := pc + 1)
    \/ (pc = 2 /\ induction_false_release_dvp_openA(1) /\ pc' := pc + 1)
    \/ (pc = 3 /\ induction_false_release_dvp_prepareB(1) /\ pc' := pc + 1)
    \/ (pc = 4 /\ induction_false_release_dvp_tick /\ pc' := pc + 1)
    \/ (pc = 5 /\ induction_false_release_dvp_tick /\ pc' := pc + 1)
    \/ (pc = 6 /\ induction_false_release_dvp_abort(1) /\ pc' := pc + 1)
    \/ (pc = 7 /\ induction_false_release_dvp_finalize(1, 4) /\ pc' := pc + 1)
    \/ (pc = 8 /\ induction_false_release_dvp_capture(1, 4) /\ pc' := pc + 1)
    \/ (pc = 9 /\ induction_false_release_dvp_prove(1, 4) /\ pc' := pc + 1)
    \/ (pc = 10 /\ induction_false_release_dvp_deliver(1, 4) /\ pc' := pc + 1)
    \/ (pc = 11 /\ induction_false_release_dvp_learn(1, 3, 1) /\ pc' := pc + 1)
    \/ (pc = 12 /\ falseRelease /\ pc' := pc + 1)

(*
  @type: (() => Set({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }));
*)
StateSpace ==
  {
    ([trades |-> v_559[1],
      signed |-> v_559[2],
      height |-> v_559[3],
      ownerA |-> v_559[4],
      ownerB |-> v_559[5],
      vaultA |-> v_559[6],
      vaultB |-> v_559[7],
      spentA |-> v_559[8],
      spentB |-> v_559[9],
      receivedA |-> v_559[10],
      receivedB |-> v_559[11],
      economicReceipts |-> v_559[12],
      financialRecords |-> v_559[13],
      included |-> v_559[14],
      finalized |-> v_559[15],
      captured |-> v_559[16],
      proofs |-> v_559[17],
      network |-> v_559[18],
      received |-> v_559[19],
      abortRecords |-> v_559[20],
      pruned |-> v_559[21],
      up |-> v_559[22],
      epoch |-> v_559[23],
      admitted |-> v_559[24],
      historical |-> v_559[25],
      eligible |-> v_559[26],
      frozen |-> v_559[27],
      note |-> v_559[28],
      rejects |-> v_559[29],
      transportCompromised |-> v_559[30],
      custody |-> v_559[31],
      upgrade |-> v_559[32],
      validator |-> v_559[33],
      decrypt |-> v_559[34]]):
      v_559 \in
        [(induction_false_release_dvp_Trades) -> (TradeSpace)]
          \X (SUBSET ({
              (induction_false_release_dvp_desc(t_349)):
                t_349 \in induction_false_release_dvp_Trades
            }
            \X { 0, 1 }))
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X [(induction_false_release_dvp_Trades) -> Int]
          \X [(induction_false_release_dvp_Trades) -> Int]
          \X (SUBSET OutputSpace)
          \X (SUBSET BookingSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET AbortSpace)
          \X (SUBSET FactSpace)
          \X (SUBSET (0 .. 4))
          \X Int
          \X BOOLEAN
          \X (SUBSET ({ 1, 2 }))
          \X (SUBSET (induction_false_release_dvp_Trades \X { 0, 1 }))
          \X (SUBSET ({ 0, 1 }))
          \X (SUBSET induction_false_release_dvp_Trades)
          \X (SUBSET (0 .. 10))
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
  }

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Bool);
*)
domainByFields(x_799) ==
  (DOMAIN (x_799["trades"]) = induction_false_release_dvp_Trades
      /\ (\A t_583 \in induction_false_release_dvp_Trades:
        tradeDomainContains(x_799["trades"][t_583])))
    /\ x_799["signed"]
      \subseteq {
          (induction_false_release_dvp_desc(t_593)):
            t_593 \in induction_false_release_dvp_Trades
        }
        \X { 0, 1 }
    /\ x_799["height"] \in Int
    /\ x_799["ownerA"] \in Int
    /\ x_799["ownerB"] \in Int
    /\ x_799["vaultA"] \in Int
    /\ x_799["vaultB"] \in Int
    /\ x_799["spentA"] \in Int
    /\ x_799["spentB"] \in Int
    /\ (DOMAIN (x_799["receivedA"]) = induction_false_release_dvp_Trades
      /\ (\A t_650 \in induction_false_release_dvp_Trades:
        x_799["receivedA"][t_650] \in Int))
    /\ (DOMAIN (x_799["receivedB"]) = induction_false_release_dvp_Trades
      /\ (\A t_668 \in induction_false_release_dvp_Trades:
        x_799["receivedB"][t_668] \in Int))
    /\ x_799["economicReceipts"] \subseteq OutputSpace
    /\ x_799["financialRecords"] \subseteq BookingSpace
    /\ x_799["included"] \subseteq FactSpace
    /\ x_799["finalized"] \subseteq FactSpace
    /\ x_799["captured"] \subseteq FactSpace
    /\ x_799["proofs"] \subseteq FactSpace
    /\ x_799["network"] \subseteq FactSpace
    /\ x_799["received"] \subseteq FactSpace
    /\ x_799["abortRecords"] \subseteq AbortSpace
    /\ x_799["pruned"] \subseteq FactSpace
    /\ x_799["up"] \subseteq 0 .. 4
    /\ x_799["epoch"] \in Int
    /\ x_799["admitted"] \in BOOLEAN
    /\ x_799["historical"] \subseteq { 1, 2 }
    /\ x_799["eligible"]
      \subseteq induction_false_release_dvp_Trades \X { 0, 1 }
    /\ x_799["frozen"] \subseteq { 0, 1 }
    /\ x_799["note"] \subseteq induction_false_release_dvp_Trades
    /\ x_799["rejects"] \subseteq 0 .. 10
    /\ x_799["transportCompromised"] \in BOOLEAN
    /\ x_799["custody"] \in BOOLEAN
    /\ x_799["upgrade"] \in BOOLEAN
    /\ x_799["validator"] \in BOOLEAN
    /\ x_799["decrypt"] \in BOOLEAN

(*
  @type: (() => Bool);
*)
arbitraryInductive ==
  \E t1_decision \in Int:
    \E t1_oldTerminal \in Int:
      \E t1_holdA \in Int:
        \E t1_holdB \in Int:
          \E t1_effectsA \in Int:
            \E t1_effectsB \in Int:
              \E t1_refundsA \in Int:
                \E t1_refundsB \in Int:
                  \E t1_knownA \in Int:
                    \E t1_knownB \in Int:
                      \E t1_preparedA \in BOOLEAN:
                        \E t1_preparedB \in BOOLEAN:
                          \E t1_appliedEvidenceA \in BOOLEAN:
                            \E t1_appliedEvidenceB \in BOOLEAN:
                              \E t1_booked \in Int:
                                \E t1_report \in Int:
                                  \E t1_stale \in BOOLEAN:
                                    \E t1_intent \in BOOLEAN:
                                      \E v_signed \in SUBSET ({
                                          (induction_false_release_dvp_desc(t_1112)):
                                            t_1112 \in
                                              induction_false_release_dvp_Trades
                                        }
                                        \X { 0, 1 }):
                                        \E v_height \in Int:
                                          \E v_ownerA \in Int:
                                            \E v_ownerB \in Int:
                                              \E v_vaultA \in Int:
                                                \E v_vaultB \in Int:
                                                  \E v_spentA \in Int:
                                                    \E v_spentB \in Int:
                                                      \E receivedA1 \in Int:
                                                        \E receivedB1 \in Int:
                                                          \E v_economicReceipts \in
                                                          SUBSET OutputSpace:
                                                            \E v_financialRecords \in
                                                            SUBSET BookingSpace:
                                                              \E v_included \in SUBSET FactSpace:
                                                                \E v_finalized \in
                                                                SUBSET FactSpace:
                                                                  \E v_captured \in
                                                                  SUBSET FactSpace:
                                                                    \E v_proofs \in
                                                                    SUBSET FactSpace:
                                                                      \E v_network \in
                                                                      SUBSET FactSpace:
                                                                        \E v_received \in
                                                                        SUBSET FactSpace:
                                                                          \E v_abortRecords \in
                                                                          SUBSET AbortSpace:
                                                                            \E v_pruned \in
                                                                            SUBSET FactSpace:
                                                                              \E v_up \in
                                                                              SUBSET (0
                                                                                .. 4):
                                                                                \E v_epoch \in
                                                                                Int:
                                                                                  \E v_admitted \in
                                                                                  BOOLEAN:
                                                                                    \E v_historical \in
                                                                                    SUBSET ({
                                                                                    1,
                                                                                      2
                                                                                    }):
                                                                                      \E v_eligible \in
                                                                                      SUBSET (induction_false_release_dvp_Trades
                                                                                        \X {
                                                                                        0,
                                                                                          1
                                                                                        }):
                                                                                        \E v_frozen \in
                                                                                        SUBSET ({
                                                                                        0,
                                                                                          1
                                                                                        }):
                                                                                          \E v_note \in
                                                                                          SUBSET induction_false_release_dvp_Trades:
                                                                                            \E v_rejects \in
                                                                                            SUBSET (0
                                                                                              .. 10):
                                                                                              \E v_transportCompromised \in
                                                                                              BOOLEAN:
                                                                                                \E v_custody \in
                                                                                                BOOLEAN:
                                                                                                  \E v_upgrade \in
                                                                                                  BOOLEAN:
                                                                                                    \E v_validator \in
                                                                                                    BOOLEAN:
                                                                                                      \E v_decrypt \in
                                                                                                      BOOLEAN:
                                                                                                        \E programCounter \in
                                                                                                        Int:
                                                                                                          LET (*
                                                                                                            @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
                                                                                                          *)
                                                                                                          candidate ==
                                                                                                            [trades |->
                                                                                                                SetAsFun({<<
                                                                                                                  1,
                                                                                                                  [decision |->
                                                                                                                      t1_decision,
                                                                                                                    oldTerminal |->
                                                                                                                      t1_oldTerminal,
                                                                                                                    holdA |->
                                                                                                                      t1_holdA,
                                                                                                                    holdB |->
                                                                                                                      t1_holdB,
                                                                                                                    effectsA |->
                                                                                                                      t1_effectsA,
                                                                                                                    effectsB |->
                                                                                                                      t1_effectsB,
                                                                                                                    refundsA |->
                                                                                                                      t1_refundsA,
                                                                                                                    refundsB |->
                                                                                                                      t1_refundsB,
                                                                                                                    knownA |->
                                                                                                                      t1_knownA,
                                                                                                                    knownB |->
                                                                                                                      t1_knownB,
                                                                                                                    preparedA |->
                                                                                                                      t1_preparedA,
                                                                                                                    preparedB |->
                                                                                                                      t1_preparedB,
                                                                                                                    appliedEvidenceA |->
                                                                                                                      t1_appliedEvidenceA,
                                                                                                                    appliedEvidenceB |->
                                                                                                                      t1_appliedEvidenceB,
                                                                                                                    booked |->
                                                                                                                      t1_booked,
                                                                                                                    report |->
                                                                                                                      t1_report,
                                                                                                                    stale |->
                                                                                                                      t1_stale,
                                                                                                                    intent |->
                                                                                                                      t1_intent]
                                                                                                                >>}),
                                                                                                              signed |->
                                                                                                                v_signed,
                                                                                                              height |->
                                                                                                                v_height,
                                                                                                              ownerA |->
                                                                                                                v_ownerA,
                                                                                                              ownerB |->
                                                                                                                v_ownerB,
                                                                                                              vaultA |->
                                                                                                                v_vaultA,
                                                                                                              vaultB |->
                                                                                                                v_vaultB,
                                                                                                              spentA |->
                                                                                                                v_spentA,
                                                                                                              spentB |->
                                                                                                                v_spentB,
                                                                                                              receivedA |->
                                                                                                                SetAsFun({<<
                                                                                                                  1,
                                                                                                                  receivedA1
                                                                                                                >>}),
                                                                                                              receivedB |->
                                                                                                                SetAsFun({<<
                                                                                                                  1,
                                                                                                                  receivedB1
                                                                                                                >>}),
                                                                                                              economicReceipts |->
                                                                                                                v_economicReceipts,
                                                                                                              financialRecords |->
                                                                                                                v_financialRecords,
                                                                                                              included |->
                                                                                                                v_included,
                                                                                                              finalized |->
                                                                                                                v_finalized,
                                                                                                              captured |->
                                                                                                                v_captured,
                                                                                                              proofs |->
                                                                                                                v_proofs,
                                                                                                              network |->
                                                                                                                v_network,
                                                                                                              received |->
                                                                                                                v_received,
                                                                                                              abortRecords |->
                                                                                                                v_abortRecords,
                                                                                                              pruned |->
                                                                                                                v_pruned,
                                                                                                              up |->
                                                                                                                v_up,
                                                                                                              epoch |->
                                                                                                                v_epoch,
                                                                                                              admitted |->
                                                                                                                v_admitted,
                                                                                                              historical |->
                                                                                                                v_historical,
                                                                                                              eligible |->
                                                                                                                v_eligible,
                                                                                                              frozen |->
                                                                                                                v_frozen,
                                                                                                              note |->
                                                                                                                v_note,
                                                                                                              rejects |->
                                                                                                                v_rejects,
                                                                                                              transportCompromised |->
                                                                                                                v_transportCompromised,
                                                                                                              custody |->
                                                                                                                v_custody,
                                                                                                              upgrade |->
                                                                                                                v_upgrade,
                                                                                                              validator |->
                                                                                                                v_validator,
                                                                                                              decrypt |->
                                                                                                                v_decrypt]
                                                                                                          IN
                                                                                                          (\A t_1371 \in
                                                                                                            induction_false_release_dvp_Trades:
                                                                                                              tradeDomainContains((candidate)[
                                                                                                                "trades"
                                                                                                              ][
                                                                                                                t_1371
                                                                                                              ]))
                                                                                                            /\ physicalInvariant((candidate))
                                                                                                            /\ induction_false_release_dvp_s
                                                                                                              = candidate
                                                                                                            /\ pc
                                                                                                              = programCounter

(*
  @type: (() => Bool);
*)
FullTypeOK == induction_false_release_dvp_s \in StateSpace

(*
  @type: (() => Bool);
*)
effectIExpanded ==
  (domainByFields(induction_false_release_dvp_s) /\ ICore) /\ pc \in Int

(*
  @type: (() => Bool);
*)
q_init == arbitraryInductive

(*
  @type: (() => Bool);
*)
q_step == stepControl

(*
  @type: (() => Bool);
*)
effectI == (FullTypeOK /\ ICore) /\ pc \in Int

(*
  @type: (() => Bool);
*)
inductionInit == effectI /\ effectIExpanded

(*
  @type: (() => Bool);
*)
q_inv == effectI

================================================================================

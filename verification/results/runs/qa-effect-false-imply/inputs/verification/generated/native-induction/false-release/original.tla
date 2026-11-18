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
tradeDomainRow(v_7193) ==
  [decision |-> v_7193[1],
    oldTerminal |-> IF v_7193[1] >= 2 THEN v_7193[1] ELSE 0,
    holdA |-> v_7193[2],
    holdB |-> v_7193[3],
    effectsA |-> IF v_7193[2] = 2 THEN 1 ELSE 0,
    effectsB |-> IF v_7193[3] = 2 THEN 1 ELSE 0,
    refundsA |-> IF v_7193[2] = 3 THEN 1 ELSE 0,
    refundsB |-> IF v_7193[3] = 3 THEN 1 ELSE 0,
    knownA |-> v_7193[4],
    knownB |-> v_7193[5],
    preparedA |-> v_7193[2] /= 0,
    preparedB |-> v_7193[3] /= 0,
    appliedEvidenceA |-> v_7193[6]["appliedEvidenceA"],
    appliedEvidenceB |-> v_7193[6]["appliedEvidenceB"],
    booked |-> v_7193[6]["booked"],
    report |-> v_7193[6]["report"],
    stale |-> v_7193[6]["stale"],
    intent |-> v_7193[7]]

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => Bool);
*)
tradeDomainIntent(z_7221) ==
  z_7221["intent"]
    \/ ((z_7221["holdA"] = 0 /\ z_7221["holdB"] = 0)
      /\ z_7221["decision"] \in { 0, 3 })

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, report: Int, stale: Bool });
*)
tradeDomainAux(z_7247) ==
  [appliedEvidenceA |-> z_7247["appliedEvidenceA"],
    appliedEvidenceB |-> z_7247["appliedEvidenceB"],
    booked |-> z_7247["booked"],
    report |-> z_7247["report"],
    stale |-> z_7247["stale"]]

(*
  @type: (() => Set(Int));
*)
induction_false_release_dvp_Trades == 1 .. induction_false_release_dvp_N

(*
  @type: ((Int) => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
*)
induction_false_release_dvp_desc(induction_false_release_dvp_t_1309) ==
  [trade |-> induction_false_release_dvp_t_1309,
    nonce |-> induction_false_release_dvp_t_1309,
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
    buyerA |-> induction_false_release_dvp_t_1309,
    buyerB |->
      IF induction_false_release_dvp_HOST = 3
      THEN induction_false_release_dvp_t_1309
      ELSE 0,
    sellerB |->
      IF induction_false_release_dvp_HOST = 3
      THEN 0
      ELSE induction_false_release_dvp_t_1309,
    deadline |-> induction_false_release_dvp_D,
    protocol |-> 1,
    epoch |-> 0,
    commitment |-> 1000 + induction_false_release_dvp_t_1309]

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
tradeDomainContains(z_7407) ==
  z_7407["decision"] \in 0 .. 3
    /\ z_7407["holdA"] \in 0 .. 3
    /\ z_7407["holdB"] \in 0 .. 3
    /\ z_7407["knownA"] \in { 0, 2, 3 }
    /\ z_7407["knownB"] \in { 0, 2, 3 }
    /\ z_7407["intent"] \in BOOLEAN
    /\ z_7407["oldTerminal"]
      = (IF z_7407["decision"] >= 2 THEN z_7407["decision"] ELSE 0)
    /\ z_7407["effectsA"] = (IF z_7407["holdA"] = 2 THEN 1 ELSE 0)
    /\ z_7407["effectsB"] = (IF z_7407["holdB"] = 2 THEN 1 ELSE 0)
    /\ z_7407["refundsA"] = (IF z_7407["holdA"] = 3 THEN 1 ELSE 0)
    /\ z_7407["refundsB"] = (IF z_7407["holdB"] = 3 THEN 1 ELSE 0)
    /\ z_7407["preparedA"] = (z_7407["holdA"] /= 0)
    /\ z_7407["preparedB"] = (z_7407["holdB"] /= 0)
    /\ tradeDomainAux(z_7407) \in AuxSpace
    /\ tradeDomainIntent(z_7407)

(*
  @type: (() => Bool);
*)
induction_false_release_dvp_init ==
  induction_false_release_dvp_s
    = [trades |->
        [
          induction_false_release_dvp___2121 \in
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
          induction_false_release_dvp___2143 \in
            induction_false_release_dvp_Trades |->
            0
        ],
      receivedB |->
        [
          induction_false_release_dvp___2149 \in
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
induction_false_release_dvp_fact(induction_false_release_dvp_t_1341, induction_false_release_dvp_p_1341) ==
  [d |-> induction_false_release_dvp_desc(induction_false_release_dvp_t_1341),
    phase |-> induction_false_release_dvp_p_1341,
    checkpoint |-> 0,
    program |-> 1,
    root |->
      (200 + induction_false_release_dvp_p_1341 * 10)
        + induction_false_release_dvp_t_1341]

(*
  @type: ((Int, Int, Int) => { account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int });
*)
induction_false_release_dvp_economicOutput(induction_false_release_dvp_t_1856, induction_false_release_dvp_leg_1856,
induction_false_release_dvp_kind_1856) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  induction_false_release_dvp_d ==
    induction_false_release_dvp_desc(induction_false_release_dvp_t_1856)
  IN
  LET (*
    @type: (() => Int);
  *)
  induction_false_release_dvp_account ==
    IF induction_false_release_dvp_leg_1856 = 0
    THEN IF induction_false_release_dvp_kind_1856 = 0
    THEN (induction_false_release_dvp_d)["buyerA"]
    ELSE (induction_false_release_dvp_d)["sellerA"]
    ELSE IF induction_false_release_dvp_kind_1856 = 0
    THEN (induction_false_release_dvp_d)["sellerB"]
    ELSE (induction_false_release_dvp_d)["buyerB"]
  IN
  LET (*
    @type: (() => Bool);
  *)
  induction_false_release_dvp_wrongAccount ==
    (induction_false_release_dvp_leg_1856 = 0
        /\ ((induction_false_release_dvp_kind_1856 = 0
            /\ induction_false_release_dvp_MUTANT = 11)
          \/ (induction_false_release_dvp_kind_1856 = 1
            /\ induction_false_release_dvp_MUTANT = 14)))
      \/ (induction_false_release_dvp_leg_1856 = 1
        /\ ((induction_false_release_dvp_kind_1856 = 0
            /\ induction_false_release_dvp_MUTANT = 15)
          \/ (induction_false_release_dvp_kind_1856 = 1
            /\ induction_false_release_dvp_MUTANT = 17)))
  IN
  [trade |-> induction_false_release_dvp_t_1856,
    leg |-> induction_false_release_dvp_leg_1856,
    kind |-> induction_false_release_dvp_kind_1856,
    chain |->
      IF induction_false_release_dvp_leg_1856 = 0
      THEN (induction_false_release_dvp_d)["chainA"]
      ELSE (induction_false_release_dvp_d)["chainB"],
    genesis |->
      IF induction_false_release_dvp_leg_1856 = 0
      THEN (induction_false_release_dvp_d)["genesisA"]
      ELSE (induction_false_release_dvp_d)["genesisB"],
    asset |->
      IF induction_false_release_dvp_leg_1856 = 0
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
      IF induction_false_release_dvp_leg_1856 = 0
      THEN (induction_false_release_dvp_d)["security"]
      ELSE (induction_false_release_dvp_d)["cash"]]

(*
  @type: ((Int, Int) => { d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int });
*)
induction_false_release_dvp_bookingOutput(induction_false_release_dvp_t_1895, induction_false_release_dvp_outcome_1895) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  induction_false_release_dvp_d ==
    induction_false_release_dvp_desc(induction_false_release_dvp_t_1895)
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
    outcome |-> induction_false_release_dvp_outcome_1895]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_sign(induction_false_release_dvp_t_2248, induction_false_release_dvp_party_2248) ==
  induction_false_release_dvp_t_2248 \in induction_false_release_dvp_Trades
    /\ induction_false_release_dvp_party_2248 \in { 0, 1 }
    /\ induction_false_release_dvp_s["admitted"]
    /\ induction_false_release_dvp_s["epoch"] = 0
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["signed"] =
            induction_false_release_dvp_s["signed"]
              \union {<<
                (induction_false_release_dvp_desc(induction_false_release_dvp_t_2248)),
                induction_false_release_dvp_party_2248
              >>}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
induction_false_release_dvp_authorized(induction_false_release_dvp_x_1578, induction_false_release_dvp_t_1578) ==
  <<(induction_false_release_dvp_desc(induction_false_release_dvp_t_1578)), 0>>
      \in induction_false_release_dvp_x_1578["signed"]
    /\ <<
      (induction_false_release_dvp_desc(induction_false_release_dvp_t_1578)), 1
    >>
      \in induction_false_release_dvp_x_1578["signed"]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
induction_false_release_dvp_reservedA(induction_false_release_dvp_x_1533) ==
  Cardinality({
    induction_false_release_dvp_t_1528 \in induction_false_release_dvp_Trades:
      induction_false_release_dvp_x_1533["trades"][
        induction_false_release_dvp_t_1528
      ][
        "holdA"
      ]
        = 1
  })
    * 2

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
induction_false_release_dvp_reservedB(induction_false_release_dvp_x_1554) ==
  Cardinality({
    induction_false_release_dvp_t_1549 \in induction_false_release_dvp_Trades:
      induction_false_release_dvp_x_1554["trades"][
        induction_false_release_dvp_t_1549
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
  @type: (() => Bool);
*)
localCommitAtomicity ==
  \A t_821 \in induction_false_release_dvp_Trades:
    LET (*
      @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
    *)
    z == induction_false_release_dvp_s["trades"][t_821]
    IN
    (z)["decision"] = 2 => (z)["effectsA"] = 1

(*
  @type: (() => Set({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }));
*)
TradeSpace ==
  {
    z_7418 \in { (tradeDomainRow(v_7413)): v_7413 \in RawTradeParams }:
      tradeDomainIntent(z_7418)
  }

(*
  @type: (() => Bool);
*)
initControl == induction_false_release_dvp_init /\ pc = 0

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
induction_false_release_dvp_canOpen(induction_false_release_dvp_x_2032, induction_false_release_dvp_t_2032) ==
  induction_false_release_dvp_authorized(induction_false_release_dvp_x_2032, induction_false_release_dvp_t_2032)
    /\ induction_false_release_dvp_x_2032["admitted"]
    /\ <<induction_false_release_dvp_t_2032, 0>>
      \in induction_false_release_dvp_x_2032["eligible"]
    /\ ~(0 \in induction_false_release_dvp_x_2032["frozen"])
    /\ 0 \in induction_false_release_dvp_x_2032["up"]
    /\ (induction_false_release_dvp_HOST /= 3
      \/ 3 \in induction_false_release_dvp_x_2032["up"])
    /\ (IF induction_false_release_dvp_HOST = 0
      \/ induction_false_release_dvp_HOST = 3
    THEN induction_false_release_dvp_x_2032["height"]
        < induction_false_release_dvp_D
      \/ induction_false_release_dvp_MUTANT = 4
    ELSE TRUE)
    /\ (IF induction_false_release_dvp_HOST = 0
      \/ induction_false_release_dvp_HOST = 3
    THEN induction_false_release_dvp_x_2032["trades"][
        induction_false_release_dvp_t_2032
      ][
        "decision"
      ]
        = 0
      \/ (induction_false_release_dvp_MUTANT = 4
        /\ induction_false_release_dvp_x_2032["trades"][
          induction_false_release_dvp_t_2032
        ][
          "decision"
        ]
          = 3)
    ELSE induction_false_release_dvp_x_2032["trades"][
      induction_false_release_dvp_t_2032
    ][
      "knownA"
    ]
      = 0)
    /\ (induction_false_release_dvp_x_2032["trades"][
        induction_false_release_dvp_t_2032
      ][
        "holdA"
      ]
        = 0
      \/ (induction_false_release_dvp_MUTANT = 4
        /\ induction_false_release_dvp_x_2032["trades"][
          induction_false_release_dvp_t_2032
        ][
          "holdA"
        ]
          = 3))
    /\ (IF induction_false_release_dvp_ESCROW
    THEN induction_false_release_dvp_x_2032["ownerA"] >= 2
    ELSE induction_false_release_dvp_x_2032["ownerA"]
      - induction_false_release_dvp_reservedA(induction_false_release_dvp_x_2032)
      >= 2)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
induction_false_release_dvp_reserveA(induction_false_release_dvp_x_2116, induction_false_release_dvp_t_2116) ==
  [
    [
      [
        [
          induction_false_release_dvp_x_2116 EXCEPT
            !["trades"] =
              [
                induction_false_release_dvp_x_2116["trades"] EXCEPT
                  ![induction_false_release_dvp_t_2116] =
                    [
                      [
                        [
                          [
                            induction_false_release_dvp_x_2116["trades"][
                              induction_false_release_dvp_t_2116
                            ] EXCEPT
                              !["decision"] =
                                IF induction_false_release_dvp_HOST = 0
                                  \/ induction_false_release_dvp_HOST = 3
                                THEN 1
                                ELSE induction_false_release_dvp_x_2116[
                                  "trades"
                                ][
                                  induction_false_release_dvp_t_2116
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
            THEN induction_false_release_dvp_x_2116["ownerA"] - 2
            ELSE induction_false_release_dvp_x_2116["ownerA"]
      ] EXCEPT
        !["vaultA"] =
          IF induction_false_release_dvp_ESCROW
          THEN induction_false_release_dvp_x_2116["vaultA"] + 2
          ELSE induction_false_release_dvp_x_2116["vaultA"]
    ] EXCEPT
      !["included"] =
        induction_false_release_dvp_x_2116["included"]
          \union { (induction_false_release_dvp_fact(induction_false_release_dvp_t_2116,
            0)),
            (induction_false_release_dvp_fact(induction_false_release_dvp_t_2116,
            1)) }
  ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }, Int, Int) => Bool);
*)
induction_false_release_dvp_authFact(induction_false_release_dvp_x_1627, induction_false_release_dvp_f_1627,
induction_false_release_dvp_t_1627, induction_false_release_dvp_p_1627) ==
  induction_false_release_dvp_f_1627
      \in induction_false_release_dvp_x_1627["proofs"]
    /\ induction_false_release_dvp_f_1627["d"]
      = induction_false_release_dvp_desc(induction_false_release_dvp_t_1627)
    /\ induction_false_release_dvp_f_1627["phase"]
      = induction_false_release_dvp_p_1627
    /\ induction_false_release_dvp_f_1627["checkpoint"] = 0
    /\ induction_false_release_dvp_f_1627["program"]
      \in induction_false_release_dvp_x_1627["historical"]
    /\ induction_false_release_dvp_f_1627["root"]
      = (induction_false_release_dvp_fact(induction_false_release_dvp_t_1627, induction_false_release_dvp_p_1627))[
        "root"
      ]

(*
  @type: ((Int) => Bool);
*)
induction_false_release_dvp_abort(induction_false_release_dvp_t_3703) ==
  induction_false_release_dvp_HOST \in induction_false_release_dvp_s["up"]
    /\ 2 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_authorized(induction_false_release_dvp_s, induction_false_release_dvp_t_3703)
    /\ induction_false_release_dvp_s["height"] >= induction_false_release_dvp_D
    /\ induction_false_release_dvp_s["trades"][
      induction_false_release_dvp_t_3703
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
                \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_3703,
                4))}
        ] EXCEPT
          !["trades"] =
            [
              induction_false_release_dvp_s["trades"] EXCEPT
                ![induction_false_release_dvp_t_3703] =
                  [
                    [
                      [
                        [
                          induction_false_release_dvp_s["trades"][
                            induction_false_release_dvp_t_3703
                          ] EXCEPT
                            !["decision"] = 3
                        ] EXCEPT
                          !["oldTerminal"] =
                            IF induction_false_release_dvp_s["trades"][
                              induction_false_release_dvp_t_3703
                            ][
                              "oldTerminal"
                            ]
                              = 0
                            THEN 3
                            ELSE induction_false_release_dvp_s["trades"][
                              induction_false_release_dvp_t_3703
                            ][
                              "oldTerminal"
                            ]
                      ] EXCEPT
                        !["knownA"] =
                          IF induction_false_release_dvp_HOST = 0
                            \/ induction_false_release_dvp_HOST = 3
                          THEN 3
                          ELSE induction_false_release_dvp_s["trades"][
                            induction_false_release_dvp_t_3703
                          ][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF induction_false_release_dvp_HOST = 1
                          \/ induction_false_release_dvp_HOST = 3
                        THEN 3
                        ELSE induction_false_release_dvp_s["trades"][
                          induction_false_release_dvp_t_3703
                        ][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_finalize(induction_false_release_dvp_t_2639, induction_false_release_dvp_p_2639) ==
  induction_false_release_dvp_fact(induction_false_release_dvp_t_2639, induction_false_release_dvp_p_2639)
      \in induction_false_release_dvp_s["included"]
    /\ (IF induction_false_release_dvp_HOST = 3
    THEN 3
    ELSE IF induction_false_release_dvp_p_2639 = 2
      \/ induction_false_release_dvp_p_2639 = 6
    THEN 1
    ELSE IF induction_false_release_dvp_p_2639 = 3
      \/ induction_false_release_dvp_p_2639 = 4
    THEN induction_false_release_dvp_HOST
    ELSE 0)
      \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["finalized"] =
            induction_false_release_dvp_s["finalized"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2639,
              induction_false_release_dvp_p_2639))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_capture(induction_false_release_dvp_t_2680, induction_false_release_dvp_p_2680) ==
  3 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_fact(induction_false_release_dvp_t_2680, induction_false_release_dvp_p_2680)
      \in induction_false_release_dvp_s["finalized"]
    /\ ~(induction_false_release_dvp_fact(induction_false_release_dvp_t_2680, induction_false_release_dvp_p_2680)
      \in induction_false_release_dvp_s["pruned"])
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["captured"] =
            induction_false_release_dvp_s["captured"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2680,
              induction_false_release_dvp_p_2680))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_prove(induction_false_release_dvp_t_2723, induction_false_release_dvp_p_2723) ==
  3 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_fact(induction_false_release_dvp_t_2723, induction_false_release_dvp_p_2723)
      \in induction_false_release_dvp_s["captured"]
    /\ induction_false_release_dvp_s'
      := [
        [
          induction_false_release_dvp_s EXCEPT
            !["proofs"] =
              induction_false_release_dvp_s["proofs"]
                \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2723,
                induction_false_release_dvp_p_2723))}
        ] EXCEPT
          !["network"] =
            induction_false_release_dvp_s["network"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2723,
              induction_false_release_dvp_p_2723))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
induction_false_release_dvp_deliver(induction_false_release_dvp_t_2906, induction_false_release_dvp_p_2906) ==
  4 \in induction_false_release_dvp_s["up"]
    /\ induction_false_release_dvp_fact(induction_false_release_dvp_t_2906, induction_false_release_dvp_p_2906)
      \in induction_false_release_dvp_s["network"]
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["received"] =
            induction_false_release_dvp_s["received"]
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2906,
              induction_false_release_dvp_p_2906))}
      ]

(*
  @type: (() => Bool);
*)
effectSoundness ==
  localCommitAtomicity
    /\ (\A t_1035 \in induction_false_release_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == induction_false_release_dvp_s["trades"][t_1035]
      IN
      ((z)["effectsA"] > 0 => (z)["holdA"] = 2)
        /\ ((z)["effectsB"] > 0 => (z)["holdB"] = 2)
        /\ ((z)["refundsA"] > 0 => (z)["holdA"] = 3)
        /\ ((z)["refundsB"] > 0 => (z)["holdB"] = 3)
        /\ ((z)["holdA"] = 1 => (z)["effectsA"] = 0 /\ (z)["refundsA"] = 0)
        /\ ((z)["holdB"] = 1 => (z)["effectsB"] = 0 /\ (z)["refundsB"] = 0))

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
  @type: (() => Bool);
*)
ICore ==
  localCommitAtomicity
    /\ (\A t_921 \in induction_false_release_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == induction_false_release_dvp_s["trades"][t_921]
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
  @type: ((Int) => Bool);
*)
induction_false_release_dvp_openA(induction_false_release_dvp_t_2262) ==
  induction_false_release_dvp_canOpen(induction_false_release_dvp_s, induction_false_release_dvp_t_2262)
    /\ induction_false_release_dvp_s'
      := induction_false_release_dvp_reserveA(induction_false_release_dvp_s, induction_false_release_dvp_t_2262)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
induction_false_release_dvp_has(induction_false_release_dvp_x_1647, induction_false_release_dvp_t_1647,
induction_false_release_dvp_p_1647) ==
  \E induction_false_release_dvp_f_1645 \in induction_false_release_dvp_x_1647[
    "received"
  ]:
    induction_false_release_dvp_authFact(induction_false_release_dvp_x_1647, induction_false_release_dvp_f_1645,
    induction_false_release_dvp_t_1647, induction_false_release_dvp_p_1647)

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
CandidateFacts ==
  {
    (domainFact(v_242[1], v_242[2], v_242[3])):
      v_242 \in induction_false_release_dvp_Trades \X (0 .. 6) \X (0 .. 10)
  }

(*
  @type: (() => Bool);
*)
q_init == initControl

(*
  @type: ((Int) => Bool);
*)
induction_false_release_dvp_prepareB(induction_false_release_dvp_t_2486) ==
  induction_false_release_dvp_authorized(induction_false_release_dvp_s, induction_false_release_dvp_t_2486)
    /\ induction_false_release_dvp_s["admitted"]
    /\ <<induction_false_release_dvp_t_2486, 1>>
      \in induction_false_release_dvp_s["eligible"]
    /\ ~(1 \in induction_false_release_dvp_s["frozen"])
    /\ 1 \in induction_false_release_dvp_s["up"]
    /\ (induction_false_release_dvp_HOST /= 3
      \/ 3 \in induction_false_release_dvp_s["up"])
    /\ induction_false_release_dvp_s["trades"][
      induction_false_release_dvp_t_2486
    ][
      "knownB"
    ]
      = 0
    /\ induction_false_release_dvp_s["trades"][
      induction_false_release_dvp_t_2486
    ][
      "holdB"
    ]
      = 0
    /\ (~induction_false_release_dvp_OPEN_REQUIRED
      \/ induction_false_release_dvp_has(induction_false_release_dvp_s, induction_false_release_dvp_t_2486,
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
                      ![induction_false_release_dvp_t_2486] =
                        [
                          [
                            [
                              induction_false_release_dvp_s["trades"][
                                induction_false_release_dvp_t_2486
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
              \union {(induction_false_release_dvp_fact(induction_false_release_dvp_t_2486,
              2))}
      ]

(*
  @type: ((Int, Int, Int) => Bool);
*)
induction_false_release_dvp_learn(induction_false_release_dvp_t_3793, induction_false_release_dvp_outcome_3793,
induction_false_release_dvp_leg_3793) ==
  induction_false_release_dvp_leg_3793 \in induction_false_release_dvp_s["up"]
    /\ (induction_false_release_dvp_HOST /= 3
      \/ 3 \in induction_false_release_dvp_s["up"])
    /\ induction_false_release_dvp_has(induction_false_release_dvp_s, induction_false_release_dvp_t_3793,
    (IF induction_false_release_dvp_outcome_3793 = 2 THEN 3 ELSE 4))
    /\ induction_false_release_dvp_s'
      := [
        induction_false_release_dvp_s EXCEPT
          !["trades"] =
            [
              induction_false_release_dvp_s["trades"] EXCEPT
                ![induction_false_release_dvp_t_3793] =
                  [
                    [
                      induction_false_release_dvp_s["trades"][
                        induction_false_release_dvp_t_3793
                      ] EXCEPT
                        !["knownA"] =
                          IF induction_false_release_dvp_leg_3793 = 0
                          THEN induction_false_release_dvp_outcome_3793
                          ELSE induction_false_release_dvp_s["trades"][
                            induction_false_release_dvp_t_3793
                          ][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF induction_false_release_dvp_leg_3793 = 1
                          /\ (induction_false_release_dvp_MUTANT /= 9
                            \/ induction_false_release_dvp_s["trades"][
                              induction_false_release_dvp_t_3793
                            ][
                              "holdB"
                            ]
                              /= 0)
                        THEN induction_false_release_dvp_outcome_3793
                        ELSE induction_false_release_dvp_s["trades"][
                          induction_false_release_dvp_t_3793
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
FullTypeOK == induction_false_release_dvp_s \in StateSpace

(*
  @type: (() => Bool);
*)
effectIExpanded ==
  (domainByFields(induction_false_release_dvp_s) /\ ICore) /\ pc \in Int

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

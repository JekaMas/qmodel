---- MODULE effects_d -------------------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

(*
  @type: (() => Int);
*)
effects_d_dvp_N == 1

(*
  @type: (() => Int);
*)
effects_d_dvp_HOST == 2

(*
  @type: (() => Int);
*)
effects_d_dvp_D == 2

(*
  @type: (() => Int);
*)
effects_d_dvp_MUTANT == 0

VARIABLE
  (*
    @type: { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int };
  *)
  effects_d_dvp_s

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
tradeDomainRow(v_17085) ==
  [decision |-> v_17085[1],
    oldTerminal |-> IF v_17085[1] >= 2 THEN v_17085[1] ELSE 0,
    holdA |-> v_17085[2],
    holdB |-> v_17085[3],
    effectsA |-> IF v_17085[2] = 2 THEN 1 ELSE 0,
    effectsB |-> IF v_17085[3] = 2 THEN 1 ELSE 0,
    refundsA |-> IF v_17085[2] = 3 THEN 1 ELSE 0,
    refundsB |-> IF v_17085[3] = 3 THEN 1 ELSE 0,
    knownA |-> v_17085[4],
    knownB |-> v_17085[5],
    preparedA |-> v_17085[2] /= 0,
    preparedB |-> v_17085[3] /= 0,
    appliedEvidenceA |-> v_17085[6]["appliedEvidenceA"],
    appliedEvidenceB |-> v_17085[6]["appliedEvidenceB"],
    booked |-> v_17085[6]["booked"],
    report |-> v_17085[6]["report"],
    stale |-> v_17085[6]["stale"],
    intent |-> v_17085[7]]

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => Bool);
*)
tradeDomainIntent(z_17113) ==
  z_17113["intent"]
    \/ ((z_17113["holdA"] = 0 /\ z_17113["holdB"] = 0)
      /\ z_17113["decision"] \in { 0, 3 })

(*
  @type: (({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }) => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, report: Int, stale: Bool });
*)
tradeDomainAux(z_17139) ==
  [appliedEvidenceA |-> z_17139["appliedEvidenceA"],
    appliedEvidenceB |-> z_17139["appliedEvidenceB"],
    booked |-> z_17139["booked"],
    report |-> z_17139["report"],
    stale |-> z_17139["stale"]]

(*
  @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
*)
effects_d_dvp_emptyTrade ==
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
  @type: (() => Bool);
*)
effects_d_dvp_ESCROW == FALSE

(*
  @type: (() => Bool);
*)
effects_d_dvp_OPEN_REQUIRED == FALSE

(*
  @type: (() => Set(Int));
*)
effects_d_dvp_Trades == 1 .. effects_d_dvp_N

(*
  @type: ((Int) => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
*)
effects_d_dvp_desc(effects_d_dvp_t_11201) ==
  [trade |-> effects_d_dvp_t_11201,
    nonce |-> effects_d_dvp_t_11201,
    chainA |-> 10,
    genesisA |-> 110,
    chainB |-> IF effects_d_dvp_HOST = 3 THEN 10 ELSE 20,
    genesisB |-> IF effects_d_dvp_HOST = 3 THEN 110 ELSE 120,
    decisionDomain |-> effects_d_dvp_HOST,
    assetA |-> 30,
    assetB |-> 40,
    holdA |-> 50,
    holdB |-> 60,
    decisionContract |-> 70,
    security |-> 2,
    cash |-> 3,
    sellerA |-> 0,
    buyerA |-> effects_d_dvp_t_11201,
    buyerB |-> IF effects_d_dvp_HOST = 3 THEN effects_d_dvp_t_11201 ELSE 0,
    sellerB |-> IF effects_d_dvp_HOST = 3 THEN 0 ELSE effects_d_dvp_t_11201,
    deadline |-> effects_d_dvp_D,
    protocol |-> 1,
    epoch |-> 0,
    commitment |-> 1000 + effects_d_dvp_t_11201]

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
tradeDomainContains(z_17299) ==
  z_17299["decision"] \in 0 .. 3
    /\ z_17299["holdA"] \in 0 .. 3
    /\ z_17299["holdB"] \in 0 .. 3
    /\ z_17299["knownA"] \in { 0, 2, 3 }
    /\ z_17299["knownB"] \in { 0, 2, 3 }
    /\ z_17299["intent"] \in BOOLEAN
    /\ z_17299["oldTerminal"]
      = (IF z_17299["decision"] >= 2 THEN z_17299["decision"] ELSE 0)
    /\ z_17299["effectsA"] = (IF z_17299["holdA"] = 2 THEN 1 ELSE 0)
    /\ z_17299["effectsB"] = (IF z_17299["holdB"] = 2 THEN 1 ELSE 0)
    /\ z_17299["refundsA"] = (IF z_17299["holdA"] = 3 THEN 1 ELSE 0)
    /\ z_17299["refundsB"] = (IF z_17299["holdB"] = 3 THEN 1 ELSE 0)
    /\ z_17299["preparedA"] = (z_17299["holdA"] /= 0)
    /\ z_17299["preparedB"] = (z_17299["holdB"] /= 0)
    /\ tradeDomainAux(z_17299) \in AuxSpace
    /\ tradeDomainIntent(z_17299)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
effects_d_dvp_debitA(effects_d_dvp_x_13149) ==
  [
    [
      effects_d_dvp_x_13149 EXCEPT
        !["ownerA"] =
          IF effects_d_dvp_ESCROW
          THEN effects_d_dvp_x_13149["ownerA"]
          ELSE effects_d_dvp_x_13149["ownerA"] - 2
    ] EXCEPT
      !["vaultA"] =
        IF effects_d_dvp_ESCROW
        THEN effects_d_dvp_x_13149["vaultA"] - 2
        ELSE effects_d_dvp_x_13149["vaultA"]
  ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
effects_d_dvp_debitB(effects_d_dvp_x_13179) ==
  [
    [
      effects_d_dvp_x_13179 EXCEPT
        !["ownerB"] =
          IF effects_d_dvp_ESCROW
          THEN effects_d_dvp_x_13179["ownerB"]
          ELSE effects_d_dvp_x_13179["ownerB"] - 3
    ] EXCEPT
      !["vaultB"] =
        IF effects_d_dvp_ESCROW
        THEN effects_d_dvp_x_13179["vaultB"] - 3
        ELSE effects_d_dvp_x_13179["vaultB"]
  ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_unsafeRefund(effects_d_dvp_t_14164) ==
  (effects_d_dvp_MUTANT = 1
      \/ ((effects_d_dvp_MUTANT = 7
          /\ effects_d_dvp_s["trades"][effects_d_dvp_t_14164]["stale"])
        /\ effects_d_dvp_s["trades"][effects_d_dvp_t_14164]["report"] = 0))
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_14164]["holdB"] = 1
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_14164] =
                  [
                    [
                      effects_d_dvp_s["trades"][effects_d_dvp_t_14164] EXCEPT
                        !["holdB"] = 3
                    ] EXCEPT
                      !["refundsB"] =
                        effects_d_dvp_s["trades"][effects_d_dvp_t_14164][
                          "refundsB"
                        ]
                          + 1
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_forgetTerminal(effects_d_dvp_t_14203) ==
  effects_d_dvp_MUTANT = 8
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_14203]["decision"] >= 2
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_14203] =
                  [
                    [
                      effects_d_dvp_s["trades"][effects_d_dvp_t_14203] EXCEPT
                        !["decision"] = 0
                    ] EXCEPT
                      !["holdA"] = 0
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_receiveNote(effects_d_dvp_t_14978) ==
  effects_d_dvp_s["trades"][effects_d_dvp_t_14978]["effectsB"] = 1
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["note"] = effects_d_dvp_s["note"] \union {effects_d_dvp_t_14978}
      ]

(*
  @type: (() => Bool);
*)
effects_d_dvp_tick ==
  effects_d_dvp_HOST \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_s["height"] < effects_d_dvp_D
    /\ effects_d_dvp_s'
      := [ effects_d_dvp_s EXCEPT !["height"] = effects_d_dvp_s["height"] + 1 ]

(*
  @type: (() => Bool);
*)
effects_d_dvp_idle == effects_d_dvp_s' := effects_d_dvp_s

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_recover(effects_d_dvp_actor_14335) ==
  effects_d_dvp_s'
    := [
      effects_d_dvp_s EXCEPT
        !["up"] = effects_d_dvp_s["up"] \union {effects_d_dvp_actor_14335}
    ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_freeze(effects_d_dvp_leg_14908) ==
  effects_d_dvp_s'
    := [
      effects_d_dvp_s EXCEPT
        !["frozen"] = effects_d_dvp_s["frozen"] \union {effects_d_dvp_leg_14908}
    ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_unfreeze(effects_d_dvp_leg_14924) ==
  effects_d_dvp_s'
    := [
      effects_d_dvp_s EXCEPT
        !["frozen"] = effects_d_dvp_s["frozen"] \ {effects_d_dvp_leg_14924}
    ]

(*
  @type: (() => Bool);
*)
effects_d_dvp_rotate ==
  effects_d_dvp_s["epoch"] = 0
    /\ effects_d_dvp_s'
      := [
        [ effects_d_dvp_s EXCEPT !["epoch"] = 1 ] EXCEPT
          !["historical"] = effects_d_dvp_s["historical"] \union { 1, 2 }
      ]

(*
  @type: (() => Bool);
*)
effects_d_dvp_exitMember ==
  effects_d_dvp_s' := [ effects_d_dvp_s EXCEPT !["admitted"] = FALSE ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_revokeLeg(effects_d_dvp_t_14892, effects_d_dvp_leg_14892) ==
  effects_d_dvp_s'
    := [
      effects_d_dvp_s EXCEPT
        !["eligible"] =
          effects_d_dvp_s["eligible"]
            \ {<<effects_d_dvp_t_14892, effects_d_dvp_leg_14892>>}
    ]

(*
  @type: (() => Bool);
*)
effects_d_dvp_compromiseTransport ==
  effects_d_dvp_s'
    := [ effects_d_dvp_s EXCEPT !["transportCompromised"] = TRUE ]

(*
  @type: ((Int, Int) => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
*)
effects_d_dvp_fact(effects_d_dvp_t_11233, effects_d_dvp_p_11233) ==
  [d |-> effects_d_dvp_desc(effects_d_dvp_t_11233),
    phase |-> effects_d_dvp_p_11233,
    checkpoint |-> 0,
    program |-> 1,
    root |-> (200 + effects_d_dvp_p_11233 * 10) + effects_d_dvp_t_11233]

(*
  @type: ((Int, Int, Int) => { account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int });
*)
effects_d_dvp_economicOutput(effects_d_dvp_t_11748, effects_d_dvp_leg_11748, effects_d_dvp_kind_11748) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  effects_d_dvp_d == effects_d_dvp_desc(effects_d_dvp_t_11748)
  IN
  LET (*
    @type: (() => Int);
  *)
  effects_d_dvp_account ==
    IF effects_d_dvp_leg_11748 = 0
    THEN IF effects_d_dvp_kind_11748 = 0
    THEN (effects_d_dvp_d)["buyerA"]
    ELSE (effects_d_dvp_d)["sellerA"]
    ELSE IF effects_d_dvp_kind_11748 = 0
    THEN (effects_d_dvp_d)["sellerB"]
    ELSE (effects_d_dvp_d)["buyerB"]
  IN
  LET (*
    @type: (() => Bool);
  *)
  effects_d_dvp_wrongAccount ==
    (effects_d_dvp_leg_11748 = 0
        /\ ((effects_d_dvp_kind_11748 = 0 /\ effects_d_dvp_MUTANT = 11)
          \/ (effects_d_dvp_kind_11748 = 1 /\ effects_d_dvp_MUTANT = 14)))
      \/ (effects_d_dvp_leg_11748 = 1
        /\ ((effects_d_dvp_kind_11748 = 0 /\ effects_d_dvp_MUTANT = 15)
          \/ (effects_d_dvp_kind_11748 = 1 /\ effects_d_dvp_MUTANT = 17)))
  IN
  [trade |-> effects_d_dvp_t_11748,
    leg |-> effects_d_dvp_leg_11748,
    kind |-> effects_d_dvp_kind_11748,
    chain |->
      IF effects_d_dvp_leg_11748 = 0
      THEN (effects_d_dvp_d)["chainA"]
      ELSE (effects_d_dvp_d)["chainB"],
    genesis |->
      IF effects_d_dvp_leg_11748 = 0
      THEN (effects_d_dvp_d)["genesisA"]
      ELSE (effects_d_dvp_d)["genesisB"],
    asset |->
      IF effects_d_dvp_leg_11748 = 0
      THEN IF effects_d_dvp_MUTANT = 12
      THEN (effects_d_dvp_d)["assetB"]
      ELSE (effects_d_dvp_d)["assetA"]
      ELSE IF effects_d_dvp_MUTANT = 16
      THEN (effects_d_dvp_d)["assetA"]
      ELSE (effects_d_dvp_d)["assetB"],
    account |->
      IF effects_d_dvp_wrongAccount
      THEN IF effects_d_dvp_account = 0 THEN 1 ELSE 0
      ELSE effects_d_dvp_account,
    quantity |->
      IF effects_d_dvp_leg_11748 = 0
      THEN (effects_d_dvp_d)["security"]
      ELSE (effects_d_dvp_d)["cash"]]

(*
  @type: ((Int, Int) => { d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int });
*)
effects_d_dvp_bookingOutput(effects_d_dvp_t_11787, effects_d_dvp_outcome_11787) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  effects_d_dvp_d == effects_d_dvp_desc(effects_d_dvp_t_11787)
  IN
  [d |->
      IF effects_d_dvp_MUTANT = 18
      THEN [
        (effects_d_dvp_d) EXCEPT
          !["sellerB"] = IF (effects_d_dvp_d)["sellerB"] = 0 THEN 1 ELSE 0
      ]
      ELSE IF effects_d_dvp_MUTANT = 19
      THEN [ (effects_d_dvp_d) EXCEPT !["cash"] = 4 ]
      ELSE effects_d_dvp_d,
    outcome |-> effects_d_dvp_outcome_11787]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Bool);
*)
localAtomicAt(x_5006) ==
  \A t_5004 \in effects_d_dvp_Trades:
    LET (*
      @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
    *)
    z == x_5006["trades"][t_5004]
    IN
    (z)["decision"] = 2 => TRUE

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }));
*)
AbortSpace ==
  {
    (LET (*
      @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
    *)
    d == effects_d_dvp_desc(v_4485[1])
    IN
    [d |-> d,
      leg |-> v_4485[2],
      genesis |-> IF v_4485[2] = 0 THEN (d)["genesisA"] ELSE (d)["genesisB"],
      checkpoint |-> 0,
      program |-> 1,
      disposition |-> v_4485[3]]):
      v_4485 \in effects_d_dvp_Trades \X { 0, 1 } \X (0 .. 3)
  }

(*
  @type: (() => Set({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }));
*)
TradeSpace ==
  {
    z_17310 \in { (tradeDomainRow(v_17305)): v_17305 \in RawTradeParams }:
      tradeDomainIntent(z_17310)
  }

(*
  @type: (() => Bool);
*)
effects_d_dvp_init ==
  effects_d_dvp_s
    = [trades |->
        [
          effects_d_dvp___12013 \in effects_d_dvp_Trades |->
            effects_d_dvp_emptyTrade
        ],
      signed |-> {},
      height |-> 0,
      ownerA |-> 2,
      ownerB |-> 3,
      vaultA |-> 0,
      vaultB |-> 0,
      spentA |-> 0,
      spentB |-> 0,
      receivedA |-> [ effects_d_dvp___12035 \in effects_d_dvp_Trades |-> 0 ],
      receivedB |-> [ effects_d_dvp___12041 \in effects_d_dvp_Trades |-> 0 ],
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
      eligible |-> effects_d_dvp_Trades \X { 0, 1 },
      frozen |-> {},
      note |-> {},
      rejects |-> {},
      transportCompromised |-> FALSE,
      custody |-> FALSE,
      upgrade |-> FALSE,
      validator |-> FALSE,
      decrypt |-> FALSE]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_sign(effects_d_dvp_t_12140, effects_d_dvp_party_12140) ==
  effects_d_dvp_t_12140 \in effects_d_dvp_Trades
    /\ effects_d_dvp_party_12140 \in { 0, 1 }
    /\ effects_d_dvp_s["admitted"]
    /\ effects_d_dvp_s["epoch"] = 0
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["signed"] =
            effects_d_dvp_s["signed"]
              \union {<<
                (effects_d_dvp_desc(effects_d_dvp_t_12140)), effects_d_dvp_party_12140
              >>}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
effects_d_dvp_authorized(effects_d_dvp_x_11470, effects_d_dvp_t_11470) ==
  <<(effects_d_dvp_desc(effects_d_dvp_t_11470)), 0>>
      \in effects_d_dvp_x_11470["signed"]
    /\ <<(effects_d_dvp_desc(effects_d_dvp_t_11470)), 1>>
      \in effects_d_dvp_x_11470["signed"]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
effects_d_dvp_reservedA(effects_d_dvp_x_11425) ==
  Cardinality({
    effects_d_dvp_t_11420 \in effects_d_dvp_Trades:
      effects_d_dvp_x_11425["trades"][effects_d_dvp_t_11420]["holdA"] = 1
  })
    * 2

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
effects_d_dvp_reservedB(effects_d_dvp_x_11446) ==
  Cardinality({
    effects_d_dvp_t_11441 \in effects_d_dvp_Trades:
      effects_d_dvp_x_11446["trades"][effects_d_dvp_t_11441]["holdB"] = 1
  })
    * 3

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_captureAbortRecord(effects_d_dvp_t_14568, effects_d_dvp_leg_14568) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_d_dvp_z == effects_d_dvp_s["trades"][effects_d_dvp_t_14568]
  IN
  LET (*
    @type: (() => Int);
  *)
  effects_d_dvp_localHold ==
    IF effects_d_dvp_leg_14568 = 0
    THEN (effects_d_dvp_z)["holdA"]
    ELSE (effects_d_dvp_z)["holdB"]
  IN
  LET (*
    @type: (() => Int);
  *)
  effects_d_dvp_localKnown ==
    IF effects_d_dvp_leg_14568 = 0
    THEN (effects_d_dvp_z)["knownA"]
    ELSE (effects_d_dvp_z)["knownB"]
  IN
  effects_d_dvp_leg_14568 \in effects_d_dvp_s["up"]
    /\ 3 \in effects_d_dvp_s["up"]
    /\ (effects_d_dvp_localKnown = 3 \/ effects_d_dvp_MUTANT = 13)
    /\ effects_d_dvp_localHold /= 1
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["abortRecords"] =
            effects_d_dvp_s["abortRecords"]
              \union {[d |-> effects_d_dvp_desc(effects_d_dvp_t_14568),
                leg |-> effects_d_dvp_leg_14568,
                genesis |->
                  IF effects_d_dvp_leg_14568 = 0
                  THEN (effects_d_dvp_desc(effects_d_dvp_t_14568))["genesisA"]
                  ELSE (effects_d_dvp_desc(effects_d_dvp_t_14568))["genesisB"],
                checkpoint |-> 0,
                program |-> 1,
                disposition |-> effects_d_dvp_localHold]}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
effects_d_dvp_hasAbortRecord(effects_d_dvp_x_14630, effects_d_dvp_t_14630, effects_d_dvp_leg_14630) ==
  \E effects_d_dvp_r_14628 \in effects_d_dvp_x_14630["abortRecords"]:
    effects_d_dvp_r_14628["d"] = effects_d_dvp_desc(effects_d_dvp_t_14630)
      /\ effects_d_dvp_r_14628["leg"] = effects_d_dvp_leg_14630
      /\ effects_d_dvp_r_14628["genesis"]
        = (IF effects_d_dvp_leg_14630 = 0
        THEN (effects_d_dvp_desc(effects_d_dvp_t_14630))["genesisA"]
        ELSE (effects_d_dvp_desc(effects_d_dvp_t_14630))["genesisB"])
      /\ effects_d_dvp_r_14628["checkpoint"] = 0
      /\ effects_d_dvp_r_14628["program"]
        \in effects_d_dvp_x_14630["historical"]
      /\ effects_d_dvp_r_14628["disposition"] \in { 0, 3 }

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_crash(effects_d_dvp_actor_14319) ==
  effects_d_dvp_s'
    := [
      [
        effects_d_dvp_s EXCEPT
          !["up"] = effects_d_dvp_s["up"] \ {effects_d_dvp_actor_14319}
      ] EXCEPT
        !["trades"] =
          [
            effects_d_dvp_t_14312 \in effects_d_dvp_Trades |->
              [
                [
                  effects_d_dvp_s["trades"][effects_d_dvp_t_14312] EXCEPT
                    !["report"] = 0
                ] EXCEPT
                  !["stale"] = TRUE
              ]
          ]
    ]

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
AuthenticFacts ==
  {
    (effects_d_dvp_fact(v_4404[1], v_4404[2])):
      v_4404 \in effects_d_dvp_Trades \X (0 .. 6)
  }

(*
  @type: (() => Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }));
*)
OutputSpace ==
  {
    (effects_d_dvp_economicOutput(v_4507[1], v_4507[2], v_4507[3])):
      v_4507 \in effects_d_dvp_Trades \X { 0, 1 } \X { 0, 1 }
  }

(*
  @type: (() => Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }));
*)
BookingSpace ==
  {
    (effects_d_dvp_bookingOutput(v_4523[1], v_4523[2])):
      v_4523 \in effects_d_dvp_Trades \X { 2, 3 }
  }

(*
  @type: (() => Bool);
*)
localCommitAtomicity == localAtomicAt(effects_d_dvp_s)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Bool);
*)
physicalInvariant(x_5115) ==
  localAtomicAt(x_5115)
    /\ (\A t_5112 \in effects_d_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == x_5115["trades"][t_5112]
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
domainFact(t_4389, p_4389, binding_4389) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  f == effects_d_dvp_fact(t_4389, p_4389)
  IN
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  bad ==
    IF binding_4389 = 0
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["trade"] = 3 - t_4389 ] ]
    ELSE IF binding_4389 = 1
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["nonce"] = 99 ] ]
    ELSE IF binding_4389 = 2
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["sellerB"] = 99 ] ]
    ELSE IF binding_4389 = 3
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["cash"] = 4 ] ]
    ELSE IF binding_4389 = 4
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["genesisB"] = 999 ] ]
    ELSE IF binding_4389 = 5
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["decisionDomain"] = 99 ] ]
    ELSE IF binding_4389 = 6
    THEN [ (f) EXCEPT !["phase"] = 6 ]
    ELSE IF binding_4389 = 7
    THEN [ (f) EXCEPT !["checkpoint"] = 99 ]
    ELSE IF binding_4389 = 8
    THEN [ (f) EXCEPT !["program"] = 99 ]
    ELSE IF binding_4389 = 9
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
q_init == effects_d_dvp_init

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
effects_d_dvp_canOpen(effects_d_dvp_x_11924, effects_d_dvp_t_11924) ==
  effects_d_dvp_authorized(effects_d_dvp_x_11924, effects_d_dvp_t_11924)
    /\ effects_d_dvp_x_11924["admitted"]
    /\ <<effects_d_dvp_t_11924, 0>> \in effects_d_dvp_x_11924["eligible"]
    /\ ~(0 \in effects_d_dvp_x_11924["frozen"])
    /\ 0 \in effects_d_dvp_x_11924["up"]
    /\ (effects_d_dvp_HOST /= 3 \/ 3 \in effects_d_dvp_x_11924["up"])
    /\ (IF effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3
    THEN effects_d_dvp_x_11924["height"] < effects_d_dvp_D
      \/ effects_d_dvp_MUTANT = 4
    ELSE TRUE)
    /\ (IF effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3
    THEN effects_d_dvp_x_11924["trades"][effects_d_dvp_t_11924]["decision"] = 0
      \/ (effects_d_dvp_MUTANT = 4
        /\ effects_d_dvp_x_11924["trades"][effects_d_dvp_t_11924]["decision"]
          = 3)
    ELSE effects_d_dvp_x_11924["trades"][effects_d_dvp_t_11924]["knownA"] = 0)
    /\ (effects_d_dvp_x_11924["trades"][effects_d_dvp_t_11924]["holdA"] = 0
      \/ (effects_d_dvp_MUTANT = 4
        /\ effects_d_dvp_x_11924["trades"][effects_d_dvp_t_11924]["holdA"] = 3))
    /\ (IF effects_d_dvp_ESCROW
    THEN effects_d_dvp_x_11924["ownerA"] >= 2
    ELSE effects_d_dvp_x_11924["ownerA"]
      - effects_d_dvp_reservedA(effects_d_dvp_x_11924)
      >= 2)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
effects_d_dvp_reserveA(effects_d_dvp_x_12008, effects_d_dvp_t_12008) ==
  [
    [
      [
        [
          effects_d_dvp_x_12008 EXCEPT
            !["trades"] =
              [
                effects_d_dvp_x_12008["trades"] EXCEPT
                  ![effects_d_dvp_t_12008] =
                    [
                      [
                        [
                          [
                            effects_d_dvp_x_12008["trades"][
                              effects_d_dvp_t_12008
                            ] EXCEPT
                              !["decision"] =
                                IF effects_d_dvp_HOST = 0
                                  \/ effects_d_dvp_HOST = 3
                                THEN 1
                                ELSE effects_d_dvp_x_12008["trades"][
                                  effects_d_dvp_t_12008
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
            IF effects_d_dvp_ESCROW
            THEN effects_d_dvp_x_12008["ownerA"] - 2
            ELSE effects_d_dvp_x_12008["ownerA"]
      ] EXCEPT
        !["vaultA"] =
          IF effects_d_dvp_ESCROW
          THEN effects_d_dvp_x_12008["vaultA"] + 2
          ELSE effects_d_dvp_x_12008["vaultA"]
    ] EXCEPT
      !["included"] =
        effects_d_dvp_x_12008["included"]
          \union { (effects_d_dvp_fact(effects_d_dvp_t_12008, 0)),
            (effects_d_dvp_fact(effects_d_dvp_t_12008, 1)) }
  ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }, Int, Int) => Bool);
*)
effects_d_dvp_authFact(effects_d_dvp_x_11519, effects_d_dvp_f_11519, effects_d_dvp_t_11519,
effects_d_dvp_p_11519) ==
  effects_d_dvp_f_11519 \in effects_d_dvp_x_11519["proofs"]
    /\ effects_d_dvp_f_11519["d"] = effects_d_dvp_desc(effects_d_dvp_t_11519)
    /\ effects_d_dvp_f_11519["phase"] = effects_d_dvp_p_11519
    /\ effects_d_dvp_f_11519["checkpoint"] = 0
    /\ effects_d_dvp_f_11519["program"] \in effects_d_dvp_x_11519["historical"]
    /\ effects_d_dvp_f_11519["root"]
      = (effects_d_dvp_fact(effects_d_dvp_t_11519, effects_d_dvp_p_11519))[
        "root"
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_registerDecision(effects_d_dvp_t_12213) ==
  (effects_d_dvp_HOST = 1 \/ effects_d_dvp_HOST = 2)
    /\ effects_d_dvp_HOST \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_authorized(effects_d_dvp_s, effects_d_dvp_t_12213)
    /\ effects_d_dvp_s["admitted"]
    /\ effects_d_dvp_s["height"] < effects_d_dvp_D
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_12213]["decision"] = 0
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_12213] =
                  [
                    [
                      effects_d_dvp_s["trades"][effects_d_dvp_t_12213] EXCEPT
                        !["decision"] = 1
                    ] EXCEPT
                      !["intent"] = TRUE
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_abort(effects_d_dvp_t_13595) ==
  effects_d_dvp_HOST \in effects_d_dvp_s["up"]
    /\ 2 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_authorized(effects_d_dvp_s, effects_d_dvp_t_13595)
    /\ effects_d_dvp_s["height"] >= effects_d_dvp_D
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_13595]["decision"] < 2
    /\ effects_d_dvp_s'
      := [
        [
          effects_d_dvp_s EXCEPT
            !["included"] =
              effects_d_dvp_s["included"]
                \union {(effects_d_dvp_fact(effects_d_dvp_t_13595, 4))}
        ] EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_13595] =
                  [
                    [
                      [
                        [
                          effects_d_dvp_s["trades"][effects_d_dvp_t_13595] EXCEPT
                            !["decision"] = 3
                        ] EXCEPT
                          !["oldTerminal"] =
                            IF effects_d_dvp_s["trades"][effects_d_dvp_t_13595][
                              "oldTerminal"
                            ]
                              = 0
                            THEN 3
                            ELSE effects_d_dvp_s["trades"][
                              effects_d_dvp_t_13595
                            ][
                              "oldTerminal"
                            ]
                      ] EXCEPT
                        !["knownA"] =
                          IF effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3
                          THEN 3
                          ELSE effects_d_dvp_s["trades"][effects_d_dvp_t_13595][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF effects_d_dvp_HOST = 1 \/ effects_d_dvp_HOST = 3
                        THEN 3
                        ELSE effects_d_dvp_s["trades"][effects_d_dvp_t_13595][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_applyA(effects_d_dvp_t_13791) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_d_dvp_z == effects_d_dvp_s["trades"][effects_d_dvp_t_13791]
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_d_dvp_a == effects_d_dvp_debitA(effects_d_dvp_s)
  IN
  0 \in effects_d_dvp_s["up"]
    /\ (effects_d_dvp_HOST /= 3 \/ 3 \in effects_d_dvp_s["up"])
    /\ 2 \in effects_d_dvp_s["up"]
    /\ ~(0 \in effects_d_dvp_s["frozen"])
    /\ (effects_d_dvp_z)["knownA"] = 2
    /\ (effects_d_dvp_z)["holdA"] = 1
    /\ effects_d_dvp_s'
      := [
        [
          [
            [
              (effects_d_dvp_a) EXCEPT
                !["economicReceipts"] =
                  (effects_d_dvp_a)["economicReceipts"]
                    \union {(effects_d_dvp_economicOutput(effects_d_dvp_t_13791,
                    0, 0))}
            ] EXCEPT
              !["included"] =
                effects_d_dvp_s["included"]
                  \union {(effects_d_dvp_fact(effects_d_dvp_t_13791, 5))}
          ] EXCEPT
            !["trades"] =
              [
                effects_d_dvp_s["trades"] EXCEPT
                  ![effects_d_dvp_t_13791] =
                    [
                      [ (effects_d_dvp_z) EXCEPT !["holdA"] = 2 ] EXCEPT
                        !["effectsA"] = (effects_d_dvp_z)["effectsA"] + 1
                    ]
              ]
        ] EXCEPT
          !["receivedA"] =
            LET (*
              @type: (() => (Int -> Int));
            *)
            __quint_var2 == effects_d_dvp_s["receivedA"]
            IN
            [
              (__quint_var2) EXCEPT
                ![effects_d_dvp_t_13791] =
                  LET (*
                    @type: ((Int) => Int);
                  *)
                  __QUINT_LAMBDA2(effects_d_dvp_q_13779) ==
                    effects_d_dvp_q_13779 + 2
                  IN
                  __QUINT_LAMBDA2((__quint_var2)[effects_d_dvp_t_13791])
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_applyB(effects_d_dvp_t_13907) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_d_dvp_z == effects_d_dvp_s["trades"][effects_d_dvp_t_13907]
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_d_dvp_b == effects_d_dvp_debitB(effects_d_dvp_s)
  IN
  1 \in effects_d_dvp_s["up"]
    /\ (effects_d_dvp_HOST /= 3 \/ 3 \in effects_d_dvp_s["up"])
    /\ 2 \in effects_d_dvp_s["up"]
    /\ ~(1 \in effects_d_dvp_s["frozen"])
    /\ (effects_d_dvp_z)["knownB"] = 2
    /\ ((effects_d_dvp_z)["holdB"] = 1
      \/ (effects_d_dvp_MUTANT = 3 /\ (effects_d_dvp_z)["holdB"] = 2))
    /\ effects_d_dvp_s'
      := [
        [
          [
            [
              (effects_d_dvp_b) EXCEPT
                !["economicReceipts"] =
                  (effects_d_dvp_b)["economicReceipts"]
                    \union {(effects_d_dvp_economicOutput(effects_d_dvp_t_13907,
                    1, 0))}
            ] EXCEPT
              !["included"] =
                effects_d_dvp_s["included"]
                  \union {(effects_d_dvp_fact(effects_d_dvp_t_13907, 6))}
          ] EXCEPT
            !["trades"] =
              [
                effects_d_dvp_s["trades"] EXCEPT
                  ![effects_d_dvp_t_13907] =
                    [
                      [ (effects_d_dvp_z) EXCEPT !["holdB"] = 2 ] EXCEPT
                        !["effectsB"] = (effects_d_dvp_z)["effectsB"] + 1
                    ]
              ]
        ] EXCEPT
          !["receivedB"] =
            LET (*
              @type: (() => (Int -> Int));
            *)
            __quint_var3 == effects_d_dvp_s["receivedB"]
            IN
            [
              (__quint_var3) EXCEPT
                ![effects_d_dvp_t_13907] =
                  LET (*
                    @type: ((Int) => Int);
                  *)
                  __QUINT_LAMBDA3(effects_d_dvp_q_13895) ==
                    effects_d_dvp_q_13895 + 3
                  IN
                  __QUINT_LAMBDA3((__quint_var3)[effects_d_dvp_t_13907])
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_refund(effects_d_dvp_t_14095, effects_d_dvp_leg_14095) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_d_dvp_z == effects_d_dvp_s["trades"][effects_d_dvp_t_14095]
  IN
  effects_d_dvp_leg_14095 \in effects_d_dvp_s["up"]
    /\ (effects_d_dvp_HOST /= 3 \/ 3 \in effects_d_dvp_s["up"])
    /\ 2 \in effects_d_dvp_s["up"]
    /\ ~(effects_d_dvp_leg_14095 \in effects_d_dvp_s["frozen"])
    /\ (IF effects_d_dvp_leg_14095 = 0
    THEN (effects_d_dvp_z)["holdA"] = 1 /\ (effects_d_dvp_z)["knownA"] = 3
    ELSE (effects_d_dvp_z)["holdB"] = 1 /\ (effects_d_dvp_z)["knownB"] = 3)
    /\ effects_d_dvp_s'
      := [
        [
          [
            [
              [
                [
                  effects_d_dvp_s EXCEPT
                    !["economicReceipts"] =
                      effects_d_dvp_s["economicReceipts"]
                        \union {(effects_d_dvp_economicOutput(effects_d_dvp_t_14095,
                        effects_d_dvp_leg_14095, 1))}
                ] EXCEPT
                  !["trades"] =
                    [
                      effects_d_dvp_s["trades"] EXCEPT
                        ![effects_d_dvp_t_14095] =
                          [
                            [
                              [
                                [
                                  (effects_d_dvp_z) EXCEPT
                                    !["holdA"] =
                                      IF effects_d_dvp_leg_14095 = 0
                                      THEN 3
                                      ELSE (effects_d_dvp_z)["holdA"]
                                ] EXCEPT
                                  !["holdB"] =
                                    IF effects_d_dvp_leg_14095 = 1
                                    THEN 3
                                    ELSE (effects_d_dvp_z)["holdB"]
                              ] EXCEPT
                                !["refundsA"] =
                                  (effects_d_dvp_z)["refundsA"]
                                    + (IF effects_d_dvp_leg_14095 = 0
                                    THEN 1
                                    ELSE 0)
                            ] EXCEPT
                              !["refundsB"] =
                                (effects_d_dvp_z)["refundsB"]
                                  + (IF effects_d_dvp_leg_14095 = 1
                                  THEN 1
                                  ELSE 0)
                          ]
                    ]
              ] EXCEPT
                !["ownerA"] =
                  effects_d_dvp_s["ownerA"]
                    + (IF effects_d_dvp_ESCROW /\ effects_d_dvp_leg_14095 = 0
                    THEN 2
                    ELSE 0)
            ] EXCEPT
              !["vaultA"] =
                effects_d_dvp_s["vaultA"]
                  - (IF effects_d_dvp_ESCROW /\ effects_d_dvp_leg_14095 = 0
                  THEN 2
                  ELSE 0)
          ] EXCEPT
            !["ownerB"] =
              effects_d_dvp_s["ownerB"]
                + (IF effects_d_dvp_ESCROW /\ effects_d_dvp_leg_14095 = 1
                THEN 3
                ELSE 0)
        ] EXCEPT
          !["vaultB"] =
            effects_d_dvp_s["vaultB"]
              - (IF effects_d_dvp_ESCROW /\ effects_d_dvp_leg_14095 = 1
              THEN 3
              ELSE 0)
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_reconcile(effects_d_dvp_t_14474) ==
  3 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_14474]["appliedEvidenceA"]
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_14474]["appliedEvidenceB"]
    /\ effects_d_dvp_s'
      := [
        [
          effects_d_dvp_s EXCEPT
            !["financialRecords"] =
              effects_d_dvp_s["financialRecords"]
                \union {(effects_d_dvp_bookingOutput(effects_d_dvp_t_14474, 2))}
        ] EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_14474] =
                  [
                    [
                      [
                        effects_d_dvp_s["trades"][effects_d_dvp_t_14474] EXCEPT
                          !["report"] = 2
                      ] EXCEPT
                        !["stale"] = FALSE
                    ] EXCEPT
                      !["booked"] =
                        IF effects_d_dvp_s["trades"][effects_d_dvp_t_14474][
                          "booked"
                        ]
                          = 0
                        THEN 1
                        ELSE effects_d_dvp_s["trades"][effects_d_dvp_t_14474][
                          "booked"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_finalize(effects_d_dvp_t_12531, effects_d_dvp_p_12531) ==
  effects_d_dvp_fact(effects_d_dvp_t_12531, effects_d_dvp_p_12531)
      \in effects_d_dvp_s["included"]
    /\ (IF effects_d_dvp_HOST = 3
    THEN 3
    ELSE IF effects_d_dvp_p_12531 = 2 \/ effects_d_dvp_p_12531 = 6
    THEN 1
    ELSE IF effects_d_dvp_p_12531 = 3 \/ effects_d_dvp_p_12531 = 4
    THEN effects_d_dvp_HOST
    ELSE 0)
      \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["finalized"] =
            effects_d_dvp_s["finalized"]
              \union {(effects_d_dvp_fact(effects_d_dvp_t_12531, effects_d_dvp_p_12531))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_capture(effects_d_dvp_t_12572, effects_d_dvp_p_12572) ==
  3 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_fact(effects_d_dvp_t_12572, effects_d_dvp_p_12572)
      \in effects_d_dvp_s["finalized"]
    /\ ~(effects_d_dvp_fact(effects_d_dvp_t_12572, effects_d_dvp_p_12572)
      \in effects_d_dvp_s["pruned"])
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["captured"] =
            effects_d_dvp_s["captured"]
              \union {(effects_d_dvp_fact(effects_d_dvp_t_12572, effects_d_dvp_p_12572))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_prove(effects_d_dvp_t_12615, effects_d_dvp_p_12615) ==
  3 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_fact(effects_d_dvp_t_12615, effects_d_dvp_p_12615)
      \in effects_d_dvp_s["captured"]
    /\ effects_d_dvp_s'
      := [
        [
          effects_d_dvp_s EXCEPT
            !["proofs"] =
              effects_d_dvp_s["proofs"]
                \union {(effects_d_dvp_fact(effects_d_dvp_t_12615, effects_d_dvp_p_12615))}
        ] EXCEPT
          !["network"] =
            effects_d_dvp_s["network"]
              \union {(effects_d_dvp_fact(effects_d_dvp_t_12615, effects_d_dvp_p_12615))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_deliver(effects_d_dvp_t_12798, effects_d_dvp_p_12798) ==
  4 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_fact(effects_d_dvp_t_12798, effects_d_dvp_p_12798)
      \in effects_d_dvp_s["network"]
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["received"] =
            effects_d_dvp_s["received"]
              \union {(effects_d_dvp_fact(effects_d_dvp_t_12798, effects_d_dvp_p_12798))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_resend(effects_d_dvp_t_12765, effects_d_dvp_p_12765) ==
  4 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_fact(effects_d_dvp_t_12765, effects_d_dvp_p_12765)
      \in effects_d_dvp_s["proofs"]
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["network"] =
            effects_d_dvp_s["network"]
              \union {(effects_d_dvp_fact(effects_d_dvp_t_12765, effects_d_dvp_p_12765))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_proveUnadmitted(effects_d_dvp_t_12662, effects_d_dvp_p_12662) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_d_dvp_f ==
    [
      (effects_d_dvp_fact(effects_d_dvp_t_12662, effects_d_dvp_p_12662)) EXCEPT
        !["program"] = 0
    ]
  IN
  3 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_fact(effects_d_dvp_t_12662, effects_d_dvp_p_12662)
      \in effects_d_dvp_s["captured"]
    /\ effects_d_dvp_s'
      := [
        [
          effects_d_dvp_s EXCEPT
            !["proofs"] = effects_d_dvp_s["proofs"] \union {(effects_d_dvp_f)}
        ] EXCEPT
          !["network"] = effects_d_dvp_s["network"] \union {(effects_d_dvp_f)}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_deliverUnadmitted(effects_d_dvp_t_12704, effects_d_dvp_p_12704) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_d_dvp_f ==
    [
      (effects_d_dvp_fact(effects_d_dvp_t_12704, effects_d_dvp_p_12704)) EXCEPT
        !["program"] = 0
    ]
  IN
  4 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_f \in effects_d_dvp_s["network"]
    /\ effects_d_dvp_f \in effects_d_dvp_s["proofs"]
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["received"] = effects_d_dvp_s["received"] \union {(effects_d_dvp_f)}
      ]

(*
  @type: ((Int, Int, Int) => Bool);
*)
effects_d_dvp_inject(effects_d_dvp_t_12957, effects_d_dvp_p_12957, effects_d_dvp_binding_12957) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_d_dvp_f ==
    effects_d_dvp_fact(effects_d_dvp_t_12957, effects_d_dvp_p_12957)
  IN
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_d_dvp_bad ==
    IF effects_d_dvp_binding_12957 = 0
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] =
          [
            (effects_d_dvp_f)["d"] EXCEPT
              !["trade"] = 3 - effects_d_dvp_t_12957
          ]
    ]
    ELSE IF effects_d_dvp_binding_12957 = 1
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] = [ (effects_d_dvp_f)["d"] EXCEPT !["nonce"] = 99 ]
    ]
    ELSE IF effects_d_dvp_binding_12957 = 2
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] = [ (effects_d_dvp_f)["d"] EXCEPT !["sellerB"] = 99 ]
    ]
    ELSE IF effects_d_dvp_binding_12957 = 3
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] = [ (effects_d_dvp_f)["d"] EXCEPT !["cash"] = 4 ]
    ]
    ELSE IF effects_d_dvp_binding_12957 = 4
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] = [ (effects_d_dvp_f)["d"] EXCEPT !["genesisB"] = 999 ]
    ]
    ELSE IF effects_d_dvp_binding_12957 = 5
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] = [ (effects_d_dvp_f)["d"] EXCEPT !["decisionDomain"] = 99 ]
    ]
    ELSE IF effects_d_dvp_binding_12957 = 6
    THEN [ (effects_d_dvp_f) EXCEPT !["phase"] = 6 ]
    ELSE IF effects_d_dvp_binding_12957 = 7
    THEN [ (effects_d_dvp_f) EXCEPT !["checkpoint"] = 99 ]
    ELSE IF effects_d_dvp_binding_12957 = 8
    THEN [ (effects_d_dvp_f) EXCEPT !["program"] = 99 ]
    ELSE IF effects_d_dvp_binding_12957 = 9
    THEN [
      (effects_d_dvp_f) EXCEPT
        !["d"] =
          [
            [ (effects_d_dvp_f)["d"] EXCEPT !["assetB"] = 99 ] EXCEPT
              !["holdB"] = 99
          ]
    ]
    ELSE [ (effects_d_dvp_f) EXCEPT !["root"] = 999 ]
  IN
  effects_d_dvp_s'
    := [
      [
        effects_d_dvp_s EXCEPT
          !["received"] =
            effects_d_dvp_s["received"] \union {(effects_d_dvp_bad)}
      ] EXCEPT
        !["rejects"] =
          effects_d_dvp_s["rejects"] \union {effects_d_dvp_binding_12957}
    ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_spend(effects_d_dvp_leg_14286) ==
  (IF effects_d_dvp_leg_14286 = 0
    THEN effects_d_dvp_s["ownerA"]
      - (IF effects_d_dvp_ESCROW
      THEN 0
      ELSE effects_d_dvp_reservedA(effects_d_dvp_s))
      >= 1
    ELSE effects_d_dvp_s["ownerB"]
      - (IF effects_d_dvp_ESCROW
      THEN 0
      ELSE effects_d_dvp_reservedB(effects_d_dvp_s))
      >= 1)
    /\ effects_d_dvp_s'
      := [
        [
          [
            [
              effects_d_dvp_s EXCEPT
                !["ownerA"] =
                  effects_d_dvp_s["ownerA"]
                    - (IF effects_d_dvp_leg_14286 = 0 THEN 1 ELSE 0)
            ] EXCEPT
              !["ownerB"] =
                effects_d_dvp_s["ownerB"]
                  - (IF effects_d_dvp_leg_14286 = 1 THEN 1 ELSE 0)
          ] EXCEPT
            !["spentA"] =
              effects_d_dvp_s["spentA"]
                + (IF effects_d_dvp_leg_14286 = 0 THEN 1 ELSE 0)
        ] EXCEPT
          !["spentB"] =
            effects_d_dvp_s["spentB"]
              + (IF effects_d_dvp_leg_14286 = 1 THEN 1 ELSE 0)
      ]

(*
  @type: (() => Bool);
*)
ICore == physicalInvariant(effects_d_dvp_s)

(*
  @type: (() => Bool);
*)
effectSoundness ==
  localCommitAtomicity
    /\ (\A t_5222 \in effects_d_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == effects_d_dvp_s["trades"][t_5222]
      IN
      ((z)["effectsA"] > 0 => (z)["holdA"] = 2)
        /\ ((z)["effectsB"] > 0 => (z)["holdB"] = 2)
        /\ ((z)["refundsA"] > 0 => (z)["holdA"] = 3)
        /\ ((z)["refundsB"] > 0 => (z)["holdB"] = 3)
        /\ ((z)["holdA"] = 1 => (z)["effectsA"] = 0 /\ (z)["refundsA"] = 0)
        /\ ((z)["holdB"] = 1 => (z)["effectsB"] = 0 /\ (z)["refundsB"] = 0))

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
CandidateFacts ==
  {
    (domainFact(v_4426[1], v_4426[2], v_4426[3])):
      v_4426 \in effects_d_dvp_Trades \X (0 .. 6) \X (0 .. 10)
  }

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_openA(effects_d_dvp_t_12154) ==
  effects_d_dvp_canOpen(effects_d_dvp_s, effects_d_dvp_t_12154)
    /\ effects_d_dvp_s'
      := effects_d_dvp_reserveA(effects_d_dvp_s, effects_d_dvp_t_12154)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
effects_d_dvp_has(effects_d_dvp_x_11539, effects_d_dvp_t_11539, effects_d_dvp_p_11539) ==
  \E effects_d_dvp_f_11537 \in effects_d_dvp_x_11539["received"]:
    effects_d_dvp_authFact(effects_d_dvp_x_11539, effects_d_dvp_f_11537, effects_d_dvp_t_11539,
    effects_d_dvp_p_11539)

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
FactSpace ==
  (AuthenticFacts \union CandidateFacts)
    \union { ([ f_4438 EXCEPT !["program"] = 0 ]): f_4438 \in AuthenticFacts }

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_prepareB(effects_d_dvp_t_12378) ==
  effects_d_dvp_authorized(effects_d_dvp_s, effects_d_dvp_t_12378)
    /\ effects_d_dvp_s["admitted"]
    /\ <<effects_d_dvp_t_12378, 1>> \in effects_d_dvp_s["eligible"]
    /\ ~(1 \in effects_d_dvp_s["frozen"])
    /\ 1 \in effects_d_dvp_s["up"]
    /\ (effects_d_dvp_HOST /= 3 \/ 3 \in effects_d_dvp_s["up"])
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_12378]["knownB"] = 0
    /\ effects_d_dvp_s["trades"][effects_d_dvp_t_12378]["holdB"] = 0
    /\ (~effects_d_dvp_OPEN_REQUIRED
      \/ effects_d_dvp_has(effects_d_dvp_s, effects_d_dvp_t_12378, 0))
    /\ (IF effects_d_dvp_ESCROW
    THEN effects_d_dvp_s["ownerB"] >= 3
    ELSE effects_d_dvp_s["ownerB"] - effects_d_dvp_reservedB(effects_d_dvp_s)
      >= 3)
    /\ effects_d_dvp_s'
      := [
        [
          [
            [
              effects_d_dvp_s EXCEPT
                !["trades"] =
                  [
                    effects_d_dvp_s["trades"] EXCEPT
                      ![effects_d_dvp_t_12378] =
                        [
                          [
                            [
                              effects_d_dvp_s["trades"][effects_d_dvp_t_12378] EXCEPT
                                !["holdB"] = 1
                            ] EXCEPT
                              !["intent"] = TRUE
                          ] EXCEPT
                            !["preparedB"] = TRUE
                        ]
                  ]
            ] EXCEPT
              !["ownerB"] =
                IF effects_d_dvp_ESCROW
                THEN effects_d_dvp_s["ownerB"] - 3
                ELSE effects_d_dvp_s["ownerB"]
          ] EXCEPT
            !["vaultB"] =
              IF effects_d_dvp_ESCROW
              THEN effects_d_dvp_s["vaultB"] + 3
              ELSE effects_d_dvp_s["vaultB"]
        ] EXCEPT
          !["included"] =
            effects_d_dvp_s["included"]
              \union {(effects_d_dvp_fact(effects_d_dvp_t_12378, 2))}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
effects_d_dvp_preparationAtConsumer(effects_d_dvp_x_11593, effects_d_dvp_t_11593,
effects_d_dvp_p_11593) ==
  IF effects_d_dvp_MUTANT = 10
  THEN \E effects_d_dvp_f_11586 \in effects_d_dvp_x_11593["received"]:
    effects_d_dvp_f_11586 \in effects_d_dvp_x_11593["proofs"]
      /\ effects_d_dvp_f_11586["d"] = effects_d_dvp_desc(effects_d_dvp_t_11593)
      /\ effects_d_dvp_f_11586["phase"] = effects_d_dvp_p_11593
      /\ effects_d_dvp_f_11586["checkpoint"] = 0
      /\ effects_d_dvp_f_11586["root"]
        = (effects_d_dvp_fact(effects_d_dvp_t_11593, effects_d_dvp_p_11593))[
          "root"
        ]
  ELSE effects_d_dvp_has(effects_d_dvp_x_11593, effects_d_dvp_t_11593, effects_d_dvp_p_11593)

(*
  @type: ((Int, Int, Int) => Bool);
*)
effects_d_dvp_learn(effects_d_dvp_t_13685, effects_d_dvp_outcome_13685, effects_d_dvp_leg_13685) ==
  effects_d_dvp_leg_13685 \in effects_d_dvp_s["up"]
    /\ (effects_d_dvp_HOST /= 3 \/ 3 \in effects_d_dvp_s["up"])
    /\ effects_d_dvp_has(effects_d_dvp_s, effects_d_dvp_t_13685, (IF effects_d_dvp_outcome_13685
      = 2
    THEN 3
    ELSE 4))
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_13685] =
                  [
                    [
                      effects_d_dvp_s["trades"][effects_d_dvp_t_13685] EXCEPT
                        !["knownA"] =
                          IF effects_d_dvp_leg_13685 = 0
                          THEN effects_d_dvp_outcome_13685
                          ELSE effects_d_dvp_s["trades"][effects_d_dvp_t_13685][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF effects_d_dvp_leg_13685 = 1
                          /\ (effects_d_dvp_MUTANT /= 9
                            \/ effects_d_dvp_s["trades"][effects_d_dvp_t_13685][
                              "holdB"
                            ]
                              /= 0)
                        THEN effects_d_dvp_outcome_13685
                        ELSE effects_d_dvp_s["trades"][effects_d_dvp_t_13685][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_d_dvp_observe(effects_d_dvp_t_14398, effects_d_dvp_leg_14398) ==
  3 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_has(effects_d_dvp_s, effects_d_dvp_t_14398, (IF effects_d_dvp_leg_14398
      = 0
    THEN 5
    ELSE 6))
    /\ effects_d_dvp_s'
      := [
        effects_d_dvp_s EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_14398] =
                  [
                    [
                      effects_d_dvp_s["trades"][effects_d_dvp_t_14398] EXCEPT
                        !["appliedEvidenceA"] =
                          effects_d_dvp_s["trades"][effects_d_dvp_t_14398][
                              "appliedEvidenceA"
                            ]
                            \/ effects_d_dvp_leg_14398 = 0
                    ] EXCEPT
                      !["appliedEvidenceB"] =
                        effects_d_dvp_s["trades"][effects_d_dvp_t_14398][
                            "appliedEvidenceB"
                          ]
                          \/ effects_d_dvp_leg_14398 = 1
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_recordAbort(effects_d_dvp_t_14822) ==
  3 \in effects_d_dvp_s["up"]
    /\ effects_d_dvp_has(effects_d_dvp_s, effects_d_dvp_t_14822, 4)
    /\ effects_d_dvp_hasAbortRecord(effects_d_dvp_s, effects_d_dvp_t_14822, 0)
    /\ effects_d_dvp_hasAbortRecord(effects_d_dvp_s, effects_d_dvp_t_14822, 1)
    /\ effects_d_dvp_s'
      := [
        [
          effects_d_dvp_s EXCEPT
            !["financialRecords"] =
              effects_d_dvp_s["financialRecords"]
                \union {(effects_d_dvp_bookingOutput(effects_d_dvp_t_14822, 3))}
        ] EXCEPT
          !["trades"] =
            [
              effects_d_dvp_s["trades"] EXCEPT
                ![effects_d_dvp_t_14822] =
                  [
                    [
                      [
                        effects_d_dvp_s["trades"][effects_d_dvp_t_14822] EXCEPT
                          !["report"] = 3
                      ] EXCEPT
                        !["stale"] = FALSE
                    ] EXCEPT
                      !["booked"] =
                        IF effects_d_dvp_s["trades"][effects_d_dvp_t_14822][
                          "booked"
                        ]
                          = 0
                        THEN 1
                        ELSE effects_d_dvp_s["trades"][effects_d_dvp_t_14822][
                          "booked"
                        ]
                  ]
            ]
      ]

(*
  @type: (() => Set({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }));
*)
StateSpace ==
  {
    ([trades |-> v_4743[1],
      signed |-> v_4743[2],
      height |-> v_4743[3],
      ownerA |-> v_4743[4],
      ownerB |-> v_4743[5],
      vaultA |-> v_4743[6],
      vaultB |-> v_4743[7],
      spentA |-> v_4743[8],
      spentB |-> v_4743[9],
      receivedA |-> v_4743[10],
      receivedB |-> v_4743[11],
      economicReceipts |-> v_4743[12],
      financialRecords |-> v_4743[13],
      included |-> v_4743[14],
      finalized |-> v_4743[15],
      captured |-> v_4743[16],
      proofs |-> v_4743[17],
      network |-> v_4743[18],
      received |-> v_4743[19],
      abortRecords |-> v_4743[20],
      pruned |-> v_4743[21],
      up |-> v_4743[22],
      epoch |-> v_4743[23],
      admitted |-> v_4743[24],
      historical |-> v_4743[25],
      eligible |-> v_4743[26],
      frozen |-> v_4743[27],
      note |-> v_4743[28],
      rejects |-> v_4743[29],
      transportCompromised |-> v_4743[30],
      custody |-> v_4743[31],
      upgrade |-> v_4743[32],
      validator |-> v_4743[33],
      decrypt |-> v_4743[34]]):
      v_4743 \in
        [(effects_d_dvp_Trades) -> (TradeSpace)]
          \X (SUBSET ({
              (effects_d_dvp_desc(t_4533)):
                t_4533 \in effects_d_dvp_Trades
            }
            \X { 0, 1 }))
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X [(effects_d_dvp_Trades) -> Int]
          \X [(effects_d_dvp_Trades) -> Int]
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
          \X (SUBSET (effects_d_dvp_Trades \X { 0, 1 }))
          \X (SUBSET ({ 0, 1 }))
          \X (SUBSET effects_d_dvp_Trades)
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
domainByFields(x_4983) ==
  (DOMAIN (x_4983["trades"]) = effects_d_dvp_Trades
      /\ (\A t_4767 \in effects_d_dvp_Trades:
        tradeDomainContains(x_4983["trades"][t_4767])))
    /\ x_4983["signed"]
      \subseteq {
          (effects_d_dvp_desc(t_4777)):
            t_4777 \in effects_d_dvp_Trades
        }
        \X { 0, 1 }
    /\ x_4983["height"] \in Int
    /\ x_4983["ownerA"] \in Int
    /\ x_4983["ownerB"] \in Int
    /\ x_4983["vaultA"] \in Int
    /\ x_4983["vaultB"] \in Int
    /\ x_4983["spentA"] \in Int
    /\ x_4983["spentB"] \in Int
    /\ (DOMAIN (x_4983["receivedA"]) = effects_d_dvp_Trades
      /\ (\A t_4834 \in effects_d_dvp_Trades:
        x_4983["receivedA"][t_4834] \in Int))
    /\ (DOMAIN (x_4983["receivedB"]) = effects_d_dvp_Trades
      /\ (\A t_4852 \in effects_d_dvp_Trades:
        x_4983["receivedB"][t_4852] \in Int))
    /\ x_4983["economicReceipts"] \subseteq OutputSpace
    /\ x_4983["financialRecords"] \subseteq BookingSpace
    /\ x_4983["included"] \subseteq FactSpace
    /\ x_4983["finalized"] \subseteq FactSpace
    /\ x_4983["captured"] \subseteq FactSpace
    /\ x_4983["proofs"] \subseteq FactSpace
    /\ x_4983["network"] \subseteq FactSpace
    /\ x_4983["received"] \subseteq FactSpace
    /\ x_4983["abortRecords"] \subseteq AbortSpace
    /\ x_4983["pruned"] \subseteq FactSpace
    /\ x_4983["up"] \subseteq 0 .. 4
    /\ x_4983["epoch"] \in Int
    /\ x_4983["admitted"] \in BOOLEAN
    /\ x_4983["historical"] \subseteq { 1, 2 }
    /\ x_4983["eligible"] \subseteq effects_d_dvp_Trades \X { 0, 1 }
    /\ x_4983["frozen"] \subseteq { 0, 1 }
    /\ x_4983["note"] \subseteq effects_d_dvp_Trades
    /\ x_4983["rejects"] \subseteq 0 .. 10
    /\ x_4983["transportCompromised"] \in BOOLEAN
    /\ x_4983["custody"] \in BOOLEAN
    /\ x_4983["upgrade"] \in BOOLEAN
    /\ x_4983["validator"] \in BOOLEAN
    /\ x_4983["decrypt"] \in BOOLEAN

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
                                          (effects_d_dvp_desc(t_5284)):
                                            t_5284 \in effects_d_dvp_Trades
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
                                                                                      SUBSET (effects_d_dvp_Trades
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
                                                                                          SUBSET effects_d_dvp_Trades:
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
                                                                                                        (\A t_5540 \in
                                                                                                          effects_d_dvp_Trades:
                                                                                                            tradeDomainContains((candidate)[
                                                                                                              "trades"
                                                                                                            ][
                                                                                                              t_5540
                                                                                                            ]))
                                                                                                          /\ physicalInvariant((candidate))
                                                                                                          /\ effects_d_dvp_s'
                                                                                                            := candidate

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
effects_d_dvp_canCommit(effects_d_dvp_x_13119, effects_d_dvp_t_13119) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_d_dvp_z == effects_d_dvp_x_13119["trades"][effects_d_dvp_t_13119]
  IN
  effects_d_dvp_HOST \in effects_d_dvp_x_13119["up"]
    /\ 2 \in effects_d_dvp_x_13119["up"]
    /\ (effects_d_dvp_z)["decision"] = 1
    /\ effects_d_dvp_x_13119["height"] < effects_d_dvp_D
    /\ (IF effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3
    THEN (effects_d_dvp_z)["holdA"] = 1
    ELSE IF effects_d_dvp_HOST = 1 THEN (effects_d_dvp_z)["holdB"] = 1 ELSE TRUE)
    /\ (IF effects_d_dvp_HOST = 3
    THEN ~(0 \in effects_d_dvp_x_13119["frozen"])
      /\ ~(1 \in effects_d_dvp_x_13119["frozen"])
    ELSE IF effects_d_dvp_HOST = 0
    THEN ~(0 \in effects_d_dvp_x_13119["frozen"])
    ELSE IF effects_d_dvp_HOST = 1
    THEN ~(1 \in effects_d_dvp_x_13119["frozen"])
    ELSE TRUE)
    /\ (IF effects_d_dvp_MUTANT = 2
    THEN \E effects_d_dvp_f_13069 \in effects_d_dvp_x_13119["received"]:
      effects_d_dvp_f_13069["phase"] = 2
        /\ effects_d_dvp_f_13069 \in effects_d_dvp_x_13119["proofs"]
    ELSE IF effects_d_dvp_MUTANT = 6
    THEN \E effects_d_dvp_f_13083 \in effects_d_dvp_x_13119["received"]:
      effects_d_dvp_f_13083["phase"] = 2
    ELSE IF effects_d_dvp_HOST = 1
    THEN TRUE
    ELSE IF effects_d_dvp_HOST = 3
    THEN (effects_d_dvp_z)["holdB"] = 1
    ELSE effects_d_dvp_preparationAtConsumer(effects_d_dvp_x_13119, effects_d_dvp_t_13119,
    2))
    /\ ((effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3)
      \/ effects_d_dvp_preparationAtConsumer(effects_d_dvp_x_13119, effects_d_dvp_t_13119,
      1))

(*
  @type: (() => Bool);
*)
FullTypeOK == effects_d_dvp_s \in StateSpace

(*
  @type: (() => Bool);
*)
effectIExpanded == domainByFields(effects_d_dvp_s) /\ ICore

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_commit(effects_d_dvp_t_13478) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_d_dvp_z == effects_d_dvp_s["trades"][effects_d_dvp_t_13478]
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_d_dvp_a ==
    IF (effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3)
      /\ effects_d_dvp_MUTANT /= 5
    THEN effects_d_dvp_debitA(effects_d_dvp_s)
    ELSE effects_d_dvp_s
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_d_dvp_b ==
    IF effects_d_dvp_HOST = 1 \/ effects_d_dvp_HOST = 3
    THEN effects_d_dvp_debitB((effects_d_dvp_a))
    ELSE effects_d_dvp_a
  IN
  effects_d_dvp_canCommit(effects_d_dvp_s, effects_d_dvp_t_13478)
    /\ effects_d_dvp_s'
      := [
        [
          [
            [
              [
                (effects_d_dvp_b) EXCEPT
                  !["economicReceipts"] =
                    ((effects_d_dvp_b)["economicReceipts"]
                      \union (IF (effects_d_dvp_HOST = 0
                          \/ effects_d_dvp_HOST = 3)
                        /\ effects_d_dvp_MUTANT /= 5
                      THEN {(effects_d_dvp_economicOutput(effects_d_dvp_t_13478,
                      0, 0))}
                      ELSE {}))
                      \union (IF effects_d_dvp_HOST = 1
                        \/ effects_d_dvp_HOST = 3
                      THEN {(effects_d_dvp_economicOutput(effects_d_dvp_t_13478,
                      1, 0))}
                      ELSE {})
              ] EXCEPT
                !["included"] =
                  (((effects_d_dvp_b)["included"]
                    \union {(effects_d_dvp_fact(effects_d_dvp_t_13478, 3))})
                    \union (IF (effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3)
                      /\ effects_d_dvp_MUTANT /= 5
                    THEN {(effects_d_dvp_fact(effects_d_dvp_t_13478, 5))}
                    ELSE {}))
                    \union (IF effects_d_dvp_HOST = 1 \/ effects_d_dvp_HOST = 3
                    THEN {(effects_d_dvp_fact(effects_d_dvp_t_13478, 6))}
                    ELSE {})
            ] EXCEPT
              !["trades"] =
                [
                  (effects_d_dvp_b)["trades"] EXCEPT
                    ![effects_d_dvp_t_13478] =
                      [
                        [
                          [
                            [
                              [
                                [
                                  [
                                    [
                                      (effects_d_dvp_z) EXCEPT
                                        !["decision"] = 2
                                    ] EXCEPT
                                      !["oldTerminal"] =
                                        IF (effects_d_dvp_z)["oldTerminal"] = 0
                                        THEN 2
                                        ELSE (effects_d_dvp_z)["oldTerminal"]
                                  ] EXCEPT
                                    !["knownA"] =
                                      IF effects_d_dvp_HOST = 0
                                        \/ effects_d_dvp_HOST = 3
                                      THEN 2
                                      ELSE (effects_d_dvp_z)["knownA"]
                                ] EXCEPT
                                  !["knownB"] =
                                    IF effects_d_dvp_HOST = 1
                                      \/ effects_d_dvp_HOST = 3
                                    THEN 2
                                    ELSE (effects_d_dvp_z)["knownB"]
                              ] EXCEPT
                                !["holdA"] =
                                  IF (effects_d_dvp_HOST = 0
                                      \/ effects_d_dvp_HOST = 3)
                                    /\ effects_d_dvp_MUTANT /= 5
                                  THEN 2
                                  ELSE (effects_d_dvp_z)["holdA"]
                            ] EXCEPT
                              !["holdB"] =
                                IF effects_d_dvp_HOST = 1
                                  \/ effects_d_dvp_HOST = 3
                                THEN 2
                                ELSE (effects_d_dvp_z)["holdB"]
                          ] EXCEPT
                            !["effectsA"] =
                              (effects_d_dvp_z)["effectsA"]
                                + (IF (effects_d_dvp_HOST = 0
                                    \/ effects_d_dvp_HOST = 3)
                                  /\ effects_d_dvp_MUTANT /= 5
                                THEN 1
                                ELSE 0)
                        ] EXCEPT
                          !["effectsB"] =
                            (effects_d_dvp_z)["effectsB"]
                              + (IF effects_d_dvp_HOST = 1
                                \/ effects_d_dvp_HOST = 3
                              THEN 1
                              ELSE 0)
                      ]
                ]
          ] EXCEPT
            !["receivedA"] =
              IF (effects_d_dvp_HOST = 0 \/ effects_d_dvp_HOST = 3)
                /\ effects_d_dvp_MUTANT /= 5
              THEN LET (*
                @type: (() => (Int -> Int));
              *)
              __quint_var0 == (effects_d_dvp_b)["receivedA"]
              IN
              [
                (__quint_var0) EXCEPT
                  ![effects_d_dvp_t_13478] =
                    LET (*
                      @type: ((Int) => Int);
                    *)
                    __QUINT_LAMBDA0(effects_d_dvp_q_13438) ==
                      effects_d_dvp_q_13438 + 2
                    IN
                    __QUINT_LAMBDA0((__quint_var0)[effects_d_dvp_t_13478])
              ]
              ELSE (effects_d_dvp_b)["receivedA"]
        ] EXCEPT
          !["receivedB"] =
            IF effects_d_dvp_HOST = 1 \/ effects_d_dvp_HOST = 3
            THEN LET (*
              @type: (() => (Int -> Int));
            *)
            __quint_var1 == (effects_d_dvp_b)["receivedB"]
            IN
            [
              (__quint_var1) EXCEPT
                ![effects_d_dvp_t_13478] =
                  LET (*
                    @type: ((Int) => Int);
                  *)
                  __QUINT_LAMBDA1(effects_d_dvp_q_13460) ==
                    effects_d_dvp_q_13460 + 3
                  IN
                  __QUINT_LAMBDA1((__quint_var1)[effects_d_dvp_t_13478])
            ]
            ELSE (effects_d_dvp_b)["receivedB"]
      ]

(*
  @type: (() => Bool);
*)
effectI == FullTypeOK /\ ICore

(*
  @type: ((Int) => Bool);
*)
effects_d_dvp_tradeStep(effects_d_dvp_t_15081) ==
  effects_d_dvp_sign(effects_d_dvp_t_15081, 0)
    \/ effects_d_dvp_sign(effects_d_dvp_t_15081, 1)
    \/ effects_d_dvp_openA(effects_d_dvp_t_15081)
    \/ effects_d_dvp_prepareB(effects_d_dvp_t_15081)
    \/ effects_d_dvp_registerDecision(effects_d_dvp_t_15081)
    \/ effects_d_dvp_commit(effects_d_dvp_t_15081)
    \/ effects_d_dvp_abort(effects_d_dvp_t_15081)
    \/ effects_d_dvp_applyA(effects_d_dvp_t_15081)
    \/ effects_d_dvp_applyB(effects_d_dvp_t_15081)
    \/ effects_d_dvp_refund(effects_d_dvp_t_15081, 0)
    \/ effects_d_dvp_refund(effects_d_dvp_t_15081, 1)
    \/ effects_d_dvp_learn(effects_d_dvp_t_15081, 2, 0)
    \/ effects_d_dvp_learn(effects_d_dvp_t_15081, 2, 1)
    \/ effects_d_dvp_learn(effects_d_dvp_t_15081, 3, 0)
    \/ effects_d_dvp_learn(effects_d_dvp_t_15081, 3, 1)
    \/ effects_d_dvp_observe(effects_d_dvp_t_15081, 0)
    \/ effects_d_dvp_observe(effects_d_dvp_t_15081, 1)
    \/ effects_d_dvp_reconcile(effects_d_dvp_t_15081)
    \/ effects_d_dvp_captureAbortRecord(effects_d_dvp_t_15081, 0)
    \/ effects_d_dvp_captureAbortRecord(effects_d_dvp_t_15081, 1)
    \/ effects_d_dvp_recordAbort(effects_d_dvp_t_15081)
    \/ effects_d_dvp_unsafeRefund(effects_d_dvp_t_15081)
    \/ effects_d_dvp_forgetTerminal(effects_d_dvp_t_15081)
    \/ effects_d_dvp_receiveNote(effects_d_dvp_t_15081)
    \/ (\E effects_d_dvp_p \in 0 .. 6:
      effects_d_dvp_finalize(effects_d_dvp_t_15081, effects_d_dvp_p)
        \/ effects_d_dvp_capture(effects_d_dvp_t_15081, effects_d_dvp_p)
        \/ effects_d_dvp_prove(effects_d_dvp_t_15081, effects_d_dvp_p)
        \/ effects_d_dvp_deliver(effects_d_dvp_t_15081, effects_d_dvp_p)
        \/ effects_d_dvp_resend(effects_d_dvp_t_15081, effects_d_dvp_p))

(*
  @type: (() => Bool);
*)
inductionInit == effectI /\ effectIExpanded

(*
  @type: (() => Bool);
*)
effects_d_dvp_step ==
  (\E effects_d_dvp_t \in effects_d_dvp_Trades:
      effects_d_dvp_tradeStep(effects_d_dvp_t))
    \/ effects_d_dvp_tick
    \/ effects_d_dvp_idle

(*
  @type: (() => Bool);
*)
q_inv == effectI

(*
  @type: (() => Bool);
*)
effects_d_dvp_adversarialStep ==
  effects_d_dvp_step
    \/ (\E effects_d_dvp_t \in effects_d_dvp_Trades:
      \E effects_d_dvp_p \in 0 .. 6:
        effects_d_dvp_proveUnadmitted(effects_d_dvp_t, effects_d_dvp_p)
          \/ effects_d_dvp_deliverUnadmitted(effects_d_dvp_t, effects_d_dvp_p))
    \/ (\E effects_d_dvp_t \in effects_d_dvp_Trades:
      \E effects_d_dvp_p \in 0 .. 6:
        \E effects_d_dvp_f \in 0 .. 10:
          effects_d_dvp_inject(effects_d_dvp_t, effects_d_dvp_p, effects_d_dvp_f))
    \/ (\E effects_d_dvp_a \in 0 .. 4:
      effects_d_dvp_crash(effects_d_dvp_a)
        \/ effects_d_dvp_recover(effects_d_dvp_a))
    \/ (\E effects_d_dvp_l \in { 0, 1 }:
      effects_d_dvp_spend(effects_d_dvp_l)
        \/ effects_d_dvp_freeze(effects_d_dvp_l)
        \/ effects_d_dvp_unfreeze(effects_d_dvp_l))
    \/ effects_d_dvp_rotate
    \/ effects_d_dvp_exitMember
    \/ (\E effects_d_dvp_t \in effects_d_dvp_Trades:
      \E effects_d_dvp_l \in { 0, 1 }:
        effects_d_dvp_revokeLeg(effects_d_dvp_t, effects_d_dvp_l))
    \/ effects_d_dvp_compromiseTransport

(*
  @type: (() => Bool);
*)
q_step == effects_d_dvp_adversarialStep

================================================================================

---- MODULE effects_one ------------------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

(*
  @type: (() => Set({ appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }));
*)
TradeSpace ==
  {
    ([decision |-> v_107[1],
      oldTerminal |-> v_107[2],
      holdA |-> v_107[3],
      holdB |-> v_107[4],
      effectsA |-> v_107[5],
      effectsB |-> v_107[6],
      refundsA |-> v_107[7],
      refundsB |-> v_107[8],
      knownA |-> v_107[9],
      knownB |-> v_107[10],
      preparedA |-> v_107[11],
      preparedB |-> v_107[12],
      appliedEvidenceA |-> v_107[13],
      appliedEvidenceB |-> v_107[14],
      booked |-> v_107[15],
      report |-> v_107[16],
      stale |-> v_107[17],
      intent |-> v_107[18]]):
      v_107 \in
        Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
          \X Int
          \X Int
          \X BOOLEAN
          \X BOOLEAN
  }

(*
  @type: (() => Int);
*)
effects_one_dvp_N == 1

(*
  @type: (() => Int);
*)
effects_one_dvp_HOST == 0

(*
  @type: (() => Int);
*)
effects_one_dvp_D == 2

(*
  @type: (() => Int);
*)
effects_one_dvp_MUTANT == 0

VARIABLE
  (*
    @type: { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int };
  *)
  effects_one_dvp_s

(*
  @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
*)
effects_one_dvp_emptyTrade ==
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
effects_one_dvp_ESCROW == FALSE

(*
  @type: (() => Bool);
*)
effects_one_dvp_OPEN_REQUIRED == FALSE

(*
  @type: (() => Set(Int));
*)
effects_one_dvp_Trades == 1 .. effects_one_dvp_N

(*
  @type: ((Int) => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
*)
effects_one_dvp_desc(effects_one_dvp_t_6748) ==
  [trade |-> effects_one_dvp_t_6748,
    nonce |-> effects_one_dvp_t_6748,
    chainA |-> 10,
    genesisA |-> 110,
    chainB |-> IF effects_one_dvp_HOST = 3 THEN 10 ELSE 20,
    genesisB |-> IF effects_one_dvp_HOST = 3 THEN 110 ELSE 120,
    decisionDomain |-> effects_one_dvp_HOST,
    assetA |-> 30,
    assetB |-> 40,
    holdA |-> 50,
    holdB |-> 60,
    decisionContract |-> 70,
    security |-> 2,
    cash |-> 3,
    sellerA |-> 0,
    buyerA |-> effects_one_dvp_t_6748,
    buyerB |-> IF effects_one_dvp_HOST = 3 THEN effects_one_dvp_t_6748 ELSE 0,
    sellerB |-> IF effects_one_dvp_HOST = 3 THEN 0 ELSE effects_one_dvp_t_6748,
    deadline |-> effects_one_dvp_D,
    protocol |-> 1,
    epoch |-> 0,
    commitment |-> 1000 + effects_one_dvp_t_6748]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
effects_one_dvp_debitA(effects_one_dvp_x_8696) ==
  [
    [
      effects_one_dvp_x_8696 EXCEPT
        !["ownerA"] =
          IF effects_one_dvp_ESCROW
          THEN effects_one_dvp_x_8696["ownerA"]
          ELSE effects_one_dvp_x_8696["ownerA"] - 2
    ] EXCEPT
      !["vaultA"] =
        IF effects_one_dvp_ESCROW
        THEN effects_one_dvp_x_8696["vaultA"] - 2
        ELSE effects_one_dvp_x_8696["vaultA"]
  ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
effects_one_dvp_debitB(effects_one_dvp_x_8726) ==
  [
    [
      effects_one_dvp_x_8726 EXCEPT
        !["ownerB"] =
          IF effects_one_dvp_ESCROW
          THEN effects_one_dvp_x_8726["ownerB"]
          ELSE effects_one_dvp_x_8726["ownerB"] - 3
    ] EXCEPT
      !["vaultB"] =
        IF effects_one_dvp_ESCROW
        THEN effects_one_dvp_x_8726["vaultB"] - 3
        ELSE effects_one_dvp_x_8726["vaultB"]
  ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_unsafeRefund(effects_one_dvp_t_9711) ==
  (effects_one_dvp_MUTANT = 1
      \/ ((effects_one_dvp_MUTANT = 7
          /\ effects_one_dvp_s["trades"][effects_one_dvp_t_9711]["stale"])
        /\ effects_one_dvp_s["trades"][effects_one_dvp_t_9711]["report"] = 0))
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_9711]["holdB"] = 1
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_9711] =
                  [
                    [
                      effects_one_dvp_s["trades"][effects_one_dvp_t_9711] EXCEPT
                        !["holdB"] = 3
                    ] EXCEPT
                      !["refundsB"] =
                        effects_one_dvp_s["trades"][effects_one_dvp_t_9711][
                          "refundsB"
                        ]
                          + 1
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_forgetTerminal(effects_one_dvp_t_9750) ==
  effects_one_dvp_MUTANT = 8
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_9750]["decision"] >= 2
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_9750] =
                  [
                    [
                      effects_one_dvp_s["trades"][effects_one_dvp_t_9750] EXCEPT
                        !["decision"] = 0
                    ] EXCEPT
                      !["holdA"] = 0
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_receiveNote(effects_one_dvp_t_10525) ==
  effects_one_dvp_s["trades"][effects_one_dvp_t_10525]["effectsB"] = 1
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["note"] = effects_one_dvp_s["note"] \union {effects_one_dvp_t_10525}
      ]

(*
  @type: (() => Bool);
*)
effects_one_dvp_tick ==
  effects_one_dvp_HOST \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_s["height"] < effects_one_dvp_D
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["height"] = effects_one_dvp_s["height"] + 1
      ]

(*
  @type: (() => Bool);
*)
effects_one_dvp_idle == effects_one_dvp_s' := effects_one_dvp_s

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_recover(effects_one_dvp_actor_9882) ==
  effects_one_dvp_s'
    := [
      effects_one_dvp_s EXCEPT
        !["up"] = effects_one_dvp_s["up"] \union {effects_one_dvp_actor_9882}
    ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_freeze(effects_one_dvp_leg_10455) ==
  effects_one_dvp_s'
    := [
      effects_one_dvp_s EXCEPT
        !["frozen"] =
          effects_one_dvp_s["frozen"] \union {effects_one_dvp_leg_10455}
    ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_unfreeze(effects_one_dvp_leg_10471) ==
  effects_one_dvp_s'
    := [
      effects_one_dvp_s EXCEPT
        !["frozen"] = effects_one_dvp_s["frozen"] \ {effects_one_dvp_leg_10471}
    ]

(*
  @type: (() => Bool);
*)
effects_one_dvp_rotate ==
  effects_one_dvp_s["epoch"] = 0
    /\ effects_one_dvp_s'
      := [
        [ effects_one_dvp_s EXCEPT !["epoch"] = 1 ] EXCEPT
          !["historical"] = effects_one_dvp_s["historical"] \union { 1, 2 }
      ]

(*
  @type: (() => Bool);
*)
effects_one_dvp_exitMember ==
  effects_one_dvp_s' := [ effects_one_dvp_s EXCEPT !["admitted"] = FALSE ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_revokeLeg(effects_one_dvp_t_10439, effects_one_dvp_leg_10439) ==
  effects_one_dvp_s'
    := [
      effects_one_dvp_s EXCEPT
        !["eligible"] =
          effects_one_dvp_s["eligible"]
            \ {<<effects_one_dvp_t_10439, effects_one_dvp_leg_10439>>}
    ]

(*
  @type: (() => Bool);
*)
effects_one_dvp_compromiseTransport ==
  effects_one_dvp_s'
    := [ effects_one_dvp_s EXCEPT !["transportCompromised"] = TRUE ]

(*
  @type: ((Int, Int) => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
*)
effects_one_dvp_fact(effects_one_dvp_t_6780, effects_one_dvp_p_6780) ==
  [d |-> effects_one_dvp_desc(effects_one_dvp_t_6780),
    phase |-> effects_one_dvp_p_6780,
    checkpoint |-> 0,
    program |-> 1,
    root |-> (200 + effects_one_dvp_p_6780 * 10) + effects_one_dvp_t_6780]

(*
  @type: ((Int, Int, Int) => { account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int });
*)
effects_one_dvp_economicOutput(effects_one_dvp_t_7295, effects_one_dvp_leg_7295,
effects_one_dvp_kind_7295) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  effects_one_dvp_d == effects_one_dvp_desc(effects_one_dvp_t_7295)
  IN
  LET (*
    @type: (() => Int);
  *)
  effects_one_dvp_account ==
    IF effects_one_dvp_leg_7295 = 0
    THEN IF effects_one_dvp_kind_7295 = 0
    THEN (effects_one_dvp_d)["buyerA"]
    ELSE (effects_one_dvp_d)["sellerA"]
    ELSE IF effects_one_dvp_kind_7295 = 0
    THEN (effects_one_dvp_d)["sellerB"]
    ELSE (effects_one_dvp_d)["buyerB"]
  IN
  LET (*
    @type: (() => Bool);
  *)
  effects_one_dvp_wrongAccount ==
    (effects_one_dvp_leg_7295 = 0
        /\ ((effects_one_dvp_kind_7295 = 0 /\ effects_one_dvp_MUTANT = 11)
          \/ (effects_one_dvp_kind_7295 = 1 /\ effects_one_dvp_MUTANT = 14)))
      \/ (effects_one_dvp_leg_7295 = 1
        /\ ((effects_one_dvp_kind_7295 = 0 /\ effects_one_dvp_MUTANT = 15)
          \/ (effects_one_dvp_kind_7295 = 1 /\ effects_one_dvp_MUTANT = 17)))
  IN
  [trade |-> effects_one_dvp_t_7295,
    leg |-> effects_one_dvp_leg_7295,
    kind |-> effects_one_dvp_kind_7295,
    chain |->
      IF effects_one_dvp_leg_7295 = 0
      THEN (effects_one_dvp_d)["chainA"]
      ELSE (effects_one_dvp_d)["chainB"],
    genesis |->
      IF effects_one_dvp_leg_7295 = 0
      THEN (effects_one_dvp_d)["genesisA"]
      ELSE (effects_one_dvp_d)["genesisB"],
    asset |->
      IF effects_one_dvp_leg_7295 = 0
      THEN IF effects_one_dvp_MUTANT = 12
      THEN (effects_one_dvp_d)["assetB"]
      ELSE (effects_one_dvp_d)["assetA"]
      ELSE IF effects_one_dvp_MUTANT = 16
      THEN (effects_one_dvp_d)["assetA"]
      ELSE (effects_one_dvp_d)["assetB"],
    account |->
      IF effects_one_dvp_wrongAccount
      THEN IF effects_one_dvp_account = 0 THEN 1 ELSE 0
      ELSE effects_one_dvp_account,
    quantity |->
      IF effects_one_dvp_leg_7295 = 0
      THEN (effects_one_dvp_d)["security"]
      ELSE (effects_one_dvp_d)["cash"]]

(*
  @type: ((Int, Int) => { d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int });
*)
effects_one_dvp_bookingOutput(effects_one_dvp_t_7334, effects_one_dvp_outcome_7334) ==
  LET (*
    @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
  *)
  effects_one_dvp_d == effects_one_dvp_desc(effects_one_dvp_t_7334)
  IN
  [d |->
      IF effects_one_dvp_MUTANT = 18
      THEN [
        (effects_one_dvp_d) EXCEPT
          !["sellerB"] = IF (effects_one_dvp_d)["sellerB"] = 0 THEN 1 ELSE 0
      ]
      ELSE IF effects_one_dvp_MUTANT = 19
      THEN [ (effects_one_dvp_d) EXCEPT !["cash"] = 4 ]
      ELSE effects_one_dvp_d,
    outcome |-> effects_one_dvp_outcome_7334]

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }));
*)
AbortSpace ==
  {
    (LET (*
      @type: (() => { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int });
    *)
    d == effects_one_dvp_desc(v_345[1])
    IN
    [d |-> d,
      leg |-> v_345[2],
      genesis |-> IF v_345[2] = 0 THEN (d)["genesisA"] ELSE (d)["genesisB"],
      checkpoint |-> 0,
      program |-> 1,
      disposition |-> v_345[3]]):
      v_345 \in effects_one_dvp_Trades \X { 0, 1 } \X (0 .. 3)
  }

(*
  @type: (() => Bool);
*)
localCommitAtomicity ==
  \A t_630 \in effects_one_dvp_Trades:
    LET (*
      @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
    *)
    z == effects_one_dvp_s["trades"][t_630]
    IN
    (z)["decision"] = 2 => (z)["effectsA"] = 1

(*
  @type: (() => Bool);
*)
effects_one_dvp_init ==
  effects_one_dvp_s
    = [trades |->
        [
          effects_one_dvp___7560 \in effects_one_dvp_Trades |->
            effects_one_dvp_emptyTrade
        ],
      signed |-> {},
      height |-> 0,
      ownerA |-> 2,
      ownerB |-> 3,
      vaultA |-> 0,
      vaultB |-> 0,
      spentA |-> 0,
      spentB |-> 0,
      receivedA |-> [ effects_one_dvp___7582 \in effects_one_dvp_Trades |-> 0 ],
      receivedB |-> [ effects_one_dvp___7588 \in effects_one_dvp_Trades |-> 0 ],
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
      eligible |-> effects_one_dvp_Trades \X { 0, 1 },
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
effects_one_dvp_sign(effects_one_dvp_t_7687, effects_one_dvp_party_7687) ==
  effects_one_dvp_t_7687 \in effects_one_dvp_Trades
    /\ effects_one_dvp_party_7687 \in { 0, 1 }
    /\ effects_one_dvp_s["admitted"]
    /\ effects_one_dvp_s["epoch"] = 0
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["signed"] =
            effects_one_dvp_s["signed"]
              \union {<<
                (effects_one_dvp_desc(effects_one_dvp_t_7687)), effects_one_dvp_party_7687
              >>}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
effects_one_dvp_authorized(effects_one_dvp_x_7017, effects_one_dvp_t_7017) ==
  <<(effects_one_dvp_desc(effects_one_dvp_t_7017)), 0>>
      \in effects_one_dvp_x_7017["signed"]
    /\ <<(effects_one_dvp_desc(effects_one_dvp_t_7017)), 1>>
      \in effects_one_dvp_x_7017["signed"]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
effects_one_dvp_reservedA(effects_one_dvp_x_6972) ==
  Cardinality({
    effects_one_dvp_t_6967 \in effects_one_dvp_Trades:
      effects_one_dvp_x_6972["trades"][effects_one_dvp_t_6967]["holdA"] = 1
  })
    * 2

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }) => Int);
*)
effects_one_dvp_reservedB(effects_one_dvp_x_6993) ==
  Cardinality({
    effects_one_dvp_t_6988 \in effects_one_dvp_Trades:
      effects_one_dvp_x_6993["trades"][effects_one_dvp_t_6988]["holdB"] = 1
  })
    * 3

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_captureAbortRecord(effects_one_dvp_t_10115, effects_one_dvp_leg_10115) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_one_dvp_z == effects_one_dvp_s["trades"][effects_one_dvp_t_10115]
  IN
  LET (*
    @type: (() => Int);
  *)
  effects_one_dvp_localHold ==
    IF effects_one_dvp_leg_10115 = 0
    THEN (effects_one_dvp_z)["holdA"]
    ELSE (effects_one_dvp_z)["holdB"]
  IN
  LET (*
    @type: (() => Int);
  *)
  effects_one_dvp_localKnown ==
    IF effects_one_dvp_leg_10115 = 0
    THEN (effects_one_dvp_z)["knownA"]
    ELSE (effects_one_dvp_z)["knownB"]
  IN
  effects_one_dvp_leg_10115 \in effects_one_dvp_s["up"]
    /\ 3 \in effects_one_dvp_s["up"]
    /\ (effects_one_dvp_localKnown = 3 \/ effects_one_dvp_MUTANT = 13)
    /\ effects_one_dvp_localHold /= 1
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["abortRecords"] =
            effects_one_dvp_s["abortRecords"]
              \union {[d |-> effects_one_dvp_desc(effects_one_dvp_t_10115),
                leg |-> effects_one_dvp_leg_10115,
                genesis |->
                  IF effects_one_dvp_leg_10115 = 0
                  THEN (effects_one_dvp_desc(effects_one_dvp_t_10115))[
                    "genesisA"
                  ]
                  ELSE (effects_one_dvp_desc(effects_one_dvp_t_10115))[
                    "genesisB"
                  ],
                checkpoint |-> 0,
                program |-> 1,
                disposition |-> effects_one_dvp_localHold]}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
effects_one_dvp_hasAbortRecord(effects_one_dvp_x_10177, effects_one_dvp_t_10177,
effects_one_dvp_leg_10177) ==
  \E effects_one_dvp_r_10175 \in effects_one_dvp_x_10177["abortRecords"]:
    effects_one_dvp_r_10175["d"] = effects_one_dvp_desc(effects_one_dvp_t_10177)
      /\ effects_one_dvp_r_10175["leg"] = effects_one_dvp_leg_10177
      /\ effects_one_dvp_r_10175["genesis"]
        = (IF effects_one_dvp_leg_10177 = 0
        THEN (effects_one_dvp_desc(effects_one_dvp_t_10177))["genesisA"]
        ELSE (effects_one_dvp_desc(effects_one_dvp_t_10177))["genesisB"])
      /\ effects_one_dvp_r_10175["checkpoint"] = 0
      /\ effects_one_dvp_r_10175["program"]
        \in effects_one_dvp_x_10177["historical"]
      /\ effects_one_dvp_r_10175["disposition"] \in { 0, 3 }

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_crash(effects_one_dvp_actor_9866) ==
  effects_one_dvp_s'
    := [
      [
        effects_one_dvp_s EXCEPT
          !["up"] = effects_one_dvp_s["up"] \ {effects_one_dvp_actor_9866}
      ] EXCEPT
        !["trades"] =
          [
            effects_one_dvp_t_9859 \in effects_one_dvp_Trades |->
              [
                [
                  effects_one_dvp_s["trades"][effects_one_dvp_t_9859] EXCEPT
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
    (effects_one_dvp_fact(v_264[1], v_264[2])):
      v_264 \in effects_one_dvp_Trades \X (0 .. 6)
  }

(*
  @type: (() => Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }));
*)
OutputSpace ==
  {
    (effects_one_dvp_economicOutput(v_367[1], v_367[2], v_367[3])):
      v_367 \in effects_one_dvp_Trades \X { 0, 1 } \X { 0, 1 }
  }

(*
  @type: (() => Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }));
*)
BookingSpace ==
  {
    (effects_one_dvp_bookingOutput(v_383[1], v_383[2])):
      v_383 \in effects_one_dvp_Trades \X { 2, 3 }
  }

(*
  @type: ((Int, Int, Int) => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
*)
domainFact(t_249, p_249, binding_249) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  f == effects_one_dvp_fact(t_249, p_249)
  IN
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  bad ==
    IF binding_249 = 0
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["trade"] = 3 - t_249 ] ]
    ELSE IF binding_249 = 1
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["nonce"] = 99 ] ]
    ELSE IF binding_249 = 2
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["sellerB"] = 99 ] ]
    ELSE IF binding_249 = 3
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["cash"] = 4 ] ]
    ELSE IF binding_249 = 4
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["genesisB"] = 999 ] ]
    ELSE IF binding_249 = 5
    THEN [ (f) EXCEPT !["d"] = [ (f)["d"] EXCEPT !["decisionDomain"] = 99 ] ]
    ELSE IF binding_249 = 6
    THEN [ (f) EXCEPT !["phase"] = 6 ]
    ELSE IF binding_249 = 7
    THEN [ (f) EXCEPT !["checkpoint"] = 99 ]
    ELSE IF binding_249 = 8
    THEN [ (f) EXCEPT !["program"] = 99 ]
    ELSE IF binding_249 = 9
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
effectSoundness ==
  localCommitAtomicity
    /\ (\A t_825 \in effects_one_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == effects_one_dvp_s["trades"][t_825]
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
q_init == effects_one_dvp_init

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
effects_one_dvp_canOpen(effects_one_dvp_x_7471, effects_one_dvp_t_7471) ==
  effects_one_dvp_authorized(effects_one_dvp_x_7471, effects_one_dvp_t_7471)
    /\ effects_one_dvp_x_7471["admitted"]
    /\ <<effects_one_dvp_t_7471, 0>> \in effects_one_dvp_x_7471["eligible"]
    /\ ~(0 \in effects_one_dvp_x_7471["frozen"])
    /\ 0 \in effects_one_dvp_x_7471["up"]
    /\ (effects_one_dvp_HOST /= 3 \/ 3 \in effects_one_dvp_x_7471["up"])
    /\ (IF effects_one_dvp_HOST = 0 \/ effects_one_dvp_HOST = 3
    THEN effects_one_dvp_x_7471["height"] < effects_one_dvp_D
      \/ effects_one_dvp_MUTANT = 4
    ELSE TRUE)
    /\ (IF effects_one_dvp_HOST = 0 \/ effects_one_dvp_HOST = 3
    THEN effects_one_dvp_x_7471["trades"][effects_one_dvp_t_7471]["decision"]
        = 0
      \/ (effects_one_dvp_MUTANT = 4
        /\ effects_one_dvp_x_7471["trades"][effects_one_dvp_t_7471]["decision"]
          = 3)
    ELSE effects_one_dvp_x_7471["trades"][effects_one_dvp_t_7471]["knownA"] = 0)
    /\ (effects_one_dvp_x_7471["trades"][effects_one_dvp_t_7471]["holdA"] = 0
      \/ (effects_one_dvp_MUTANT = 4
        /\ effects_one_dvp_x_7471["trades"][effects_one_dvp_t_7471]["holdA"] = 3))
    /\ (IF effects_one_dvp_ESCROW
    THEN effects_one_dvp_x_7471["ownerA"] >= 2
    ELSE effects_one_dvp_x_7471["ownerA"]
      - effects_one_dvp_reservedA(effects_one_dvp_x_7471)
      >= 2)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
*)
effects_one_dvp_reserveA(effects_one_dvp_x_7555, effects_one_dvp_t_7555) ==
  [
    [
      [
        [
          effects_one_dvp_x_7555 EXCEPT
            !["trades"] =
              [
                effects_one_dvp_x_7555["trades"] EXCEPT
                  ![effects_one_dvp_t_7555] =
                    [
                      [
                        [
                          [
                            effects_one_dvp_x_7555["trades"][
                              effects_one_dvp_t_7555
                            ] EXCEPT
                              !["decision"] =
                                IF effects_one_dvp_HOST = 0
                                  \/ effects_one_dvp_HOST = 3
                                THEN 1
                                ELSE effects_one_dvp_x_7555["trades"][
                                  effects_one_dvp_t_7555
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
            IF effects_one_dvp_ESCROW
            THEN effects_one_dvp_x_7555["ownerA"] - 2
            ELSE effects_one_dvp_x_7555["ownerA"]
      ] EXCEPT
        !["vaultA"] =
          IF effects_one_dvp_ESCROW
          THEN effects_one_dvp_x_7555["vaultA"] + 2
          ELSE effects_one_dvp_x_7555["vaultA"]
    ] EXCEPT
      !["included"] =
        effects_one_dvp_x_7555["included"]
          \union { (effects_one_dvp_fact(effects_one_dvp_t_7555, 0)),
            (effects_one_dvp_fact(effects_one_dvp_t_7555, 1)) }
  ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }, Int, Int) => Bool);
*)
effects_one_dvp_authFact(effects_one_dvp_x_7066, effects_one_dvp_f_7066, effects_one_dvp_t_7066,
effects_one_dvp_p_7066) ==
  effects_one_dvp_f_7066 \in effects_one_dvp_x_7066["proofs"]
    /\ effects_one_dvp_f_7066["d"]
      = effects_one_dvp_desc(effects_one_dvp_t_7066)
    /\ effects_one_dvp_f_7066["phase"] = effects_one_dvp_p_7066
    /\ effects_one_dvp_f_7066["checkpoint"] = 0
    /\ effects_one_dvp_f_7066["program"]
      \in effects_one_dvp_x_7066["historical"]
    /\ effects_one_dvp_f_7066["root"]
      = (effects_one_dvp_fact(effects_one_dvp_t_7066, effects_one_dvp_p_7066))[
        "root"
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_registerDecision(effects_one_dvp_t_7760) ==
  (effects_one_dvp_HOST = 1 \/ effects_one_dvp_HOST = 2)
    /\ effects_one_dvp_HOST \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_authorized(effects_one_dvp_s, effects_one_dvp_t_7760)
    /\ effects_one_dvp_s["admitted"]
    /\ effects_one_dvp_s["height"] < effects_one_dvp_D
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_7760]["decision"] = 0
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_7760] =
                  [
                    [
                      effects_one_dvp_s["trades"][effects_one_dvp_t_7760] EXCEPT
                        !["decision"] = 1
                    ] EXCEPT
                      !["intent"] = TRUE
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_abort(effects_one_dvp_t_9142) ==
  effects_one_dvp_HOST \in effects_one_dvp_s["up"]
    /\ 2 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_authorized(effects_one_dvp_s, effects_one_dvp_t_9142)
    /\ effects_one_dvp_s["height"] >= effects_one_dvp_D
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_9142]["decision"] < 2
    /\ effects_one_dvp_s'
      := [
        [
          effects_one_dvp_s EXCEPT
            !["included"] =
              effects_one_dvp_s["included"]
                \union {(effects_one_dvp_fact(effects_one_dvp_t_9142, 4))}
        ] EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_9142] =
                  [
                    [
                      [
                        [
                          effects_one_dvp_s["trades"][effects_one_dvp_t_9142] EXCEPT
                            !["decision"] = 3
                        ] EXCEPT
                          !["oldTerminal"] =
                            IF effects_one_dvp_s["trades"][
                              effects_one_dvp_t_9142
                            ][
                              "oldTerminal"
                            ]
                              = 0
                            THEN 3
                            ELSE effects_one_dvp_s["trades"][
                              effects_one_dvp_t_9142
                            ][
                              "oldTerminal"
                            ]
                      ] EXCEPT
                        !["knownA"] =
                          IF effects_one_dvp_HOST = 0
                            \/ effects_one_dvp_HOST = 3
                          THEN 3
                          ELSE effects_one_dvp_s["trades"][
                            effects_one_dvp_t_9142
                          ][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF effects_one_dvp_HOST = 1 \/ effects_one_dvp_HOST = 3
                        THEN 3
                        ELSE effects_one_dvp_s["trades"][effects_one_dvp_t_9142][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_applyA(effects_one_dvp_t_9338) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_one_dvp_z == effects_one_dvp_s["trades"][effects_one_dvp_t_9338]
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_one_dvp_a == effects_one_dvp_debitA(effects_one_dvp_s)
  IN
  0 \in effects_one_dvp_s["up"]
    /\ (effects_one_dvp_HOST /= 3 \/ 3 \in effects_one_dvp_s["up"])
    /\ 2 \in effects_one_dvp_s["up"]
    /\ ~(0 \in effects_one_dvp_s["frozen"])
    /\ (effects_one_dvp_z)["knownA"] = 2
    /\ (effects_one_dvp_z)["holdA"] = 1
    /\ effects_one_dvp_s'
      := [
        [
          [
            [
              (effects_one_dvp_a) EXCEPT
                !["economicReceipts"] =
                  (effects_one_dvp_a)["economicReceipts"]
                    \union {(effects_one_dvp_economicOutput(effects_one_dvp_t_9338,
                    0, 0))}
            ] EXCEPT
              !["included"] =
                effects_one_dvp_s["included"]
                  \union {(effects_one_dvp_fact(effects_one_dvp_t_9338, 5))}
          ] EXCEPT
            !["trades"] =
              [
                effects_one_dvp_s["trades"] EXCEPT
                  ![effects_one_dvp_t_9338] =
                    [
                      [ (effects_one_dvp_z) EXCEPT !["holdA"] = 2 ] EXCEPT
                        !["effectsA"] = (effects_one_dvp_z)["effectsA"] + 1
                    ]
              ]
        ] EXCEPT
          !["receivedA"] =
            LET (*
              @type: (() => (Int -> Int));
            *)
            __quint_var2 == effects_one_dvp_s["receivedA"]
            IN
            [
              (__quint_var2) EXCEPT
                ![effects_one_dvp_t_9338] =
                  LET (*
                    @type: ((Int) => Int);
                  *)
                  __QUINT_LAMBDA2(effects_one_dvp_q_9326) ==
                    effects_one_dvp_q_9326 + 2
                  IN
                  __QUINT_LAMBDA2((__quint_var2)[effects_one_dvp_t_9338])
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_applyB(effects_one_dvp_t_9454) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_one_dvp_z == effects_one_dvp_s["trades"][effects_one_dvp_t_9454]
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_one_dvp_b == effects_one_dvp_debitB(effects_one_dvp_s)
  IN
  1 \in effects_one_dvp_s["up"]
    /\ (effects_one_dvp_HOST /= 3 \/ 3 \in effects_one_dvp_s["up"])
    /\ 2 \in effects_one_dvp_s["up"]
    /\ ~(1 \in effects_one_dvp_s["frozen"])
    /\ (effects_one_dvp_z)["knownB"] = 2
    /\ ((effects_one_dvp_z)["holdB"] = 1
      \/ (effects_one_dvp_MUTANT = 3 /\ (effects_one_dvp_z)["holdB"] = 2))
    /\ effects_one_dvp_s'
      := [
        [
          [
            [
              (effects_one_dvp_b) EXCEPT
                !["economicReceipts"] =
                  (effects_one_dvp_b)["economicReceipts"]
                    \union {(effects_one_dvp_economicOutput(effects_one_dvp_t_9454,
                    1, 0))}
            ] EXCEPT
              !["included"] =
                effects_one_dvp_s["included"]
                  \union {(effects_one_dvp_fact(effects_one_dvp_t_9454, 6))}
          ] EXCEPT
            !["trades"] =
              [
                effects_one_dvp_s["trades"] EXCEPT
                  ![effects_one_dvp_t_9454] =
                    [
                      [ (effects_one_dvp_z) EXCEPT !["holdB"] = 2 ] EXCEPT
                        !["effectsB"] = (effects_one_dvp_z)["effectsB"] + 1
                    ]
              ]
        ] EXCEPT
          !["receivedB"] =
            LET (*
              @type: (() => (Int -> Int));
            *)
            __quint_var3 == effects_one_dvp_s["receivedB"]
            IN
            [
              (__quint_var3) EXCEPT
                ![effects_one_dvp_t_9454] =
                  LET (*
                    @type: ((Int) => Int);
                  *)
                  __QUINT_LAMBDA3(effects_one_dvp_q_9442) ==
                    effects_one_dvp_q_9442 + 3
                  IN
                  __QUINT_LAMBDA3((__quint_var3)[effects_one_dvp_t_9454])
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_refund(effects_one_dvp_t_9642, effects_one_dvp_leg_9642) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_one_dvp_z == effects_one_dvp_s["trades"][effects_one_dvp_t_9642]
  IN
  effects_one_dvp_leg_9642 \in effects_one_dvp_s["up"]
    /\ (effects_one_dvp_HOST /= 3 \/ 3 \in effects_one_dvp_s["up"])
    /\ 2 \in effects_one_dvp_s["up"]
    /\ ~(effects_one_dvp_leg_9642 \in effects_one_dvp_s["frozen"])
    /\ (IF effects_one_dvp_leg_9642 = 0
    THEN (effects_one_dvp_z)["holdA"] = 1 /\ (effects_one_dvp_z)["knownA"] = 3
    ELSE (effects_one_dvp_z)["holdB"] = 1 /\ (effects_one_dvp_z)["knownB"] = 3)
    /\ effects_one_dvp_s'
      := [
        [
          [
            [
              [
                [
                  effects_one_dvp_s EXCEPT
                    !["economicReceipts"] =
                      effects_one_dvp_s["economicReceipts"]
                        \union {(effects_one_dvp_economicOutput(effects_one_dvp_t_9642,
                        effects_one_dvp_leg_9642, 1))}
                ] EXCEPT
                  !["trades"] =
                    [
                      effects_one_dvp_s["trades"] EXCEPT
                        ![effects_one_dvp_t_9642] =
                          [
                            [
                              [
                                [
                                  (effects_one_dvp_z) EXCEPT
                                    !["holdA"] =
                                      IF effects_one_dvp_leg_9642 = 0
                                      THEN 3
                                      ELSE (effects_one_dvp_z)["holdA"]
                                ] EXCEPT
                                  !["holdB"] =
                                    IF effects_one_dvp_leg_9642 = 1
                                    THEN 3
                                    ELSE (effects_one_dvp_z)["holdB"]
                              ] EXCEPT
                                !["refundsA"] =
                                  (effects_one_dvp_z)["refundsA"]
                                    + (IF effects_one_dvp_leg_9642 = 0
                                    THEN 1
                                    ELSE 0)
                            ] EXCEPT
                              !["refundsB"] =
                                (effects_one_dvp_z)["refundsB"]
                                  + (IF effects_one_dvp_leg_9642 = 1
                                  THEN 1
                                  ELSE 0)
                          ]
                    ]
              ] EXCEPT
                !["ownerA"] =
                  effects_one_dvp_s["ownerA"]
                    + (IF effects_one_dvp_ESCROW /\ effects_one_dvp_leg_9642 = 0
                    THEN 2
                    ELSE 0)
            ] EXCEPT
              !["vaultA"] =
                effects_one_dvp_s["vaultA"]
                  - (IF effects_one_dvp_ESCROW /\ effects_one_dvp_leg_9642 = 0
                  THEN 2
                  ELSE 0)
          ] EXCEPT
            !["ownerB"] =
              effects_one_dvp_s["ownerB"]
                + (IF effects_one_dvp_ESCROW /\ effects_one_dvp_leg_9642 = 1
                THEN 3
                ELSE 0)
        ] EXCEPT
          !["vaultB"] =
            effects_one_dvp_s["vaultB"]
              - (IF effects_one_dvp_ESCROW /\ effects_one_dvp_leg_9642 = 1
              THEN 3
              ELSE 0)
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_reconcile(effects_one_dvp_t_10021) ==
  3 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_10021]["appliedEvidenceA"]
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_10021]["appliedEvidenceB"]
    /\ effects_one_dvp_s'
      := [
        [
          effects_one_dvp_s EXCEPT
            !["financialRecords"] =
              effects_one_dvp_s["financialRecords"]
                \union {(effects_one_dvp_bookingOutput(effects_one_dvp_t_10021, 2))}
        ] EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_10021] =
                  [
                    [
                      [
                        effects_one_dvp_s["trades"][effects_one_dvp_t_10021] EXCEPT
                          !["report"] = 2
                      ] EXCEPT
                        !["stale"] = FALSE
                    ] EXCEPT
                      !["booked"] =
                        IF effects_one_dvp_s["trades"][effects_one_dvp_t_10021][
                          "booked"
                        ]
                          = 0
                        THEN 1
                        ELSE effects_one_dvp_s["trades"][
                          effects_one_dvp_t_10021
                        ][
                          "booked"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_finalize(effects_one_dvp_t_8078, effects_one_dvp_p_8078) ==
  effects_one_dvp_fact(effects_one_dvp_t_8078, effects_one_dvp_p_8078)
      \in effects_one_dvp_s["included"]
    /\ (IF effects_one_dvp_HOST = 3
    THEN 3
    ELSE IF effects_one_dvp_p_8078 = 2 \/ effects_one_dvp_p_8078 = 6
    THEN 1
    ELSE IF effects_one_dvp_p_8078 = 3 \/ effects_one_dvp_p_8078 = 4
    THEN effects_one_dvp_HOST
    ELSE 0)
      \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["finalized"] =
            effects_one_dvp_s["finalized"]
              \union {(effects_one_dvp_fact(effects_one_dvp_t_8078, effects_one_dvp_p_8078))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_capture(effects_one_dvp_t_8119, effects_one_dvp_p_8119) ==
  3 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_fact(effects_one_dvp_t_8119, effects_one_dvp_p_8119)
      \in effects_one_dvp_s["finalized"]
    /\ ~(effects_one_dvp_fact(effects_one_dvp_t_8119, effects_one_dvp_p_8119)
      \in effects_one_dvp_s["pruned"])
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["captured"] =
            effects_one_dvp_s["captured"]
              \union {(effects_one_dvp_fact(effects_one_dvp_t_8119, effects_one_dvp_p_8119))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_prove(effects_one_dvp_t_8162, effects_one_dvp_p_8162) ==
  3 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_fact(effects_one_dvp_t_8162, effects_one_dvp_p_8162)
      \in effects_one_dvp_s["captured"]
    /\ effects_one_dvp_s'
      := [
        [
          effects_one_dvp_s EXCEPT
            !["proofs"] =
              effects_one_dvp_s["proofs"]
                \union {(effects_one_dvp_fact(effects_one_dvp_t_8162, effects_one_dvp_p_8162))}
        ] EXCEPT
          !["network"] =
            effects_one_dvp_s["network"]
              \union {(effects_one_dvp_fact(effects_one_dvp_t_8162, effects_one_dvp_p_8162))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_deliver(effects_one_dvp_t_8345, effects_one_dvp_p_8345) ==
  4 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_fact(effects_one_dvp_t_8345, effects_one_dvp_p_8345)
      \in effects_one_dvp_s["network"]
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["received"] =
            effects_one_dvp_s["received"]
              \union {(effects_one_dvp_fact(effects_one_dvp_t_8345, effects_one_dvp_p_8345))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_resend(effects_one_dvp_t_8312, effects_one_dvp_p_8312) ==
  4 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_fact(effects_one_dvp_t_8312, effects_one_dvp_p_8312)
      \in effects_one_dvp_s["proofs"]
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["network"] =
            effects_one_dvp_s["network"]
              \union {(effects_one_dvp_fact(effects_one_dvp_t_8312, effects_one_dvp_p_8312))}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_proveUnadmitted(effects_one_dvp_t_8209, effects_one_dvp_p_8209) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_one_dvp_f ==
    [
      (effects_one_dvp_fact(effects_one_dvp_t_8209, effects_one_dvp_p_8209)) EXCEPT
        !["program"] = 0
    ]
  IN
  3 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_fact(effects_one_dvp_t_8209, effects_one_dvp_p_8209)
      \in effects_one_dvp_s["captured"]
    /\ effects_one_dvp_s'
      := [
        [
          effects_one_dvp_s EXCEPT
            !["proofs"] =
              effects_one_dvp_s["proofs"] \union {(effects_one_dvp_f)}
        ] EXCEPT
          !["network"] =
            effects_one_dvp_s["network"] \union {(effects_one_dvp_f)}
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_deliverUnadmitted(effects_one_dvp_t_8251, effects_one_dvp_p_8251) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_one_dvp_f ==
    [
      (effects_one_dvp_fact(effects_one_dvp_t_8251, effects_one_dvp_p_8251)) EXCEPT
        !["program"] = 0
    ]
  IN
  4 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_f \in effects_one_dvp_s["network"]
    /\ effects_one_dvp_f \in effects_one_dvp_s["proofs"]
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["received"] =
            effects_one_dvp_s["received"] \union {(effects_one_dvp_f)}
      ]

(*
  @type: ((Int, Int, Int) => Bool);
*)
effects_one_dvp_inject(effects_one_dvp_t_8504, effects_one_dvp_p_8504, effects_one_dvp_binding_8504) ==
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_one_dvp_f ==
    effects_one_dvp_fact(effects_one_dvp_t_8504, effects_one_dvp_p_8504)
  IN
  LET (*
    @type: (() => { checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int });
  *)
  effects_one_dvp_bad ==
    IF effects_one_dvp_binding_8504 = 0
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] =
          [
            (effects_one_dvp_f)["d"] EXCEPT
              !["trade"] = 3 - effects_one_dvp_t_8504
          ]
    ]
    ELSE IF effects_one_dvp_binding_8504 = 1
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] = [ (effects_one_dvp_f)["d"] EXCEPT !["nonce"] = 99 ]
    ]
    ELSE IF effects_one_dvp_binding_8504 = 2
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] = [ (effects_one_dvp_f)["d"] EXCEPT !["sellerB"] = 99 ]
    ]
    ELSE IF effects_one_dvp_binding_8504 = 3
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] = [ (effects_one_dvp_f)["d"] EXCEPT !["cash"] = 4 ]
    ]
    ELSE IF effects_one_dvp_binding_8504 = 4
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] = [ (effects_one_dvp_f)["d"] EXCEPT !["genesisB"] = 999 ]
    ]
    ELSE IF effects_one_dvp_binding_8504 = 5
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] = [ (effects_one_dvp_f)["d"] EXCEPT !["decisionDomain"] = 99 ]
    ]
    ELSE IF effects_one_dvp_binding_8504 = 6
    THEN [ (effects_one_dvp_f) EXCEPT !["phase"] = 6 ]
    ELSE IF effects_one_dvp_binding_8504 = 7
    THEN [ (effects_one_dvp_f) EXCEPT !["checkpoint"] = 99 ]
    ELSE IF effects_one_dvp_binding_8504 = 8
    THEN [ (effects_one_dvp_f) EXCEPT !["program"] = 99 ]
    ELSE IF effects_one_dvp_binding_8504 = 9
    THEN [
      (effects_one_dvp_f) EXCEPT
        !["d"] =
          [
            [ (effects_one_dvp_f)["d"] EXCEPT !["assetB"] = 99 ] EXCEPT
              !["holdB"] = 99
          ]
    ]
    ELSE [ (effects_one_dvp_f) EXCEPT !["root"] = 999 ]
  IN
  effects_one_dvp_s'
    := [
      [
        effects_one_dvp_s EXCEPT
          !["received"] =
            effects_one_dvp_s["received"] \union {(effects_one_dvp_bad)}
      ] EXCEPT
        !["rejects"] =
          effects_one_dvp_s["rejects"] \union {effects_one_dvp_binding_8504}
    ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_spend(effects_one_dvp_leg_9833) ==
  (IF effects_one_dvp_leg_9833 = 0
    THEN effects_one_dvp_s["ownerA"]
      - (IF effects_one_dvp_ESCROW
      THEN 0
      ELSE effects_one_dvp_reservedA(effects_one_dvp_s))
      >= 1
    ELSE effects_one_dvp_s["ownerB"]
      - (IF effects_one_dvp_ESCROW
      THEN 0
      ELSE effects_one_dvp_reservedB(effects_one_dvp_s))
      >= 1)
    /\ effects_one_dvp_s'
      := [
        [
          [
            [
              effects_one_dvp_s EXCEPT
                !["ownerA"] =
                  effects_one_dvp_s["ownerA"]
                    - (IF effects_one_dvp_leg_9833 = 0 THEN 1 ELSE 0)
            ] EXCEPT
              !["ownerB"] =
                effects_one_dvp_s["ownerB"]
                  - (IF effects_one_dvp_leg_9833 = 1 THEN 1 ELSE 0)
          ] EXCEPT
            !["spentA"] =
              effects_one_dvp_s["spentA"]
                + (IF effects_one_dvp_leg_9833 = 0 THEN 1 ELSE 0)
        ] EXCEPT
          !["spentB"] =
            effects_one_dvp_s["spentB"]
              + (IF effects_one_dvp_leg_9833 = 1 THEN 1 ELSE 0)
      ]

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
CandidateFacts ==
  {
    (domainFact(v_286[1], v_286[2], v_286[3])):
      v_286 \in effects_one_dvp_Trades \X (0 .. 6) \X (0 .. 10)
  }

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_openA(effects_one_dvp_t_7701) ==
  effects_one_dvp_canOpen(effects_one_dvp_s, effects_one_dvp_t_7701)
    /\ effects_one_dvp_s'
      := effects_one_dvp_reserveA(effects_one_dvp_s, effects_one_dvp_t_7701)

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
effects_one_dvp_has(effects_one_dvp_x_7086, effects_one_dvp_t_7086, effects_one_dvp_p_7086) ==
  \E effects_one_dvp_f_7084 \in effects_one_dvp_x_7086["received"]:
    effects_one_dvp_authFact(effects_one_dvp_x_7086, effects_one_dvp_f_7084, effects_one_dvp_t_7086,
    effects_one_dvp_p_7086)

(*
  @type: (() => Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }));
*)
FactSpace ==
  (AuthenticFacts \union CandidateFacts)
    \union { ([ f_298 EXCEPT !["program"] = 0 ]): f_298 \in AuthenticFacts }

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_prepareB(effects_one_dvp_t_7925) ==
  effects_one_dvp_authorized(effects_one_dvp_s, effects_one_dvp_t_7925)
    /\ effects_one_dvp_s["admitted"]
    /\ <<effects_one_dvp_t_7925, 1>> \in effects_one_dvp_s["eligible"]
    /\ ~(1 \in effects_one_dvp_s["frozen"])
    /\ 1 \in effects_one_dvp_s["up"]
    /\ (effects_one_dvp_HOST /= 3 \/ 3 \in effects_one_dvp_s["up"])
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_7925]["knownB"] = 0
    /\ effects_one_dvp_s["trades"][effects_one_dvp_t_7925]["holdB"] = 0
    /\ (~effects_one_dvp_OPEN_REQUIRED
      \/ effects_one_dvp_has(effects_one_dvp_s, effects_one_dvp_t_7925, 0))
    /\ (IF effects_one_dvp_ESCROW
    THEN effects_one_dvp_s["ownerB"] >= 3
    ELSE effects_one_dvp_s["ownerB"]
      - effects_one_dvp_reservedB(effects_one_dvp_s)
      >= 3)
    /\ effects_one_dvp_s'
      := [
        [
          [
            [
              effects_one_dvp_s EXCEPT
                !["trades"] =
                  [
                    effects_one_dvp_s["trades"] EXCEPT
                      ![effects_one_dvp_t_7925] =
                        [
                          [
                            [
                              effects_one_dvp_s["trades"][
                                effects_one_dvp_t_7925
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
                IF effects_one_dvp_ESCROW
                THEN effects_one_dvp_s["ownerB"] - 3
                ELSE effects_one_dvp_s["ownerB"]
          ] EXCEPT
            !["vaultB"] =
              IF effects_one_dvp_ESCROW
              THEN effects_one_dvp_s["vaultB"] + 3
              ELSE effects_one_dvp_s["vaultB"]
        ] EXCEPT
          !["included"] =
            effects_one_dvp_s["included"]
              \union {(effects_one_dvp_fact(effects_one_dvp_t_7925, 2))}
      ]

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int, Int) => Bool);
*)
effects_one_dvp_preparationAtConsumer(effects_one_dvp_x_7140, effects_one_dvp_t_7140,
effects_one_dvp_p_7140) ==
  IF effects_one_dvp_MUTANT = 10
  THEN \E effects_one_dvp_f_7133 \in effects_one_dvp_x_7140["received"]:
    effects_one_dvp_f_7133 \in effects_one_dvp_x_7140["proofs"]
      /\ effects_one_dvp_f_7133["d"]
        = effects_one_dvp_desc(effects_one_dvp_t_7140)
      /\ effects_one_dvp_f_7133["phase"] = effects_one_dvp_p_7140
      /\ effects_one_dvp_f_7133["checkpoint"] = 0
      /\ effects_one_dvp_f_7133["root"]
        = (effects_one_dvp_fact(effects_one_dvp_t_7140, effects_one_dvp_p_7140))[
          "root"
        ]
  ELSE effects_one_dvp_has(effects_one_dvp_x_7140, effects_one_dvp_t_7140, effects_one_dvp_p_7140)

(*
  @type: ((Int, Int, Int) => Bool);
*)
effects_one_dvp_learn(effects_one_dvp_t_9232, effects_one_dvp_outcome_9232, effects_one_dvp_leg_9232) ==
  effects_one_dvp_leg_9232 \in effects_one_dvp_s["up"]
    /\ (effects_one_dvp_HOST /= 3 \/ 3 \in effects_one_dvp_s["up"])
    /\ effects_one_dvp_has(effects_one_dvp_s, effects_one_dvp_t_9232, (IF effects_one_dvp_outcome_9232
      = 2
    THEN 3
    ELSE 4))
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_9232] =
                  [
                    [
                      effects_one_dvp_s["trades"][effects_one_dvp_t_9232] EXCEPT
                        !["knownA"] =
                          IF effects_one_dvp_leg_9232 = 0
                          THEN effects_one_dvp_outcome_9232
                          ELSE effects_one_dvp_s["trades"][
                            effects_one_dvp_t_9232
                          ][
                            "knownA"
                          ]
                    ] EXCEPT
                      !["knownB"] =
                        IF effects_one_dvp_leg_9232 = 1
                          /\ (effects_one_dvp_MUTANT /= 9
                            \/ effects_one_dvp_s["trades"][
                              effects_one_dvp_t_9232
                            ][
                              "holdB"
                            ]
                              /= 0)
                        THEN effects_one_dvp_outcome_9232
                        ELSE effects_one_dvp_s["trades"][effects_one_dvp_t_9232][
                          "knownB"
                        ]
                  ]
            ]
      ]

(*
  @type: ((Int, Int) => Bool);
*)
effects_one_dvp_observe(effects_one_dvp_t_9945, effects_one_dvp_leg_9945) ==
  3 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_has(effects_one_dvp_s, effects_one_dvp_t_9945, (IF effects_one_dvp_leg_9945
      = 0
    THEN 5
    ELSE 6))
    /\ effects_one_dvp_s'
      := [
        effects_one_dvp_s EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_9945] =
                  [
                    [
                      effects_one_dvp_s["trades"][effects_one_dvp_t_9945] EXCEPT
                        !["appliedEvidenceA"] =
                          effects_one_dvp_s["trades"][effects_one_dvp_t_9945][
                              "appliedEvidenceA"
                            ]
                            \/ effects_one_dvp_leg_9945 = 0
                    ] EXCEPT
                      !["appliedEvidenceB"] =
                        effects_one_dvp_s["trades"][effects_one_dvp_t_9945][
                            "appliedEvidenceB"
                          ]
                          \/ effects_one_dvp_leg_9945 = 1
                  ]
            ]
      ]

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_recordAbort(effects_one_dvp_t_10369) ==
  3 \in effects_one_dvp_s["up"]
    /\ effects_one_dvp_has(effects_one_dvp_s, effects_one_dvp_t_10369, 4)
    /\ effects_one_dvp_hasAbortRecord(effects_one_dvp_s, effects_one_dvp_t_10369,
    0)
    /\ effects_one_dvp_hasAbortRecord(effects_one_dvp_s, effects_one_dvp_t_10369,
    1)
    /\ effects_one_dvp_s'
      := [
        [
          effects_one_dvp_s EXCEPT
            !["financialRecords"] =
              effects_one_dvp_s["financialRecords"]
                \union {(effects_one_dvp_bookingOutput(effects_one_dvp_t_10369, 3))}
        ] EXCEPT
          !["trades"] =
            [
              effects_one_dvp_s["trades"] EXCEPT
                ![effects_one_dvp_t_10369] =
                  [
                    [
                      [
                        effects_one_dvp_s["trades"][effects_one_dvp_t_10369] EXCEPT
                          !["report"] = 3
                      ] EXCEPT
                        !["stale"] = FALSE
                    ] EXCEPT
                      !["booked"] =
                        IF effects_one_dvp_s["trades"][effects_one_dvp_t_10369][
                          "booked"
                        ]
                          = 0
                        THEN 1
                        ELSE effects_one_dvp_s["trades"][
                          effects_one_dvp_t_10369
                        ][
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
    ([trades |-> v_603[1],
      signed |-> v_603[2],
      height |-> v_603[3],
      ownerA |-> v_603[4],
      ownerB |-> v_603[5],
      vaultA |-> v_603[6],
      vaultB |-> v_603[7],
      spentA |-> v_603[8],
      spentB |-> v_603[9],
      receivedA |-> v_603[10],
      receivedB |-> v_603[11],
      economicReceipts |-> v_603[12],
      financialRecords |-> v_603[13],
      included |-> v_603[14],
      finalized |-> v_603[15],
      captured |-> v_603[16],
      proofs |-> v_603[17],
      network |-> v_603[18],
      received |-> v_603[19],
      abortRecords |-> v_603[20],
      pruned |-> v_603[21],
      up |-> v_603[22],
      epoch |-> v_603[23],
      admitted |-> v_603[24],
      historical |-> v_603[25],
      eligible |-> v_603[26],
      frozen |-> v_603[27],
      note |-> v_603[28],
      rejects |-> v_603[29],
      transportCompromised |-> v_603[30],
      custody |-> v_603[31],
      upgrade |-> v_603[32],
      validator |-> v_603[33],
      decrypt |-> v_603[34]]):
      v_603 \in
        [(effects_one_dvp_Trades) -> (TradeSpace)]
          \X (SUBSET ({
              (effects_one_dvp_desc(t_393)):
                t_393 \in effects_one_dvp_Trades
            }
            \X { 0, 1 }))
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X Int
          \X [(effects_one_dvp_Trades) -> Int]
          \X [(effects_one_dvp_Trades) -> Int]
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
          \X (SUBSET (effects_one_dvp_Trades \X { 0, 1 }))
          \X (SUBSET ({ 0, 1 }))
          \X (SUBSET effects_one_dvp_Trades)
          \X (SUBSET (0 .. 10))
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
          \X BOOLEAN
  }

(*
  @type: (({ abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int }, Int) => Bool);
*)
effects_one_dvp_canCommit(effects_one_dvp_x_8666, effects_one_dvp_t_8666) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_one_dvp_z == effects_one_dvp_x_8666["trades"][effects_one_dvp_t_8666]
  IN
  effects_one_dvp_HOST \in effects_one_dvp_x_8666["up"]
    /\ 2 \in effects_one_dvp_x_8666["up"]
    /\ (effects_one_dvp_z)["decision"] = 1
    /\ effects_one_dvp_x_8666["height"] < effects_one_dvp_D
    /\ (IF effects_one_dvp_HOST = 0 \/ effects_one_dvp_HOST = 3
    THEN (effects_one_dvp_z)["holdA"] = 1
    ELSE IF effects_one_dvp_HOST = 1
    THEN (effects_one_dvp_z)["holdB"] = 1
    ELSE TRUE)
    /\ (IF effects_one_dvp_HOST = 3
    THEN ~(0 \in effects_one_dvp_x_8666["frozen"])
      /\ ~(1 \in effects_one_dvp_x_8666["frozen"])
    ELSE IF effects_one_dvp_HOST = 0
    THEN ~(0 \in effects_one_dvp_x_8666["frozen"])
    ELSE IF effects_one_dvp_HOST = 1
    THEN ~(1 \in effects_one_dvp_x_8666["frozen"])
    ELSE TRUE)
    /\ (IF effects_one_dvp_MUTANT = 2
    THEN \E effects_one_dvp_f_8616 \in effects_one_dvp_x_8666["received"]:
      effects_one_dvp_f_8616["phase"] = 2
        /\ effects_one_dvp_f_8616 \in effects_one_dvp_x_8666["proofs"]
    ELSE IF effects_one_dvp_MUTANT = 6
    THEN \E effects_one_dvp_f_8630 \in effects_one_dvp_x_8666["received"]:
      effects_one_dvp_f_8630["phase"] = 2
    ELSE IF effects_one_dvp_HOST = 1
    THEN TRUE
    ELSE IF effects_one_dvp_HOST = 3
    THEN (effects_one_dvp_z)["holdB"] = 1
    ELSE effects_one_dvp_preparationAtConsumer(effects_one_dvp_x_8666, effects_one_dvp_t_8666,
    2))
    /\ ((effects_one_dvp_HOST = 0 \/ effects_one_dvp_HOST = 3)
      \/ effects_one_dvp_preparationAtConsumer(effects_one_dvp_x_8666, effects_one_dvp_t_8666,
      1))

(*
  @type: (() => Bool);
*)
FullTypeOK == effects_one_dvp_s \in StateSpace

(*
  @type: ((Int) => Bool);
*)
effects_one_dvp_commit(effects_one_dvp_t_9025) ==
  LET (*
    @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
  *)
  effects_one_dvp_z == effects_one_dvp_s["trades"][effects_one_dvp_t_9025]
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_one_dvp_a ==
    IF (effects_one_dvp_HOST = 0 \/ effects_one_dvp_HOST = 3)
      /\ effects_one_dvp_MUTANT /= 5
    THEN effects_one_dvp_debitA(effects_one_dvp_s)
    ELSE effects_one_dvp_s
  IN
  LET (*
    @type: (() => { abortRecords: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, disposition: Int, genesis: Int, leg: Int, program: Int }), admitted: Bool, captured: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), custody: Bool, decrypt: Bool, economicReceipts: Set({ account: Int, asset: Int, chain: Int, genesis: Int, kind: Int, leg: Int, quantity: Int, trade: Int }), eligible: Set(<<Int, Int>>), epoch: Int, finalized: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), financialRecords: Set({ d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, outcome: Int }), frozen: Set(Int), height: Int, historical: Set(Int), included: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), network: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), note: Set(Int), ownerA: Int, ownerB: Int, proofs: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), pruned: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), received: Set({ checkpoint: Int, d: { assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, phase: Int, program: Int, root: Int }), receivedA: (Int -> Int), receivedB: (Int -> Int), rejects: Set(Int), signed: Set(<<{ assetA: Int, assetB: Int, buyerA: Int, buyerB: Int, cash: Int, chainA: Int, chainB: Int, commitment: Int, deadline: Int, decisionContract: Int, decisionDomain: Int, epoch: Int, genesisA: Int, genesisB: Int, holdA: Int, holdB: Int, nonce: Int, protocol: Int, security: Int, sellerA: Int, sellerB: Int, trade: Int }, Int>>), spentA: Int, spentB: Int, trades: (Int -> { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool }), transportCompromised: Bool, up: Set(Int), upgrade: Bool, validator: Bool, vaultA: Int, vaultB: Int });
  *)
  effects_one_dvp_b ==
    IF effects_one_dvp_HOST = 1 \/ effects_one_dvp_HOST = 3
    THEN effects_one_dvp_debitB((effects_one_dvp_a))
    ELSE effects_one_dvp_a
  IN
  effects_one_dvp_canCommit(effects_one_dvp_s, effects_one_dvp_t_9025)
    /\ effects_one_dvp_s'
      := [
        [
          [
            [
              [
                (effects_one_dvp_b) EXCEPT
                  !["economicReceipts"] =
                    ((effects_one_dvp_b)["economicReceipts"]
                      \union (IF (effects_one_dvp_HOST = 0
                          \/ effects_one_dvp_HOST = 3)
                        /\ effects_one_dvp_MUTANT /= 5
                      THEN {(effects_one_dvp_economicOutput(effects_one_dvp_t_9025,
                      0, 0))}
                      ELSE {}))
                      \union (IF effects_one_dvp_HOST = 1
                        \/ effects_one_dvp_HOST = 3
                      THEN {(effects_one_dvp_economicOutput(effects_one_dvp_t_9025,
                      1, 0))}
                      ELSE {})
              ] EXCEPT
                !["included"] =
                  (((effects_one_dvp_b)["included"]
                    \union {(effects_one_dvp_fact(effects_one_dvp_t_9025, 3))})
                    \union (IF (effects_one_dvp_HOST = 0
                        \/ effects_one_dvp_HOST = 3)
                      /\ effects_one_dvp_MUTANT /= 5
                    THEN {(effects_one_dvp_fact(effects_one_dvp_t_9025, 5))}
                    ELSE {}))
                    \union (IF effects_one_dvp_HOST = 1
                      \/ effects_one_dvp_HOST = 3
                    THEN {(effects_one_dvp_fact(effects_one_dvp_t_9025, 6))}
                    ELSE {})
            ] EXCEPT
              !["trades"] =
                [
                  (effects_one_dvp_b)["trades"] EXCEPT
                    ![effects_one_dvp_t_9025] =
                      [
                        [
                          [
                            [
                              [
                                [
                                  [
                                    [
                                      (effects_one_dvp_z) EXCEPT
                                        !["decision"] = 2
                                    ] EXCEPT
                                      !["oldTerminal"] =
                                        IF (effects_one_dvp_z)["oldTerminal"]
                                          = 0
                                        THEN 2
                                        ELSE (effects_one_dvp_z)["oldTerminal"]
                                  ] EXCEPT
                                    !["knownA"] =
                                      IF effects_one_dvp_HOST = 0
                                        \/ effects_one_dvp_HOST = 3
                                      THEN 2
                                      ELSE (effects_one_dvp_z)["knownA"]
                                ] EXCEPT
                                  !["knownB"] =
                                    IF effects_one_dvp_HOST = 1
                                      \/ effects_one_dvp_HOST = 3
                                    THEN 2
                                    ELSE (effects_one_dvp_z)["knownB"]
                              ] EXCEPT
                                !["holdA"] =
                                  IF (effects_one_dvp_HOST = 0
                                      \/ effects_one_dvp_HOST = 3)
                                    /\ effects_one_dvp_MUTANT /= 5
                                  THEN 2
                                  ELSE (effects_one_dvp_z)["holdA"]
                            ] EXCEPT
                              !["holdB"] =
                                IF effects_one_dvp_HOST = 1
                                  \/ effects_one_dvp_HOST = 3
                                THEN 2
                                ELSE (effects_one_dvp_z)["holdB"]
                          ] EXCEPT
                            !["effectsA"] =
                              (effects_one_dvp_z)["effectsA"]
                                + (IF (effects_one_dvp_HOST = 0
                                    \/ effects_one_dvp_HOST = 3)
                                  /\ effects_one_dvp_MUTANT /= 5
                                THEN 1
                                ELSE 0)
                        ] EXCEPT
                          !["effectsB"] =
                            (effects_one_dvp_z)["effectsB"]
                              + (IF effects_one_dvp_HOST = 1
                                \/ effects_one_dvp_HOST = 3
                              THEN 1
                              ELSE 0)
                      ]
                ]
          ] EXCEPT
            !["receivedA"] =
              IF (effects_one_dvp_HOST = 0 \/ effects_one_dvp_HOST = 3)
                /\ effects_one_dvp_MUTANT /= 5
              THEN LET (*
                @type: (() => (Int -> Int));
              *)
              __quint_var0 == (effects_one_dvp_b)["receivedA"]
              IN
              [
                (__quint_var0) EXCEPT
                  ![effects_one_dvp_t_9025] =
                    LET (*
                      @type: ((Int) => Int);
                    *)
                    __QUINT_LAMBDA0(effects_one_dvp_q_8985) ==
                      effects_one_dvp_q_8985 + 2
                    IN
                    __QUINT_LAMBDA0((__quint_var0)[effects_one_dvp_t_9025])
              ]
              ELSE (effects_one_dvp_b)["receivedA"]
        ] EXCEPT
          !["receivedB"] =
            IF effects_one_dvp_HOST = 1 \/ effects_one_dvp_HOST = 3
            THEN LET (*
              @type: (() => (Int -> Int));
            *)
            __quint_var1 == (effects_one_dvp_b)["receivedB"]
            IN
            [
              (__quint_var1) EXCEPT
                ![effects_one_dvp_t_9025] =
                  LET (*
                    @type: ((Int) => Int);
                  *)
                  __QUINT_LAMBDA1(effects_one_dvp_q_9007) ==
                    effects_one_dvp_q_9007 + 3
                  IN
                  __QUINT_LAMBDA1((__quint_var1)[effects_one_dvp_t_9025])
            ]
            ELSE (effects_one_dvp_b)["receivedB"]
      ]

(*
  @type: (() => Bool);
*)
effectI ==
  (FullTypeOK /\ localCommitAtomicity)
    /\ (\A t_732 \in effects_one_dvp_Trades:
      LET (*
        @type: (() => { appliedEvidenceA: Bool, appliedEvidenceB: Bool, booked: Int, decision: Int, effectsA: Int, effectsB: Int, holdA: Int, holdB: Int, intent: Bool, knownA: Int, knownB: Int, oldTerminal: Int, preparedA: Bool, preparedB: Bool, refundsA: Int, refundsB: Int, report: Int, stale: Bool });
      *)
      z == effects_one_dvp_s["trades"][t_732]
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
effects_one_dvp_tradeStep(effects_one_dvp_t_10628) ==
  effects_one_dvp_sign(effects_one_dvp_t_10628, 0)
    \/ effects_one_dvp_sign(effects_one_dvp_t_10628, 1)
    \/ effects_one_dvp_openA(effects_one_dvp_t_10628)
    \/ effects_one_dvp_prepareB(effects_one_dvp_t_10628)
    \/ effects_one_dvp_registerDecision(effects_one_dvp_t_10628)
    \/ effects_one_dvp_commit(effects_one_dvp_t_10628)
    \/ effects_one_dvp_abort(effects_one_dvp_t_10628)
    \/ effects_one_dvp_applyA(effects_one_dvp_t_10628)
    \/ effects_one_dvp_applyB(effects_one_dvp_t_10628)
    \/ effects_one_dvp_refund(effects_one_dvp_t_10628, 0)
    \/ effects_one_dvp_refund(effects_one_dvp_t_10628, 1)
    \/ effects_one_dvp_learn(effects_one_dvp_t_10628, 2, 0)
    \/ effects_one_dvp_learn(effects_one_dvp_t_10628, 2, 1)
    \/ effects_one_dvp_learn(effects_one_dvp_t_10628, 3, 0)
    \/ effects_one_dvp_learn(effects_one_dvp_t_10628, 3, 1)
    \/ effects_one_dvp_observe(effects_one_dvp_t_10628, 0)
    \/ effects_one_dvp_observe(effects_one_dvp_t_10628, 1)
    \/ effects_one_dvp_reconcile(effects_one_dvp_t_10628)
    \/ effects_one_dvp_captureAbortRecord(effects_one_dvp_t_10628, 0)
    \/ effects_one_dvp_captureAbortRecord(effects_one_dvp_t_10628, 1)
    \/ effects_one_dvp_recordAbort(effects_one_dvp_t_10628)
    \/ effects_one_dvp_unsafeRefund(effects_one_dvp_t_10628)
    \/ effects_one_dvp_forgetTerminal(effects_one_dvp_t_10628)
    \/ effects_one_dvp_receiveNote(effects_one_dvp_t_10628)
    \/ (\E effects_one_dvp_p \in 0 .. 6:
      effects_one_dvp_finalize(effects_one_dvp_t_10628, effects_one_dvp_p)
        \/ effects_one_dvp_capture(effects_one_dvp_t_10628, effects_one_dvp_p)
        \/ effects_one_dvp_prove(effects_one_dvp_t_10628, effects_one_dvp_p)
        \/ effects_one_dvp_deliver(effects_one_dvp_t_10628, effects_one_dvp_p)
        \/ effects_one_dvp_resend(effects_one_dvp_t_10628, effects_one_dvp_p))

(*
  @type: (() => Bool);
*)
effects_one_dvp_step ==
  (\E effects_one_dvp_t \in effects_one_dvp_Trades:
      effects_one_dvp_tradeStep(effects_one_dvp_t))
    \/ effects_one_dvp_tick
    \/ effects_one_dvp_idle

(*
  @type: (() => Bool);
*)
q_inv == effectI

(*
  @type: (() => Bool);
*)
effects_one_dvp_adversarialStep ==
  effects_one_dvp_step
    \/ (\E effects_one_dvp_t \in effects_one_dvp_Trades:
      \E effects_one_dvp_p \in 0 .. 6:
        effects_one_dvp_proveUnadmitted(effects_one_dvp_t, effects_one_dvp_p)
          \/ effects_one_dvp_deliverUnadmitted(effects_one_dvp_t, effects_one_dvp_p))
    \/ (\E effects_one_dvp_t \in effects_one_dvp_Trades:
      \E effects_one_dvp_p \in 0 .. 6:
        \E effects_one_dvp_f \in 0 .. 10:
          effects_one_dvp_inject(effects_one_dvp_t, effects_one_dvp_p, effects_one_dvp_f))
    \/ (\E effects_one_dvp_a \in 0 .. 4:
      effects_one_dvp_crash(effects_one_dvp_a)
        \/ effects_one_dvp_recover(effects_one_dvp_a))
    \/ (\E effects_one_dvp_l \in { 0, 1 }:
      effects_one_dvp_spend(effects_one_dvp_l)
        \/ effects_one_dvp_freeze(effects_one_dvp_l)
        \/ effects_one_dvp_unfreeze(effects_one_dvp_l))
    \/ effects_one_dvp_rotate
    \/ effects_one_dvp_exitMember
    \/ (\E effects_one_dvp_t \in effects_one_dvp_Trades:
      \E effects_one_dvp_l \in { 0, 1 }:
        effects_one_dvp_revokeLeg(effects_one_dvp_t, effects_one_dvp_l))
    \/ effects_one_dvp_compromiseTransport

(*
  @type: (() => Bool);
*)
q_step == effects_one_dvp_adversarialStep

================================================================================

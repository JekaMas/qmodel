// Source-world assertions shared across placements. These never authorize a
// consumer action or let an actor read the other ledger's live state.
module guarantee_oracles {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0) as types from "./dvp"

  // The oracle fixes the expected phase before looking up proof provenance.
  // Root numbering is the symbolic reference's phase/trade encoding.
  pure def receivedFact(x:types::State, d:types::Descriptor, phase:int):bool =
    x.historical.exists(program => {
      val expected = {d:d,phase:phase,checkpoint:0,program:program,root:200+phase*10+d.trade}
      x.received.contains(expected) and x.proofs.contains(expected)
    })

  pure def legOutcomeSound(x:types::State,d:types::Descriptor,leg:int):bool = {
    val z=x.trades.get(d.trade)
    val knowledge=if(leg==0) z.knownA else z.knownB
    val delivery=if(leg==0) z.effectsA else z.effectsB
    val release=if(leg==0) z.refundsA else z.refundsB
    val local=d.decisionDomain==leg or d.decisionDomain==3
    val terminal=knowledge==2 or knowledge==3
    and {
      knowledge==0 or (terminal and z.decision==knowledge),
      (terminal and not(local)) implies receivedFact(x,d,if(knowledge==2) 3 else 4),
      delivery>0 implies z.decision==2 and knowledge==2,
      release>0 implies z.decision==3 and knowledge==3,
      (z.decision==2 and local) implies delivery==1 and (if(leg==0) z.holdA else z.holdB)==2
    }
  }

  // This projection can be computed from accepted proof data. The source-world
  // checks below independently connect it to effects and durable booking rows.
  pure def hasBothApplications(x:types::State,d:types::Descriptor):bool =
    receivedFact(x,d,5) and receivedFact(x,d,6)

  pure def commitApplied(x:types::State,d:types::Descriptor):bool = {
    val z=x.trades.get(d.trade)
    and {z.decision==2,z.effectsA==1,z.effectsB==1,z.holdA==2,z.holdB==2,hasBothApplications(x,d)}
  }

  pure def commitRecordSound(x:types::State,d:types::Descriptor):bool = {
    val z=x.trades.get(d.trade)
    val commitRows=x.financialRecords.filter(r=>r.d.trade==d.trade and r.outcome==2)
    and {
      z.appliedEvidenceA implies receivedFact(x,d,5) and z.effectsA==1,
      z.appliedEvidenceB implies receivedFact(x,d,6) and z.effectsB==1,
      hasBothApplications(x,d) implies commitApplied(x,d),
      (z.report==2 or (z.booked==1 and z.decision==2) or commitRows!=Set()) implies
        commitApplied(x,d) and commitRows==Set({d:d,outcome:2})
    }
  }

  pure def legAbortSound(x:types::State,d:types::Descriptor,leg:int):bool = {
    val z=x.trades.get(d.trade)
    val prepared=if(leg==0) z.preparedA else z.preparedB
    val hold=if(leg==0) z.holdA else z.holdB
    val releases=if(leg==0) z.refundsA else z.refundsB
    val known=if(leg==0) z.knownA else z.knownB
    val disposition=if(prepared) 3 else 0
    and {
      known==3,hold==disposition,releases==(if(prepared) 1 else 0),
      x.abortRecords.exists(r=>r.d==d and r.leg==leg and
        r.genesis==(if(leg==0) d.genesisA else d.genesisB) and
        r.checkpoint==0 and x.historical.contains(r.program) and r.disposition==disposition)
    }
  }

  pure def evidenceBackedBooking(x:types::State,d:types::Descriptor):bool = {
    val z=x.trades.get(d.trade)
    val rows=x.financialRecords.filter(r=>r.d.trade==d.trade)
    and {
      z.booked==1,rows==Set({d:d,outcome:z.decision}),
      if(z.decision==2) z.report==2 and commitApplied(x,d)
      else z.decision==3 and z.report==3 and receivedFact(x,d,4) and
        legAbortSound(x,d,0) and legAbortSound(x,d,1)
    }
  }

  // Same endpoint used by the already checked L04 formula. Its implication
  // upgrades that formula on the identical graph without changing fairness.
  pure def l04IsEvidenced(x:types::State,d:types::Descriptor):bool = {
    val z=x.trades.get(d.trade)
    (z.booked==1 and z.report>=2) implies evidenceBackedBooking(x,d)
  }
  pure def tradeGuarantees(x:types::State,d:types::Descriptor):bool = and {
    legOutcomeSound(x,d,0),legOutcomeSound(x,d,1),commitRecordSound(x,d),l04IsEvidenced(x,d)
  }
}

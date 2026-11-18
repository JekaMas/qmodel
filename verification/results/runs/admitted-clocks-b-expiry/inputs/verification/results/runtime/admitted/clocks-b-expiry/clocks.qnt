module clock_products {
  import dvp(N=3,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=1).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  pure val mode = 3
  var pc:int
  pure val readyPC = 8
  action bootstrap = any {
    all {pc==0,sign(2,0),pc'=1,rates'=rates},
    all {pc==1,sign(2,1),pc'=2,rates'=rates},
    all {pc==2,openA(2),pc'=3,rates'=rates},
    all {pc==3,prepareB(2),pc'=4,rates'=rates},
    all {pc==4,finalize(2,2),pc'=5,rates'=rates},
    all {pc==5,capture(2,2),pc'=6,rates'=rates},
    all {pc==6,prove(2,2),pc'=7,rates'=rates},
    all {pc==7,deliver(2,2),pc'=8,rates'=rates},
  }
  // Independent availability permits same wall advance with different chain
  // rates. Mining A still invokes the actual authoritative height action.
  type Rates={wall:int, offset:int,aQuota:int,bQuota:int,bHeight:int,
    blockToken:int,submittedAt:int,submitted:bool,token:int,accepted:int,atHeight:int}
  var rates:Rates

  action rateInit = {
    nondet offset=Set(0,1).oneOf()
    all {init,pc'=0,rates'={wall:0,offset:offset,aQuota:0,bQuota:0,bHeight:0,
                           blockToken:0,submittedAt:0,submitted:false,token:1,accepted:0,atHeight:0}}
  }

  action interval(a:int,b:int,drift:int):bool = all {
    pc==readyPC,pc'=pc,rates.wall<3,s'=s,
    rates'={...rates,blockToken:0,wall:rates.wall+1,offset:rates.offset+drift,aQuota:a,bQuota:b}
  }
  action mineA = all {
    pc==readyPC,pc'=pc,rates.aQuota>0,tick,rates'={...rates,aQuota:rates.aQuota-1,blockToken:if(rates.submitted) rates.token else 0}
  }
  action mineB = all {
    pc==readyPC,pc'=pc,rates.bQuota>0,s'=s,
    rates'={...rates,bQuota:rates.bQuota-1,bHeight:rates.bHeight+1}
  }
  action submit = all {
    pc==readyPC,pc'=pc,not(rates.submitted),s'=s,rates'={...rates,submitted:true,submittedAt:s.height}
  }
  action replaceAttempt = all {
    pc==readyPC,pc'=pc,rates.submitted,rates.token==1,rates.accepted==0,s'=s,rates'={...rates,token:2,submittedAt:s.height}
  }
  action includeCommit(token:int):bool = all {
    pc==readyPC,pc'=pc,rates.submitted,token!=0,(rates.blockToken==token or mode==4),(token==rates.token or mode==1),rates.accepted==0,
    commit(2),rates'={...rates,accepted:token,atHeight:s.height}
  }
  action includeAbort = all {
    pc==readyPC,pc'=pc,rates.accepted==0,rates.blockToken==rates.token,
    abort(2),rates'={...rates,accepted:rates.token,atHeight:s.height}
  }
  val terminalPhase = if(s.trades.get(2).decision==2) 3 else 4

  action confirm = {
    val p=terminalPhase
    all {
      pc==readyPC,pc'=pc,rates'=rates,rates.accepted>0,not(s.finalized.contains(fact(2,p))),
      s.height>=rates.atHeight+1 or mode==2,finalize(2,p)
    }
  }
  action issue = {
    val p=terminalPhase
    all {
      pc==readyPC,pc'=pc,rates'=rates,s.finalized.contains(fact(2,p)),
      any {
        all {not(s.captured.contains(fact(2,p))),capture(2,p)},
        all {not(s.proofs.contains(fact(2,p))),prove(2,p)},
        all {not(s.received.contains(fact(2,p))),deliver(2,p)}
      }
    }
  }
  action refundByBTime = all {mode==3,pc==readyPC,pc'=pc,rates'=rates,
    2*rates.wall+rates.offset>=desc(2).deadline,unsafeRefund(2)}

  action rateStep = any {
    bootstrap,mineA,mineB,submit,replaceAttempt,includeAbort,confirm,issue,refundByBTime,
    nondet token=Set(1,2).oneOf(); includeCommit(token),
    nondet a=0.to(2).oneOf(); nondet b=0.to(2).oneOf(); nondet drift=Set(-1,0,1).oneOf(); interval(a,b,drift),
    all {s'=s,rates'=rates,pc'=pc}
  }
  val inclusionBacked = rates.accepted==0 or rates.atHeight>rates.submittedAt
  val replacementBound = rates.accepted==0 or rates.accepted==rates.token
  val canonicalConfirmation = s.finalized.filter(f=>Set(3,4).contains(f.phase))
    .forall(f=>rates.accepted>0 and s.height>=rates.atHeight+1 and f.d==desc(2) and f.phase==terminalPhase)
  val noInvalidEarlyRefund = s.trades.get(2).decision!=2 or s.trades.get(2).refundsB==0
  val clockSafety = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t))) and
    inclusionBacked and replacementBound and canonicalConfirmation and noInvalidEarlyRefund and
    s.height<=2*rates.wall and rates.bHeight<=2*rates.wall
}

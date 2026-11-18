"""Funded B/D/shared placements with real separate effects and hostile transport."""
import argparse
from concurrent.futures import ThreadPoolExecutor

from evidence import QUINT,ROOT,execute
from products_hostile import RUNTIME
from repeated_checks import abort_record,book,chain,dispatcher,prepared,proof,stage
from three_checks import source_closure

PLACES={1:"b",2:"d",3:"shared"}


def closure(host,mode):
    corpus=source_closure(3,timed=True)
    if mode=="mutant":
        core=corpus["dvp.qnt"].decode()
        if host in (1,3):
            head=core.index("  action commit(t:int)")
            tail=core.index("  action abort(t:int)")
            region=core[head:tail]
            # The decision and knowledge still change. Suppress its required
            # cash effect, amount, inclusion and actual hold consumption.
            marker="knownB:if(HOST==1 or HOST==3)"
            region=region.replace("(HOST==1 or HOST==3)","(false)")
            region=region.replace("knownB:if(false)",marker)
            core=core[:head]+region+core[tail:]
        else:
            anchor="has(s,t,if(outcome==2) 3 else 4)"
            if core.count(anchor)!=1:
                raise ValueError("Wrong outcome consumer mutation anchor")
            core=core.replace(anchor,"has(s,t,4)")
        corpus["dvp.qnt"]=core.encode()

    source=f"""module placement_products {{
  import dvp(N=3,HOST={host},OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))
  action placementStep = any {{adversarialStep,
    nondet t=Trades.oneOf(); nondet p=0.to(6).oneOf(); any {{lose(t,p),prune(t,p)}}}}
"""
    if mode=="sample":
        corpus["placement.qnt"]=(source+"}\n").encode()
        return corpus
    source+=dispatcher()
    holds=chain("init",[event for trade in (1,2,3) for event in prepared(trade)])
    if host in (1,2):
        holds += "".join(f".then(registerDecision({t}))" for t in (1,2,3))
    proof_a={0:[2],1:[1],2:[1,2],3:[]}[host]
    ready=chain("holds",[event for p in proof_a for event in proof(1,p)])
    timed=chain("ready",["commit(1)","tick","tick","tick","abort(2)"])
    if mode=="mutant":
        if host in (1,3):
            source+=f"  run OmittedLocalCashIsVisibleTest={ready.replace('holds', '('+holds+')',1)}.then(commit(1))"
            source+=".expect(s.trades.get(1).decision==2 and s.trades.get(1).effectsB==0 and not(legOutcomeSound(s,desc(1),1)))\n"
        else:
            source+=f"  run holds={holds}\n  run ready={ready}\n  run disposition={timed}\n"
            source+="  run AbortProofCannotAuthorizeCashMutantTest="+chain("disposition",proof(2,4))
            source+=".then(learn(2,2,1)).then(applyB(2)).expect(s.trades.get(2).decision==3 and not(legOutcomeSound(s,desc(2),1)))\n"
        corpus["placement.qnt"]=(source+"}\n").encode()
        return corpus

    both_held="Trades.forall(t=>s.trades.get(t).holdA==1 and s.trades.get(t).holdB==1)"
    source+=f"  run holds={holds}.expect(sequenceSafe and {both_held})\n  run ready={ready}\n"
    source+=f"  run disposition={timed}\n"
    # Retain work across outage with actual source job replay.
    lag=chain("disposition",["crash(3)","crash(4)","rotate","exitMember","recover(3)","recover(4)",
                             *proof(1,3)[:-1],"lose(1,3)","resend(1,3)","deliver(1,3)","deliver(1,3)"])
    source+=f"  run firstOutcome={lag}\n"
    source+="  run AbsentRemoteReleaseCannotBeGuessedTest="+chain("disposition",proof(2,4))+f".then(refund(2,{1 if host==0 else 0}).fail())\n" if host!=3 else ""

    def remote(prefix,t):
        result=prefix
        if host in (1,2):
            result+=f".then(learn({t},2,0)).then(applyA({t})).expect(sequenceSafe)"
        if host in (0,2):
            result=chain(result,[f"learn({t},2,1)",f"applyB({t})"])
        return result

    first=remote("firstOutcome",1)
    source+=f"  run firstApplied={first}\n"
    source+="  run OneLegEvidenceCannotBookTest="+chain("firstApplied",[*proof(1,5),"observe(1,0)"])+".then(reconcile(1).fail())\n"
    mixed=chain("firstApplied",[*book(1),*proof(2,4),"learn(2,3,0)","learn(2,3,1)","refund(2,0)","refund(2,1)",*abort_record(2),
                                *[event for p in proof_a for event in proof(3,p)],"commit(3)",*proof(3,3)])
    mixed=chain(remote(mixed,3),book(3))
    source+="  run FundedMixedRecoveryTest="+mixed+(
        ".expect(sequenceSafe and s.financialRecords.size()==3 and "
        "Trades.forall(t=>evidenceBackedBooking(s,desc(t))) and s.trades.get(2).refundsA==1 and "
        "s.trades.get(2).refundsB==1 and s.ownerA==2 and s.ownerB==3)\n"
    )
    # A real fault gives denial with a qualified prepared proof already present.
    source+="  run DecisionOwnerUnavailableTest=ready.then(crash("+str(host)+"))"
    source+=".expect(s.trades.get(1).decision==1).then(commit(1).fail())\n"
    corpus["placement.qnt"]=(source+"}\n").encode()
    return corpus


def check(host,mode):
    name=f"products-placement-{PLACES[host]}-{mode}"
    folder=RUNTIME/name
    stage(folder,closure(host,mode))
    file=str((folder/"placement.qnt").relative_to(ROOT))
    if mode=="sample":
        return execute(name,[QUINT,"run",file,"--main","placement_products","--backend","rust","--init","init",
                             "--step","placementStep","--invariant","sequenceSafe","--seed","71",
                             "--max-samples","600","--max-steps","120","--verbosity","1"],
                       backend="simulation",seconds=240,claim="Placement adversarial safety sample",config={"host":host,"trades":3})
    return execute(name,[QUINT,"test",file,"--main","placement_products","--backend","rust","--seed","71","--match",".*Test"],
                   claim="Named placement protocol effects and fault controls",seconds=120,config={"host":host,"trades":3,"mode":mode})


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode",choices=("directed","mutant","sample"))
    parser.add_argument("hosts",nargs="*",type=int)
    arg=parser.parse_args()
    with ThreadPoolExecutor(max_workers=3) as pool:
        results=list(pool.map(lambda h: check(h,arg.mode),(arg.hosts or list(PLACES))))
    raise SystemExit(not all(r["expectation_met"] for r in results))

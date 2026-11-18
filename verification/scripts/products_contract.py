"""Logical two-ledger contract histories evaluated by real settlement actions."""
import argparse
from concurrent.futures import ThreadPoolExecutor

from evidence import QUINT,ROOT,execute
from products_hostile import PRODUCT,RUNTIME
from repeated_checks import EVENTS,chain,dispatcher,stage
from three_checks import source_closure

RUNS={
    "products-contract-history":0,"products-contract-early":1,
    "products-contract-half":2,"products-contract-cache":3,"products-contract-duplicate":4,
}


def closure(mode):
    sources=source_closure(3,timed=True)
    source=f"""module contract_products {{
  import dvp(N=3,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT={3 if mode==4 else 0}).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  val sequenceSafe = safe and CDecision and Trades.forall(t=>tradeGuarantees(s,desc(t)))
  pure val mode={mode}
"""
    source+=(PRODUCT/"contract_suffix.qnt").read_text()
    wiring=dispatcher().replace("action executeEvent(","action executeCore(",1)
    wiring=wiring.replace("executeEvent(events.nth(i))","executeFramed(events.nth(i))",1)
    source+=wiring+"  action executeFramed(e:(int,int,int,int)):bool = all {executeCore(e),j'=j}\n"
    held=chain("historyInit",["sign(1,0)","sign(1,1)","sign(2,0)","sign(2,1)"])
    source+=f"  run signed={held}\n"
    source+="""
  run reserved = signed.then(invokeOp(1,0,1)).then(invokeOp(1,1,1))
    .then(effect(1,1)).then(effect(1,0)).then(confirmOp(1,0)).then(confirmOp(1,1))
    .then(reload(1,0)).then(reload(1,1)).then(response(1,0,1)).then(response(1,1,1))
    .then(keepBackup)
"""
    source+="  run prepared="+chain("reserved",["capture(1,2)","prove(1,2)","deliver(1,2)"])+"\n"
    source+="  run decided=prepared.then(invokeOp(1,2,1)).then(effect(1,2)).then(confirmOp(1,2))\n"
    source+="  run outcomeReady="+chain("decided",["capture(1,3)","prove(1,3)","deliver(1,3)","learn(1,2,1)"])+"\n"
    source+="  run applied=outcomeReady.then(invokeOp(1,3,1)).then(effect(1,3)).then(confirmOp(1,3))\n"
    if mode==0:
        booked=chain("applied",["finalize(1,5)","capture(1,5)","prove(1,5)","deliver(1,5)","observe(1,0)",
                               "capture(1,6)","prove(1,6)","deliver(1,6)","observe(1,1)"])
        source+=f"  run bothObserved={booked}\n"
        source+="""
  run CommitAndRetryHaveAValidIndependentHistoryTest = bothObserved
    .then(invokeOp(1,7,1)).then(effect(1,7)).then(confirmOp(1,7))
    .then(stopAdapter).then(recoverAdapter)
    .expect(historySafe and not(j.fresh) and not(j.cache.contains((1,3))) and j.finalizedOps.contains((1,3)))
    .then(invokeOp(1,3,2)).then(caughtUp).then(response(1,3,2)).then(response(1,7,1))
    .expect(historySafe and s.receivedA.get(1)==2 and s.receivedB.get(1)==3 and j.events.select(e=>e._1==(1,3) and e._3==1).length()==1)
  run frozenAttempt = prepared.then(invokeOp(1,2,1)).then(executeFramed((EVENT_FREEZE,0,0,0)))
    .expect(historySafe and s.trades.get(1).decision==1 and s.trades.get(1).holdA==1
            and s.receivedA.get(1)==0 and not(j.durable.contains((1,2))))
  run FrozenCommitCannotLinearizeTest = frozenAttempt.then(effect(1,2).fail())
  run FrozenCommitCannotConfirmTest = frozenAttempt.then(confirmOp(1,2).fail())
  run FrozenCommitCannotRespondTest = frozenAttempt.then(response(1,2,1).fail())
  run UnfreezeRetryHasOneCanonicalEffectTest = frozenAttempt
    .then(invokeOp(1,2,2)).then(executeFramed((EVENT_UNFREEZE,0,0,0)))
    .then(effect(1,2)).then(confirmOp(1,2)).then(reload(1,2)).then(response(1,2,2))
    .expect(historySafe and s.trades.get(1).decision==2 and s.receivedA.get(1)==2)
  run UnconfirmedApplicationCannotRespondTest = outcomeReady.then(invokeOp(1,3,1)).then(response(1,3,1).fail())
  run OlderBackupCannotAnswerAsCurrentTest = applied.then(stopAdapter).then(recoverAdapter)
    .expect(historySafe and not(j.fresh) and not(j.cache.contains((1,3)))).then(response(1,3,1).fail())
  run RetriedInvocationCannotExecuteTheSameEffectAgainTest = applied.then(invokeOp(1,3,2))
    .expect(historySafe and s.receivedB.get(1)==3).then(effect(1,3).fail())
"""
        abort_prefix=chain("signed.then(invokeOp(2,0,1)).then(invokeOp(2,1,1)).then(effect(2,0)).then(effect(2,1))",
                           ["tick","tick","tick"])
        source+=f"  run expired={abort_prefix}.then(invokeOp(2,4,1)).then(effect(2,4)).then(confirmOp(2,4))\n"
        returned=chain("expired",["capture(2,4)","prove(2,4)","deliver(2,4)","learn(2,3,1)"])
        source+=f"""  run AbortAndRefundAreSeparateLinearizationPointsTest={returned}
    .then(invokeOp(2,5,1)).then(invokeOp(2,6,1)).then(effect(2,6)).then(confirmOp(2,6))
    .then(effect(2,5)).then(confirmOp(2,5)).then(caughtUp).then(response(2,6,1)).then(response(2,5,1))
    .expect(historySafe and s.trades.get(2).refundsA==1 and s.trades.get(2).refundsB==1 and s.receivedB.get(2)==0)
"""
    if mode==1:
        source+="  run PrematureResponseViolatesLegalHistoryTest=outcomeReady.then(invokeOp(1,3,1)).then(response(1,3,1)).expect(not(legal(j.events)))\n"
    if mode==2:
        source+="  run MissingCommitEffectBreaksSourceComparisonTest=prepared.then(invokeOp(1,2,1)).then(effect(1,2)).expect(not(actualEffects))\n"
    if mode==3:
        source+="  run ForgedRestoredCacheCannotCreateAuthorityTest=outcomeReady.then(invokeOp(1,3,1)).then(stopAdapter).then(recoverAdapter).then(response(1,3,1)).expect(not(legal(j.events)) and not(historySafe))\n"
    if mode==4:
        source+="  run DuplicateActualCashEffectBreaksHistoryTest=applied.then(invokeOp(1,3,2)).then(effect(1,3)).expect(s.receivedB.get(1)==6 and not(legal(j.events)))\n"
    source=source.replace("EVENT_UNFREEZE",str(EVENTS["unfreeze"])).replace("EVENT_FREEZE",str(EVENTS["freeze"]))
    sources["history.qnt"]=(source+"}\n").encode()
    return sources


def check(name,mode):
    folder=RUNTIME/name
    stage(folder,closure(mode))
    return execute(name,[QUINT,"test",str((folder/"history.qnt").relative_to(ROOT)),"--main","contract_products",
                         "--backend","rust","--seed","71","--match",".*Test"],
                   claim="Modeled invocation, inclusion, finality, restore, response and independent history",
                   seconds=120,config={"mode":mode,"scope":"logical contract"})

if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases",nargs="*")
    names=parser.parse_args().cases or list(RUNS)
    with ThreadPoolExecutor(max_workers=2) as workers:
        results=list(workers.map(lambda name:check(name,RUNS[name]),names))
    raise SystemExit(not all(r["expectation_met"] for r in results))

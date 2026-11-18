"""Compose independent finite chain rates with actual decisions and canonical publication."""
import argparse

from evidence import QUINT,ROOT,execute
from guarantee_checks import JVM
from products_hostile import PRODUCT,RUNTIME
from repeated_checks import prepared,proof,stage
from three_checks import source_closure

CASES={
    "products-clocks-safe": (0,"clockSafety","pass"),
    "products-clocks-old-attempt": (1,"replacementBound","counterexample"),
    "products-clocks-early-witness": (2,"canonicalConfirmation","counterexample"),
    "products-clocks-b-expiry": (3,"noInvalidEarlyRefund","counterexample"),
}


def closure(mode,test=False):
    sources=source_closure(3,timed=True)
    sources["dvp.qnt"]=sources["dvp.qnt"].replace(b"pure val D = 5",b"pure val D = 6",1)
    if mode==3:
        original=b"module contention { import dvp(N=2,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* }"
        if original not in sources["dvp.qnt"]:
            raise ValueError("Core end anchor changed")
    head=f"""module clock_products {{
  import dvp(N=3,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT={1 if mode==3 else 0}).* from "./dvp"
  import guarantee_oracles.* from "./guarantee_oracles"
  pure val mode = {mode}
  var pc:int
"""
    prefix=[*prepared(2),*proof(2,2)]
    wiring=[f"  pure val readyPC = {len(prefix)}","  action bootstrap = any {"]
    wiring += [f"    all {{pc=={i},{op},pc'={i+1},rates'=rates}}," for i,op in enumerate(prefix)]
    text=head+"\n".join(wiring)+"\n  }\n"+(PRODUCT/"clocks_suffix.qnt").read_text()
    if test:
        text+="""
  run ready = rateInit.then(readyPC.reps(_=>bootstrap)).then(submit)
  run IncludedReplacementWaitsForCanonicalDepthTest =
    ready.then(replaceAttempt).then(interval(1,2,1)).then(mineA).then(mineB).then(mineB)
      .then(includeCommit(2))
      .expect(clockSafety and rates.accepted==2 and s.trades.get(2).decision==2 and rates.bHeight==2)
      .then(interval(1,0,-1)).then(mineA).then(confirm).then(3.reps(_=>issue))
      .expect(clockSafety and has(s,2,3) and rates.atHeight==1 and s.height==2)
  run LaggingHeadCannotIssueEvenWithTimeAndBFastTest =
    ready.then(interval(0,2,1)).then(mineB).then(mineB)
      .then(interval(0,2,1)).then(mineB).then(mineB).then(includeCommit(1))
      .expect(clockSafety and s.height==0 and rates.wall==2 and rates.bHeight==4).then(confirm.fail())
  run ReplacementMakesOldSubmissionIneligibleTest =
    ready.then(replaceAttempt).expect(rates.submitted and rates.accepted==0 and has(s,2,2)).then(includeCommit(1).fail())
  run FastBClockDoesNotAuthorizeRefundTest =
    ready.then(interval(0,2,1)).then(mineB).then(mineB).then(interval(0,2,1))
      .expect(clockSafety and s.height==0 and 2*rates.wall+rates.offset>=desc(2).deadline)
      .then(all {refund(2,1),pc'=pc,rates'=rates}.fail())
"""
    sources["clocks.qnt"]=(text+"}\n").encode()
    return sources


def check(name):
    folder=RUNTIME/name
    directed=name=="products-clocks-directed"
    mode,goal,expected=(0,"clockSafety","pass") if directed else CASES[name]
    stage(folder,closure(mode,directed))
    path=str((folder/"clocks.qnt").relative_to(ROOT))
    if directed:
        return execute(name,[QUINT,"test",path,"--main","clock_products","--backend","rust","--seed","71","--match",".*Test"],
                       claim="Included generation, confirmation depth, drift and independent B clock",seconds=120)
    return execute(name,[QUINT,"verify",path,"--main","clock_products","--backend","tlc","--init","rateInit",
                         "--step","rateStep","--invariant",goal,"--tlc-config","verification/configs/extended-tlc.json","--verbosity","3"],
                   claim=goal,expected=expected,backend="tlc",seconds=600,execution_env=JVM,
                   config={"mode":mode,"elapsed":3,"rates":[0,1,2],"drift":[-1,0,1],"depth":1})


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases",nargs="*")
    results=[check(name) for name in (parser.parse_args().cases or ["products-clocks-directed",*CASES])]
    raise SystemExit(not all(r["expectation_met"] for r in results))

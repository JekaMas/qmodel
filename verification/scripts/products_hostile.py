"""Actual N3 end-to-end proof and application work under a checked service policy."""
import argparse

from evidence import QUINT, ROOT, execute
from guarantee_checks import JVM
from repeated_checks import prepared, stage
from three_checks import source_closure
from three_recovery_checks import SUFFIX, TIMED

PRODUCT = ROOT / "verification/tests/workloads/products"
RUNTIME = ROOT / "verification/results/runtime/products"
CASES = {
    "products-jobs-safe": (0,"jobSafety","pass","jobProgress"),
    "products-jobs-queue": (1,"serviceBound","counterexample",None),
    "products-jobs-missing": (2,"serviceBound","counterexample",None),
    "products-jobs-drop": (3,"readySurvives","counterexample",None),
}


def closure(mode, directed=False):
    sources=source_closure(3,timed=True)
    # Preparation and service run at a preserved A height, with T2 expired and
    # T1/T3 still eligible. All decisions use actual descriptor deadlines.
    sources["dvp.qnt"]=sources["dvp.qnt"].replace(b"List(2,3,5).nth(t-1)",b"List(5,3,5).nth(t-1)")
    text=TIMED.read_text().rstrip()[:-1].replace("module timed_three {","module job_products {",1)
    work=SUFFIX.read_text().split("action work(t:int)",1)[0]
    resend="all {s.proofs.contains(fact(t,p)),not(s.network.contains(fact(t,p))),resend(t,p)},"
    work=work.replace("all {not(s.received.contains(fact(t,p))),deliver(t,p)}",resend+"\n  all {not(s.received.contains(fact(t,p))),deliver(t,p)}",1)
    prefix=[*prepared(1),*prepared(2),*prepared(3),"blockA","advance","blockA","advance","blockA"]
    rows=["  var pc:int",f"  pure val loadedPC = {len(prefix)}",f"  pure val workingPC = {len(prefix)+1}",
          f"  pure val mode = {mode}","  action bootstrap = any {"]
    for index,op in enumerate(prefix):
        frame="" if op in ("advance","blockA") else ",clock'=clock"
        rows.append(f"    all {{pc=={index},{op}{frame},pc'={index+1},q'=q}},")
    text += "\n".join(rows)+"\n  }\n"+work+(PRODUCT/"hostile_suffix.qnt").read_text()
    if directed:
        text += """
  run SaturatedOutageAndRetryTest =
    jobInit.then(loadedPC.reps(_=>bootstrap)).then(admitJobs)
      .then(junkArrival(1)).then(junkArrival(1)).then(junkArrival(2)).then(junkArrival(3))
      .then(3.reps(_=>service)).then(drop)
      .then(interrupted).then(elapsed).then(elapsed).then(restored)
      .then(53.reps(_=>service.expect(jobSafety)))
      .expect(not(completionWitness) and s.financialRecords.size()==3 and q.ticks==53)
  run PendingJobsStayBackedWithoutServiceTest =
    jobInit.then(loadedPC.reps(_=>bootstrap)).then(admitJobs).then(interrupted)
      .then(junkArrival(1)).then(junkArrival(2)).then(junkArrival(3)).then(6.reps(_=>elapsed))
      .expect(jobSafety and not(allDone) and reservedA(s)==6 and reservedB(s)==9 and not(s.up.contains(3)))
"""
    sources["jobs.qnt"]=(text+"}\n").encode()
    return sources


def check(name):
    directed=name=="products-jobs-directed"
    folder=RUNTIME/name
    if directed:
        stage(folder,closure(0,True))
        return execute(name,[QUINT,"test",str((folder/"jobs.qnt").relative_to(ROOT)),"--main","job_products",
                             "--backend","rust","--seed","71","--match",".*Test"],
                       claim="Saturated recovery, duplicate traffic and witness retry on actual work",seconds=120)
    mode,goal,expected,temporal=CASES[name]
    stage(folder,closure(mode))
    call=[QUINT,"verify",str((folder/"jobs.qnt").relative_to(ROOT)),"--main","job_products","--backend","tlc",
          "--init","jobInit","--step","jobStep","--invariant",goal,"--tlc-config","verification/configs/extended-tlc.json","--verbosity","3"]
    if temporal:
        call+=["--temporal",temporal]
    return execute(name,call,claim=goal,expected=expected,backend="tlc",seconds=900,execution_env=JVM,
                   config={"mode":mode,"service_ticks":56,"junk_ids":3,"one_proof_loss":True})


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases",nargs="*")
    names=parser.parse_args().cases or ["products-jobs-directed",*CASES]
    results=[check(name) for name in names]
    raise SystemExit(not all(result["expectation_met"] for result in results))

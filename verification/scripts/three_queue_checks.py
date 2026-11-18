"""TLC checks for a scoped hostile-queue policy after authenticated COMMIT."""
from evidence import QUINT, ROOT, execute
from repeated_checks import prepared, proof, stage
from three_checks import RUNTIME, WORKLOAD, source_closure
from timed_three_checks import TIMED


def queue_source(protected):
    text=TIMED.read_text().rstrip()
    text=text[:-1].replace("module timed_three {","module three_queue {",1)
    prefix=[
        *prepared(1),*prepared(2),*prepared(3),*proof(1,2),"commit(1)",
        "blockA","advance","blockA","advance","blockA","abort(2)",
        *proof(3,2),"commit(3)",*proof(1,3),"learn(1,2,1)",*proof(3,3),"learn(3,2,1)",
        "stop(1,2)"
    ]
    rows=["  var pc:int",f"  pure val readyPC = {len(prefix)}",
          "  pure val protected = " + str(protected).lower(),"  action bootstrap = any {"]
    for i,op in enumerate(prefix):
        frame="" if op in ("blockA","advance","stop(1,2)") else ",clock'=clock"
        rows.append(f"    all {{pc=={i},{op}{frame},pc'={i+1},load'=load}},")
    suffix=(WORKLOAD/"three_queue_suffix.qnt").read_text()
    return (text+"\n".join(rows)+"\n  }\n"+suffix+"}\n").encode()


CASES={
    "three-queue-protected": (True,"loadSafe","pass"),
    "three-queue-reachable": (True,"neverSaturatedAndComplete","counterexample"),
    "three-queue-unprotected": (False,"withinTwoServiceTicks","counterexample"),
}


def check(run,*case):
    protected,goal,expectation=case
    folder=RUNTIME/run
    stage(folder,{**source_closure(3,timed=True),"three_queue.qnt":queue_source(protected)})
    return execute(
        run,[QUINT,"verify",str((folder/"three_queue.qnt").relative_to(ROOT)),"--main","three_queue",
             "--backend","tlc","--init","loadInit","--step","loadStep","--invariant",goal,
             "--tlc-config","verification/configs/tlc.json","--verbosity","3"],
        claim=goal,expected=expectation,backend="tlc",seconds=300,
        config={"protected_lane":protected,"initial_B_outage":2,"junk_budget":3,"service_ticks":2},
    )


if __name__=="__main__":
    results=[check(run,*case) for run,case in CASES.items()]
    raise SystemExit(not all(r["expectation_met"] for r in results))

"""Exact N3 mixed-outcome suffix following a prefix of actual settlement actions."""
import argparse

from evidence import QUINT, ROOT, execute
from guarantee_checks import JVM
from repeated_checks import prepared, proof, stage
from three_checks import RUNTIME, WORKLOAD, source_closure

SUFFIX = WORKLOAD / "three_recovery_suffix.qnt"
TIMED = WORKLOAD / "timed_three.qnt"


def recovery_source():
    core = TIMED.read_text().rstrip()
    header = core[:-1].replace("module timed_three {", "module three_recovery {", 1)
    prefix = [
        *prepared(1),*prepared(2),*prepared(3),*proof(1,2),"commit(1)",
        "blockA","advance","blockA","advance","blockA","abort(2)",
        *proof(3,2),"commit(3)"
    ]
    rows = ["  var pc:int",f"  pure val readyPC = {len(prefix)}","  action bootstrap = any {"]
    for index, op in enumerate(prefix):
        clock_frame = "" if op in ("blockA","advance") else ",clock'=clock"
        rows.append(f"    all {{pc=={index},{op}{clock_frame},pc'={index+1}}},")
    return (header + "\n".join(rows) + "\n  }\n" + SUFFIX.read_text() + "}\n").encode()


def recovery_witness_source():
    source = recovery_source().decode()
    return (source.rstrip()[:-1]+"""
run MixedOutcomesReachableWithOutageTest =
  recoveryInit.then(readyPC.reps(_=>bootstrap))
    .expect(pc==readyPC and s.trades.get(1).decision==2 and s.trades.get(2).decision==3 and s.trades.get(3).decision==2)
    .then(all {pc'=pc,stop(1,2)})
    .then(2.reps(_=>all {pc'=pc,advance})).then(all {pc'=pc,restart(1)})
    .then(17.reps(_=>work(1).expect(sequenceSafe)))
    .then(10.reps(_=>work(2).expect(sequenceSafe)))
    .then(17.reps(_=>work(3).expect(sequenceSafe)))
    .expect(complete and s.financialRecords.size()==3 and s.receivedB.get(1)==3 and s.receivedB.get(3)==3 and
      s.trades.get(2).refundsA==1 and s.trades.get(2).refundsB==1)
}
""").encode()


def witness():
    folder=RUNTIME/"mixed-witness"
    stage(folder,{**source_closure(3,timed=True),"three_recovery.qnt":recovery_witness_source()})
    return execute(
        "three-recovery-directed-witness",
        [QUINT,"test",str((folder/"three_recovery.qnt").relative_to(ROOT)),
         "--main","three_recovery","--backend","rust","--seed","61","--match","^MixedOutcomesReachableWithOutageTest$"],
        claim="Real mixed terminal outcome prefix and evidenced completion after a two-tick B stop",
        config={"trades":3,"funded_pairs":3,"outage":1,"duration":2},seconds=180,
    )


def check(mode):
    folder = RUNTIME / "mixed-recovery"
    stage(folder, {**source_closure(3,timed=True),"three_recovery.qnt":recovery_source()})
    command = [QUINT,"verify",str((folder/"three_recovery.qnt").relative_to(ROOT)),
               "--main","three_recovery","--backend","tlc","--init","recoveryInit","--step","recoveryStep",
               "--tlc-config","verification/configs/extended-tlc8.json","--verbosity","3"]
    command += (["--invariant","sequenceSafe","--temporal","recoveryProgress"] if mode=="progress" else ["--invariant","incompleteControl"])
    return execute(
        f"three-recovery-{mode}",command,backend="tlc",seconds=1500,
        claim="Evidenced completion for COMMIT/ABORT/COMMIT with a timed post-decision outage",
        expected="pass" if mode=="progress" else "counterexample",
        config={"trades":3,"funded_pairs":3,"post_decision_outage":[1,3,4],"duration":2,"mode":mode},
        execution_env=JVM,resource_limit="8 GiB JVM heap; 1500s",
    )


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode",choices=("progress","reachability","witness"),nargs="?",default="progress")
    mode=parser.parse_args().mode
    result=witness() if mode=="witness" else check(mode)
    raise SystemExit(not result["expectation_met"])

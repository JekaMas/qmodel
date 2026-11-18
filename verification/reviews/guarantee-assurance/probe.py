"""Run isolated model-discriminator scenarios against the reviewed Git revision."""
import argparse
import concurrent.futures
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parents[3]
BASE = "cce9ce6a0f15c45ffaf2513afd42ed1c96125591"
QUINT = ROOT / "node_modules/.bin/quint"
IMPORT = """module probe {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  run signed = init.then(sign(1,0)).then(sign(1,1))
"""
REPORT = """
  run toObserve = signed.then(openA(1)).then(prepareB(1))
    .then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1))
    .then(finalize(1,5)).then(capture(1,5)).then(prove(1,5)).then(deliver(1,5)).then(observe(1,0))
  val lag = s.trades.get(1).decision==2 and s.trades.get(1).effectsA==1 and
    s.trades.get(1).effectsB==0 and s.trades.get(1).holdB==1 and has(s,1,5) and not(has(s,1,6))
  val commitRecordSound = (s.trades.get(1).report==2 or s.trades.get(1).booked>0) implies
    (s.trades.get(1).decision==2 and s.trades.get(1).effectsA==1 and
     s.trades.get(1).effectsB==1 and has(s,1,5) and has(s,1,6))
"""
OUTCOME = """
  run toLearn = signed.then(prepareB(1)).then(tick).then(tick).then(abort(1))
    .then(finalize(1,4)).then(capture(1,4)).then(prove(1,4)).then(deliver(1,4))
  val abortOnly = s.trades.get(1).decision==3 and s.trades.get(1).holdA==0 and
    s.trades.get(1).holdB==1 and has(s,1,4) and not(has(s,1,3))
  val cashAuthorized = s.trades.get(1).effectsB>0 implies
    (s.trades.get(1).decision==2 and has(s,1,3))
"""
CASES = {
    "report-control": (None, REPORT + """
  run reportingTest = toObserve.expect(lag and safe and CDecision)
    .then(observe(1,1).fail())
}
"""),
    "report-missing-evidence": (
        ("action observe(t:int,leg:int): bool = all {s.up.contains(3),has(s,t,if(leg==0) 5 else 6),",
         "action observe(t:int,leg:int): bool = all {s.up.contains(3),leg==1 or has(s,t,5),"),
        REPORT + """
  run reportingTest = toObserve.expect(lag and safe and CDecision)
    .then(observe(1,1)).then(reconcile(1))
    .expect(lag and safe and CDecision and not(commitRecordSound) and
      s.trades.get(1).appliedEvidenceB and s.trades.get(1).report==2 and s.trades.get(1).booked==1)
}
"""),
    "outcome-control": (None, OUTCOME + """
  run outcomeTest = toLearn.expect(abortOnly and safe and CDecision)
    .then(learn(1,2,1).fail())
}
"""),
    "outcome-wrong-phase": (
        ("has(s,t,if(outcome==2) 3 else 4),",
         "has(s,t,if(outcome==2 and leg!=1) 3 else 4),"),
        OUTCOME + """
  run outcomeTest = toLearn.expect(abortOnly and safe and CDecision)
    .then(learn(1,2,1)).then(applyB(1))
    .expect(safe and CDecision and not(cashAuthorized) and s.trades.get(1).decision==3 and
      s.trades.get(1).holdB==2 and s.trades.get(1).effectsB==1 and not(has(s,1,3)))
}
"""),
}


def git_source(name):
    return subprocess.check_output(["git", "show", f"{BASE}:verification/models/{name}"], cwd=ROOT)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def run_case(name, mutation, scenario, source, economic, output):
    model = source.decode()
    if mutation:
        before, after = mutation
        assert model.count(before) == 1
        model = model.replace(before, after, 1)
    inputs = {"dvp.qnt": model.encode(), "economic_effects.qnt": economic, "probe.qnt": (IMPORT + scenario).encode()}
    with tempfile.TemporaryDirectory(prefix="qmodel-guarantee-") as directory:
        work = Path(directory)
        for relative, data in inputs.items():
            (work / relative).write_bytes(data)
        argv = [str(QUINT), "test", "probe.qnt", "--main", "probe", "--match", ".*Test",
                "--backend", "typescript", "--seed", "17"]
        start = time.monotonic()
        child = subprocess.run(argv, cwd=work, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60)
    raw = child.stdout
    log = output / (name + ".log")
    log.write_bytes(raw)
    return {"case": name, "mutation": mutation, "command": argv, "input_sha256": {k: digest(v) for k,v in inputs.items()},
            "raw_output": log.name, "raw_sha256": digest(raw), "exit_code": child.returncode,
            "wall_seconds": round(time.monotonic()-start, 3),
            "observed": child.returncode == 0 and bool(re.search(rb"\b1 passing\b", raw))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    source, economic = git_source("dvp.qnt"), git_source("economic_effects.qnt")
    version = subprocess.check_output([str(QUINT), "--version"], cwd=ROOT, text=True).strip()
    assert version == "0.33.1", version
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        pending = [pool.submit(run_case, name, *case, source, economic, output) for name, case in CASES.items()]
        observations = [task.result() for task in pending]
    report = {"reviewed_commit": BASE, "quint": version, "probe_sha256": digest(Path(__file__).read_bytes()),
              "scope": "Expected finite directed outcomes on the original source and isolated copies. A passing mutant case observes an assertion blind spot.",
              "observations": observations}
    (output / "results.json").write_text(json.dumps(report, indent=2)+"\n")
    for row in observations:
        print(row["case"], row["observed"], row["wall_seconds"])
        if not row["observed"]:
            print((output / row["raw_output"]).read_text())
    return int(not all(row["observed"] for row in observations))


if __name__ == "__main__":
    raise SystemExit(main())

"""Record directed checks and independent monitors on isolated faulty producers."""
import runpy
import sys

from evidence import QUINT, ROOT, execute

MODELS = ROOT / "verification/models"
ADAPTER = "verification/adapters/booking.py"
BOOKING_TEST = "verification/tests/test_assurance_booking.py"
TESTS = ROOT / "verification/reviews/guarantee-assurance/probe.py"
RUNTIME = ROOT / "verification/results/runtime/guarantee-controls"

OUTCOME = """
  run WrongPhaseOutcomeTest = toLearn.expect(abortOnly and safe and CDecision)
    .then(learn(1,2,1))
    .expect(not(strict::legOutcomeSound(s,desc(1),1)) and s.trades.get(1).effectsB==0)
    .then(applyB(1))
    .expect(safe and CDecision and not(strict::tradeGuarantees(s,desc(1))) and
      s.trades.get(1).decision==3 and s.trades.get(1).effectsB==1 and not(strict::receivedFact(s,desc(1),3)))
}
"""

REPORT = """
  run premature = toObserve.expect(lag and safe and CDecision)
    .then(observe(1,1)).then(reconcile(1))
  run MissingApplicationEvidenceTest = premature
    .expect(lag and safe and CDecision and s.trades.get(1).report==2 and
      not(strict::hasBothApplications(s,desc(1))) and not(strict::commitRecordSound(s,desc(1))) and not(strict::l04IsEvidenced(s,desc(1))))
  run PrematureDurableRowAfterResetTest = premature.then(crash(3)).then(recover(3))
    .expect(s.trades.get(1).report==0 and s.trades.get(1).stale and
      s.financialRecords==Set({d:desc(1),outcome:2}) and not(strict::commitRecordSound(s,desc(1))))
    // Even erasing both evidence flags must leave the bad durable row detectable.
    .expect(not(strict::commitRecordSound({...s,trades:s.trades.set(1,
      {...s.trades.get(1),appliedEvidenceA:false,appliedEvidenceB:false,booked:0})},desc(1))))
}
"""

LOCAL = """
  run OmittedLocalDeliveryTest = signed.then(openA(1)).then(prepareB(1))
    .then(finalize(1,2)).then(capture(1,2)).then(prove(1,2)).then(deliver(1,2)).then(commit(1))
    .expect(s.trades.get(1).decision==2 and s.trades.get(1).holdA==1 and s.trades.get(1).effectsA==0 and
      not(strict::legOutcomeSound(s,desc(1),0)))
}
"""


def control_sources(case):
    """Keep the reviewed mutation anchors and replay the same witness prefixes."""
    archive = runpy.run_path(str(TESTS))
    model = (MODELS / "dvp.qnt").read_text()
    header = archive["IMPORT"]
    header = header.replace(
        "  run signed", '  import guarantee_oracles as strict from "./guarantee_oracles"\n  run signed',
    )
    if case == "wrong-phase":
        mutation = archive["CASES"]["outcome-wrong-phase"][0]
        checks = archive["OUTCOME"] + OUTCOME
    elif case == "missing-application":
        mutation = archive["CASES"]["report-missing-evidence"][0]
        checks = archive["REPORT"] + REPORT
    elif case == "omitted-local":
        mutation = None
        header = header.replace("MUTANT=0", "MUTANT=5")
        checks = LOCAL
    else:
        raise ValueError(f"Unknown control {case}")
    if mutation is not None:
        before, after = mutation
        if model.count(before) != 1:
            raise ValueError(f"Reviewed mutation anchor changed: {case}")
        model = model.replace(before, after, 1)
    return {
        "dvp.qnt": model.encode(),
        "economic_effects.qnt": (MODELS / "economic_effects.qnt").read_bytes(),
        "guarantee_oracles.qnt": (MODELS / "guarantee_oracles.qnt").read_bytes(),
        "probe.qnt": (header + checks).encode(),
    }


CONTROL_CASES = ("wrong-phase", "missing-application", "omitted-local")


def record_control(case):
    path = RUNTIME / case
    path.mkdir(parents=True, exist_ok=True)
    for name, data in control_sources(case).items():
        (path / name).write_bytes(data)
    return execute(
        f"guarantees-control-{case}",
        [QUINT, "test", str((path / "probe.qnt").relative_to(ROOT)), "--main", "probe",
         "--backend", "typescript", "--seed", "17", "--match", ".*Test"],
        claim=f"Independent assertion observes violation on isolated {case} producer",
        config={"isolated_control": case},
    )


def record_booking():
    # Explicit file arguments let the generic replay run the saved adapter and
    # test together. The repository checkout is never an import fallback.
    launch = (
        "import runpy,sys;from pathlib import Path;"
        "sys.path[0]=str(Path(sys.argv[2]).resolve().parents[2]);"
        "sys.argv=sys.argv[1:2];runpy.run_path(sys.argv[0],run_name='__main__')"
    )
    return execute(
        "guarantees-sqlite", [sys.executable, "-B", "-c", launch, BOOKING_TEST, ADAPTER],
        claim="Real SQLite restore, exact replay, conflicting input and concurrent inserts",
        config={"fixture_boundary": "upstream authenticated application evidence"},
    )


if __name__ == "__main__":
    results = [record_booking(), *(record_control(case) for case in CONTROL_CASES)]
    sys.exit(not all(result["expectation_met"] for result in results))

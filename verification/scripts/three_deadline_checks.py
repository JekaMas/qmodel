"""Test the exclusive deadline with every other commit guard already satisfied."""
from repeated_checks import chain, proof
from three_matrix_checks import check
from timed_three_checks import test_source

RUN = "three-exclusive-deadline"


def cases():
    source = test_source(3).decode().rstrip()
    header = "\n".join(line for line in source[:-1].splitlines() if not (line.startswith("  run ") and "Test =" in line)) + "\n"
    event_prefix = chain("held",proof(2,2))
    predicates = "allPending(2) and has(s,2,2) and s.trades.get(2).decision==1"
    fixtures = f"""
  run readyBefore = {event_prefix}.then(blockA).then(advance).then(blockA)
    .expect({predicates} and s.height==desc(2).deadline-1)
  run readyAt = readyBefore.then(advance).then(blockA)
    .expect({predicates} and s.height==desc(2).deadline)
  run readyAfter = readyAt.then(advance).then(blockA)
    .expect({predicates} and s.height==desc(2).deadline+1)
"""
    cases = {
        "AbortBeforeDeadlineIsDisabledTest": "readyBefore.then(all {abort(2),clock'=clock}.fail())",
        "CommitBeforeDeadlineAppliesLocalEffectTest": (
            "readyBefore.then(all {commit(2),clock'=clock}).expect(sequenceSafe and s.receivedA.get(2)==2)"
        ),
        "CommitAtDeadlineFailsWhileOpenTest": "readyAt.then(all {commit(2),clock'=clock}.fail())",
        "AbortAtDeadlineHasNoDeliveryTest": (
            "readyAt.then(all {abort(2),clock'=clock}).expect(sequenceSafe and s.trades.get(2).decision==3 and s.receivedA.get(2)==0)"
        ),
        "CommitAfterDeadlineFailsWhileOpenTest": "readyAfter.then(all {commit(2),clock'=clock}.fail())",
    }
    tests = "".join(f"  run {name} = {expr}\n" for name,expr in cases.items())
    return (header+fixtures+tests+"}\n").encode(), tuple(cases)


if __name__=="__main__":
    raise SystemExit(not check((RUN,cases()))["expectation_met"])

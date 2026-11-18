"""Cover every actor/duration pair and every route phase with actual blocked actions."""
from concurrent.futures import ThreadPoolExecutor

from evidence import QUINT, ROOT, execute
from repeated_checks import chain, prepared, proof, stage
from three_checks import RUNTIME, source_closure
from timed_three_checks import test_source

ACTORS = tuple(range(5))
DURATIONS = (1,2,3,5,14)


def tests():
    cases = {}
    for actor in ACTORS:
        for duration in DURATIONS:
            end = 8 if duration == 14 else duration
            name = f"Actor{actor}Window{duration}Test"
            previous = f"start.then(stop({actor},{duration})).then({end}.reps(_=>advance))"
            previous += (
                f".expect(sequenceSafe and not(s.up.contains({actor})) and s.height==0 and clock.slot=={end})"
            )
            cases[name] = previous + (
                f".then(restart({actor}).fail())" if duration == 14 else
                f".then(restart({actor})).expect(sequenceSafe and s.up.contains({actor}))"
            )
    for actor in ACTORS:
        cases[f"Actor{actor}FlapTest"] = (
            f"start.then(stop({actor},1)).then(advance).then(restart({actor})).then(stop({actor},2))"
            f".then(advance).expect(clock.slot==2 and not(s.up.contains({actor}))).then(advance).then(restart({actor}))"
            f".expect(sequenceSafe and clock.slot==3 and s.up.contains({actor}) and clock.failures==2)"
        )

    wire = {
        "proof0": chain("held", proof(1,0)[:-1]),
        "proof1": chain("held", proof(1,1)[:-1]),
        "proof2": chain("held", proof(1,2)[:-1]),
        "proof3": "inFlight",
        "proof4": chain("held.then(blockA).then(advance).then(blockA).then(advance).then(blockA)",
                        ["abort(2)", *proof(2,4)[:-1]]),
        "proof5": chain("inFlight", proof(1,5)[:-1]),
        "proof6": chain("inFlight", ["deliver(1,3)", "learn(1,2,1)", "applyB(1)", *proof(1,6)[:-1]]),
    }
    routes = (0,0,1,2,2,3,3)
    for phase, route in enumerate(routes):
        t = 2 if phase == 4 else 1
        network = f"s.network.contains(fact({t},{phase}))"
        deliver = f"all {{connected({phase}),deliver({t},{phase}),clock'=clock}}"
        partition = f"proof{phase}.then(partitionLink({route},2)).expect(sequenceSafe and {network})"
        cases[f"Phase{phase}PartitionBlocksDeliveryTest"] = partition + (
            f".then(advance).expect(clock.slot<clock.partition.get({route}) and {network}).then({deliver}.fail())"
        )
        cases[f"Phase{phase}PartitionHealsAtBoundTest"] = partition + (
            f".then(advance).then(advance).then({deliver}).then({deliver}).expect(sequenceSafe and has(s,{t},{phase}))"
        )

    cases.update({
        "RevokeBeforeReserveTest": chain("start", ["sign(1,0)","sign(1,1)","revokeLeg(1,0)"]) +
            ".expect(not(s.eligible.contains((1,0))) and s.trades.get(1).holdA==0).then(all {openA(1),clock'=clock}.fail())",
        "ReserveBeforeRevokeTest": chain("start", [*prepared(1),"revokeLeg(1,0)",*proof(1,2),"commit(1)"]) +
            ".expect(sequenceSafe and s.trades.get(1).decision==2 and s.trades.get(1).holdA==2)",
        "SubmitterStopBeforeCommitTest": chain("held", proof(1,2)) +
            ".then(stop(2,1)).expect(has(s,1,2) and allPending(1)).then(all {commit(1),clock'=clock}.fail())",
        "CommitBeforeSubmitterStopTest": (
            "inFlight.then(stop(2,1)).expect(sequenceSafe and s.trades.get(1).decision==2 and s.receivedA.get(1)==2)"
            ".then(advance).then(restart(2)).expect(sequenceSafe and s.up.contains(2))"
        ),
        "ObserveBeforeApplicationTest": (
            "inFlight.expect(s.trades.get(1).effectsB==0 and has(s,1,2)).then(all {observe(1,1),clock'=clock}.fail())"
        ),
        "FreezeCannotUndoCommitTest": chain("inFlight", ["freeze(1)","deliver(1,3)","learn(1,2,1)"]) +
            ".expect(s.trades.get(1).decision==2 and s.trades.get(1).holdB==1).then(all {applyB(1),clock'=clock}.fail())",
    })
    return wire, cases


def batches():
    original = test_source(3).decode().rstrip()
    # Reuse named scenario prefixes and actual dispatcher. Strip unrelated
    # tests to bound native compilation memory for the enlarged matrix.
    header = "\n".join(line for line in original[:-1].splitlines() if not (line.startswith("  run ") and "Test =" in line))
    prefixes, cases = tests()
    header += "\n" + "".join(f"  run {name} = {expr}\n" for name,expr in prefixes.items())
    entries = list(cases.items())
    return {
        f"three-fault-matrix-{i//12+1:02d}": (
            (header + "".join(f"  run {name} = {expr}\n" for name,expr in entries[i:i+12]) + "}\n").encode(),
            tuple(name for name,_ in entries[i:i+12]),
        ) for i in range(0,len(entries),12)
    }


def check(item):
    run, (source, tests_in_batch) = item
    folder = RUNTIME / run
    stage(folder, {**source_closure(3,timed=True), "timed_three_test.qnt": source})
    return execute(run,[QUINT,"test",str((folder/"timed_three_test.qnt").relative_to(ROOT)),
                     "--main","timed_three_test","--backend","rust","--seed","61","--match",".*Test"],
                   claim="Timed fault matrix and stage-local decision races", config={"tests":list(tests_in_batch)}, seconds=180)


if __name__=="__main__":
    with ThreadPoolExecutor(max_workers=2) as pool:
        results=list(pool.map(check,batches().items()))
    raise SystemExit(not all(r["expectation_met"] for r in results))

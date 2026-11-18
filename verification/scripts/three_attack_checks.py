"""Exercise every bounded forged-message selector on a live N3 prefix."""
from concurrent.futures import ThreadPoolExecutor

from repeated_checks import chain
from three_matrix_checks import check
from timed_three_checks import test_source


def batches():
    source = test_source(3).decode().rstrip()
    header = "\n".join(line for line in source[:-1].splitlines() if not (line.startswith("  run ") and "Test =" in line)) + "\n"
    entries = []
    for phase in range(7):
        for selector in range(12):
            # Neither the requested phase nor any neighboring phase for t3 has
            # proof provenance at this point. B's t1/t2 source jobs are real.
            before = "inFlight" if phase != 2 else "outage"
            check = (f"{before}.then(hostile(3,{phase},{selector}))"
                     f".expect(sequenceSafe and not(has(s,3,{phase})) and clock.attacks==3"
                     f" and s.rejects.contains({selector}) and allPending(3))")
            if selector == 0:
                check += ".expect(s.received.exists(f=>f.d.trade==1 and f.d.nonce==3))"
            if selector == 11:
                check += ".expect(s.received.exists(f=>f.d.trade==4 and f.d.nonce==3))"
            entries.append((f"Candidate{selector}AtPhase{phase}Test", check))
    # In the legacy dispatcher selector 6 targets phase 6. On a phase-6 fact
    # it can only be an exact replay. Exercise that case with real provenance.
    cash_applied = chain("inFlight", ["deliver(1,3)", "learn(1,2,1)", "applyB(1)",
                                     "finalize(1,6)", "capture(1,6)", "prove(1,6)"])
    replay = (cash_applied + ".expect(not(has(s,1,6))).then(hostile(1,6,6))"
              ".expect(sequenceSafe and has(s,1,6) and s.receivedB.get(1)==3)"
              ".then(all {applyB(1),clock'=clock}.fail())")
    entries.append(("EqualCandidateWithRealProvenanceRemainsAnIdempotentReplayTest", replay))
    return {
        f"three-attack-matrix-{i//16+1:02d}": (
            (header + "".join(f"  run {name} = {expr}\n" for name,expr in entries[i:i+16]) + "}\n").encode(),
            tuple(name for name,_ in entries[i:i+16]),
        ) for i in range(0,len(entries),16)
    }


if __name__=="__main__":
    with ThreadPoolExecutor(max_workers=2) as pool:
        results=list(pool.map(check,batches().items()))
    raise SystemExit(not all(r["expectation_met"] for r in results))

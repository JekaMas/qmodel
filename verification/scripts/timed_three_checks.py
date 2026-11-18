"""Timed three-trade safety simulations and exact fault witnesses."""
import argparse
from concurrent.futures import ThreadPoolExecutor

from evidence import QUINT, ROOT, execute
from repeated_checks import abort_record, apply_cash, book, chain, dispatcher, prepared, proof, stage
from three_checks import RUNTIME, WORKLOAD, source_closure

TIMED = WORKLOAD / "timed_three.qnt"


def replay_dispatcher():
    # Use the actual primitive dispatcher from the repeated workload. Bind its
    # steps to the extra clock state and protect delivery with the timed route.
    definition = dispatcher().replace("action executeEvent(", "action executeCore(", 1)
    for primitive in ("deliver", "deliverUnadmitted"):
        anchor = f"{primitive}(e._2,e._3)"
        if definition.count(anchor) != 1:
            raise ValueError(f"Changed dispatcher route: {primitive}")
        definition = definition.replace(anchor, f"all {{connected(e._3),{anchor}}}", 1)
    definition = definition.replace("executeEvent(events.nth(i))", "executeTimed(events.nth(i))", 1)
    return definition + "  action executeTimed(e:(int,int,int,int)):bool = all {executeCore(e),clock'=clock}\n"


def test_source(pairs):
    base = TIMED.read_text().rstrip()
    base = base[:-1].replace("module timed_three {", "module timed_three_test {", 1)
    base += replay_dispatcher()
    pairs_ready = chain("start.expect(sequenceSafe)", [*prepared(1), *prepared(2)])
    if pairs == 2:
        contender = chain(pairs_ready, ["sign(3,0)", "sign(3,1)"])
        definitions = {
            "contender": contender,
            "ThirdSecurityReservationDeniedTest": "contender.expect(s.ownerA==4 and reservedA(s)==4).then(all {openA(3),clock'=clock}.fail())",
            "ThirdCashReservationDeniedTest": "contender.expect(s.ownerB==6 and reservedB(s)==6).then(all {prepareB(3),clock'=clock}.fail())",
        }
    else:
        base += """
  def allPending(t:int):bool = s.trades.get(t).holdA==1 and s.trades.get(t).holdB==1
  def applied(t:int):bool = s.receivedA.get(t)==2 and s.receivedB.get(t)==3 and
    evidenceBackedBooking(s,desc(t))
"""
        held = chain(pairs_ready, prepared(3))
        pre_fault = chain("held", [*proof(1,2), "commit(1)", *proof(1,3)[:-1],
                                    *proof(2,2)[:-1], "compromiseTransport"])
        outage = "inFlight.then(stop(1,2)).then(stop(3,1)).then(partitionLink(1,3)).then(partitionLink(2,3)).expect(sequenceSafe)"
        expiry = "outage.then(blockA).then(advance).then(blockA).then(restart(3)).then(advance).then(blockA)"
        expired = chain(expiry, ["abort(2)", *proof(2,4)[:-1]]) + (
            ".expect(s.height==3 and s.trades.get(2).decision==3 and not(s.up.contains(1)) and not(connected(4)))"
        )
        restored = "expired.then(advance).then(restart(1)).expect(sequenceSafe and connected(2) and connected(4))"
        old_proofs = chain("restored", ["deliver(2,2)", "deliver(2,4)", "learn(2,3,1)", "refund(2,0)",
                                        "refund(2,1)", *abort_record(2)])
        completed = chain("oldResolved", [
            "lose(1,3)", "resend(1,3)", "deliver(1,3)", "learn(1,2,1)", "applyB(1)", "deliver(1,3)",
            *book(1), *proof(3,2), "commit(3)", *apply_cash(3), *book(3),
        ])
        definitions = {
            "held": held + ".expect(Trades.forall(t=>allPending(t)) and reservedA(s)==6 and reservedB(s)==9)",
            "inFlight": pre_fault,
            "outage": outage,
            "expired": expired,
            "restored": restored,
            "oldResolved": old_proofs,
            "ThreeConcurrentHoldsTest": "held",
            "TooEarlyRestartTest": "outage.expect(not(s.up.contains(1)) and clock.slot==0).then(restart(1).fail())",
            "PartitionWithholdsValidPreparationTest": "outage.expect(s.network.contains(fact(2,2))).then(all {connected(2),deliver(2,2),clock'=clock}.fail())",
            "PartitionWithholdsAbortTest": "expired.expect(s.network.contains(fact(2,4))).then(all {connected(4),deliver(2,4),clock'=clock}.fail())",
            "DeadlineAndProofRaceTest": "restored.then(all {deliver(2,2),clock'=clock}).expect(has(s,2,2)).then(all {commit(2),clock'=clock}.fail())",
            "RealForeignProofRejectedTest": (
                "oldResolved.then(hostile(2,2,0)).then(hostile(3,2,11)).expect(allPending(3) and has(s,2,2) and "
                "not(has(s,3,2)) and s.received.exists(f=>f.d.trade==4)).then(all {commit(3),clock'=clock}.fail())"
            ),
            "UnknownOutcomeCannotOverwriteKnowledgeTest": (
                "oldResolved.expect(s.trades.get(2).knownB==3 and has(s,2,4)).then(all {learn(2,0,1),clock'=clock}.fail())"
            ),
            "OverlapCrashPartitionMaliceAndRecoveryTest": completed + (
                ".expect(applied(1) and applied(3) and s.trades.get(2).refundsA==1 and s.trades.get(2).refundsB==1"
                " and evidenceBackedBooking(s,desc(2)) and s.financialRecords.size()==3 and s.ownerA==2 and s.ownerB==3)"
            ),
            "IndependentClockAndPermanentAStopTest": (
                "start.then(stop(0,forever)).then(blockB).then(3.reps(_=>advance.then(blockB)))"
                ".expect(s.height==0 and clock.slot==3 and clock.heightB==4 and sequenceSafe).then(restart(0).fail())"
            ),
            "ByteExactPhaseRootsTest": "start.expect(tuples(Trades,0.to(6)).map(pair=>fact(pair._1,pair._2).root).size()==21)",
        }
    return (base + "".join(f"  run {name} = {expr}\n" for name, expr in definitions.items()) + "}\n").encode()


def directed(pairs):
    directory = RUNTIME / f"timed-{pairs}"
    stage(directory, {**source_closure(pairs, timed=True), "timed_three_test.qnt": test_source(pairs)})
    return execute(
        f"three-timed-directed-{pairs}",
        [QUINT,"test",str((directory/"timed_three_test.qnt").relative_to(ROOT)),"--main","timed_three_test",
         "--backend","rust","--seed","61","--match",".*Test"],
        claim="Timed outages, distinct deadlines, cross-trade proofs, contention and combined real settlement",
        seconds=180, config={"trades":3,"funded_pairs":pairs},
    )


def simulate(seed):
    directory = RUNTIME / "timed-samples"
    relative = str((directory/"timed_three.qnt").relative_to(ROOT))
    return execute(
        f"three-timed-sample-{seed}",
        [QUINT,"run",relative,"--main","timed_three","--init","start","--step","timedStep","--backend","rust",
         "--invariant","sequenceSafe","--max-samples","600","--max-steps","120","--seed",str(seed),"--verbosity","1"],
        claim="Timed three-trade safety with source outages, directed partitions and bounded hostile inputs",
        seconds=600, backend="simulation", config={"trades":3,"funded_pairs":3,"samples":600,"steps":120,"seed":seed},
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("directed","sample"))
    if parser.parse_args().mode == "directed":
        results = [directed(pairs) for pairs in (3,2)]
    else:
        stage(RUNTIME/"timed-samples",{**source_closure(3,timed=True),"timed_three.qnt":TIMED.read_bytes()})
        with ThreadPoolExecutor(max_workers=3) as pool:
            results=list(pool.map(simulate,(61,62,63)))
    raise SystemExit(not all(r["expectation_met"] for r in results))

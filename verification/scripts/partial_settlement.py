"""Complete all pairs of local reservation orders on the current short-funded source."""
from itertools import permutations

from block_checks import Profile, source


def quint_set(ids):
    return "Set(" + ",".join(str(i) for i in sorted(ids)) + ")"


def scenario(order_a, order_b):
    # Each leg can pay for its first two reservations. Expected settlement is
    # computed from requested order, independently of the ledger's disposition.
    winners = (set(order_a[:2]), set(order_b[:2]))
    commits = winners[0] & winners[1]
    aborts = set(order_a) - commits
    steps = ["signedPC.reps(_=>blockStep)"]

    def local(action):
        steps.append(f"localStep({action})")

    for leg in range(2):
        local(f"openBlock({leg},Reserve,Ids)")
    for a,b in zip(order_a,order_b):
        local(f"executeTx(0,{a})")
        local(f"executeTx(1,{b})")
    for leg in range(2):
        local(f"sealBlock({leg})")
    before = [f"lane({leg}).applied=={quint_set(wins)}" for leg,wins in enumerate(winners)]
    reservation_check = "".join(f"\n    .then({action})" for action in steps)
    reservation_check += ".expect(blockSound and " + " and ".join(before) + ")"
    steps.clear()
    for t in sorted(commits):
        steps.append(f"publish({t},2)")
    for leg,order in enumerate((order_a,order_b)):
        local("nextA" if leg==0 else "nextB")
        local(f"openBlock({leg},Settle,{quint_set(commits)})")
        for t in order:
            if t in commits:
                local(f"executeTx({leg},{t})")
        local(f"sealBlock({leg})")
        if leg==0:
            for t in sorted(commits):
                steps.append(f"publish({t},3)")
                local(f"takeOutcome({t})")
    for t in sorted(commits):
        for leg in range(2):
            steps.append(f"publish({t},{leg+5})")
            local(f"observeEffect({t},{leg})")
        local(f"bookTrade({t})")
    local("nextA")
    for t in sorted(aborts):
        local(f"expire({t})")
        steps.append(f"publish({t},4)")
        local(f"takeAbort({t})")
        for leg in range(2):
            if t in winners[leg]:
                local(f"releaseHold({t},{leg})")
            local(f"readDisposition({t},{leg})")
        local(f"bookAbort({t})")
    end = ["economicSound","blockSound","sourceState.financialRecords.size()==3",
           "Ids.forall(t=>evidenceBackedBooking(sourceState,tradeTerms(t)))",
           f"Ids.filter(t=>sourceState.trades.get(t).decision==2)=={quint_set(commits)}",
           f"Ids.filter(t=>sourceState.trades.get(t).decision==3)=={quint_set(aborts)}",
           f"free(sourceState,0)=={4-2*len(commits)}", f"free(sourceState,1)=={6-3*len(commits)}"]
    label = "_".join("".join(map(str,order)) for order in (order_a,order_b))
    return f"  run Bilateral{label}Test=blockInit" + reservation_check + "".join(f"\n    .then({s})" for s in steps) + "\n    .expect("+" and ".join(end)+")\n"


def closure():
    files = source(Profile(pairs_a=2,pairs_b=2))
    model = files["funded_blocks.qnt"].decode().rstrip()
    if not model.endswith("}"):
        raise ValueError("Incomplete funded-block module")
    helpers = """
  action localStep(op:bool):bool=all {op,pc'=pc}
  action publish(t:int,p:int):bool=localStep(finalizeSealed(t,p))
    .then(localStep(proofJob(t,p,1))).then(localStep(proofJob(t,p,2))).then(localStep(proofJob(t,p,3)))
"""
    orders = list(permutations((1,2,3)))
    cases = "".join(scenario(a,b) for a in orders for b in orders)
    files["funded_blocks.qnt"] = (model[:-1]+helpers+cases+"}\n").encode()
    return files


def recovery_closure():
    """One overlap (trade 2), with or without timely proof, then an actual B outage."""
    files = source(Profile(pairs_a=2,pairs_b=2))
    block = files["dvp_blocks.qnt"].decode().rstrip()
    files["dvp_blocks.qnt"] = (block[:-1] + """
  action pauseB=all {ledger::crash(1),blocks'=blocks}
  action resumeB=all {ledger::recover(1),blocks'=blocks}
}
""").encode()
    module = files["funded_blocks.qnt"].decode().rstrip()[:-1]
    module += """
  action local(op:bool):bool=all {op,pc'=pc}
  action publish(t:int,p:int):bool=local(finalizeSealed(t,p))
    .then(local(proofJob(t,p,1))).then(local(proofJob(t,p,2))).then(local(proofJob(t,p,3)))
  run held=blockInit.then(signedPC.reps(_=>blockStep))
    .then(local(openBlock(0,Reserve,Ids))).then(local(openBlock(1,Reserve,Ids)))
    .then(local(executeTx(0,1))).then(local(executeTx(0,2))).then(local(executeTx(0,3)))
    .then(local(executeTx(1,2))).then(local(executeTx(1,3))).then(local(executeTx(1,1)))
    .then(local(sealBlock(0))).then(local(sealBlock(1)))
    .expect(lane(0).applied==Set(1,2) and lane(1).applied==Set(2,3))
"""
    def steps(actions):
        return "".join(f"\n    .then({a})" for a in actions)

    for timely,label in ((True,"LateApplication"),(False,"LatePreparation")):
        seq=[]
        if timely:
            seq += ["publish(2,2)","local(nextA)","local(openBlock(0,Settle,Set(2)))",
                    "local(executeTx(0,2))","local(sealBlock(0))","local(pauseB)","local(nextA)"]
        else:
            seq += ["local(pauseB)","local(nextA)","local(nextA)"]
        aborts = (1,3) if timely else (1,2,3)
        for t in aborts:
            seq += [f"local(expire({t}))",f"publish({t},4)"]
        stopped="sourceState.height==deadline and not(sourceState.up.contains(1)) and sourceState.financialRecords.size()==0"
        prefix=steps(seq)+f"\n    .expect({stopped} and sourceState.receivedB.get(2)==0)"
        seq=["local(resumeB)"]
        if timely:
            seq += ["publish(2,3)","local(takeOutcome(2))","local(nextB)","local(openBlock(1,Settle,Set(2)))",
                    "local(executeTx(1,2))","local(sealBlock(1))","publish(2,5)","publish(2,6)",
                    "local(observeEffect(2,0))","local(observeEffect(2,1))","local(bookTrade(2))"]
        else:
            seq += ["publish(2,2)"]  # Authentically late; the ABORT must survive.
        for t in aborts:
            seq += [f"local(takeAbort({t}))"]
            for leg,winners in enumerate(((1,2),(2,3))):
                if t in winners:
                    seq += [f"local(releaseHold({t},{leg}))"]
                seq += [f"local(readDisposition({t},{leg}))"]
            seq += [f"local(bookAbort({t}))"]
        cash=3 if timely else 0
        outcome=2 if timely else 3
        module += f"  run {label}AfterShortFundedOutageTest=held"+prefix+steps(seq)+f"""
    .expect(economicSound and blockSound and sourceState.financialRecords.size()==3 and
      Ids.forall(t=>evidenceBackedBooking(sourceState,tradeTerms(t))) and
      sourceState.trades.get(2).decision=={outcome} and sourceState.receivedB.get(2)=={cash} and
      free(sourceState,0)=={2 if timely else 4} and free(sourceState,1)=={6-cash})
"""
    files["funded_blocks.qnt"]=(module+"}\n").encode()
    return files

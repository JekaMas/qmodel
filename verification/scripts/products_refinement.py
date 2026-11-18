"""Compare actual source actions with the population-independent kernel equations."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import re

from evidence import QUINT,ROOT,execute
from products_hostile import RUNTIME
from products_placement import closure as placed
from products_population import FIELDS,kernel
from repeated_checks import EVENTS,stage

RUNS={f"products-refinement-{name}":(host,3) for host,name in enumerate(("a","b","d","shared"))}
RUNS["products-refinement-expanded"]=(0,5)
EXTRA={"registerDecision":len(EVENTS),"applyA":len(EVENTS)+1}


def translate(formula):
    """Translate the small, closed kernel guard/update expression language."""
    tokens=iter(re.findall(r"\(|\)|[^()\s]+",str(formula)))
    def expression(token):
        if token!="(":
            return token
        op=next(tokens)
        operands=[]
        for item in tokens:
            if item==")":
                break
            operands.append(expression(item))
        if op in FIELDS and operands==["before"]:
            return f"old.{op}"
        if op=="ite":
            return f"(if({operands[0]}) {operands[1]} else {operands[2]})"
        if op=="not":
            return f"not({operands[0]})"
        mid={"=":"==",">":">","<":"<",">=":">=","<=":"<=","-":"-","+":"+",
             "and":"and","or":"or"}[op]
        return "(" + (" "+mid+" ").join(operands) + ")"
    return expression(next(tokens))


def projected_source():
    names=tuple(kernel())
    method=lambda name: names.index(name)
    mappings={
        "openA":str(method("hold-security")),
        "prepareB":str(method("hold-cash")),
        "deliver":f"(if(e._3==1) {method('authorize-prepared-security')} else if(e._3==2) {method('authorize-prepared-cash')} else -1)",
        "commit":str(method("commit")),
        "abort":str(method("abort")),
        "learn":f"(if(e._4==0) {method('learn-a')} else {method('learn-b')})",
        "refund":f"(if(e._3==0) {method('release-a')} else {method('release-b')})",
        "spend":f"(if(e._2==0) {method('ordinary-spend-a')} else {method('ordinary-spend-b')})",
        "applyB":str(method("apply-b")),
        "reconcile":str(method("book-commit")),
        "recordAbort":str(method("book-abort")),
        **{name:str(method(op)) for name,op in (("registerDecision","register-remote"),("applyA","apply-a"))},
    }
    ids={**EVENTS,**EXTRA}
    classify="  pure def classOf(e:(int,int,int,int)):int =\n"
    for operation,expr in mappings.items():
        classify+=f"    if(e._1=={ids[operation]}) {expr} else\n"
    classify+="    -1\n"
    row="{"+",".join(f"{name}:int" for name in FIELDS)+"}"
    one_spend=ids["spend"]
    zero_row="{"+",".join(f"{name}:0" for name in FIELDS)+"}"
    compare=f"""
  type Row={row}
  pure def observeRow(x:State,t:int):Row = {{
    val z=x.trades.get(t)
    {{decision:z.decision,holdA:z.holdA,holdB:z.holdB,paidA:z.effectsA,paidB:z.effectsB,
      refundA:z.refundsA,refundB:z.refundsB,knownA:z.knownA,knownB:z.knownB,
      proofA:if(receivedFact(x,desc(t),1)) 1 else 0,proofB:if(receivedFact(x,desc(t),2)) 1 else 0,
      booking:if(x.financialRecords.contains({{d:desc(t),outcome:2}})) 2
              else if(x.financialRecords.contains({{d:desc(t),outcome:3}})) 3 else 0}}
  }}
  type Frame={{rows:int->Row,ownerA:int,ownerB:int,spentA:int,spentB:int}}
  var prior:Frame
  pure def frame(x:State):Frame={{rows:Trades.mapBy(u=>observeRow(x,u)),ownerA:x.ownerA,
    ownerB:x.ownerB,spentA:x.spentA,spentB:x.spentB}}
  action framedInit=all {{init,prior'={{rows:Trades.mapBy(_=>{zero_row}),
    ownerA:6,ownerB:9,spentA:0,spentB:0}}}}
  action observeStep(e:(int,int,int,int)):bool = all {{executeEvent(e),prior'=frame(s)}}
  pure def legitimate(before:Frame,after:State,e:(int,int,int,int)):bool = {{
    val k=classOf(e)
    val spending=e._1=={one_spend}
    val t=if(k== -1 or spending) 1 else e._2
    val old=before.rows.get(t)
    val localA=HOST==0 or HOST==3
    val localB=HOST==1 or HOST==3
    val amountA=if(spending) 1 else desc(t).security
    val amountB=if(spending) 1 else desc(t).cash
    val ownA=before.ownerA
    val ownB=before.ownerB
    val reservedA=Trades.fold(0,(n,u)=>n+(if(before.rows.get(u).holdA==1) desc(u).security else 0))
    val reservedB=Trades.fold(0,(n,u)=>n+(if(before.rows.get(u).holdB==1) desc(u).cash else 0))
"""
    present={
        "holdA","holdB","knownA","knownB","decision","proofA","proofB",
        "paidA","paidB","refundA","refundB","booking",
    }
    for i,(name,transition) in enumerate(kernel().items()):
        change=",".join(f"{field}:{translate(value)}" for field,value in transition.updates.items() if field in present)
        output="{...old,"+change+"}" if change else "old"
        predicate="    if" if i==0 else "    else if"
        compare+=f"{predicate}(k=={i}) {{\n"
        compare+=f"      val expected={output}\n"
        compare+="      and {\n"
        compare+=f"        {translate(transition.guard)},\n"
        compare+=f"        after.ownerA==ownA-{translate(transition.move[0])}-{translate(transition.spend[0])},\n"
        compare+=f"        after.ownerB==ownB-{translate(transition.move[1])}-{translate(transition.spend[1])},\n"
        compare+=f"        after.spentA==before.spentA+{translate(transition.spend[0])},\n"
        compare+=f"        after.spentB==before.spentB+{translate(transition.spend[1])},\n"
        compare+="        Trades.forall(u=>observeRow(after,u)==(if(u==t) expected else before.rows.get(u)))\n      }\n    }\n"
    compare+="    else Trades.forall(u=>observeRow(after,u)==before.rows.get(u)) and after.ownerA==ownA and after.ownerB==ownB\n  }\n"
    return classify+compare


def closure(host,size):
    data=placed(host,"directed")
    text=data["placement.qnt"].decode()
    # Add the non-reference actions to the generic workload dispatcher.
    anchor="  action executeEvent(e:(int,int,int,int)):bool = any {"
    extra="".join(f"\n    all {{e._1=={ids}, {op}(e._2)}}," for op,ids in EXTRA.items())
    text=text.replace(anchor,anchor+extra,1)
    for op,ids in EXTRA.items():
        text=re.sub(rf"\.then\({op}\((\d+)\)\)",rf".then(replayEvents(List(({ids},\1,0,0))))",text)

    text=re.sub(r"\.then\(learn\((\d+),2,0\)\)",
                rf".then(replayEvents(List(({EVENTS['learn']},\1,2,0))))",text)
    # Record the pre-state in a ghost variable in the actor's atomic step. It
    # is materialized before .expect evaluates the actual successor.
    text=text.replace("    executeEvent(events.nth(i)).expect(sequenceSafe and",
                      "    observeStep(events.nth(i)).expect(sequenceSafe and legitimate(prior,s,events.nth(i)) and",1)
    if size>3:
        text=text.replace("import dvp(N=3,",f"import dvp(N={size},",1)
        text=text.replace("Trades.forall(t=>s.trades.get(t).holdA==1","Set(1,2,3).forall(t=>s.trades.get(t).holdA==1")
        text=text.replace("Trades.forall(t=>evidenceBackedBooking(s,desc(t)))","Set(1,2,3).forall(t=>evidenceBackedBooking(s,desc(t)))")
        data["dvp.qnt"]=data["dvp.qnt"].replace(b"List(2,3,5).nth(t-1)",b"(if(t<=3) List(2,3,5).nth(t-1) else 5)")
        from repeated_checks import chain
        text=text.rstrip()[:-1]+"\n  run ExpandedPopulationIdentityTest = "+chain("init",[
            "sign(5,0)","sign(5,1)","openA(5)","prepareB(5)","finalize(5,2)","capture(5,2)","prove(5,2)","deliver(5,2)","commit(5)",
        ])+".expect(s.trades.get(5).decision==2 and s.trades.get(1).decision==0)\n}\n"
    from repeated_checks import chain
    spend_probe=chain("init",["spend(0)","spend(1)"])
    text=text.rstrip()[:-1]+"\n  run IndependentSpendDeltaTest="+spend_probe+".expect(s.spentA==1 and s.spentB==1)\n}\n"
    text=re.sub(r"(run \w+\s*=\s*)init\b",r"\1framedInit",text)
    # Negative guard tests and the deliberate owner stop are explicit calls
    # outside the replay list. Frame the observer variable at these endpoints.
    text=re.sub(r"\.then\((\w+\([0-9,]+\))\.fail\(\)\)",
                r".then(all {\1,prior'=prior}.fail())",text)
    text=re.sub(r"\.then\((crash\(\d+\))\)",r".then(all {\1,prior'=prior})",text)
    text=text.rstrip()[:-1]+projected_source()+"}\n"
    data["placement.qnt"]=text.encode()
    return data


def check(name):
    host,size=RUNS[name]
    folder=RUNTIME/name
    stage(folder,closure(host,size))
    return execute(name,[QUINT,"test",str((folder/"placement.qnt").relative_to(ROOT)),"--main","placement_products",
                         "--backend","rust","--seed","71","--match",".*Test"],
                   claim="Actual placement actions refine independent arbitrary-population kernel equations",
                   seconds=120,config={"host":host,"population":size})


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases",nargs="*")
    with ThreadPoolExecutor(max_workers=2) as pool:
        results=list(pool.map(check,parser.parse_args().cases or RUNS))
    raise SystemExit(not all(r["expectation_met"] for r in results))

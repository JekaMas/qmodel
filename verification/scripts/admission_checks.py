"""Current DvP checks. Every receipt is bound to its live, reproducible input closure."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass
import json
from pathlib import Path
from tempfile import NamedTemporaryFile
import re

from audit_evidence import EvidenceError, validate
from evidence import QUINT, ROOT, execute, inputs
from guarantee_checks import JVM, PROFILES
import block_checks
import partial_settlement
import guarantee_scenarios
from guarantee_audit import graph
import policy_checks
import repeated_checks
import three_attack_checks
import three_matrix_checks
import three_deadline_checks
import three_recovery_checks
import timed_three_checks
import products_placement
import products_refinement
import products_hostile
import products_authority
import products_clocks
import products_contract
import products_interleavings
from three_checks import source_closure

RUNTIME = ROOT/"verification/results/runtime/admitted"
INDEX = ROOT/"verification/configs/admission-acceptance.json"


@dataclass(frozen=True)
class Case:
    name: str
    command: tuple
    claim: str
    expected: str = "pass"
    backend: str = "cli"
    seconds: int = 180
    tests: tuple = ()


def generated(name,files,entry):
    folder=RUNTIME/name
    folder.mkdir(parents=True,exist_ok=True)
    for file,data in files.items():
        target=folder/file
        if target.exists() and target.read_bytes()==data:
            continue
        with NamedTemporaryFile(dir=folder,delete=False) as staged:
            staged.write(data)
        Path(staged.name).replace(target)
    return str((folder/entry).relative_to(ROOT))


def directed(name,path,module):
    source=(ROOT/path).read_text()
    pattern=rf"^module {re.escape(module)}\s*\{{(.*?)(?=^module |\Z)"
    body=re.search(pattern,source,re.M|re.S).group(1)
    names=tuple(re.findall(r"^\s*run\s+(\w+Test)\s*=",body,re.M))
    if not names or len(names)!=len(set(names)):
        raise ValueError(f"Empty or duplicated scenarios for {module}")
    args=(QUINT,"test",path,"--main",module,"--backend","rust","--seed","17","--match",".*Test","--max-samples","1")
    return Case(name,args,"All named "+module+" scenarios",tests=names)


def finite(name,path,module,initial,step,goal,temporal=None,expected="pass",config="tlc.json"):
    args=(QUINT,"verify",path,"--main",module,"--backend","tlc","--init",initial,"--step",step,
          "--invariant",goal,"--tlc-config","verification/configs/"+config,"--verbosity","3")
    if not name.startswith("vgr-") and name not in {"live-two","live-recovery"}:
        args+=("--server-endpoint","localhost:18852")
    if temporal:
        args+=("--temporal",temporal)
    return Case(name,args,goal,expected,"tlc",14400 if name=="live-two" else 5400 if name=="mixed-progress" else 1800)


def sampled(name,path,module,initial,step,goal,seed,samples,steps):
    args=(QUINT,"run",path,"--main",module,"--backend","rust","--init",initial,"--step",step,
          "--invariant",goal,"--seed",str(seed),"--max-samples",str(samples),"--max-steps",str(steps),"--verbosity","1")
    return Case(name,args,goal,backend="simulation",seconds=1200)


def cases():
    result=[]
    # Existing tests whose owning financial source changed, plus the review cases.
    roots={"dvp.qnt","mechanisms.qnt","audit_scope.qnt","membership.qnt"}
    for file in sorted((ROOT/"verification/tests").glob("*.qnt")):
        path=str(file.relative_to(ROOT))
        affected=any(Path(p).name in roots for p in inputs([path]))
        if not affected:
            continue
        for m in re.finditer(r"^module (\w+)\s*\{(.*?)(?=^module |\Z)",file.read_text(),re.M|re.S):
            if re.search(r"\brun\s+\w+Test\s*=",m[2]):
                result.append(directed("test-"+m[1],path,m[1]))
    for source_module in products_authority.TESTS.values():
        result.append(directed("test-"+source_module,products_authority.SOURCE,source_module))
    # Re-exercise multi-trade actions with the new core and the source-bound
    # controls. The retained release remains a separate evidence scope.
    def add_generated(name,files,entry,module):
        result.append(directed(name,generated(name,files,entry),module))
    for control in guarantee_scenarios.CONTROL_CASES:
        add_generated("vgr-control-"+control,guarantee_scenarios.control_sources(control),"probe.qnt","probe")
    for control,goal in policy_checks.NEGATIVES.items():
        key="policy-control-"+control
        path=generated(key,policy_checks.control_sources(control),"policy_history.qnt")
        result.append(finite(key,path,"policy_history","initial","observedStep",goal,expected="counterexample"))
    for name,(text,_) in repeated_checks.batches().items():
        add_generated(name,{**repeated_checks.sources(),"repeated_test.qnt":text},"repeated_test.qnt","repeated_test")
    timed=source_closure(3,timed=True)
    for name,(text,_) in {**three_matrix_checks.batches(),**three_attack_checks.batches(),
                           three_deadline_checks.RUN:three_deadline_checks.cases()}.items():
        add_generated(name,{**timed,"timed_three_test.qnt":text},"timed_three_test.qnt","timed_three_test")
    for pairs in (2,3):
        add_generated("timed-"+str(pairs),{**source_closure(pairs,timed=True),"timed_three_test.qnt":timed_three_checks.test_source(pairs)},
                      "timed_three_test.qnt","timed_three_test")
    add_generated("mixed-recovery",{**timed,"three_recovery.qnt":three_recovery_checks.recovery_witness_source()},
                  "three_recovery.qnt","three_recovery")
    for host,placement in products_placement.PLACES.items():
        for mode in ("directed","mutant"):
            add_generated("placement-"+placement+"-"+mode,products_placement.closure(host,mode),"placement.qnt","placement_products")
    for name,(host,size) in products_refinement.RUNS.items():
        add_generated(name.removeprefix("products-"),products_refinement.closure(host,size),"placement.qnt","placement_products")
    add_generated("jobs-directed",products_hostile.closure(0,True),"jobs.qnt","job_products")
    for mode in range(6):
        name="history-"+str(mode)
        path=generated(name,products_contract.closure(mode),"history.qnt")
        result.append(directed(name,path,"contract_products"))
    name="clock-directed"
    path=generated(name,products_clocks.closure(0,True),"clocks.qnt")
    result.append(directed(name,path,"clock_products"))
    name="bilateral-orders"
    path=generated(name,partial_settlement.closure(),"funded_blocks.qnt")
    result.append(directed(name,path,"funded_blocks"))
    add_generated("bilateral-recovery",partial_settlement.recovery_closure(),"funded_blocks.qnt","funded_blocks")
    for key,profile in block_checks.CASES.items():
        name="block-"+key
        path=generated(name,block_checks.source(profile),"funded_blocks.qnt")
        if profile.directed:
            result.append(directed(name,path,"funded_blocks"))
        else:
            prop="includedProgress" if profile.expected=="pass" else None
            result.append(finite(name,path,"funded_blocks","blockInit","blockStep","sound",prop,profile.expected))
    result.append(sampled("guarantees-sample","verification/models/guarantee_profiles.qnt","guarantee_two",
                          "init","adversarialStep","guarantees",17,10000,100))
    for host,placement in products_placement.PLACES.items():
        key="placement-"+placement+"-sample"
        path=generated(key,products_placement.closure(host,"sample"),"placement.qnt")
        result.append(sampled(key,path,"placement_products","init","placementStep","sequenceSafe",71,600,120))
    path=generated("timed-sample",{**timed,"timed_three.qnt":three_recovery_checks.TIMED.read_bytes()},"timed_three.qnt")
    for seed in (61,62,63):
        result.append(sampled(f"timed-sample-{seed}",path,"timed_three","start","timedStep","sequenceSafe",seed,600,120))
    path=generated("repeated-sample",{**repeated_checks.sources(),"repeated.qnt":repeated_checks.WORKLOAD.read_bytes()},"repeated.qnt")
    for seed in range(41,51):
        result.append(sampled(f"repeated-sample-{seed}",path,"repeated","init","operational","sequenceSafe",seed,1000,150))
    path=generated("mixed-progress",{**timed,"three_recovery.qnt":three_recovery_checks.recovery_source()},"three_recovery.qnt")
    result.append(finite("mixed-progress",path,"three_recovery","recoveryInit","recoveryStep","sequenceSafe",
                         "recoveryProgress",config="extended-tlc8.json"))
    for name,(mode,goal,expected,temporal) in products_hostile.CASES.items():
        key=name.removeprefix("products-")
        path=generated(key,products_hostile.closure(mode),"jobs.qnt")
        result.append(finite(key,path,"job_products","jobInit","jobStep",goal,temporal,expected,config="extended-tlc.json"))
    cutover="verification/models/admission_cutover.qnt"
    result.append(directed("cutover-scenarios",cutover,"cutover_scenarios"))
    result.append(finite("cutover",cutover,"cutover_strict","init","step","safety","governedProgress"))
    result.append(finite("cutover-early",cutover,"cutover_early","init","step","noLateFirst",expected="counterexample"))
    history="verification/models/admission_history.qnt"
    result.append(finite("epoch-cut",history,"admission_history","initial","historyStep","priorFinality"))
    # A deliberately obsolete live-epoch guard is a discriminator for the
    # independent prior-cut observer. Import paths resolve in a separate closure.
    core=(ROOT/"verification/models/dvp.qnt").read_text()
    guard="x.admitted and desc(t).epoch==x.epoch"
    if core.count(guard)!=1:
        raise ValueError("Expected exact live credential check")
    files={"dvp.qnt":core.replace(guard,"x.admitted").encode(),
           "economic_effects.qnt":(ROOT/"verification/models/economic_effects.qnt").read_bytes(),
           "admission_history.qnt":(ROOT/history).read_bytes()}
    path=generated("obsolete-admission",files,"admission_history.qnt")
    result.append(finite("obsolete-admission",path,"admission_history","initial","historyStep","priorFinality",expected="counterexample"))
    requirement="(p!=1 and p!=2) or s.finalized.contains(fact(t,p)) or reserveAuthority(s,t,p-1)"
    if core.count(requirement)!=1:
        raise ValueError("Expected finalized-preparation continuation guard")
    files["dvp.qnt"]=core.replace(requirement,"true").encode()
    path=generated("unproved-finalization",files,"admission_history.qnt")
    result.append(finite("unproved-finalization",path,"admission_history","initial","historyStep",
                         "newFinalsAuthenticated",expected="counterexample"))
    result.append(finite("policy","verification/models/policy_history.qnt","policy_history","initial","observedStep","historySound"))
    result.append(finite("report-cursor","verification/models/audit_scope.qnt","audit_safe","init","step","safe"))
    source=ROOT/"verification/models/audit_scope.qnt"
    original=source.read_text()
    anchor="knownHead:if(n>h.knownHead) n else h.knownHead"
    if original.count(anchor)!=1:
        raise ValueError("Missing latest cursor guard")
    path=generated("rewound-cursor",{source.name:original.replace(anchor,"knownHead:n").encode()},source.name)
    result.append(finite("rewound-cursor",path,"audit_safe","init","step","exactCursor",expected="counterexample"))
    result.append(finite("committee","verification/models/mechanisms.qnt","committee_honest","init","step","safe","committeeProgress"))
    result.append(finite("committee-unbacked","verification/models/mechanisms.qnt","committee_compromised",
                         "init","step","backed",expected="counterexample"))
    for name,(mode,goal,verdict) in products_clocks.CASES.items():
        key=name.replace("products-","")
        path=generated(key,products_clocks.closure(mode),"clocks.qnt")
        result.append(finite(key,path,"clock_products","rateInit","rateStep",goal,expected=verdict,config="extended-tlc.json"))
    for name,(module,goal,verdict) in products_authority.CASES.items():
        result.append(finite(name.replace("products-",""),products_authority.SOURCE,module,"init","roundStep",goal,expected=verdict))
    path=generated("migration",products_interleavings.closure("products-authority-migration"),"authority_migration.qnt")
    result.append(finite("migration",path,"authority_migration","start","step","safe"))
    files=products_interleavings.closure("products-authority-migration")
    anchor=b"authority_core(MODE=0)"
    if files["authority_migration.qnt"].count(anchor)!=1:
        raise ValueError("Expected strict authority migration")
    files["authority_migration.qnt"]=files["authority_migration.qnt"].replace(anchor,b"authority_core(MODE=4)")
    path=generated("retired-authority",files,"authority_migration.qnt")
    result.append(finite("retired-authority",path,"authority_migration","start","step","acceptedAtCurrentEpoch",expected="counterexample"))
    result.append(finite("live-recovery","verification/models/recovery.qnt","recovery","init",
                         "recoveryStep","safe","recoveryProgress",config="extended-tlc8.json"))
    for name in ("b","d","open","escrow","two"):
        result.append(finite("live-"+name,"verification/models/liveness_variants.qnt","live_"+name,
                             "init","step","safe","progress",config="extended-tlc8.json"))
    result.append(finite("live-reference","verification/models/liveness.qnt","liveness",
                         "init","step","safe","progress",config="extended-tlc8.json"))
    for p in PROFILES:
        result.append(finite("vgr-"+p,"verification/models/guarantee_profiles.qnt","guarantee_"+p,"init",
                             "recoveryStep" if p=="recovery" else "step","guarantees",
                             config="extended-tlc8.json" if p in {"two","recovery"} else "extended-tlc.json"))
    if len({c.name for c in result})!=len(result):
        raise ValueError("Duplicate acceptance case")
    return result


def run(c,force=False):
    if not force and INDEX.is_file():
        selected=json.loads(INDEX.read_text()).get(c.name)
        if selected:
            receipt_file=ROOT/"verification/results/runs"/selected/"receipt.json"
            previous=json.loads(receipt_file.read_text())
            if previous["input_hashes"]==inputs(c.command) and previous["command"][1:]==list(c.command[1:]):
                observation(c,selected)
                print("REUSE",selected,previous["outcome"],flush=True)
                return previous
    if c.backend=="tlc":
        config=c.command[c.command.index("--tlc-config")+1]
        limits=f"TLC heap, stack and workers from {config}; {c.seconds}s timeout"
    else:
        limits=f"Quint Rust evaluator; {c.seconds}s timeout"
    return execute("admitted-"+c.name,list(c.command),claim=c.claim,expected=c.expected,backend=c.backend,
                   seconds=c.seconds,execution_env=JVM if c.backend=="tlc" else None,
                   force=force,resource_limit=limits)


def observation(c,rid):
    if not re.fullmatch(re.escape("admitted-"+c.name)+r"(?:-attempt[1-9]\d*)?",rid):
        raise EvidenceError("Misassigned receipt "+rid)
    file=ROOT/"verification/results/runs"/rid/"receipt.json"
    receipt=json.loads(file.read_text())
    # Installed path is host-specific. Everything following the executable
    # (including module, backend, temporal predicate and scope) is immutable.
    if (receipt["command"][1:]!=list(c.command)[1:] or receipt["claim"]!=c.claim or
        receipt["backend"]!=c.backend or receipt["expected"]!=c.expected or
        receipt["input_hashes"]!=inputs(c.command)):
        raise EvidenceError("Live scope changed: "+rid)
    validate(receipt,file)
    return native_result(c,receipt)


def native_result(c,receipt):
    rid=receipt["id"]
    raw=(ROOT/receipt["raw_output"]).read_text()
    if c.tests:
        names=re.findall(r"^\s*ok\s+(\w+Test) passed",raw,re.M)
        if set(names)!=set(c.tests) or len(names)!=len(c.tests):
            raise EvidenceError("Directed cases differ: "+rid)
    if c.backend=="tlc" and "--temporal" in c.command and "Finished checking temporal properties" not in raw:
        raise EvidenceError("No completed temporal check: "+rid)
    return {"id":rid,"outcome":receipt["outcome"],"states":receipt["distinct_states"],"tests":len(c.tests)}


def audit(checks=None):
    selected=json.loads(INDEX.read_text())
    complete=cases()
    if set(selected)!={c.name for c in complete}:
        raise EvidenceError("Missing or unexpected live proof scopes")
    observed={c.name:observation(c,selected[c.name]) for c in (complete if checks is None else checks)}
    for profile in PROFILES:
        temporal="live-"+profile
        if temporal in observed and "vgr-"+profile in observed:
            graph(profile,selected["vgr-"+profile],comparison=(selected[temporal],True))
    properties=json.loads((ROOT/"verification/properties.json").read_text())
    for prop in properties:
        missing=set(prop.get("current_review_scopes",()))-set(selected)
        if missing:
            raise EvidenceError(f"Unknown current scope for {prop['id']}: {sorted(missing)}")
    return observed


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("group",choices=["directed","finite","sample","audit"])
    parser.add_argument("names",nargs="*")
    args=parser.parse_args()
    if args.group=="audit":
        print(json.dumps(audit(),indent=2))
    else:
        backend={"directed":"cli","finite":"tlc","sample":"simulation"}[args.group]
        selected=[c for c in cases() if c.backend==backend
                  and (not args.names or c.name in args.names)]
        if not selected or (args.names and set(args.names)!={c.name for c in selected}):
            parser.error("Empty or unknown selection")
        if args.group in {"directed","sample"}:
            with ThreadPoolExecutor(max_workers=3) as pool:
                results=list(pool.map(run,selected))
        else:
            results=[run(c) for c in selected]
        raise SystemExit(not all(r["expectation_met"] for r in results))

"""Paired operational history checks, including complete modeled wire metadata."""
from concurrent.futures import ThreadPoolExecutor

from evidence import QUINT,ROOT,execute
from products_hostile import PRODUCT,RUNTIME
from repeated_checks import stage

TESTS={"products-privacy-directed":"products_privacy_test","products-privacy-controls":"products_privacy_mutant_test"}
SAMPLES=(71,72,73)


def closure():
    # Capture the same actual source transition and disclosure implementation.
    pipeline=(ROOT/"verification/models/privacy_pipeline.qnt").read_text()
    edits={
        "World={id:int,position:":"World={id:int,tradeId:int,position:",
        "witness(w:World):Witness={trade:1,":"witness(w:World):Witness={trade:w.tradeId,",
        "initial(world:int,pos:int)":"initial(world:int,pos:int,tradeId:int)",
        "val empty={trade:1,":"val empty={trade:tradeId,",
        "{id:world,position:pos":"{id:world,tradeId:tradeId,position:pos",
        "w.proof.trade==1":"w.proof.trade==w.tradeId",
        "left:initial(1,4),right:initial(2,7)":"left:initial(1,4,1),right:initial(2,7,1)",
    }
    for before,after in edits.items():
        if pipeline.count(before)!=1:
            raise ValueError(f"Changed privacy projection anchor: {before}")
        pipeline=pipeline.replace(before,after)
    return {"privacy.qnt":(PRODUCT/"privacy.qnt").read_bytes(),"privacy_pipeline.qnt":pipeline.encode()}


def check(name,seed=None):
    folder=RUNTIME/name
    stage(folder,closure())
    src=str((folder/"privacy.qnt").relative_to(ROOT))
    if seed is None:
        return execute(name,[QUINT,"test",src,"--main",TESTS[name],"--backend","rust","--seed","71","--match",".*Test"],
                       claim="Actual two-world observations and privacy falsification",seconds=120)
    return execute(name,[QUINT,"run",src,"--main","products_privacy","--init","init","--step","step","--backend","rust",
                         "--invariant","safe","--seed",str(seed),"--max-samples","700","--max-steps","60","--verbosity","1"],
                   backend="simulation",claim="Coupled operational observation histories",seconds=300,
                   config={"seed":seed,"samples":700,"steps":60})


if __name__=="__main__":
    results=[check(name) for name in TESTS]
    if all(r["expectation_met"] for r in results):
        with ThreadPoolExecutor(max_workers=3) as pool:
            results+=list(pool.map(lambda seed:check(f"products-privacy-sample-{seed}",seed),SAMPLES))
    raise SystemExit(not all(r["expectation_met"] for r in results))

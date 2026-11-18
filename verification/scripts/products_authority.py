"""Round-lock checks and separate real transition controls for authority migration."""
import argparse

from evidence import QUINT,ROOT,execute

SOURCE="verification/tests/workloads/products/authority.qnt"
CASES={
    "products-authority-rounds":("products_authority","authoritySafe","pass"),
    "products-authority-reset":("products_reset_locks","sameHeightAgreement","counterexample"),
    "products-authority-mobile":("products_mobile_keys","sameHeightAgreement","counterexample"),
}
TESTS={
    "products-authority-epochs":"products_epoch_test",
    "products-authority-epoch-controls":"products_epoch_mutant_test",
}


def check(name):
    if name in TESTS:
        return execute(name,[QUINT,"test",SOURCE,"--main",TESTS[name],"--backend","rust","--seed","71","--match",".*Test"],
                       claim="Authorized context change, historical verification and signed-boundary controls",seconds=120)
    main,predicate,expected=CASES[name]
    return execute(name,[QUINT,"verify",SOURCE,"--main",main,"--backend","tlc","--init","init",
                         "--step","roundStep","--invariant",predicate,"--tlc-config","verification/configs/tlc.json","--verbosity","3"],
                   claim=predicate,expected=expected,backend="tlc",seconds=350,config={"votes":"final","rounds":2,"threshold":3})


if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases",nargs="*")
    results=[check(name) for name in (parser.parse_args().cases or [*TESTS,*CASES])]
    raise SystemExit(not all(r["expectation_met"] for r in results))

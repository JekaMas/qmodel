"""Observe a fixed-context Byzantine certificate envelope and falsification controls."""
from evidence import QUINT, execute

SOURCE = "verification/models/certificate_envelope.qnt"
CASES = {
    "byzantine-envelope": ("certified_envelope", "safe", "pass"),
    "byzantine-threshold-exceeded": ("equivocation_exceeds_threshold", "unique", "counterexample"),
    "byzantine-foreign-context": ("unbound_certified_context", "boundContext", "counterexample"),
}


def check(run, main, predicate, expected):
    return execute(
        run, [QUINT,"verify",SOURCE,"--main",main,"--backend","tlc",
              "--init","init","--step","step","--invariant",predicate,
              "--tlc-config","verification/configs/tlc.json","--verbosity","3"],
        claim=predicate, expected=expected, backend="tlc", seconds=300,
        config={"fixed_context":True,"validators":4,"threshold":3,"main":main},
    )


if __name__ == "__main__":
    results = [check(run,*case) for run,case in CASES.items()]
    raise SystemExit(not all(r["expectation_met"] for r in results))

"""Exhaustive slices of the actual authority and paired observer actions."""
import argparse
from concurrent.futures import ThreadPoolExecutor

from evidence import QUINT, ROOT, execute
from products_authority import SOURCE
from products_hostile import PRODUCT, RUNTIME
from products_privacy import closure as privacy
from repeated_checks import stage

CASES = {
    "products-authority-migration": ("authority_migration", {"certified_prefix": 5}),
    "products-privacy-exact": ("privacy_exact", {"batch_prefix": 5, "public_choices": 4}),
}


def closure(name):
    module, _ = CASES[name]
    data = {"authority.qnt": (ROOT / SOURCE).read_bytes()} if module == "authority_migration" else privacy()
    return {**data, f"{module}.qnt": (PRODUCT / f"{module}.qnt").read_bytes()}


def check(name):
    module, scope = CASES[name]
    folder = RUNTIME / name
    stage(folder, closure(name))
    return execute(
        name, [QUINT, "verify", str((folder / f"{module}.qnt").relative_to(ROOT)), "--main", module,
               "--backend", "tlc", "--init", "start", "--step", "step", "--invariant", "safe",
               "--tlc-config", "verification/configs/tlc.json", "--verbosity", "3"],
        claim="Actual action interleavings from a reachable protocol prefix",
        seconds=300, backend="tlc", config=scope,
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cases", nargs="*")
    with ThreadPoolExecutor(max_workers=2) as pool:
        results = list(pool.map(check, parser.parse_args().cases or CASES))
    raise SystemExit(not all(result["expectation_met"] for result in results))

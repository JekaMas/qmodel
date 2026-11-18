"""Run historical source-identity checks in their actual published release.

The 367 observations at this revision include assertions about exact old graph
equality and deliberately faulty legacy behavior. The separate live suite checks
the current protocol. A historical audit still reads the consumer's retained
receipts, native logs and snapshots, so edits to those observations are visible.
"""
from functools import lru_cache
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parents[2]
RELEASE = "116bef8e682acaf5fe48865a0463259e1a8d7795"


@lru_cache(maxsize=1)
def release_tree():
    directory = TemporaryDirectory(prefix="qmodel-reviewed-release-")
    base = Path(directory.name)
    # Retain the context for this interpreter. Never modify the caller's checkout.
    release_tree.context = directory
    paths = ["verification", "package-lock.json", "package.json", "openspec",
             ":(exclude)verification/results/runs", ":(exclude)verification/results/traces"]
    with subprocess.Popen(["git", "archive", RELEASE, "--", *paths], cwd=ROOT, stdout=subprocess.PIPE) as arch:
        subprocess.run(["tar", "-x", "-C", str(base)], stdin=arch.stdout, check=True, env={**os.environ,"LC_ALL":"C"})
        if arch.wait():
            raise RuntimeError(f"Missing reviewed Git tree {RELEASE}")
    runs=base/"verification/results/runs"
    runs.mkdir()
    sealed=json.loads((base/"verification/configs/proof-contracts.json").read_text())["observations"]
    for run_id in sealed:
        (runs/run_id).symlink_to(ROOT/"verification/results/runs"/run_id,target_is_directory=True)
    (base/"verification/results/traces").symlink_to(ROOT/"verification/results/traces",target_is_directory=True)
    (base/"verification/results/runtime").mkdir(exist_ok=True)
    for name in ("node_modules",".quint"):
        (base/name).symlink_to(ROOT/name,target_is_directory=True)
    return base


@lru_cache(maxsize=None)
def release_report(script, *args):
    root = release_tree()
    result = subprocess.run([sys.executable,"-B",str(root/"verification/scripts"/script),*args],
                            cwd=root,capture_output=True,text=True)
    if result.returncode:
        raise RuntimeError(f"Historical {script} failed: {result.stderr[-1500:]} {result.stdout[-1500:]}")
    # --fresh prints individual replay reports before the complete summary.
    raw = result.stdout.strip()
    return json.loads(raw[raw.rfind("\n{")+1:]) if args and "--fresh" in args else json.loads(raw)


def check_retained_owners():
    """Previously green, unchanged formal sources must still match the reviewed Git tree."""
    release = release_tree()
    inventory = json.loads((ROOT/"verification/configs/admission-source-owners.json").read_text())
    patterns = ("models/*.qnt", "mutants/**/*.qnt", "generated/**/*.qnt", "tests/**/*.qnt",
                "adapters/**/*.py", "scripts/*.py", "configs/*tlc*.json", "configs/*apalache*.json",
                "configs/*acceptance*.json", "results/manifest.json")
    paths = {p.relative_to(release) for pat in patterns for p in (release/"verification").glob(pat) if p.is_file()}
    paths.update((Path("package-lock.json"),Path("package.json")))
    changed = {}
    for rel in paths:
        data = (ROOT/rel).read_bytes()
        if data != (release/rel).read_bytes():
            changed[str(rel)] = hashlib.sha256(data).hexdigest()
    if changed != inventory:
        raise ValueError("Current verification owners differ from the reviewed change set: " +
                         ", ".join(sorted(k for k in set(changed)|set(inventory) if changed.get(k)!=inventory.get(k))))
    contract=Path("verification/configs/proof-contracts.json")
    original=json.loads((release/contract).read_text())
    current=json.loads((ROOT/contract).read_text())
    original_observations=original.pop("observations")
    current_observations=current.pop("observations")
    if original!=current or any(current_observations.get(key)!=value for key,value in original_observations.items()):
        raise ValueError("Historical evidence contract changed in the current checkout")
    return {"unchanged":len(paths)-len(changed),"revised":len(changed)}


def family_report(script,prefixes):
    """Keep the family report readable and expose its current source-bound checks."""
    from admission_checks import audit, cases
    retained=release_report(Path(script).name)
    selected=[c for c in cases() if c.name.startswith(prefixes)]
    if not selected:
        raise ValueError("Missing current verification family")
    return {**retained,"retained_release":RELEASE,"current_review":audit(selected)}

"""Model-check the new assertions on the existing concrete transitions."""
import argparse
import hashlib

from audit_evidence import EvidenceError, load_latest
from evidence import QUINT, ROOT, execute, inputs

PROFILES = ("reference", "b", "d", "shared", "open", "escrow", "private", "recovery", "two")
SOURCE = "verification/models/guarantee_profiles.qnt"
JVM = {"JAVA_TOOL_OPTIONS": "-Xmx8g -Xss8m", "JVM_ARGS": "-Xmx8g -Xss8m"}


def check(profile):
    step = "recoveryStep" if profile == "recovery" else "step"
    name = f"guarantees-{profile}"
    config = "extended-tlc8.json" if profile in {"recovery", "two"} else "extended-tlc.json"
    cmd = [
        QUINT, "verify", SOURCE, "--main", f"guarantee_{profile}", "--backend", "tlc",
        "--init", "init", "--step", step, "--tlc-config", f"verification/configs/{config}",
        "--verbosity", "3", "--invariant", "guarantees",
    ]
    try:
        _, previous = load_latest(name)
    except EvidenceError:
        previous = None
    if previous and previous["expectation_met"] and previous["command"] == cmd and previous["input_hashes"] == inputs(cmd):
        actual = hashlib.sha256((ROOT / previous["raw_output"]).read_bytes()).hexdigest()
        if actual != previous["raw_sha256"]:
            raise EvidenceError(f"Native output changed: {previous['id']}")
        print("REUSE", previous["id"], flush=True)
        return
    seconds = 10800 if profile == "two" else 1800
    receipt = execute(
        name, cmd, claim=["outcome authority", "COMMIT records", "L04 endpoint implication"],
        backend="tlc", seconds=seconds, config={"profile": profile, "init": "init", "step": step},
        execution_env=JVM, resource_limit=f"8 GiB JVM heap; one heavy checker; {seconds}s cap",
    )
    if not receipt["expectation_met"]:
        raise RuntimeError("Unexpected native result " + receipt["id"])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("profiles", nargs="*")
    args = parser.parse_args()
    for profile in args.profiles or PROFILES:
        if profile not in PROFILES:
            parser.error("unknown profile: " + profile)
        check(profile)


if __name__ == "__main__":
    main()

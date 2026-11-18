"""Audit the current protocol and the previous release's exact retained graph claims."""
import argparse
import json
import sys

from admission_checks import audit, cases, native_result, run
from audit_evidence import EvidenceError
from release_evidence import RELEASE, check_retained_owners, release_report


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("suite",choices=("baseline","negative","audit"))
    parser.add_argument("--fresh",action="store_true",help="Run the selected native executions again")
    parser.add_argument("--focused",action="store_true",help="Select the historical focused suite and current review checks")
    args=parser.parse_args()
    historical_args=[args.suite]
    if args.focused:
        historical_args.append("--focused")
    if args.fresh:
        historical_args.append("--fresh")
    owners=check_retained_owners()
    retained=release_report("verify.py",*historical_args)
    def control(c):
        return (c.expected=="counterexample" or c.name.startswith("vgr-control-")
                or c.name.endswith("-mutant") or c.name=="test-products_epoch_mutant_test"
                or c.name in {"history-1","history-2","history-3","history-4","history-5"})

    selected=[c for c in cases() if args.suite=="audit" or (args.suite=="negative")==control(c)]
    live=audit(selected)
    if args.fresh:
        for c in selected:
            current=run(c,force=True)
            if not current["expectation_met"]:
                raise EvidenceError("Fresh execution failed: "+c.name)
            native_result(c,current)
    print(json.dumps({"status":"passed","suite":args.suite,"retained_release":RELEASE,
                      "reviewed_owners":owners,"retained_checks":retained["checks"],"current_checks":len(selected),
                      "current_directed_cases":sum(live[c.name]["tests"] for c in selected),
                      "current_finite_graphs":sum(c.backend=="tlc" and c.expected=="pass" for c in selected),
                      "current_native_counterexamples":sum(c.expected=="counterexample" for c in selected),
                      "current_sampled_traces":sum(int(c.command[c.command.index("--max-samples")+1])
                                                  for c in selected if c.backend=="simulation"),
                      "current_scope":"Source-bound checks listed in configs/admission-acceptance.json",
                      "retained_scope":retained["scope"]},indent=2))
    return 0


if __name__=="__main__":
    try:
        sys.exit(main())
    except (EvidenceError,OSError,KeyError,ValueError,RuntimeError) as error:
        print("Verification failed:",error,file=sys.stderr)
        sys.exit(1)

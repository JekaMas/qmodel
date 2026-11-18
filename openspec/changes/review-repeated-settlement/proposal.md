## Why

The verified two-trade reference deliberately funds only one successful trade and uses a shared deadline. This exercises contention but cannot witness successive successful exchanges or three concurrently funded exchanges. The follow-up checks both patterns, evidence isolation and modeled fault coverage.

## What changes

- Add a bounded workload using the settlement machine, sufficient initial funding for five successful exchanges, per-trade deadlines and durable decisions across all seven IDs.
- Execute sequential COMMIT/ABORT/COMMIT, three overlapping funded exchanges, a contending seventh trade and replay of earlier authentic results.
- Test modeled event classes with concrete reached or rejected actions. Account for placement-specific and mutant-only actions, fault consequences, and behavior outside the models.
- Re-review predicates, workloads and tests against original requirements and executable Quint/TLA+ examples.

# Proposal

## Why

The proposed cross-chain DvP protocol has no executed formal evidence, and its atomicity wording can be stronger than its asynchronous application guarantee. Establish reproducible evidence without assuming correctness.

## What Changes

- Build and run layered Quint models, counterexample controls and bounded/finite verification.
- Trace every mandatory v2 suite, including variants, privacy, timing and operational integration.
- Preserve exact source identity, toolchain, replayable traces and external obligations.
- Independently review the original request and repair model/evidence gaps; comment the executable specification and publish the reviewed local project under JekaMas/qmodel as explicitly requested.

## Capabilities

### New Capabilities

- `dvp-verification`: Evidence-backed protocol investigation and scoped guarantee reporting.

### Modified Capabilities

None; this is a new repository.

## Impact

Project-local Quint and model-checker dependencies, verification artifacts and workflow. No real banking, asset movement, blockchain deployment or paid infrastructure. GitHub repository creation/push/readback is authorized for JekaMas/qmodel.

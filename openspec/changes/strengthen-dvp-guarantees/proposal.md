## Why

The source-bound review found two assurance gaps. An isolated wrong-phase consumer can pay cash after ABORT while the old assertions pass. An isolated reporter can mark COMMIT fully applied and book it while cash remains held. Both original transition guards reject the individual faults. The verified design remains A-hosted with two native ledgers and conditional eventual application.

## What changes

- Add placement-aware assertions for authenticated terminal knowledge and exact local effects.
- Check COMMIT reporting and durable booking against independent application evidence and source effects. Connect the existing L04 endpoint to these checks.
- Retain the original negatives and add combined rotation/exit, stale restore with replay, and transfer/freeze cases. Exercise real SQLite persistence at the locally implementable adapter boundary.
- Reconcile affected evidence and document the two-network PoC boundary, architecture and supported guarantees.

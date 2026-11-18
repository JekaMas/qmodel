## Block ownership and linearization

Each ledger owns its open block, selected trade IDs and progress through that set. The previously verified contract primitive remains the write owner. A successful transaction reads the state left by earlier transactions in that block. An unfunded reservation changes only its local execution status. Regardless of chosen order, a block seals after every included request has a disposition. A cannot advance its authoritative deadline height while that block is open. B advances independently.

Reserve blocks start with signed, locally eligible requests. An A decision block starts with live local holds and authenticated B preparation. A B application block requires authenticated COMMIT already learned locally and active cash holds. Reserve capacity excludes existing holds. Decision and application consume those holds without charging free balance a second time. Evidence issuance in the workload follows the source block's seal. Inclusion is a modeled input; no cross-ledger clock, common block or publisher SLA is added.

## Verification

Use the existing source-bound native settlement model and check exact source closures. TLC explores both reserve orders, their interleavings, and all local decision and application orders. Use profiles for exact funding, short A and short B. Directed cases cover the deadline, an older reservation, premature source publication, and retries. Early sealing, stale balance reads and a second balance charge have independent controls. Retain the older arbitrary-inclusion terminal-decision check with its own claim.

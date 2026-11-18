## Why

The three-trade terminal-decision graph permits the chain to advance past the deadline before ready submissions are included. It therefore cannot establish the required outcome for funded requests already included in a block. Ledger order alone must not create a funding conflict.

## What changes

- Model each ledger's block as a set of included local requests, an arbitrary execution order, and one fixed height for all of its transactions.
- Require every otherwise enabled reservation to succeed when total demand fits the spendable balance. If funding is short, apply each valid reservation against the preceding state and reject only the unfunded remainder.
- Decide and apply all selected funded trades through their actual authenticated contract actions. The A deadline remains exclusive. Settlement consumes existing holds, including when the free balance is zero.

## Scope

Verify the A-hosted, native-hold protocol with three parallel trades. Distinguish funds, scheduled inclusion and proof readiness. Separate blocks on A and B keep their own heights and local effects.

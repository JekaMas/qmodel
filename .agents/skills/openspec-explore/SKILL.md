---
name: openspec-explore
description: Explore a change before deciding implementation.
metadata:
  owner: agent-workflow
---

# OpenSpec explore

Rendered from the pinned shared integration; edit canonical source, not this copy.
Read applicable project instructions and `.agents/workflow-project.json`.
Use `.agents/workflow/docs/operations.md` for relevant operation loading and
`.agents/workflow/docs/project-flow.md` for project commands. Keep user authority and task scope.

Inspect the question, relevant specs and source. For every relevant behavioral
property or exact test identity, update the selected change's `discovery.json`:
complete exact repository search, perform one focused semantic Context search when
ownership or sibling coverage is not already known, and perform a targeted
JetBrains-index symbol/reference lookup when that capability is exposed and
healthy. Record an unavailable capability with its exact reason; never relabel
exact text search as semantic or IDE evidence. Classify each useful result and
decide current change, named new change, validation only or no change. Validate
the ledger with `scripts/discovery_ledger.py` before using it as a scope decision.
Investigate uncertainty and record useful decisions in the selected change when
authorized. Exploration alone does not authorize implementation. Return to the
enclosing delivery task when it includes implementation.

Before authoring an artifact, read its current native instructions and use the
selected schema's output definition. For a glob output, choose a concrete output
file that matches it; existing matches do not make a partly written artifact
complete. Resolve the concrete output's canonical path, including existing parent
symlinks, and require it to remain inside the selected `changeDir` before any
write. Reject a path or symlink escape instead of writing it. Apply this check
before delegating creation to a skill or command too. Use only artifacts defined
by the selected schema; do not invent default-schema files for a custom schema.

---
name: openspec-propose
description: Propose a complete scoped OpenSpec change.
metadata:
  owner: agent-workflow
---

# OpenSpec propose

Rendered from the pinned shared integration; edit canonical source, not this copy.
Read applicable project instructions and `.agents/workflow-project.json`.
Use `.agents/workflow/docs/operations.md` for relevant operation loading and
`.agents/workflow/docs/project-flow.md` for project commands. Keep user authority and task scope.

Resolve intent, create a matching change if needed, then use native artifact instructions to produce proposal, specs, design and tasks in dependency order. Preserve meaningful uncertainty and required evidence. A proposal-only request does not authorize product implementation.

Before authoring an artifact, read its current native instructions and use the
selected schema's output definition. For a glob output, choose a concrete output
file that matches it; existing matches do not make a partly written artifact
complete. Resolve the concrete output's canonical path, including existing parent
symlinks, and require it to remain inside the selected `changeDir` before any
write. Reject a path or symlink escape instead of writing it. Apply this check
before delegating creation to a skill or command too. Use only artifacts defined
by the selected schema; do not invent default-schema files for a custom schema.

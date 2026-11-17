---
name: openspec-ff-change
description: Prepare implementation-ready OpenSpec artifacts.
metadata:
  owner: agent-workflow
---

# OpenSpec ff

Rendered from the pinned shared integration; edit canonical source, not this copy.
Read applicable project instructions and `.agents/workflow-project.json`.
Use `.agents/workflow/docs/operations.md` for relevant operation loading and
`.agents/workflow/docs/project-flow.md` for project commands. Keep user authority and task scope.

Read status and create missing artifacts in native dependency order using each instruction response. For a planning-only request, apply readiness is the requested outcome and therefore DONE; when the enclosing task authorizes implementation, continue straight into implementation in the same run.

Before authoring an artifact, read its current native instructions and use the
selected schema's output definition. For a glob output, choose a concrete output
file that matches it; existing matches do not make a partly written artifact
complete. Resolve the concrete output's canonical path, including existing parent
symlinks, and require it to remain inside the selected `changeDir` before any
write. Reject a path or symlink escape instead of writing it. Apply this check
before delegating creation to a skill or command too. Use only artifacts defined
by the selected schema; do not invent default-schema files for a custom schema.

---
name: openspec-continue-change
description: Create the next ready OpenSpec artifact.
metadata:
  owner: agent-workflow
---

# OpenSpec continue

Rendered from the pinned shared integration; edit canonical source, not this copy.
Read applicable project instructions and `.agents/workflow-project.json`.
Use `.agents/workflow/docs/operations.md` for relevant operation loading and
`.agents/workflow/docs/project-flow.md` for project commands. Keep user authority and task scope.

Read status and select the next ready artifact. Retrieve its native instructions and required dependencies, then author it from the actual intent. A continue-only request produces that next artifact; an enclosing delivery request proceeds through remaining authorized work.

Before authoring an artifact, read its current native instructions and use the
selected schema's output definition. For a glob output, choose a concrete output
file that matches it; existing matches do not make a partly written artifact
complete. Resolve the concrete output's canonical path, including existing parent
symlinks, and require it to remain inside the selected `changeDir` before any
write. Reject a path or symlink escape instead of writing it. Apply this check
before delegating creation to a skill or command too. Use only artifacts defined
by the selected schema; do not invent default-schema files for a custom schema.

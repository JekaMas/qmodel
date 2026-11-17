---
name: openspec-update-change
description: Revise an existing OpenSpec plan.
metadata:
  owner: agent-workflow
---

# OpenSpec update

Rendered from the pinned shared integration; edit canonical source, not this copy.
Read applicable project instructions and `.agents/workflow-project.json`.
Use `.agents/workflow/docs/operations.md` for relevant operation loading and
`.agents/workflow/docs/project-flow.md` for project commands. Keep user authority and task scope.

Read selected artifacts and changed intent/evidence. Revise affected requirements, design and tasks coherently, preserving completed evidence and marking invalidated results. Routine in-scope edits proceed autonomously. Ask only for material decisions, weaker acceptance or expanded authority. This operation changes artifacts; return to implementation when the enclosing request includes it. This is not the `openspec update` integration-regeneration CLI command.

Before authoring an artifact, read its current native instructions and use the
selected schema's output definition. For a glob output, choose a concrete output
file that matches it; existing matches do not make a partly written artifact
complete. Resolve the concrete output's canonical path, including existing parent
symlinks, and require it to remain inside the selected `changeDir` before any
write. Reject a path or symlink escape instead of writing it. Apply this check
before delegating creation to a skill or command too. Use only artifacts defined
by the selected schema; do not invent default-schema files for a custom schema.

---
name: openspec-bulk-archive-change
description: Archive selected completed OpenSpec changes.
metadata:
  owner: agent-workflow
---

# OpenSpec bulk-archive

Rendered from the pinned shared integration; edit canonical source, not this copy.
Read applicable project instructions and `.agents/workflow-project.json`.
Use `.agents/workflow/docs/operations.md` for relevant operation loading and
`.agents/workflow/docs/project-flow.md` for project commands. Keep user authority and task scope.

Enumerate the exact requested changes and reconcile shared-spec conflicts. Assess completion and authority separately for each; archive eligible changes using native instructions, inspect each resulting diff and report skipped/blocking changes. Do not infer completion from artifact presence.

For each newly introduced capability, supply a meaningful `## Purpose` before
synchronization; native archive can otherwise insert a placeholder that fails
strict main-spec validation. After sync/archive, run
`openspec validate <capability> --type spec --strict --json --no-interactive`
for every affected main spec, preserving the selected store/root. Inspect its
requirements, links and scenarios. A successful archive command alone is not
valid synchronization; repair any resulting spec defect and revalidate.
Before archive, strictly validate the selected deltas and resolve blocking
findings. A blocking sync result stops archive; do not proceed with unchanged main
specs or bypass the finding with an archive flag.

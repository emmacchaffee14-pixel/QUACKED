---
description: Refresh the current-standing sections of .quacked/knowledge/MASTER_HANDBOOK.md against the live repo — the learning-progression build status, backend/Supabase summary, file structure, and cross-document staleness log. Use when the user asks to update, refresh, or sync the master handbook, weekly rule included.
---

# Update Master Handbook

`MASTER_HANDBOOK.md` is a synthesis document, not a mechanical one — unlike
`/update-handbook` (which regenerates `BACKEND_HANDBOOK.md`'s schema/tier-gating
tables from a script with no judgment involved), this is a re-derivation: re-read
the live repo and the specialized knowledge docs, and correct the master handbook
wherever reality has moved past it. There is no script for this — it requires
actually reading things.

## Steps

1. **Re-read every doc in `.quacked/knowledge/`** other than `MASTER_HANDBOOK.md`
   itself. For each one, check its own "Status"/"Last verified" line and compare
   against `git log` on that file — flag anything that looks like it's drifted
   further since the master handbook's §1 table was last written.
2. **Re-derive the learning-progression status (§2)** by checking the live code,
   not by trusting the previous version of this doc or `SWIM_DIVE_METHODOLOGY.md`:
   - `ls cursor/src/components/{swim,dive,waddle,chartsAndGraphs}` — did any
     sub-mode's component set change (new file = possible new sub-mode or exercise
     type, matching how Magnitude Master was first caught this way)?
   - `ls cursor/supabase/functions` — did the Edge Function count change?
   - `git log --since="<date of last master-handbook sync>" --oneline` scoped to
     `cursor/src/`, `cursor/supabase/functions/`, `cursor/shared/chartArchetypes/`,
     and `archetypes/` — anything suggesting a mode's build status changed.
3. **Re-run the reconciliation check** if `cursor/scripts/quacked-qa/reconcile-content-inventory.mjs`
   exists: `cd cursor && node scripts/quacked-qa/reconcile-content-inventory.mjs`,
   and update §4/§6's numbers from its output rather than re-deriving by hand.
4. **Re-check the file-structure section (§5)** against `ls`/`find` on the actual
   repo — new top-level directories, new `cursor/scripts/` entries, stack changes
   (e.g. if `CLAUDE.md`'s Next.js claim ever gets reconciled with the real Vite
   setup, remove that flagged note).
5. **Update the "Last synthesized" date** at the top and the doc-status table in §1.
6. **Do not touch `BACKEND_HANDBOOK.md`'s own `AUTO:` blocks** — if backend schema
   or tier-gating looks stale, that's `/update-handbook`'s job, not this one. This
   skill may note in §3 that `/update-handbook` should be run, but doesn't run it
   itself unless explicitly asked.
7. **Write the updated file only — do not commit.** This skill (including its
   weekly scheduled run) never runs `git commit`. Leave the change as an
   uncommitted diff for a human to review.
8. Report a short summary of what changed (or "no material drift found" if
   nothing did) — don't just say "done."

## Weekly automated run

A scheduled routine invokes this skill at the end of every week. It follows the
exact same steps above, with the same no-commit rule. If a scheduled run finds
nothing has drifted, it should still update the "Last synthesized" date (so the
doc's own staleness is honestly tracked) and report a brief "no material changes"
result rather than skipping the write.

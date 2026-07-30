Archetype Batch Addition Workflow

Status: Living reference document. Update this file itself whenever a batch surfaces a new gotcha or process improvement — don't let it go stale the way the v3.4 Backend Architecture Handbook did.

Origin: Written after completing batch 1 (3 profitability-family siblings: cost_structure_creep, revenue_mix_shift, channel_profitability_divergence), which took the archetype library from 10 to 15 total archetypes (10 → 12 once customer_base_growth/ltv_cac_ratio/ltv_horizon were confirmed as the real split of the old placeholder customer_growth → 15 after batch 1).

Suggested location: .quacked/workflows/archetype-batch-addition.md

Why this workflow exists

Every archetype batch touches the same fragile seam: content (business realism, math correctness) meets infrastructure (schema types, deployed function logic, weighted selection config). Skipping steps or reordering them is exactly what caused batch 1 to take far longer than expected — a text[] vs jsonb casting bug, an orphaned weight-config key, and a missing ARCHETYPE_BRIEF entry all would have shipped silently broken if any single verification step had been skipped or done out of order.

The core principle: test after every step, not after every batch. If three changes ship together and something breaks, you don't know which one caused it. If each step is verified before the next begins, every failure has exactly one possible cause.

Phase 0 — Decide what to build and why
Determine target weight tier(s) for new archetypes based on real-world case interview frequency (see prior research: profitability + market sizing ≈ 60% combined, market entry/growth next, operations least frequent — MBB-specific, not general-consulting-industry, since Deloitte/Kearney/Accenture skew more operational than MBB does).
Check weight-per-archetype-within-class, not just weight-per-class. If a high-weight class only has 1-2 archetypes, it'll repeat often for users — that's the real signal for how many siblings a class needs, not just its raw weight percentage.
Name the new archetypes and briefly describe each one's business premise before writing any JSON.
Phase 1 — Draft the archetype JSON
Pull a live reference archetype from the same weight class first (query the actual templates table, or ask Claude Code to pull one) — never draft from memory of the schema, and never trust the Backend Architecture Handbook's schema description alone, since it can drift out of sync with the live schema (confirmed happened at least once: id field description, variables type, solution_logic step-prefix convention all differed from live data).
Match exactly: field names, _prior/_current naming convention (for period-comparison archetypes) vs. single-funnel structure (for sizing-family archetypes) vs. whatever convention fits the new archetype's actual math — don't force one family's convention onto another.
Match tone/brevity: short noun-phrase business contexts, single-sentence key_insight, Step N: ...-prefixed solution_logic, reused skills_tested tags from index.json's all_skills list rather than invented ones (flag any genuinely new skill tag as its own decision — see Phase 2).
No id field in the archetype JSON itself — that's DB-generated on insert. The archetype's snake_case identifier lives in the archetype field.
archetype_tags convention varies by family: profitability-family uses industry verticals (retail, SaaS); market-sizing-family uses context tags (market entry, investor pitch). Match whichever fits.
Phase 2 — Self-check (treat drafts as drafts, not final content)

Have Claude Code (or do it yourself) review drafts against:

Format conformance — exact field structure vs. live reference archetypes.
Math correctness — walk solution_logic by hand across the full min/max variable range. Check for: divide-by-zero, negative/nonsensical outputs, overlapping ranges that undermine the archetype's premise (e.g. two things meant to diverge that can land identical), missing guard conditions that existing similar archetypes already enforce.
Business realism — does the math structure match how a real case interview would actually test this (e.g. are fixed costs given directly, or does the candidate need to allocate them)?
Skill tag reuse — cross-check against index.json. If a genuinely new tag is needed (happened once: weighted_average_math for a mix-shift archetype), decide deliberately rather than silently inventing it — check for hardcoded assumptions elsewhere in the codebase about skill count/list length before adding.
Any known open bugs in the reference archetype you copied from — worth surfacing even if unrelated to the current batch (e.g. market_sizing's undocumented segment-split variables were caught this way).
Phase 3 — Fix based on self-check findings

Apply fixes directly to the draft JSON. Common fix categories seen so far:

Missing range constraints that let a "should diverge" archetype produce non-diverging rolls
Unit-scale mismatches (e.g. percentage-points 0-100 vs. decimal-fraction 0-1 — must match the convention used elsewhere in the same codebase, since the calculator's rounding/rate logic is calibrated for one scale)
Uncomputable solution_logic steps (a step that sounds reasonable but has no actual formula behind it)
Phase 4 — Wire up calculate-case (separate, explicit authorization)

This is not covered by default guardrails — treat it as its own deliberate step requiring explicit sign-off, since it's your most important Edge Function.

Add exactly N new case branches to the archetype-routing switch (computeArchetype or equivalent).
Add exactly N new validation guards (isSane or equivalent) enforcing the constraints identified in Phase 3.
Confirm the diff is purely additive — no existing archetype's branch or guard touched.
Phase 5 — Pressure-test the guards

For each new archetype, test at minimum:

One reject case: values near the edge that should trip the guard (e.g. price close to cost, near-identical values where divergence is required).
One pass case: safely mid-range values that should produce a sane final_answer and worked_solution.

If calculate-case only accepts template_id (no raw archetype+variables path) and the archetype isn't seeded yet, this can't be tested via live HTTP call — running the actual guard/compute source locally against constructed variable sets (same logic, no network/DB call) is an acceptable substitute, but note this explicitly as a methodology caveat: it verifies the logic is correct, not that the deployed function behaves identically end-to-end. That confirmation only comes after seeding.

Phase 6 — Deploy
Deploy calculate-case (or whichever function changed).
Regression-check an existing, already-seeded archetype via the test button — confirms nothing broke for real users. Don't skip this just because the diff was "additive-only" by inspection; deployed behavior should be confirmed live, not just reasoned about from the code.
Check the Verify JWT toggle — known Supabase quirk: it silently reverts to ON after redeploys regardless of config.toml. Check every time.
Phase 7 — Update archetype-weights.ts
Add the new archetype IDs at the appropriate weight for their class.
Cross-check against the real archetype IDs in seed_templates.sql, not against assumed/remembered IDs — this is where the customer_growth orphaned-key bug was caught (a placeholder ID that no longer matched any real template, silently causing 3 real archetypes to fall back to default weight 1).
Confirm generate-case actually imports and calls pickWeightedArchetype — a weights file that exists but isn't wired in does nothing.
Drop any unused imports (e.g. ARCHETYPE_WEIGHTS itself, if only the picker function is called).
Phase 8 — Update seed_templates.sql
Add new INSERT ... ON CONFLICT DO UPDATE blocks, matching the exact column list and format of existing rows.
Update the DELETE FROM templates WHERE id NOT IN (...) guard line to include the new IDs. Miss this and the very next time the file is re-run (for any reason), it silently deletes the rows it just inserted.
Known critical gotcha: confirm actual column types via information_schema.columns before trusting any regenerated seed file's casting:
sql
   SELECT column_name, data_type, udt_name
   FROM information_schema.columns
   WHERE table_name = 'templates'
   ORDER BY ordinal_position;

In this schema, only variables is genuinely jsonb. Every other array-shaped column (firm_compatibility, difficulty_range, skills_tested, business_contexts, question_patterns, solution_logic, common_mistakes, archetype_tags) is a native Postgres text[] and requires ARRAY['a', 'b', 'c'] syntax, not '["a","b","c"]'::jsonb. A regenerated seed file casting all array-like fields uniformly as ::jsonb will fail on the very first INSERT with column "X" is of type text[] but expression is of type jsonb. 4. Before running: spot-check a few conversions against original values (easy place for a bulk find-replace to drop/duplicate entries), confirm variables wasn't touched by the same fix, confirm nothing else in the file changed.

Phase 9 — Run the seed and verify
Run the complete file (not just new rows) in the SQL Editor.
Verify immediately:
sql
   SELECT archetype, jsonb_typeof(variables) AS variables_type
   FROM templates
   ORDER BY archetype;

Confirm the expected total row count and that every row (old and new) shows variables_type: object. 3. If new archetypes are missing from the result, don't assume a bug — check first whether the seed script was actually run (this happened twice in batch 1: once genuinely not run yet, once after a failed run whose error message wasn't scrolled to/read).

Phase 10 — Wire up ARCHETYPE_BRIEF (if generate-case uses one)

Easy to forget since it's a separate object from computeArchetype/isSane. If your AI wrapper prompt uses a per-archetype brief to enforce unit-fidelity (per-unit vs. monthly vs. annual framing, "not a subscription business" style clarifications), every new archetype needs its own entry or it silently falls back to an empty string — a real risk specifically for high-weight-tier archetypes, since they get generated often.

Phase 11 — Targeted generation test

Call generate-case directly for each new archetype (pass archetype explicitly, don't rely on random weighted pick) and read the full output. Check specifically:

Does the generated scenario respect the ARCHETYPE_BRIEF unit-fidelity guidance?
Do the numbers in worked_solution actually check out by hand?
Does final_answer match the last worked_solution step?
For guard-dependent archetypes, does the generated roll actually clear the guard thresholds (confirms the guard worked in live production, not just in isolated testing)?
Phase 12 — Final distribution test

Re-run the full-library distribution test (no archetype/skill/industry filter, ~100 calls) against the complete, newly-expanded archetype set. This is the only test that reflects the real, final, shipped weighting — earlier distribution tests run before seeding are informative but will be superseded once the archetype count within a weight class changes.

Standing gotchas log (append here as new ones surface)
Backend Architecture Handbook drift: don't trust its schema description as ground truth — pull live reference data instead.
text[] vs jsonb: only variables is jsonb in templates. Everything else array-shaped is text[]. Verify via information_schema.columns whenever a seed file is regenerated by any tool/process, since regeneration has silently introduced uniform (wrong) ::jsonb casting before.
DELETE ... WHERE id NOT IN (...) guard: must include every ID ever inserted by the file, or a future re-run silently deletes rows.
Verify JWT toggle: reverts to ON after redeploy regardless of config.toml. Check after every calculate-case/generate-case deploy.
Weight-config orphaned keys: a placeholder archetype ID (e.g. an old single archetype later split into several real ones) can linger in archetype-weights.ts with no matching template — silently causes the real archetypes to fall back to default weight.
ARCHETYPE_BRIEF (or equivalent per-archetype AI-wrapper guidance) is a separate object from the calculator logic — easy to wire up computeArchetype/isSane and forget this one entirely.

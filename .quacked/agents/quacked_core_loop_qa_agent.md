# Quacked — Core Loop QA Agent
# Save this file. Re-paste into a fresh Claude Code session to run the QA loop.
# Last used: 2026-07-23 — PASS 11/11

## AGENT IDENTITY
You are running an automated Core Loop QA pass for Quacked, a consulting interview prep app.
You have two roles running in sequence: QA Runner then QA Reviewer. Do not sign off until
the Reviewer confirms all checks pass. Self-correct and retry on any failure.

## HUMAN-IN-THE-LOOP (HITL) PROTOCOL
You must PAUSE and wait for explicit human approval at three checkpoints before proceeding:
- CHECKPOINT A: after reading the anon key and confirming environment setup
- CHECKPOINT B: after QA Runner completes all 5 test groups, before Reviewer runs
- CHECKPOINT C: after Reviewer produces its verdict, before final sign-off

At each checkpoint, print clearly:
⏸ CHECKPOINT [A/B/C] — WAITING FOR HUMAN APPROVAL
Then summarize what you just did and what you are about to do next.
Then print: "Type CONTINUE to proceed, or give me a correction and I will fix it before moving on."
Do not proceed until the human types CONTINUE or provides a correction.
If the human provides a correction, apply it, confirm what changed, and re-present the checkpoint.
Do not skip checkpoints even if everything looks clean.

## ENVIRONMENT
- Supabase URL: https://pmftqshqfjylmpukscts.supabase.co
- Supabase anon key: read from .env.local at /Users/emmachaffee/Desktop/QUACKED/cursor/.env.local
- Test user ID: e279566a-3969-4865-a2f2-453cc65df9b6
- Admin password: read from the ADMIN_OVERRIDE_PASSWORD Supabase Edge Function secret (not stored in this file)
- Edge function base: https://pmftqshqfjylmpukscts.supabase.co/functions/v1

SETUP: Before running tests, read the anon key from .env.local. You will need it as the
Authorization header: "Bearer <anon_key>" on all Edge Function calls.

Then pause at CHECKPOINT A.

## QA RUNNER — run all of these after CHECKPOINT A approval

### TEST GROUP 1: GATE CHECK (check-gate function)
Call check-gate and confirm correct behavior per tier.

SQL to switch tiers — print each SQL statement and wait for human to confirm they ran it:
- Free:     UPDATE user_profiles SET subscription_tier='free', is_admin=false WHERE id='e279566a-3969-4865-a2f2-453cc65df9b6';
- Big Duck: UPDATE user_profiles SET subscription_tier='big_duck', is_admin=false WHERE id='e279566a-3969-4865-a2f2-453cc65df9b6';
- Reset:    UPDATE user_profiles SET daily_drill_count=0 WHERE id='e279566a-3969-4865-a2f2-453cc65df9b6';

Tests:
- Free + beginner → should allow
- Free + intermediate → should BLOCK (tier_locked)
- Free + advanced → should BLOCK (tier_locked)
- Free exhaustion: reset counter, call beginner 3 times (should allow), 4th call should BLOCK with "3 free drills" message
- Big Duck + all 3 difficulties → should allow
- Big Duck 6 consecutive calls → all should allow, reason: big_duck_unlimited

### TEST GROUP 2: CALCULATE-CASE (all 12 archetypes × 2 difficulties)
Call calculate-case at beginner and advanced for each template.
Record: variables, final_answer, worked_solution step count, last step label.

Template IDs:
- break_even_investment:   8f4e74fd-450f-4da7-b38b-dc63d5bc33af
- capacity_expansion:      c577c0a3-9850-4fa1-aa8f-665dca68f949
- customer_base_growth:    9d59ae79-7f11-4408-9b49-09d8cd3291c8
- ltv_cac_ratio:           005417bb-8cea-4df1-8e46-d4c967092655
- ltv_horizon:             31ce7726-4fc2-4c36-bc72-cafe7dd02b3e
- market_share_shift:      c8245cf9-9dcb-494a-a0b3-cff9e18bd10f
- market_sizing:           ef2ef59e-aac8-4683-8cc0-c1b90c3da6e2
- pricing_optimization:    3cc36cc8-a473-449e-96ad-c3b7fa0e5658
- productivity_improvement: e56d60c4-30b6-4d82-b432-bcb89edc4531
- profitability_decline:   514aae64-08f9-497b-b927-028214de9426
- supply_chain_efficiency: 76084dcc-76ff-42de-852d-bf7c1d15448e
- throughput_bottleneck:   4264c01b-445f-45d9-9d8c-d04d73a4f8c0

### TEST GROUP 3: GENERATE-CASE (5 combos × 3 tones)
Call generate-case for each combination. Verify:
a) No real firm names (McKinsey, Bain, BCG, Deloitte, etc.) in intro/facts/question/interpretation
b) answer_label matches what the question asks for
c) tone field saves correctly on the case row
d) facts contain every variable needed to solve

Combinations:
{ "template_id": "514aae64-08f9-497b-b927-028214de9426", "tone": "mbb",     "difficulty": "advanced" }
{ "template_id": "514aae64-08f9-497b-b927-028214de9426", "tone": "quacked", "difficulty": "beginner" }
{ "template_id": "ef2ef59e-aac8-4683-8cc0-c1b90c3da6e2", "tone": "econ",    "difficulty": "advanced" }
{ "template_id": "8f4e74fd-450f-4da7-b38b-dc63d5bc33af", "tone": "tier2",   "difficulty": "intermediate" }
{ "template_id": "005417bb-8cea-4df1-8e46-d4c967092655", "tone": "inhouse", "difficulty": "advanced" }

### TEST GROUP 4: GRADING MATH VERIFICATION
Hand-trace 3 drills from Group 3:
- Multiply out every step in worked_solution
- Confirm final_answer equals last step result (within 0.01)
- Confirm step count is HIGHER at advanced than beginner for Phase 6 archetypes:
  profitability_decline, throughput_bottleneck, break_even_investment,
  capacity_expansion, pricing_optimization, market_sizing
- Flag any step where calc string and result are inconsistent

### TEST GROUP 5: ARITHMETIC GATE
Call arithmetic-attempt in check_only mode for Free and Big Duck.
IMPORTANT: use `check_only: true` (boolean), NOT `mode: "check_only"` (string).

Call body: { "user_id": "e279566a-3969-4865-a2f2-453cc65df9b6", "check_only": true }

Expected: returns allowed, remaining (number for free/pond, null for big_duck), tier.
Confirm remaining counts match tier limits (free=15, pond=40, big_duck=null).

After all 5 groups, pause at CHECKPOINT B with summary table:
| Test Group | Tests Run | Passed | Failed | Notes |

## QA REVIEWER — run after CHECKPOINT B approval

Score each item ✅ or ❌:

1.  ✅/❌ GATE — Free blocked intermediate difficulty
2.  ✅/❌ GATE — Free blocked after 3 drills with correct "3 free drills" message
3.  ✅/❌ GATE — Big Duck passed all difficulties, unlimited across 6 calls
4.  ✅/❌ CALCULATOR — No 422 errors on any of the 24 combos
5.  ✅/❌ CALCULATOR — All final_answers sane (no invalid negatives or absurd values)
6.  ✅/❌ STEP COUNTS — advanced has more steps than beginner on the 6 Phase 6 archetypes
7.  ✅/❌ GENERATE-CASE — No real firm names in any output
8.  ✅/❌ GENERATE-CASE — All answer_labels match their question
9.  ✅/❌ GENERATE-CASE — All tone fields saved correctly
10. ✅/❌ MATH — All traced calculations correct within tolerance
11. ✅/❌ ARITHMETIC — check_only returns correct remaining counts per tier

If any item is ❌:
- State exactly what failed and what the output was vs expected
- Classify: code bug / data bug / config issue / wrong call format
- Propose the specific fix
- Do NOT sign off
- Loop: apply fix → re-run affected group → re-review that item only

Only when all 11 are ✅, pause at CHECKPOINT C with full scorecard.
Wait for human CONTINUE before printing final sign-off.

## FINAL SIGN-OFF FORMAT

Pass:
CORE LOOP QA: PASS ✅
[date]
[all 11 checks with ✅]
Ready for: Cursor prompts → re-QA → deploy

Fail:
CORE LOOP QA: FAIL ❌
[specific failures with proposed fixes]
Awaiting human direction.

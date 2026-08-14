# Fly Phase B — Scoping Doc

**Status: scoping only, nothing implemented.** Feeds Sprint 2 planning; precedes the Library Day mass-generation run for Fly content specifically (Business Interpretation generation is not blocked by this).

## 1. Current state, audited end-to-end

**Entry point**: `/fly` (`App.jsx:34`) renders `src/pages/Fly.jsx`, which is a 3-line `ModeComingSoon` placeholder. There is no real Fly UI live today.

**What actually plays the role of "Fly" today**: `/drills` → `src/pages/Practice.jsx` (1500+ lines). This is the app's original, pre-Swim/Dive/Waddle drill screen: configure tone/firm/difficulty/archetype/industry/skill-target → one `check-gate` call → one `generate-case` call (mode omitted, which `generate-case` resolves to `"fly"` by default) → one question, one answer, one grade → result screen with worked solution + business interpretation prose. One case, one shot, session ends.

**Phase A** (uncommitted, unwired — `src/lib/flyEngine.js` + `flyEngineCore.js`): a byte-faithful extraction of Practice.jsx's generation/grading/persistence logic into a reusable, framework-agnostic module, verified against Practice.jsx line-for-line (`scripts/verify-fly-engine-core.mjs`). It changes nothing about the *shape* of the experience — still one case, one question, one grade. Nothing imports it yet; `Fly.jsx` doesn't touch it.

**`generate-case`'s `mode: "fly"` path**: the original, full-prose generation flow — calls Anthropic unconditionally, returns a complete narrative case (`title`, `intro`, `facts`, `question`, `guiding_nudge`, `framework_soundbite`, `worked_solution`, `final_answer`, `business_interpretation`, `answer_label`). This path is stable and production-shipped (it's what Practice.jsx already runs on) — **not a gap**, and not something Phase B needs to touch to make Fly generate content.

**How it starts/ends relative to other modes**: identically to Waddle/Swim/Dive's shared shape (config → gate → generate → answer → result) but with no sub-mode picker and no multi-question progression — every other pillar (Waddle's session, Swim's 3 sub-modes, Dive's 3 sub-modes) has since grown a `*Session.jsx` container with a phase machine; Fly has no equivalent, it's still Practice.jsx's older, flatter single-screen flow.

## 2. What "full loop" currently doesn't do

A real case-interview loop chains distinct cognitive moves against **one shared scenario**: recognize what's being asked → structure the approach → calculate → interpret the result. Every one of those moves already exists as an isolated, working pillar — Problem Recognition (Swim), Structure Building (Dive), the calculation itself (Waddle/`calculate-case`), Business Interpretation (Swim) — but each pulls its **own separate `generate-case` call** for its own separate, disposable case. Nothing today walks a single case through more than one of these stages. Fly's current one-shot Practice.jsx flow doesn't chain anything either — it's a single Q&A, not a loop.

The methodology doc's own description of Fly ("integrate all previous skills under realistic case interview conditions") is one sentence with no structural detail — there is no existing spec anywhere in the repo for what stages a loop should contain or how many. This scoping doc is the first attempt to define that; it isn't filling in a gap in an existing plan.

## 3. Build requirements

**New templates/archetypes**: not required for a baseline loop. Every archetype already carries the fields a recognition→calculate→interpret sequence needs (`target_label`, `formula`, `key_insight`, `business_interpretation`, `answer_label`) — this is exactly the same data Problem Recognition's 5-question progression already walks through **client-side, from one already-fetched case, with zero extra network/AI calls** (`lib/swim/problemRecognition.js`). A structure-inclusive loop is a different story: `acceptable_structures` (Structure Building's grading data) is only authored for ~5-6 of ~30 archetypes today (`generate-case/index.ts:360`, confirmed against the handbook) — a loop that includes a structuring stage is archetype-limited unless more of that content gets authored, which is real content work, not sequencing logic.

**New sequencing logic**: yes, this is the actual gap. No `FlySession.jsx` exists. Building one means either (a) a new multi-stage container that renders stage-appropriate mini-views against one fetched case (borrowing the pattern `ProblemRecognitionCard`/`BusinessInterpretationCard` already prove out, not necessarily reusing those components verbatim since they're wired to Swim's own scoring contract), or (b) something lighter. This is genuinely new frontend orchestration work, but it has a proven, low-risk template to copy from — Problem Recognition already demonstrates "walk one case through N stages, no new AI calls, one aggregate score at the end" end-to-end in production.

**Prompt/generation changes**: none needed for a baseline loop — the existing `mode: "fly"` generation already returns everything a recognition→calculate→interpret sequence needs in one call. A structure-inclusive loop doesn't need new prompt logic either (Structure Building's grading is already deterministic, client-side-comparison-against-`acceptable_structures`, no AI) — its limit is content coverage, not generation logic.

**UI/flow changes**: yes — this is most of the actual work. A new `FlySession.jsx`, new stage components (or adapted versions of existing ones), and a decision on session end/scoring shape (one aggregate result across all stages, mirroring how Problem Recognition already resolves its 5-question progression to one score — recommended, for consistency with the rest of the app's one-case-one-attempt scoring contract that `update-skills` assumes).

## 4. Overlap with other in-flight work

**Business Interpretation / unit-formatting-hint (this session's work)**: direct, small overlap. `answer_format` and `target_label` are currently only attached to `mode === "swim"` responses (`generate-case/index.ts`, the `mode === "swim"` block) — **`mode: "fly"` does not get them today.** If Fly's interpretation stage is meant to look like Business Interpretation's now-fixed display (real label, correctly formatted value), `answer_format` needs to be extended to fly responses too. This is a small, low-risk, additive change — `answer_format` only depends on `template.archetype`, which is already in scope regardless of mode — but it's a real, concrete piece of Phase B's build, not zero-touch.

**Library Day**: confirms the original sequencing concern was well-founded, now with a specific mechanism. If Library Day banks Fly cases before Phase B lands, and Phase B turns out to need `answer_format`/`target_label` on those responses (per the overlap above), every banked Fly case would be missing a field the full-loop UI needs — meaning re-generation, not just re-review. Business Interpretation batches are unaffected (already scoped to `mode === "swim"`, already has the field).

## 5. Sizing

Not one Sprint-sized change. Recommend splitting:

- **Phase B1 (MVP loop, Sprint-sized)**: recognition → calculate/reveal → interpret, walking one `mode: "fly"` case through 2-3 client-side stages, no new archetype content, one new `FlySession.jsx` + stage views, plus the small `answer_format`/`target_label` extension to fly responses. Comparable in size to a single prior sprint in this engagement (Formula Fluency's Learn+Recognize build was a similar shape: new session container + reused data + no new AI calls).
- **Phase B2 (structure-inclusive loop, larger, content-gated)**: adds a structuring stage using `acceptable_structures`, blocked on authoring that data for enough archetypes to feel representative (currently ~5-6 of ~30). This is a separate content-authoring effort before it's an engineering one.

Recommend scoping Sprint 2 to Phase B1 only, and treating Phase B2 as a later, explicitly-content-gated follow-up — matching how Structure Building itself already ships gated to its authored subset rather than waiting for full coverage.

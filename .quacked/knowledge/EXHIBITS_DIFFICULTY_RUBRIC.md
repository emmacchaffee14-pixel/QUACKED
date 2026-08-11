# Exhibits — Difficulty Calibration Rubric

Status: living reference document, written before any Step 2/3 retuning began (see the calibration pass this doc was written for). Verify against current archetype code before relying on it — generator parameters are exactly what this pass exists to change.

Origin: Batch 2 QA flagged that `beginner`/`intermediate`/`advanced` don't feel meaningfully different across Exhibits archetypes, despite each archetype having some difficulty-keyed parameter. Deferred twice pending (a) more archetypes existing and (b) `consultingQuestionBuilder`/`ConsultingFeedback` (Batch 4.5) replacing shallow single-field explanations. Both are now true. This rubric is the shared definition of "tier" that was previously missing — each archetype was tuning its own difficulty knob with no cross-archetype agreement on what a tier is supposed to guarantee.

This is a rubric, not an audit. See the calibration pass's Step 2 findings for how current output actually measures against it.

## The five dimensions

### 1. Signal-to-noise / margin

How close is the correct answer to the next-best distractor/candidate, in whatever unit the archetype uses.

| Tier | Target margin |
|---|---|
| Beginner | Correct answer is **>25%** clear of the next-best candidate (or, for spatial archetypes, unambiguous at a glance — outlier/second-largest/boundary-distance well outside the ambient noise band) |
| Intermediate | **10–25%** clear — requires actually reading values, not just eyeballing shape |
| Advanced | **<10%** clear — the two leading candidates are close enough that a fast scan is unreliable; the learner must read the underlying numbers |

For value-based archetypes (`simple_bar`, `pie`, `bubble`), margin = `(top - secondBest) / secondBest`. For spatial archetypes (`scatter`, `matrix_2x2`), margin is distance-based: residual gap or distance from midpoint, expressed as a fraction of the tier's own scale.

**Non-negotiable finding this rubric must be checked against:** margin should be controlled at *every* tier, not just forced at `advanced` and left to chance at `beginner`/`intermediate`. An uncontrolled beginner margin can randomly land smaller than a controlled advanced margin, which is a direct cause of "tiers don't feel different."

### 2. Data volume

How many categories/points/segments/bins the learner has to parse before finding the answer.

This already exists in some form in most archetypes (`*_COUNT_BY_DIFFICULTY` tables) and is generally reasonable — audit and tighten rather than reinvent. Target shape, as a ratio against beginner:

| Tier | Target volume (relative to beginner) |
|---|---|
| Beginner | baseline (as few items as the archetype can sensibly show) |
| Intermediate | +30–50% over beginner |
| Advanced | +80–150% over beginner |

`matrix_2x2` has no volume axis (always one point) — volume is N/A there; its difficulty is carried entirely by margin (distance from the quadrant boundary).

### 3. Inference depth

Does answering require one lookup (find the max), or comparing two derived quantities (line graph's steepest-interval-vs-net-change distinction, 100%-stacked-bar's share-hides-absolute-size trap, an outlier that isn't extreme on either axis alone)?

| Tier | Target |
|---|---|
| Beginner | Archetype's "trap" scenario should **rarely** be the operative case (target: ≤15% of instances) |
| Intermediate | Trap scenario present at a **moderate, noticeable** rate (target: ~35–50% of instances) |
| Advanced | Trap scenario should be the **dominant** case (target: ≥70% of instances) — this is what "advanced" is for |

"Trap scenario" per archetype = the specific case each archetype's conditional tip was written to catch: line graph's steepest-interval ≠ net-change interval; histogram's skew present when asked about a range or vice versa; scatter's non-extreme-looking outlier; bubble's size-independent-of-position confusion; stacked_bar_100's share-shift-with-flat-absolute-value case. Where an archetype has no authored trap distinct from margin (e.g. `simple_bar`), inference depth collapses into margin for that archetype and this dimension is scored the same as margin — don't force an artificial trap where the archetype genuinely doesn't have one; note it as N/A in scoring rather than fabricating a 1-3 value.

### 4. Insight distance

Distinct from inference depth: this is about how directly the exhibit surfaces what's needed, not how many computational steps are involved.

- **Beginner:** the exhibit contains what's needed relatively directly (e.g. "which segment had the highest growth?").
- **Intermediate:** the learner must connect two pieces of information or perform a modest transformation (e.g. "which segment contributed most to overall growth?" — weighting by size, not just reading the highest rate).
- **Advanced:** the learner has to recognize an implication not explicitly surfaced by the exhibit (e.g. "which segment should management investigate first?" — a judgment call, not a lookup).

Operationally, this is carried by **which `askFor`/question-variant branch the generator selects**, since that's what actually determines whether the task is a direct read or a modest transformation (`pie`'s `dominant` vs `top2share`, `stacked_bar`'s `categoryMax` vs `segmentTotal`, `histogram`'s `mode` vs `skew`). Today these branches are chosen with a **fixed probability independent of difficulty** in every archetype that has them — this is the rubric's sharpest current gap; see Step 2 findings.

| Tier | Target: probability of the "modest transformation" branch |
|---|---|
| Beginner | ≤20% |
| Intermediate | ~50% |
| Advanced | ≥80% |

### 5. Question framing (consultingQuestionBuilder tiers)

Beginner = direct read, intermediate = investigate-first framing, advanced = recommendation-MC. **This dimension is not a proxy for the other four and must not be treated as sufficient on its own.**

Explicit check required per archetype: do beginner and intermediate present the **same options list** (same correct answer, same distractors) with only the prompt sentence changed? If yes, that's a rubric violation — the "investigate first" framing must not sit on top of an identical underlying task with no margin/insight-distance change. Question framing is fine as-is (it's copy, out of scope for this pass) as long as dimensions 1–4 actually diverge underneath it; the fix for this dimension is never to touch `consultingQuestionBuilder` copy, it's to make sure dimensions 1–4 give it something genuinely different to sit on top of.

## Difficulty score

For a single generated instance, score dimensions 1–4 from 1 (beginner-like) to 3 (advanced-like); dimension 5 (question framing) is not scored numerically since it's driven by the `difficulty` parameter directly, not measured from output. Where a dimension is N/A for an archetype (e.g. volume for `matrix_2x2`, inference depth where no distinct trap exists), exclude it from the sum and prorate: `score = round(sum(applicable dims) / count(applicable dims) * 4)`, keeping all archetypes on a comparable ~4–12 scale regardless of how many dimensions apply.

Starting hypothesis (to be replaced with real thresholds after Step 2's audit, from what current output actually produces):

| Tier | Score band (hypothesis) |
|---|---|
| Beginner | 4–6 |
| Intermediate | 7–9 |
| Advanced | 10–12 |

This score is a **complement to, not a replacement for**, a human read of actual generated instances (Step 4 of the calibration pass). A numeric score in-band can still be satisfied by output that reads as "different wording, same task" to a person — that's the actual failure mode this rubric exists to catch, and the score alone cannot catch it.

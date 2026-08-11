# Fly Calibration Rubric

Established during a single-case calibration loop (`channel_profitability_divergence`,
intermediate) before extrapolating caliber to the rest of the archetype set. This is
the reusable standard, not the case itself — apply it whenever a Fly case (or the
wrapper prose generation generally) needs a caliber check.

## The 5 dimensions

### 1. Recognition / nudge calibration
The guiding nudge may orient the candidate toward the right *kind* of thinking, but
must not disclose: the calculation structure, the relevant variables, the operation
sequence, or any decomposition (e.g. channel-by-channel, segment-by-segment) the
candidate is supposed to arrive at themselves. If a candidate could read the nudge
and skip straight to plugging numbers into a stated formula, the nudge has failed —
Fly is testing recognition as part of the loop, not just calculation.

*Check:* could someone with no case-interview training follow the nudge into the
correct calculation without ever recognizing the underlying structure? If yes, the
nudge reveals too much.

### 2. Question ↔ case ambition match
The setup/intro and the question must promise the same thing. If the intro frames a
strategic or resource-allocation decision, a question that only asks for a number
undersells what was set up — and grading only the number leaves the actual decision
untested. Three ways to fix a mismatch (pick one, don't stack them):
- Trim the setup so it stops promising a decision it doesn't ask about, or
- Raise the question into the actual decision the setup promised, or
- **Two-step question (quantify → interpret/recommend)** — preferred when it maps
  onto Fly's existing recognize→calculate→interpret stage architecture
  (`FlyLoopCard.jsx`), since it lets the case test both the number and the judgment
  call without inflating the dataset.

*Check:* if you covered the question and only read the intro, what decision would
you expect to be asked to make? Does the actual question ask that?

### 3. Interpretation depth
The interpretation must not stop at restating the arithmetic in prose ("X is bigger
than Y because X's unit economics are better" is the calculation, not analysis). A
genuine interpretation reaches a real tension — in a profitability-comparison case,
that's usually that the lower-profitability option isn't automatically the one to
cut (brand visibility, acquisition funnel, strategic role, data the model doesn't
capture). The interpretation should land on that tension and a reasoned call, not
just the number's sign and magnitude restated in words.

*Check:* if you deleted the interpretation and asked "so what should the client do,"
would an average candidate's answer already be fully contained in what's written?
If yes, it's too shallow.

### 4. Data texture — non-blocking
Only add a fact if it changes the reasoning, not just the length or apparent
complexity. Don't pad a case to make it feel more "advanced" — if dimensions 1-3
already make the case feel appropriately Fly-caliber, leave the dataset alone. This
is the one dimension where "do nothing" is frequently the right call.

### 5. Overall Fly calibration
The case as a whole should require recognition, calculation, *and* judgment against
one continuous scenario — not just a harder version of a single isolated skill.
Compare explicitly against what Swim and Dive already test in isolation (see the 9
self-audit questions below, items 6-7) — if a case could be fully solved the same
way inside a Swim or Dive sub-mode, it hasn't actually reached Fly's loop.

## Grading tiers (committed direction, not just this case's fix)

**Decision: no AI/free-response grading of any kind, for now** — too expensive, and
a much later build if it happens at all. Fly follows the exact same tiered pattern
already shipped in Business Interpretation:

- **Beginner/Intermediate = multiple choice**, distractors representing real
  consulting mistakes (a profit-maximization trap, a volume trap, false balance —
  not three flavors of "sounds sophisticated"). Grading is exact client-side string
  comparison against `business_interpretation`, via the same `buildMCOptions`
  mechanism Business Interpretation already uses (see FlyLoopCard's Interpret
  stage) — no new grading mechanism needed at this tier.
- **Advanced = self-assessed free response against a shown sample answer.**
  Learner writes a response, reveals the sample answer, self-attests correct/
  incorrect via a binary button — never AI-graded, never calculator-verified.
  This is Business Interpretation's existing Advanced-tier pattern
  (`BusinessInterpretationCard.jsx`'s `isAdvanced` branch); Fly's future Advanced
  tier should reuse it directly rather than building a parallel mechanism.
- **No AI/LLM grading at either tier.** Not a "for now, until we build it right"
  scaffold — a standing decision.

## Difficulty should come from reasoning, not arbitrary traps

A "data-integrity wrinkle" (a case requiring the candidate to notice something
wrong with the data itself before trusting the numbers) is a fine *occasional*
device when it arises naturally from the business problem. It must not become a
checklist requirement for every Fly case — that produces artificial difficulty,
which this project has consistently rejected elsewhere (Exhibits' difficulty
calibration pass avoided exactly this failure mode). If a case doesn't need a
wrinkle to earn its difficulty tier, it doesn't get one bolted on.

## The 9-question self-audit

Run after any revision, before calling a case done:

1. What capability is this drill actually testing, after revision?
2. What capability is Fly supposed to test?
3. Where does the candidate have to recognize something rather than execute a
   provided formula?
4. Where does the candidate have to interpret the result, not just calculate it?
5. Where does the candidate have to exercise business judgment?
6. What makes this meaningfully harder than Swim?
7. What makes this meaningfully different from Dive?
8. What would an excellent MBB candidate do that an average candidate might miss?
9. What, if anything, still feels "Intermediate" rather than genuinely "Fly"?

## Report format

```
FLY AUDIT
STATUS: [APPROVE / REVISE / REJECT]
CURRENT CALIBRATION: [Fly / Dive / Swim / Waddle / unclear]
MATH: [PASS / FAIL]
CONTENT LOGIC: [PASS / FAIL]
MBB TONE: [PASS / FAIL]
FLY DISTINCTIVENESS: [PASS / FAIL]
REMAINING ISSUES (if any):
```

`STATUS` is the reviewer's self-assessment going into human review, not a final
decision — the human calibrating the case still has the actual approval call.
`REMAINING ISSUES` exists specifically to let a case pass with a noted, non-blocking
stretch goal rather than forcing another full revision round for every observation
the self-audit surfaces.

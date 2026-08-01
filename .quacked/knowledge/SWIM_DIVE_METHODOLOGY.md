# Swim & Dive Methodology — Product Direction (Updated August 2026)

This is a product philosophy document, not an implementation spec. It reflects finalized naming, copy, and mechanic decisions. Treat it as the source of truth for naming/scope, but also as inspiration — if another direction feels more intuitive at any point of revision, that's fine to flag rather than follow blindly.

## Swim — "Choose your focus."

Swim is not a linear workflow. It is the environment where learners develop recognition — the ability to identify the correct business thinking before jumping into calculations or structure. Swim contains three focused sub-modes. Each isolates a single cognitive skill using fresh, independent scenarios so learners cannot rely on memory from a previous question.

Naming note: these are called sub-modes, not "Ponds." Code, database values, component names, and function parameters should use the plain, neutral slugs listed under each sub-mode below — no internal-only naming.

### Problem Recognition — "What kind of problem is this?"
slug: `problem-recognition`

Given a business prompt, identify what business quantity should be calculated (e.g. Revenue Growth, Gross Margin, Market Share, Break-even, ROI, etc.).

Mechanic: facts are shown to the learner first. Before any solve or calculation happens, the learner is asked "what are you solving for?" The correct answer is the case's own archetype identity / `skills_tested` value. Distractors are 2-3 other archetypes' labels drawn from the same pool — no separately authored distractor content and no additional LLM call required.

### Formula Finder — "How do I solve it?"
slug: `formula-finder`

Practice recognizing and reinforcing consulting formulas through three exercise types:
- Formula identification (multiple choice)
- Formula ordering / unscrambling
- Matching metrics to formulas

This remains a distinct sub-mode because formula recognition is a separate skill from problem recognition, and is inexpensive to build while providing meaningful learning value.

### Business Interpretation — "What does the answer mean?"
slug: `business-interpretation`

Given a completed calculation (and brief business context), determine what the result actually means.

Progression:
- Beginner → straightforward multiple choice
- Intermediate → more nuanced, contextual multiple choice
- Advanced → free response with a worked/sample answer shown (AI grading deferred — not part of v1)

All Swim sub-modes should reuse the same underlying infrastructure wherever possible: existing case generation, the deterministic calculator, scoring, persistence, the session engine, and results components. Only the recognition task itself changes. Swim is about recognizing, not constructing.

## Dive — "Let's dive deeper."

Dive is the environment where learners begin building. Dive is where learners construct solutions rather than recognize them.

### Structure Building
slug: `structure-building`

Build the quantitative structure required to solve an ambiguous consulting problem.

Workflow: Problem → Build Structure → Compare Against Acceptable Structures → Solve → Interpret. Multiple correct structures should be supported wherever appropriate. This is the flagship feature and where the majority of new engineering effort should be spent.

### Market Sizing
slug: `market-sizing`

Market sizing belongs inside Dive — not as its own environment. Learners practice:
- Top-down sizing
- Bottom-up sizing
- Hybrid approaches
- Assumption generation
- Assumption validation

Initially, worked solutions are sufficient. AI grading can be added later.

Standalone expansion of the shared-pool `market_sizing` archetype ("batch 2") stays paused until this builder experience is designed — the existing archetype remains as-is (bug fix only) in the meantime.

## Overall Methodology

- **Warm-Up** → Build arithmetic fluency.
- **Waddle** → Execute consulting calculations automatically.
- **Swim** → Recognize what to calculate, which formula applies, and what the answer means.
- **Dive** → Build quantitative structures and reason through ambiguity.
- **Fly** → Integrate all previous skills under realistic case interview conditions.

## Guiding Principle

Every environment should own a different cognitive skill, not simply present different content. Reuse existing infrastructure aggressively; invest engineering effort only where the learning experience is genuinely new. Warm-Up, Waddle, and Swim should maximize reuse of the current architecture. Dive is where the majority of new product engineering should occur.

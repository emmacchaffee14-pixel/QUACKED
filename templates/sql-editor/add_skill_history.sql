-- Skill history: logs every score change over time
-- This powers the paid-tier improvement chart
create table skill_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  skill text,
  score_before integer,
  score_after integer,
  delta integer,
  correct boolean,
  case_id uuid references generated_cases(id),
  created_at timestamptz default now()
);

-- Index for fast user skill history lookups
create index skill_history_user_id_idx on skill_history(user_id);
create index skill_history_skill_idx on skill_history(user_id, skill);
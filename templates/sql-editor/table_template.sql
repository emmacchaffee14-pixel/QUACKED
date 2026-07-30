-- 1. TEMPLATES
create table templates (
  id uuid primary key default gen_random_uuid(),
  name text,
  description text,
  archetype text,
  content_type text default 'drill',
  firm_compatibility text[],
  difficulty_range text[],
  recommended_difficulty text,
  formula text,
  skills_tested text[],
  business_contexts text[],
  question_patterns text[],
  variables jsonb,
  solution_logic text[],
  key_insight text,
  common_mistakes text[],
  framework_soundbite text,
  archetype_tags text[]
);

-- 2. GENERATED CASES
create table generated_cases (
  id uuid primary key default gen_random_uuid(),
  template_id uuid references templates(id),
  title text,
  firm text,
  difficulty text,
  industry text,
  intro text,
  facts text[],
  question text,
  guiding_nudge text,
  framework_soundbite text,
  worked_solution jsonb,
  final_answer numeric,
  business_interpretation text,
  skills_tested text[],
  content_type text default 'drill',
  status text default 'pending',
  created_at timestamptz default now()
);

-- 3. USER ATTEMPTS
create table user_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  case_id uuid references generated_cases(id),
  correct boolean,
  response_time integer,
  hint_used boolean,
  created_at timestamptz default now()
);

-- 4. USER SKILLS
create table user_skills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  skill text,
  score integer default 50,
  last_updated timestamptz default now(),
  unique(user_id, skill)
);

-- 5. USER PROFILES
create table user_profiles (
  id uuid primary key references auth.users(id),
  xp integer default 0,
  streak_days integer default 0,
  last_active_date date,
  favorite_firm text default 'McKinsey',
  created_at timestamptz default now()
);

-- 6. AUTO-CREATE PROFILE ON SIGNUP
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into user_profiles (id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();
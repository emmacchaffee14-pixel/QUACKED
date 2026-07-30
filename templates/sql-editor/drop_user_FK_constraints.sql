-- Remove the auth.users FK constraint from skill_history
-- We'll enforce user validity at the application layer instead
alter table skill_history 
drop constraint skill_history_user_id_fkey;

-- Also remove from user_skills for consistency
alter table user_skills
drop constraint user_skills_user_id_fkey;

-- And user_attempts
alter table user_attempts
drop constraint user_attempts_user_id_fkey;
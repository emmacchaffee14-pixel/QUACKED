-- Add gate model columns to user_profiles
alter table user_profiles 
  add column daily_drill_count integer default 0,
  add column last_drill_date date,
  add column is_paid boolean default false,
  add column is_admin boolean default false;

-- Set your account as admin
-- First find your user id
select id, email from auth.users;
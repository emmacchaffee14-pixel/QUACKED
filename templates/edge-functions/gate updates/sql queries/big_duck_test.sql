set session_replication_role = replica;

insert into user_profiles (id, xp, daily_drill_count, last_drill_date, is_paid, is_admin)
values (
  '00000000-0000-0000-0000-000000000004',
  600,
  999,
  current_date,
  true,
  false
);

set session_replication_role = default;
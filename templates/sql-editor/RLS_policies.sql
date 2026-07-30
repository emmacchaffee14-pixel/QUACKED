-- ============================================================
-- QUACKED — Row Level Security Policies
-- Run in: Supabase → SQL Editor → New query → paste → Run
-- ============================================================
-- KEY FACT: Edge Functions use the SERVICE_ROLE_KEY, which
-- BYPASSES RLS entirely. All 5 of your functions keep working
-- with zero changes. These policies only govern client-side
-- (browser) queries made with the anon/authenticated key.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Enable RLS on every table
--    (Once enabled with no matching policy = access denied.)
-- ------------------------------------------------------------
ALTER TABLE user_profiles   ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_attempts   ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skills     ENABLE ROW LEVEL SECURITY;
ALTER TABLE skill_history   ENABLE ROW LEVEL SECURITY;
ALTER TABLE generated_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates       ENABLE ROW LEVEL SECURITY;


-- ------------------------------------------------------------
-- 2. user_profiles
--    ASSUMPTION: user_profiles.id == auth.users.id (the profile
--    id IS the user id, created by your handle_new_user trigger).
--    Verify this before running. If your user link column is
--    named differently, change `id` below to that column.
-- ------------------------------------------------------------
CREATE POLICY "Users read own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

-- SECURITY FIX (privilege escalation):
-- A plain UPDATE policy would let a user set their OWN
-- is_paid = true or is_admin = true and unlock paid/admin
-- features for free. We block that by revoking UPDATE on all
-- columns from the client, then granting it back ONLY on the
-- columns a user should legitimately change (their firm pref).
-- Sensitive columns (is_paid, is_admin, xp, daily_drill_count,
-- streak_days) can then only be written by Edge Functions via
-- the service role (e.g. the Stripe webhook flipping is_paid).
REVOKE UPDATE ON user_profiles FROM authenticated;
GRANT  UPDATE (favorite_firm) ON user_profiles TO authenticated;


-- ------------------------------------------------------------
-- 3. user_attempts
--    Read + insert own rows. UPDATE is included now so the
--    upcoming `saved` toggle (Session 1) works out of the box.
-- ------------------------------------------------------------
CREATE POLICY "Users read own attempts"
  ON user_attempts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users insert own attempts"
  ON user_attempts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users update own attempts"
  ON user_attempts FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);


-- ------------------------------------------------------------
-- 4. user_skills  (read only from client; writes come from
--    update-skills Edge Function via service role)
-- ------------------------------------------------------------
CREATE POLICY "Users read own skills"
  ON user_skills FOR SELECT
  USING (auth.uid() = user_id);


-- ------------------------------------------------------------
-- 5. skill_history (read only from client; writes come from
--    update-skills Edge Function via service role)
-- ------------------------------------------------------------
CREATE POLICY "Users read own skill history"
  ON skill_history FOR SELECT
  USING (auth.uid() = user_id);


-- ------------------------------------------------------------
-- 6. generated_cases
--    Clients may read ONLY approved cases. Writes come from
--    generate-case via service role.
--    NOTE: your cases currently save as status='pending', so
--    with this policy the client sees NOTHING until the
--    pending-status fix (gap item #2). That's expected.
-- ------------------------------------------------------------
CREATE POLICY "Authenticated users read approved cases"
  ON generated_cases FOR SELECT
  TO authenticated
  USING (status = 'approved');


-- ------------------------------------------------------------
-- 7. templates
--    Reference data. Only Edge Functions (service role) ever
--    read this. RLS is enabled with NO policy = fully locked
--    to the client. If any client code reads templates
--    directly, it will return empty — route it through an
--    Edge Function instead.
-- ------------------------------------------------------------
-- (intentionally no client policy)


-- ============================================================
-- POST-RUN VERIFICATION
-- Run these as a logged-in user to confirm isolation:
--   SELECT * FROM user_attempts;   -- should show ONLY your rows
--   SELECT * FROM templates;       -- should return 0 rows (client)
--   UPDATE user_profiles SET is_paid = true WHERE id = auth.uid();
--                                  -- should ERROR (permission denied)
-- ============================================================
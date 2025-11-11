-- ============================================================================
-- FitChekk Database Verification Tests
-- ============================================================================
-- Run these queries in Supabase SQL Editor to verify deployment
-- ============================================================================

-- TEST 1: Verify Users Table Structure
-- Expected: 8 columns including id, email, display_name, subscription_tier, etc.
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'users'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- ============================================================================

-- TEST 2: Verify All Tables Exist
-- Expected: 5 tables (users, user_preferences, wardrobe_items, outfits, planner_entries)
SELECT table_name, 
       (SELECT COUNT(*) FROM information_schema.columns WHERE columns.table_name = tables.table_name) as column_count
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ============================================================================

-- TEST 3: Verify RLS Policies
-- Expected: 7 policies across the 5 tables
SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ============================================================================

-- TEST 4: Verify Foreign Key Relationships
-- Expected: 5+ foreign keys showing relationships between tables
SELECT
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
JOIN information_schema.referential_constraints AS rc
  ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

-- ============================================================================

-- TEST 5: Verify Indexes
-- Expected: 5 custom indexes plus automatic primary key indexes
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
AND tablename IN ('users', 'user_preferences', 'wardrobe_items', 'outfits', 'planner_entries')
ORDER BY tablename, indexname;

-- ============================================================================

-- TEST 6: Verify Functions
-- Expected: 2 functions (update_updated_at_column, handle_new_user)
SELECT 
    n.nspname as schema_name,
    p.proname as function_name,
    pg_get_function_result(p.oid) as return_type,
    pg_get_function_arguments(p.oid) as arguments
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
AND p.proname IN ('update_updated_at_column', 'handle_new_user')
ORDER BY p.proname;

-- ============================================================================

-- TEST 7: Verify Triggers
-- Expected: 6 triggers (5 for updated_at + 1 for auth)
SELECT 
    event_object_table AS table_name,
    trigger_name,
    event_manipulation AS trigger_event,
    action_timing
FROM information_schema.triggers
WHERE trigger_schema = 'public'
OR (event_object_schema = 'auth' AND trigger_name = 'on_auth_user_created')
ORDER BY event_object_table, trigger_name;

-- ============================================================================

-- TEST 8: Verify RLS is Enabled on All Tables
-- Expected: All 5 tables should show 't' (true) for rowsecurity
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- ============================================================================

-- TEST 9: Verify Array Columns
-- Expected: Several columns using array types (TEXT[], UUID[])
SELECT 
    table_name,
    column_name,
    data_type,
    udt_name
FROM information_schema.columns
WHERE table_schema = 'public'
AND data_type = 'ARRAY'
ORDER BY table_name, column_name;

-- ============================================================================

-- TEST 10: Verify Check Constraints
-- Expected: Constraints on subscription_tier, formality, user_rating, etc.
SELECT
    tc.table_name,
    tc.constraint_name,
    cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.check_constraints cc 
    ON tc.constraint_name = cc.constraint_name
WHERE tc.table_schema = 'public'
AND tc.constraint_type = 'CHECK'
ORDER BY tc.table_name, tc.constraint_name;

-- ============================================================================
-- VERIFICATION COMPLETE
-- ============================================================================
-- Review the results above. All tests should return expected data.
-- If any test returns empty results or errors, check the deployment.
-- ============================================================================


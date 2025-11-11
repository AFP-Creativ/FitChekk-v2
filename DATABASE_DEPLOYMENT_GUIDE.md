# FitChekk Database Deployment Guide

**Step 1.2: Database Schema Deployment**

---

## 📋 Overview

This guide walks you through deploying the complete FitChekk database schema to Supabase. The process takes approximately 10-15 minutes.

---

## ✅ Pre-Deployment Checklist

- [ ] Supabase account logged in
- [ ] Project URL confirmed: `https://paufghpcdsvspznnygxo.supabase.co`
- [ ] SQL files ready:
  - `supabase_schema_v1.sql` ✓
  - `supabase_storage_policies.sql` ✓

---

## 🚀 Deployment Steps

### Part 1: Deploy Database Schema (5 minutes)

1. **Open Supabase SQL Editor**
   - Go to: https://supabase.com/dashboard/project/paufghpcdsvspznnygxo/editor
   - Or navigate: Dashboard → Your Project → SQL Editor

2. **Create New Query**
   - Click "+ New query" button
   - Name it: "FitChekk Schema v1.0"

3. **Paste Schema SQL**
   - Open: `supabase_schema_v1.sql`
   - Copy entire contents
   - Paste into SQL Editor

4. **Execute Schema**
   - Click "Run" button (or press Cmd/Ctrl + Enter)
   - Wait for execution to complete (~30 seconds)
   - You should see: "Success. No rows returned"

5. **Verify Tables Created**
   - Navigate to: Table Editor
   - You should see 5 new tables:
     - ✓ `users`
     - ✓ `user_preferences`
     - ✓ `wardrobe_items`
     - ✓ `outfits`
     - ✓ `planner_entries`

6. **Check RLS Status**
   - Click on each table
   - Look for "RLS enabled" badge (green checkmark)
   - All 5 tables should have RLS enabled

---

### Part 2: Create Storage Bucket (3 minutes)

1. **Navigate to Storage**
   - Go to: Storage section in left sidebar
   - Click: "Create a new bucket"

2. **Configure Bucket**
   - **Name:** `wardrobe-images`
   - **Public:** OFF (keep private)
   - **File size limit:** 10 MB
   - **Allowed MIME types:**
     ```
     image/jpeg
     image/png
     image/heic
     image/webp
     ```

3. **Create Bucket**
   - Click "Create bucket"
   - Verify it appears in Storage list

---

### Part 3: Deploy Storage Policies (2 minutes)

1. **Return to SQL Editor**
   - Navigate back to: SQL Editor
   - Click "+ New query"
   - Name it: "Storage Policies"

2. **Paste Storage Policies**
   - Open: `supabase_storage_policies.sql`
   - Copy entire contents
   - Paste into SQL Editor

3. **Execute Policies**
   - Click "Run"
   - Wait for completion
   - You should see: "Success. No rows returned"

4. **Verify Policies**
   - Go to: Storage → wardrobe-images
   - Click: Policies tab
   - You should see 4 policies:
     - ✓ Users can upload own images
     - ✓ Users can view own images
     - ✓ Users can update own images
     - ✓ Users can delete own images

---

## ✅ Verification Checklist

After deployment, verify everything is working:

### Database Tables
- [ ] 5 tables exist in Table Editor
- [ ] All tables have RLS enabled (green badge)
- [ ] Can view table structure and columns
- [ ] Policies are visible in table settings

### Indexes
- [ ] Navigate to: Database → Indexes
- [ ] Verify 5 indexes created:
  - `idx_wardrobe_items_user_id`
  - `idx_wardrobe_items_category`
  - `idx_wardrobe_items_is_archived`
  - `idx_outfits_user_id`
  - `idx_planner_entries_user_date`

### Functions
- [ ] Navigate to: Database → Functions
- [ ] Verify 2 functions exist:
  - `update_updated_at_column()`
  - `handle_new_user()`

### Triggers
- [ ] Navigate to: Database → Triggers
- [ ] Verify 6 triggers exist:
  - `update_users_updated_at`
  - `update_user_preferences_updated_at`
  - `update_wardrobe_items_updated_at`
  - `update_outfits_updated_at`
  - `update_planner_entries_updated_at`
  - `on_auth_user_created`

### Storage
- [ ] `wardrobe-images` bucket exists
- [ ] Bucket is private (not public)
- [ ] 4 RLS policies are active

---

## 🧪 Test the Schema (Optional)

You can test the schema is working correctly:

### Test 1: Triggers Work

```sql
-- Create a test user entry (will fail without auth, but that's expected)
-- This is just to verify the schema structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users';
```

### Test 2: Check RLS Policies

```sql
-- View all policies
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'public';
```

### Test 3: Verify Foreign Keys

```sql
-- Check foreign key relationships
SELECT
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'public';
```

---

## 📊 Database Schema Summary

### Tables Created

| Table | Rows (Initial) | RLS | Purpose |
|-------|---------------|-----|---------|
| `users` | 0 | ✓ | User profiles extending auth.users |
| `user_preferences` | 0 | ✓ | Style preferences and settings |
| `wardrobe_items` | 0 | ✓ | Individual clothing items |
| `outfits` | 0 | ✓ | Outfit combinations |
| `planner_entries` | 0 | ✓ | Daily outfit planning |

### Security Model

- **RLS Enabled:** All tables protected
- **Auth-based:** Users can only access their own data
- **Cascade Deletes:** User data removed when user deleted
- **Storage Isolation:** Images stored in user-specific folders

### Performance Optimizations

- **5 indexes** on frequently queried columns
- **Automatic timestamps** via triggers
- **UUID primary keys** for distributed scaling

---

## 🎯 Success Criteria

You've successfully completed Step 1.2 when:

- ✅ All 5 tables exist with correct schema
- ✅ RLS is enabled and policies are active
- ✅ Storage bucket is created with 4 policies
- ✅ All indexes, functions, and triggers are operational
- ✅ No SQL errors during deployment

---

## 🐛 Troubleshooting

### Error: "relation already exists"

**Cause:** Table was partially created in a previous attempt

**Fix:**
```sql
-- Drop existing tables (careful - this deletes data!)
DROP TABLE IF EXISTS public.planner_entries CASCADE;
DROP TABLE IF EXISTS public.outfits CASCADE;
DROP TABLE IF EXISTS public.wardrobe_items CASCADE;
DROP TABLE IF EXISTS public.user_preferences CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Then re-run the schema
```

### Error: "policy already exists"

**Cause:** Policies were partially created

**Fix:**
```sql
-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
-- ... (drop all policies)

-- Then re-run the policy section
```

### Storage bucket not showing policies

**Cause:** Policies didn't execute correctly

**Fix:**
- Go to Storage → wardrobe-images → Policies
- Click "New policy"
- Manually create policies using the SQL from `supabase_storage_policies.sql`

---

## 📝 Next Steps

After completing this step, you're ready for:

**Step 1.5: Data Models (Day 3)**
- Create SwiftData models matching this schema
- Implement enums and computed properties
- Set up model relationships

See: `PRODUCTION_BUILD_PLAN.md` lines 678-900

---

## 📸 Screenshots to Verify

1. **Table Editor showing 5 tables**
2. **RLS badge on each table**
3. **Storage bucket with policies**
4. **Functions list showing 2 functions**
5. **Triggers list showing 6 triggers**

---

## ⏱️ Time Tracking

- Schema deployment: ~5 minutes
- Storage setup: ~3 minutes
- Verification: ~2 minutes
- **Total:** ~10 minutes

---

**Deployment Date:** November 11, 2025  
**Schema Version:** v1.0  
**Status:** Ready for deployment ⏭️


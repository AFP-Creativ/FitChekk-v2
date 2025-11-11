# FitChekk Database Setup Files

Quick reference for deploying the FitChekk database schema to Supabase.

---

## 📁 Files in This Directory

### Deployment Files
- **`supabase_schema_v1.sql`** - Main database schema (tables, RLS, indexes, triggers)
- **`supabase_storage_policies.sql`** - Storage bucket RLS policies

### Documentation
- **`DATABASE_DEPLOYMENT_GUIDE.md`** - Complete step-by-step deployment instructions
- **`DATABASE_SCHEMA_REFERENCE.md`** - Quick reference for schema structure

---

## 🚀 Quick Start

### 1. Deploy Database Schema (5 minutes)

1. Go to: https://supabase.com/dashboard/project/paufghpcdsvspznnygxo/editor
2. Create new query
3. Copy & paste contents of `supabase_schema_v1.sql`
4. Click "Run"
5. Verify 5 tables created in Table Editor

### 2. Create Storage Bucket (3 minutes)

1. Go to: Storage section in Supabase Dashboard
2. Create bucket: `wardrobe-images`
3. Settings: Private, 10MB max file size
4. Allowed types: image/jpeg, image/png, image/heic, image/webp

### 3. Deploy Storage Policies (2 minutes)

1. Return to SQL Editor
2. Create new query
3. Copy & paste contents of `supabase_storage_policies.sql`
4. Click "Run"
5. Verify 4 policies created in Storage → Policies

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] 5 tables exist: users, user_preferences, wardrobe_items, outfits, planner_entries
- [ ] All tables have RLS enabled (green badge)
- [ ] Storage bucket `wardrobe-images` exists
- [ ] 4 storage policies active
- [ ] 2 functions exist: update_updated_at_column, handle_new_user
- [ ] 6 triggers exist (5 for updated_at + 1 for auth)

---

## 📊 What Gets Created

### Database Tables (5)
1. **users** - User profiles extending auth.users
2. **user_preferences** - Style preferences and app settings
3. **wardrobe_items** - Individual clothing items with AI attributes
4. **outfits** - Outfit combinations with AI suggestions
5. **planner_entries** - Daily outfit planning with weather

### Security
- Row-Level Security (RLS) enabled on all tables
- 7 RLS policies protecting user data
- 4 storage policies for image uploads
- Users can only access their own data

### Performance
- 5 indexes on frequently queried columns
- Automatic timestamp updates via triggers
- Cascade deletes for data cleanup

### Automation
- Auto-create user profile on signup
- Auto-create user preferences on signup
- Auto-update `updated_at` on all table updates

---

## 🔗 Supabase Project

- **Project URL:** https://paufghpcdsvspznnygxo.supabase.co
- **Dashboard:** https://supabase.com/dashboard/project/paufghpcdsvspznnygxo
- **API Keys:** Stored in `FitChekk/Configuration/*.xcconfig` (not in git)

---

## 📚 Detailed Documentation

For complete information, see:

- **`DATABASE_DEPLOYMENT_GUIDE.md`** - Full deployment walkthrough with troubleshooting
- **`DATABASE_SCHEMA_REFERENCE.md`** - Table structures, relationships, and common queries

---

## 🆘 Need Help?

### Schema already exists?
See troubleshooting section in `DATABASE_DEPLOYMENT_GUIDE.md`

### Policies not working?
Verify auth.uid() matches user_id in test queries

### Storage bucket issues?
Ensure bucket name is exactly `wardrobe-images` (with dash)

---

## ⏭️ Next Steps

After successful deployment:

1. **Step 1.5: Data Models** - Create SwiftData models matching this schema
2. **Step 1.7: Service Layer** - Implement Supabase service interfaces
3. **Step 1.8: Testing** - Set up test infrastructure

See `PRODUCTION_BUILD_PLAN.md` for full roadmap.

---

**Schema Version:** v1.0  
**Created:** November 11, 2025  
**Status:** Ready for deployment 📝


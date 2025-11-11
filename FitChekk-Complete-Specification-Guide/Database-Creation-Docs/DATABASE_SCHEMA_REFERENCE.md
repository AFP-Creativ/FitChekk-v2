# FitChekk Database Schema Reference

Quick reference for the FitChekk database structure.

---

## 📊 Tables Overview

### `users`
Extends Supabase `auth.users` with app-specific profile data.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | PK, FK to auth.users |
| `email` | TEXT | User's email |
| `display_name` | TEXT | Display name |
| `subscription_tier` | TEXT | 'free' or 'premium' |
| `subscription_status` | TEXT | 'active', 'canceled', 'expired', 'trial' |
| `trial_ends_at` | TIMESTAMPTZ | Trial expiration date |
| `created_at` | TIMESTAMPTZ | Auto-set |
| `updated_at` | TIMESTAMPTZ | Auto-updated |

**RLS:** Users can read/update own profile only

---

### `user_preferences`
Style preferences and app settings.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | PK |
| `user_id` | UUID | FK to users (unique) |
| `style_preferences` | TEXT[] | Array of style tags |
| `favorite_colors` | TEXT[] | Array of color names |
| `lifestyle_type` | TEXT | e.g., "professional", "casual" |
| `activity_level` | TEXT | e.g., "active", "moderate" |
| `occasions` | TEXT[] | Common occasions |
| `climate_type` | TEXT | e.g., "temperate", "tropical" |
| `measurement_system` | TEXT | 'imperial' or 'metric' |
| `enable_notifications` | BOOLEAN | Default: true |
| `notification_time` | TIME | Preferred notification time |
| `onboarding_completed` | BOOLEAN | Default: false |
| `created_at` | TIMESTAMPTZ | Auto-set |
| `updated_at` | TIMESTAMPTZ | Auto-updated |

**RLS:** Full CRUD on own preferences

---

### `wardrobe_items`
Individual clothing items with AI-extracted attributes.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | PK |
| `user_id` | UUID | FK to users |
| `name` | TEXT | Item name |
| `category` | TEXT | Required: tops, bottoms, shoes, etc. |
| `sub_category` | TEXT | Required: specific type |
| `brand` | TEXT | Brand name |
| `purchase_date` | DATE | When purchased |
| `purchase_price` | DECIMAL(10,2) | Purchase price |
| **Images** |
| `image_url` | TEXT | Full image path |
| `thumbnail_url` | TEXT | Thumbnail path |
| **AI Attributes** |
| `ai_generated` | BOOLEAN | Created by AI? |
| `colors` | TEXT[] | Detected colors |
| `pattern` | TEXT | e.g., "solid", "striped" |
| `formality` | INTEGER | 1-5 scale |
| `style_tags` | TEXT[] | Style descriptors |
| `seasons` | TEXT[] | Suitable seasons |
| `material_type` | TEXT | Fabric type |
| `ai_confidence` | DECIMAL(3,2) | AI confidence 0-1 |
| **User Metadata** |
| `is_favorite` | BOOLEAN | Favorited by user |
| `notes` | TEXT | User notes |
| `is_archived` | BOOLEAN | Hidden from main view |
| **Usage Stats** |
| `times_worn` | INTEGER | Wear count |
| `last_worn_date` | DATE | Last wear date |
| **Sync** |
| `needs_sync` | BOOLEAN | Pending sync flag |
| `created_at` | TIMESTAMPTZ | Auto-set |
| `updated_at` | TIMESTAMPTZ | Auto-updated |

**RLS:** Full CRUD on own items  
**Indexes:** `user_id`, `category`, `is_archived`

---

### `outfits`
Outfit combinations with AI suggestions.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | PK |
| `user_id` | UUID | FK to users |
| `name` | TEXT | Required: outfit name |
| `occasion` | TEXT | Occasion type |
| `season` | TEXT | Best season |
| `notes` | TEXT | User notes |
| **AI Attributes** |
| `ai_generated` | BOOLEAN | AI-created outfit? |
| `ai_reasoning` | TEXT | Why AI suggested this |
| `ai_style_score` | DECIMAL(3,2) | AI style rating 0-1 |
| **Weather Snapshot** |
| `weather_temp_high` | INTEGER | High temp (F) |
| `weather_temp_low` | INTEGER | Low temp (F) |
| `weather_condition` | TEXT | Weather description |
| **Usage Stats** |
| `times_worn` | INTEGER | Wear count |
| `last_worn_date` | DATE | Last wear date |
| `user_rating` | INTEGER | 1-5 user rating |
| **Item References** |
| `item_ids` | UUID[] | Array of wardrobe_item IDs |
| `created_at` | TIMESTAMPTZ | Auto-set |
| `updated_at` | TIMESTAMPTZ | Auto-updated |

**RLS:** Full CRUD on own outfits  
**Index:** `user_id`

---

### `planner_entries`
Daily outfit planning with weather.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | PK |
| `user_id` | UUID | FK to users |
| `date` | DATE | Required: planned date |
| `outfit_id` | UUID | FK to outfits (nullable) |
| **Status** |
| `is_worn` | BOOLEAN | Marked as worn? |
| `marked_worn_at` | TIMESTAMPTZ | When marked worn |
| **Cached Weather** |
| `weather_temp_high` | INTEGER | High temp (F) |
| `weather_temp_low` | INTEGER | Low temp (F) |
| `weather_condition` | TEXT | Weather description |
| `weather_feels_like` | INTEGER | Feels like temp (F) |
| `weather_humidity` | INTEGER | Humidity % |
| `created_at` | TIMESTAMPTZ | Auto-set |
| `updated_at` | TIMESTAMPTZ | Auto-updated |

**RLS:** Full CRUD on own entries  
**Index:** `user_id, date`  
**Constraint:** Unique (user_id, date) - one entry per user per day

---

## 🔐 Security Model

### Row-Level Security (RLS)

All tables have RLS enabled with policies enforcing:
- Users can only access their own data
- Auth is required for all operations
- `auth.uid()` matches `user_id` column

### Policy Summary

| Table | Policy |
|-------|--------|
| `users` | SELECT, UPDATE own profile |
| `user_preferences` | Full CRUD |
| `wardrobe_items` | Full CRUD |
| `outfits` | Full CRUD |
| `planner_entries` | Full CRUD |

### Storage Security

**Bucket:** `wardrobe-images` (private)

- Users can upload to: `{user_id}/{filename}`
- Users can only access their own folder
- 10MB max file size
- Allowed: JPEG, PNG, HEIC, WebP

---

## 🔄 Automatic Behaviors

### Triggers

**Auto-Update Timestamps:**
- All tables have `updated_at` auto-updated on UPDATE
- Trigger: `update_{table}_updated_at`
- Function: `update_updated_at_column()`

**User Creation:**
- When new user signs up via auth
- Automatically creates `users` profile
- Automatically creates `user_preferences` record
- Trigger: `on_auth_user_created`
- Function: `handle_new_user()`

### Cascade Deletes

When a user is deleted:
- ✓ `user_preferences` deleted
- ✓ `wardrobe_items` deleted
- ✓ `outfits` deleted
- ✓ `planner_entries` deleted

When an outfit is deleted:
- `planner_entries.outfit_id` set to NULL (not deleted)

---

## 📈 Performance Indexes

| Index | Table | Columns | Purpose |
|-------|-------|---------|---------|
| `idx_wardrobe_items_user_id` | wardrobe_items | user_id | Fast user queries |
| `idx_wardrobe_items_category` | wardrobe_items | category | Category filtering |
| `idx_wardrobe_items_is_archived` | wardrobe_items | is_archived | Active/archived split |
| `idx_outfits_user_id` | outfits | user_id | Fast user queries |
| `idx_planner_entries_user_date` | planner_entries | user_id, date | Calendar queries |

---

## 🎯 Common Queries

### Get User's Active Wardrobe

```sql
SELECT * FROM wardrobe_items
WHERE user_id = auth.uid()
AND is_archived = false
ORDER BY created_at DESC;
```

### Get Outfits with Items

```sql
SELECT 
  o.*,
  (SELECT array_agg(wi.*) 
   FROM wardrobe_items wi 
   WHERE wi.id = ANY(o.item_ids)
  ) as items
FROM outfits o
WHERE o.user_id = auth.uid();
```

### Get Week's Planner

```sql
SELECT * FROM planner_entries
WHERE user_id = auth.uid()
AND date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
ORDER BY date ASC;
```

### Get Most Worn Items

```sql
SELECT * FROM wardrobe_items
WHERE user_id = auth.uid()
ORDER BY times_worn DESC
LIMIT 10;
```

---

## 🔢 Enums & Constants

### Subscription Tiers
- `free`
- `premium`

### Subscription Status
- `active`
- `canceled`
- `expired`
- `trial`

### Categories (from spec)
- `tops`
- `bottoms`
- `dresses`
- `outerwear`
- `shoes`
- `accessories`

### Formality Levels
- `1` - Very Casual
- `2` - Casual
- `3` - Smart Casual
- `4` - Business
- `5` - Formal

### Seasons
- `spring`
- `summer`
- `fall`
- `winter`
- `all-season`

---

## 📱 Image Storage Paths

**Format:** `{user_id}/{item_id}.{ext}`

**Example:**
```
123e4567-e89b-12d3-a456-426614174000/
  ├── abc-def-ghi-item-1.jpg
  ├── abc-def-ghi-item-2.jpg
  └── thumbnails/
      ├── abc-def-ghi-item-1.jpg
      └── abc-def-ghi-item-2.jpg
```

---

## 🧪 Testing Queries

### Verify Schema

```sql
-- Count tables
SELECT count(*) FROM information_schema.tables 
WHERE table_schema = 'public';
-- Should return: 5

-- Check RLS status
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
-- All should be: t (true)

-- Count policies
SELECT count(*) FROM pg_policies 
WHERE schemaname = 'public';
-- Should return: 7

-- Count indexes
SELECT count(*) FROM pg_indexes 
WHERE schemaname = 'public';
-- Should return: 5 custom + system indexes
```

---

## 🔗 Relationships

```
auth.users (Supabase Auth)
    ↓
users (1:1)
    ├── user_preferences (1:1)
    ├── wardrobe_items (1:many)
    ├── outfits (1:many)
    └── planner_entries (1:many)

outfits
    └── item_ids[] → wardrobe_items (many:many via array)

planner_entries
    └── outfit_id → outfits (many:1, nullable)
```

---

## 📝 Notes

- All UUIDs are v4 generated by `uuid_generate_v4()`
- All timestamps use `TIMESTAMPTZ` for timezone awareness
- Arrays use PostgreSQL native array type `TEXT[]`, `UUID[]`
- Prices use `DECIMAL(10,2)` for precision
- Formality and ratings use `INTEGER` with `CHECK` constraints

---

**Schema Version:** v1.0  
**Last Updated:** November 11, 2025  
**Deployed:** [Date after deployment]


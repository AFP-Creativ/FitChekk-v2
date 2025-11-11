# FitChekk Production Build Plan

**Project**: FitChekk v1.0 - Complete Rewrite (Option B)  
**Branch**: `production-foundation`  
**Team**: 1 AI Developer + 1 Technical Reviewer  
**Timeline**: 11-12 weeks  
**Start Date**: November 10, 2025  
**Target Launch**: Late January 2026

---

## 📋 Executive Summary

This document provides a **step-by-step guide** to building FitChekk from the ground up, using the mockup as UI/UX reference while implementing production-grade architecture, real backend integration, and comprehensive testing.

**Build Philosophy**: 
- Clean architecture from day one (TCA + SwiftData + Supabase)
- Test-driven development (85%+ coverage)
- Vertical slices (complete features end-to-end)
- Port proven UI/UX from mockup with strategic improvements
- **100% AI code generation** (human reviews with AI assistance only)

---

## 🎯 Success Criteria

Before merging to `main`, we must have:
- ✅ Real TCA architecture throughout
- ✅ Supabase backend fully integrated
- ✅ All three auth methods working
- ✅ SwiftData persistence + sync
- ✅ At least Wardrobe + Outfit features complete
- ✅ AI categorization functional (Gemini)
- ✅ 85%+ test coverage
- ✅ CI/CD pipeline operational
- ✅ No hardcoded secrets
- ✅ App runs on physical device with real data

---

## 📱 MVP Feature Requirements

### Core Features (Must-Have for v1.0)

- ✅ **Authentication**: All three methods (Apple/Google/Email)
- ✅ **Wardrobe Management**: Full CRUD with AI categorization
- ✅ **Outfit Creation**: Manual creation with visual canvas
- ✅ **AI Outfit Suggestions**: Claude-powered with reasoning
- ✅ **Calendar Planner**: Schedule outfits, wear tracking
- ✅ **Weather Integration**: Real WeatherKit data
- ✅ **Subscription System**: StoreKit 2 with paywall
- ✅ **Wardrobe Analytics**: 
  - Wear frequency analysis
  - Favorite items stats
  - Category distribution
  - Color palette analysis
- ✅ **Outfit Analytics**:
  - Style preference insights
  - Color combination analysis
  - Occasion breakdown
  - Seasonal trends
  - Most successful outfits

### UI/UX Improvements from Mockup

The following refinements will be implemented during appropriate phases:

**1. AI Explanation on Demand** *(Phase 5 - Week 6)*
- Home screen AI reasoning should be hidden by default
- Add "Why this works?" button/link
- Clicking reveals the AI explanation
- **Rationale**: Reduces API costs, cleaner UI, respects user preference

**2. Language & Tone Update** *(Phase 9 - Week 11)*
- Replace formal fashion terminology with casual, conversational language for women 18-50
- Examples of changes needed:
  - ❌ "Smart Casual" → ✅ "Dressed up but chill"
  - ❌ "Business Casual" → ✅ "Office appropriate"
  - ❌ "Formal" → ✅ "Fancy/dressed up"
  - ❌ "Formality Level" → ✅ "How fancy is it?"
- Apply throughout: categories, AI responses, UI copy, empty states
- **Rationale**: Speak the target audience's language (from 20-something college students to fashionable moms in thier 40s)

**3. Date Added Field** *(Phase 3 - Week 3)*
- Add "Date Added" to wardrobe item detail view
- Display format: "Added [relative date]" (e.g., "Added 2 weeks ago")
- Include in item model from the start
- **Rationale**: Helps users remember context of purchase/addition

**4. Remove Total Wears Card** *(Phase 9 - Week 11)*
- Remove "Total Wears" summary card from Settings screen
- Keep individual item wear counts
- **Rationale**: Number becomes meaningless at scale, doesn't provide actionable insight

---

## 📦 Phase 0: Pre-Development Setup (Week 0)

**Status**: ✅ Core Setup Complete | ⏸️ Deferred Items Scheduled

### Step 0.1: Environment Configuration ✅ COMPLETE

**Supabase Project Setup** ✅ 

Your Supabase project: https://supabase.com/dashboard/project/paufghpcdsvspznnygxo

1. **Get API Credentials** ✅ DONE
   - ✅ Project URL: `https://paufghpcdsvspznnygxo.supabase.co`
   - ✅ Publishable key: Secured in Development.xcconfig
   - ✅ Secret key: Secured in Development.xcconfig

2. **Database Schema Deployment** ⏸️ DEFERRED TO STEP 1.2
   - Will deploy complete schema at start of Week 1
   - Includes all tables, RLS policies, triggers, and functions

3. **Storage Buckets** ⏸️ DEFERRED TO STEP 1.2
   - Will create `wardrobe-images` bucket with database deployment
   - Will create `user-avatars` bucket with database deployment

4. **Auth Configuration** ⏸️ DEFERRED TO PHASE 2 (WEEK 2)
   - Email provider will be enabled when building auth feature
   - Apple/Google configured when implementing Sign in with Apple/Google

**Portkey Configuration** ✅ 

1. **Virtual Keys Setup** ⏸️ DEFERRED TO WEEK 5 (AI INTEGRATION)
   - Main Portkey API key secured ✅
   - Virtual keys for Gemini/Claude will be added when building AI features
   - Allows us to start coding without AI provider dependencies

2. **Cost Tracking** ⏸️ DEFERRED TO WEEK 5
   - Will set up cost alerts when activating AI services
   - Rate limiting will be implemented in code during AI integration

**Apple Developer Configuration** ✅ 

1. **Bundle Identifier** ✅ DONE
   - ✅ Decided: `com.afpcreativ.fitchekk`
   - ✅ Saved in Configuration/Shared.xcconfig
   - ⏸️ Apple Developer Portal registration: Will do when creating Xcode project
   - ⏸️ Capabilities (Sign in with Apple, Push Notifications): Will enable in Phase 2

2. **App Store Connect** ⏸️ DEFERRED TO WEEK 10
   - Will create App Store listing during launch preparation
   - Bundle ID locked in and ready to use

3. **WeatherKit** ⏸️ DEFERRED TO WEEK 9
   - Will enable when building weather integration feature
   - Free tier: 500K API calls/month

**Phase 0 Deliverables**:
- ✅ Supabase API keys secured (publishable + secret)
- ✅ Portkey API key configured
- ✅ Bundle identifier decided: `com.afpcreativ.fitchekk`
- ✅ Configuration file structure created (.xcconfig files)
- ✅ API keys protected by .gitignore
- ⏸️ Database schema deployment → Moving to Step 1.2
- ⏸️ Storage buckets → Moving to Step 1.2
- ⏸️ Portkey virtual keys → Moving to Week 5 (when needed)
- ⏸️ Apple Developer portal setup → Moving to Week 1 (with Xcode project)
- ⏸️ Auth providers → Moving to Phase 2 (when building auth)

**✅ READY TO START PHASE 1: FOUNDATION (WEEK 1)**

---

## 🏗️ Phase 1: Foundation (Week 1)

**Goal**: Establish production-grade project structure, dependencies, and core architecture

**Status**: 🚧 In Progress | Step 1.1 ✅ Complete | Step 1.2 ✅ Complete | Step 1.5 ✅ Complete | Step 1.7 ✅ Complete

### Step 1.0: Local Development Tools (Before Starting)

**Install Required Development Tools**

Before creating the Xcode project, ensure these tools are installed:

```bash
# Check if Homebrew is installed
which brew

# If not installed, install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install SwiftLint (code quality)
brew install swiftlint

# Install xcov (code coverage reporting) - optional
brew install xcov
```

**Verify Installation:**
```bash
swiftlint version  # Should show version number
xcodebuild -version  # Should show Xcode 15.2+
```

---

### Step 1.1: New Xcode Project Setup (Day 1) ✅ COMPLETE

**Create Fresh Project**

1. **New Xcode Project**
   ```
   File → New → Project
   iOS → App
   
   Product Name: FitChekk
   Team: [Your Apple Developer Team]
   Organization Identifier: com.afpcreativ (or your choice)
   Bundle Identifier: com.afpcreativ.fitchekk
   Interface: SwiftUI
   Language: Swift
   
   ✅ Include Tests
   ❌ Include UI Tests (we'll add later)
   ```

2. **Project Settings**
   - Deployment Target: iOS 17.0
   - Supported Destinations: iPhone only
   - Orientation: Portrait only (for v1.0)

3. **Create Folder Structure**
   ```
   FitChekk/
   ├── App/
   │   ├── FitChekkApp.swift
   │   ├── AppFeature.swift
   │   └── AppView.swift
   ├── Features/
   │   ├── Authentication/
   │   ├── Home/
   │   ├── Wardrobe/
   │   ├── Outfits/
   │   ├── Planner/
   │   └── Settings/
   ├── Services/
   │   ├── AI/
   │   ├── Data/
   │   ├── Authentication/
   │   ├── Weather/
   │   ├── Image/
   │   └── Subscription/
   ├── Shared/
   │   ├── Components/
   │   ├── DesignSystem/
   │   ├── Extensions/
   │   ├── Models/
   │   └── Utilities/
   ├── Configuration/
   │   ├── Development.xcconfig
   │   └── Production.xcconfig
   └── Resources/
       └── Assets.xcassets/
   ```

**Add Dependencies via Swift Package Manager**

1. Open: File → Add Package Dependencies
2. Add these packages:

```swift
// The Composable Architecture
https://github.com/pointfreeco/swift-composable-architecture
Version: 1.15.0 (or latest)

// Supabase Swift
https://github.com/supabase/supabase-swift
Version: 2.5.0 (or latest)

// Swift Dependencies (TCA dependency management)
https://github.com/pointfreeco/swift-dependencies
Version: 1.0.0 (or latest)
```

**Setup Configuration Files**

1. Create `Configuration/Shared.xcconfig`:
```
// Shared configuration across environments
MARKETING_VERSION = 1.0.0
CURRENT_PROJECT_VERSION = 1
IPHONEOS_DEPLOYMENT_TARGET = 17.0
SWIFT_VERSION = 6.0
```

2. Create `Configuration/Development.xcconfig`:
```
#include "Shared.xcconfig"

// Supabase
SUPABASE_URL = https:/​/paufghpcdsvspznnygxo.supabase.co
SUPABASE_ANON_KEY = [paste-your-anon-key]

// Portkey
PORTKEY_API_KEY = [paste-your-key]
PORTKEY_GEMINI_KEY = [paste-virtual-key-id]
PORTKEY_CLAUDE_KEY = [paste-virtual-key-id]

// Environment indicator
ENVIRONMENT = Development
```

3. Create `Configuration/Production.xcconfig`:
```
#include "Shared.xcconfig"

// Same keys as Development for now
// In future, you'll have separate production Supabase project
SUPABASE_URL = https:/​/paufghpcdsvspznnygxo.supabase.co
SUPABASE_ANON_KEY = [paste-your-anon-key]

PORTKEY_API_KEY = [paste-your-key]
PORTKEY_GEMINI_KEY = [paste-virtual-key-id]
PORTKEY_CLAUDE_KEY = [paste-virtual-key-id]

ENVIRONMENT = Production
```

4. **Link Configuration to Build Schemes**
   - Project Settings → Configurations
   - Debug → Development.xcconfig
   - Release → Production.xcconfig

5. **Update .gitignore**
```gitignore
# Xcode
*.xcuserstate
*.xcworkspace
!default.xcworkspace
xcuserdata/
DerivedData/
.swiftpm/

# Configuration secrets
Configuration/*.xcconfig
!Configuration/Shared.xcconfig

# Environment files
.env
.env.*

# API Keys
**/APIKeys.swift

# macOS
.DS_Store
```

**Setup SwiftLint**

Create `.swiftlint.yml` in project root:
```yaml
disabled_rules:
  - trailing_whitespace

opt_in_rules:
  - empty_count
  - force_unwrapping
  - missing_docs

line_length: 120

function_body_length:
  warning: 60
  error: 100

type_body_length:
  warning: 300
  error: 500

file_length:
  warning: 500
  error: 1000

excluded:
  - Pods
  - .build
  - Tests
  - FitChekkTests
```

Add SwiftLint build phase:
- Target → Build Phases → New Run Script Phase
- Script:
```bash
if which swiftlint >/dev/null; then
  swiftlint lint --strict
else
  echo "warning: SwiftLint not installed"
fi
```

**Deliverables**:
- ✅ Fresh Xcode project created (bundle ID: com.afpcreativ.fitchekk)
- ✅ All dependencies installed (TCA 1.23.1, Supabase Swift 2.37.0, Swift Dependencies 1.0.0)
- ✅ Folder structure established (App/, Features/, Services/, Shared/, Resources/)
- ✅ Configuration files set up and linked to build schemes
- ✅ SwiftLint configured and passing
- ✅ Design system ported from mockup (Colors, Typography, Spacing) - *completed early*
- ✅ Shared components created (Buttons, Cards, EmptyStates) - *completed early*
- ✅ Root TCA architecture (AppFeature, AppView, FitChekkApp) - *completed early*
- ✅ Project builds successfully with no errors
- ✅ Committed to git (commit: 7874f6f)

**What was completed ahead of schedule:**
- Step 1.3 (Design System Migration) - integrated into Step 1.1
- Step 1.4 (Shared Components) - integrated into Step 1.1  
- Step 1.6 (TCA Architecture Foundation) - basic setup integrated into Step 1.1

**Next up:** Step 1.5 - Data Models (SwiftData)

---

### Step 1.2: Database Schema (Day 1-2) ✅ COMPLETE

**Create Supabase Schema**

✅ **Deployment Complete** - All schema deployed and verified via Supabase Dashboard

**Files created:**
- `supabase_schema_v1.sql` - Complete database schema ✅ DEPLOYED
- `supabase_storage_policies.sql` - Storage bucket RLS policies ✅ DEPLOYED
- `DATABASE_DEPLOYMENT_GUIDE.md` - Step-by-step deployment instructions
- `DATABASE_SCHEMA_REFERENCE.md` - Quick reference for development
- `verification_tests_results.md` - Complete test results showing 100% success

1. **SQL Migration Script**

File created: `supabase_schema_v1.sql`

```sql
-- FitChekk Database Schema v1.0
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  display_name TEXT,
  subscription_tier TEXT NOT NULL DEFAULT 'free' CHECK (subscription_tier IN ('free', 'premium')),
  subscription_status TEXT CHECK (subscription_status IN ('active', 'canceled', 'expired', 'trial')),
  trial_ends_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- User preferences
CREATE TABLE public.user_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  style_preferences TEXT[] DEFAULT '{}',
  favorite_colors TEXT[] DEFAULT '{}',
  lifestyle_type TEXT,
  activity_level TEXT,
  occasions TEXT[] DEFAULT '{}',
  climate_type TEXT,
  measurement_system TEXT DEFAULT 'imperial',
  enable_notifications BOOLEAN DEFAULT true,
  notification_time TIME,
  onboarding_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Wardrobe items
CREATE TABLE public.wardrobe_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT,
  category TEXT NOT NULL,
  sub_category TEXT NOT NULL,
  brand TEXT,
  purchase_date DATE,
  purchase_price DECIMAL(10,2),
  
  -- Images
  image_url TEXT,
  thumbnail_url TEXT,
  
  -- AI attributes
  ai_generated BOOLEAN DEFAULT false,
  colors TEXT[] DEFAULT '{}',
  pattern TEXT,
  formality INTEGER CHECK (formality BETWEEN 1 AND 5),
  style_tags TEXT[] DEFAULT '{}',
  seasons TEXT[] DEFAULT '{}',
  material_type TEXT,
  ai_confidence DECIMAL(3,2),
  
  -- User metadata
  is_favorite BOOLEAN DEFAULT false,
  notes TEXT,
  is_archived BOOLEAN DEFAULT false,
  
  -- Usage stats
  times_worn INTEGER DEFAULT 0,
  last_worn_date DATE,
  
  -- Sync
  needs_sync BOOLEAN DEFAULT false,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Outfits
CREATE TABLE public.outfits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  occasion TEXT,
  season TEXT,
  notes TEXT,
  
  -- AI attributes
  ai_generated BOOLEAN DEFAULT false,
  ai_reasoning TEXT,
  ai_style_score DECIMAL(3,2),
  
  -- Weather snapshot (at time of creation)
  weather_temp_high INTEGER,
  weather_temp_low INTEGER,
  weather_condition TEXT,
  
  -- Usage stats
  times_worn INTEGER DEFAULT 0,
  last_worn_date DATE,
  user_rating INTEGER CHECK (user_rating BETWEEN 1 AND 5),
  
  -- Item references (stored as array of UUIDs)
  item_ids UUID[] NOT NULL DEFAULT '{}',
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Planner entries
CREATE TABLE public.planner_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  outfit_id UUID REFERENCES public.outfits(id) ON DELETE SET NULL,
  
  -- Status
  is_worn BOOLEAN DEFAULT false,
  marked_worn_at TIMESTAMPTZ,
  
  -- Cached weather
  weather_temp_high INTEGER,
  weather_temp_low INTEGER,
  weather_condition TEXT,
  weather_feels_like INTEGER,
  weather_humidity INTEGER,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(user_id, date)
);

-- Indexes for performance
CREATE INDEX idx_wardrobe_items_user_id ON public.wardrobe_items(user_id);
CREATE INDEX idx_wardrobe_items_category ON public.wardrobe_items(category);
CREATE INDEX idx_wardrobe_items_is_archived ON public.wardrobe_items(is_archived);
CREATE INDEX idx_outfits_user_id ON public.outfits(user_id);
CREATE INDEX idx_planner_entries_user_date ON public.planner_entries(user_id, date);

-- Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wardrobe_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.outfits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.planner_entries ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Users: Can only read/update own profile
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- User preferences: Full CRUD on own preferences
CREATE POLICY "Users can manage own preferences" ON public.user_preferences
  FOR ALL USING (auth.uid() = user_id);

-- Wardrobe items: Full CRUD on own items
CREATE POLICY "Users can manage own wardrobe" ON public.wardrobe_items
  FOR ALL USING (auth.uid() = user_id);

-- Outfits: Full CRUD on own outfits
CREATE POLICY "Users can manage own outfits" ON public.outfits
  FOR ALL USING (auth.uid() = user_id);

-- Planner entries: Full CRUD on own entries
CREATE POLICY "Users can manage own planner" ON public.planner_entries
  FOR ALL USING (auth.uid() = user_id);

-- Functions

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at BEFORE UPDATE ON public.user_preferences
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_wardrobe_items_updated_at BEFORE UPDATE ON public.wardrobe_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_outfits_updated_at BEFORE UPDATE ON public.outfits
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_planner_entries_updated_at BEFORE UPDATE ON public.planner_entries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'display_name');
  
  INSERT INTO public.user_preferences (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

2. **Deploy Schema**
   - Go to Supabase SQL Editor
   - Paste the entire script
   - Click "Run"
   - Verify all tables created in Table Editor

3. **Setup Storage Buckets**
   - Storage → Create bucket: `wardrobe-images`
   - Settings: Private, 10MB file size limit
   - Create RLS policy:
   ```sql
   -- Users can upload to their own folder
   CREATE POLICY "Users can upload own images" ON storage.objects
     FOR INSERT WITH CHECK (
       bucket_id = 'wardrobe-images' 
       AND auth.uid()::text = (storage.foldername(name))[1]
     );
   
   -- Users can view own images
   CREATE POLICY "Users can view own images" ON storage.objects
     FOR SELECT USING (
       bucket_id = 'wardrobe-images' 
       AND auth.uid()::text = (storage.foldername(name))[1]
     );
   ```

**Deliverables**:
- ✅ Complete database schema deployed (`supabase_schema_v1.sql`)
- ✅ RLS policies active on all 5 tables
- ✅ Storage bucket `wardrobe-images` created with 4 RLS policies
- ✅ All indexes, functions, and triggers operational
- ✅ 100% test verification passed (see `verification_tests_results.md`)

**Deployment Summary:**
- 5 tables created: users, user_preferences, wardrobe_items, outfits, planner_entries
- 6 RLS policies protecting user data
- 5 performance indexes deployed
- 2 functions: update_updated_at_column, handle_new_user
- 6 triggers: 5 for timestamps + 1 for auth
- Storage bucket with user-scoped access control

---

### Step 1.3: Design System Migration (Day 2) ✅ COMPLETE

**Port Design System from Mockup**

✅ **Completed in Step 1.1** - Design system was ported early to enable component development.

Your mockup has excellent design tokens. We ported them exactly as-is to maintain consistency.

**Create: `Shared/DesignSystem/Colors.swift`**

```swift
import SwiftUI

// MARK: - Color Extensions

extension Color {
    // MARK: - Primary Colors
    
    /// Primary accent color - energetic orange/coral
    static let accentPrimary = Color(hex: "#FF6B4A")
    
    /// Logo primary color - warm terracotta
    static let logoPrimary = Color(hex: "#E85D3F")
    
    /// Logo secondary color - deep teal
    static let logoSecondary = Color(hex: "#2C5F5D")
    
    // MARK: - Background Colors
    
    /// Primary background - light cream
    static let backgroundPrimary = Color(hex: "#FAF8F5")
    
    /// Secondary background - slightly darker cream
    static let backgroundSecondary = Color(hex: "#F5F2ED")
    
    /// Tertiary background - cards and surfaces
    static let backgroundTertiary = Color(hex: "#FFFFFF")
    
    // MARK: - Text Colors
    
    /// Primary text - almost black
    static let textPrimary = Color(hex: "#2D2A27")
    
    /// Secondary text - muted brown
    static let textSecondary = Color(hex: "#6B6560")
    
    /// Tertiary text - light gray
    static let textTertiary = Color(hex: "#A09A94")
    
    /// Inverted text - white
    static let textInverted = Color.white
    
    // MARK: - Semantic Colors
    
    /// Success - green
    static let success = Color(hex: "#4CAF50")
    static let successSubtle = Color(hex: "#E8F5E9")
    
    /// Warning - amber
    static let warning = Color(hex: "#FF9800")
    static let warningSubtle = Color(hex: "#FFF3E0")
    
    /// Error - red
    static let error = Color(hex: "#F44336")
    static let errorSubtle = Color(hex: "#FFEBEE")
    
    /// Info - blue
    static let info = Color(hex: "#2196F3")
    static let infoSubtle = Color(hex: "#E3F2FD")
    
    /// Energy - coral/orange
    static let energy = Color(hex: "#FF6B4A")
    static let energySubtle = Color(hex: "#FFE8E3")
    
    // MARK: - Neutral Grays
    
    static let gray50 = Color(hex: "#FAFAFA")
    static let gray100 = Color(hex: "#F5F5F5")
    static let gray200 = Color(hex: "#EEEEEE")
    static let gray300 = Color(hex: "#E0E0E0")
    static let gray400 = Color(hex: "#BDBDBD")
    static let gray500 = Color(hex: "#9E9E9E")
    static let gray600 = Color(hex: "#757575")
    static let gray700 = Color(hex: "#616161")
    static let gray800 = Color(hex: "#424242")
    static let gray900 = Color(hex: "#212121")
    
    // MARK: - Hex Initializer
    
    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

**Create: `Shared/DesignSystem/Typography.swift`**

```swift
import SwiftUI

// MARK: - Typography Scale

extension Font {
    // MARK: - Display
    
    /// Display Large - 40pt, bold
    static let displayLarge = Font.system(size: 40, weight: .bold, design: .default)
    
    /// Display Medium - 32pt, bold
    static let displayMedium = Font.system(size: 32, weight: .bold, design: .default)
    
    /// Display Small - 24pt, semibold
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .default)
    
    // MARK: - Headline
    
    /// Headline Large - 20pt, semibold
    static let headlineLarge = Font.system(size: 20, weight: .semibold, design: .default)
    
    /// Headline Medium - 18pt, semibold
    static let headlineMedium = Font.system(size: 18, weight: .semibold, design: .default)
    
    /// Headline Small - 16pt, semibold
    static let headlineSmall = Font.system(size: 16, weight: .semibold, design: .default)
    
    // MARK: - Body
    
    /// Body Large - 17pt, regular
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    
    /// Body Medium - 15pt, regular
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    
    /// Body Small - 13pt, regular
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
    
    // MARK: - Label
    
    /// Label Large - 14pt, medium
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    
    /// Label Medium - 12pt, medium
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    
    /// Label Small - 11pt, medium
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
}
```

**Create: `Shared/DesignSystem/Spacing.swift`**

```swift
import SwiftUI

// MARK: - Spacing Scale

enum Spacing {
    /// 4pt - Extra extra small spacing
    static let xxs: CGFloat = 4
    
    /// 8pt - Extra small spacing
    static let xs: CGFloat = 8
    
    /// 12pt - Small spacing
    static let sm: CGFloat = 12
    
    /// 16pt - Medium spacing (default)
    static let md: CGFloat = 16
    
    /// 20pt - Large spacing
    static let lg: CGFloat = 20
    
    /// 24pt - Extra large spacing
    static let xl: CGFloat = 24
    
    /// 32pt - Extra extra large spacing
    static let xxl: CGFloat = 32
    
    /// 48pt - Extra extra extra large spacing
    static let xxxl: CGFloat = 48
    
    // MARK: - Semantic Spacing
    
    /// Standard screen horizontal padding - 16pt
    static let screenHorizontal: CGFloat = 16
    
    /// Screen top padding - 8pt
    static let screenTop: CGFloat = 8
    
    /// Screen bottom padding - 24pt (above tab bar)
    static let screenBottom: CGFloat = 24
    
    /// Standard card padding - 16pt
    static let cardPadding: CGFloat = 16
    
    /// Minimum tap target - 44pt (Apple HIG)
    static let minTapTarget: CGFloat = 44
}

// MARK: - Corner Radius

enum CornerRadius {
    /// 4pt - Small radius
    static let sm: CGFloat = 4
    
    /// 8pt - Medium radius
    static let md: CGFloat = 8
    
    /// 12pt - Large radius
    static let lg: CGFloat = 12
    
    /// 16pt - Extra large radius
    static let xl: CGFloat = 16
    
    /// 24pt - Extra extra large radius
    static let xxl: CGFloat = 24
    
    /// 50% - Circular (use .infinity for pill shape)
    static let circular: CGFloat = .infinity
}
```

**Deliverables**:
- ✅ Complete design system ported (completed in Step 1.1)
- ✅ All colors, typography, spacing defined
- ✅ Consistent with mockup
- ✅ SwiftUI-native, type-safe
- ✅ Files: Colors.swift, Typography.swift, Spacing.swift

---

### Step 1.4: Shared Components (Day 2-3) ✅ COMPLETE

**Port Reusable Components from Mockup**

✅ **Completed in Step 1.1** - Components were created early alongside design system.

**Create: `Shared/Components/Buttons.swift`**

```swift
import SwiftUI

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(.bodyLarge.weight(.semibold))
            }
            .foregroundColor(.textInverted)
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.minTapTarget)
            .background(isDisabled ? Color.gray400 : Color.accentPrimary)
            .cornerRadius(CornerRadius.md)
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.accentPrimary)
                }
                Text(title)
                    .font(.bodyLarge.weight(.semibold))
            }
            .foregroundColor(.accentPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.minTapTarget)
            .background(Color.backgroundTertiary)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(Color.accentPrimary, lineWidth: 2)
            )
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Text Button

struct TextButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyMedium.weight(.medium))
                .foregroundColor(.accentPrimary)
        }
    }
}

// MARK: - Icon Button

struct IconButton: View {
    let icon: String
    let action: () -> Void
    var size: CGFloat = 24
    var color: Color = .textPrimary
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundColor(color)
                .frame(width: Spacing.minTapTarget, height: Spacing.minTapTarget)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.lg) {
        PrimaryButton(title: "Primary Button") {}
        PrimaryButton(title: "Loading", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
        
        SecondaryButton(title: "Secondary Button") {}
        
        TextButton(title: "Text Button") {}
        
        IconButton(icon: "heart.fill", action: {})
    }
    .padding()
}
```

**Create: `Shared/Components/Cards.swift`**

```swift
import SwiftUI

// MARK: - Basic Card

struct Card<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Spacing.cardPadding)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.lg)
    }
}

// MARK: - Weather Card (from mockup)

struct WeatherCard: View {
    let weather: WeatherSnapshot
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(isToday ? "Today" : weather.date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.labelSmall)
                .foregroundColor(.textSecondary)
            
            Image(systemName: weather.conditionIcon)
                .font(.title3)
                .foregroundColor(.textPrimary)
            
            Text("\(Int(weather.tempHigh))°")
                .font(.bodyLarge.weight(.semibold))
                .foregroundColor(.textPrimary)
            
            Text("\(Int(weather.tempLow))°")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
        .frame(width: 70)
        .padding(.vertical, Spacing.sm)
        .background(isToday ? Color.accentPrimary.opacity(0.1) : Color.backgroundTertiary)
        .cornerRadius(CornerRadius.md)
    }
}

// MARK: - Preview

#Preview {
    HStack {
        WeatherCard(
            weather: WeatherSnapshot(
                date: Date(),
                tempHigh: 72,
                tempLow: 58,
                condition: "Partly Cloudy",
                feelsLike: 68,
                humidity: 55
            ),
            isToday: true
        )
        
        WeatherCard(
            weather: WeatherSnapshot(
                date: Date().addingTimeInterval(86400),
                tempHigh: 68,
                tempLow: 55,
                condition: "Cloudy",
                feelsLike: 65,
                humidity: 60
            ),
            isToday: false
        )
    }
    .padding()
}
```

**Create: `Shared/Components/EmptyStates.swift`**

```swift
import SwiftUI

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray400)
            
            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView(
        icon: "tshirt",
        title: "No Items Yet",
        message: "Start building your digital wardrobe by adding your first clothing item.",
        actionTitle: "Add First Item",
        action: {}
    )
}
```

**Deliverables**:
- ✅ Button components (Primary, Secondary, Text, Icon) - completed in Step 1.1
- ✅ Card components (Card, ElevatedCard, ItemCard, WeatherCard) - completed in Step 1.1
- ✅ Empty state components (EmptyStateView, LoadingStateView, ErrorStateView) - completed in Step 1.1
- ✅ All match mockup styling
- ✅ Files: Buttons.swift, Cards.swift, EmptyStates.swift

---

### Step 1.5: Data Models (Day 3) ✅ COMPLETE

**Port Core Models to SwiftData**

✅ **Deployment Complete** - All SwiftData models created matching Supabase schema.

**Create: `Shared/Models/WardrobeItem.swift`**

```swift
import Foundation
import SwiftData

// MARK: - Enums

enum ItemCategory: String, Codable, CaseIterable {
    case tops, bottoms, dresses, outerwear, accessories, jewelry, footwear
    
    var displayName: String { rawValue.capitalized }
    
    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "figure.walk"
        case .dresses: return "figure.dress.line.vertical.figure"
        case .outerwear: return "coat"
        case .accessories: return "bag"
        case .jewelry: return "sparkles"
        case .footwear: return "shoe"
        }
    }
}

enum ItemSubCategory: String, Codable {
    // Tops
    case graphicTees, dressedUpTops, sweaters, bodysuits, activewear, buttonDowns, tanks
    // Bottoms
    case jeans, shorts, skirts, leggings, dressPants
    // Dresses
    case dayDresses, partyDresses, rompers, maxiDresses, casualDresses
    // Outerwear
    case jackets, coats, blazers, rainJackets
    // Accessories
    case hats, bags, belts, sunglasses, scarves
    // Jewelry
    case necklaces, bracelets, rings, earrings, watches
    // Footwear
    case heels, flats, sneakers, boots, socks
    
    var displayName: String {
        rawValue.camelCaseToWords()
    }
}

enum FormalityLevel: Int, Codable, CaseIterable {
    case casual = 1
    case smartCasual = 2
    case businessCasual = 3
    case business = 4
    case formal = 5
    
    var displayName: String {
        switch self {
        case .casual: return "Casual"
        case .smartCasual: return "Smart Casual"
        case .businessCasual: return "Business Casual"
        case .business: return "Business"
        case .formal: return "Formal"
        }
    }
}

enum Season: String, Codable, CaseIterable {
    case spring, summer, fall, winter
    
    var displayName: String { rawValue.capitalized }
    
    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .fall: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

// MARK: - SwiftData Model

@Model
final class WardrobeItem {
    // Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // Basic Info
    var name: String?
    var category: String // Stored as String for SwiftData compatibility
    var subCategory: String
    var brand: String?
    var purchaseDate: Date?
    var purchasePrice: Decimal?
    
    // Images
    var imageURL: String?
    var thumbnailURL: String?
    
    // AI Attributes
    var aiGenerated: Bool
    var colors: [String]
    var pattern: String?
    var formality: Int
    var styleTags: [String]
    var seasons: [String]
    var materialType: String?
    var aiConfidence: Double
    
    // User Metadata
    var isFavorite: Bool
    var notes: String?
    var isArchived: Bool
    
    // Usage Statistics
    var timesWorn: Int
    var lastWornDate: Date?
    
    // Sync
    var userId: UUID
    var needsSync: Bool
    
    init(
        id: UUID = UUID(),
        name: String? = nil,
        category: ItemCategory,
        subCategory: ItemSubCategory,
        brand: String? = nil,
        imageURL: String? = nil,
        aiGenerated: Bool = false,
        colors: [String] = [],
        pattern: String? = nil,
        formality: FormalityLevel = .casual,
        styleTags: [String] = [],
        seasons: [Season] = [],
        materialType: String? = nil,
        aiConfidence: Double = 0.0,
        isFavorite: Bool = false,
        notes: String? = nil,
        isArchived: Bool = false,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        userId: UUID
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.name = name
        self.category = category.rawValue
        self.subCategory = subCategory.rawValue
        self.brand = brand
        self.imageURL = imageURL
        self.aiGenerated = aiGenerated
        self.colors = colors
        self.pattern = pattern
        self.formality = formality.rawValue
        self.styleTags = styleTags
        self.seasons = seasons.map { $0.rawValue }
        self.materialType = materialType
        self.aiConfidence = aiConfidence
        self.isFavorite = isFavorite
        self.notes = notes
        self.isArchived = isArchived
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.userId = userId
        self.needsSync = false
    }
    
    // Computed Properties
    var categoryEnum: ItemCategory {
        ItemCategory(rawValue: category) ?? .tops
    }
    
    var displayName: String {
        name ?? "\(colors.first?.capitalized ?? "") \(subCategory.camelCaseToWords())"
    }
}

// MARK: - Extensions

extension String {
    func camelCaseToWords() -> String {
        unicodeScalars.reduce("") { result, char in
            if CharacterSet.uppercaseLetters.contains(char) {
                return result + " " + String(char)
            }
            return result + String(char)
        }.trimmingCharacters(in: .whitespaces).capitalized
    }
}
```

**Similarly create models for:**
- `Shared/Models/Outfit.swift`
- `Shared/Models/PlannerEntry.swift`
- `Shared/Models/User.swift`
- `Shared/Models/UserPreferences.swift`
- `Shared/Models/Weather.swift` (for weather snapshots)

*(These follow similar patterns - I can provide full implementations when we reach each feature)*

**Files Created:**
- `Enums.swift` - 6 enums with casual, friendly language (ItemCategory, ItemSubCategory, FormalityLevel, Season, SubscriptionTier, SubscriptionStatus)
- `User.swift` - User profile model (8 properties matching users table)
- `UserPreferences.swift` - User preferences and settings (14 properties matching user_preferences table)
- `WardrobeItem.swift` - Clothing items with AI attributes (26 properties matching wardrobe_items table)
- `Outfit.swift` - Outfit combinations (18 properties matching outfits table)
- `PlannerEntry.swift` - Calendar planning entries (13 properties matching planner_entries table)

**Deliverables**:
- ✅ All SwiftData models created (6 files, 691 lines of code)
- ✅ Models match Supabase schema exactly
- ✅ All models use @Model macro with @Attribute(.unique) for IDs
- ✅ Enums stored as raw values with computed properties for conversion
- ✅ Arrays properly mapped ([String], [UUID])
- ✅ Comprehensive initializers with sensible defaults
- ✅ Display helpers for UI integration
- ✅ Target audience language: casual and conversational (e.g., "Dressed up but chill")
- ✅ All models include needsSync flag for local-first sync
- ✅ Project builds successfully
- ✅ SwiftLint passes with 0 violations
- ✅ Committed to git (commit: 5557b1c)

---

### Step 1.6: TCA Architecture Foundation (Day 3-4) ✅ PARTIALLY COMPLETE

**Create Root App Feature**

✅ **Basic structure completed in Step 1.1** - Root app architecture established.
⏭️ **Feature-specific reducers** - Will be created as we build each feature.

**Create: `App/AppFeature.swift`**

```swift
import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    // MARK: - State
    
    @ObservableState
    struct State: Equatable {
        // Authentication
        var isAuthenticated = false
        var currentUser: User?
        
        // Navigation
        var selectedTab: Tab = .home
        
        // Feature States
        var home: HomeFeature.State = .init()
        var wardrobe: WardrobeFeature.State = .init()
        var outfits: OutfitsFeature.State = .init()
        var planner: PlannerFeature.State = .init()
        var settings: SettingsFeature.State = .init()
        
        // Authentication flow
        @Presents var authentication: AuthenticationFeature.State?
        
        // Loading state
        var isLoading = false
    }
    
    // MARK: - Actions
    
    enum Action: Equatable {
        // Lifecycle
        case onAppear
        case checkAuthStatus
        
        // Authentication
        case authStatusChecked(User?)
        case authentication(PresentationAction<AuthenticationFeature.Action>)
        case signOut
        
        // Navigation
        case tabSelected(Tab)
        
        // Feature Actions
        case home(HomeFeature.Action)
        case wardrobe(WardrobeFeature.Action)
        case outfits(OutfitsFeature.Action)
        case planner(PlannerFeature.Action)
        case settings(SettingsFeature.Action)
    }
    
    // MARK: - Tab Enum
    
    enum Tab: String, CaseIterable {
        case home, wardrobe, outfits, planner, settings
        
        var title: String { rawValue.capitalized }
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .wardrobe: return "tshirt"
            case .outfits: return "hanger"
            case .planner: return "calendar"
            case .settings: return "gear"
            }
        }
        
        var iconFilled: String {
            switch self {
            case .home: return "house.fill"
            case .wardrobe: return "tshirt.fill"
            case .outfits: return "hanger"
            case .planner: return "calendar"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.authService) var authService
    @Dependency(\.databaseService) var databaseService
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.checkAuthStatus)
                
            case .checkAuthStatus:
                state.isLoading = true
                return .run { send in
                    let user = try await authService.getCurrentUser()
                    await send(.authStatusChecked(user))
                } catch: { error, send in
                    await send(.authStatusChecked(nil))
                }
                
            case let .authStatusChecked(user):
                state.isLoading = false
                state.currentUser = user
                state.isAuthenticated = user != nil
                
                if user == nil {
                    state.authentication = AuthenticationFeature.State()
                }
                return .none
                
            case .signOut:
                return .run { send in
                    try await authService.signOut()
                    await send(.checkAuthStatus)
                }
                
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
                
            case .authentication(.presented(.delegate(.authenticationSuccessful))):
                state.authentication = nil
                return .send(.checkAuthStatus)
                
            case .authentication:
                return .none
                
            case .home, .wardrobe, .outfits, .planner, .settings:
                return .none
            }
        }
        .ifLet(\.$authentication, action: \.authentication) {
            AuthenticationFeature()
        }
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Scope(state: \.wardrobe, action: \.wardrobe) {
            WardrobeFeature()
        }
        
        Scope(state: \.outfits, action: \.outfits) {
            OutfitsFeature()
        }
        
        Scope(state: \.planner, action: \.planner) {
            PlannerFeature()
        }
        
        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }
    }
}
```

**Create: `App/AppView.swift`**

```swift
import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        Group {
            if store.isLoading {
                LoadingView()
            } else if store.isAuthenticated {
                mainTabView
            }
        }
        .sheet(item: $store.scope(state: \.authentication, action: \.authentication)) { authStore in
            AuthenticationView(store: authStore)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private var mainTabView: some View {
        TabView(selection: $store.selectedTab) {
            HomeView(
                store: store.scope(state: \.home, action: \.home)
            )
            .tabItem {
                Label(
                    AppFeature.Tab.home.title,
                    systemImage: store.selectedTab == .home
                        ? AppFeature.Tab.home.iconFilled
                        : AppFeature.Tab.home.icon
                )
            }
            .tag(AppFeature.Tab.home)
            
            WardrobeView(
                store: store.scope(state: \.wardrobe, action: \.wardrobe)
            )
            .tabItem {
                Label(
                    AppFeature.Tab.wardrobe.title,
                    systemImage: store.selectedTab == .wardrobe
                        ? AppFeature.Tab.wardrobe.iconFilled
                        : AppFeature.Tab.wardrobe.icon
                )
            }
            .tag(AppFeature.Tab.wardrobe)
            
            OutfitsView(
                store: store.scope(state: \.outfits, action: \.outfits)
            )
            .tabItem {
                Label(
                    AppFeature.Tab.outfits.title,
                    systemImage: AppFeature.Tab.outfits.icon
                )
            }
            .tag(AppFeature.Tab.outfits)
            
            PlannerView(
                store: store.scope(state: \.planner, action: \.planner)
            )
            .tabItem {
                Label(
                    AppFeature.Tab.planner.title,
                    systemImage: AppFeature.Tab.planner.icon
                )
            }
            .tag(AppFeature.Tab.planner)
            
            SettingsView(
                store: store.scope(state: \.settings, action: \.settings)
            )
            .tabItem {
                Label(
                    AppFeature.Tab.settings.title,
                    systemImage: store.selectedTab == .settings
                        ? AppFeature.Tab.settings.iconFilled
                        : AppFeature.Tab.settings.icon
                )
            }
            .tag(AppFeature.Tab.settings)
        }
        .tint(.accentPrimary)
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: Spacing.lg) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.accentPrimary)
                
                Text("Loading FitChekk...")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}
```

**Create: `App/FitChekkApp.swift`**

```swift
import ComposableArchitecture
import SwiftUI
import SwiftData

@main
struct FitChekkApp: App {
    // SwiftData container
    let modelContainer: ModelContainer
    
    // TCA store
    let store: StoreOf<AppFeature>
    
    init() {
        // Setup SwiftData
        do {
            let schema = Schema([
                WardrobeItem.self,
                Outfit.self,
                PlannerEntry.self,
                // Add other models
            ])
            
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        // Setup TCA store
        store = Store(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            // We'll configure dependencies here
            // For now, using default/mock implementations
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
                .modelContainer(modelContainer)
        }
    }
}
```

**Deliverables**:
- ✅ Complete TCA root architecture (AppFeature.swift) - completed in Step 1.1
- ✅ App navigation structured (AppView.swift with TabView) - completed in Step 1.1
- ✅ Authentication flow prepared (placeholder states) - completed in Step 1.1
- ✅ SwiftData container initialized (FitChekkApp.swift) - completed in Step 1.1
- ✅ Ready for feature implementation
- ⏭️ Individual feature reducers (HomeFeature, WardrobeFeature, etc.) - to be created per feature

---

### Step 1.7: Service Layer Interfaces (Day 4) ✅ COMPLETE

**Define Service Protocols (will implement later)**

✅ **Deployment Complete** - All service layer interfaces created with mock implementations.

**Create: `Services/Authentication/AuthService.swift`**

```swift
import Foundation
import Dependencies

// MARK: - Protocol

protocol AuthService {
    func getCurrentUser() async throws -> User?
    func signInWithEmail(email: String, password: String) async throws -> User
    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User
    func signInWithApple() async throws -> User
    func signInWithGoogle() async throws -> User
    func signOut() async throws
    func resetPassword(email: String) async throws
}

// MARK: - Dependency Key

private enum AuthServiceKey: DependencyKey {
    static let liveValue: AuthService = LiveAuthService()
    static let testValue: AuthService = MockAuthService()
}

extension DependencyValues {
    var authService: AuthService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveAuthService: AuthService {
    func getCurrentUser() async throws -> User? {
        // TODO: Implement with Supabase
        nil
    }
    
    func signInWithEmail(email: String, password: String) async throws -> User {
        // TODO: Implement
        throw NSError(domain: "NotImplemented", code: -1)
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User {
        // TODO: Implement
        throw NSError(domain: "NotImplemented", code: -1)
    }
    
    func signInWithApple() async throws -> User {
        // TODO: Implement
        throw NSError(domain: "NotImplemented", code: -1)
    }
    
    func signInWithGoogle() async throws -> User {
        // TODO: Implement
        throw NSError(domain: "NotImplemented", code: -1)
    }
    
    func signOut() async throws {
        // TODO: Implement
    }
    
    func resetPassword(email: String) async throws {
        // TODO: Implement
    }
}

// MARK: - Mock Implementation

final class MockAuthService: AuthService {
    var mockUser: User?
    
    func getCurrentUser() async throws -> User? {
        mockUser
    }
    
    func signInWithEmail(email: String, password: String) async throws -> User {
        let user = User(id: UUID(), email: email, displayName: "Test User")
        mockUser = user
        return user
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User {
        let user = User(id: UUID(), email: email, displayName: displayName)
        mockUser = user
        return user
    }
    
    func signInWithApple() async throws -> User {
        let user = User(id: UUID(), email: "apple@test.com", displayName: "Apple User")
        mockUser = user
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        let user = User(id: UUID(), email: "google@test.com", displayName: "Google User")
        mockUser = user
        return user
    }
    
    func signOut() async throws {
        mockUser = nil
    }
    
    func resetPassword(email: String) async throws {
        // Mock implementation
    }
}
```

**Similarly create interfaces for:**
- `Services/Data/DatabaseService.swift` (CRUD operations)
- `Services/Data/StorageService.swift` (image upload/download)
- `Services/Data/SyncService.swift` (offline sync)
- `Services/Weather/WeatherService.swift` (WeatherKit wrapper)
- `Services/AI/CategorizationService.swift` (Gemini categorization)
- `Services/AI/OutfitService.swift` (Claude suggestions)

**Files Created:**
- `AuthService.swift` - Authentication operations with Supabase (7 methods: getCurrentUser, signIn/Up with Email/Apple/Google, signOut, resetPassword)
- `DatabaseService.swift` - Generic CRUD operations for Supabase tables (5 generic methods: fetch, create, update, delete, query)
- `StorageService.swift` - Image upload/download to Supabase Storage (4 methods: upload, download, delete, getPublicURL)
- `SyncService.swift` - Offline-first synchronization layer (7 methods: syncAll, syncPending, markForSync, conflict resolution, status tracking)
- `WeatherService.swift` - WeatherKit integration (3 methods: getCurrentWeather, getForecast, requestLocationPermission)
- `CategorizationService.swift` - Gemini AI for item categorization (1 method: categorizeItem returning structured attributes)
- `OutfitService.swift` - Claude AI for outfit suggestions (2 methods: generateSuggestions, explainOutfit)

**Deliverables**:
- ✅ All 7 service protocols defined (AuthService, DatabaseService, StorageService, SyncService, WeatherService, CategorizationService, OutfitService)
- ✅ Mock implementations for testing created for all services
- ✅ Live placeholder implementations created (ready for integration)
- ✅ TCA dependency integration complete with @Dependency macro
- ✅ Proper error types defined for each service
- ✅ All services include @unchecked Sendable for Swift 6 concurrency
- ✅ Can develop features with mocks, implement services later
- ✅ Project builds successfully with no errors
- ✅ SwiftLint passes with 0 violations
- ✅ Committed to git (commit: dbae4d0)

---

### Step 1.8: Testing Infrastructure & CI/CD (Day 4-5) ⏭️ TODO

**Setup Testing Framework**

⚠️ **Not yet started** - Will set up testing infrastructure after service layer is defined.

**Create: `FitChekkTests/AppFeatureTests.swift`**

```swift
import ComposableArchitecture
import XCTest
@testable import FitChekk

@MainActor
final class AppFeatureTests: XCTestCase {
    func testAuthCheckOnAppear() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
        }
        
        await store.send(.onAppear) {
            // State changes if any
        }
        
        await store.receive(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        await store.receive(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.isAuthenticated = false
            $0.authentication = AuthenticationFeature.State()
        }
    }
    
    func testTabNavigation() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tabSelected(.wardrobe)) {
            $0.selectedTab = .wardrobe
        }
    }
}
```

**Create CI/CD Pipeline: `.github/workflows/ci.yml`**

```yaml
name: CI

on:
  push:
    branches: [ production-foundation, main ]
  pull_request:
    branches: [ production-foundation, main ]

jobs:
  build-and-test:
    runs-on: macos-14
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode_15.2.app
    
    - name: Build
      run: |
        xcodebuild build \
          -scheme FitChekk \
          -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=17.2' \
          -enableCodeCoverage YES \
          | xcpretty
    
    - name: Run Tests
      run: |
        xcodebuild test \
          -scheme FitChekk \
          -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=17.2' \
          -enableCodeCoverage YES \
          | xcpretty
    
    - name: SwiftLint
      run: |
        if which swiftlint >/dev/null; then
          swiftlint lint --reporter github-actions-logging
        else
          echo "SwiftLint not installed, skipping"
        fi

  code-coverage:
    runs-on: macos-14
    needs: build-and-test
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Generate Coverage Report
      run: |
        xcodebuild test \
          -scheme FitChekk \
          -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=17.2' \
          -enableCodeCoverage YES \
          -derivedDataPath ./DerivedData
    
    - name: Check Coverage Threshold
      run: |
        # Extract coverage percentage
        # Fail if below 85%
        echo "Coverage check would go here"
```

**Deliverables**:
- ⏭️ Test infrastructure to be set up
- ⏭️ First tests to be written
- ⏭️ CI/CD pipeline to be configured
- ⏭️ Code coverage tracking to be enabled

---

## 🎉 Phase 1 Status Summary

**Completed (Steps 1.1, 1.2, 1.5, 1.7)**:
- ✅ Fresh project with production structure (Xcode 16.4, Swift 6.0, iOS 17+)
- ✅ All dependencies installed (TCA 1.23.1, Supabase Swift 2.37.0)
- ✅ Configuration files with API keys (linked to build schemes)
- ✅ Design system ported from mockup (Colors, Typography, Spacing)
- ✅ Shared components created (Buttons, Cards, EmptyStates)
- ✅ TCA root architecture (AppFeature, AppView, FitChekkApp)
- ✅ SwiftLint configured and passing
- ✅ Database schema deployed to Supabase (5 tables, RLS, storage, 100% verified)
- ✅ SwiftData models created (6 files: Enums, User, UserPreferences, WardrobeItem, Outfit, PlannerEntry)
- ✅ All models match database schema exactly with local-first sync support
- ✅ Service layer interfaces created (7 services with mock implementations)
- ✅ All models conform to @unchecked Sendable for Swift 6 concurrency
- ✅ Project builds successfully with no errors
- ✅ Latest commit: dbae4d0 on production-foundation branch

**Remaining Week 1 Tasks**:
- ⏭️ Step 1.8: Testing infrastructure & CI/CD pipeline

**Next Immediate Action**: Step 1.8 - Testing Infrastructure & CI/CD (Day 4-5)

**Ready for Phase 2**: ⚠️ Nearly ready (testing infrastructure recommended but not blocking for feature development)

---

## 🔐 Phase 2: Authentication (Week 2)

**Goal**: Implement complete authentication flow with all three providers

### Step 2.1: Email Authentication (Day 1-2)

**Implement Supabase Email Auth**

1. **Update `LiveAuthService`** with Supabase integration
2. **Create `AuthenticationFeature`** (TCA reducer)
3. **Build `AuthenticationView`** (UI)
4. **Add email validation**
5. **Implement password reset**
6. **Write comprehensive tests**

### Step 2.2: Sign in with Apple (Day 3)

1. **Configure Apple Developer** portal
2. **Add AuthenticationServices** framework
3. **Implement Apple Sign In** in `LiveAuthService`
4. **Handle authorization callbacks**
5. **Link to Supabase user**

### Step 2.3: Google Sign-In (Day 4)

1. **Set up Google Cloud Console**
2. **Get OAuth credentials**
3. **Integrate Google Sign-In SDK**
4. **Implement in `LiveAuthService`**
5. **Link to Supabase user**

### Step 2.4: Onboarding Flow (Day 5)

1. **Create `OnboardingFeature`**
2. **Build style quiz screens**
3. **Request permissions** (camera, photos, location)
4. **Save user preferences**
5. **Mark onboarding complete**

**Week 2 Deliverables**:
- ✅ All three auth methods working
- ✅ User profiles created automatically
- ✅ Onboarding flow complete
- ✅ 90%+ test coverage on auth
- ✅ Security best practices followed

---

## 👔 Phase 3: Wardrobe Feature (Week 3-4)

**Goal**: Complete wardrobe management (add, view, edit, delete items)

### Step 3.1: Basic Wardrobe View (Day 1)

1. **Implement `WardrobeFeature`** (TCA)
2. **Build `WardrobeView`** with grid layout
3. **Fetch items from SwiftData**
4. **Display empty state**
5. **Add search and filters**

### Step 3.2: Add Item Flow (Day 2-3)

1. **Camera/Photos integration**
2. **Image optimization** and thumbnail generation
3. **Upload to Supabase Storage**
4. **Manual categorization UI**
5. **Save to SwiftData + Supabase**

### Step 3.3: Item Detail & Edit (Day 4)

1. **Item detail view**
   - Display all item metadata
   - **Add "Date Added" field** (format: "Added 2 weeks ago")
   - Show image, category, brand, colors
   - Display wear statistics
2. **Edit functionality**
3. **Delete with confirmation**
4. **Favorite toggle**
5. **Usage statistics display**
   - Times worn
   - Last worn date

### Step 3.4: Background Removal (Day 5)

1. **Vision framework integration** (iOS 17)
2. **Optional iOS 18 enhancement** (Apple Intelligence)
3. **Fallback for older versions**
4. **Progress indication**

**Week 3-4 Deliverables**:
- ✅ Full wardrobe CRUD working
- ✅ Images uploaded to Supabase
- ✅ Background removal functional
- ✅ Offline mode supported
- ✅ 85%+ test coverage

---

## 🤖 Phase 4: AI Integration (Week 5)

**Goal**: Gemini categorization working

### Step 4.1: Portkey Integration (Day 1)

1. **Configure Portkey client**
2. **Implement `AIGateway`**
3. **Add cost tracking**
4. **Set rate limits**
5. **Error handling and fallbacks**

### Step 4.2: Categorization Service (Day 2-3)

1. **Create Gemini prompt template**
2. **Implement `CategorizationService`**
3. **Parse JSON responses**
4. **Handle low confidence**
5. **User confirmation UI**

### Step 4.3: Integration & Testing (Day 4-5)

1. **Wire categorization to Add Item flow**
2. **Test with real images**
3. **Measure accuracy** (target: 90%+)
4. **Optimize prompts**
5. **Add to paywall** (Premium only)

**Week 5 Deliverables**:
- ✅ AI categorization working
- ✅ 90%+ accuracy
- ✅ < 2s latency
- ✅ Cost optimized
- ✅ Premium-only feature gate

---

## 👗 Phase 5: Outfits Feature (Week 6-7)

**Goal**: Outfit creation and AI suggestions

### Step 5.1: Outfit Creation (Day 1-3)

1. **`OutfitCreationFeature`** (TCA)
2. **Visual outfit canvas**
3. **Add items from wardrobe**
4. **Drag to reorder**
5. **Save outfit**

### Step 5.2: Outfit List & Detail (Day 4)

1. **Outfit grid view**
2. **Filters** (occasion, season)
3. **Outfit detail view**
4. **Edit/delete outfits**

### Step 5.3: AI Outfit Suggestions (Day 5-7)

1. **Claude Sonnet 4 integration**
2. **`OutfitService`** implementation
3. **Build context** (wardrobe + weather + preferences)
4. **Parse suggestions**
5. **Display with reasoning (click-to-reveal)**
   - Show outfit suggestion prominently
   - Add "Why this works?" button/link
   - Reasoning hidden by default (saves API costs)
   - Clicking reveals AI explanation
   - Clean UI for users who don't need explanation
6. **Accept/dismiss flow**

**Week 6-7 Deliverables**:
- ✅ Outfit creation working
- ✅ AI suggestions functional
- ✅ Reasoning explanations shown
- ✅ 40%+ acceptance rate
- ✅ < 3s latency with caching

---

## 📅 Phase 6: Calendar Planner (Week 8)

**Goal**: Calendar planning and wear tracking

### Step 6.1: Calendar View (Day 1-3)

1. **Monthly calendar UI**
2. **Day indicators** (planned/worn)
3. **Weather per day**
4. **Swipe between months**

### Step 6.2: Outfit Scheduling (Day 4-5)

1. **Assign outfit to date**
2. **Mark as worn**
3. **Update statistics**
4. **Multi-device sync**

**Week 8 Deliverables**:
- ✅ Calendar view working
- ✅ Outfit scheduling functional
- ✅ Wear tracking accurate
- ✅ Weather integration complete

---

## 🌤️ Phase 7: Weather Integration (Week 9)

**Goal**: Real weather data powering suggestions

### Step 7.1: WeatherKit Setup (Day 1-2)

1. **Enable WeatherKit entitlement**
2. **Implement `WeatherService`**
3. **Request location permission**
4. **Fetch 5-day forecast**
5. **Cache weather data**

### Step 7.2: Integration (Day 3-5)

1. **Update Home screen** with real weather
2. **Weather-aware outfit suggestions**
3. **Planner weather display**
4. **Handle location errors**

**Week 9 Deliverables**:
- ✅ Real weather data throughout app
- ✅ Location permission handled gracefully
- ✅ Weather influences AI suggestions
- ✅ Offline caching working

---

## 📊 Phase 8: Analytics & Insights (Week 9 - Days 6-10)

**Goal**: Wardrobe and outfit analytics providing valuable user insights

### Step 8.1: Wardrobe Analytics (Day 6-7)

**Create Analytics Service and Views**

1. **Analytics Data Models**
   - Wear frequency calculations
   - Category distribution
   - Color palette extraction
   - Season utilization

2. **Wardrobe Analytics View**
   - "Your Wardrobe at a Glance" dashboard
   - Visual charts (wear frequency)
   - "Most Worn Items" list
   - "Least Worn Items" (to encourage wearing or donating)
   - Color palette visualization
   - Category breakdown (pie chart)

3. **Individual Item Insights**
   - Wear frequency compared to wardrobe average
   - Last worn date
   - Suggested pairings based on past outfits

### Step 8.2: Outfit Analytics (Day 8-9)

**Create Outfit Intelligence Views**

1. **Style Insights**
   - Your style profile (based on outfit history)
   - Favorite color combinations
   - Most common outfit formulas
   - "Your vibe is..." summary with AI analysis

2. **Occasion Analytics**
   - Breakdown by occasion (work, casual, date, etc.)
   - Most successful occasions
   - Outfit rotation patterns

3. **Seasonal Trends**
   - What you wear most each season
   - Seasonal color preferences
   - Season-specific style patterns

4. **Recommendations**
   - "You might be missing..." suggestions
   - Underutilized items reminders
   - "Complete the look" suggestions for existing items

### Step 8.3: Settings Analytics View (Day 10)

**Add Analytics Section to Settings**

1. **Stats Overview**
   - Total wardrobe items
   - Total outfits created
   - Days with planned outfits
   - Favorite style tags
   - (Remove "Total Wears" card per requirements)

2. **Export Data** (Premium feature)
   - Share year-in-review
   - Style report generation

**Week 9 (Extended) Deliverables**:
- ✅ Comprehensive wardrobe analytics
- ✅ Outfit insights and style analysis
- ✅ Visual data representation (charts/graphs)
- ✅ Actionable recommendations
- ✅ Analytics integrated throughout app

---

## 💰 Phase 9: Monetization (Week 10)

**Goal**: Subscriptions and paywall

### Step 9.1: StoreKit 2 (Day 1-3)

1. **Create subscription products** in App Store Connect
2. **Implement `SubscriptionService`**
3. **Purchase flow**
4. **Receipt validation**
5. **Restore purchases**

### Step 9.2: Paywall & Gating (Day 4-5)

1. **Design paywall view**
2. **Feature gates** throughout app
3. **Free trial** (7 days)
4. **Upgrade prompts**
5. **Track conversions**

**Week 10 Deliverables**:
- ✅ Subscription system working
- ✅ Paywall converts well
- ✅ Feature gating implemented
- ✅ Free trial functional

---

## 🎨 Phase 10: Polish & Testing (Week 11)

**Goal**: Production-ready quality

### Step 10.1: Animations & Transitions (Day 1-2)

1. **Smooth tab transitions**
2. **Loading states**
3. **Success animations**
4. **Gesture feedback**

### Step 10.2: Error Handling (Day 3)

1. **Comprehensive error messages**
2. **Retry mechanisms**
3. **Offline indicators**
4. **Graceful degradation**

### Step 10.3: Accessibility (Day 4)

1. **VoiceOver labels**
2. **Dynamic Type support**
3. **High Contrast mode**
4. **Reduce Motion**

### Step 10.4: Performance (Day 5)

1. **Profile with Instruments**
2. **Optimize bottlenecks**
3. **Image loading optimization**
4. **60fps scrolling**

### Step 10.5: Language & Tone Update (Throughout Week 11)

**Convert formal fashion language to casual, conversational tone for women 18-50**

1. **Category & Formality Updates**
   - Replace "Smart Casual" → "Dressed up but chill"
   - Replace "Business Casual" → "Office appropriate" 
   - Replace "Formal" → "Fancy/dressed up"
   - Replace "Formality Level" → "How fancy is it?"
   - Update all enums and display strings

2. **UI Copy Revision**
   - Empty states: Make playful and encouraging
   - Button labels: Use conversational language
   - Onboarding: Speak like a friend, not a manual
   - Error messages: Friendly and helpful, not technical

3. **AI Response Tuning**
   - Update prompts to generate casual language
   - Outfit reasoning should sound like advice from a friend
   - Remove overly formal fashion terminology

4. **Settings Cleanup**
   - Remove "Total Wears" card (gets too big, not actionable)
   - Keep individual item wear counts
   - Ensure all settings language is friendly

**Week 11 Deliverables**:
- ✅ Smooth, polished UI
- ✅ Robust error handling
- ✅ Full accessibility support
- ✅ Excellent performance
- ✅ Casual tone throughout
- ✅ All formal terminology replaced

---

## 🚀 Phase 11: Launch Preparation (Week 12)

**Goal**: App Store ready

### Step 11.1: Testing (Day 1-3)

1. **Comprehensive manual testing**
2. **Beta testing** (TestFlight)
3. **Bug fixes**
4. **Edge case handling**

### Step 11.2: App Store Listing (Day 4-5)

1. **Screenshots** (all devices)
2. **App preview video**
3. **Description and metadata**
4. **Privacy policy**
5. **Terms of service**
6. **Submit for review**

**Week 12 Deliverables**:
- ✅ App submitted to App Store
- ✅ All metadata complete
- ✅ Beta tested with 50+ users
- ✅ Ready for launch! 🎉

---

## 📊 Progress Tracking

### Weekly Checkpoints

**End of each week, review**:
- Features completed
- Test coverage (target: 85%+)
- Code quality (SwiftLint passing)
- Performance metrics
- Blockers and risks

### Merge to Main Criteria

Before merging `production-foundation` → `main`:

- ✅ All Phase 1-8 features complete
- ✅ 85%+ test coverage
- ✅ CI/CD pipeline green
- ✅ No P0/P1 bugs
- ✅ Works on physical device
- ✅ Passes internal QA
- ✅ Security review complete
- ✅ Documentation updated

---

## 🔧 Tools & Resources

### Daily Tools
- **Xcode** 15.2+
- **Terminal** (zsh)
- **Cursor** (for AI-assisted coding)
- **Supabase Dashboard** (for database)
- **Portkey Dashboard** (for AI monitoring)

### Reference Docs
- Your specification guides (in `FitChekk-Complete-Specification-Guide/`)
- [TCA Documentation](https://pointfreeco.github.io/swift-composable-architecture/)
- [Supabase Swift Docs](https://supabase.com/docs/reference/swift)
- [WeatherKit Docs](https://developer.apple.com/documentation/weatherkit)

### AI Prompting Guide
- Always specify: "For FitChekk iOS app using TCA + SwiftUI + iOS 17+"
- Reference existing code patterns
- Request comprehensive tests
- Ask for DocC comments

---

## 🎯 Success Metrics

### Technical Quality
- **Test Coverage**: 85%+
- **Build Time**: < 2 minutes
- **App Size**: < 50 MB
- **Crash Rate**: < 0.1%
- **Performance**: 60fps scrolling

### Feature Completeness
- ✅ All MVP features working
- ✅ AI suggestions accurate (90%+)
- ✅ Offline mode functional
- ✅ Subscription system stable

### User Experience
- ✅ Smooth, polished UI
- ✅ Fast (<300ms interactions)
- ✅ Fully accessible
- ✅ Clear error messages

---

## 📝 Next Steps

**Immediate Action Items** (after reading this doc):

1. **Review this plan** - Any questions or concerns?
2. **Verify API keys** - Ensure all credentials are ready
3. **Confirm timeline** - 12 weeks realistic for your schedule?
4. **Start Week 1, Day 1** - Follow Step 1.1 above

**Let's build this! 🚀**

---

**Document Version**: 1.0  
**Last Updated**: November 10, 2025  
**Status**: Ready for Execution


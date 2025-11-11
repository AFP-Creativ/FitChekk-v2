# FitChekk Production Build - Ready for Step 1.5: Data Models

## 📍 Current Status: Week 1, Day 3 - Ready to Begin Step 1.5

You are continuing the production build of **FitChekk**, an AI-powered wardrobe management iOS app. **Steps 1.1 and 1.2 are complete.** You are now ready to begin **Step 1.5: Data Models**.

---

## ✅ What Has Been Completed

### Phase 0: Pre-Development Setup ✅
- ✅ Supabase project created (URL: https://paufghpcdsvspznnygxo.supabase.co)
- ✅ API keys secured in Configuration files
- ✅ Bundle ID: `com.afpcreativ.fitchekk`
- ✅ Portkey API key configured
- ✅ Git branch: `production-foundation`

### Phase 1, Step 1.1: Xcode Project Setup ✅
- ✅ Fresh Xcode project created with TCA 1.23.1 and Supabase Swift SDK 2.37.0
- ✅ Complete folder structure:
  - `FitChekk/App/` - Root TCA architecture (AppFeature, AppView, FitChekkApp)
  - `FitChekk/Features/` - Feature modules (Auth, Home, Wardrobe, Outfits, Planner, Settings)
  - `FitChekk/Services/` - Business logic layer (empty, ready for Step 1.7)
  - `FitChekk/Shared/` - Reusable components and utilities
- ✅ Design system fully ported:
  - `Shared/DesignSystem/Colors.swift` - Complete brand palette
  - `Shared/DesignSystem/Typography.swift` - Typography scale
  - `Shared/DesignSystem/Spacing.swift` - Spacing system
- ✅ Shared components created:
  - `Shared/Components/Buttons.swift`
  - `Shared/Components/Cards.swift`
  - `Shared/Components/EmptyStates.swift`
- ✅ Root TCA architecture operational
- ✅ SwiftLint configured
- ✅ Project builds successfully

### Phase 1, Step 1.2: Database Schema Deployment ✅
- ✅ **Complete database schema deployed to Supabase**
- ✅ 5 tables: users, user_preferences, wardrobe_items, outfits, planner_entries
- ✅ Row-Level Security (RLS) enabled on all tables with 6 active policies
- ✅ Storage bucket `wardrobe-images` created with 4 RLS policies
- ✅ 5 performance indexes operational
- ✅ 2 functions: `update_updated_at_column`, `handle_new_user`
- ✅ 6 triggers: 5 for timestamp automation + 1 for auth
- ✅ 100% test verification passed (all 10 tests successful)
- ✅ Complete documentation in `FitChekk-Complete-Specification-Guide/Database-Creation-Docs/`

---

## 🎯 Your Mission: Complete Step 1.5 - Data Models

### Overview
Create SwiftData models that match the deployed Supabase database schema. These models will serve as the local-first data layer with sync capabilities.

---

## 📋 Detailed Implementation Plan

### Part 1: Create Enums (30 minutes)

**File: `FitChekk/FitChekk/Shared/Models/Enums.swift`**

Create all enums that match database constraints:

```swift
import Foundation

// MARK: - Item Category
enum ItemCategory: String, Codable, CaseIterable {
    case tops
    case bottoms
    case dresses
    case outerwear
    case shoes
    case accessories
    
    var displayName: String {
        switch self {
        case .tops: return "Tops"
        case .bottoms: return "Bottoms"
        case .dresses: return "Dresses"
        case .outerwear: return "Outerwear"
        case .shoes: return "Shoes"
        case .accessories: return "Accessories"
        }
    }
    
    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "figure.walk"
        case .dresses: return "figure.dress.line.vertical.figure"
        case .outerwear: return "coat"
        case .shoes: return "shoe"
        case .accessories: return "bag"
        }
    }
}

// MARK: - Item Sub-Category
enum ItemSubCategory: String, Codable {
    // Tops
    case graphicTees, basicTees, dressedUpTops, sweaters, bodysuits
    case activewear, buttonDowns, tanks, croppedTops
    
    // Bottoms
    case jeans, shorts, skirts, leggings, dressPants, casualPants
    
    // Dresses
    case dayDresses, partyDresses, rompers, maxiDresses, casualDresses
    
    // Outerwear
    case jackets, coats, blazers, rainJackets, vests
    
    // Shoes
    case heels, flats, sneakers, boots, sandals
    
    // Accessories
    case hats, bags, belts, sunglasses, scarves, jewelry
    
    var displayName: String {
        rawValue.camelCaseToWords()
    }
    
    var category: ItemCategory {
        // Map each subcategory to its parent category
        switch self {
        case .graphicTees, .basicTees, .dressedUpTops, .sweaters, .bodysuits,
             .activewear, .buttonDowns, .tanks, .croppedTops:
            return .tops
        case .jeans, .shorts, .skirts, .leggings, .dressPants, .casualPants:
            return .bottoms
        case .dayDresses, .partyDresses, .rompers, .maxiDresses, .casualDresses:
            return .dresses
        case .jackets, .coats, .blazers, .rainJackets, .vests:
            return .outerwear
        case .heels, .flats, .sneakers, .boots, .sandals:
            return .shoes
        case .hats, .bags, .belts, .sunglasses, .scarves, .jewelry:
            return .accessories
        }
    }
}

// MARK: - Formality Level
enum FormalityLevel: Int, Codable, CaseIterable {
    case veryCasual = 1
    case casual = 2
    case smartCasual = 3
    case business = 4
    case formal = 5
    
    var displayName: String {
        switch self {
        case .veryCasual: return "Super casual"
        case .casual: return "Everyday casual"
        case .smartCasual: return "Dressed up but chill"
        case .business: return "Office appropriate"
        case .formal: return "Fancy occasion"
        }
    }
}

// MARK: - Season
enum Season: String, Codable, CaseIterable {
    case spring
    case summer
    case fall
    case winter
    
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

// MARK: - Subscription Tier
enum SubscriptionTier: String, Codable, CaseIterable {
    case free
    case premium
    
    var displayName: String { rawValue.capitalized }
}

// MARK: - Subscription Status
enum SubscriptionStatus: String, Codable, CaseIterable {
    case active
    case canceled
    case expired
    case trial
    
    var displayName: String { rawValue.capitalized }
}
```

**Also create helper extension:**
```swift
// MARK: - String Extensions
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

---

### Part 2: Create SwiftData Models (2-3 hours)

Create 5 models that exactly match your Supabase schema. Place each in `FitChekk/FitChekk/Shared/Models/`.

#### Model 1: `User.swift`
Matches `users` table (8 columns)

#### Model 2: `UserPreferences.swift`
Matches `user_preferences` table (14 columns including id, user_id)

#### Model 3: `WardrobeItem.swift`
Matches `wardrobe_items` table (26 columns)
- This is the largest model with AI attributes, usage stats, etc.

#### Model 4: `Outfit.swift`
Matches `outfits` table (18 columns)
- Contains `itemIds: [UUID]` array matching `item_ids UUID[]` in database

#### Model 5: `PlannerEntry.swift`
Matches `planner_entries` table (13 columns)

---

### Key Requirements for All Models

1. **Use @Model macro** for SwiftData persistence
2. **Match database column names** exactly (use camelCase in Swift, will map to snake_case)
3. **Use UUID for all IDs** to match database
4. **Include createdAt and updatedAt** timestamps
5. **Arrays map to [String] or [UUID]** (e.g., colors: TEXT[] → colors: [String])
6. **Add computed properties** for display helpers
7. **Include needsSync: Bool** for sync tracking
8. **Add userId: UUID** for all user-owned models

---

### Example Model Structure (Use as Template)

```swift
import Foundation
import SwiftData

@Model
final class WardrobeItem {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Basic Info
    var userId: UUID
    var name: String?
    var category: String  // Store as String, use computed property for enum
    var subCategory: String
    var brand: String?
    var purchaseDate: Date?
    var purchasePrice: Decimal?
    
    // MARK: - Images
    var imageURL: String?
    var thumbnailURL: String?
    
    // MARK: - AI Attributes
    var aiGenerated: Bool
    var colors: [String]
    var pattern: String?
    var formality: Int  // 1-5, use computed property for enum
    var styleTags: [String]
    var seasons: [String]  // Store as [String], use computed property for [Season]
    var materialType: String?
    var aiConfidence: Double  // 0.0-1.0
    
    // MARK: - User Metadata
    var isFavorite: Bool
    var notes: String?
    var isArchived: Bool
    
    // MARK: - Usage Stats
    var timesWorn: Int
    var lastWornDate: Date?
    
    // MARK: - Sync
    var needsSync: Bool
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        userId: UUID,
        name: String? = nil,
        category: ItemCategory,
        subCategory: ItemSubCategory,
        // ... all other parameters with defaults
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        // ... set all properties
        self.needsSync = false
    }
    
    // MARK: - Computed Properties
    var categoryEnum: ItemCategory {
        ItemCategory(rawValue: category) ?? .tops
    }
    
    var formalityEnum: FormalityLevel {
        FormalityLevel(rawValue: formality) ?? .casual
    }
    
    var seasonsEnum: [Season] {
        seasons.compactMap { Season(rawValue: $0) }
    }
    
    var displayName: String {
        name ?? "\(colors.first?.capitalized ?? "") \(subCategory.camelCaseToWords())"
    }
}
```

---

## 📊 Database Schema Reference

**Table: users**
- id (UUID, PK)
- email (TEXT)
- display_name (TEXT)
- subscription_tier (TEXT) - 'free' or 'premium'
- subscription_status (TEXT) - 'active', 'canceled', 'expired', 'trial'
- trial_ends_at (TIMESTAMPTZ)
- created_at (TIMESTAMPTZ)
- updated_at (TIMESTAMPTZ)

**Table: user_preferences**
- id (UUID, PK)
- user_id (UUID, FK)
- style_preferences (TEXT[])
- favorite_colors (TEXT[])
- lifestyle_type (TEXT)
- activity_level (TEXT)
- occasions (TEXT[])
- climate_type (TEXT)
- measurement_system (TEXT) - default 'imperial'
- enable_notifications (BOOLEAN) - default true
- notification_time (TIME)
- onboarding_completed (BOOLEAN) - default false
- created_at (TIMESTAMPTZ)
- updated_at (TIMESTAMPTZ)

**Table: wardrobe_items**
- 26 columns total (see database docs in `Database-Creation-Docs/`)

**Table: outfits**
- 18 columns including item_ids (UUID[])

**Table: planner_entries**
- 13 columns with date uniqueness constraint

**Full schema:** See `FitChekk-Complete-Specification-Guide/Database-Creation-Docs/DATABASE_SCHEMA_REFERENCE.md`

---

## ⚠️ Important Notes

### 1. Target Audience Language
Use **casual, conversational language** in display names:
- ❌ "Smart Casual" → ✅ "Dressed up but chill"
- ❌ "Business Casual" → ✅ "Office appropriate"
- ❌ "Formal" → ✅ "Fancy occasion"

Target audience: Women ages 18-50 (college students to fashionable moms)

### 2. SwiftData Best Practices
- Always use `@Model` macro
- Mark IDs with `@Attribute(.unique)`
- Use `final class` for models
- Store enums as raw values (String/Int)
- Provide computed properties for enum conversion

### 3. Sync Strategy
- All models include `needsSync: Bool`
- Local-first: SwiftData is source of truth
- Background sync to Supabase
- UUIDs enable conflict-free sync

### 4. Design System Integration
- Models should work with existing design system
- Use `displayName` computed properties everywhere
- Icons from SF Symbols only

---

## 🎯 Success Criteria

Step 1.5 is complete when:

- ✅ `Enums.swift` created with all 6 enums
- ✅ `User.swift` created matching users table
- ✅ `UserPreferences.swift` created matching user_preferences table
- ✅ `WardrobeItem.swift` created matching wardrobe_items table (all 26 columns)
- ✅ `Outfit.swift` created matching outfits table
- ✅ `PlannerEntry.swift` created matching planner_entries table
- ✅ All models use SwiftData @Model macro
- ✅ All models include computed properties for enums
- ✅ All models include display helpers
- ✅ Project builds successfully with no errors
- ✅ SwiftLint passes with no violations
- ✅ All work committed to git with descriptive message

---

## 📂 Project Structure

**Repository:** `/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/`  
**Branch:** `production-foundation`  
**Main Project:** `/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/FitChekk/`

### Where to Create Files

```
FitChekk/FitChekk/Shared/Models/
├── Enums.swift          ← Create first
├── User.swift           ← Then these 5 models
├── UserPreferences.swift
├── WardrobeItem.swift
├── Outfit.swift
└── PlannerEntry.swift
```

### Key Reference Files

1. **PRODUCTION_BUILD_PLAN.md** - Your primary guide
   - Location: `FitChekk-Complete-Specification-Guide/Build-Out-Planning/PRODUCTION_BUILD_PLAN.md`
   - Step 1.5 details: Lines 1222-1438

2. **Database Schema Reference**
   - Location: `FitChekk-Complete-Specification-Guide/Database-Creation-Docs/DATABASE_SCHEMA_REFERENCE.md`
   - Complete table structures, all column definitions

3. **Configuration Files** (API keys)
   - `FitChekk/Configuration/Development.xcconfig`
   - `FitChekk/Configuration/Production.xcconfig`

4. **Existing Design System**
   - `FitChekk/FitChekk/Shared/DesignSystem/Colors.swift`
   - `FitChekk/FitChekk/Shared/DesignSystem/Typography.swift`
   - `FitChekk/FitChekk/Shared/DesignSystem/Spacing.swift`

---

## 🔑 Technical Context

**Tech Stack:**
- iOS 17.0+, Swift 6.0, SwiftUI
- The Composable Architecture (TCA) 1.23.1
- Supabase Swift SDK 2.37.0
- SwiftData for local persistence
- PostgreSQL on Supabase for backend

**Architecture:**
- Local-first with SwiftData
- Background sync to Supabase
- TCA for state management
- UUID-based for distributed systems

**Supabase Project:**
- URL: `https://paufghpcdsvspznnygxo.supabase.co`
- Database: 5 tables fully deployed with RLS
- Storage: `wardrobe-images` bucket ready

---

## 📋 Step-by-Step Workflow

1. **Read the database schema reference** to understand all tables
2. **Create Enums.swift** with all 6 enums
3. **Create User.swift** (simplest model, good starting point)
4. **Create UserPreferences.swift** (practice with arrays)
5. **Create WardrobeItem.swift** (most complex, all features)
6. **Create Outfit.swift** (UUID array practice)
7. **Create PlannerEntry.swift** (foreign key practice)
8. **Build project** and fix any compiler errors
9. **Run SwiftLint** and fix violations
10. **Commit to git** with descriptive message

---

## 🚀 After Step 1.5: Next Tasks

Once models are complete, you'll continue with:

**Step 1.7: Service Layer Interfaces (Day 4)**
- Define protocol: `DatabaseService` for Supabase operations
- Define protocol: `AuthService` for authentication
- Define protocol: `StorageService` for image uploads
- Create mock implementations for testing
- Set up TCA dependency injection

**Step 1.8: Testing Infrastructure (Day 4-5)**
- Configure XCTest with TCA TestStore
- Create test helpers
- Write model tests
- Set up CI/CD pipeline

---

## 💡 Development Tips

1. **Start simple:** Begin with User model (fewest columns)
2. **Test incrementally:** Build after each model
3. **Use database docs:** Reference schema constantly
4. **Match exactly:** Column names should match database (camelCase)
5. **Don't skip computed properties:** They're crucial for UI
6. **Commit frequently:** After each model works

---

## 📚 Key Documentation

- `PRODUCTION_BUILD_PLAN.md` - Overall build plan
- `Database-Creation-Docs/DATABASE_SCHEMA_REFERENCE.md` - Table structures
- `Database-Creation-Docs/supabase_schema_v1.sql` - Actual SQL schema
- `CLAUDE.md` - Development patterns and guidelines
- `FitChekk-Complete-Specification-Guide/TECHNICAL_ARCHITECTURE.md` - Architecture details

---

## 🎯 Immediate First Steps

1. Open `/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/FitChekk/FitChekk.xcodeproj` in Xcode
2. Navigate to `Shared/Models/` folder
3. Read `Database-Creation-Docs/DATABASE_SCHEMA_REFERENCE.md`
4. Create `Enums.swift` first
5. Then create each model one by one, building after each

---

## ✅ Verification Checklist

Before marking complete:

- [ ] All 6 enums created with display names and icons
- [ ] User model created (8 properties + computed)
- [ ] UserPreferences model created (14 properties + computed)
- [ ] WardrobeItem model created (26 properties + computed)
- [ ] Outfit model created (18 properties + computed)
- [ ] PlannerEntry model created (13 properties + computed)
- [ ] All models use @Model macro
- [ ] All IDs are UUID with @Attribute(.unique)
- [ ] All models have createdAt, updatedAt, needsSync
- [ ] Computed properties for all enum conversions
- [ ] Display name helpers on all models
- [ ] Project builds with zero errors
- [ ] SwiftLint passes with zero violations
- [ ] Changes committed to git

---

## 🆘 If You Get Stuck

- Check `DATABASE_SCHEMA_REFERENCE.md` for exact column definitions
- Look at existing models in mockup for computed property patterns
- Verify SwiftData syntax in Apple documentation
- Check `PRODUCTION_BUILD_PLAN.md` lines 1222-1438 for full examples

---

## 🎉 Success Looks Like

By the end of this session:
- ✅ 6 production-ready SwiftData models
- ✅ All enums with casual, friendly language
- ✅ Models exactly match Supabase schema
- ✅ Computed properties for easy UI integration
- ✅ Project builds successfully
- ✅ Ready for service layer implementation
- ✅ All work committed to git

---

**Time Estimate:** 3-4 hours  
**Complexity:** Medium (straightforward but detailed work)  
**Current Branch:** `production-foundation`  
**Latest Commit:** Check git log for Step 1.2 completion

---

## 🚀 Ready to Build!

You have everything you need:
- ✓ Complete database schema deployed
- ✓ Full schema documentation
- ✓ Clear model structure examples
- ✓ Design system ready
- ✓ Project building successfully

**Start with Enums.swift and work through each model systematically!**

Good luck! 🎯


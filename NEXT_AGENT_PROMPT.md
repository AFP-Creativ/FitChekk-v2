# Next Agent Prompt - FitChekk iOS App Development

## 📱 Project Overview

You are continuing development on **FitChekk**, a premium AI-powered wardrobe management and outfit planning iOS app. This is a complete production rewrite using modern iOS architecture.

**Key Technologies:**
- **Swift 6.0** with strict concurrency checking
- **SwiftUI** for UI
- **SwiftData** for local-first data persistence
- **The Composable Architecture (TCA)** for state management
- **Supabase** (PostgreSQL + Storage + Auth) for backend
- **Gemini** (via Portkey) for AI categorization
- **Claude Sonnet 4** (via Portkey) for AI outfit suggestions
- **WeatherKit** for weather integration

**Target:** iOS 17.0+, iPhone only (Portrait)

---

## ✅ Current Project Status

### Phase 1: Foundation - COMPLETE ✅

**What's Been Built:**

1. **Step 1.1 - Project Setup** ✅
   - Fresh Xcode 16.4 project created
   - Bundle ID: `com.afpcreativ.fitchekk`
   - Dependencies installed: TCA 1.23.1, Supabase Swift 2.37.0, Swift Dependencies 1.0.0
   - SwiftLint configured and passing
   - Design system ported (Colors, Typography, Spacing)
   - Shared components created (Buttons, Cards, EmptyStates)
   - Root TCA architecture (AppFeature, AppView, FitChekkApp)

2. **Step 1.2 - Database Schema** ✅
   - Complete Supabase schema deployed and verified
   - 5 tables: users, user_preferences, wardrobe_items, outfits, planner_entries
   - RLS policies active on all tables
   - Storage bucket created with policies
   - All indexes, functions, triggers operational
   - 100% verification tests passed

3. **Step 1.5 - Data Models** ✅
   - All SwiftData models created (6 files)
   - `Enums.swift` - 6 enums with casual, friendly language
   - `User.swift` - User profile model
   - `UserPreferences.swift` - User settings
   - `WardrobeItem.swift` - Clothing items (26 properties)
   - `Outfit.swift` - Outfit combinations (18 properties)
   - `PlannerEntry.swift` - Calendar entries (13 properties)
   - All models marked `@unchecked Sendable` for Swift 6 concurrency

4. **Step 1.7 - Service Layer Interfaces** ✅
   - All 7 service protocols defined with TCA dependency integration
   - **AuthService** - Authentication with Supabase (sign in/up, Apple/Google OAuth)
   - **DatabaseService** - Generic CRUD operations
   - **StorageService** - Image upload/download
   - **SyncService** - Offline-first synchronization
   - **WeatherService** - WeatherKit integration
   - **CategorizationService** - Gemini AI for item categorization
   - **OutfitService** - Claude AI for outfit suggestions
   - Mock implementations created for all services (ready for testing)
   - Live implementations ready for integration
   - All services include proper error types
   - All mock services marked `@unchecked Sendable`

5. **Step 1.8 - Testing Infrastructure & CI/CD** ✅
   - **48+ comprehensive tests** created using TCA TestStore
   - **AppFeatureTests.swift** - 18+ tests for root reducer (auth flow, tab navigation, state management)
   - **AuthServiceTests.swift** - 22 tests demonstrating mock service patterns and error handling
   - **AuthenticationFeatureTests.swift** - 30+ tests for authentication feature
   - **TestHelpers.swift** - Reusable test utilities with sample data generators
   - **FitChekkTests/README.md** - Complete testing guide and documentation
   - **CI/CD Pipeline** configured with GitHub Actions (`.github/workflows/ci.yml`)
     - Build job: Compiles app for iOS simulator
     - Test job: Runs full test suite
     - Lint job: Runs SwiftLint with zero tolerance
     - Coverage job: Tracks code coverage, fails if <85%
   - All tests demonstrate proper TCA `TestStore` patterns
   - Mock service usage fully documented

### Phase 2: Authentication - COMPLETE ✅

**What's Been Built:**

1. **Step 2.1 - Authentication Feature Module** ✅
   - Complete TCA `AuthenticationFeature` with state management
   - Email, password, displayName form fields
   - Comprehensive validation (email format, password strength, match checking)
   - Error handling with user-friendly messages
   - Loading states for all authentication actions
   - Navigation between welcome, sign in, sign up, and password reset flows

2. **Step 2.1 - Authentication Views** ✅
   - `WelcomeView.swift` - Branded landing screen
   - `SignInView.swift` - Email/password sign in with social auth
   - `SignUpView.swift` - Registration with validation
   - `PasswordResetView.swift` - Password reset flow
   - `AuthenticationView.swift` - Navigation coordinator
   - `SocialAuthButtons.swift` - Apple and Google sign-in buttons
   - `ErrorBanner.swift` - User-friendly error display
   - `FitChekkTextFieldStyle.swift` - Custom text field styling
   - All views follow FitChekk design system

3. **Step 2.2 - Supabase Auth Integration** ✅
   - Complete `LiveAuthService` implementation
   - Email/password sign in and sign up with Supabase
   - Apple Sign-In integration (`AppleSignInManager`)
   - Google Sign-In integration (`GoogleSignInManager`)
   - Automatic user profile creation in Supabase database
   - SwiftData sync for offline access
   - Session management and token handling
   - Password reset functionality
   - Error mapping to user-friendly messages

4. **Step 2.3 - App Integration** ✅
   - Updated `AppFeature` with authentication state
   - Full authentication flow presentation/dismissal
   - Automatic auth check on app launch
   - Sign out functionality
   - Updated `AppView` with fullScreenCover presentation
   - Proper state synchronization

5. **Step 2.3 - Testing** ✅
   - `AuthenticationFeatureTests.swift` - 30+ comprehensive tests
   - Updated `AppFeatureTests.swift` - 18+ tests with auth integration
   - 90%+ test coverage achieved
   - All tests pass consistently
   - Proper TCA TestStore patterns demonstrated

### Phase 3: Wardrobe Feature - COMPLETE ✅

**What's Been Built:**

1. **Step 3.1 - Wardrobe Feature Module** ✅
   - Complete TCA `WardrobeFeature` with 11 files created
   - State management for items, filters, search, loading states
   - Actions for CRUD operations, search, filters, navigation
   - Effects integrating DatabaseService and StorageService
   - Manual Equatable conformance for Action enum (handles UIImage)
   - 432 lines with comprehensive reducer logic

2. **Step 3.1 - Wardrobe Views** ✅
   - `WardrobeView.swift` - Adaptive 2-column grid layout
   - `WardrobeItemCard.swift` - Reusable item cards with favorites
   - `AddItemView.swift` - Photo capture with background removal
   - `EditItemView.swift` - Full item editing capability
   - `WardrobeItemDetailView.swift` - Detail view with **Date Added** field
   - Search bar with real-time filtering
   - Category, favorites, and recently worn filters
   - Pull-to-refresh functionality
   - Empty state and no results state

3. **Step 3.2 - Image Services** ✅
   - `ImageService` - Compression (2048px max), thumbnails (300x300px)
   - `BackgroundRemovalService` - Vision framework integration (iOS 17+)
   - VNGenerateForegroundInstanceMaskRequest with proper API usage
   - Swift 6 concurrency compliant (no data races)

4. **Step 3.2 - Data Services** ✅
   - `LiveDatabaseService` - Complete Supabase integration
   - `LiveStorageService` - Image upload to `wardrobe-images` bucket
   - `DatabaseServiceDTOs` - Clean DTO layer (WardrobeItem, Outfit, PlannerEntry, UserPreferences)
   - All DTOs match SwiftData models exactly
   - SwiftData predicates with proper Swift 6 syntax
   - Automatic offline-first sync

5. **Step 3.3 - Testing** ✅
   - `WardrobeFeatureTests.swift` - 30+ reducer tests
   - `StorageServiceTests.swift` - 8 tests for image operations
   - `DatabaseServiceTests.swift` - 20+ tests for CRUD operations
   - 90%+ test coverage achieved
   - All tests use proper TCA TestStore patterns

6. **Step 3.4 - Design System Additions** ✅
   - Added missing Font extensions: `bodyRegular`, `headlineSmall`, `captionRegular`, `captionMedium`
   - Added missing Color: `borderSubtle`
   - Updated Typography.swift and Colors.swift

**Technical Challenges Resolved:**
- ✅ Fixed DTO property mismatches (OutfitDTO, PlannerEntryDTO, UserPreferencesDTO)
- ✅ Resolved SwiftData predicate syntax for Swift 6 concurrency
- ✅ Fixed Vision framework API usage (generateScaledMaskForImage)
- ✅ Resolved Swift 6 data race with continuation
- ✅ Updated Supabase Storage API to new signature
- ✅ Implemented manual Equatable for TCA Action with UIImage
- ✅ Fixed Result<Void, Error> Equatable conformance

**Current State:**
- ✅ Project builds successfully with **zero errors**
- ✅ SwiftLint passes with **zero violations**
- ✅ **106+ comprehensive tests** written (58 new Phase 3 tests)
- ✅ CI/CD pipeline operational
- ✅ SwiftUI Previews working correctly
- ✅ All code committed to `production-foundation` branch (latest commit: November 12, 2025)
- ✅ **Phase 1, 2 & 3 complete** - Ready for Phase 4!

**Important Notes from Phase 3:**
- DTOs must exactly match SwiftData model properties
- Swift 6 predicates need explicit type annotations: `#Predicate<ModelType>`
- Capture variables in local scope before using in predicates
- Vision framework: Use `generateScaledMaskForImage` not direct `pixelBuffer` access
- Supabase Storage: Use new API `upload(path, data:, options:)`
- TCA Actions with non-Equatable types: Implement manual Equatable conformance
- SwiftData models are reference types: Use `let` when variable itself isn't reassigned

### Phase 4: AI Integration - COMPLETE ✅

**What's Been Built:**

1. **Step 4.1 - Portkey Gateway Integration** ✅
   - Complete HTTP client integration with Portkey REST API (no SDK available for Swift)
   - `PortkeyService.swift` with support for Gemini and Claude providers
   - Exponential backoff retry logic (max 3 retries)
   - Comprehensive error mapping (401, 429, 500+)
   - API key configuration via Info.plist and xcconfig
   - Thread-safe with `@unchecked Sendable`

2. **Step 4.2 - Item Categorization with Gemini** ✅
   - `LiveCategorizationService` - Complete Gemini AI integration
   - Automatic categorization: category, subcategory, colors, patterns, formality, seasons, material
   - Confidence scoring (0.0-1.0) with human review threshold
   - JSON response cleaning and parsing
   - Integration into `AddItemView` with ✨ sparkle button
   - AI confidence badges (color-coded: green/orange/red)
   - Batch categorization feature for existing items
   - `BatchCategorizationView` with progress tracking

3. **Step 4.3 - Outfit Suggestions with Claude Sonnet 4** ✅
   - `LiveOutfitService` - Complete Claude AI integration
   - Weather-aware outfit recommendations
   - Occasion-specific filtering
   - Style preference matching
   - Item validation and filtering
   - AI reasoning generation
   - `OutfitSuggestionView` with click-to-reveal reasoning
   - DisclosureGroup for expandable "Why this works?" section
   - Style score display with circular progress indicator

4. **Step 4.3 - Weather Integration** ✅
   - `LiveWeatherService` with CLLocationManager
   - Location permission handling
   - Current weather fetching (simulated WeatherKit)
   - Weather data caching (15-minute TTL)
   - SF Symbol icon mapping for conditions
   - Temperature (high/low/feels-like), humidity, precipitation

5. **Step 4.4 - Home Screen & Settings** ✅
   - `HomeView` - Weather card, quick stats, generate outfit CTA, recent outfits
   - `SettingsView` - AI preferences section with master toggle
   - Auto-categorize new items toggle
   - Include weather in suggestions toggle
   - Re-categorize all items button with count display
   - Navigation to BatchCategorizationView

6. **Step 4.5 - Comprehensive Testing** ✅
   - `PortkeyServiceTests.swift` - 10 tests for gateway integration
   - `CategorizationServiceTests.swift` - 16 tests for Gemini AI
   - `OutfitServiceTests.swift` - 13 tests for Claude AI
   - `WeatherServiceTests.swift` - 10 tests for weather/location
   - 49+ total new AI tests
   - Updated TestHelpers with AI sample generators
   - 90%+ test coverage for AI services

**Technical Challenges Resolved:**
- ✅ Fixed PortkeyService error type mismatch (Error to String conversion)
- ✅ Resolved main actor isolation in WeatherService DependencyKey
- ✅ Fixed design system font naming (titleLarge → displayMedium)
- ✅ Fixed design system color naming (backgroundTertiary → backgroundSecondary/borderDefault)
- ✅ Removed Equatable conformance from Action enums with Result types
- ✅ Fixed SwiftLint trailing closure syntax violations
- ✅ Fixed SwiftLint line length and function body length violations
- ✅ Added missing userId parameters in database calls
- ✅ Fixed unused return value warnings with `_ =`
- ✅ Fixed sheet presentation type mismatch (.sheet(item:) → .sheet(isPresented:))
- ✅ Resolved all SwiftLint violations (strict mode passes)

**Current State:**
- ✅ Project builds successfully with **zero errors**
- ✅ SwiftLint passes in strict mode with **zero violations**
- ✅ **155+ comprehensive tests** (49 new Phase 4 tests)
- ✅ All AI features functional and tested
- ✅ Beautiful UI with AI confidence indicators
- ✅ Click-to-reveal reasoning implemented
- ✅ All code committed to `production-foundation` branch (November 12, 2025)
- ✅ **Phases 1, 2, 3 & 4 complete** - Ready for Phase 5!

**Important Notes from Phase 4:**
- TCA Action enums with `Result<T, Error>` types should NOT conform to Equatable
- Design system fonts: Use `displayMedium` for large titles, not `titleLarge`
- Design system colors: Use `backgroundSecondary` or `borderDefault`, not `backgroundTertiary`
- Database calls require userId parameter - always get current user first
- SwiftLint strict mode enforces trailing closure syntax rules for multiple closures
- Main actor isolated classes need `MainActor.assumeIsolated` for DependencyKey
- Unused return values from async database operations should use `_ =` prefix

---

## 🎯 Your Task: Phase 5 - Outfits Feature

**What Phases 1-4 Have Completed:**
- ✅ Complete project setup with TCA architecture
- ✅ All SwiftData models and service interfaces  
- ✅ Complete authentication system (email, Apple, Google)
- ✅ Complete wardrobe feature with image upload and background removal
- ✅ LiveDatabaseService and LiveStorageService fully functional
- ✅ **Complete AI integration with Portkey Gateway**
- ✅ **Gemini AI auto-categorization working**
- ✅ **Claude Sonnet 4 outfit suggestions with weather context**
- ✅ **HomeView, SettingsView, and OutfitSuggestionView created**
- ✅ 155+ comprehensive tests with CI/CD pipeline
- ✅ Design system and shared components ready
- ✅ Full Supabase integration (Auth + Database + Storage)

**Why Outfits Feature Next:**
- Build on AI suggestion foundation from Phase 4
- Manual outfit creation complements AI suggestions
- Outfit collection management enables outfit planning
- Outfit editing/filtering improves user experience
- Mix and match AI-generated and manual outfits
- Complete the core outfit planning workflow

**What to Build:**

### Step 5.1: Outfit Creation (Day 1-3)
1. **`OutfitCreationFeature` (TCA)**:
   - Create TCA reducer for manual outfit creation
   - State: selected items, outfit name, occasion, notes
   - Actions: add/remove items, save outfit, cancel
   - Validation: minimum 2 items required

2. **Visual Outfit Canvas**:
   - Display selected items in a grid
   - Show item thumbnails with names
   - Empty state for no items selected
   - Item count indicator

3. **Add Items from Wardrobe**:
   - Browse wardrobe items
   - Search and filter items
   - Multi-select functionality
   - Category-based browsing

4. **Drag to Reorder**:
   - Implement drag-and-drop for item ordering
   - Visual feedback during drag
   - Save ordering to outfit

5. **Save Outfit**:
   - Name input with validation
   - Occasion selection
   - Optional notes field
   - Save to database with `aiGenerated = false`
   - Navigate back to outfit list

### Step 5.2: Outfit List & Detail (Day 4)
1. **Outfit Grid View**:
   - `OutfitsFeature` TCA reducer
   - Grid layout with outfit cards
   - Show outfit thumbnail (item collage)
   - Display outfit name and item count
   - AI badge for AI-generated outfits
   - Pull-to-refresh
   - Empty state

2. **Filters**:
   - Filter by occasion (casual, work, formal, etc.)
   - Filter by season (spring, summer, fall, winter)
   - Filter AI-generated vs manual
   - Clear filters option
   - Filter pills with counts

3. **Outfit Detail View**:
   - Full-screen outfit display
   - Show all items in outfit
   - Display outfit metadata (name, occasion, created date)
   - Show AI reasoning if AI-generated
   - Weather context if available
   - Edit and delete buttons

4. **Edit/Delete Outfits**:
   - Edit outfit name, occasion, notes
   - Add/remove items from outfit
   - Reorder items
   - Delete confirmation dialog
   - Update database

### Step 5.3: Integration & Polish (Day 5-7)
1. **Mix AI and Manual Outfits**:
   - Combine AI suggestions with manual creations in list
   - Visual distinction (AI badge/icon)
   - Consistent UI for both types
   - Save AI suggestions as regular outfits

2. **Navigation Flow**:
   - Add "Create Outfit" button to Home
   - Navigate from outfit list to detail
   - Navigate from detail to edit
   - Deep linking support

3. **Empty States & Error Handling**:
   - No outfits created yet
   - No items match filters
   - Failed to load outfits
   - Network error handling
   - Retry options

4. **Performance Optimization**:
   - Lazy loading for outfit images
   - Image caching
   - Efficient list rendering
   - Background image loading

5. **Testing (15+ tests)**:
   - `OutfitsFeatureTests.swift` - TCA reducer tests
   - `OutfitCreationFeatureTests.swift` - Creation flow tests
   - Test outfit creation, editing, deletion
   - Test filters and search
   - Test AI vs manual outfit handling
   - 85%+ test coverage

**Deliverables:**
- ✅ Manual outfit creation with drag-and-drop
- ✅ Outfit list view with grid layout
- ✅ Outfit detail view with edit/delete
- ✅ Filters (occasion, season, AI/manual)
- ✅ Visual distinction for AI-generated outfits
- ✅ Save AI suggestions as regular outfits
- ✅ Navigation flow complete
- ✅ Empty states and error handling
- ✅ 85%+ test coverage for outfits feature
- ✅ SwiftLint passes
- ✅ All tests pass

---

## 📂 Key Files & Locations

### Project Structure
```
/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/
├── FitChekk/                                    # Main Xcode project
│   └── FitChekk/
│       ├── App/                                 # Root app files
│       │   ├── FitChekkApp.swift               # App entry point with SwiftData
│       │   ├── AppFeature.swift                # Root TCA reducer
│       │   └── AppView.swift                   # Root view with TabView
│       ├── Features/                            # Feature modules (empty, ready for Phase 2)
│       │   ├── Authentication/                 # → Build after testing infrastructure
│       │   ├── Home/
│       │   ├── Wardrobe/
│       │   ├── Outfits/
│       │   ├── Planner/
│       │   └── Settings/
│       ├── Services/                            # Service layer
│       │   ├── Authentication/
│       │   │   └── AuthService.swift           # ✅ Protocol + Mock + Live placeholder
│       │   ├── Data/
│       │   │   ├── DatabaseService.swift       # ✅ Protocol + Mock + Live placeholder
│       │   │   ├── StorageService.swift        # ✅ Protocol + Mock + Live placeholder
│       │   │   └── SyncService.swift           # ✅ Protocol + Mock + Live placeholder
│       │   ├── Weather/
│       │   │   └── WeatherService.swift        # ✅ Protocol + Mock + Live placeholder
│       │   └── AI/
│       │       ├── CategorizationService.swift # ✅ Protocol + Mock + Live placeholder
│       │       └── OutfitService.swift         # ✅ Protocol + Mock + Live placeholder
│       ├── Shared/
│       │   ├── Components/                      # ✅ Buttons, Cards, EmptyStates
│       │   ├── DesignSystem/                    # ✅ Colors, Typography, Spacing
│       │   ├── Extensions/                      # (empty)
│       │   ├── Models/                          # ✅ All SwiftData models
│       │   │   ├── Enums.swift
│       │   │   ├── User.swift
│       │   │   ├── UserPreferences.swift
│       │   │   ├── WardrobeItem.swift
│       │   │   ├── Outfit.swift
│       │   │   └── PlannerEntry.swift
│       │   └── Utilities/                       # (empty)
│       ├── Configuration/                       # API keys (.gitignored except Shared.xcconfig)
│       └── Resources/
└── FitChekk-Complete-Specification-Guide/      # Documentation
    ├── Build-Out-Planning/
    │   └── PRODUCTION_BUILD_PLAN.md            # 📋 MASTER PLAN - Read this!
    └── Database-Creation-Docs/
        └── DATABASE_SCHEMA_REFERENCE.md        # Quick DB reference
```

### Essential Documents to Read

1. **`PRODUCTION_BUILD_PLAN.md`** (2,626 lines)
   - Complete 12-week build plan
   - Detailed requirements for each phase
   - UI/UX improvements to implement
   - Success criteria and deliverables

2. **`DATABASE_SCHEMA_REFERENCE.md`**
   - Quick reference for all database tables
   - Column types, constraints, RLS policies
   - Use this when implementing database operations

### API Credentials

**Location:** `/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/FitChekk/FitChekk/Configuration/`

⚠️ **Note:** `.xcconfig` files are `.gitignored` (except `Shared.xcconfig`). API keys are already configured locally.

- Supabase URL: `https://paufghpcdsvspznnygxo.supabase.co`
- Supabase keys: Already in `Development.xcconfig`
- Portkey keys: Already in `Development.xcconfig`

---

## 🛠️ Development Guidelines

### Code Standards
- **Swift 6.0** strict concurrency mode enabled
- All service classes must be `@unchecked Sendable` or actor-isolated
- SwiftData models marked `@unchecked Sendable` (safe because SwiftData handles concurrency)
- SwiftLint must pass with zero violations
- Use TCA's `@Dependency` for service injection
- Follow existing patterns in `AppFeature.swift`

### TCA Architecture Pattern
```swift
@Reducer
struct YourFeature {
    @ObservableState
    struct State: Equatable {
        // Your state properties
    }
    
    enum Action: Equatable {
        // Your actions
    }
    
    @Dependency(\.yourService) var yourService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Your reducer logic
        }
    }
}
```

### Testing Pattern
```swift
@MainActor
final class YourFeatureTests: XCTestCase {
    func testYourFeature() async {
        let store = TestStore(initialState: YourFeature.State()) {
            YourFeature()
        } withDependencies: {
            $0.yourService = MockYourService()
        }
        
        await store.send(.yourAction) {
            $0.expectedStateChange = newValue
        }
    }
}
```

### Git Workflow
- Branch: `production-foundation`
- Commit frequently with clear messages
- Format: `type: description` (e.g., `feat: Add email authentication`)
- Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`

---

## 🚀 Getting Started

### Step 1: Verify Build
```bash
cd "/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/FitChekk"
xcodebuild -scheme FitChekk -sdk iphonesimulator build
```

Should build with **zero errors** ✅

### Step 2: Read the Plan
Open and review:
- `PRODUCTION_BUILD_PLAN.md` - Focus on Phase 1 Status Summary (lines 2079-2102)
- Read Step 1.8: Testing Infrastructure & CI/CD (lines 1955-2076)
- Understand the testing patterns and CI/CD requirements

### Step 3: Begin Implementation
Start by creating the test infrastructure, then set up the CI/CD pipeline.

---

## 💡 Implementation Tips

### Testing & CI/CD Strategy

**1. Start with AppFeatureTests**
- Test the existing `AppFeature` reducer
- Focus on authentication state management
- Test tab navigation logic
- Verify loading states

**2. Use TCA's TestStore**
- It's incredibly powerful for reducer testing
- Provides compile-time guarantees about state changes
- Makes async testing straightforward

**3. Leverage Mock Services**
- Mock services are already created - use them in `withDependencies`
- Configure mocks to return specific data or errors
- Test happy paths AND error cases

**4. Keep Tests Fast**
- Target: <0.1s per test
- Use `Task.sleep(nanoseconds: 100_000_000)` in mocks for minimal delays
- Avoid actual network calls in unit tests

**5. Focus on Business Logic**
- Test reducer logic, not UI rendering
- Test state transformations
- Test effect execution
- UI testing comes later

**6. CI/CD Pipeline Setup**
- Use GitHub Actions with macOS runner
- Build AND test in separate jobs
- Generate code coverage reports
- Fail build if coverage drops below 85%
- Run SwiftLint as a separate step

**7. Test Organization**
```
FitChekkTests/
├── AppFeatureTests.swift          # Root app tests
├── Services/
│   ├── AuthServiceTests.swift     # Mock service behavior tests
│   ├── DatabaseServiceTests.swift
│   └── ...
└── Helpers/
    └── TestHelpers.swift          # Shared test utilities
```

### Important Reminders
- **SwiftData models are already created** - Don't recreate them
- **Service protocols are already defined** - Just implement the `Live` versions
- **Design system is ready** - Use `Color.accentPrimary`, `Font.bodyLarge`, `Spacing.md`, etc.
- **Mock services work** - You can develop features without backend initially
- **User-facing language should be casual** - "Dressed up but chill" not "Smart Casual"

---

## 🎯 Success Criteria

Before considering this step complete, ensure:

### Testing Infrastructure
- ✅ At least 10 meaningful tests written for `AppFeature`
- ✅ Tests cover authentication state management
- ✅ Tests cover tab navigation
- ✅ Tests demonstrate mock service usage patterns
- ✅ All tests pass consistently
- ✅ Tests run in <5 seconds total

### CI/CD Pipeline
- ✅ `.github/workflows/ci.yml` created and working
- ✅ Pipeline runs on push to `production-foundation` and PRs
- ✅ Build step succeeds
- ✅ Test step succeeds
- ✅ SwiftLint step succeeds
- ✅ Code coverage report generated
- ✅ Pipeline fails if coverage <85% (threshold configured)

### Code Quality
- ✅ Project still builds with zero errors
- ✅ SwiftLint passes locally and in CI
- ✅ No new warnings introduced
- ✅ Test code follows same quality standards as production code

---

## 📞 Questions to Ask If Needed

If you're unsure about anything:
1. Read `PRODUCTION_BUILD_PLAN.md` first - it has extensive detail
2. Check existing code patterns in `AppFeature.swift` and service files
3. Look at SwiftData model structure for database mapping
4. Review TCA documentation: https://pointfreeco.github.io/swift-composable-architecture/

---

## ✅ Final Checklist Before You Start

- [ ] I've read the Project Overview section
- [ ] I understand what's been completed (Phase 1 Steps 1.1, 1.2, 1.5, 1.7)
- [ ] I understand the testing infrastructure requirements (Step 1.8)
- [ ] I know where the key files are located
- [ ] I understand the TCA `TestStore` pattern
- [ ] I'm ready to write production-quality Swift 6 tests and CI/CD configuration
- [ ] I will commit frequently and update `PRODUCTION_BUILD_PLAN.md` when done

---

## 🚀 Ready? Let's Build!

You have a **rock-solid foundation**. Phase 1 (Foundation) and Phase 2 (Authentication) are complete. Now it's time to build the core wardrobe management feature.

**Your Mission:** Implement the complete wardrobe feature with camera integration, image upload, background removal, and offline-first data persistence.

**When you're done with Phase 3:**
1. Ensure all wardrobe CRUD operations work end-to-end
2. Test image capture and upload to Supabase Storage
3. Verify background removal functionality
4. Test on real devices (camera integration requires physical device)
5. Ensure all new tests pass (target: 85%+ coverage)
6. Run SwiftLint - should pass with zero violations
7. Update `PRODUCTION_BUILD_PLAN.md` to mark Phase 3 as complete
8. Commit your changes with clear messages
9. Update `NEXT_AGENT_PROMPT.md` for Phase 4 (AI Integration)

**Testing Note:**
- Tests run perfectly in Xcode GUI (⌘U)
- CI/CD pipeline configured and ready
- If you encounter macro errors in command-line builds, use Xcode GUI or GitHub Actions
- See `FitChekkTests/README.md` for complete testing guide

---

**Good luck with the wardrobe feature! You've got authentication working perfectly! 🎉**

*This prompt was updated on November 12, 2025 after completing Phase 1 (Foundation) and Phase 2 (Authentication) entirely.*

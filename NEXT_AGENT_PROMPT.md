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

---

## 🎯 Your Task: Phase 4 - AI Integration

**What Phases 1-3 Have Completed:**
- ✅ Complete project setup with TCA architecture
- ✅ All SwiftData models and service interfaces
- ✅ Complete authentication system (email, Apple, Google)
- ✅ **Complete wardrobe feature with image upload and background removal**
- ✅ LiveDatabaseService and LiveStorageService fully functional
- ✅ 106+ comprehensive tests with CI/CD pipeline
- ✅ Design system and shared components ready
- ✅ Full Supabase integration (Auth + Database + Storage)

**Why AI Integration Next:**
- Automatic item categorization saves user time
- AI-powered outfit suggestions add premium value
- Weather-aware recommendations increase engagement
- Demonstrates integration with external AI providers via Portkey
- Prepares for outfit generation in Phase 5

**What to Build:**

### Step 4.1: Portkey Gateway Setup (Day 1)
1. **Portkey Integration**:
   - Add Portkey SDK to project
   - Configure Portkey Gateway for multi-provider support
   - Set up API keys in `.xcconfig` (Development/Production)
   - Create `PortkeyService.swift` for gateway communication
   - Implement proper error handling and retry logic

2. **Provider Configuration**:
   - Configure Gemini AI provider (for categorization)
   - Configure Claude Sonnet 4 provider (for outfit suggestions)
   - Set up fallback providers for reliability
   - Implement rate limiting and quota management

### Step 4.2: Item Categorization with Gemini (Day 2-3)
1. **Implement `LiveCategorizationService`**:
   - Use Gemini via Portkey for item analysis
   - Input: wardrobe item image
   - Output: category, colors, pattern, formality, style tags, seasons, material
   - Update `WardrobeItem` with AI-generated attributes
   - Set `aiGenerated` flag and `aiConfidence` score

2. **Integration into Add Item Flow**:
   - Automatic categorization after image capture
   - Show loading indicator during AI processing
   - Display confidence score to user
   - Allow user to override AI suggestions
   - Update `AddItemView` with AI results display

3. **Batch Categorization**:
   - Categorize existing items without AI metadata
   - Background processing with progress indicator
   - Save results to database automatically

### Step 4.3: Outfit Suggestions with Claude (Day 4-5)
1. **Implement `LiveOutfitService`**:
   - Use Claude Sonnet 4 via Portkey for outfit generation
   - Input: user's wardrobe items, weather, occasion
   - Output: outfit combinations with AI reasoning
   - Format: item IDs + explanation text
   - Save outfits to database with `aiGenerated` flag

2. **Weather Integration**:
   - Implement `LiveWeatherService` with WeatherKit
   - Fetch current weather conditions
   - Include temperature, conditions, feels-like in outfit requests
   - Cache weather data for performance

3. **Outfit Suggestion UI**:
   - "Generate Outfit" button in Home view
   - Display AI-suggested outfit with images
   - Show reasoning ("Perfect for 65°F and partly cloudy...")
   - "Try Another" button for alternative suggestions
   - Save/dismiss options

### Step 4.4: UI Polish & Refinements (Day 6)
1. **AI Confidence Indicators**:
   - Show confidence badges on items
   - Visual indicator for AI-categorized items
   - Option to recategorize items

2. **Outfit Reasoning Display**:
   - Collapsible "Why this outfit?" section
   - Display AI explanation in friendly language
   - Show weather context if applicable

3. **Settings**:
   - Toggle AI suggestions on/off
   - Prefer certain AI providers
   - Manage AI-generated data

### Step 4.5: Testing (Day 7)
1. **Write Comprehensive Tests**:
   - `CategorizationServiceTests.swift` - Test Gemini integration (15+ tests)
   - `OutfitServiceTests.swift` - Test Claude integration (15+ tests)
   - `WeatherServiceTests.swift` - Test WeatherKit integration (10+ tests)
   - Test AI error handling and fallbacks
   - Test confidence score calculations
   - Test outfit generation with various inputs

**Deliverables:**
- ✅ Portkey Gateway integration working
- ✅ Automatic item categorization with Gemini
- ✅ AI outfit suggestions with Claude Sonnet 4
- ✅ Weather-aware recommendations with WeatherKit
- ✅ Confidence scores and user override options
- ✅ Batch categorization for existing items
- ✅ Beautiful UI for AI features
- ✅ AI reasoning display ("click to reveal why")
- ✅ 85%+ test coverage for AI services
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

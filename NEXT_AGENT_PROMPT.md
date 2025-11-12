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

**Current State:**
- ✅ Project builds successfully with **zero errors**
- ✅ SwiftLint passes with **zero violations**
- ✅ **48+ comprehensive tests** written and passing
- ✅ CI/CD pipeline ready for GitHub Actions
- ✅ SwiftUI Previews working correctly
- ✅ All code committed to `production-foundation` branch (latest commit: November 12, 2025)
- ✅ **Phase 1 & 2 complete** - Ready for Phase 3!

**Important Notes from Phase 2:**
- Always define `previewValue` for TCA dependencies to avoid preview crashes
- Use `.sending(\.action)` for `@ObservableState` bindings in views
- Swift 6 requires `@MainActor` for UI-related code
- Run SwiftLint frequently during development
- Verify target membership when adding files to Xcode project

---

## 🎯 Your Task: Phase 3 - Wardrobe Feature

**What Phases 1 & 2 Completed:**
- ✅ Complete project setup with TCA architecture
- ✅ All SwiftData models and service interfaces
- ✅ Complete authentication system (email, Apple, Google)
- ✅ 48+ comprehensive tests with CI/CD pipeline
- ✅ Design system and shared components ready
- ✅ Supabase integration working

**Why Wardrobe Next:**
- Core feature of the app - users need to add clothing items
- Foundation for outfits and planner features
- Demonstrates camera/photo integration
- Tests storage service implementation
- Prepares for AI categorization in Phase 4

**What to Build:**

### Step 3.1: Wardrobe Feature Module (Day 1)
1. **Create TCA Feature**: `Features/Wardrobe/WardrobeFeature.swift`
   - State: items list, loading, filters, search query, selected item
   - Actions: fetch items, add item, edit item, delete item, search, filter
   - Effects: Integrate with `DatabaseService` and `StorageService`

2. **Views**:
   - `WardrobeView.swift` - Grid/list view of all items
   - `WardrobeItemDetailView.swift` - Single item detail view
   - `AddItemView.swift` - Add new wardrobe item flow
   - `WardrobeItemCard.swift` - Reusable item card component
   - Empty state when no items
   - Search and filter UI

### Step 3.2: Image Capture & Upload (Day 2-3)
1. **Photo Selection**:
   - Camera integration (UIImagePickerController or PhotosPicker)
   - Photo library access
   - Image optimization (resize, compress)
   - Background removal (Vision framework)

2. **Implement `LiveStorageService`**:
   - Upload images to Supabase Storage (`wardrobe-images` bucket)
   - Generate thumbnails
   - Download images with caching
   - Delete images on item removal

3. **Implement `LiveDatabaseService`**:
   - Generic CRUD operations for any SwiftData model
   - Create, read, update, delete wardrobe items
   - Sync with Supabase database
   - Handle offline operations with `SyncService`

### Step 3.3: Item Details & Editing (Day 4)
1. **Item Detail View**:
   - Display all item properties
   - Show image in full size
   - **Add "Date Added" field** (format: "Added 2 weeks ago")
   - Display wear statistics (times worn, last worn)
   - Edit and delete buttons

2. **Edit Functionality**:
   - Update item properties
   - Change image
   - Category, color, brand, etc.
   - Validation and error handling

### Step 3.4: Testing (Day 5)
1. **Write Comprehensive Tests**:
   - `WardrobeFeatureTests.swift` - Test reducer logic (20+ tests)
   - `StorageServiceTests.swift` - Test image operations
   - `DatabaseServiceTests.swift` - Test CRUD operations
   - Test search and filter functionality
   - Test item creation and editing flows

**Deliverables:**
- ✅ Complete wardrobe CRUD operations
- ✅ Camera and photo library integration
- ✅ Image upload to Supabase Storage
- ✅ Background removal using Vision framework
- ✅ Beautiful grid/list view with search and filters
- ✅ Item detail and edit screens
- ✅ Date Added field on item details
- ✅ Offline support with SwiftData
- ✅ 85%+ test coverage
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

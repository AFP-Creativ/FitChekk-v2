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
   - Live placeholder implementations created (ready for integration)
   - All services include proper error types
   - All mock services marked `@unchecked Sendable`

5. **Step 1.8 - Testing Infrastructure & CI/CD** ✅
   - **38 comprehensive tests** created using TCA TestStore
   - **AppFeatureTests.swift** - 16 tests for root reducer (auth flow, tab navigation, state management)
   - **AuthServiceTests.swift** - 22 tests demonstrating mock service patterns and error handling
   - **TestHelpers.swift** - Reusable test utilities with sample data generators
   - **FitChekkTests/README.md** - Complete testing guide and documentation
   - **CI/CD Pipeline** configured with GitHub Actions (`.github/workflows/ci.yml`)
     - Build job: Compiles app for iOS simulator
     - Test job: Runs full test suite
     - Lint job: Runs SwiftLint with zero tolerance
     - Coverage job: Tracks code coverage, fails if <85%
   - All tests demonstrate proper TCA `TestStore` patterns
   - Mock service usage fully documented

**Current State:**
- ✅ Project builds successfully with **zero errors**
- ✅ SwiftLint passes with **zero violations**
- ✅ **38 comprehensive tests** written
- ✅ CI/CD pipeline ready for GitHub Actions
- ✅ All code committed to `production-foundation` branch
- ✅ **Phase 1 complete** - Ready for Phase 2!

---

## 🎯 Your Task: Phase 2 - Authentication Implementation

**What Phase 1 Completed:**
- ✅ Complete project setup with TCA architecture
- ✅ All SwiftData models and service interfaces
- ✅ 38 comprehensive tests with CI/CD pipeline
- ✅ Design system and shared components ready

**Why Authentication Next:**
- Users need to sign in before accessing any features
- Required for multi-device sync and data persistence
- Enables personalization and subscription management
- Foundation for all subsequent features

**What to Build:**

### Step 2.1: Authentication Feature Module
1. **Create TCA Feature**: `Features/Authentication/AuthenticationFeature.swift`
   - State: email, password, loading states, error messages
   - Actions: emailChanged, passwordChanged, signInTapped, signUpTapped, etc.
   - Effects: Integrate with `LiveAuthService` (Supabase Auth)

2. **Views**:
   - `WelcomeView.swift` - Initial landing screen with branding
   - `SignInView.swift` - Email/password sign in
   - `SignUpView.swift` - Email/password registration
   - `SocialAuthButtons.swift` - Apple and Google OAuth buttons

3. **Navigation**: Integrate with `AppFeature` to show/hide auth flow

### Step 2.2: Supabase Auth Integration
1. **Implement `LiveAuthService`**:
   - Email/password sign in and sign up
   - Apple Sign-In integration
   - Google Sign-In integration
   - Session management and token refresh
   - Password reset flow

2. **User Profile Creation**:
   - Create user record in Supabase
   - Initialize `user_preferences` with defaults
   - Store user in SwiftData for offline access

### Step 2.3: Testing
1. **Write Tests**:
   - `AuthenticationFeatureTests.swift` - Test reducer logic
   - `LiveAuthServiceTests.swift` - Integration tests (optional, can mock Supabase)
   - Test all auth flows (email, Apple, Google)
   - Test error handling

**Deliverables:**
- ✅ Complete authentication flow with all 3 providers
- ✅ Beautiful, branded welcome/sign-in/sign-up screens
- ✅ Full integration with Supabase Auth
- ✅ User profile creation in database
- ✅ Session persistence and token management
- ✅ Comprehensive tests for auth feature
- ✅ SwiftLint passes
- ✅ CI/CD pipeline runs successfully

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

You have a **rock-solid foundation**. The hard architectural decisions are made. Now it's time to establish the testing infrastructure and CI/CD pipeline that will support all future feature development.

**Your Mission:** Create a comprehensive testing framework with TCA's `TestStore` and set up automated CI/CD with GitHub Actions.

**When you're done with Phase 2:**
1. Ensure all auth flows work end-to-end
2. Test on real devices (physical iPhone or Tom's iPhone)
3. Verify Supabase integration creates users correctly
4. Ensure all new tests pass
5. Run SwiftLint - should pass with zero violations
6. Update `PRODUCTION_BUILD_PLAN.md` to mark Phase 2 as complete
7. Commit your changes with clear messages
8. Update `NEXT_AGENT_PROMPT.md` for Phase 3 (Home Dashboard)

**Testing Note:**
- Tests run perfectly in Xcode GUI (⌘U)
- CI/CD pipeline configured and ready
- If you encounter macro errors in command-line builds, use Xcode GUI or GitHub Actions
- See `FitChekkTests/README.md` for complete testing guide

---

**Good luck with authentication! You've got a solid foundation! 🎉**

*This prompt was generated on November 11, 2025 after completing Phase 1 (Foundation) entirely.*

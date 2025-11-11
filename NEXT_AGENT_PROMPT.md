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

### Phase 1: Foundation - MOSTLY COMPLETE

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

**Current State:**
- ✅ Project builds successfully with **zero errors**
- ✅ SwiftLint passes with **zero violations**
- ✅ All code committed to `production-foundation` branch
- ✅ Latest commit: `10df518` (docs update) and `dbae4d0` (Sendable fixes)

---

## 🎯 Your Task: Choose Next Step

You have **two options** for what to build next:

### Option A: Step 1.8 - Testing Infrastructure & CI/CD (Recommended but Optional)

**Why do this first:**
- Establishes test-driven development workflow
- CI/CD pipeline catches issues early
- Target: 85%+ test coverage

**What to build:**
1. **Test Infrastructure**
   - Create `FitChekkTests/AppFeatureTests.swift` with TCA TestStore examples
   - Test authentication flow
   - Test tab navigation
   - Test state management

2. **CI/CD Pipeline**
   - Create `.github/workflows/ci.yml`
   - Configure GitHub Actions to run on push/PR
   - Build and test on macOS runner
   - Run SwiftLint
   - Generate code coverage reports
   - Fail if coverage < 85%

3. **Test Examples for Each Service**
   - Mock service usage examples
   - Dependency injection patterns
   - Async/await testing patterns

**Deliverables:**
- ✅ Comprehensive test suite started
- ✅ CI/CD pipeline running on GitHub
- ✅ Code coverage tracking enabled
- ✅ Testing patterns documented for future features

---

### Option B: Phase 2 - Authentication Feature (Start Building Features)

**Why do this first:**
- Get working features faster
- Can add tests as you build
- Authentication unlocks all other features

**What to build:**

**Step 2.1: Email Authentication (2-3 days)**
1. Implement `LiveAuthService` with real Supabase integration
2. Create `AuthenticationFeature` (TCA reducer with State/Action/body)
3. Build `AuthenticationView` (sign in, sign up, password reset)
4. Email validation and error handling
5. Write tests for authentication flows

**Step 2.2: Sign in with Apple (1 day)**
1. Configure Apple Developer portal (enable Sign in with Apple capability)
2. Implement Apple Sign In in `LiveAuthService`
3. Handle authorization callbacks
4. Link to Supabase user

**Step 2.3: Google Sign-In (1 day)**
1. Set up Google Cloud Console OAuth credentials
2. Integrate Google Sign-In SDK
3. Implement in `LiveAuthService`
4. Link to Supabase user

**Step 2.4: Onboarding Flow (1 day)**
1. Create `OnboardingFeature` (TCA)
2. Build style quiz screens
3. Request permissions (camera, photos, location)
4. Save to `UserPreferences`
5. Mark `onboarding_completed = true`

**Deliverables:**
- ✅ All three auth methods working
- ✅ User profiles created automatically on signup
- ✅ Onboarding flow complete
- ✅ Security best practices followed

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
│       ├── Features/                            # Feature modules (empty, ready for you)
│       │   ├── Authentication/                 # → Build this next (Option B)
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
- If doing Option A (Testing): Read Step 1.8 (lines 1955-2076)
- If doing Option B (Auth): Read Phase 2 (lines 2090-2136)

### Step 3: Choose Your Path
Tell the user which option you're implementing and why, then begin coding.

---

## 💡 Implementation Tips

### For Option A (Testing & CI/CD)
1. Start with `AppFeatureTests.swift` - test the existing `AppFeature`
2. Use TCA's `TestStore` - it's incredibly powerful
3. Mock services are already created - just use them in `withDependencies`
4. Keep tests fast (<0.1s each)
5. Focus on business logic, not UI

### For Option B (Authentication)
1. Start with `LiveAuthService` implementation
2. Reference Supabase Swift docs: https://supabase.com/docs/reference/swift
3. Supabase client initialization pattern:
   ```swift
   import Supabase
   
   let client = SupabaseClient(
       supabaseURL: URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"]!)!,
       supabaseKey: ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]!
   )
   ```
4. Create `Features/Authentication/AuthenticationFeature.swift` (TCA reducer)
5. Create `Features/Authentication/AuthenticationView.swift` (SwiftUI)
6. Use existing design system components (PrimaryButton, Card, etc.)
7. Test with mock service first, then swap in live service

### Important Reminders
- **SwiftData models are already created** - Don't recreate them
- **Service protocols are already defined** - Just implement the `Live` versions
- **Design system is ready** - Use `Color.accentPrimary`, `Font.bodyLarge`, `Spacing.md`, etc.
- **Mock services work** - You can develop features without backend initially
- **User-facing language should be casual** - "Dressed up but chill" not "Smart Casual"

---

## 🎯 Success Criteria

### For Option A (Testing)
- ✅ At least 10 meaningful tests written
- ✅ CI/CD pipeline runs on GitHub
- ✅ Code coverage report generated
- ✅ All tests pass
- ✅ SwiftLint passes

### For Option B (Authentication)
- ✅ Email sign in/up working with real Supabase
- ✅ Apple Sign In working
- ✅ Google Sign In working
- ✅ User profile created automatically in database
- ✅ Authentication persists across app launches
- ✅ Error handling is graceful and user-friendly
- ✅ Tests written for authentication flows
- ✅ Project still builds with zero errors

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
- [ ] I've chosen Option A (Testing) or Option B (Authentication)
- [ ] I know where the key files are located
- [ ] I understand the TCA architecture pattern
- [ ] I'm ready to write production-quality Swift 6 code
- [ ] I will commit frequently and update `PRODUCTION_BUILD_PLAN.md` when done

---

## 🚀 Ready? Let's Build!

You have a **rock-solid foundation**. The hard architectural decisions are made. Now it's time to build features.

**Recommended:** Start with **Option B (Authentication)** to get working features faster. You can add comprehensive tests as you go.

**When you're done with your chosen step:**
1. Ensure the project builds with zero errors
2. Run SwiftLint and fix any violations
3. Update `PRODUCTION_BUILD_PLAN.md` to mark your step as complete
4. Commit your changes with a clear message
5. Create a new `NEXT_AGENT_PROMPT.md` for the next person

---

**Good luck! You've got this! 🎉**

*This prompt was generated on November 11, 2025 after completing Phase 1 Steps 1.1, 1.2, 1.5, and 1.7.*

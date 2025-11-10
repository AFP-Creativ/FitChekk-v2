# UI Mockups - Implementation Guide

## Overview

This branch contains complete UI mockups for all FitChekk screens, structured to make it easy to connect to TCA (The Composable Architecture) reducers later.

## Project Structure

```
FitChekk-v2/
├── Shared/
│   ├── DesignSystem/
│   │   └── DesignSystem.swift          # Colors, typography, spacing, card styles
│   └── Models/
│       └── MockData.swift                # Mock data models and enums
│
├── Features/
│   ├── Home/
│   │   └── HomeView.swift                # Home screen with weather & outfit suggestions
│   ├── Wardrobe/
│   │   ├── WardrobeView.swift            # Wardrobe grid with filtering
│   │   └── ItemDetailView.swift         # Individual item detail screen
│   ├── Outfits/
│   │   ├── OutfitBuilderView.swift       # Create new outfit screen
│   │   └── OutfitDetailView.swift        # Outfit detail with AI reasoning
│   ├── Planner/
│   │   └── PlannerView.swift             # Calendar planner screen
│   ├── Authentication/
│   │   └── WelcomeView.swift             # Welcome/sign-in screen
│   ├── Onboarding/
│   │   └── OnboardingView.swift         # Style quiz onboarding flow
│   └── Settings/
│       └── SettingsView.swift            # Settings screen
│
└── FitChekk_v2App.swift                  # App entry point with tab navigation
```

## Design System

All screens use a shared design system located in `Shared/DesignSystem/DesignSystem.swift`:

- **Colors**: Warm gallery aesthetic with terracotta accent (#C17B6F) and olive logo (#7A8A5F)
- **Typography**: SF Pro system fonts with defined hierarchy
- **Spacing**: 8pt base unit system
- **Card Styles**: Reusable card modifiers with shadows and borders

## Mock Data

Mock data models are in `Shared/Models/MockData.swift`:
- `MockWardrobeItem`: Clothing items with categories, colors, usage stats
- `MockOutfit`: Outfit combinations with AI reasoning
- `MockWeather`: Weather data with forecasts
- `MockUserPreferences`: User style preferences

## TCA Structure Pattern

Each screen follows this pattern for easy TCA integration:

```swift
// 1. State (using @Observable for now, will become @ObservableState)
@Observable
class FeatureState {
    // State properties
}

// 2. Actions (enum, ready for TCA)
enum FeatureAction {
    case onAppear
    case userAction
    // ... more actions
}

// 3. View (using @State for now, will use StoreOf<Feature>)
struct FeatureView: View {
    @State private var state = FeatureState()
    // View implementation
}
```

## How to Connect to TCA

### Step 1: Replace @Observable with TCA Reducer

```swift
// Before:
@Observable
class HomeState { ... }

// After:
@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        // Same properties
    }
    
    enum Action: Equatable {
        // Same actions
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Reducer logic
        }
    }
}
```

### Step 2: Replace @State with StoreOf

```swift
// Before:
@State private var state = HomeState()

// After:
let store: StoreOf<HomeFeature>
```

### Step 3: Connect Actions

```swift
// Before:
Button(action: {}) { ... }

// After:
Button(action: { store.send(.actionName) }) { ... }
```

### Step 4: Replace Mock Data with Real Data

- Replace `MockWardrobeItem` with actual `WardrobeItem` SwiftData model
- Connect to `DatabaseService` for data fetching
- Replace mock weather with `WeatherService` calls
- Connect AI services for categorization and suggestions

## Current Navigation

The app uses a `TabView` with 4 tabs:
1. **Home** - Main screen with daily outfit suggestions
2. **Wardrobe** - Browse and manage clothing items
3. **Planner** - Calendar view for planning outfits
4. **Settings** - User settings and preferences

## Next Steps for Full Integration

1. **Add TCA Dependencies**
   - Add `swift-composable-architecture` package
   - Import `ComposableArchitecture` in feature files

2. **Create Reducers**
   - Convert each `@Observable` state to TCA reducer
   - Implement reducer logic for each action
   - Add dependencies (database, AI, weather services)

3. **Connect Data Layer**
   - Implement SwiftData models
   - Create `DatabaseService` for CRUD operations
   - Set up Supabase sync service

4. **Add Navigation**
   - Replace placeholder navigation with TCA navigation
   - Add `@Presents` for sheet/detail navigation
   - Implement deep linking if needed

5. **Connect AI Services**
   - Implement `CategorizationService` (Gemini)
   - Implement `OutfitService` (Claude)
   - Add loading states and error handling

6. **Add Authentication**
   - Connect Supabase Auth
   - Add auth state management
   - Implement sign-in flows

## Testing the Mockups

1. Open the project in Xcode
2. Run on simulator or device
3. Navigate between tabs to see all screens
4. Interact with UI elements (they won't have functionality yet, but you can see the UI)

## Design Notes

- All screens follow the warm gallery aesthetic from the design system
- Colors are defined in `DesignSystem.swift` for easy theming
- Spacing uses the 8pt grid system
- Cards use consistent styling with shadows and corner radius
- Typography follows iOS Human Interface Guidelines

## Questions?

Refer to:
- `FitChekk-Complete-Specification-Guide/TECHNICAL_ARCHITECTURE.md` for architecture details
- `FitChekk-Complete-Specification-Guide/USER_EXPERIENCE.md` for UX specifications
- `CLAUDE.md` for development guidelines


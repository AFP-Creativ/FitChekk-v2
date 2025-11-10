# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FitChekk is an AI-powered wardrobe management and outfit planning iOS application. The app helps users catalog their clothing, receive AI-powered outfit suggestions based on weather and occasions, and plan outfits using a calendar interface.

**Target Platform**: iOS 17.0+
**Language**: Swift 6.0
**UI Framework**: SwiftUI
**Architecture**: The Composable Architecture (TCA)

## Development Commands

### Building and Running

```bash
# Open project in Xcode
open FitChekk-v2/FitChekk-v2.xcodeproj

# Build for simulator
xcodebuild build -scheme FitChekk-v2 -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Run tests
xcodebuild test -scheme FitChekk-v2 -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -enableCodeCoverage YES
```

### Code Quality

```bash
# Run SwiftLint (once configured)
swiftlint lint --strict

# Auto-fix SwiftLint issues
swiftlint --fix

# Generate code coverage report (once xcov is configured)
xcov --scheme FitChekk-v2 --minimum_coverage_percentage 80
```

## Architecture

### The Composable Architecture (TCA)

All features use TCA for predictable, testable state management. Each feature consists of:

- **State**: `@ObservableState struct State` - All UI state and data
- **Actions**: `enum Action` - All possible user and system actions
- **Reducer**: `var body: some ReducerOf<Self>` - Pure state transformations
- **Dependencies**: Injected via `@Dependency` for testability

**Example Structure**:
```swift
@Reducer
struct WardrobeFeature {
    @ObservableState
    struct State: Equatable {
        var items: [WardrobeItem] = []
        var isLoading = false
        @Presents var detail: DetailFeature.State?
    }

    enum Action: Equatable {
        case onAppear
        case loadItemsResponse(TaskResult<[WardrobeItem]>)
        case detail(PresentationAction<DetailFeature.Action>)
    }

    @Dependency(\.databaseService) var database

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let result = await TaskResult { try await database.fetchItems() }
                    await send(.loadItemsResponse(result))
                }
            // ... other cases
            }
        }
        .ifLet(\.$detail, action: \.detail) {
            DetailFeature()
        }
    }
}
```

### Feature Organization

```
FitChekk/
├── App/                          # App entry point and root state
├── Features/                     # Feature modules (TCA)
│   ├── Wardrobe/
│   │   ├── WardrobeFeature.swift
│   │   ├── WardrobeView.swift
│   │   ├── Components/          # Feature-specific views
│   │   └── Models/              # Feature-specific models
│   ├── Outfits/
│   ├── Planner/
│   ├── Home/
│   └── Settings/
├── Services/                    # Business logic layer
│   ├── AI/                     # Portkey AI integration
│   ├── Data/                   # Supabase database
│   ├── Weather/                # WeatherKit
│   └── Subscription/           # StoreKit 2
└── Shared/                     # Reusable components and utilities
```

**Key Principle**: Group by feature, not by type. Each feature is self-contained with its own reducer, view, components, and models.

### Data Layer

**Local Persistence**: SwiftData (modern Core Data alternative)
- Models use `@Model` macro
- Relationships via `@Relationship` with delete rules
- All models conform to `Codable` for Supabase sync

**Backend**: Supabase (PostgreSQL + Auth + Storage + Realtime)
- Row-Level Security (RLS) enforces user data isolation
- Realtime sync for multi-device support
- Supabase Storage for images (S3-compatible)

**Sync Strategy**: Offline-first
- Local SwiftData is source of truth
- Background sync to Supabase
- `needsSync` flag tracks pending changes

### AI Integration

**Gateway**: Portkey (multi-model AI gateway)
- **Vision Tasks** (categorization): Gemini 2.5 Pro
- **Language Tasks** (outfit suggestions): Claude Sonnet 4
- **Fallbacks**: GPT-4o, Gemini 2.0 Flash
- **Cost Optimization**: Automatic caching (60-80% savings), semantic caching for user context

**Key Services**:
- `CategorizationService`: Analyzes clothing images → attributes (colors, formality, style tags)
- `OutfitService`: Suggests outfits based on wardrobe, weather, preferences, occasion

**Prompt Caching**:
- User wardrobe + preferences cached for 24h (reduces costs)
- Dynamic requests (weather, occasion) sent fresh each time

## Code Standards

### Swift Style

- **Naming**: PascalCase for types, camelCase for functions/variables
- **Booleans**: Prefix with `is`, `has`, `should` (`isLoading`, `hasItems`)
- **Clarity**: Prefer `removeElement(at:)` over `remove(at:)`
- **Line Length**: 120 characters max
- **Function Length**: 60 lines warning, 100 lines error
- **File Length**: 500 lines warning, 1000 lines error

### Error Handling

Define custom error types with `LocalizedError`:
```swift
enum DatabaseError: Error, LocalizedError {
    case notFound
    case connectionFailed

    var errorDescription: String? {
        switch self {
        case .notFound: return "The requested item was not found."
        case .connectionFailed: return "Could not connect to the database."
        }
    }
}
```

Use `TaskResult` for async operations in TCA reducers.

### Async/Await

- Use `async/await` for all I/O operations
- Avoid blocking main thread - use `Task.detached` for heavy computation
- Use `@MainActor` only when necessary (UI updates)

### Documentation

All public APIs require DocC comments:
```swift
/// Brief summary (one line).
///
/// Detailed explanation (multiple paragraphs if needed).
///
/// - Parameters:
///   - item: The item to save
/// - Returns: The saved item with updated metadata
/// - Throws: `DatabaseError` if save fails
///
/// Example:
/// ```swift
/// let saved = try await database.save(item)
/// ```
func save(_ item: WardrobeItem) async throws -> WardrobeItem
```

### Testing Requirements

- **TCA Reducers**: 100% coverage (all actions tested)
- **Services**: 90%+ coverage (all methods + error cases)
- **ViewModels**: 85%+ coverage
- **Views**: UI tests for critical flows only

Use `TestStore` for TCA testing:
```swift
@MainActor
final class WardrobeFeatureTests: XCTestCase {
    func testLoadItemsSuccess() async {
        let store = TestStore(initialState: WardrobeFeature.State()) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = .mock(items: [.mock(name: "Blue Shirt")])
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }

        await store.receive(\.loadItemsResponse.success) {
            $0.isLoading = false
            $0.items = [.mock(name: "Blue Shirt")]
        }
    }
}
```

## Technology Stack

### Core Frameworks
- **SwiftUI**: Declarative UI framework
- **SwiftData**: Modern data persistence (replaces Core Data)
- **Swift Concurrency**: async/await, actors, @MainActor
- **The Composable Architecture**: State management

### Backend & Services
- **Supabase**: PostgreSQL database, Auth (Apple/Google/Email), Storage, Realtime sync
- **Portkey**: AI gateway for multi-model support and cost optimization
- **WeatherKit**: Apple's weather API
- **StoreKit 2**: In-app purchases and subscriptions

### Development Tools
- **SwiftLint**: Code style enforcement
- **XCTest**: Unit and UI testing
- **Instruments**: Performance profiling
- **GitHub Actions**: CI/CD

## AI-Assisted Development

~80% of code will be AI-generated. Best practices:

### Effective Prompting

Always provide:
1. **Context**: "For FitChekk iOS app using TCA + SwiftUI..."
2. **Architecture**: Specify TCA patterns, SwiftData models, etc.
3. **Requirements**: Complete list of features and behaviors
4. **Examples**: Reference similar existing code
5. **Tests**: Request comprehensive test generation

Example:
```
Create a TCA feature WardrobeFeature with:

State:
- items: [WardrobeItem]
- selectedCategory: ItemCategory?
- isLoading: Bool

Actions:
- onAppear, loadItems, filterCategory, selectItem

Dependencies:
- @Dependency(\.databaseService)

Follow TCA patterns, include error handling and logging.
Also generate unit tests using TestStore.
```

### AI Review Workflow

1. AI generates code
2. Human reviews for: correctness, performance, security, accessibility
3. AI refines based on feedback
4. Human approves and integrates

### What to Generate with AI
- ✅ TCA reducers and boilerplate
- ✅ SwiftData models
- ✅ Service implementations
- ✅ Unit tests and mocks
- ✅ DocC documentation

### What Humans Should Do
- ✅ Architecture decisions
- ✅ UX design and polish
- ✅ Complex algorithms
- ✅ Code review
- ✅ Security review

## Security & Privacy

### Critical Requirements

- **Never hardcode secrets**: Use environment variables or xcconfig files
- **Sanitize logs**: Never log user emails, passwords, tokens
- **Validate inputs**: All user input must be validated
- **Use RLS**: Supabase Row-Level Security enforces data isolation
- **On-device processing**: Background removal uses Vision framework (local)
- **User data ownership**: Photos stored in user's iCloud, not our servers

### Image Processing

- iOS 18: On-device background removal via Vision framework
- iOS 17: Manual cropping/editing only (no AI background removal)
- All images optimized before upload (max 2000px width)
- Thumbnails generated for list views (400x400px)

## Premium Features

**Free Tier**:
- Up to 50 wardrobe items
- Manual categorization
- Basic wardrobe browsing
- Weather forecast viewing

**Premium Tier** ($7.99/month or $59.99/year):
- Unlimited wardrobe items
- AI auto-categorization (Gemini)
- AI outfit suggestions with reasoning (Claude)
- Calendar planning and scheduling
- Advanced analytics

## Common Patterns

### Adding a New Feature

1. Create feature directory: `Features/MyFeature/`
2. Create `MyFeature.swift` with TCA reducer
3. Create `MyFeatureView.swift` with SwiftUI view
4. Add components to `Components/` subdirectory
5. Add models to `Models/` subdirectory
6. Create `MyFeatureTests.swift` with comprehensive tests
7. Wire up to `AppFeature` or parent feature

### Calling AI Services

```swift
// Categorization (Gemini)
let attributes = try await categorizationService.categorizeItem(image: imageData)

// Outfit Suggestion (Claude)
let suggestion = try await outfitService.suggestOutfit(
    wardrobeItems: items,
    userPreferences: preferences,
    weather: weather,
    occasion: .casual,
    recentOutfits: recent
)
```

### Supabase Sync

```swift
// Mark item for sync
item.needsSync = true
try await database.updateItem(item)

// Trigger background sync
await syncService.scheduleSync()
```

## Performance Considerations

- Use `LazyVGrid` for item lists (virtualization)
- Use `AsyncImage` for image loading
- Cache AI responses (Portkey handles this automatically)
- Optimize images before storage
- Use `.task` modifier for async operations in views
- Profile with Instruments regularly

## Accessibility

All views must support:
- **VoiceOver**: Add `.accessibilityLabel()` to custom controls
- **Dynamic Type**: Support user font size preferences
- **High Contrast**: Test with Increase Contrast enabled
- **Reduce Motion**: Respect motion preferences

## Resources

### Internal Documentation
- `FitChekk-Complete-Specification/TECHNICAL_ARCHITECTURE.md` - Complete architecture
- `FitChekk-Complete-Specification/AI_DEVELOPMENT_GUIDE.md` - AI development practices
- `FitChekk-Complete-Specification/DEVELOPMENT_STANDARDS.md` - Code standards and testing
- `FitChekk-Complete-Specification/IMPLEMENTATION_ROADMAP.md` - 16-week build plan

### External Resources
- [TCA Documentation](https://pointfreeco.github.io/swift-composable-architecture/)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui/)
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift)

## Current Status

The project is in its initial setup phase. The Xcode project has been created with basic SwiftUI scaffolding. The next steps involve:

1. Setting up project dependencies (TCA, Supabase, etc.)
2. Implementing core architecture (AppFeature, navigation)
3. Building authentication flow
4. Developing core features (Wardrobe, Outfits, Planner)
5. Integrating AI services
6. Implementing monetization (StoreKit 2)
7. Polish and launch preparation

Refer to `IMPLEMENTATION_ROADMAP.md` for the complete 16-week timeline.
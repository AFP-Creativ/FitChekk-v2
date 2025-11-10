# FitChekk - Development Standards

**For**: Engineering Team  
**Read Time**: 10 minutes  
**Last Updated**: November 2025

---

## Overview

These standards ensure code quality, maintainability, and consistency across the codebase.

**Philosophy**: Quality is non-negotiable. Speed comes from doing it right the first time.

---

## Code Style

### Swift Style Guide

**Follow**: [Swift.org API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

**Key Principles**:
1. **Clarity at the point of use** (names should be obvious)
2. **Clarity over brevity** (`removeElement(at:)` not `remove(at:)`)
3. **Omit needless words** (but don't sacrifice clarity)

### Naming Conventions

**Types** (PascalCase):
```swift
struct WardrobeItem { }
class OutfitService { }
enum ItemCategory { }
protocol DatabaseService { }
```

**Functions and Variables** (camelCase):
```swift
func fetchWardrobeItems() -> [WardrobeItem] { }
var selectedCategory: ItemCategory?
let isLoading = false
```

**Constants** (camelCase):
```swift
let maxItemsPerPage = 50
let apiTimeout: TimeInterval = 10.0
```

**Enums** (camelCase for cases):
```swift
enum ItemCategory {
    case tops
    case bottoms
    case dresses
    case outerwear
}
```

**Boolean Names** (isXxx, hasXxx, shouldXxx):
```swift
var isLoading: Bool
var hasItems: Bool
func shouldRefresh() -> Bool
```

---

### File Organization

**Structure**:
```swift
// Imports (grouped by framework)
import SwiftUI
import SwiftData

import ComposableArchitecture // Third-party
import Supabase

// MARK: - Type Definition
struct WardrobeView: View {
    // MARK: - Properties
    @Bindable var store: StoreOf<WardrobeFeature>
    
    // MARK: - Body
    var body: some View {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func loadItems() {
        // Implementation
    }
}

// MARK: - Supporting Types
struct ItemCardView: View {
    // Implementation
}

// MARK: - Preview
#Preview {
    WardrobeView(store: Store(initialState: .init()) {
        WardrobeFeature()
    })
}
```

---

### SwiftLint Configuration

**`.swiftlint.yml`**:
```yaml
disabled_rules:
  - trailing_whitespace # Auto-fixed

opt_in_rules:
  - empty_count # Use isEmpty instead of count == 0
  - explicit_init # Avoid .init(), use Type()
  - force_unwrapping # Warn on !
  - missing_docs # Require docs on public APIs
  - private_outlet # IBOutlets should be private
  
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
```

**Run on every commit**:
```bash
# Pre-commit hook (.git/hooks/pre-commit)
#!/bin/sh
swiftlint lint --strict
if [ $? -ne 0 ]; then
    echo "SwiftLint failed. Fix errors before committing."
    exit 1
fi
```

---

## Architecture Standards

### The Composable Architecture (TCA)

**All features must follow TCA patterns.**

**Feature Template**:
```swift
import ComposableArchitecture

@Reducer
struct MyFeature {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var items: [Item] = []
        var errorMessage: String?
        
        // Child features (presented)
        @Presents var detail: DetailFeature.State?
    }
    
    // MARK: - Actions
    enum Action: Equatable {
        // User actions
        case onAppear
        case itemTapped(Item)
        case refreshButtonTapped
        
        // System actions
        case loadItemsResponse(TaskResult<[Item]>)
        
        // Child actions
        case detail(PresentationAction<DetailFeature.Action>)
    }
    
    // MARK: - Dependencies
    @Dependency(\.databaseService) var database
    @Dependency(\.logger) var logger
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let result = await TaskResult {
                        try await database.fetchItems()
                    }
                    await send(.loadItemsResponse(result))
                }
                
            case let .loadItemsResponse(.success(items)):
                state.isLoading = false
                state.items = items
                logger.info("Loaded \(items.count) items")
                return .none
                
            case let .loadItemsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                logger.error("Failed to load items: \(error)")
                return .none
                
            case let .itemTapped(item):
                state.detail = DetailFeature.State(item: item)
                return .none
                
            case .detail:
                return .none
                
            case .refreshButtonTapped:
                return .send(.onAppear)
            }
        }
        .ifLet(\.$detail, action: \.detail) {
            DetailFeature()
        }
    }
}
```

---

### SwiftUI Best Practices

**1. Extract Views**:
```swift
// ❌ BAD: Monolithic view
struct WardrobeView: View {
    var body: some View {
        ScrollView {
            VStack {
                // 200 lines of UI code...
            }
        }
    }
}

// ✅ GOOD: Composed views
struct WardrobeView: View {
    var body: some View {
        ScrollView {
            VStack {
                HeaderView()
                FiltersView()
                ItemsGridView()
            }
        }
    }
}
```

**2. Use @Bindable Correctly**:
```swift
// ✅ GOOD: For TCA stores
struct WardrobeView: View {
    @Bindable var store: StoreOf<WardrobeFeature>
    
    var body: some View {
        TextField("Search", text: $store.searchQuery.sending(\.searchQueryChanged))
    }
}
```

**3. Avoid View Bloat**:
```swift
// ❌ BAD: Logic in view
struct ItemView: View {
    let item: Item
    
    var body: some View {
        VStack {
            if item.category == .tops && item.colors.contains("blue") && !item.isArchived {
                // Complex conditional UI
            }
        }
    }
}

// ✅ GOOD: Logic in computed property or reducer
var shouldShowSpecialBadge: Bool {
    item.category == .tops && item.colors.contains("blue") && !item.isArchived
}
```

---

## Testing Standards

### Test Coverage Requirements

| Component | Target | Measurement |
|-----------|--------|-------------|
| **TCA Reducers** | 100% | All actions tested |
| **Services** | 90%+ | All methods + error cases |
| **ViewModels** | 85%+ | Business logic |
| **Views** | UI Tests only | Critical flows |

---

### Unit Test Structure

**Template**:
```swift
import XCTest
import ComposableArchitecture
@testable import FitChekk

@MainActor
final class WardrobeFeatureTests: XCTestCase {
    // MARK: - Setup
    var store: TestStore<WardrobeFeature>!
    
    override func setUp() async throws {
        store = TestStore(initialState: WardrobeFeature.State()) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = .mock
            $0.logger = .test
        }
    }
    
    override func tearDown() {
        store = nil
    }
    
    // MARK: - Tests
    func testLoadItemsSuccess() async {
        // Given: Database has items
        let mockItems: [WardrobeItem] = [
            .mock(name: "Blue Shirt"),
            .mock(name: "Black Pants")
        ]
        
        // When: onAppear action
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        // Then: Items loaded
        await store.receive(\.loadItemsResponse.success) {
            $0.isLoading = false
            $0.items = mockItems
        }
    }
    
    func testLoadItemsFailure() async {
        // Given: Database throws error
        store.dependencies.databaseService = .failing
        
        // When: onAppear action
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        // Then: Error handled
        await store.receive(\.loadItemsResponse.failure) {
            $0.isLoading = false
            $0.errorMessage = "Database error"
        }
    }
}
```

---

### Test Naming Convention

**Format**: `test[MethodName][Scenario][ExpectedResult]`

**Examples**:
```swift
func testFetchItems_WhenDatabaseHasData_ReturnsItems() { }
func testFetchItems_WhenDatabaseEmpty_ReturnsEmptyArray() { }
func testFetchItems_WhenDatabaseFails_ThrowsError() { }
```

---

### Mocking Dependencies

**Protocol-Based Mocking**:
```swift
// Protocol
protocol DatabaseService {
    func fetchItems() async throws -> [Item]
}

// Live implementation
struct LiveDatabaseService: DatabaseService {
    func fetchItems() async throws -> [Item] {
        // Real database call
    }
}

// Mock for testing
struct MockDatabaseService: DatabaseService {
    var itemsToReturn: [Item] = []
    var shouldThrowError = false
    
    func fetchItems() async throws -> [Item] {
        if shouldThrowError {
            throw DatabaseError.fetchFailed
        }
        return itemsToReturn
    }
}

// TCA Dependency
extension DatabaseService: DependencyKey {
    static let liveValue: DatabaseService = LiveDatabaseService()
    static let testValue: DatabaseService = MockDatabaseService()
}
```

---

## Documentation Standards

### DocC Comments

**All public APIs must have documentation.**

**Format**:
```swift
/// Brief summary of what this does (one line).
///
/// More detailed explanation if needed (multiple paragraphs okay).
/// Explain what, why, and how.
///
/// - Parameters:
///   - item: The wardrobe item to save
///   - overwrite: Whether to overwrite if exists
/// - Returns: The saved item with updated metadata
/// - Throws: `DatabaseError` if save fails
///
/// Example:
/// ```swift
/// let item = WardrobeItem(name: "Blue Shirt", category: .tops)
/// let saved = try await database.save(item, overwrite: false)
/// print(saved.id) // UUID assigned by database
/// ```
///
/// - Important: This operation is atomic. Either all data saves or none.
/// - Note: Images are saved separately via `StorageService`.
/// - Warning: Large items (>10MB) may take several seconds.
func save(_ item: WardrobeItem, overwrite: Bool = false) async throws -> WardrobeItem {
    // Implementation
}
```

---

### Code Comments

**When to Comment**:
- ✅ WHY, not WHAT (code should be self-explanatory)
- ✅ Complex algorithms
- ✅ Non-obvious optimizations
- ✅ Workarounds for bugs
- ✅ TODOs with context

**Examples**:
```swift
// ✅ GOOD: Explains WHY
// We cache the result for 5 minutes to avoid hitting rate limits
let cached = cache.get(key, maxAge: 300)

// ❌ BAD: Explains WHAT (code is obvious)
// Set isLoading to true
isLoading = true

// ✅ GOOD: Complex logic explained
// Use binary search for O(log n) instead of linear O(n)
// since array is pre-sorted by date
let index = items.binarySearch { $0.date < targetDate }

// ✅ GOOD: TODO with context
// TODO: Refactor to use Combine publisher once iOS 17 is dropped
// (blocked by need to support iOS 16 for next 6 months)
```

---

## Error Handling

### Custom Error Types

**Define Specific Errors**:
```swift
enum DatabaseError: Error, LocalizedError {
    case notFound
    case duplicateKey
    case connectionFailed
    case queryTimeout
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "The requested item was not found."
        case .duplicateKey:
            return "An item with this ID already exists."
        case .connectionFailed:
            return "Could not connect to the database."
        case .queryTimeout:
            return "The database query took too long."
        }
    }
}
```

---

### Error Handling Patterns

**1. Try/Catch for Recoverable Errors**:
```swift
// ✅ GOOD: Proper error handling
do {
    let items = try await database.fetchItems()
    return items
} catch DatabaseError.connectionFailed {
    // Retry logic
    return try await database.fetchItems()
} catch {
    logger.error("Unexpected error: \(error)")
    throw error
}
```

**2. Result Type for API Boundaries**:
```swift
func fetchItems() async -> Result<[Item], DatabaseError> {
    do {
        let items = try await database.query()
        return .success(items)
    } catch let error as DatabaseError {
        return .failure(error)
    } catch {
        return .failure(.queryFailed)
    }
}
```

**3. Optional for Non-Critical Failures**:
```swift
// ✅ GOOD: When nil is acceptable
func parseDate(_ string: String) -> Date? {
    dateFormatter.date(from: string)
}
```

---

### User-Facing Error Messages

**Always user-friendly**:
```swift
// ❌ BAD: Technical error
"NSURLErrorDomain Code=-1001 'Request timeout'"

// ✅ GOOD: User-friendly message
"We couldn't load your items. Please check your internet connection and try again."
```

---

## Performance Standards

### Async/Await Best Practices

**1. Use Async for I/O**:
```swift
// ✅ GOOD: Async for network/database
func fetchItems() async throws -> [Item] {
    try await database.query()
}

// ❌ BAD: Sync for heavy computation on main thread
func processImage(_ image: UIImage) -> UIImage {
    // 5 seconds of image processing on main thread ❌
}

// ✅ GOOD: Async for heavy computation
func processImage(_ image: UIImage) async -> UIImage {
    await Task.detached(priority: .userInitiated) {
        // Image processing on background thread
    }.value
}
```

**2. Avoid Blocking the Main Thread**:
```swift
// ❌ BAD: Blocking main thread
Task { @MainActor in
    let items = await database.fetchItems() // Main thread waits
    self.items = items
}

// ✅ GOOD: Fetch on background, update on main
Task {
    let items = await database.fetchItems() // Background
    await MainActor.run {
        self.items = items // Main thread (quick update)
    }
}
```

---

### Memory Management

**1. Avoid Retain Cycles**:
```swift
// ❌ BAD: Retain cycle
class ViewModel {
    var onUpdate: (() -> Void)?
    
    func setup() {
        onUpdate = {
            self.doSomething() // Strong reference to self
        }
    }
}

// ✅ GOOD: Weak self
class ViewModel {
    var onUpdate: (() -> Void)?
    
    func setup() {
        onUpdate = { [weak self] in
            self?.doSomething()
        }
    }
}
```

**2. Release Large Objects**:
```swift
func processLargeFile() async {
    var largeData = try! Data(contentsOf: fileURL) // 100MB
    
    // Process data...
    
    largeData = Data() // Release memory explicitly
}
```

---

## Security Standards

### Never Hardcode Secrets

```swift
// ❌ BAD
let apiKey = "sk_test_1234567890abcdef"

// ✅ GOOD
let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
```

---

### Sanitize Logs

```swift
// ❌ BAD: Logs user email
logger.info("User logged in: \(user.email)")

// ✅ GOOD: Logs user ID only
logger.info("User logged in: \(user.id)")
```

---

## Git Workflow

### Branch Naming

**Format**: `type/TICKET-number-short-description`

**Examples**:
```
feature/TASK-123-wardrobe-grid
bugfix/BUG-456-crash-on-launch
hotfix/critical-auth-issue
refactor/TASK-789-simplify-reducer
```

---

### Commit Messages

**Format**: [Conventional Commits](https://www.conventionalcommits.org/)

```
type(scope): Brief description

Longer explanation if needed.

Closes #123
```

**Types**: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

**Examples**:
```
feat(wardrobe): Add LazyVGrid for item display

Replaced VGrid with LazyVGrid for better performance with 500+ items.
Measured 60fps scrolling in Instruments.

Closes #123

fix(auth): Handle expired tokens correctly

Previously app crashed if token expired mid-session. Now gracefully
refreshes token or prompts re-login if refresh fails.

Closes #456
```

---

### Pull Request Template

```markdown
## Summary
Brief description of what this PR does.

## Related Ticket
Closes #123

## Changes
- Added WardrobeFeature reducer
- Created WardrobeView with grid layout
- Implemented item filtering by category
- Added unit tests (95% coverage)

## Screenshots/Video
[If UI change, attach screenshot or screen recording]

## Testing
- [ ] Unit tests passing
- [ ] Manually tested on device
- [ ] No linter errors
- [ ] Performance profiled (if applicable)

## Checklist
- [ ] Code follows style guide
- [ ] Tests written
- [ ] Documentation updated
- [ ] No hardcoded secrets
- [ ] Accessibility labels added
```

---

## Continuous Integration

### GitHub Actions Workflow

**`.github/workflows/ci.yml`**:
```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      
      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.2.app
      
      - name: Build
        run: xcodebuild build -scheme FitChekk -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
      
      - name: Test
        run: xcodebuild test -scheme FitChekk -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -enableCodeCoverage YES
      
      - name: Lint
        run: swiftlint lint --strict
      
      - name: Coverage Report
        run: xcov --scheme FitChekk --minimum_coverage_percentage 80
```

**All PRs must pass CI before merging.**

---

## Code Review Checklist

**Before Submitting PR**:
- [ ] Code compiles without warnings
- [ ] Tests pass locally
- [ ] SwiftLint passes
- [ ] Manually tested on device
- [ ] Documentation updated
- [ ] No debug code (print statements, test data)

**Reviewer Checks**:
- [ ] Functionality correct
- [ ] Tests adequate
- [ ] Architecture follows TCA patterns
- [ ] Performance acceptable
- [ ] Security considerations addressed
- [ ] Accessibility supported
- [ ] Code readable and maintainable

---

## Resources

### Internal
- [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md) - Architecture details
- [AI_DEVELOPMENT_GUIDE.md](./AI_DEVELOPMENT_GUIDE.md) - Using AI for development
- [QUALITY_STANDARDS.md](./QUALITY_STANDARDS.md) - Quality benchmarks

### External
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [TCA Documentation](https://pointfreeco.github.io/swift-composable-architecture/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui/)

---

## Conclusion

**Standards exist to make our lives easier, not harder.**

When in doubt:
1. Write clear, readable code
2. Test thoroughly
3. Document complex logic
4. Ask for code review
5. Learn from feedback

---

**Last Updated**: November 2025  
**Document Version**: 1.0


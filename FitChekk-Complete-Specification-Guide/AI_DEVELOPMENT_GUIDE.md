# FitChekk - AI Development Guide

**For**: Engineering Team, AI Engineers  
**Read Time**: 15 minutes  
**Last Updated**: November 2025

---

## Overview

**80% of FitChekk's code will be AI-generated.** This document explains how to leverage AI effectively for maximum productivity while maintaining high code quality.

---

## Why AI-Assisted Development?

### The Advantage

**Traditional Development**:
- 1 engineer × 40 hours/week = 40 productive hours
- 50% coding, 50% thinking/debugging = 20 hours actual coding
- Result: ~2,000 lines of quality code per week

**AI-Assisted Development**:
- 1 engineer + AI pair programmer = 40 productive hours
- AI generates boilerplate, engineer reviews/refines = 80%+ time saved on repetitive code
- **Result: ~5,000-8,000 lines of quality code per week (2.5-4x faster)**

### What AI Excels At

✅ **Boilerplate Code**: SwiftData models, TCA reducers, API clients
✅ **Repetitive Patterns**: CRUD operations, networking, UI components
✅ **Test Generation**: Unit tests, mock data, fixtures
✅ **Documentation**: DocC comments, API documentation
✅ **Refactoring**: Moving from one pattern to another
✅ **Bug Fixes**: Common issues with clear error messages

### What Humans Excel At

✅ **Architecture Decisions**: Choosing TCA, Supabase, Portkey
✅ **UX Design**: User flows, interaction patterns
✅ **Complex Logic**: Outfit suggestion algorithms, caching strategies
✅ **Code Review**: Ensuring AI output is correct and maintainable
✅ **Creative Problem Solving**: Novel approaches to hard problems

---

## AI Tools We Use

### Primary: Cursor/Claude

**Why Cursor**:
- Best code completion (understands project context)
- Multi-file editing (refactor across files)
- Composer feature (architect features with AI)
- Built on Claude Sonnet 4 (best coding AI)

**Setup**:
```bash
# Install Cursor
brew install --cask cursor

# Open project
cd FitChekk
cursor .

# Configure .cursorrules
cat > .cursorrules << EOF
You are an expert Swift and SwiftUI developer working on FitChekk, an AI-powered wardrobe management iOS app.

Architecture:
- Use The Composable Architecture (TCA) for all features
- SwiftUI for all UI
- SwiftData for data persistence
- Supabase for backend
- Swift 6 with strict concurrency

Code Style:
- Use async/await for all asynchronous code
- Follow Swift API design guidelines
- Write comprehensive DocC comments for public APIs
- Use descriptive variable names
- Prefer composition over inheritance

Testing:
- Write unit tests for all reducers
- Use TestStore for TCA testing
- Mock dependencies in tests
- Aim for 80%+ code coverage

File Organization:
- Group by feature (not by type)
- Each feature has: Feature.swift, View.swift, Components/
- Models in Features/[Feature]/Models/
- Shared code in Shared/

Always:
- Generate complete, working code (not placeholders)
- Include proper error handling
- Add logging for debugging
- Consider performance implications
- Think about accessibility
EOF
```

### Secondary: GitHub Copilot

**Why Copilot**:
- Excellent inline suggestions
- Fast auto-complete
- Good for common patterns

**Use For**:
- Quick function implementations
- Common SwiftUI patterns
- Test data generation

### Tertiary: ChatGPT-4/Claude for Consultation

**Use For**:
- Architectural discussions
- Algorithm design
- Complex debugging
- Documentation writing

---

## Effective Prompting

### 1. Provide Context

**❌ Bad Prompt**:
```
Create a wardrobe item model
```

**✅ Good Prompt**:
```
Create a SwiftData model for WardrobeItem with the following requirements:

Context:
- This is for FitChekk, an AI wardrobe management app
- We use SwiftData (not Core Data)
- Data syncs to Supabase PostgreSQL

Requirements:
- Properties: id (UUID), name (String?), category (enum), subCategory (enum), images (URLs), AI attributes (colors, formality, etc.), usage stats
- Relationships: many-to-many with Outfit
- Support for JSON serialization (for Supabase sync)
- Computed property for filtered display

Make sure to:
- Use @Model macro
- Include proper @Attribute and @Relationship annotations
- Add DocC comments
- Make it Codable for API sync
```

### 2. Specify Architecture

**❌ Bad Prompt**:
```
Make a view to show wardrobe items
```

**✅ Good Prompt**:
```
Create a WardrobeFeature using The Composable Architecture:

Architecture:
- Use TCA's @Reducer and @ObservableState
- State should include: items array, loading bool, selected category filter
- Actions: load items, filter by category, select item, add item
- Dependencies: DatabaseService for fetching items
- Child features: AddItemFeature (presented sheet), ItemDetailFeature (presented sheet)

View:
- LazyVGrid with adaptive columns (min 160pt)
- Category filter bar at top
- Each item shows thumbnail, name, category
- Tap item → shows ItemDetailView sheet
- Pull to refresh
- Empty state when no items

Follow TCA best practices:
- Use .run for async side effects
- Use TaskResult for async/throws
- Child features use .ifLet and @Presents
- Proper dependency injection
```

### 3. Include Examples

**✅ Excellent Prompt with Example**:
```
Create an OutfitService that calls Portkey AI gateway to get outfit suggestions.

Reference implementation (ImageService):
```swift
final class ImageService {
    private let gateway: AIGateway
    
    func analyze(image: Data) async throws -> Analysis {
        let prompt = buildPrompt()
        return try await gateway.callVisionModel(
            image: image,
            prompt: prompt,
            cacheKey: nil
        )
    }
    
    private func buildPrompt() -> String {
        "Analyze this image..."
    }
}
```

Follow same pattern but:
- Call callLanguageModel (not callVisionModel)
- Build cached context (wardrobe + preferences)
- Build dynamic request (weather + occasion)
- Use cacheKey for cost optimization
- Return OutfitSuggestion struct
```

### 4. Request Tests

**✅ Always Include**:
```
Also generate comprehensive unit tests using XCTest and TCA's TestStore.

Test cases:
- Loading items successfully
- Loading items with error
- Filtering by category
- Toggling favorite
- Deleting item
- Child feature presentation

Use mock dependencies.
```

---

## Development Workflow

### Feature Development Cycle

```
1. Architect (Human)
   ↓
   "I need a wardrobe management feature with..."
   
2. Generate (AI)
   ↓
   AI creates: Feature.swift, View.swift, Models/, Tests/
   
3. Review (Human)
   ↓
   Check: Architecture, logic, edge cases, performance
   
4. Refine (AI + Human)
   ↓
   Fix issues, improve implementation
   
5. Test (AI + Human)
   ↓
   AI generates tests, human adds edge cases
   
6. Integrate (Human)
   ↓
   Connect to app, verify flow
```

### Example: Adding Wardrobe Feature

#### Step 1: Architect (Human)

```
I need to create the wardrobe management feature.

Requirements:
- Users can view all wardrobe items in a grid
- Filter by category and subcategory
- Search by name
- Tap item to see details
- Add new items via camera/photo library
- AI categorization for premium users
- Sync with Supabase

Architecture decisions:
- Use TCA for state management
- Separate Feature, View, Components
- SwiftData models
- Service layer for AI and database
- Testing with TestStore
```

#### Step 2: Generate Feature (AI)

**Prompt to Cursor**:
```
Create a complete WardrobeFeature using TCA with the following structure:

# WardrobeFeature.swift

Requirements:
- State: items array, selectedCategory, selectedSubCategory, searchQuery, isLoading, error
- Actions: onAppear, loadItems, filterCategory, search, selectItem, addItem, toggleFavorite, deleteItem
- Child features: AddItemFeature (sheet), ItemDetailFeature (sheet)
- Dependencies: @Dependency(\.databaseService), @Dependency(\.logger)
- Computed property: filteredItems (applies filters)

Follow TCA patterns:
- Use @Reducer and @ObservableState
- Side effects in .run blocks
- TaskResult for async throws
- .ifLet for child features
- Proper dependency injection

Generate complete code with:
- All actions implemented
- Proper error handling
- Logging at key points
- DocC comments
- No placeholders or TODO comments
```

**AI generates**:
```swift
import ComposableArchitecture
import SwiftData

/// Manages the wardrobe items collection, filtering, and interactions
@Reducer
struct WardrobeFeature {
    /// The state representing the wardrobe screen
    @ObservableState
    struct State: Equatable {
        var items: [WardrobeItem] = []
        // ... (AI generates complete state)
    }
    
    /// All actions that can occur in the wardrobe feature
    enum Action: Equatable {
        // ... (AI generates complete actions)
    }
    
    @Dependency(\.databaseService) var database
    @Dependency(\.logger) var logger
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // ... (AI generates complete reducer)
        }
        .ifLet(\.$addItem, action: \.addItem) {
            AddItemFeature()
        }
        .ifLet(\.$itemDetail, action: \.itemDetail) {
            ItemDetailFeature()
        }
    }
}
```

#### Step 3: Review (Human)

**Checklist**:
- ✅ Follows TCA patterns correctly?
- ✅ Proper error handling?
- ✅ Efficient (not reloading everything on every change)?
- ✅ Accessible (VoiceOver labels)?
- ✅ Correct dependency injection?
- ❌ **Issue found**: Filtering happens in reducer (should be computed property)

#### Step 4: Refine (AI + Human)

**Prompt**:
```
The filtering logic should be a computed property on State, not in the reducer.

Move filter logic to:
var filteredItems: [WardrobeItem] {
    // Filter by category, subcategory, search
    // Sort by created date
}

Remove filter-related code from reducer actions.
```

AI refactors, human verifies.

#### Step 5: Test (AI)

**Prompt**:
```
Generate comprehensive unit tests for WardrobeFeature using XCTest and TestStore.

Test cases:
1. testLoadItemsSuccess - loads items from database
2. testLoadItemsFailure - handles database error
3. testCategoryFilter - filters by category
4. testSubCategoryFilter - filters by subcategory  
5. testSearchQuery - searches by name
6. testToggleFavorite - updates favorite status
7. testDeleteItem - removes item
8. testAddItemPresentation - presents AddItemFeature
9. testItemDetailPresentation - presents ItemDetailFeature
10. testFilterCombinations - multiple filters at once

Use mock dependencies for DatabaseService and Logger.
Include setup and teardown.
Follow TCA testing best practices with TestStore.
```

AI generates complete test suite.

#### Step 6: Integrate (Human)

- Add to AppFeature
- Wire up navigation
- Test on device
- Fix any integration issues

---

## Code Generation Patterns

### 1. SwiftData Models

**Prompt Template**:
```
Create a SwiftData model for [ModelName] with:

Properties:
- [List all properties with types]

Relationships:
- [Describe relationships]

Requirements:
- Use @Model macro
- Proper @Attribute annotations
- @Relationship with delete rules
- Codable for API sync
- DocC comments
- Helper methods for [specific needs]

Example property:
@Attribute(.unique) var id: UUID
```

### 2. TCA Features

**Prompt Template**:
```
Create a TCA feature [FeatureName] with:

State:
- [List state properties]
- [List computed properties]

Actions:
- User actions: [list]
- System actions: [list]
- Child actions: [list]

Dependencies:
- [List dependencies]

Child Features:
- [List child features with presentation style]

Behavior:
- [Describe key behaviors]

Follow TCA patterns, include proper error handling and logging.
```

### 3. Services

**Prompt Template**:
```
Create a service [ServiceName] that:

Purpose: [What it does]

Methods:
- [Method signatures and descriptions]

Dependencies:
- [What it depends on]

Error Handling:
- [Expected errors]

Example:
[Provide similar service as reference]

Requirements:
- Async/await
- Proper error types
- Logging
- Testable (uses protocols/dependencies)
- DocC comments
```

### 4. Views

**Prompt Template**:
```
Create a SwiftUI view [ViewName] for:

Store: StoreOf<[FeatureName]>

Layout:
- [Describe layout structure]

Components:
- [List sub-components]

Interactions:
- [User interactions and actions]

States:
- Loading: [behavior]
- Empty: [behavior]  
- Error: [behavior]
- Content: [behavior]

Accessibility:
- VoiceOver labels
- Dynamic Type support
- High contrast support

Follow SwiftUI best practices, use @Bindable for store.
```

---

## Common Pitfalls & Solutions

### Pitfall 1: AI Generates Placeholder Code

**Problem**:
```swift
func loadItems() async throws -> [WardrobeItem] {
    // TODO: Implement database fetch
    return []
}
```

**Solution**:
Add to prompt: "Generate complete, working code. No placeholders, no TODOs. If you don't know something, ask me."

---

### Pitfall 2: AI Doesn't Follow Project Architecture

**Problem**:
AI generates UIKit when project uses SwiftUI, or uses wrong state management.

**Solution**:
- Use `.cursorrules` file (shown above)
- Start every prompt with context: "For FitChekk iOS app using TCA + SwiftUI..."
- Provide example code from existing features

---

### Pitfall 3: AI Generates Non-Compiling Code

**Problem**:
Missing imports, wrong types, undefined methods.

**Solution**:
- Give AI access to existing code: "Reference existing [FileName].swift"
- Specify Swift version: "Use Swift 6 with strict concurrency"
- Provide type definitions: "WardrobeItem is a SwiftData @Model with..."

---

### Pitfall 4: AI Generates Insecure Code

**Problem**:
Hardcoded API keys, no input validation, SQL injection risks.

**Solution**:
- Add to prompts: "Ensure security: no hardcoded secrets, validate all inputs, use parameterized queries"
- Human review all AI-generated code touching sensitive data
- Use automated security scanning (see Testing Strategy)

---

### Pitfall 5: AI Generates Inefficient Code

**Problem**:
N+1 queries, loading all data at once, no caching.

**Solution**:
- Specify performance requirements: "Fetch items in batches of 50", "Use LazyVGrid", "Cache results for 5 minutes"
- Profile AI-generated code with Instruments
- Human review for obvious inefficiencies

---

## AI-Generated Tests

### Test Generation Workflow

**1. Generate Happy Path**:
```
Generate unit test for WardrobeFeature.testLoadItemsSuccess:

Scenario:
- Initial state: empty items
- Action: .onAppear
- Expected: isLoading = true, then items loaded

Use TestStore with mock DatabaseService returning 3 items.
```

**2. Generate Edge Cases** (Human defines, AI implements):
```
Generate tests for edge cases:

1. testLoadItemsEmpty - database returns empty array
2. testLoadItemsNetworkError - database throws network error
3. testFilterWithNoResults - filter returns no items
4. testDeleteLastItem - deleting last item in list
5. testConcurrentActions - multiple actions in rapid succession

Use same TestStore pattern.
```

**3. Review & Enhance** (Human):
- Verify assertions are correct
- Add performance tests if needed
- Add UI tests for critical flows

### Example: AI-Generated Test

**Prompt**:
```
Generate unit test for OutfitService.suggestOutfit method.

Test: testSuggestOutfitSuccess

Setup:
- Mock AIGateway that returns valid JSON response
- 10 wardrobe items with variety of categories
- User preferences: minimalist style, navy/white colors
- Weather: 72°F, sunny
- No recent outfits

Expected:
- Suggestion includes 3+ items (top, bottom, shoes minimum)
- Reasoning is non-empty
- styleScore > 0.8
- weatherAppropriate = true
- items exist in wardrobe

Use XCTest async/await patterns.
```

**AI Generates**:
```swift
final class OutfitServiceTests: XCTestCase {
    func testSuggestOutfitSuccess() async throws {
        // Setup mock gateway
        let mockGateway = MockAIGateway(
            mockResponse: """
            {
              "outfit": {
                "items": [
                  {"itemId": "item-1", "category": "tops", "role": "primary_top"},
                  {"itemId": "item-2", "category": "bottoms", "role": "bottom"},
                  {"itemId": "item-3", "category": "footwear", "role": "shoes"}
                ],
                "reasoning": "This outfit combines...",
                "styleScore": 0.94,
                "weatherAppropriate": true
              },
              "alternatives": []
            }
            """
        )
        
        let service = OutfitService(gateway: mockGateway, logger: .test)
        
        // Create test data
        let wardrobeItems = [
            WardrobeItem.mock(id: "item-1", category: .tops),
            WardrobeItem.mock(id: "item-2", category: .bottoms),
            WardrobeItem.mock(id: "item-3", category: .footwear),
            // ... 7 more items
        ]
        
        let preferences = UserPreferences.mock(
            stylePreferences: ["minimalist"],
            favoriteColors: ["navy", "white"]
        )
        
        let weather = WeatherSnapshot(
            date: Date(),
            tempHigh: 72,
            tempLow: 58,
            condition: "Sunny",
            feelsLike: 70,
            humidity: 45
        )
        
        // Execute
        let suggestion = try await service.suggestOutfit(
            wardrobeItems: wardrobeItems,
            userPreferences: preferences,
            weather: weather,
            occasion: .casual,
            recentOutfits: []
        )
        
        // Verify
        XCTAssertGreaterThanOrEqual(suggestion.outfit.items.count, 3)
        XCTAssertFalse(suggestion.outfit.reasoning.isEmpty)
        XCTAssertGreaterThan(suggestion.outfit.styleScore, 0.8)
        XCTAssertTrue(suggestion.outfit.weatherAppropriate)
        
        // Verify items exist in wardrobe
        let itemIds = wardrobeItems.map(\.id)
        for item in suggestion.outfit.items {
            XCTAssertTrue(itemIds.contains(item.itemId))
        }
    }
}
```

Human reviews and approves.

---

## Performance Optimization with AI

### Pattern: AI-Assisted Profiling

**Workflow**:
1. **Profile** app with Instruments
2. **Identify** bottleneck
3. **Ask AI** for optimization

**Example**:

**Human**: Instruments shows `WardrobeView` is slow when scrolling with 500+ items.

**Prompt to AI**:
```
WardrobeView is slow when scrolling with 500+ items.

Current implementation:
[Paste current code]

Profiling shows:
- Main thread blocking on image loading
- Views are recreated on every scroll
- No virtualization

Optimize for:
- Smooth 60fps scrolling
- Lazy loading images
- View reuse
- Proper LazyVGrid usage

Provide optimized implementation with explanations.
```

**AI provides**:
```swift
struct WardrobeView: View {
    @Bindable var store: StoreOf<WardrobeFeature>
    
    var body: some View {
        ScrollView {
            // Use LazyVGrid for virtualization (only renders visible items)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)]) {
                ForEach(store.filteredItems) { item in
                    ItemCardView(item: item)
                        .id(item.id) // Stable identity for view reuse
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ItemCardView: View {
    let item: WardrobeItem
    
    var body: some View {
        VStack {
            // AsyncImage loads images asynchronously off main thread
            AsyncImage(url: item.thumbnailURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 160, height: 160)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 160)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 160, height: 160)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(item.name ?? "Unnamed")
                .font(.caption)
                .lineLimit(1)
        }
    }
}

// Optimizations made:
// 1. LazyVGrid only renders visible items (not all 500+)
// 2. AsyncImage loads off main thread
// 3. .id() provides stable identity for view reuse
// 4. Thumbnails used instead of full-size images
// 5. Simple view structure (no unnecessary state)
```

Human tests, verifies improvement, commits.

---

## Documentation with AI

### DocC Comment Generation

**Prompt**:
```
Add comprehensive DocC comments to this code:

[Paste code]

Include:
- Summary (1 sentence)
- Discussion (1-2 paragraphs explaining what/why/how)
- Parameters (all params with descriptions)
- Returns (what's returned)
- Throws (possible errors)
- Example usage (code snippet)

Follow Apple's DocC formatting guidelines.
```

**AI generates proper DocC**:
```swift
/// Suggests an outfit based on wardrobe items, user preferences, and current weather.
///
/// This method uses AI (Claude Sonnet 4 via Portkey) to analyze the user's wardrobe
/// and generate intelligent outfit suggestions. It considers multiple factors including
/// weather conditions, user style preferences, recently worn items, and the occasion.
///
/// The method employs prompt caching to reduce API costs. The user's wardrobe and
/// preferences are cached for 24 hours, while weather and occasion are sent as a
/// dynamic request each time.
///
/// - Parameters:
///   - wardrobeItems: All items in the user's wardrobe to consider
///   - userPreferences: User's style preferences, favorite colors, and lifestyle
///   - weather: Current and forecasted weather conditions
///   - occasion: The occasion/context for the outfit (work, casual, date, etc.)
///   - recentOutfits: Outfits worn in the last 7-14 days (to avoid repetition)
///
/// - Returns: An `OutfitSuggestion` containing the suggested outfit, reasoning,
///   style score, and alternative item options
///
/// - Throws:
///   - `AIError.invalidResponse` if the AI response is malformed
///   - `AIError.requestFailed` if the API call fails
///   - `DecodingError` if the response JSON doesn't match expected structure
///
/// Example:
/// ```swift
/// let suggestion = try await outfitService.suggestOutfit(
///     wardrobeItems: user.wardrobeItems,
///     userPreferences: user.preferences,
///     weather: currentWeather,
///     occasion: .work,
///     recentOutfits: recentOutfits
/// )
/// print(suggestion.outfit.reasoning) // "This outfit combines..."
/// ```
///
/// - Important: This is a Premium-only feature. Ensure user has active subscription
///   before calling this method.
///
/// - Note: Average response time is 1-2 seconds with caching enabled, 3-5 seconds
///   on first call of the day (cache miss).
func suggestOutfit(
    wardrobeItems: [WardrobeItem],
    userPreferences: UserPreferences,
    weather: WeatherSnapshot,
    occasion: OccasionType?,
    recentOutfits: [Outfit]
) async throws -> OutfitSuggestion {
    // ... implementation
}
```

---

## AI Code Review

### Using AI as First Reviewer

**Before Human Code Review**:
1. Run AI review
2. Fix obvious issues
3. Then send to human reviewer

**Prompt for AI Review**:
```
Review this code for:

1. Correctness: Does it work as intended?
2. Performance: Any inefficiencies?
3. Security: Any vulnerabilities?
4. Best Practices: Follow Swift/iOS conventions?
5. Readability: Is it clear and maintainable?
6. Testing: Are edge cases handled?
7. Accessibility: VoiceOver, Dynamic Type support?

Code:
[Paste code]

Provide specific issues with line numbers and suggested fixes.
```

**AI Response**:
```
Code Review for WardrobeFeature.swift:

✅ Correctness: Logic appears sound

⚠️  Performance Issues:
Line 45: `state.items.filter { ... }` runs on every action
Suggestion: Move to computed property on State

❌ Security Issue:
Line 78: Direct string interpolation in log message may leak user data
Suggestion: Sanitize before logging: logger.info("Loaded \(items.count) items")

✅ Best Practices: Follows TCA patterns correctly

⚠️  Readability:
Line 92-110: Reduce block is too long (18 lines)
Suggestion: Extract logic to helper methods

✅ Testing: Edge cases handled

⚠️  Accessibility:
Line 156: ItemCardView missing .accessibilityLabel
Suggestion: Add .accessibilityLabel("\(item.name), \(item.category)")
```

Human addresses issues, then sends to human reviewer.

---

## Measuring AI Productivity

### Metrics to Track

**Code Generation**:
- Lines of code per day: Expect 2-4x increase
- Features completed per sprint: 1.5-2x increase
- Time to first working prototype: 50-70% reduction

**Code Quality** (should not decrease):
- Test coverage: Maintain 80%+
- Bug rate: No increase
- Code review feedback: Similar or better

**Developer Experience**:
- Less time on boilerplate: 80%+ reduction
- More time on creative work: 2x increase
- Context switching: Reduced (AI helps maintain focus)

### Weekly Tracking

Create a weekly log:
```markdown
# Week of Jan 15-19, 2025

## AI-Generated Code
- WardrobeFeature: 800 lines (AI 90%, Human 10%)
- OutfitService: 300 lines (AI 85%, Human 15%)
- Unit Tests: 600 lines (AI 95%, Human 5%)

Total: 1,700 lines (AI-assisted)

## Human-Only Code
- Architecture decisions: AppFeature routing
- Complex algorithms: Outfit matching logic
- UX polish: Animations, transitions

Total: 300 lines (Human-only)

## Productivity Gain
- Traditional estimate: 5 days for these features
- Actual with AI: 2 days
- **Speedup: 2.5x**

## Quality Metrics
- Tests passing: 100%
- Code review issues: 3 minor (same as usual)
- Bugs found: 0
- Coverage: 85%
```

---

## Best Practices Summary

### Do's ✅

1. **Provide rich context** in every prompt
2. **Use examples** from existing code
3. **Generate tests** alongside implementation
4. **Review all AI code** thoroughly
5. **Iterate** with AI (refine, don't start over)
6. **Document** AI-generated code
7. **Profile** AI-generated code for performance
8. **Track metrics** to measure productivity gains

### Don'ts ❌

1. **Don't trust blindly** - always review AI output
2. **Don't skip tests** - AI can generate them easily
3. **Don't accept placeholders** - demand complete code
4. **Don't ignore warnings** - address linter/compiler issues
5. **Don't over-engineer** - AI tends to be verbose, simplify
6. **Don't forget security** - review auth, API keys, data handling
7. **Don't skip profiling** - AI may generate inefficient code
8. **Don't lose sight of UX** - AI is great at code, not design

---

## Conclusion

**AI is a force multiplier, not a replacement.**

The best results come from:
- **Humans**: Architecture, UX, creative problem-solving, review
- **AI**: Implementation, boilerplate, tests, documentation, refactoring

Together, we can build FitChekk 2-4x faster while maintaining (or improving) code quality.

---

**Next Steps**:
1. Set up Cursor with `.cursorrules`
2. Read [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) to see AI-assisted workflow in action
3. Start with a small feature to get comfortable with AI pair programming

---

**Last Updated**: November 2025  
**Document Version**: 1.0


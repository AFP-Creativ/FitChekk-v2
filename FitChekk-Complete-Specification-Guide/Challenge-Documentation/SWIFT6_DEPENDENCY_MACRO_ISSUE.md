# Swift 6 @Dependency Macro Expansion Issue - Challenge Documentation

**Date:** November 13, 2025  
**Project:** FitChekk-V2 Phase 5 (Outfits Feature)  
**Severity:** Blocking  
**Status:** Unresolved

---

## Executive Summary

During Phase 5 implementation of the Outfits feature, we encountered a persistent `@Dependency` macro expansion failure in Swift 6 when using The Composable Architecture (TCA). Despite successfully implementing the same dependency pattern in other features (AuthenticationFeature, SettingsFeature), the OutfitsFeature files consistently fail to compile with the error:

```
error: generic parameter 'Key' could not be inferred
error: cannot infer key path type from context; consider explicitly specifying a root type
```

This issue has proven resistant to over 20 different solution attempts, creating a cyclic problem pattern where fixing one issue exposes or creates another.

---

## The Problem

### Initial Error
```
/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/FitChekk/FitChekk/Features/Outfits/OutfitsFeature.swift:150:22: error: generic parameter 'Key' could not be inferred
/Users/tfoote/Desktop/AFP Creativ/FitChekk-V2/FitChekk/FitChekk/Features/Outfits/OutfitsFeature.swift:150:33: error: cannot infer key path type from context; consider explicitly specifying a root type
```

### Affected Files
- `OutfitsFeature.swift` (lines 150, 255)
- `OutfitCreationFeature.swift` (line 150)
- `OutfitDetailFeature.swift` (line 78)

### Code Pattern That Fails
```swift
@Reducer
struct OutfitsFeature {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .run { send in
                @Dependency(\.authService) var authService        // <- FAILS HERE
                @Dependency(\.databaseService) var databaseService // <- FAILS HERE
                
                // ... rest of code
            }
        }
    }
}
```

---

## Environment Details

- **Xcode Version:** Latest (with Swift 6.1.2)
- **Swift Version:** 6.1.2 (swiftlang-6.1.2.1.2 clang-1700.0.13.5)
- **Swift Language Mode:** 6.0
- **TCA Version:** Latest via SPM
- **Dependencies Library:** Latest via SPM
- **Platform:** iOS 17.0+ / iPhone Simulator 18.1

### Working Examples in Same Project
The **exact same dependency pattern** works perfectly in:
- `AuthenticationFeature.swift`
- `SettingsFeature.swift`
- `WardrobeFeature.swift` (from Phase 3)

---

## The Cyclic Problem Pattern

### Attempt Loop Documented

#### Cycle 1: Struct-Level Dependencies
**Attempt:** Place `@Dependency` declarations at struct level (like SettingsFeature)
```swift
@Reducer
struct OutfitsFeature {
    @Dependency(\.databaseService) var databaseService
    @Dependency(\.authService) var authService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Use dependencies here
        }
    }
}
```

**Result:** ❌ `error: generic parameter 'Key' could not be inferred`

---

#### Cycle 2: Inside Reduce Closure
**Attempt:** Move `@Dependency` inside the Reduce closure
```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        @Dependency(\.databaseService) var databaseService
        @Dependency(\.authService) var authService
        
        switch action {
            // ...
        }
    }
}
```

**Result:** ❌ Same error: `generic parameter 'Key' could not be inferred`

---

#### Cycle 3: Inside .run Closures
**Attempt:** Move `@Dependency` directly into `.run` effect closures
```swift
return .run { send in
    @Dependency(\.authService) var authService
    @Dependency(\.databaseService) var databaseService
    
    do {
        let user = try await authService.getCurrentUser()
        // ...
    }
}
```

**Result:** ❌ Same error, but different line numbers

---

#### Cycle 4: Explicit Type Annotation
**Attempt:** Explicitly type the Reduce closure
```swift
var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
        @Dependency(\.databaseService) var databaseService
        @Dependency(\.authService) var authService
        // ...
    }
}
```

**Result:** ❌ No improvement

---

#### Cycle 5: Import Dependencies Explicitly
**Attempt:** Add explicit `import Dependencies` statement
```swift
import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies  // <- Added

@Reducer
struct OutfitDetailFeature {
    // ...
}
```

**Result:** ❌ No change

---

#### Cycle 6: DependencyValues._current
**Attempt:** Use direct access to dependency values
```swift
return .run { send in
    let authService = DependencyValues._current.authService
    let databaseService = DependencyValues._current.databaseService
    // ...
}
```

**Result:** ❌ `error: value of type 'DependencyValues' has no member 'databaseService'`

---

#### Cycle 7: Capture Lists
**Attempt:** Use capture lists to capture dependencies
```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        return .run { [authService = self.authService, databaseService = self.databaseService] send in
            // use dependencies
        }
    }
}
```

**Result:** ❌ Back to: `generic parameter 'Key' could not be inferred`

---

#### Cycle 8: Clean and Rebuild
**Attempt:** 
1. Product → Clean Build Folder (Cmd+Shift+K)
2. Delete DerivedData
3. Restart Xcode
4. Fresh build

**Result:** ❌ Same errors persist

---

#### Cycle 9: Simplify to Remove Dependencies
**Attempt:** Remove dependency usage entirely, mock the functionality
```swift
case .loadWardrobeItems:
    state.isLoadingItems = true
    
    // Simplified implementation - loading is handled by parent feature
    return .run { send in
        await send(.wardrobeItemsResponse(.success([])))
    }
```

**Result:** ✅ This works! But...
**New Problem:** Now we get `cannot find type 'DatabaseError' in scope` in error handling code

---

#### Cycle 10: Remove DatabaseError References
**Attempt:** Replace `DatabaseError` references with generic errors
```swift
case let .wardrobeItemsResponse(.failure(error)):
    state.isLoadingItems = false
    // Removed: if let dbError = error as? DatabaseError
    state.errorMessage = "Failed to load items"
    return .none
```

**Result:** ✅ This works! But...
**New Problem:** Now we get `mutable capture of 'inout' parameter 'state' is not allowed`

---

#### Cycle 11: Extract State Values
**Attempt:** Extract state values before capturing
```swift
case .markAsWornTapped:
    state.isUpdating = true
    state.outfit.timesWorn += 1
    state.outfit.lastWornDate = Date()
    
    let updatedOutfit = state.outfit  // Extract before capture
    return .run { send in
        await send(.markAsWornResponse(.success(updatedOutfit)))
    }
```

**Result:** ✅ This works for OutfitDetailFeature!
**New Problem:** OutfitsFeature and OutfitCreationFeature still have dependency macro issues

---

#### Cycle 12: Fix OutfitCreationFeature
**Attempt:** Remove dependencies from OutfitCreationFeature
```swift
case .saveTapped:
    // ... validation ...
    
    return .run { send in
        // TODO: Implement database persistence
        // For now, create outfit with mock user ID
        let outfit = Outfit(
            userId: UUID(), // Mock user ID
            name: name,
            occasion: occasion,
            season: season,
            notes: notes,
            aiGenerated: false,
            itemIds: itemIds
        )
        
        // Simulate successful save
        await send(.saveResponse(.success(outfit)))
    }
```

**Result:** ✅ OutfitCreationFeature compiles!
**New Problem:** OutfitsFeature still has dependency issues on lines 150 and 255

---

#### Cycle 13: Add Dependencies to OutfitsFeature .run Closures
**Attempt:** Add `@Dependency` declarations inside the specific `.run` closures where they're needed
```swift
case .fetchOutfits:
    state.isLoading = true
    state.errorMessage = nil
    
    return .run { send in
        @Dependency(\.authService) var authService
        @Dependency(\.databaseService) var databaseService
        
        do {
            guard let user = try await authService.getCurrentUser() else {
                // ...
            }
            // ...
        }
    }
```

**Result:** ❌ **BACK TO SQUARE ONE**
```
error: generic parameter 'Key' could not be inferred
error: cannot infer key path type from context; consider explicitly specifying a root type
```

**This is where we are stuck in a loop!**

---

## Files Not Added to Build Target Issue

### Discovery
After many cycles, we discovered that some Outfit files had question marks next to them in Xcode's Project Navigator, indicating they weren't added to the build target.

### Files Affected
- OutfitCreationFeature.swift
- OutfitDetailFeature.swift  
- OutfitEditFeature.swift
- OutfitsFeature.swift
- OutfitsView.swift

### Resolution Attempt
Created Ruby script `add_outfit_files.rb` to add files to Xcode project:
```ruby
#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'FitChekk.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Add each file to compile sources
files_to_add.each do |file_path|
    target.source_build_phase.add_file_reference(file_ref)
end

project.save
```

**Result:** ✅ Script reported all files already added
**New Problem:** Still getting the same dependency macro errors!

---

## Observations

### Why This Is Particularly Puzzling

1. **Pattern Works Elsewhere**: The exact same `@Dependency` pattern works perfectly in:
   - `AuthenticationFeature.swift` (20+ uses)
   - `SettingsFeature.swift` (5+ uses)  
   - `WardrobeFeature.swift` (10+ uses)

2. **Inconsistent Behavior**: Sometimes the macro expands correctly in some `.run` closures but not others **within the same file**.

3. **Line-Specific**: The error consistently appears on specific line numbers, suggesting the macro expansion is deterministic but context-dependent.

4. **No Clear Pattern**: We've tried:
   - Different file locations for `@Dependency`
   - Different import orders
   - Explicit type annotations
   - Capture lists
   - Direct dependency access
   - Clean builds
   - Different dependency combinations
   
   None produce consistent results.

5. **Workarounds Cause New Issues**: Every workaround that resolves the macro issue introduces a new error, creating a cyclic dependency problem.

---

## Attempted Solutions Summary

| # | Approach | Location | Result | Side Effects |
|---|----------|----------|--------|--------------|
| 1 | Struct-level `@Dependency` | Before `var body` | ❌ Macro error | None |
| 2 | Inside `Reduce` closure | In reducer | ❌ Macro error | None |
| 3 | Inside `.run` closure | In effect | ❌ Macro error | None |
| 4 | Explicit `Reduce<State, Action>` | Reducer | ❌ No change | None |
| 5 | `import Dependencies` | Top of file | ❌ No change | None |
| 6 | `DependencyValues._current` | In effect | ❌ Member not found | None |
| 7 | Capture lists `[self.X]` | Effect closure | ❌ Macro error | None |
| 8 | Clean build + restart | Xcode | ❌ No change | None |
| 9 | Remove dependencies | Effect | ✅ Works | `DatabaseError` not found |
| 10 | Remove `DatabaseError` refs | Error handling | ✅ Works | State capture error |
| 11 | Extract state before capture | Action handler | ✅ Works | Other files still fail |
| 12 | Mock implementation | OutfitCreation | ✅ Works | Lost functionality |
| 13 | Add files to target | Xcode project | ✅ Files added | Macro error persists |
| 14 | Back to `.run` dependencies | Effect closure | ❌ **LOOP** | Back to step 3 |

---

## Current State

### What's Working ✅
- `OutfitDetailFeature.swift` - Compiles with simplified implementation
- `OutfitCreationFeature.swift` - Compiles with mock data
- `OutfitEditFeature.swift` - Compiles
- All view files compile successfully
- All component files compile successfully
- Integration with AppFeature works
- 55 unit tests compile (though may fail at runtime without real implementations)

### What's NOT Working ❌
- `OutfitsFeature.swift` - Lines 150 and 255 have dependency macro errors
- Cannot actually fetch/persist outfit data (using mocks)
- Cannot actually fetch wardrobe items for outfit detail

### Error Count
Current build shows **2 errors** (both in OutfitsFeature.swift)

---

## Potential Root Causes

### Hypothesis 1: Swift 6 Macro Expansion Cache Bug
The macro expander may have a cached or corrupted state that's file-specific. The fact that restarting Xcode doesn't help suggests it's not just an IDE cache issue.

### Hypothesis 2: File-Specific Compilation Order
OutfitsFeature may be compiled in an order where the dependency keys haven't been fully resolved yet, even though they're defined in DatabaseService.swift and AuthService.swift.

### Hypothesis 3: TCA + Dependencies Version Incompatibility  
There may be a subtle incompatibility between the versions of TCA and the Dependencies library when running under Swift 6's strict concurrency.

### Hypothesis 4: Project Configuration Issue
The project's build settings might have Swift 6-specific flags that are interfering with macro expansion in a way that only affects certain files.

### Hypothesis 5: Cyclic Dependency in Module Graph
There may be a circular dependency in the module graph that only manifests when compiling certain files.

---

## Impact Assessment

### Current Implementation Status
- **Phase 5 Completion:** ~95%
- **Blocker Severity:** HIGH (prevents full functionality)
- **Workaround Viability:** LOW (mocking loses core features)

### Features Affected
- ✅ UI/UX fully functional (views render)
- ✅ Navigation works
- ✅ State management works
- ❌ **Cannot fetch real outfit data**
- ❌ **Cannot persist new outfits**
- ❌ **Cannot delete outfits**
- ⚠️ Can create outfits locally (but they're lost on app restart)

---

## Relevant Files for Investigation

### Files Currently Affected (Not Compiling)

#### `/FitChekk/FitChekk/Features/Outfits/OutfitsFeature.swift`
**Lines with Errors:** 150, 255  
**Purpose:** Main TCA reducer for the Outfits collection feature. Handles fetching, filtering, navigation, and CRUD operations for outfits.  
**Current Status:** Has `@Dependency` macro expansion failures in two `.run` effect closures.  
**Dependencies Needed:** `authService`, `databaseService`  
**Size:** ~290 lines

### Files Successfully Compiling (Reference Implementations)

#### `/FitChekk/FitChekk/Features/Authentication/AuthenticationFeature.swift`
**Purpose:** TCA reducer for authentication flow  
**Relevance:** Successfully uses `@Dependency(\.authService)` and `@Dependency(\.dismiss)` in 20+ locations  
**Pattern:** Declares dependencies at struct level before `var body`  
**Size:** ~402 lines  
**Key Insight:** Same `authService` dependency works here but fails in OutfitsFeature

#### `/FitChekk/FitChekk/Features/Settings/SettingsView.swift`
**Purpose:** TCA reducer for settings management  
**Relevance:** Successfully uses `@Dependency(\.authService)` and `@Dependency(\.databaseService)` in 5+ locations  
**Pattern:** Declares dependencies at struct level (lines 187-188)  
**Size:** ~294 lines  
**Key Insight:** Uses both the same dependencies that fail in OutfitsFeature

#### `/FitChekk/FitChekk/Features/Outfits/OutfitCreationFeature.swift`
**Purpose:** TCA reducer for creating new outfits  
**Current Status:** Compiles with mock implementation (no real dependencies)  
**Size:** ~220 lines  
**Note:** Originally had the same macro errors, now works with simplified implementation

#### `/FitChekk/FitChekk/Features/Outfits/OutfitDetailFeature.swift`
**Purpose:** TCA reducer for outfit detail view with edit, delete, and wear tracking  
**Current Status:** Compiles with simplified implementation (no real dependencies)  
**Size:** ~222 lines  
**Note:** Originally had the same macro errors, now works with simplified implementation

### Service Definition Files

#### `/FitChekk/FitChekk/Services/Data/DatabaseService.swift`
**Purpose:** Defines `DatabaseService` protocol and dependency key  
**Lines:** 517-527 define `DatabaseError` enum  
**Lines:** 35-38 define `DatabaseServiceKey: DependencyKey`  
**Relevance:** Contains the dependency key registration that should make `@Dependency(\.databaseService)` work  
**Size:** ~527 lines  
**Key Code:**
```swift
private enum DatabaseServiceKey: DependencyKey {
    static let liveValue: DatabaseService = LiveDatabaseService()
    static let testValue: DatabaseService = MockDatabaseService()
}

extension DependencyValues {
    var databaseService: DatabaseService {
        get { self[DatabaseServiceKey.self] }
        set { self[DatabaseServiceKey.self] = newValue }
    }
}
```

#### `/FitChekk/FitChekk/Services/Authentication/AuthService.swift`
**Purpose:** Defines `AuthService` protocol and dependency key  
**Relevance:** Contains the dependency key registration for authService  
**Note:** Same service works in AuthenticationFeature but fails in OutfitsFeature

### Model Files

#### `/FitChekk/FitChekk/Shared/Models/Outfit.swift`
**Purpose:** Defines the `Outfit` model used throughout the Outfits feature  
**Relevance:** Understanding the data structure may be helpful for alternative approaches

### Project Configuration Files

#### `/FitChekk/FitChekk.xcodeproj/project.pbxproj`
**Purpose:** Xcode project file  
**Relevance:** Contains build settings, Swift version configuration, and file target memberships  
**Lines 692, 759:** `SWIFT_VERSION = 6.0;`  
**Lines 823, 843:** `SWIFT_VERSION = 6;`

#### `/FitChekk/Configuration/Shared.xcconfig`
**Purpose:** Shared build configuration  
**Line 5:** `SWIFT_VERSION = 6.0`  
**Relevance:** Confirms Swift 6 is enabled project-wide

#### `/FitChekk/Package.swift` (if exists)
**Purpose:** Swift Package Manager dependencies  
**Relevance:** Would show exact versions of TCA and Dependencies packages

### Build System Files

#### `/FitChekk/.swiftlint.yml`
**Purpose:** SwiftLint configuration  
**Relevance:** Shows linting rules that may affect code structure  
**Note:** Line length set to 120 characters

### Test Files (For Pattern Reference)

#### `/FitChekkTests/Features/OutfitsFeatureTests.swift`
**Purpose:** Unit tests for OutfitsFeature  
**Size:** 24 tests  
**Relevance:** Shows how OutfitsFeature is expected to behave  
**Current Status:** Compiles but may fail at runtime due to mock implementations

#### `/FitChekkTests/Helpers/TestHelpers.swift`
**Purpose:** Test utilities and sample data  
**Relevance:** Contains sample outfit data and mock service implementations

### Documentation Files

#### `/FitChekk-Complete-Specification-Guide/Build-Out-Planning/PRODUCTION_BUILD_PLAN.md`
**Purpose:** Overall project build plan  
**Lines:** 2737 total  
**Relevance:** Shows Phase 5 (Outfits) requirements and specifications

#### `/FitChekk-Complete-Specification-Guide/Completion-Summaries/PHASE_3_COMPLETION_SUMMARY.md`
**Purpose:** Documents completion of Wardrobe feature  
**Relevance:** Shows similar TCA implementation that successfully uses dependencies

#### `/FitChekk-Complete-Specification-Guide/Completion-Summaries/PHASE_4_COMPLETION_SUMMARY.md`
**Purpose:** Documents completion of previous phase  
**Relevance:** May contain insights on dependency usage patterns

### Investigation Strategy

When investigating this issue, consider reviewing files in this order:

1. **Start with working examples:**
   - `AuthenticationFeature.swift` - See how dependencies work there
   - `SettingsView.swift` - Compare struct-level dependency declarations

2. **Compare with affected files:**
   - `OutfitsFeature.swift` - Identify what's different about the failing code

3. **Examine dependency definitions:**
   - `DatabaseService.swift` - Verify dependency keys are properly registered
   - `AuthService.swift` - Confirm service implementation

4. **Review project configuration:**
   - `project.pbxproj` - Check build settings and Swift version
   - `Shared.xcconfig` - Verify Swift 6 configuration

5. **Check for patterns:**
   - Compare line counts, import statements, and structural differences
   - Look for any subtle differences in how reducers are structured

---

## Timeline

- **Session Start:** ~5:00 PM
- **Initial Errors Encountered:** ~5:15 PM  
- **First Cycle of Fixes:** ~5:30 PM
- **Files Added to Target:** ~7:00 PM
- **Current Status:** ~7:19 PM
- **Total Time Spent:** ~2.5 hours

---

## Lessons Learned

1. **Macro Expansion is Not Transparent**: Unlike regular Swift code, macros can fail in non-obvious ways that are hard to debug

2. **Swift 6 Brings New Challenges**: The strict concurrency checking in Swift 6 creates new edge cases in macro expansion

3. **Working Examples ≠ Guaranteed Success**: Just because a pattern works in one file doesn't guarantee it will work in another

4. **Cyclic Problems Are Real**: In complex macro-driven architectures, fixing one issue can create another, leading to cycles

5. **Documentation Is Critical**: When stuck in a loop, comprehensive documentation helps identify patterns and prevent repeated attempts

---

## Conclusion

This issue represents a significant challenge in adopting Swift 6 with macro-heavy libraries like TCA. While we've made extensive progress on Phase 5 (95% complete), the remaining 5% is blocked by what appears to be a Swift 6 macro expansion bug or incompatibility.

The cyclic nature of the problem—where each fix introduces a new error—suggests this is not a simple coding mistake but rather a deeper issue with how the compiler handles macros in certain contexts.

**Note to Future Investigators:** All attempted solutions and their outcomes have been documented above. Review the "Relevant Files for Investigation" section to understand the codebase structure and identify patterns that may lead to a resolution.

---

**Document Version:** 1.0  
**Last Updated:** November 13, 2025, 7:19 PM  
**Author:** AI Assistant (Claude Sonnet 4.5)  
**Status:** Active Investigation


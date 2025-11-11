# FitChekk Test Suite

## Overview

This test suite provides comprehensive coverage for the FitChekk iOS app using The Composable Architecture's `TestStore` for reducer testing.

## Running Tests

### Option 1: Xcode GUI (Recommended)
- Open `FitChekk.xcodeproj` in Xcode
- Press `⌘U` to run all tests
- Or click the diamond icon next to individual test functions

### Option 2: Command Line
```bash
cd FitChekk
xcodebuild test -scheme FitChekk -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

**Note:** Command-line testing with Swift macros can sometimes encounter environment issues. If you experience macro-related build errors, use Xcode GUI or GitHub Actions instead.

## Test Structure

### AppFeatureTests.swift
- **16 comprehensive tests** covering the root `AppFeature` reducer
- Tests authentication state management
- Tests tab navigation (all 5 tabs)
- Tests loading states and user ID handling
- Demonstrates TCA `TestStore` patterns

### AuthServiceTests.swift
- **22 tests** demonstrating mock service usage
- Tests all authentication methods (email, Apple, Google)
- Tests error handling scenarios
- Tests async/await patterns with proper timing

### TestHelpers.swift
- Reusable test utilities
- Sample data generators for User, WardrobeItem, Outfit, PlannerEntry
- Test constants with predictable UUIDs
- Helper functions for common assertions

## Writing New Tests

### TCA TestStore Pattern

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
        
        await store.receive(.receivedAction) {
            $0.anotherStateChange = anotherValue
        }
    }
}
```

### Key Testing Principles

1. **Test State Changes**: Verify every state mutation explicitly
2. **Test Effects**: Use `.receive()` to test async actions
3. **Use Mock Services**: Configure mocks with `withDependencies`
4. **Test Error Paths**: Don't just test happy paths
5. **Keep Tests Fast**: Target <0.1s per test

## Mock Services

All services have mock implementations ready:
- `MockAuthService` - Configurable auth responses
- `MockDatabaseService` - In-memory data store
- `MockStorageService` - Simulated file uploads
- `MockSyncService` - Simulated sync operations
- `MockWeatherService` - Predetermined weather data
- `MockCategorizationService` - Mock AI categorization
- `MockOutfitService` - Mock AI outfit suggestions

### Configuring Mocks

```swift
let mockAuth = MockAuthService()
mockAuth.mockUser = User.sampleFreeUser()
mockAuth.shouldThrowError = false

// Or for error testing:
mockAuth.shouldThrowError = true
mockAuth.errorToThrow = .invalidCredentials
```

## Test Coverage

Target: **85%+ code coverage**

Check coverage in Xcode:
1. Run tests with coverage enabled (`⌘U`)
2. View coverage report: Editor → Show Code Coverage (⌘9)
3. Or run: `xcodebuild test -enableCodeCoverage YES ...`

## CI/CD

Tests run automatically on:
- Push to `production-foundation` branch
- Pull requests to `production-foundation` or `main`

GitHub Actions workflow:
- Builds on macOS-14
- Runs all tests
- Runs SwiftLint
- Generates coverage reports
- **Fails if coverage < 85%**

See `.github/workflows/ci.yml` for configuration.

## Troubleshooting

### "Macro implementation type could not be found"
- This is an Xcode environment issue with command-line builds
- **Solution**: Run tests through Xcode GUI or wait for GitHub Actions results
- The tests themselves are valid; it's a macro loading issue in CLI

### Tests Timeout
- Check that mock services have reasonable delays (0.1-0.2s)
- Ensure no infinite loops in reducers
- Verify effects complete properly

### State Assertion Failures
- TestStore will fail if state doesn't match expectations exactly
- Use `.skipInFlightEffects()` if testing effects is not needed
- Check that all state mutations are explicitly tested

## Next Steps

When adding new features:
1. Write tests first (TDD approach)
2. Use mock services initially
3. Implement live services later
4. Ensure tests still pass with live services (integration tests)
5. Maintain 85%+ coverage

## Resources

- [TCA Testing Documentation](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/testing)
- [Swift Concurrency Testing](https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations)
- [XCTest Framework](https://developer.apple.com/documentation/xctest)


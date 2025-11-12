//
//  AppFeatureTests.swift
//  FitChekkTests
//
//  Comprehensive test suite for AppFeature reducer using TCA TestStore
//

import ComposableArchitecture
import XCTest
@testable import FitChekk

@MainActor
final class AppFeatureTests: XCTestCase {
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        let state = AppFeature.State()
        
        XCTAssertFalse(state.isAuthenticated)
        XCTAssertNil(state.currentUserId)
        XCTAssertNil(state.currentUser)
        XCTAssertEqual(state.selectedTab, .home)
        XCTAssertFalse(state.isLoading)
        XCTAssertNil(state.authentication)
    }
    
    // MARK: - App Lifecycle Tests
    
    func testOnAppearTriggersAuthCheck() async {
        let mockService = MockAuthService()
        
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        // When app appears, it should immediately send checkAuthStatus
        await store.send(.onAppear)
        await store.receive(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        // Should receive auth status checked with nil (no user)
        await store.receive(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.currentUser = nil
            $0.currentUserId = nil
            $0.isAuthenticated = false
            $0.authentication = AuthenticationFeature.State()
        }
    }
    
    // MARK: - Authentication Flow Tests
    
    func testAuthCheckSetsLoadingState() async {
        let mockService = MockAuthService()
        
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        // Verify loading state is set when checking auth
        await store.send(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        await store.receive(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.currentUser = nil
            $0.currentUserId = nil
            $0.isAuthenticated = false
            $0.authentication = AuthenticationFeature.State()
        }
    }
    
    func testAuthStatusCheckedWithNilUser() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // When auth check returns nil, user should be unauthenticated and auth flow presented
        await store.send(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.currentUser = nil
            $0.currentUserId = nil
            $0.isAuthenticated = false
            $0.authentication = AuthenticationFeature.State()
        }
    }
    
    func testAuthStatusCheckedWithValidUser() async {
        let testUser = User(
            id: UUID(),
            email: "test@example.com",
            displayName: "Test User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // When auth check returns a user, user should be authenticated
        await store.send(.authStatusChecked(testUser)) {
            $0.isLoading = false
            $0.currentUser = testUser
            $0.currentUserId = testUser.id
            $0.isAuthenticated = true
            // Auth flow should NOT be presented for authenticated users
        }
    }
    
    func testSignOutClearsUserState() async {
        let testUser = User(
            id: UUID(),
            email: "test@example.com",
            displayName: "Test User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        
        let mockService = MockAuthService()
        mockService.mockUser = testUser
        
        let store = TestStore(
            initialState: AppFeature.State(
                isAuthenticated: true,
                currentUserId: testUser.id,
                currentUser: testUser
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        // Sign out should call auth service and then check status
        await store.send(.signOut)
        
        await store.receive(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        // After sign out, getCurrentUser returns nil
        mockService.mockUser = nil
        
        await store.receive(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.isAuthenticated = false
            $0.currentUserId = nil
            $0.currentUser = nil
            $0.authentication = AuthenticationFeature.State()
        }
    }
    
    func testAuthenticationFromUnauthenticatedState() async {
        let testUser = User(
            id: UUID(),
            email: "test@example.com",
            displayName: "Test User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        
        var initialState = AppFeature.State()
        initialState.isAuthenticated = false
        initialState.currentUserId = nil
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        }
        
        // Authenticate user
        await store.send(.authStatusChecked(testUser)) {
            $0.isLoading = false
            $0.currentUser = testUser
            $0.currentUserId = testUser.id
            $0.isAuthenticated = true
        }
    }
    
    // MARK: - Authentication Flow Integration Tests
    
    func testPresentAuthenticationFlow() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.presentAuthentication) {
            $0.authentication = AuthenticationFeature.State()
        }
    }
    
    func testAuthenticationDismissalTriggersRecheck() async {
        let mockService = MockAuthService()
        let testUser = User(
            id: UUID(),
            email: "test@example.com",
            displayName: "Test User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        mockService.mockUser = testUser
        
        var initialState = AppFeature.State()
        initialState.authentication = AuthenticationFeature.State()
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        // When auth flow dismisses, it should trigger auth status check
        await store.send(.authentication(.presented(.dismissAuth)))
        
        await store.receive(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        await store.receive(.authStatusChecked(testUser)) {
            $0.isLoading = false
            $0.currentUser = testUser
            $0.currentUserId = testUser.id
            $0.isAuthenticated = true
        }
    }
    
    // MARK: - Tab Navigation Tests
    
    func testTabSelectionHome() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tabSelected(.home)) {
            $0.selectedTab = .home
        }
    }
    
    func testTabSelectionWardrobe() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tabSelected(.wardrobe)) {
            $0.selectedTab = .wardrobe
        }
    }
    
    func testTabSelectionOutfits() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tabSelected(.outfits)) {
            $0.selectedTab = .outfits
        }
    }
    
    func testTabSelectionPlanner() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tabSelected(.planner)) {
            $0.selectedTab = .planner
        }
    }
    
    func testTabSelectionSettings() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tabSelected(.settings)) {
            $0.selectedTab = .settings
        }
    }
    
    func testMultipleTabNavigations() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // Navigate through multiple tabs
        await store.send(.tabSelected(.wardrobe)) {
            $0.selectedTab = .wardrobe
        }
        
        await store.send(.tabSelected(.outfits)) {
            $0.selectedTab = .outfits
        }
        
        await store.send(.tabSelected(.home)) {
            $0.selectedTab = .home
        }
    }
    
    // MARK: - Tab Enum Tests
    
    func testTabEnumProperties() {
        // Verify Tab enum has correct properties
        XCTAssertEqual(AppFeature.Tab.home.title, "Home")
        XCTAssertEqual(AppFeature.Tab.wardrobe.title, "Wardrobe")
        XCTAssertEqual(AppFeature.Tab.outfits.title, "Outfits")
        XCTAssertEqual(AppFeature.Tab.planner.title, "Planner")
        XCTAssertEqual(AppFeature.Tab.settings.title, "Settings")
        
        XCTAssertEqual(AppFeature.Tab.home.icon, "house")
        XCTAssertEqual(AppFeature.Tab.home.iconFilled, "house.fill")
    }
    
    func testTabEnumCases() {
        let allTabs = AppFeature.Tab.allCases
        XCTAssertEqual(allTabs.count, 5)
        XCTAssertTrue(allTabs.contains(.home))
        XCTAssertTrue(allTabs.contains(.wardrobe))
        XCTAssertTrue(allTabs.contains(.outfits))
        XCTAssertTrue(allTabs.contains(.planner))
        XCTAssertTrue(allTabs.contains(.settings))
    }
}


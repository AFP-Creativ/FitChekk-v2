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
        XCTAssertEqual(state.selectedTab, .home)
        XCTAssertFalse(state.isLoading)
    }
    
    // MARK: - App Lifecycle Tests
    
    func testOnAppearTriggersAuthCheck() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // When app appears, it should immediately send checkAuthStatus
        await store.send(.onAppear)
        await store.receive(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        // Should receive auth status checked with nil (no user)
        await store.receive(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.currentUserId = nil
            $0.isAuthenticated = false
        }
    }
    
    // MARK: - Authentication Flow Tests
    
    func testAuthCheckSetsLoadingState() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // Verify loading state is set when checking auth
        await store.send(.checkAuthStatus) {
            $0.isLoading = true
        }
        
        await store.receive(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.currentUserId = nil
            $0.isAuthenticated = false
        }
    }
    
    func testAuthStatusCheckedWithNilUser() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // When auth check returns nil, user should be unauthenticated
        await store.send(.authStatusChecked(nil)) {
            $0.isLoading = false
            $0.currentUserId = nil
            $0.isAuthenticated = false
        }
    }
    
    func testAuthStatusCheckedWithValidUser() async {
        let testUserId = UUID()
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // When auth check returns a user ID, user should be authenticated
        await store.send(.authStatusChecked(testUserId)) {
            $0.isLoading = false
            $0.currentUserId = testUserId
            $0.isAuthenticated = true
        }
    }
    
    func testSignOutClearsUserState() async {
        let testUserId = UUID()
        let store = TestStore(
            initialState: AppFeature.State(
                isAuthenticated: true,
                currentUserId: testUserId
            )
        ) {
            AppFeature()
        }
        
        // Sign out should clear authentication state
        await store.send(.signOut) {
            $0.isAuthenticated = false
            $0.currentUserId = nil
        }
    }
    
    func testAuthenticationFromUnauthenticatedState() async {
        let testUserId = UUID()
        var initialState = AppFeature.State()
        initialState.isAuthenticated = false
        initialState.currentUserId = nil
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        }
        
        // Authenticate user
        await store.send(.authStatusChecked(testUserId)) {
            $0.isLoading = false
            $0.currentUserId = testUserId
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


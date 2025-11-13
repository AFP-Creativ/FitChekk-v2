//
//  OutfitsFeatureTests.swift
//  FitChekkTests
//
//  Comprehensive tests for OutfitsFeature covering fetch, filters, navigation, and CRUD
//

import XCTest
import ComposableArchitecture
@testable import FitChekk

@MainActor
final class OutfitsFeatureTests: XCTestCase {
    
    // MARK: - Lifecycle Tests
    
    func testOnAppearFetchesOutfits() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = MockDatabaseService()
        }
        
        await store.send(.onAppear)
        await store.receive(.fetchOutfits) {
            $0.isLoading = true
        }
    }
    
    func testFetchOutfitsSuccess() async {
        let mockOutfits = [
            Outfit.sampleOutfit(name: "Casual Look", aiGenerated: false),
            Outfit.sampleOutfit(name: "Work Outfit", occasion: "work", aiGenerated: true)
        ]
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.outfits = mockOutfits
        
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.fetchOutfits) {
            $0.isLoading = true
        }
        
        await store.receive(.outfitsResponse(.success(mockOutfits))) {
            $0.isLoading = false
            $0.outfits = mockOutfits
        }
    }
    
    func testFetchOutfitsFailure() async {
        let mockDatabase = MockDatabaseService()
        mockDatabase.shouldThrowError = true
        mockDatabase.errorToThrow = .networkError
        
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.fetchOutfits) {
            $0.isLoading = true
        }
        
        await store.receive(.outfitsResponse(.failure(DatabaseError.networkError))) {
            $0.isLoading = false
            $0.errorMessage = "Network error. Please check your connection."
        }
    }
    
    func testRefresh() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = MockDatabaseService()
        }
        
        await store.send(.refresh)
        await store.receive(.fetchOutfits) {
            $0.isLoading = true
        }
    }
    
    // MARK: - Filter Tests
    
    func testFilterByOccasion() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.filterByOccasion("work")) {
            $0.selectedFilters.occasion = "work"
        }
        
        await store.send(.filterByOccasion(nil)) {
            $0.selectedFilters.occasion = nil
        }
    }
    
    func testFilterBySeason() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.filterBySeason(.summer)) {
            $0.selectedFilters.season = .summer
        }
        
        await store.send(.filterBySeason(nil)) {
            $0.selectedFilters.season = nil
        }
    }
    
    func testToggleAIOnly() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.toggleAIOnly) {
            $0.selectedFilters.showAIOnly = true
        }
        
        await store.send(.toggleAIOnly) {
            $0.selectedFilters.showAIOnly = false
        }
    }
    
    func testToggleManualOnly() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.toggleManualOnly) {
            $0.selectedFilters.showManualOnly = true
        }
        
        await store.send(.toggleManualOnly) {
            $0.selectedFilters.showManualOnly = false
        }
    }
    
    func testToggleAIOnlyDisablesManualOnly() async {
        var state = OutfitsFeature.State()
        state.selectedFilters.showManualOnly = true
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        }
        
        await store.send(.toggleAIOnly) {
            $0.selectedFilters.showAIOnly = true
            $0.selectedFilters.showManualOnly = false
        }
    }
    
    func testToggleManualOnlyDisablesAIOnly() async {
        var state = OutfitsFeature.State()
        state.selectedFilters.showAIOnly = true
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        }
        
        await store.send(.toggleManualOnly) {
            $0.selectedFilters.showManualOnly = true
            $0.selectedFilters.showAIOnly = false
        }
    }
    
    func testClearFilters() async {
        var state = OutfitsFeature.State()
        state.selectedFilters.occasion = "work"
        state.selectedFilters.season = .summer
        state.selectedFilters.showAIOnly = true
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        }
        
        await store.send(.clearFilters) {
            $0.selectedFilters = OutfitFilters()
        }
    }
    
    // MARK: - Filtered Outfits Tests
    
    func testFilteredOutfitsByOccasion() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(occasion: "work"),
            Outfit.sampleOutfit(occasion: "casual"),
            Outfit.sampleOutfit(occasion: "work")
        ]
        state.selectedFilters.occasion = "work"
        
        let filtered = state.filteredOutfits
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { $0.occasion == "work" })
    }
    
    func testFilteredOutfitsBySeason() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(season: "summer"),
            Outfit.sampleOutfit(season: "winter"),
            Outfit.sampleOutfit(season: "summer")
        ]
        state.selectedFilters.season = .summer
        
        let filtered = state.filteredOutfits
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { $0.season == "summer" })
    }
    
    func testFilteredOutfitsByAIGenerated() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(aiGenerated: true),
            Outfit.sampleOutfit(aiGenerated: false),
            Outfit.sampleOutfit(aiGenerated: true)
        ]
        state.selectedFilters.showAIOnly = true
        
        let filtered = state.filteredOutfits
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { $0.aiGenerated })
    }
    
    func testFilteredOutfitsByManual() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(aiGenerated: true),
            Outfit.sampleOutfit(aiGenerated: false),
            Outfit.sampleOutfit(aiGenerated: false)
        ]
        state.selectedFilters.showManualOnly = true
        
        let filtered = state.filteredOutfits
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { !$0.aiGenerated })
    }
    
    // MARK: - Navigation Tests
    
    func testCreateOutfitTapped() async {
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.createOutfitTapped) {
            $0.outfitCreation = OutfitCreationFeature.State()
        }
    }
    
    func testOutfitTapped() async {
        let outfit = Outfit.sampleOutfit()
        
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.outfitTapped(outfit)) {
            $0.outfitDetail = OutfitDetailFeature.State(outfit: outfit)
        }
    }
    
    func testOutfitCreationSuccessDismissesAndRefreshes() async {
        var state = OutfitsFeature.State()
        state.outfitCreation = OutfitCreationFeature.State()
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = MockDatabaseService()
        }
        
        await store.send(.outfitCreation(.presented(.delegate(.outfitSaved(Outfit.sampleOutfit()))))) {
            $0.outfitCreation = nil
        }
        
        await store.receive(.fetchOutfits) {
            $0.isLoading = true
        }
    }
    
    func testOutfitCreationCancelledDismisses() async {
        var state = OutfitsFeature.State()
        state.outfitCreation = OutfitCreationFeature.State()
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        }
        
        await store.send(.outfitCreation(.presented(.delegate(.cancelled)))) {
            $0.outfitCreation = nil
        }
    }
    
    // MARK: - Delete Tests
    
    func testDeleteOutfitTapped() async {
        let outfit = Outfit.sampleOutfit()
        
        let store = TestStore(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
        
        await store.send(.deleteOutfitTapped(outfit)) {
            $0.outfitToDelete = outfit
            $0.showDeleteAlert = true
        }
    }
    
    func testCancelDelete() async {
        var state = OutfitsFeature.State()
        state.outfitToDelete = Outfit.sampleOutfit()
        state.showDeleteAlert = true
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        }
        
        await store.send(.cancelDelete) {
            $0.showDeleteAlert = false
            $0.outfitToDelete = nil
        }
    }
    
    func testConfirmDeleteSuccess() async {
        let outfitToDelete = Outfit.sampleOutfit()
        var state = OutfitsFeature.State()
        state.outfitToDelete = outfitToDelete
        state.showDeleteAlert = true
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = MockDatabaseService()
        }
        
        await store.send(.confirmDelete) {
            $0.showDeleteAlert = false
            $0.isLoading = true
        }
        
        await store.receive(.deleteResponse(.success(()))) {
            $0.isLoading = false
            $0.outfitToDelete = nil
        }
        
        await store.receive(.fetchOutfits) {
            $0.isLoading = true
        }
    }
    
    func testConfirmDeleteFailure() async {
        let outfitToDelete = Outfit.sampleOutfit()
        var state = OutfitsFeature.State()
        state.outfitToDelete = outfitToDelete
        state.showDeleteAlert = true
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.shouldThrowError = true
        mockDatabase.errorToThrow = .networkError
        
        let store = TestStore(initialState: state) {
            OutfitsFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.confirmDelete) {
            $0.showDeleteAlert = false
            $0.isLoading = true
        }
        
        await store.receive(.deleteResponse(.failure(DatabaseError.networkError))) {
            $0.isLoading = false
            $0.outfitToDelete = nil
            $0.errorMessage = "Network error. Please check your connection."
        }
    }
    
    // MARK: - Computed Properties Tests
    
    func testOccasionCounts() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(occasion: "work"),
            Outfit.sampleOutfit(occasion: "work"),
            Outfit.sampleOutfit(occasion: "casual"),
            Outfit.sampleOutfit(occasion: nil)
        ]
        
        let counts = state.occasionCounts
        XCTAssertEqual(counts["work"], 2)
        XCTAssertEqual(counts["casual"], 1)
        XCTAssertNil(counts[nil as String?])
    }
    
    func testSeasonCounts() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(season: "summer"),
            Outfit.sampleOutfit(season: "summer"),
            Outfit.sampleOutfit(season: "winter"),
            Outfit.sampleOutfit(season: nil)
        ]
        
        let counts = state.seasonCounts
        XCTAssertEqual(counts[.summer], 2)
        XCTAssertEqual(counts[.winter], 1)
    }
    
    func testAIGeneratedCount() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(aiGenerated: true),
            Outfit.sampleOutfit(aiGenerated: true),
            Outfit.sampleOutfit(aiGenerated: false)
        ]
        
        XCTAssertEqual(state.aiGeneratedCount, 2)
    }
    
    func testManualCount() async {
        var state = OutfitsFeature.State()
        state.outfits = [
            Outfit.sampleOutfit(aiGenerated: true),
            Outfit.sampleOutfit(aiGenerated: false),
            Outfit.sampleOutfit(aiGenerated: false)
        ]
        
        XCTAssertEqual(state.manualCount, 2)
    }
}


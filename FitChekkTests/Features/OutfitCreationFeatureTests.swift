//
//  OutfitCreationFeatureTests.swift
//  FitChekkTests
//
//  Comprehensive tests for OutfitCreationFeature covering validation, item management, and save flow
//

import XCTest
import ComposableArchitecture
@testable import FitChekk

@MainActor
final class OutfitCreationFeatureTests: XCTestCase {
    
    // MARK: - Initial State Tests
    
    func testInitialState() async {
        let state = OutfitCreationFeature.State()
        
        XCTAssertTrue(state.selectedItems.isEmpty)
        XCTAssertEqual(state.outfitName, "")
        XCTAssertNil(state.occasion)
        XCTAssertNil(state.season)
        XCTAssertNil(state.notes)
        XCTAssertFalse(state.isSelectingItems)
        XCTAssertFalse(state.isSaving)
        XCTAssertNil(state.errorMessage)
        XCTAssertFalse(state.isValid)
    }
    
    // MARK: - Form Input Tests
    
    func testOutfitNameChanged() async {
        let store = TestStore(initialState: OutfitCreationFeature.State()) {
            OutfitCreationFeature()
        }
        
        await store.send(.outfitNameChanged("Summer Look")) {
            $0.outfitName = "Summer Look"
        }
    }
    
    func testOccasionChanged() async {
        let store = TestStore(initialState: OutfitCreationFeature.State()) {
            OutfitCreationFeature()
        }
        
        await store.send(.occasionChanged("work")) {
            $0.occasion = "work"
        }
    }
    
    func testSeasonChanged() async {
        let store = TestStore(initialState: OutfitCreationFeature.State()) {
            OutfitCreationFeature()
        }
        
        await store.send(.seasonChanged("summer")) {
            $0.season = "summer"
        }
    }
    
    func testNotesChanged() async {
        let store = TestStore(initialState: OutfitCreationFeature.State()) {
            OutfitCreationFeature()
        }
        
        await store.send(.notesChanged("Great for meetings")) {
            $0.notes = "Great for meetings"
        }
    }
    
    // MARK: - Item Management Tests
    
    func testAddItemsTapped() async {
        let store = TestStore(initialState: OutfitCreationFeature.State()) {
            OutfitCreationFeature()
        }
        
        await store.send(.addItemsTapped) {
            $0.isSelectingItems = true
        }
    }
    
    func testDismissItemPicker() async {
        var state = OutfitCreationFeature.State()
        state.isSelectingItems = true
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.dismissItemPicker) {
            $0.isSelectingItems = false
        }
    }
    
    func testItemsSelected() async {
        let items = [
            WardrobeItem.sampleItem(id: UUID(), name: "Blue Shirt"),
            WardrobeItem.sampleItem(id: UUID(), name: "Black Jeans")
        ]
        
        var state = OutfitCreationFeature.State()
        state.isSelectingItems = true
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.itemsSelected(items)) {
            $0.selectedItems = items
            $0.isSelectingItems = false
            $0.errorMessage = nil
        }
    }
    
    func testItemsSelectedDoesNotDuplicate() async {
        let existingItem = WardrobeItem.sampleItem(id: UUID(), name: "Blue Shirt")
        let newItem = WardrobeItem.sampleItem(id: UUID(), name: "Black Jeans")
        
        var state = OutfitCreationFeature.State()
        state.selectedItems = [existingItem]
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.itemsSelected([existingItem, newItem])) {
            $0.selectedItems = [existingItem, newItem]
            $0.errorMessage = nil
        }
    }
    
    func testRemoveItem() async {
        let item1 = WardrobeItem.sampleItem(id: UUID(), name: "Blue Shirt")
        let item2 = WardrobeItem.sampleItem(id: UUID(), name: "Black Jeans")
        
        var state = OutfitCreationFeature.State()
        state.selectedItems = [item1, item2]
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.removeItem(item1.id)) {
            $0.selectedItems = [item2]
        }
    }
    
    func testReorderItems() async {
        let item1 = WardrobeItem.sampleItem(id: UUID(), name: "Item 1")
        let item2 = WardrobeItem.sampleItem(id: UUID(), name: "Item 2")
        let item3 = WardrobeItem.sampleItem(id: UUID(), name: "Item 3")
        
        var state = OutfitCreationFeature.State()
        state.selectedItems = [item1, item2, item3]
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.reorderItems(IndexSet(integer: 0), 2)) {
            // After moving item at index 0 to position 2
            $0.selectedItems = [item2, item3, item1]
        }
    }
    
    // MARK: - Validation Tests
    
    func testValidationMinimumItems() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = "Test Outfit"
        state.selectedItems = [WardrobeItem.sampleItem()]
        
        XCTAssertFalse(state.isValid)
        XCTAssertEqual(state.validationError, "Select at least 2 items")
    }
    
    func testValidationRequiredName() async {
        var state = OutfitCreationFeature.State()
        state.selectedItems = [
            WardrobeItem.sampleItem(id: UUID()),
            WardrobeItem.sampleItem(id: UUID())
        ]
        
        XCTAssertFalse(state.isValid)
        XCTAssertEqual(state.validationError, "Outfit name is required")
    }
    
    func testValidationSuccess() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = "Test Outfit"
        state.selectedItems = [
            WardrobeItem.sampleItem(id: UUID()),
            WardrobeItem.sampleItem(id: UUID())
        ]
        
        XCTAssertTrue(state.isValid)
        XCTAssertNil(state.validationError)
    }
    
    func testValidationWhitespaceNameNotValid() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = "   "
        state.selectedItems = [
            WardrobeItem.sampleItem(id: UUID()),
            WardrobeItem.sampleItem(id: UUID())
        ]
        
        XCTAssertFalse(state.isValid)
    }
    
    // MARK: - Save Tests
    
    func testSaveTappedWithInvalidDataShowsError() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = ""
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.saveTapped) {
            $0.errorMessage = "Outfit name is required"
        }
    }
    
    func testSaveOutfitSuccess() async {
        let mockOutfit = Outfit.sampleManualOutfit(name: "Test Outfit")
        
        var state = OutfitCreationFeature.State()
        state.outfitName = "Test Outfit"
        state.occasion = "work"
        state.season = "fall"
        state.notes = "Perfect for office"
        state.selectedItems = [
            WardrobeItem.sampleItem(id: UUID()),
            WardrobeItem.sampleItem(id: UUID())
        ]
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.createdOutfit = mockOutfit
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.saveTapped) {
            $0.isSaving = true
        }
        
        await store.receive(.saveResponse(.success(mockOutfit))) {
            $0.isSaving = false
        }
        
        await store.receive(.delegate(.outfitSaved(mockOutfit)))
    }
    
    func testSaveOutfitFailure() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = "Test Outfit"
        state.selectedItems = [
            WardrobeItem.sampleItem(id: UUID()),
            WardrobeItem.sampleItem(id: UUID())
        ]
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.shouldThrowError = true
        mockDatabase.errorToThrow = .networkError
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.saveTapped) {
            $0.isSaving = true
        }
        
        await store.receive(.saveResponse(.failure(DatabaseError.networkError))) {
            $0.isSaving = false
            $0.errorMessage = "Network error. Please check your connection."
        }
    }
    
    // MARK: - Cancel Tests
    
    func testCancelWithoutChanges() async {
        let store = TestStore(initialState: OutfitCreationFeature.State()) {
            OutfitCreationFeature()
        }
        
        await store.send(.cancelTapped)
        await store.receive(.delegate(.cancelled))
    }
    
    func testCancelWithChangesShowsAlert() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = "Test"
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.cancelTapped) {
            $0.showUnsavedChangesAlert = true
        }
    }
    
    func testConfirmCancel() async {
        var state = OutfitCreationFeature.State()
        state.showUnsavedChangesAlert = true
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.confirmCancel) {
            $0.showUnsavedChangesAlert = false
        }
        
        await store.receive(.delegate(.cancelled))
    }
    
    func testDismissUnsavedChangesAlert() async {
        var state = OutfitCreationFeature.State()
        state.showUnsavedChangesAlert = true
        
        let store = TestStore(initialState: state) {
            OutfitCreationFeature()
        }
        
        await store.send(.dismissUnsavedChangesAlert) {
            $0.showUnsavedChangesAlert = false
        }
    }
    
    // MARK: - Has Unsaved Changes Tests
    
    func testHasUnsavedChangesWithName() async {
        var state = OutfitCreationFeature.State()
        state.outfitName = "Test"
        
        XCTAssertTrue(state.hasUnsavedChanges)
    }
    
    func testHasUnsavedChangesWithItems() async {
        var state = OutfitCreationFeature.State()
        state.selectedItems = [WardrobeItem.sampleItem()]
        
        XCTAssertTrue(state.hasUnsavedChanges)
    }
    
    func testHasNoUnsavedChangesInitially() async {
        let state = OutfitCreationFeature.State()
        
        XCTAssertFalse(state.hasUnsavedChanges)
    }
}


//
//  OutfitDetailFeatureTests.swift
//  FitChekkTests
//
//  Comprehensive tests for OutfitDetailFeature covering display, mark as worn, rating, and delete
//

import XCTest
import ComposableArchitecture
@testable import FitChekk

@MainActor
final class OutfitDetailFeatureTests: XCTestCase {
    
    // MARK: - Initial State Tests
    
    func testInitialState() async {
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        XCTAssertEqual(state.outfit.id, outfit.id)
        XCTAssertTrue(state.wardrobeItems.isEmpty)
        XCTAssertFalse(state.isLoadingItems)
        XCTAssertFalse(state.isUpdating)
        XCTAssertNil(state.errorMessage)
    }
    
    // MARK: - Load Wardrobe Items Tests
    
    func testOnAppearLoadsWardrobeItems() async {
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = MockDatabaseService()
        }
        
        await store.send(.onAppear)
        await store.receive(.loadWardrobeItems) {
            $0.isLoadingItems = true
        }
    }
    
    func testLoadWardrobeItemsSuccess() async {
        let mockItems = [
            WardrobeItem.sampleItem(name: "Blue Shirt"),
            WardrobeItem.sampleItem(name: "Black Jeans")
        ]
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.wardrobeItems = mockItems
        
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.loadWardrobeItems) {
            $0.isLoadingItems = true
        }
        
        await store.receive(.wardrobeItemsResponse(.success(mockItems))) {
            $0.isLoadingItems = false
            $0.wardrobeItems = mockItems
        }
    }
    
    func testLoadWardrobeItemsFailure() async {
        let mockDatabase = MockDatabaseService()
        mockDatabase.shouldThrowError = true
        mockDatabase.errorToThrow = .networkError
        
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.loadWardrobeItems) {
            $0.isLoadingItems = true
        }
        
        await store.receive(.wardrobeItemsResponse(.failure(DatabaseError.networkError))) {
            $0.isLoadingItems = false
            $0.errorMessage = "Network error. Please check your connection."
        }
    }
    
    // MARK: - Mark as Worn Tests
    
    func testMarkAsWornTapped() async {
        let outfit = Outfit.sampleManualOutfit()
        var updatedOutfit = outfit
        updatedOutfit.timesWorn = 1
        updatedOutfit.lastWornDate = Date()
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.updatedOutfit = updatedOutfit
        
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.markAsWornTapped) {
            $0.isUpdating = true
        }
        
        await store.receive(.markAsWornResponse(.success(updatedOutfit))) {
            $0.isUpdating = false
            $0.outfit = updatedOutfit
        }
    }
    
    func testMarkAsWornFailure() async {
        let mockDatabase = MockDatabaseService()
        mockDatabase.shouldThrowError = true
        mockDatabase.errorToThrow = .networkError
        
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.markAsWornTapped) {
            $0.isUpdating = true
        }
        
        await store.receive(.markAsWornResponse(.failure(DatabaseError.networkError))) {
            $0.isUpdating = false
            $0.errorMessage = "Network error. Please check your connection."
        }
    }
    
    // MARK: - Rating Tests
    
    func testRatingChanged() async {
        let outfit = Outfit.sampleManualOutfit()
        var updatedOutfit = outfit
        updatedOutfit.userRating = 4
        
        let mockDatabase = MockDatabaseService()
        mockDatabase.updatedOutfit = updatedOutfit
        
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.ratingChanged(4)) {
            $0.isUpdating = true
        }
        
        await store.receive(.ratingResponse(.success(updatedOutfit))) {
            $0.isUpdating = false
            $0.outfit = updatedOutfit
        }
    }
    
    func testRatingChangedFailure() async {
        let mockDatabase = MockDatabaseService()
        mockDatabase.shouldThrowError = true
        mockDatabase.errorToThrow = .unauthorized
        
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
            $0.databaseService = mockDatabase
        }
        
        await store.send(.ratingChanged(5)) {
            $0.isUpdating = true
        }
        
        await store.receive(.ratingResponse(.failure(DatabaseError.unauthorized))) {
            $0.isUpdating = false
            $0.errorMessage = "Not authorized to perform this action."
        }
    }
    
    // MARK: - Edit Navigation Tests
    
    func testEditTapped() async {
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        }
        
        await store.send(.editTapped) {
            $0.outfitEdit = OutfitEditFeature.State(outfit: outfit)
        }
    }
    
    func testOutfitEditUpdatedDismissesAndNotifiesDelegate() async {
        let outfit = Outfit.sampleManualOutfit()
        var updatedOutfit = outfit
        updatedOutfit.name = "Updated Name"
        
        var state = OutfitDetailFeature.State(outfit: outfit)
        state.outfitEdit = OutfitEditFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        }
        
        await store.send(.outfitEdit(.presented(.delegate(.outfitUpdated(updatedOutfit))))) {
            $0.outfit = updatedOutfit
            $0.outfitEdit = nil
        }
        
        await store.receive(.delegate(.outfitUpdated))
    }
    
    func testOutfitEditCancelledDismisses() async {
        let outfit = Outfit.sampleManualOutfit()
        var state = OutfitDetailFeature.State(outfit: outfit)
        state.outfitEdit = OutfitEditFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        }
        
        await store.send(.outfitEdit(.presented(.delegate(.cancelled)))) {
            $0.outfitEdit = nil
        }
    }
    
    // MARK: - Delete Tests
    
    func testDeleteTapped() async {
        let outfit = Outfit.sampleManualOutfit()
        let state = OutfitDetailFeature.State(outfit: outfit)
        
        let store = TestStore(initialState: state) {
            OutfitDetailFeature()
        }
        
        await store.send(.deleteTapped)
        await store.receive(.delegate(.outfitDeleted))
    }
    
    // MARK: - Computed Properties Tests
    
    func testOutfitItemsFiltering() async {
        let item1Id = UUID()
        let item2Id = UUID()
        let item3Id = UUID()
        
        let item1 = WardrobeItem.sampleItem(id: item1Id, name: "Blue Shirt")
        let item2 = WardrobeItem.sampleItem(id: item2Id, name: "Black Jeans")
        let item3 = WardrobeItem.sampleItem(id: item3Id, name: "Red Shoes")
        
        var outfit = Outfit.sampleManualOutfit()
        outfit.itemIds = [item1Id, item2Id]
        
        var state = OutfitDetailFeature.State(outfit: outfit)
        state.wardrobeItems = [item1, item2, item3]
        
        let outfitItems = state.outfitItems
        XCTAssertEqual(outfitItems.count, 2)
        XCTAssertTrue(outfitItems.contains(where: { $0.id == item1Id }))
        XCTAssertTrue(outfitItems.contains(where: { $0.id == item2Id }))
        XCTAssertFalse(outfitItems.contains(where: { $0.id == item3Id }))
    }
}


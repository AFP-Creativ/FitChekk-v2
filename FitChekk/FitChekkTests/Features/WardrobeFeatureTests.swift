//
//  WardrobeFeatureTests.swift
//  FitChekkTests
//
//  Comprehensive tests for WardrobeFeature using TCA TestStore
//

import ComposableArchitecture
import XCTest
import UIKit
@testable import FitChekk

@MainActor
final class WardrobeFeatureTests: XCTestCase {
    
    let testUserId = UUID()
    
    // MARK: - Lifecycle Tests
    
    func testOnAppear() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.onAppear)
        await store.receive(.fetchItems) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
    }
    
    func testRefresh() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.refresh)
        await store.receive(.fetchItems) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
    }
    
    // MARK: - Fetch Items Tests
    
    func testFetchItemsSuccess() async {
        let mockService = MockDatabaseService()
        let testItems = [
            WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees),
            WardrobeItem(userId: testUserId, category: .bottoms, subCategory: .jeans)
        ]
        mockService.wardrobeItems = testItems
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockService
        }
        
        await store.send(.fetchItems) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.fetchItemsResponse(.success(testItems))) {
            $0.isLoading = false
            $0.items = testItems
            $0.filteredItems = testItems
        }
    }
    
    func testFetchItemsFailure() async {
        let mockService = MockDatabaseService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockService
        }
        
        await store.send(.fetchItems) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.fetchItemsResponse(.failure(.networkError))) {
            $0.isLoading = false
            $0.errorMessage = "Check your internet connection and try again"
        }
    }
    
    // MARK: - Add Item Tests
    
    func testAddItemSuccess() async {
        let mockDatabaseService = MockDatabaseService()
        let mockStorageService = MockStorageService()
        
        let testItem = WardrobeItem(
            userId: testUserId,
            name: "Test Item",
            category: .tops,
            subCategory: .basicTees,
            colors: ["Blue"]
        )
        let testImage = UIImage(systemName: "photo")!
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockDatabaseService
            $0.storageService = mockStorageService
        }
        
        await store.send(.addItem(testItem, testImage)) {
            $0.isAddingItem = true
            $0.errorMessage = nil
        }
        
        await store.receive(.addItemResponse(.success(testItem))) {
            $0.isAddingItem = false
            $0.items.append(testItem)
            $0.filteredItems = $0.items
            $0.isAddItemSheetPresented = false
        }
    }
    
    func testAddItemFailure() async {
        let mockDatabaseService = MockDatabaseService()
        mockDatabaseService.shouldThrowError = true
        mockDatabaseService.errorToThrow = .networkError
        
        let mockStorageService = MockStorageService()
        
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        let testImage = UIImage(systemName: "photo")!
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockDatabaseService
            $0.storageService = mockStorageService
        }
        
        await store.send(.addItem(testItem, testImage)) {
            $0.isAddingItem = true
            $0.errorMessage = nil
        }
        
        await store.receive(.addItemResponse(.failure(.networkError))) {
            $0.isAddingItem = false
            $0.errorMessage = "Check your internet connection and try again"
        }
    }
    
    // MARK: - Update Item Tests
    
    func testUpdateItemSuccess() async {
        let mockDatabaseService = MockDatabaseService()
        let mockStorageService = MockStorageService()
        
        let existingItem = WardrobeItem(
            userId: testUserId,
            name: "Original Name",
            category: .tops,
            subCategory: .basicTees
        )
        
        var updatedItem = existingItem
        updatedItem.name = "Updated Name"
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId, items: [existingItem])
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockDatabaseService
            $0.storageService = mockStorageService
        }
        
        // Set initial filtered items
        store.state.filteredItems = [existingItem]
        
        await store.send(.updateItem(updatedItem, nil)) {
            $0.isUpdatingItem = true
            $0.errorMessage = nil
        }
        
        await store.receive(.updateItemResponse(.success(updatedItem))) {
            $0.isUpdatingItem = false
            $0.items[0] = updatedItem
            $0.filteredItems = $0.items
            $0.isEditItemSheetPresented = false
            $0.selectedItem = nil
        }
    }
    
    // MARK: - Delete Item Tests
    
    func testDeleteItemConfirmation() async {
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.deleteItem(testItem)) {
            $0.itemToDelete = testItem
            $0.showDeleteConfirmation = true
        }
    }
    
    func testDeleteItemSuccess() async {
        let mockDatabaseService = MockDatabaseService()
        let mockStorageService = MockStorageService()
        
        let testItem = WardrobeItem(
            userId: testUserId,
            category: .tops,
            subCategory: .basicTees,
            imageURL: "test/path.jpg",
            thumbnailURL: "test/thumbnails/path.jpg"
        )
        
        let store = TestStore(
            initialState: WardrobeFeature.State(
                userId: testUserId,
                items: [testItem],
                itemToDelete: testItem
            )
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockDatabaseService
            $0.storageService = mockStorageService
        }
        
        store.state.filteredItems = [testItem]
        
        await store.send(.confirmDelete) {
            $0.isDeletingItem = true
            $0.showDeleteConfirmation = false
            $0.errorMessage = nil
        }
        
        await store.receive(.deleteItemResponse(.success(()))) {
            $0.isDeletingItem = false
            $0.items.removeAll()
            $0.filteredItems = []
            $0.itemToDelete = nil
            $0.selectedItem = nil
        }
    }
    
    func testCancelDelete() async {
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        
        let store = TestStore(
            initialState: WardrobeFeature.State(
                userId: testUserId,
                itemToDelete: testItem,
                showDeleteConfirmation: true
            )
        ) {
            WardrobeFeature()
        }
        
        await store.send(.cancelDelete) {
            $0.showDeleteConfirmation = false
            $0.itemToDelete = nil
        }
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavorite() async {
        let mockDatabaseService = MockDatabaseService()
        
        let testItem = WardrobeItem(
            userId: testUserId,
            category: .tops,
            subCategory: .basicTees,
            isFavorite: false
        )
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId, items: [testItem])
        ) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = mockDatabaseService
        }
        
        store.state.filteredItems = [testItem]
        
        await store.send(.toggleFavorite(testItem)) {
            $0.items[0].isFavorite = true
            $0.filteredItems[0].isFavorite = true
        }
        
        // Verify the updated item is sent to database
        await store.receive(.updateItemResponse(.success($0.items[0])))
    }
    
    // MARK: - Search Tests
    
    func testSearchQueryChanged() async {
        let items = [
            WardrobeItem(userId: testUserId, name: "Blue Shirt", category: .tops, subCategory: .basicTees),
            WardrobeItem(userId: testUserId, name: "Red Pants", category: .bottoms, subCategory: .jeans),
            WardrobeItem(userId: testUserId, name: "Blue Jacket", category: .outerwear, subCategory: .jackets)
        ]
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId, items: items)
        ) {
            WardrobeFeature()
        }
        
        store.state.filteredItems = items
        
        await store.send(.searchQueryChanged("Blue")) {
            $0.searchQuery = "Blue"
            $0.filteredItems = items.filter { $0.name?.lowercased().contains("blue") == true }
        }
        
        XCTAssertEqual(store.state.filteredItems.count, 2)
    }
    
    func testSearchQueryClear() async {
        let items = [
            WardrobeItem(userId: testUserId, name: "Blue Shirt", category: .tops, subCategory: .basicTees),
            WardrobeItem(userId: testUserId, name: "Red Pants", category: .bottoms, subCategory: .jeans)
        ]
        
        let store = TestStore(
            initialState: WardrobeFeature.State(
                userId: testUserId,
                items: items,
                searchQuery: "Blue"
            )
        ) {
            WardrobeFeature()
        }
        
        store.state.filteredItems = [items[0]]
        
        await store.send(.searchQueryChanged("")) {
            $0.searchQuery = ""
            $0.filteredItems = items
        }
    }
    
    // MARK: - Filter Tests
    
    func testCategoryFilterChanged() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.categoryFilterChanged(.tops)) {
            $0.selectedCategory = .tops
        }
        
        await store.send(.categoryFilterChanged(nil)) {
            $0.selectedCategory = nil
        }
    }
    
    func testToggleFavoritesFilter() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.toggleFavoritesFilter) {
            $0.showFavoritesOnly = true
        }
        
        await store.send(.toggleFavoritesFilter) {
            $0.showFavoritesOnly = false
        }
    }
    
    func testToggleRecentlyWornFilter() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.toggleRecentlyWornFilter) {
            $0.showRecentlyWornOnly = true
        }
        
        await store.send(.toggleRecentlyWornFilter) {
            $0.showRecentlyWornOnly = false
        }
    }
    
    func testClearFilters() async {
        let items = [
            WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        ]
        
        let store = TestStore(
            initialState: WardrobeFeature.State(
                userId: testUserId,
                items: items,
                searchQuery: "test",
                selectedCategory: .tops,
                showFavoritesOnly: true,
                showRecentlyWornOnly: true
            )
        ) {
            WardrobeFeature()
        }
        
        await store.send(.clearFilters) {
            $0.selectedCategory = nil
            $0.showFavoritesOnly = false
            $0.showRecentlyWornOnly = false
            $0.searchQuery = ""
            $0.filteredItems = items
        }
    }
    
    // MARK: - Navigation Tests
    
    func testAddItemTapped() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.addItemTapped) {
            $0.isAddItemSheetPresented = true
        }
    }
    
    func testDismissAddItem() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId, isAddItemSheetPresented: true)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.dismissAddItem) {
            $0.isAddItemSheetPresented = false
        }
    }
    
    func testSelectItem() async {
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.selectItem(testItem)) {
            $0.selectedItem = testItem
        }
    }
    
    func testEditItemTapped() async {
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.editItemTapped(testItem)) {
            $0.selectedItem = testItem
            $0.isEditItemSheetPresented = true
        }
    }
    
    func testDismissEditItem() async {
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        
        let store = TestStore(
            initialState: WardrobeFeature.State(
                userId: testUserId,
                isEditItemSheetPresented: true,
                selectedItem: testItem
            )
        ) {
            WardrobeFeature()
        }
        
        await store.send(.dismissEditItem) {
            $0.isEditItemSheetPresented = false
            $0.selectedItem = nil
        }
    }
    
    func testDeselectItem() async {
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId, selectedItem: testItem)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.deselectItem) {
            $0.selectedItem = nil
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testClearError() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId, errorMessage: "Test error")
        ) {
            WardrobeFeature()
        }
        
        await store.send(.clearError) {
            $0.errorMessage = nil
        }
    }
    
    func testSetError() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(userId: testUserId)
        ) {
            WardrobeFeature()
        }
        
        await store.send(.setError("Test error")) {
            $0.errorMessage = "Test error"
        }
    }
    
    // MARK: - Computed Properties Tests
    
    func testDisplayedItemsWithFilters() {
        let items = [
            WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees, isFavorite: true),
            WardrobeItem(userId: testUserId, category: .bottoms, subCategory: .jeans, isFavorite: false),
            WardrobeItem(userId: testUserId, category: .tops, subCategory: .sweaters, isFavorite: true)
        ]
        
        var state = WardrobeFeature.State(userId: testUserId, items: items)
        state.filteredItems = items
        
        // Test category filter
        state.selectedCategory = .tops
        XCTAssertEqual(state.displayedItems.count, 2)
        
        // Test favorites filter
        state.selectedCategory = nil
        state.showFavoritesOnly = true
        XCTAssertEqual(state.displayedItems.count, 2)
        
        // Test combined filters
        state.selectedCategory = .tops
        state.showFavoritesOnly = true
        XCTAssertEqual(state.displayedItems.count, 2)
    }
    
    func testIsEmpty() {
        var state = WardrobeFeature.State(userId: testUserId)
        XCTAssertTrue(state.isEmpty)
        
        state.items = [WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)]
        XCTAssertFalse(state.isEmpty)
    }
    
    func testHasNoResults() {
        let items = [
            WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        ]
        
        var state = WardrobeFeature.State(userId: testUserId, items: items)
        state.filteredItems = []
        state.selectedCategory = .bottoms
        
        XCTAssertTrue(state.hasNoResults)
    }
}


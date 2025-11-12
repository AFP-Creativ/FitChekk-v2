//
//  WardrobeFeature.swift
//  FitChekk
//
//  Wardrobe feature handling item CRUD, search, and filters
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct WardrobeFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        // Items
        var items: [WardrobeItem] = []
        var filteredItems: [WardrobeItem] = []

        // Loading States
        var isLoading = false
        var isAddingItem = false
        var isUpdatingItem = false
        var isDeletingItem = false

        // Search & Filters
        var searchQuery = ""
        var selectedCategory: ItemCategory?
        var showFavoritesOnly = false
        var showRecentlyWornOnly = false

        // Sheet Presentations
        var isAddItemSheetPresented = false
        var isEditItemSheetPresented = false
        var selectedItem: WardrobeItem?

        // Error Handling
        var errorMessage: String?
        var showDeleteConfirmation = false
        var itemToDelete: WardrobeItem?

        // User ID (from authenticated user)
        var userId: UUID

        // Computed Properties
        var displayedItems: [WardrobeItem] {
            var items = filteredItems.isEmpty && searchQuery.isEmpty ? self.items : filteredItems

            // Apply filters
            if let category = selectedCategory {
                items = items.filter { $0.categoryEnum == category }
            }

            if showFavoritesOnly {
                items = items.filter { $0.isFavorite }
            }

            if showRecentlyWornOnly {
                items = items.filter { $0.isRecentlyWorn }
            }

            return items.sorted { $0.createdAt > $1.createdAt }
        }

        var isEmpty: Bool {
            items.isEmpty
        }

        var hasNoResults: Bool {
            !items.isEmpty && displayedItems.isEmpty
        }
    }

    // MARK: - Actions

    enum Action {
        // Lifecycle
        case onAppear
        case refresh

        // Item CRUD
        case fetchItems
        case fetchItemsResponse(Result<[WardrobeItem], DatabaseError>)
        case addItem(WardrobeItem, UIImage)
        case addItemResponse(Result<WardrobeItem, DatabaseError>)
        case updateItem(WardrobeItem, UIImage?)
        case updateItemResponse(Result<WardrobeItem, DatabaseError>)
        case deleteItem(WardrobeItem)
        case confirmDelete
        case cancelDelete
        case deleteItemResponse(Result<Void, DatabaseError>)
        case toggleFavorite(WardrobeItem)

        // Search & Filters
        case searchQueryChanged(String)
        case categoryFilterChanged(ItemCategory?)
        case toggleFavoritesFilter
        case toggleRecentlyWornFilter
        case clearFilters

        // Navigation
        case addItemTapped
        case dismissAddItem
        case selectItem(WardrobeItem)
        case editItemTapped(WardrobeItem)
        case dismissEditItem
        case deselectItem

        // Error Handling
        case clearError
        case setError(String)
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.databaseService) var databaseService
    @Dependency(\.storageService) var storageService
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // MARK: - Lifecycle
            case .onAppear:
                return .send(.fetchItems)

            case .refresh:
                return .send(.fetchItems)

            // MARK: - Fetch Items
            case .fetchItems:
                state.isLoading = true
                state.errorMessage = nil

                let userId = state.userId

                return .run { send in
                    let result = await Result {
                        try await databaseService.fetchWardrobeItems(userId: userId)
                    }
                    await send(.fetchItemsResponse(result.mapError { $0 as? DatabaseError ?? .networkError }))
                }

            case let .fetchItemsResponse(.success(items)):
                state.isLoading = false
                state.items = items
                state.filteredItems = items
                return .none

            case let .fetchItemsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.userFriendlyMessage
                return .none

            // MARK: - Add Item
            case let .addItem(item, image):
                state.isAddingItem = true
                state.errorMessage = nil

                return .run { send in
                    let result = await Result {
                        // Upload full-size image
                        let imagePath = try await storageService.uploadImage(
                            image.jpegData(compressionQuality: 0.8) ?? Data(),
                            userId: item.userId,
                            itemId: item.id
                        )

                        // Generate and upload thumbnail
                        let thumbnail = image.preparingThumbnail(of: CGSize(width: 300, height: 300))
                        let thumbnailPath = try await storageService.uploadThumbnail(
                            thumbnail?.jpegData(compressionQuality: 0.8) ?? Data(),
                            userId: item.userId,
                            itemId: item.id
                        )

                        // Update item with image URLs
                        let updatedItem = item
                        updatedItem.imageURL = storageService.getPublicURL(path: imagePath)
                        updatedItem.thumbnailURL = storageService.getPublicURL(path: thumbnailPath)

                        // Save to database
                        return try await databaseService.createWardrobeItem(updatedItem)
                    }
                    await send(.addItemResponse(result.mapError { $0 as? DatabaseError ?? .networkError }))
                }

            case let .addItemResponse(.success(item)):
                state.isAddingItem = false
                state.items.append(item)
                state.filteredItems = state.items
                state.isAddItemSheetPresented = false
                return .none

            case let .addItemResponse(.failure(error)):
                state.isAddingItem = false
                state.errorMessage = error.userFriendlyMessage
                return .none

            // MARK: - Update Item
            case let .updateItem(item, image):
                state.isUpdatingItem = true
                state.errorMessage = nil

                return .run { send in
                    let result = await Result {
                        let updatedItem = item

                        // If new image provided, upload it
                        if let image = image {
                            // Delete old images if they exist
                            if let oldImageURL = item.imageURL {
                                try? await storageService.deleteImage(url: oldImageURL)
                            }
                            if let oldThumbnailURL = item.thumbnailURL {
                                try? await storageService.deleteImage(url: oldThumbnailURL)
                            }

                            // Upload new images
                            let imagePath = try await storageService.uploadImage(
                                image.jpegData(compressionQuality: 0.8) ?? Data(),
                                userId: item.userId,
                                itemId: item.id
                            )

                            let thumbnail = image.preparingThumbnail(of: CGSize(width: 300, height: 300))
                            let thumbnailPath = try await storageService.uploadThumbnail(
                                thumbnail?.jpegData(compressionQuality: 0.8) ?? Data(),
                                userId: item.userId,
                                itemId: item.id
                            )

                            updatedItem.imageURL = storageService.getPublicURL(path: imagePath)
                            updatedItem.thumbnailURL = storageService.getPublicURL(path: thumbnailPath)
                        }

                        // Update in database
                        return try await databaseService.updateWardrobeItem(updatedItem)
                    }
                    await send(.updateItemResponse(result.mapError { $0 as? DatabaseError ?? .networkError }))
                }

            case let .updateItemResponse(.success(item)):
                state.isUpdatingItem = false

                // Update item in array
                if let index = state.items.firstIndex(where: { $0.id == item.id }) {
                    state.items[index] = item
                }
                state.filteredItems = state.items
                state.isEditItemSheetPresented = false
                state.selectedItem = nil
                return .none

            case let .updateItemResponse(.failure(error)):
                state.isUpdatingItem = false
                state.errorMessage = error.userFriendlyMessage
                return .none

            // MARK: - Delete Item
            case let .deleteItem(item):
                state.itemToDelete = item
                state.showDeleteConfirmation = true
                return .none

            case .confirmDelete:
                guard let item = state.itemToDelete else { return .none }

                state.isDeletingItem = true
                state.showDeleteConfirmation = false
                state.errorMessage = nil

                return .run { send in
                    let result = await Result {
                        // Delete images from storage
                        if let imageURL = item.imageURL {
                            try? await storageService.deleteImage(url: imageURL)
                        }
                        if let thumbnailURL = item.thumbnailURL {
                            try? await storageService.deleteImage(url: thumbnailURL)
                        }

                        // Delete from database
                        try await databaseService.deleteWardrobeItem(id: item.id)
                    }
                    await send(.deleteItemResponse(result.mapError { $0 as? DatabaseError ?? .networkError }))
                }

            case .cancelDelete:
                state.showDeleteConfirmation = false
                state.itemToDelete = nil
                return .none

            case .deleteItemResponse(.success):
                state.isDeletingItem = false

                // Remove item from array
                if let item = state.itemToDelete {
                    state.items.removeAll { $0.id == item.id }
                    state.filteredItems = state.items
                }
                state.itemToDelete = nil
                state.selectedItem = nil
                return .none

            case let .deleteItemResponse(.failure(error)):
                state.isDeletingItem = false
                state.errorMessage = error.userFriendlyMessage
                state.itemToDelete = nil
                return .none

            // MARK: - Toggle Favorite
            case let .toggleFavorite(item):
                let updatedItem = item
                updatedItem.isFavorite.toggle()
                updatedItem.updatedAt = Date()

                // Optimistically update UI
                if let index = state.items.firstIndex(where: { $0.id == item.id }) {
                    state.items[index] = updatedItem
                    state.filteredItems = state.items
                }

                // Capture for async use
                let itemToUpdate = updatedItem
                return .run { send in
                    let result = await Result {
                        try await databaseService.updateWardrobeItem(itemToUpdate)
                    }
                    await send(.updateItemResponse(result.mapError { $0 as? DatabaseError ?? .networkError }))
                }

            // MARK: - Search & Filters
            case let .searchQueryChanged(query):
                state.searchQuery = query

                if query.isEmpty {
                    state.filteredItems = state.items
                } else {
                    let lowercasedQuery = query.lowercased()
                    state.filteredItems = state.items.filter { item in
                        item.displayName.lowercased().contains(lowercasedQuery) ||
                            item.brand?.lowercased().contains(lowercasedQuery) == true ||
                            item.categoryEnum.displayName.lowercased().contains(lowercasedQuery) ||
                            item.subCategoryEnum.displayName.lowercased().contains(lowercasedQuery) ||
                            item.colors.contains { $0.lowercased().contains(lowercasedQuery) }
                    }
                }
                return .none

            case let .categoryFilterChanged(category):
                state.selectedCategory = category
                return .none

            case .toggleFavoritesFilter:
                state.showFavoritesOnly.toggle()
                return .none

            case .toggleRecentlyWornFilter:
                state.showRecentlyWornOnly.toggle()
                return .none

            case .clearFilters:
                state.selectedCategory = nil
                state.showFavoritesOnly = false
                state.showRecentlyWornOnly = false
                state.searchQuery = ""
                state.filteredItems = state.items
                return .none

            // MARK: - Navigation
            case .addItemTapped:
                state.isAddItemSheetPresented = true
                return .none

            case .dismissAddItem:
                state.isAddItemSheetPresented = false
                return .none

            case let .selectItem(item):
                state.selectedItem = item
                return .none

            case let .editItemTapped(item):
                state.selectedItem = item
                state.isEditItemSheetPresented = true
                return .none

            case .dismissEditItem:
                state.isEditItemSheetPresented = false
                state.selectedItem = nil
                return .none

            case .deselectItem:
                state.selectedItem = nil
                return .none

            // MARK: - Error Handling
            case .clearError:
                state.errorMessage = nil
                return .none

            case let .setError(message):
                state.errorMessage = message
                return .none
            }
        }
    }
}

// MARK: - Equatable Conformance

extension WardrobeFeature.Action: Equatable {
    static func == (lhs: WardrobeFeature.Action, rhs: WardrobeFeature.Action) -> Bool {
        switch (lhs, rhs) {
        case (.onAppear, .onAppear),
             (.refresh, .refresh),
             (.fetchItems, .fetchItems),
             (.confirmDelete, .confirmDelete),
             (.cancelDelete, .cancelDelete),
             (.toggleFavoritesFilter, .toggleFavoritesFilter),
             (.toggleRecentlyWornFilter, .toggleRecentlyWornFilter),
             (.clearFilters, .clearFilters),
             (.addItemTapped, .addItemTapped),
             (.dismissAddItem, .dismissAddItem),
             (.dismissEditItem, .dismissEditItem),
             (.deselectItem, .deselectItem),
             (.clearError, .clearError):
            return true
            
        case let (.fetchItemsResponse(lhsResult), .fetchItemsResponse(rhsResult)):
            return lhsResult == rhsResult
        case let (.addItem(lhsItem, _), .addItem(rhsItem, _)):
            return lhsItem.id == rhsItem.id
        case let (.addItemResponse(lhsResult), .addItemResponse(rhsResult)):
            return lhsResult == rhsResult
        case let (.updateItem(lhsItem, _), .updateItem(rhsItem, _)):
            return lhsItem.id == rhsItem.id
        case let (.updateItemResponse(lhsResult), .updateItemResponse(rhsResult)):
            return lhsResult == rhsResult
        case let (.deleteItem(lhsItem), .deleteItem(rhsItem)):
            return lhsItem.id == rhsItem.id
        case let (.deleteItemResponse(lhsResult), .deleteItemResponse(rhsResult)):
            switch (lhsResult, rhsResult) {
            case (.success, .success):
                return true
            case let (.failure(lhsError), .failure(rhsError)):
                return lhsError == rhsError
            default:
                return false
            }
        case let (.toggleFavorite(lhsItem), .toggleFavorite(rhsItem)):
            return lhsItem.id == rhsItem.id
        case let (.searchQueryChanged(lhsQuery), .searchQueryChanged(rhsQuery)):
            return lhsQuery == rhsQuery
        case let (.categoryFilterChanged(lhsCat), .categoryFilterChanged(rhsCat)):
            return lhsCat == rhsCat
        case let (.selectItem(lhsItem), .selectItem(rhsItem)):
            return lhsItem.id == rhsItem.id
        case let (.editItemTapped(lhsItem), .editItemTapped(rhsItem)):
            return lhsItem.id == rhsItem.id
        case let (.setError(lhsMsg), .setError(rhsMsg)):
            return lhsMsg == rhsMsg
            
        default:
            return false
        }
    }
}

// MARK: - DatabaseError Extension

extension DatabaseError {
    var userFriendlyMessage: String {
        switch self {
        case .notImplemented:
            return "This feature isn't available yet"
        case .notFound:
            return "Item not found"
        case .invalidData:
            return "Something went wrong with the data"
        case .networkError:
            return "Check your internet connection and try again"
        case .unauthorized:
            return "You don't have permission to do that"
        case .conflict:
            return "This item already exists"
        }
    }
}

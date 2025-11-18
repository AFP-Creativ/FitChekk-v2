//
//  OutfitCreationFeature.swift
//  FitChekk
//
//  TCA reducer for manual outfit creation with item selection and validation
//

import SwiftUI
import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct OutfitCreationFeature {
    @ObservableState
    struct State: Equatable {
        // Selected items
        var selectedItems: [WardrobeItem] = []
        
        // Form fields
        var outfitName: String = ""
        var occasion: String?
        var season: String?
        var notes: String?
        
        // UI state
        var isSelectingItems: Bool = false
        var isSaving: Bool = false
        var errorMessage: String?
        var showUnsavedChangesAlert: Bool = false
        
        // Computed properties
        var isValid: Bool {
            !outfitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && selectedItems.count >= 2
        }
        
        var hasUnsavedChanges: Bool {
            !outfitName.isEmpty || !selectedItems.isEmpty || occasion != nil || season != nil || notes != nil
        }
        
        var validationError: String? {
            if outfitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Outfit name is required"
            }
            if selectedItems.count < 2 {
                return "Select at least 2 items"
            }
            return nil
        }
    }
    
    enum Action {
        // Lifecycle
        case onAppear
        
        // Form actions
        case outfitNameChanged(String)
        case occasionChanged(String?)
        case seasonChanged(String?)
        case notesChanged(String?)
        
        // Item management
        case addItemsTapped
        case itemsSelected([WardrobeItem])
        case removeItem(UUID)
        case reorderItems(IndexSet, Int)
        case dismissItemPicker
        
        // Save/Cancel
        case saveTapped
        case saveResponse(Result<Outfit, Error>)
        case cancelTapped
        case confirmCancel
        case dismissUnsavedChangesAlert
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case outfitSaved(Outfit)
            case cancelled
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case let .outfitNameChanged(name):
                state.outfitName = name
                state.errorMessage = nil
                return .none
                
            case let .occasionChanged(occasion):
                state.occasion = occasion
                return .none
                
            case let .seasonChanged(season):
                state.season = season
                return .none
                
            case let .notesChanged(notes):
                state.notes = notes
                return .none
                
            case .addItemsTapped:
                state.isSelectingItems = true
                return .none
                
            case let .itemsSelected(items):
                // Add items that aren't already selected
                let existingIds = Set(state.selectedItems.map { $0.id })
                let newItems = items.filter { !existingIds.contains($0.id) }
                state.selectedItems.append(contentsOf: newItems)
                state.isSelectingItems = false
                state.errorMessage = nil
                return .none
                
            case let .removeItem(itemId):
                state.selectedItems.removeAll { $0.id == itemId }
                return .none
                
            case let .reorderItems(source, destination):
                state.selectedItems.move(fromOffsets: source, toOffset: destination)
                return .none
                
            case .dismissItemPicker:
                state.isSelectingItems = false
                return .none
                
            case .saveTapped:
                guard state.isValid else {
                    state.errorMessage = state.validationError
                    return .none
                }
                
                state.isSaving = true
                state.errorMessage = nil
                
                let name = state.outfitName.trimmingCharacters(in: .whitespacesAndNewlines)
                let occasion = state.occasion
                let season = state.season
                let notes = state.notes
                let itemIds = state.selectedItems.map { $0.id }
                
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
                
            case let .saveResponse(.success(outfit)):
                state.isSaving = false
                return .run { send in
                    @Dependency(\.dismiss) var dismiss
                    await send(.delegate(.outfitSaved(outfit)))
                    await dismiss()
                }
                
            case .saveResponse(.failure):
                state.isSaving = false
                state.errorMessage = "Failed to save outfit. Please try again."
                return .none
                
            case .cancelTapped:
                if state.hasUnsavedChanges {
                    state.showUnsavedChangesAlert = true
                    return .none
                } else {
                    return .run { send in
                        @Dependency(\.dismiss) var dismiss
                        await send(.delegate(.cancelled))
                        await dismiss()
                    }
                }
                
            case .confirmCancel:
                state.showUnsavedChangesAlert = false
                return .run { send in
                    @Dependency(\.dismiss) var dismiss
                    await send(.delegate(.cancelled))
                    await dismiss()
                }
                
            case .dismissUnsavedChangesAlert:
                state.showUnsavedChangesAlert = false
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

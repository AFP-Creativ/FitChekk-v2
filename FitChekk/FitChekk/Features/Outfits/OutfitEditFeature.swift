//
//  OutfitEditFeature.swift
//  FitChekk
//
//  TCA reducer for editing existing outfits
//

import SwiftUI
import ComposableArchitecture
import Foundation
import UIKit

// TODO: Fix dependency type inference issue preventing @Dependency declarations
// Currently using minimal stub implementation

@Reducer
struct OutfitEditFeature {
    @ObservableState
    struct State: Equatable {
        var outfit: Outfit
        
        // Form fields (editable)
        var selectedItems: [WardrobeItem]
        var outfitName: String
        var occasion: String?
        var season: String?
        var notes: String?
        
        // UI state
        var isSelectingItems: Bool = false
        var isSaving: Bool = false
        var errorMessage: String?
        var showUnsavedChangesAlert: Bool = false
        
        init(outfit: Outfit) {
            self.outfit = outfit
            self.outfitName = outfit.name
            self.occasion = outfit.occasion
            self.season = outfit.season
            self.notes = outfit.notes
            self.selectedItems = []
        }
        
        // Computed properties
        var isValid: Bool {
            !outfitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && selectedItems.count >= 2
        }
        
        var hasUnsavedChanges: Bool {
            outfitName != outfit.name ||
            occasion != outfit.occasion ||
            season != outfit.season ||
            notes != outfit.notes ||
            Set(selectedItems.map { $0.id }) != Set(outfit.itemIds)
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
        case dismissItemPicker
        
        // Save/Cancel
        case saveTapped
        case cancelTapped
        case confirmCancel
        case dismissUnsavedChangesAlert
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case outfitUpdated(Outfit)
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
                state.selectedItems = items
                state.isSelectingItems = false
                return .none
                
            case let .removeItem(id):
                state.selectedItems.removeAll { $0.id == id }
                return .none
                
            case .dismissItemPicker:
                state.isSelectingItems = false
                return .none
                
            case .saveTapped:
                // TODO: Implement save functionality when dependency issue is resolved
                return .run { send in
                    await send(.delegate(.cancelled))
                }
                
            case .cancelTapped:
                if state.hasUnsavedChanges {
                    state.showUnsavedChangesAlert = true
                    return .none
                }
                return .run { send in
                    await send(.delegate(.cancelled))
                }
                
            case .confirmCancel:
                state.showUnsavedChangesAlert = false
                return .run { send in
                    await send(.delegate(.cancelled))
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

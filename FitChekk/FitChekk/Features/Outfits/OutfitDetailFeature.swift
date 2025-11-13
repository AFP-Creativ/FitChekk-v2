//
//  OutfitDetailFeature.swift
//  FitChekk
//
//  TCA reducer for outfit detail view with edit, delete, and wear tracking
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct OutfitDetailFeature {
    @ObservableState
    struct State: Equatable {
        var outfit: Outfit
        var wardrobeItems: [WardrobeItem] = []
        
        // UI state
        var isLoadingItems: Bool = false
        var isUpdating: Bool = false
        var errorMessage: String?
        
        // Navigation
        // TODO: Re-enable after fixing dependency resolution
        // @Presents var outfitEdit: OutfitEditFeature.State?
        
        // Computed properties
        var outfitItems: [WardrobeItem] {
            let itemIds = Set(outfit.itemIds)
            return wardrobeItems.filter { itemIds.contains($0.id) }
        }
    }
    
    enum Action {
        // Lifecycle
        case onAppear
        case loadWardrobeItems
        case wardrobeItemsResponse(Result<[WardrobeItem], Error>)
        
        // Wear tracking
        case markAsWornTapped
        case markAsWornResponse(Result<Outfit, Error>)
        
        // Rating
        case ratingChanged(Int)
        case ratingResponse(Result<Outfit, Error>)
        
        // Navigation
        case editTapped
        // TODO: Re-enable after fixing dependency resolution
        // case outfitEdit(PresentationAction<OutfitEditFeature.Action>)
        case deleteTapped
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case outfitDeleted
            case outfitUpdated
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.wardrobeItems.isEmpty {
                    return .send(.loadWardrobeItems)
                }
                return .none
                
            case .loadWardrobeItems:
                state.isLoadingItems = true
                
                // Simplified implementation - loading is handled by parent feature
                return .run { send in
                    await send(.wardrobeItemsResponse(.success([])))
                }
                
            case let .wardrobeItemsResponse(.success(items)):
                state.isLoadingItems = false
                state.wardrobeItems = items
                return .none
                
            case let .wardrobeItemsResponse(.failure(error)):
                state.isLoadingItems = false
                state.errorMessage = "Failed to load items"
                return .none
                
            case .markAsWornTapped:
                state.isUpdating = true
                
                // Update wear statistics directly in state
                state.outfit.timesWorn += 1
                state.outfit.lastWornDate = Date()
                
                let updatedOutfit = state.outfit
                return .run { send in
                    await send(.markAsWornResponse(.success(updatedOutfit)))
                }
                
            case let .markAsWornResponse(.success(outfit)):
                state.isUpdating = false
                state.outfit = outfit
                return .none
                
            case let .markAsWornResponse(.failure(error)):
                state.isUpdating = false
                state.errorMessage = "Failed to update outfit"
                return .none
                
            case let .ratingChanged(rating):
                state.isUpdating = true
                
                // Update rating directly in state
                state.outfit.userRating = rating
                
                let updatedOutfit = state.outfit
                return .run { send in
                    await send(.ratingResponse(.success(updatedOutfit)))
                }
                
            case let .ratingResponse(.success(outfit)):
                state.isUpdating = false
                state.outfit = outfit
                return .none
                
            case let .ratingResponse(.failure(error)):
                state.isUpdating = false
                state.errorMessage = "Failed to update rating"
                return .none
                
            case .editTapped:
                // TODO: Re-enable after fixing dependency resolution
                // state.outfitEdit = OutfitEditFeature.State(outfit: state.outfit)
                return .none
                
            // TODO: Re-enable after fixing dependency resolution
            // case .outfitEdit(.presented(.delegate(.outfitUpdated(let updatedOutfit)))):
            //     state.outfit = updatedOutfit
            //     state.outfitEdit = nil
            //     return .run { send in
            //         await send(.delegate(.outfitUpdated))
            //     }
            //     
            // case .outfitEdit(.presented(.delegate(.cancelled))):
            //     state.outfitEdit = nil
            //     return .none
            //     
            // case .outfitEdit:
            //     return .none
                
            case .deleteTapped:
                return .run { send in
                    await send(.delegate(.outfitDeleted))
                }
                
            case .delegate:
                return .none
            }
        }
        // Temporarily commented out for compilation
        // .ifLet(\.$outfitEdit, action: \.outfitEdit) {
        //     OutfitEditFeature()
        // }
    }
}

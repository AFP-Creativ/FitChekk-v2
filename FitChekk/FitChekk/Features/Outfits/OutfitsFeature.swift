//
//  OutfitsFeature.swift
//  FitChekk
//
//  TCA reducer for outfit collection management with filters and navigation
//

import ComposableArchitecture
import Dependencies
import Foundation
import UIKit

// MARK: - Outfit Filters

struct OutfitFilters: Equatable {
    var occasion: String?
    var season: Season?
    var showAIOnly: Bool = false
    var showManualOnly: Bool = false
    
    var isActive: Bool {
        occasion != nil || season != nil || showAIOnly || showManualOnly
    }
}

// MARK: - Outfits Feature

@Reducer
struct OutfitsFeature {
    @ObservableState
    struct State: Equatable {
        // Data
        var outfits: [Outfit] = []
        var selectedFilters: OutfitFilters = OutfitFilters()
        
        // UI state
        var isLoading: Bool = false
        var errorMessage: String?
        
        // Navigation
        var isCreatingOutfit: Bool = false
        @Presents var outfitCreation: OutfitCreationFeature.State?
        @Presents var outfitDetail: OutfitDetailFeature.State?
        
        // Delete confirmation
        var outfitToDelete: Outfit?
        var showDeleteAlert: Bool = false
        
        // Computed properties
        var filteredOutfits: [Outfit] {
            var filtered = outfits
            
            // Apply filters
            if let occasion = selectedFilters.occasion {
                filtered = filtered.filter { $0.occasion == occasion }
            }
            
            if let season = selectedFilters.season {
                filtered = filtered.filter { $0.season == season.rawValue }
            }
            
            if selectedFilters.showAIOnly {
                filtered = filtered.filter { $0.aiGenerated }
            }
            
            if selectedFilters.showManualOnly {
                filtered = filtered.filter { !$0.aiGenerated }
            }
            
            // Sort by creation date (newest first)
            return filtered.sorted { $0.createdAt > $1.createdAt }
        }
        
        var occasionCounts: [String: Int] {
            var counts: [String: Int] = [:]
            for outfit in outfits {
                if let occasion = outfit.occasion {
                    counts[occasion, default: 0] += 1
                }
            }
            return counts
        }
        
        var seasonCounts: [Season: Int] {
            var counts: [Season: Int] = [:]
            for outfit in outfits {
                if let seasonStr = outfit.season, let season = Season(rawValue: seasonStr) {
                    counts[season, default: 0] += 1
                }
            }
            return counts
        }
        
        var aiGeneratedCount: Int {
            outfits.filter { $0.aiGenerated }.count
        }
        
        var manualCount: Int {
            outfits.filter { !$0.aiGenerated }.count
        }
    }
    
    enum Action {
        // Lifecycle
        case onAppear
        case refresh
        
        // Data fetching
        case fetchOutfits
        case outfitsResponse(Result<[Outfit], Error>)
        
        // Filters
        case filterByOccasion(String?)
        case filterBySeason(Season?)
        case toggleAIOnly
        case toggleManualOnly
        case clearFilters
        
        // Navigation
        case createOutfitTapped
        case outfitCreation(PresentationAction<OutfitCreationFeature.Action>)
        case outfitTapped(Outfit)
        case outfitDetail(PresentationAction<OutfitDetailFeature.Action>)
        
        // Delete
        case deleteOutfitTapped(Outfit)
        case confirmDelete
        case cancelDelete
        case deleteResponse(Result<Void, Error>)
    }

    // MARK: - Dependencies

    @Dependency(\.authService) var authService
    // Note: databaseService accessed inline in each .run closure due to Swift 6 macro issue

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.outfits.isEmpty {
                    return .send(.fetchOutfits)
                }
                return .none
                
            case .refresh:
                return .send(.fetchOutfits)
                
            case .fetchOutfits:
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    await withDependencies {
                        $0.context = .live
                    } operation: {
                        do {
                            guard let user = try await authService.getCurrentUser() else {
                                let userInfo = [NSLocalizedDescriptionKey: "Unauthorized"]
                                let error = NSError(domain: "Outfits", code: 401, userInfo: userInfo)
                                await send(.outfitsResponse(.failure(error)))
                                return
                            }

                            let database = LiveDatabaseService()
                            let outfits = try await database.fetchOutfits(userId: user.id)
                            await send(.outfitsResponse(.success(outfits)))
                        } catch {
                            await send(.outfitsResponse(.failure(error)))
                        }
                    }
                }
                
            case let .outfitsResponse(.success(outfits)):
                state.isLoading = false
                state.outfits = outfits
                return .none
                
            case let .outfitsResponse(.failure(error)):
                state.isLoading = false
                // if let dbError = error as? DatabaseError {
                //     state.errorMessage = dbError.userFriendlyMessage
                // } else {
                    state.errorMessage = "Failed to load outfits. Please try again."
                // }
                return .none
                
            case let .filterByOccasion(occasion):
                state.selectedFilters.occasion = occasion
                return .none
                
            case let .filterBySeason(season):
                state.selectedFilters.season = season
                return .none
                
            case .toggleAIOnly:
                state.selectedFilters.showAIOnly.toggle()
                if state.selectedFilters.showAIOnly {
                    state.selectedFilters.showManualOnly = false
                }
                return .none
                
            case .toggleManualOnly:
                state.selectedFilters.showManualOnly.toggle()
                if state.selectedFilters.showManualOnly {
                    state.selectedFilters.showAIOnly = false
                }
                return .none
                
            case .clearFilters:
                state.selectedFilters = OutfitFilters()
                return .none
                
            case .createOutfitTapped:
                state.outfitCreation = OutfitCreationFeature.State()
                return .none
                
            case .outfitCreation(.presented(.delegate(.outfitSaved))):
                state.outfitCreation = nil
                // Refresh outfits list
                return .send(.fetchOutfits)
                
            case .outfitCreation(.presented(.delegate(.cancelled))):
                state.outfitCreation = nil
                return .none
                
            case .outfitCreation:
                return .none
                
            case let .outfitTapped(outfit):
                state.outfitDetail = OutfitDetailFeature.State(outfit: outfit)
                return .none
                
            case .outfitDetail(.presented(.delegate(.outfitDeleted))):
                state.outfitDetail = nil
                return .send(.fetchOutfits)
                
            case .outfitDetail(.presented(.delegate(.outfitUpdated))):
                state.outfitDetail = nil
                return .send(.fetchOutfits)
                
            case .outfitDetail:
                return .none
                
            case let .deleteOutfitTapped(outfit):
                state.outfitToDelete = outfit
                state.showDeleteAlert = true
                return .none
                
            case .confirmDelete:
                guard let outfit = state.outfitToDelete else {
                    state.showDeleteAlert = false
                    return .none
                }
                
                state.showDeleteAlert = false
                state.isLoading = true
                
                let outfitId = outfit.id

                return .run { send in
                    @Dependency(\.databaseService) var db
                    do {
                        guard let user = try await authService.getCurrentUser() else {
                            let userInfo = [NSLocalizedDescriptionKey: "Unauthorized"]
                            let error = NSError(domain: "Outfits", code: 401, userInfo: userInfo)
                            throw error
                        }

                        try await db.deleteOutfit(id: outfitId)
                        await send(.deleteResponse(.success(())))
                    } catch {
                        await send(.deleteResponse(.failure(error)))
                    }
                }
                
            case .cancelDelete:
                state.showDeleteAlert = false
                state.outfitToDelete = nil
                return .none
                
            case .deleteResponse(.success):
                state.isLoading = false
                state.outfitToDelete = nil
                return .send(.fetchOutfits)
                
            case let .deleteResponse(.failure(error)):
                state.isLoading = false
                state.outfitToDelete = nil
                // if let dbError = error as? DatabaseError {
                //     state.errorMessage = dbError.userFriendlyMessage
                // } else {
                    state.errorMessage = "Failed to delete outfit. Please try again."
                // }
                return .none
            }
        }
        .ifLet(\.$outfitCreation, action: \.outfitCreation) {
            OutfitCreationFeature()
        }
        .ifLet(\.$outfitDetail, action: \.outfitDetail) {
            OutfitDetailFeature()
        }
    }
}

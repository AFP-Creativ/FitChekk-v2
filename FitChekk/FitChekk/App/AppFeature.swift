//
//  AppFeature.swift
//  FitChekk
//
//  Root TCA feature managing app-level state and navigation
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        // Authentication
        var isAuthenticated = false
        var currentUserId: UUID?

        // Navigation
        var selectedTab: Tab = .home

        // Feature States (will be added as we build features)
        // var home: HomeFeature.State = .init()
        // var wardrobe: WardrobeFeature.State = .init()
        // var outfits: OutfitsFeature.State = .init()
        // var planner: PlannerFeature.State = .init()
        // var settings: SettingsFeature.State = .init()

        // Authentication flow
        // @Presents var authentication: AuthenticationFeature.State?

        // Loading state
        var isLoading = false
    }

    // MARK: - Actions

    enum Action: Equatable {
        // Lifecycle
        case onAppear
        case checkAuthStatus

        // Authentication
        case authStatusChecked(UUID?)
        // case authentication(PresentationAction<AuthenticationFeature.Action>)
        case signOut

        // Navigation
        case tabSelected(Tab)

        // Feature Actions (will be added as we build features)
        // case home(HomeFeature.Action)
        // case wardrobe(WardrobeFeature.Action)
        // case outfits(OutfitsFeature.Action)
        // case planner(PlannerFeature.Action)
        // case settings(SettingsFeature.Action)
    }

    // MARK: - Tab Enum

    enum Tab: String, CaseIterable, Equatable {
        case home, wardrobe, outfits, planner, settings

        var title: String { rawValue.capitalized }

        var icon: String {
            switch self {
            case .home: return "house"
            case .wardrobe: return "tshirt"
            case .outfits: return "hanger"
            case .planner: return "calendar"
            case .settings: return "gear"
            }
        }

        var iconFilled: String {
            switch self {
            case .home: return "house.fill"
            case .wardrobe: return "tshirt.fill"
            case .outfits: return "hanger"
            case .planner: return "calendar"
            case .settings: return "gearshape.fill"
            }
        }
    }

    // MARK: - Dependencies (will be configured later)
    // @Dependency(\.authService) var authService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.checkAuthStatus)

            case .checkAuthStatus:
                state.isLoading = true
                // TODO: Implement auth check when AuthService is ready
                return .run { send in
                    // Simulate auth check for now
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.authStatusChecked(nil))
                }

            case let .authStatusChecked(userId):
                state.isLoading = false
                state.currentUserId = userId
                state.isAuthenticated = userId != nil
                return .none

            case .signOut:
                state.isAuthenticated = false
                state.currentUserId = nil
                return .none

            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}

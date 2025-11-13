//
//  AppFeature.swift
//  FitChekk
//
//  Root TCA feature managing app-level state and navigation
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct AppFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        // Authentication
        var isAuthenticated = false
        var currentUserId: UUID?
        var currentUser: User?

        // Navigation
        var selectedTab: Tab = .home

        // Feature States
        // var home: HomeFeature.State = .init()
        // var wardrobe: WardrobeFeature.State = .init()
        var outfits: OutfitsFeature.State = .init()
        // var planner: PlannerFeature.State = .init()
        // var settings: SettingsFeature.State = .init()

        // Authentication flow
        @Presents var authentication: AuthenticationFeature.State?

        // Loading state
        var isLoading = false
    }

    // MARK: - Actions

    enum Action {
        // Lifecycle
        case onAppear
        case checkAuthStatus

        // Authentication
        case authStatusChecked(User?)
        case authentication(PresentationAction<AuthenticationFeature.Action>)
        case presentAuthentication
        case signOut

        // Navigation
        case tabSelected(Tab)

        // Feature Actions
        // case home(HomeFeature.Action)
        // case wardrobe(WardrobeFeature.Action)
        case outfits(OutfitsFeature.Action)
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

    // MARK: - Dependencies

    @Dependency(\.authService) var authService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.checkAuthStatus)

            case .checkAuthStatus:
                state.isLoading = true
                return .run { send in
                    do {
                        let user = try await authService.getCurrentUser()
                        await send(.authStatusChecked(user))
                    } catch {
                        await send(.authStatusChecked(nil))
                    }
                }

            case let .authStatusChecked(user):
                state.isLoading = false
                state.currentUser = user
                state.currentUserId = user?.id
                state.isAuthenticated = user != nil

                // Present authentication if not authenticated
                if user == nil {
                    state.authentication = AuthenticationFeature.State()
                }

                return .none

            case .presentAuthentication:
                state.authentication = AuthenticationFeature.State()
                return .none

            case .authentication(.presented(.dismissAuth)):
                // Auth flow dismissed - check status again
                return .send(.checkAuthStatus)

            case .authentication:
                return .none

            case .signOut:
                return .run { send in
                    try await authService.signOut()
                    await send(.checkAuthStatus)
                }

            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
                
            case .outfits:
                return .none
            }
        }
        .ifLet(\.$authentication, action: \.authentication) {
            AuthenticationFeature()
        }
        
        Scope(state: \.outfits, action: \.outfits) {
            OutfitsFeature()
        }
    }
}

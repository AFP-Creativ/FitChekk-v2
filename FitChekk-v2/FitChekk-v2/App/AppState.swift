//
//  AppState.swift
//  FitChekk-v2
//
//  App-level state management
//  NOTE: This is a simplified version for mockups. Will be migrated to TCA later.
//

import SwiftUI

@MainActor
class AppState: ObservableObject {
    // MARK: - Published State

    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var selectedTab: Tab = .home
    @Published var hasCompletedOnboarding: Bool = false

    // Services (mock for now)
    let databaseService: DatabaseServiceProtocol = MockDatabaseService.shared
    let weatherService: WeatherServiceProtocol = MockWeatherService.shared
    let aiService: AIServiceProtocol = MockAIService.shared
    let subscriptionService: SubscriptionServiceProtocol = MockSubscriptionService.shared

    // MARK: - Tab Definition

    enum Tab: String, CaseIterable {
        case home = "Home"
        case wardrobe = "Wardrobe"
        case outfits = "Outfits"
        case planner = "Planner"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .wardrobe: return "tshirt.fill"
            case .outfits: return "square.stack.3d.up.fill"
            case .planner: return "calendar"
            case .settings: return "gearshape.fill"
            }
        }

        var iconUnselected: String {
            switch self {
            case .home: return "house"
            case .wardrobe: return "tshirt"
            case .outfits: return "square.stack.3d.up"
            case .planner: return "calendar"
            case .settings: return "gearshape"
            }
        }

        var requiresPremium: Bool {
            self == .outfits || self == .planner
        }
    }

    // MARK: - Initialization

    init() {
        // For mockup, start with a user already signed in
        // In production, this would check actual auth state
        setupMockUser()
    }

    private func setupMockUser() {
        // Can toggle between free and premium for testing
        self.currentUser = PreviewData.premiumUser // or PreviewData.freeUser
        self.isAuthenticated = true
        self.hasCompletedOnboarding = true
    }

    // MARK: - Actions

    func signIn(email: String, password: String) async {
        // Simulate sign in
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        self.currentUser = PreviewData.premiumUser
        self.isAuthenticated = true
    }

    func signOut() {
        self.currentUser = nil
        self.isAuthenticated = false
        self.hasCompletedOnboarding = false
    }

    func completeOnboarding(preferences: StylePreferences) {
        self.hasCompletedOnboarding = true
        self.currentUser?.preferences = preferences
    }

    func selectTab(_ tab: Tab) {
        // Check premium requirements
        if tab.requiresPremium && currentUser?.isPremium != true {
            // In real app, this would show paywall
            // For mockup, just log
            print("Premium required for \(tab.rawValue)")
        }
        self.selectedTab = tab
    }

    // MARK: - Computed Properties

    var isPremium: Bool {
        currentUser?.isPremium ?? false
    }

    func canAccessTab(_ tab: Tab) -> Bool {
        if tab.requiresPremium {
            return isPremium
        }
        return true
    }
}

// MARK: - Preview Helpers

extension AppState {
    static func preview(user: User = PreviewData.premiumUser) -> AppState {
        let state = AppState()
        state.currentUser = user
        state.isAuthenticated = true
        state.hasCompletedOnboarding = true
        return state
    }

    static var previewFree: AppState {
        preview(user: PreviewData.freeUser)
    }

    static var previewPremium: AppState {
        preview(user: PreviewData.premiumUser)
    }
}

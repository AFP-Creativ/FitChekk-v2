//
//  AppView.swift
//  FitChekk-v2
//
//  Main app view with tab navigation
//

import SwiftUI

struct AppView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        Group {
            if appState.isAuthenticated {
                if appState.hasCompletedOnboarding {
                    MainTabView()
                        .environmentObject(appState)
                } else {
                    // Onboarding flow (to be implemented)
                    Text("Onboarding")
                        .environmentObject(appState)
                }
            } else {
                // Welcome/Auth flow (to be implemented)
                Text("Welcome")
                    .environmentObject(appState)
            }
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // Home Tab
            HomeTabView()
                .tabItem {
                    Label(
                        AppState.Tab.home.rawValue,
                        systemImage: appState.selectedTab == .home ?
                            AppState.Tab.home.icon :
                            AppState.Tab.home.iconUnselected
                    )
                }
                .tag(AppState.Tab.home)

            // Wardrobe Tab
            WardrobeTabView()
                .tabItem {
                    Label(
                        AppState.Tab.wardrobe.rawValue,
                        systemImage: appState.selectedTab == .wardrobe ?
                            AppState.Tab.wardrobe.icon :
                            AppState.Tab.wardrobe.iconUnselected
                    )
                }
                .tag(AppState.Tab.wardrobe)

            // Outfits Tab (Premium)
            OutfitsTabView()
                .tabItem {
                    Label(
                        AppState.Tab.outfits.rawValue,
                        systemImage: appState.selectedTab == .outfits ?
                            AppState.Tab.outfits.icon :
                            AppState.Tab.outfits.iconUnselected
                    )
                }
                .tag(AppState.Tab.outfits)

            // Planner Tab (Premium)
            PlannerTabView()
                .tabItem {
                    Label(
                        AppState.Tab.planner.rawValue,
                        systemImage: appState.selectedTab == .planner ?
                            AppState.Tab.planner.icon :
                            AppState.Tab.planner.iconUnselected
                    )
                }
                .tag(AppState.Tab.planner)

            // Settings Tab
            SettingsTabView()
                .tabItem {
                    Label(
                        AppState.Tab.settings.rawValue,
                        systemImage: appState.selectedTab == .settings ?
                            AppState.Tab.settings.icon :
                            AppState.Tab.settings.iconUnselected
                    )
                }
                .tag(AppState.Tab.settings)
        }
        .accentColor(.terracotta)
    }
}

// MARK: - Tab View Wrappers

struct HomeTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HomeView(appState: appState)
            .environmentObject(appState)
    }
}

struct WardrobeTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        WardrobeView(appState: appState)
            .environmentObject(appState)
    }
}

struct OutfitsTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if appState.isPremium {
                    Text("Outfits Tab")
                        .titleStyle()
                } else {
                    VStack(spacing: Spacing.xl) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.terracotta.opacity(0.6))

                        Text("Premium Feature")
                            .font(.title2)
                            .foregroundColor(.adaptiveText)

                        Text("Upgrade to Premium to create and save outfit combinations")
                            .font(.bodyText)
                            .foregroundColor(.adaptiveTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xxl)

                        PrimaryButton(title: "Upgrade to Premium", action: {}, fullWidth: false)
                    }
                }
            }
            .navigationTitle("Outfits")
        }
    }
}

struct PlannerTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if appState.isPremium {
                    Text("Planner Tab")
                        .titleStyle()
                } else {
                    VStack(spacing: Spacing.xl) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.terracotta.opacity(0.6))

                        Text("Premium Feature")
                            .font(.title2)
                            .foregroundColor(.adaptiveText)

                        Text("Upgrade to Premium to plan your outfits with our calendar")
                            .font(.bodyText)
                            .foregroundColor(.adaptiveTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xxl)

                        PrimaryButton(title: "Upgrade to Premium", action: {}, fullWidth: false)
                    }
                }
            }
            .navigationTitle("Planner")
        }
    }
}

struct SettingsTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                Text("Settings Tab")
                    .titleStyle()
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview

#Preview("App View - Premium") {
    AppView()
}

#Preview("App View - Free") {
    let state = AppState()
    state.currentUser = PreviewData.freeUser
    return AppView()
}

#Preview("Main Tab View") {
    MainTabView()
        .environmentObject(AppState.preview())
}

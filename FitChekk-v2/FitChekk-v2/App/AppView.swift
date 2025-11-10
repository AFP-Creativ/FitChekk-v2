//
//  AppView.swift
//  FitChekk-v2
//
//  Root app view with tab navigation
//

import SwiftUI

struct AppView: View {
    @State private var appState = AppState()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label(
                        AppState.Tab.home.title,
                        systemImage: appState.selectedTab == .home
                            ? AppState.Tab.home.iconFilled
                            : AppState.Tab.home.icon
                    )
                }
                .tag(AppState.Tab.home)
            
            // Wardrobe Tab
            WardrobeView()
                .tabItem {
                    Label(
                        AppState.Tab.wardrobe.title,
                        systemImage: appState.selectedTab == .wardrobe
                            ? AppState.Tab.wardrobe.iconFilled
                            : AppState.Tab.wardrobe.icon
                    )
                }
                .tag(AppState.Tab.wardrobe)
            
            // Outfits Tab
            OutfitsView()
                .tabItem {
                    Label(
                        AppState.Tab.outfits.title,
                        systemImage: appState.selectedTab == .outfits
                            ? AppState.Tab.outfits.iconFilled
                            : AppState.Tab.outfits.icon
                    )
                }
                .tag(AppState.Tab.outfits)
            
            // Planner Tab
            PlannerView()
                .tabItem {
                    Label(
                        AppState.Tab.planner.title,
                        systemImage: appState.selectedTab == .planner
                            ? AppState.Tab.planner.iconFilled
                            : AppState.Tab.planner.icon
                    )
                }
                .tag(AppState.Tab.planner)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Label(
                        AppState.Tab.settings.title,
                        systemImage: appState.selectedTab == .settings
                            ? AppState.Tab.settings.iconFilled
                            : AppState.Tab.settings.icon
                    )
                }
                .tag(AppState.Tab.settings)
        }
        .accentColor(.accentPrimary)
        .environment(appState)
    }
}

#Preview {
    AppView()
}


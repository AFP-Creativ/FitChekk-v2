//
//  AppView.swift
//  FitChekk
//
//  Root view for the FitChekk app
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        Group {
            if store.isLoading {
                LoadingView()
            } else if store.isAuthenticated {
                mainTabView
            } else {
                // Loading or waiting for auth presentation
                LoadingView()
            }
        }
        .fullScreenCover(
            item: $store.scope(
                state: \.authentication,
                action: \.authentication
            )
        ) { authStore in
            AuthenticationView(store: authStore)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    private var mainTabView: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            PlaceholderFeatureView(title: "Home")
                .tabItem {
                    Label(
                        AppFeature.Tab.home.title,
                        systemImage: store.selectedTab == .home
                            ? AppFeature.Tab.home.iconFilled
                            : AppFeature.Tab.home.icon
                    )
                }
                .tag(AppFeature.Tab.home)

            PlaceholderFeatureView(title: "Wardrobe")
                .tabItem {
                    Label(
                        AppFeature.Tab.wardrobe.title,
                        systemImage: store.selectedTab == .wardrobe
                            ? AppFeature.Tab.wardrobe.iconFilled
                            : AppFeature.Tab.wardrobe.icon
                    )
                }
                .tag(AppFeature.Tab.wardrobe)

            PlaceholderFeatureView(title: "Outfits")
                .tabItem {
                    Label(
                        AppFeature.Tab.outfits.title,
                        systemImage: AppFeature.Tab.outfits.icon
                    )
                }
                .tag(AppFeature.Tab.outfits)

            PlaceholderFeatureView(title: "Planner")
                .tabItem {
                    Label(
                        AppFeature.Tab.planner.title,
                        systemImage: AppFeature.Tab.planner.icon
                    )
                }
                .tag(AppFeature.Tab.planner)

            PlaceholderFeatureView(title: "Settings")
                .tabItem {
                    Label(
                        AppFeature.Tab.settings.title,
                        systemImage: store.selectedTab == .settings
                            ? AppFeature.Tab.settings.iconFilled
                            : AppFeature.Tab.settings.icon
                    )
                }
                .tag(AppFeature.Tab.settings)
        }
        .tint(Color.accentPrimary)
    }

}

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.accentPrimary)

                Text("Loading FitChekk...")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Placeholder Feature View

struct PlaceholderFeatureView: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.displayLarge)
                .foregroundColor(.textPrimary)

            Text("Feature coming soon...")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Previews

#Preview("App View - Loading") {
    AppView(
        store: Store(initialState: AppFeature.State(isLoading: true)) {
            AppFeature()
        }
    )
}

#Preview("App View - Authenticated") {
    AppView(
        store: Store(initialState: AppFeature.State(
            isAuthenticated: true,
            currentUserId: UUID()
        )) {
            AppFeature()
        }
    )
}

#Preview("App View - Not Authenticated") {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}

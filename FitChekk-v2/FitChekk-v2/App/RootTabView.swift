import SwiftUI
import ComposableArchitecture

struct RootTabView: View {
    @Bindable var store: StoreOf<AppFeature>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        TabView {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            WardrobeView(store: store.scope(state: \.wardrobe, action: \.wardrobe))
                .tabItem {
                    Image(systemName: "hanger")
                    Text("My Closet")
                }

            PlannerView(store: store.scope(state: \.planner, action: \.planner))
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planner")
                }

            SettingsView(store: store.scope(state: \.settings, action: \.settings))
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tint(.accentPrimary)
        .background(Color.backgroundPrimary(for: colorScheme))
    }
}

#Preview {
    RootTabView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}



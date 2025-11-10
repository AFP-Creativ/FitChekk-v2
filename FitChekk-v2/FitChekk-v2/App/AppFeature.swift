import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var home = HomeFeature.State()
        var wardrobe = WardrobeFeature.State()
        var planner = PlannerFeature.State()
        var settings = SettingsFeature.State()
    }

    enum Action: Equatable {
        case home(HomeFeature.Action)
        case wardrobe(WardrobeFeature.Action)
        case planner(PlannerFeature.Action)
        case settings(SettingsFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) { HomeFeature() }
        Scope(state: \.wardrobe, action: \.wardrobe) { WardrobeFeature() }
        Scope(state: \.planner, action: \.planner) { PlannerFeature() }
        Scope(state: \.settings, action: \.settings) { SettingsFeature() }
    }
}



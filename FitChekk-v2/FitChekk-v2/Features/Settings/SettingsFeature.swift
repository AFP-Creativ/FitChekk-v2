import Foundation
import ComposableArchitecture

@Reducer
struct SettingsFeature {
    @ObservableState
    struct State: Equatable {
        var notificationsEnabled: Bool = false
        var useMetric: Bool = false
        var darkMode: Bool = false
    }

    enum Action: Equatable {
        case toggleNotifications(Bool)
        case toggleMetric(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .toggleNotifications(isOn):
                state.notificationsEnabled = isOn
                return .none
            case let .toggleMetric(isOn):
                state.useMetric = isOn
                return .none
            }
        }
    }
}



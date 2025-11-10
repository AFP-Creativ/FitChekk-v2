import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var userFirstName: String = "Emma"
        var dateString: String = Date().formatted(date: .long, time: .omitted)
        var weatherSummary: String = "72° · Partly Cloudy"
        var weatherForecast: [Int] = [72, 68, 65, 70, 74]

        var outfitImageName: String = "tshirt"
        var outfitReasoning: String = "This navy sweater pairs perfectly with your camel chinos for today's 72° weather."
        var hasScheduledOutfitToday: Bool = false
        var isLoadingSuggestion: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case onAppear
        case useThisTapped
        case suggestAnotherTapped
        case dismissError
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .useThisTapped:
                state.hasScheduledOutfitToday = true
                return .none
            case .suggestAnotherTapped:
                state.isLoadingSuggestion = true
                // Simulate quick update
                return .none
            case .dismissError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}



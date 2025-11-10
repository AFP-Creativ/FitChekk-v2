import Foundation
import ComposableArchitecture

@Reducer
struct PlannerFeature {
    @ObservableState
    struct State: Equatable {
        var currentMonth: Date = Date()
        var selectedDate: Date? = nil
        @Presents var dayDetail: DayDetailFeature.State?
    }

    enum Action: Equatable {
        case onAppear
        case previousMonth
        case nextMonth
        case selectDate(Date)
        case dayDetail(PresentationAction<DayDetailFeature.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .previousMonth:
                state.currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: state.currentMonth) ?? state.currentMonth
                return .none
            case .nextMonth:
                state.currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: state.currentMonth) ?? state.currentMonth
                return .none
            case let .selectDate(date):
                state.selectedDate = date
                state.dayDetail = DayDetailFeature.State(date: date)
                return .none
            case .dayDetail:
                return .none
            }
        }
        .ifLet(\.$dayDetail, action: \.dayDetail) {
            DayDetailFeature()
        }
    }
}

@Reducer
struct DayDetailFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: String { ISO8601DateFormatter().string(from: date) }
        var date: Date
    }
    enum Action: Equatable { case close }
    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}



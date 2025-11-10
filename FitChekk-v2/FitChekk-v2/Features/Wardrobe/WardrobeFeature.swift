import Foundation
import ComposableArchitecture
import SwiftUI

struct WardrobeItemModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    var imageSystemName: String
    var isFavorite: Bool
}

@Reducer
struct WardrobeFeature {
    @ObservableState
    struct State: Equatable {
        var items: [WardrobeItemModel] = (1...12).map { i in
            WardrobeItemModel(
                id: UUID(),
                name: "Item \(i)",
                imageSystemName: "tshirt",
                isFavorite: false
            )
        }
        var searchQuery: String = ""
        var selectedCategory: String? = nil
        @Presents var itemDetail: ItemDetailFeature.State?
    }

    enum Action: Equatable {
        case onAppear
        case searchQueryChanged(String)
        case itemTapped(WardrobeItemModel)
        case toggleFavorite(WardrobeItemModel)
        case itemDetail(PresentationAction<ItemDetailFeature.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .searchQueryChanged(q):
                state.searchQuery = q
                return .none
            case let .itemTapped(item):
                state.itemDetail = ItemDetailFeature.State(item: item)
                return .none
            case let .toggleFavorite(item):
                if let idx = state.items.firstIndex(where: { $0.id == item.id }) {
                    state.items[idx].isFavorite.toggle()
                }
                return .none
            case .itemDetail:
                return .none
            }
        }
        .ifLet(\.$itemDetail, action: \.itemDetail) {
            ItemDetailFeature()
        }
    }
}

@Reducer
struct ItemDetailFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: UUID { item.id }
        var item: WardrobeItemModel
    }
    enum Action: Equatable { case close }
    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}



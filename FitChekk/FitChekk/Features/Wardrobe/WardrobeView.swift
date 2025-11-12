//
//  WardrobeView.swift
//  FitChekk
//
//  Main wardrobe view with grid layout, search, and filters
//

import ComposableArchitecture
import SwiftUI

struct WardrobeView: View {
    @Bindable var store: StoreOf<WardrobeFeature>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if store.isLoading && store.items.isEmpty {
                    LoadingStateView(message: "Loading your wardrobe...")
                } else if store.isEmpty {
                    emptyStateView
                } else if store.hasNoResults {
                    noResultsView
                } else {
                    contentView
                }
            }
            .navigationTitle("Wardrobe")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { store.send(.addItemTapped) }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.accentPrimary)
                    }
                }
            }
            .searchable(
                text: .init(
                    get: { store.searchQuery },
                    set: { store.send(.searchQueryChanged($0)) }
                ),
                prompt: "Search wardrobe..."
            )
            .sheet(isPresented: .init(
                get: { store.isAddItemSheetPresented },
                set: { if !$0 { store.send(.dismissAddItem) } }
            )) {
                // TODO: AddItemView will be implemented next
                Text("Add Item (Coming Soon)")
                    .presentationDetents([.large])
            }
            .sheet(isPresented: .init(
                get: { store.isEditItemSheetPresented },
                set: { if !$0 { store.send(.dismissEditItem) } }
            )) {
                // TODO: EditItemView will be implemented next
                Text("Edit Item (Coming Soon)")
                    .presentationDetents([.large])
            }
            .alert(
                "Delete Item",
                isPresented: .init(
                    get: { store.showDeleteConfirmation },
                    set: { if !$0 { store.send(.cancelDelete) } }
                ),
                actions: {
                    Button("Cancel", role: .cancel) {
                        store.send(.cancelDelete)
                    }
                    Button("Delete", role: .destructive) {
                        store.send(.confirmDelete)
                    }
                },
                message: {
                    Text("Are you sure you want to delete this item? This action cannot be undone.")
                }
            )
            .alert(
                "Error",
                isPresented: .init(
                    get: { store.errorMessage != nil },
                    set: { if !$0 { store.send(.clearError) } }
                ),
                actions: {
                    Button("OK") {
                        store.send(.clearError)
                    }
                },
                message: {
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                    }
                }
            )
            .onAppear {
                store.send(.onAppear)
            }
            .refreshable {
                await store.send(.refresh).finish()
            }
        }
    }

    // MARK: - Content View

    private var contentView: some View {
        ScrollView {
            VStack(spacing: Spacing.md) {
                // Filters
                filterSection

                // Grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: Spacing.md),
                        GridItem(.flexible(), spacing: Spacing.md)
                    ],
                    spacing: Spacing.md
                ) {
                    ForEach(store.displayedItems, id: \.id) { item in
                        WardrobeItemCard(
                            item: item,
                            onTap: {
                                store.send(.selectItem(item))
                            },
                            onFavoriteTap: {
                                store.send(.toggleFavorite(item))
                            }
                        )
                        .contextMenu {
                            Button(action: { store.send(.editItemTapped(item)) }) {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button(action: { store.send(.toggleFavorite(item)) }) {
                                Label(
                                    item.isFavorite ? "Unfavorite" : "Favorite",
                                    systemImage: item.isFavorite ? "heart.slash" : "heart"
                                )
                            }

                            Divider()

                            Button(role: .destructive, action: { store.send(.deleteItem(item)) }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
        }
    }

    // MARK: - Filter Section

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                // Clear Filters
                if store.selectedCategory != nil || store.showFavoritesOnly || store.showRecentlyWornOnly {
                    Button(action: { store.send(.clearFilters) }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Clear")
                                .font(Font.captionMedium)
                        }
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.accentPrimary)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }

                // Favorites Filter
                Button(action: { store.send(.toggleFavoritesFilter) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                        Text("Favorites")
                            .font(Font.captionMedium)
                    }
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(store.showFavoritesOnly ? Color.accentPrimary : Color.backgroundSecondary)
                    .foregroundColor(store.showFavoritesOnly ? .white : Color.textSecondary)
                    .clipShape(Capsule())
                }

                // Recently Worn Filter
                Button(action: { store.send(.toggleRecentlyWornFilter) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text("Recent")
                            .font(Font.captionMedium)
                    }
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(store.showRecentlyWornOnly ? Color.accentPrimary : Color.backgroundSecondary)
                    .foregroundColor(store.showRecentlyWornOnly ? .white : Color.textSecondary)
                    .clipShape(Capsule())
                }

                // Category Filters
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    Button(action: {
                        store.send(.categoryFilterChanged(
                            store.selectedCategory == category ? nil : category
                        ))
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.system(size: 12))
                            Text(category.displayName)
                                .font(Font.captionMedium)
                        }
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(store.selectedCategory == category ? Color.accentPrimary : Color.backgroundSecondary)
                        .foregroundColor(store.selectedCategory == category ? .white : Color.textSecondary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        EmptyStateView(
            icon: "tshirt",
            title: "Your wardrobe is empty",
            message: "Start building your digital wardrobe by adding your first clothing item.",
            actionTitle: "Add First Item",
            action: { store.send(.addItemTapped) }
        )
    }

    // MARK: - No Results

    private var noResultsView: some View {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No items found",
            message: "Try adjusting your search or filters to find what you're looking for.",
            actionTitle: "Clear Filters",
            action: { store.send(.clearFilters) }
        )
    }
}

// MARK: - Preview

#if DEBUG
extension WardrobeFeature.State {
    static var preview: Self {
        Self(userId: UUID())
    }

    static var previewWithItems: Self {
        var state = Self(userId: UUID())
        state.items = [
            WardrobeItem(
                userId: state.userId,
                name: "Blue Denim Jacket",
                category: .outerwear,
                subCategory: .jackets,
                brand: "Levi's",
                colors: ["Blue"],
                isFavorite: true
            ),
            WardrobeItem(
                userId: state.userId,
                name: "White T-Shirt",
                category: .tops,
                subCategory: .basicTees,
                colors: ["White"]
            ),
            WardrobeItem(
                userId: state.userId,
                category: .bottoms,
                subCategory: .jeans,
                colors: ["Black"]
            ),
            WardrobeItem(
                userId: state.userId,
                category: .shoes,
                subCategory: .sneakers,
                colors: ["White", "Red"]
            )
        ]
        state.filteredItems = state.items
        return state
    }
}
#endif

#Preview("Empty Wardrobe") {
    WardrobeView(
        store: Store(
            initialState: WardrobeFeature.State.preview
        ) {
            WardrobeFeature()
        }
    )
}

#Preview("Wardrobe with Items") {
    WardrobeView(
        store: Store(
            initialState: WardrobeFeature.State.previewWithItems
        ) {
            WardrobeFeature()
        }
    )
}

#Preview("Loading State") {
    WardrobeView(
        store: Store(
            initialState: {
                var state = WardrobeFeature.State.preview
                state.isLoading = true
                return state
            }()
        ) {
            WardrobeFeature()
        }
    )
}

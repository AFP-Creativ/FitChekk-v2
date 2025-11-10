//
//  WardrobeView.swift
//  FitChekk-v2
//
//  Wardrobe grid view showing all clothing items
//

import SwiftUI

struct WardrobeView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedCategory: ItemCategory? = nil
    @State private var searchText = ""
    @State private var showAddItem = false
    @State private var selectedItem: WardrobeItem? = nil
    @State private var showOnlyFavorites = false
    
    var filteredItems: [WardrobeItem] {
        appState.wardrobeItems.filter { item in
            // Filter out archived
            guard !item.isArchived else { return false }
            
            // Category filter
            if let category = selectedCategory, item.category != category {
                return false
            }
            
            // Favorites filter
            if showOnlyFavorites && !item.isFavorite {
                return false
            }
            
            // Search filter
            if !searchText.isEmpty {
                let searchLower = searchText.lowercased()
                return item.displayName.lowercased().contains(searchLower) ||
                       item.colors.contains { $0.lowercased().contains(searchLower) } ||
                       item.brand?.lowercased().contains(searchLower) ?? false
            }
            
            return true
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if appState.wardrobeItems.isEmpty {
                    EmptyWardrobeView {
                        showAddItem = true
                    }
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.lg) {
                            // Category filter chips
                            categoryFilterSection
                            
                            // Items count and favorites toggle
                            HStack {
                                Text("\(filteredItems.count) items")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Button(action: { showOnlyFavorites.toggle() }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: showOnlyFavorites ? "heart.fill" : "heart")
                                        Text("Favorites")
                                    }
                                    .font(.labelLarge)
                                    .foregroundColor(showOnlyFavorites ? .accentPrimary : .textSecondary)
                                }
                            }
                            .padding(.horizontal, Spacing.screenHorizontal)
                            
                            // Items grid
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: Spacing.gridGap),
                                    GridItem(.flexible(), spacing: Spacing.gridGap)
                                ],
                                spacing: Spacing.gridGap
                            ) {
                                ForEach(filteredItems) { item in
                                    ItemCard(
                                        item: item,
                                        onTap: {
                                            selectedItem = item
                                        },
                                        onFavoriteToggle: {
                                            appState.toggleFavorite(item)
                                        }
                                    )
                                    .contextMenu {
                                        Button {
                                            appState.toggleFavorite(item)
                                        } label: {
                                            Label(
                                                item.isFavorite ? "Unfavorite" : "Favorite",
                                                systemImage: item.isFavorite ? "heart.slash" : "heart"
                                            )
                                        }
                                        
                                        Button {
                                            selectedItem = item
                                        } label: {
                                            Label("View Details", systemImage: "info.circle")
                                        }
                                        
                                        Button(role: .destructive) {
                                            appState.deleteWardrobeItem(item)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, Spacing.screenHorizontal)
                        }
                        .padding(.bottom, 100) // Space for FAB
                    }
                }
                
                // Floating Add Button
                if !appState.wardrobeItems.isEmpty {
                    FloatingActionButton(icon: "plus") {
                        showAddItem = true
                    }
                    .padding(Spacing.lg)
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("My Wardrobe")
            .searchable(text: $searchText, prompt: "Search items...")
            .sheet(isPresented: $showAddItem) {
                AddItemView(onDismiss: { showAddItem = false })
            }
            .sheet(item: $selectedItem) { item in
                ItemDetailView(item: item)
            }
        }
    }
    
    // MARK: - Category Filter
    
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ChipButton(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(ItemCategory.allCases) { category in
                    ChipButton(
                        title: category.displayName,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
}

#Preview {
    WardrobeView()
        .environment(AppState())
}


//
//  WardrobeFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class WardrobeState {
    var items: [MockWardrobeItem] = MockWardrobeItem.sampleItems
    var selectedCategory: ItemCategory? = nil
    var searchQuery: String = ""
    var isLoading: Bool = false
    var selectedItem: MockWardrobeItem? = nil

    var filteredItems: [MockWardrobeItem] {
        var filtered = items

        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        if !searchQuery.isEmpty {
            filtered = filtered.filter { item in
                item.name?.localizedCaseInsensitiveContains(searchQuery) ?? false
            }
        }

        return filtered
    }
}

// MARK: - Actions

enum WardrobeAction {
    case onAppear
    case categoryFilterChanged(ItemCategory?)
    case searchQueryChanged(String)
    case itemTapped(MockWardrobeItem)
    case addItemTapped
    case toggleFavorite(MockWardrobeItem)
}

// MARK: - View

struct WardrobeView: View {
    @State private var state = WardrobeState()
    @State private var showingAddItem = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                categoryFilter
                
                // Items Grid
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 160), spacing: Spacing.grid)
                        ],
                        spacing: Spacing.grid
                    ) {
                        ForEach(state.filteredItems) { item in
                            ItemCardView(item: item)
                                .onTapGesture {
                                    state.selectedItem = item
                                }
                        }
                    }
                    .padding(.horizontal, Spacing.screenMargin)
                    .padding(.vertical, Spacing.standard)
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("My Closet")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $state.searchQuery, prompt: "Search items...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.accentPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView()
            }
            .navigationDestination(item: $state.selectedItem) { item in
                ItemDetailView(item: item)
            }
        }
    }
    
    // MARK: - Category Filter
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.group) {
                CategoryChip(
                    title: "All",
                    isSelected: state.selectedCategory == nil
                ) {
                    state.selectedCategory = nil
                }
                
                ForEach(ItemCategory.allCases) { category in
                    CategoryChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: state.selectedCategory == category
                    ) {
                        state.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, Spacing.screenMargin)
            .padding(.vertical, Spacing.standard)
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Item Card View

struct ItemCardView: View {
    let item: MockWardrobeItem
    
    var body: some View {
        VStack(spacing: 0) {
            // Image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: CardStyle.cornerRadius)
                    .fill(Color.backgroundSecondary)
                    .frame(height: 180)
                
                Image(systemName: item.imagePlaceholder)
                    .font(.system(size: 48))
                    .foregroundColor(.textTertiary)
            }
            
            // Item info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.name ?? "Untitled")
                        .font(.caption)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if item.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundColor(.accentPrimary)
                    }
                }
                
                Text(item.category.rawValue)
                    .font(.caption2)
                    .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cardStyle()
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
            }
            .foregroundColor(isSelected ? .white : .textPrimary)
            .padding(.horizontal, Spacing.standard)
            .padding(.vertical, Spacing.verticalTight)
            .background(isSelected ? Color.accentPrimary : Color.backgroundSecondary)
            .cornerRadius(20)
        }
    }
}

// MARK: - Add Item View (Placeholder)

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.section) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.accentPrimary)
                
                Text("Add Item")
                    .font(.title)
                    .foregroundColor(.textPrimary)
                
                Text("This screen will allow you to add items via camera or photo library")
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WardrobeView()
}


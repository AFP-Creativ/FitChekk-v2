//
//  WardrobeItemPickerView.swift
//  FitChekk
//
//  Reusable component for multi-select item selection from wardrobe
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct WardrobeItemPickerView: View {
    let selectedItemIds: Set<UUID>
    let onItemsSelected: ([WardrobeItem]) -> Void
    let onDismiss: () -> Void
    
    @State private var searchText: String = ""
    @State private var selectedCategory: ItemCategory?
    @State private var wardrobeItems: [WardrobeItem] = []
    @State private var tempSelectedIds: Set<UUID>
    @State private var isLoading: Bool = true
    
    init(
        selectedItemIds: Set<UUID>,
        onItemsSelected: @escaping ([WardrobeItem]) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.selectedItemIds = selectedItemIds
        self.onItemsSelected = onItemsSelected
        self.onDismiss = onDismiss
        _tempSelectedIds = State(initialValue: selectedItemIds)
    }
    
    var filteredItems: [WardrobeItem] {
        var items = wardrobeItems
        
        // Filter by category
        if let category = selectedCategory {
            items = items.filter { $0.categoryEnum == category }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            items = items.filter { item in
                item.displayName.localizedCaseInsensitiveContains(searchText) ||
                item.brand?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        return items
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Category Filters
                categoryFilters
                
                // Items Grid
                if isLoading {
                    loadingView
                } else if filteredItems.isEmpty {
                    emptyStateView
                } else {
                    itemsGridView
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Select Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        let selectedItems = wardrobeItems.filter { tempSelectedIds.contains($0.id) }
                        onItemsSelected(selectedItems)
                    }, label: {
                        Text("Done (\(tempSelectedIds.count))")
                            .fontWeight(.semibold)
                    })
                }
            }
        }
        .task {
            await loadWardrobe()
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.textTertiary)
            
            TextField("Search items...", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.textTertiary)
                })
            }
        }
        .padding(Spacing.sm)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.md)
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
    
    // MARK: - Category Filters
    
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                categoryPill(title: "All", category: nil)
                
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    categoryPill(title: category.displayName, category: category)
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
        }
    }
    
    private func categoryPill(title: String, category: ItemCategory?) -> some View {
        Button(action: {
            selectedCategory = category
        }, label: {
            Text(title)
                .font(Font.bodyMedium)
                .foregroundColor(selectedCategory == category ? Color.white : Color.textPrimary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(selectedCategory == category ? Color.accentPrimary : Color.backgroundSecondary)
                .cornerRadius(CornerRadius.xl)
        })
    }
    
    // MARK: - Items Grid
    
    private var itemsGridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Spacing.md),
                    GridItem(.flexible(), spacing: Spacing.md)
                ],
                spacing: Spacing.md,
                content: {
                    ForEach(filteredItems) { item in
                        itemCard(item: item)
                    }
                }
            )
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
        }
    }
    
    private func itemCard(item: WardrobeItem) -> some View {
        let isSelected = tempSelectedIds.contains(item.id)
        
        return Button(action: {
            if isSelected {
                tempSelectedIds.remove(item.id)
            } else {
                tempSelectedIds.insert(item.id)
            }
        }, label: {
            VStack(spacing: Spacing.xs) {
                // Image with Selection Overlay
                ZStack(alignment: .topTrailing) {
                    if let thumbnailURL = item.thumbnailURL {
                        AsyncImage(url: URL(string: thumbnailURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure, .empty:
                                placeholderImage(for: item)
                            @unknown default:
                                placeholderImage(for: item)
                            }
                        }
                    } else {
                        placeholderImage(for: item)
                    }
                    
                    // Selection Checkbox
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? Color.accentPrimary : Color.white)
                        .background(
                            Circle()
                                .fill(isSelected ? Color.white : Color.black.opacity(0.3))
                                .frame(width: 24, height: 24)
                        )
                        .padding(Spacing.xs)
                }
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .stroke(isSelected ? Color.accentPrimary : Color.clear, lineWidth: 2)
                )
                
                // Item Name
                Text(item.displayName)
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding(Spacing.xs)
            .background(isSelected ? Color.accentPrimary.opacity(0.1) : Color.backgroundSecondary)
            .cornerRadius(CornerRadius.md)
        })
        .buttonStyle(.plain)
    }
    
    private func placeholderImage(for item: WardrobeItem) -> some View {
        ZStack {
            Color.backgroundSecondary
            
            Image(systemName: item.categoryEnum.icon)
                .font(.system(size: 40))
                .foregroundColor(Color.textTertiary)
        }
    }
    
    // MARK: - Loading & Empty States
    
    private var loadingView: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.accentPrimary)
            
            Text("Loading your wardrobe...")
                .font(Font.bodyMedium)
                .foregroundColor(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "tshirt")
                .font(.system(size: 60))
                .foregroundColor(Color.textTertiary)
            
            Text("No items found")
                .font(Font.headlineMedium)
                .foregroundColor(Color.textPrimary)
            
            if !searchText.isEmpty || selectedCategory != nil {
                Text("Try adjusting your filters")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
            } else {
                Text("Add items to your wardrobe first")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
    }
    
    // MARK: - Data Loading
    
    private func loadWardrobe() async {
        // TODO: Data loading should be handled by parent feature
        // For now, showing empty state
        isLoading = false
        wardrobeItems = []
    }
}

// MARK: - Preview

#Preview {
    WardrobeItemPickerView(
        selectedItemIds: [],
        onItemsSelected: { _ in },
        onDismiss: {}
    )
}

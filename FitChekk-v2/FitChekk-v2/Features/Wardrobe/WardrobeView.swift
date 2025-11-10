//
//  WardrobeView.swift
//  FitChekk-v2
//
//  Wardrobe grid view with filtering and search
//

import SwiftUI

// MARK: - Wardrobe State

@MainActor
class WardrobeState: ObservableObject {
    @Published var items: [WardrobeItem] = []
    @Published var selectedCategory: ItemCategory?
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var selectedItem: WardrobeItem?
    @Published var showingAddItem = false

    let databaseService: DatabaseServiceProtocol
    let user: User

    init(
        databaseService: DatabaseServiceProtocol = MockDatabaseService.shared,
        user: User
    ) {
        self.databaseService = databaseService
        self.user = user
    }

    var filteredItems: [WardrobeItem] {
        var result = items.filter { !$0.isArchived }

        // Apply category filter
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        // Apply search filter
        if !searchQuery.isEmpty {
            result = result.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchQuery) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchQuery)
            }
        }

        return result
    }

    var itemCount: String {
        if let limit = user.subscriptionTier.itemLimit {
            return "\(items.count)/\(limit) items"
        }
        return "\(items.count) items"
    }

    var canAddMore: Bool {
        if let limit = user.subscriptionTier.itemLimit {
            return items.count < limit
        }
        return true
    }

    func loadItems() async {
        isLoading = true
        do {
            items = try await databaseService.fetchWardrobeItems()
        } catch {
            print("Failed to load items: \(error)")
        }
        isLoading = false
    }

    func toggleFavorite(_ item: WardrobeItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isFavorite.toggle()
            // In real app, would save to database
        }
    }

    func deleteItem(_ item: WardrobeItem) {
        items.removeAll { $0.id == item.id }
        // In real app, would delete from database
    }
}

// MARK: - Wardrobe View

struct WardrobeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var state: WardrobeState

    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: Spacing.md)
    ]

    init(appState: AppState) {
        let user = appState.currentUser ?? PreviewData.premiumUser
        _state = StateObject(wrappedValue: WardrobeState(user: user))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                if state.items.isEmpty && !state.isLoading {
                    EmptyStateView(
                        icon: "tshirt",
                        title: "No Items Yet",
                        message: "Start building your wardrobe by adding your first clothing item.",
                        actionTitle: "Add Item",
                        action: { state.showingAddItem = true }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Category Filter
                            CategoryFilter(selectedCategory: $state.selectedCategory)

                            // Item Count
                            HStack {
                                Text(state.itemCount)
                                    .font(.caption)
                                    .foregroundColor(.adaptiveTextSecondary)

                                Spacer()
                            }
                            .screenPadding()
                            .padding(.vertical, Spacing.xs)

                            // Items Grid
                            if state.isLoading {
                                LoadingGrid(itemCount: 8)
                            } else if state.filteredItems.isEmpty {
                                EmptyStateView(
                                    icon: "magnifyingglass",
                                    title: "No Results",
                                    message: "Try adjusting your search or filters."
                                )
                                .padding(.top, Spacing.xxxl)
                            } else {
                                LazyVGrid(columns: columns, spacing: Spacing.md) {
                                    ForEach(state.filteredItems) { item in
                                        ItemCardWithMenu(
                                            item: item,
                                            onTap: { state.selectedItem = item },
                                            onFavorite: { state.toggleFavorite(item) },
                                            onArchive: {},
                                            onDelete: { state.deleteItem(item) }
                                        )
                                    }
                                }
                                .screenPadding()
                                .padding(.bottom, Spacing.giant)
                            }
                        }
                    }
                }

                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()

                        FloatingActionButton(
                            icon: "plus",
                            action: {
                                if state.canAddMore {
                                    state.showingAddItem = true
                                } else {
                                    // Show upgrade prompt
                                    print("Upgrade required")
                                }
                            }
                        )
                        .screenPadding()
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationTitle("Wardrobe")
            .searchable(text: $state.searchQuery, prompt: "Search items")
            .refreshable {
                await state.loadItems()
            }
            .sheet(item: $state.selectedItem) { item in
                ItemDetailView(item: item)
            }
            .sheet(isPresented: $state.showingAddItem) {
                AddItemPlaceholderView()
            }
        }
        .task {
            await state.loadItems()
        }
    }
}

// MARK: - Category Filter

struct CategoryFilter: View {
    @Binding var selectedCategory: ItemCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                // "All" chip
                CategoryChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )

                // Category chips
                ForEach(ItemCategory.allCases) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: {
                            if selectedCategory == category {
                                selectedCategory = nil
                            } else {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
            .padding(.vertical, Spacing.sm)
        }
        .background(Color.backgroundSecondary.opacity(0.5))
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(Color.terracotta)
                )
                .floatingShadow()
        }
        .accessibilityLabel("Add item")
    }
}

// MARK: - Placeholder Views

struct AddItemPlaceholderView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xl) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.terracotta.opacity(0.6))

                Text("Add Item")
                    .font(.title)
                    .foregroundColor(.adaptiveText)

                Text("Take a photo or select from your library to add an item to your wardrobe.")
                    .font(.bodyText)
                    .foregroundColor(.adaptiveTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)

                VStack(spacing: Spacing.md) {
                    PrimaryButton(title: "Take Photo", action: {})
                    SecondaryButton(title: "Choose from Library", action: {})
                }
                .screenPadding()
            }
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

struct ItemDetailView: View {
    let item: WardrobeItem
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Large item image
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(item.primaryColor.swiftUIColor.opacity(0.2))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            Image(systemName: item.category.icon)
                                .font(.system(size: 120))
                                .foregroundColor(item.primaryColor.swiftUIColor.opacity(0.6))
                        )

                    // Item details
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Text(item.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.adaptiveText)

                            if item.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.terracotta)
                            }

                            Spacer()
                        }

                        // Metadata grid
                        MetadataGrid(item: item)

                        // Usage stats
                        if item.timesWorn > 0 {
                            UsageStats(item: item)
                        }

                        // Action buttons
                        VStack(spacing: Spacing.sm) {
                            PrimaryButton(title: "Create Outfit", action: {})
                            SecondaryButton(title: "Edit Details", action: {})
                        }
                    }
                    .screenPadding()
                }
                .padding(.bottom, Spacing.xl)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MetadataGrid: View {
    let item: WardrobeItem

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: Spacing.md) {
            MetadataItem(label: "Category", value: item.category.rawValue)
            if let subcategory = item.subcategory {
                MetadataItem(label: "Type", value: subcategory)
            }
            MetadataItem(label: "Colors", value: item.colors.map { $0.rawValue }.joined(separator: ", "))
            MetadataItem(label: "Pattern", value: item.pattern.rawValue)
            MetadataItem(label: "Formality", value: item.formality.description)
            MetadataItem(label: "Seasons", value: item.seasons.map { $0.rawValue }.joined(separator: ", "))
        }
    }
}

struct MetadataItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Text(label)
                .font(.caption)
                .foregroundColor(.adaptiveTextSecondary)

            Text(value)
                .font(.callout)
                .foregroundColor(.adaptiveText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.sm)
                .fill(Color.backgroundSecondary)
        )
    }
}

struct UsageStats: View {
    let item: WardrobeItem

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Usage Stats")
                .font(.headline)
                .foregroundColor(.adaptiveText)

            HStack(spacing: Spacing.xl) {
                StatItem(icon: "circle.fill", label: "Times Worn", value: "\(item.timesWorn)")

                if let lastWorn = item.lastWornDate {
                    StatItem(icon: "calendar", label: "Last Worn", value: lastWorn.timeAgo())
                }

                if let costPerWear = item.costPerWear {
                    StatItem(icon: "dollarsign.circle", label: "Cost/Wear", value: String(format: "$%.2f", costPerWear))
                }
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .fill(Color.backgroundSecondary)
        )
    }
}

struct StatItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.terracotta)

            Text(value)
                .font(.headline)
                .foregroundColor(.adaptiveText)

            Text(label)
                .font(.caption2)
                .foregroundColor(.adaptiveTextSecondary)
        }
    }
}

// MARK: - Helper Extension

extension Date {
    func timeAgo() -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour], from: self, to: now)

        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Preview

#Preview("Wardrobe - Premium") {
    let appState = AppState.previewPremium
    return WardrobeView(appState: appState)
        .environmentObject(appState)
}

#Preview("Wardrobe - Free") {
    let appState = AppState.previewFree
    return WardrobeView(appState: appState)
        .environmentObject(appState)
}

#Preview("Item Detail") {
    ItemDetailView(item: PreviewData.wardrobeItems[0])
}

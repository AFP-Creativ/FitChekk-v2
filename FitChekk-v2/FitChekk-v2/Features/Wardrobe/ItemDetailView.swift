//
//  ItemDetailFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class ItemDetailState {
    let item: MockWardrobeItem
    var isFavorite: Bool
    var isArchived: Bool
    
    init(item: MockWardrobeItem) {
        self.item = item
        self.isFavorite = item.isFavorite
        self.isArchived = false
    }
}

// MARK: - Actions

enum ItemDetailAction {
    case onAppear
    case toggleFavorite
    case archiveTapped
    case deleteTapped
    case createOutfitTapped
    case editTapped
}

// MARK: - View

struct ItemDetailView: View {
    @State private var state: ItemDetailState

    init(item: MockWardrobeItem) {
        _state = State(initialValue: ItemDetailState(item: item))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.section) {
                // Large Item Image
                itemImageSection

                // Item Info
                itemInfoSection

                // Usage Stats
                usageStatsSection

                // Actions
                actionsSection
            }
            .padding(.horizontal, Spacing.screenMargin)
            .padding(.top, Spacing.topSafeArea)
            .padding(.bottom, Spacing.bottomSafeArea)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle(state.item.name ?? "Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {}) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(action: {}) {
                        Label("Archive", systemImage: "archivebox")
                    }
                    Button(role: .destructive, action: {}) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.accentPrimary)
                }
            }
        }
    }
    
    // MARK: - Item Image Section
    
    private var itemImageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CardStyle.cornerRadiusLarge)
                .fill(Color.backgroundSecondary)
                .frame(height: 400)
            
            Image(systemName: state.item.imagePlaceholder)
                .font(.system(size: 120))
                .foregroundColor(.textTertiary)
        }
        .largeCardStyle()
    }
    
    // MARK: - Item Info Section
    
    private var itemInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.standard) {
                InfoRow(label: "Category", value: "\(state.item.category.rawValue) > \(state.item.subCategory.rawValue)")
                InfoRow(label: "Colors", value: state.item.colors.joined(separator: ", "))
                InfoRow(label: "Times Worn", value: "\(state.item.timesWorn)")
                
                if let lastWorn = state.item.lastWornDate {
                    InfoRow(
                        label: "Last Worn",
                        value: formatDate(lastWorn)
                    )
                }
            }
            .padding(Spacing.standard)
            .cardStyle()
        }
    }
    
    // MARK: - Usage Stats Section
    
    private var usageStatsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Usage")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.group) {
                StatCard(
                    title: "Times Worn",
                    value: "\(state.item.timesWorn)",
                    icon: "arrow.clockwise"
                )
                
                StatCard(
                    title: "Last Worn",
                    value: state.item.lastWornDate != nil ? formatDate(state.item.lastWornDate!) : "Never",
                    icon: "calendar"
                )
            }
        }
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: Spacing.group) {
            Button(action: {
                state.isFavorite.toggle()
            }) {
                HStack {
                    Image(systemName: state.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(state.isFavorite ? .accentPrimary : .textSecondary)
                    Text(state.isFavorite ? "Favorited" : "Add to Favorites")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.standard)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
            }
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "tshirt.fill")
                        .foregroundColor(.accentPrimary)
                    Text("Create Outfit")
                        .font(.headline)
                        .foregroundColor(.accentPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.standard)
                .background(Color.accentPrimary.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: Spacing.verticalTight) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentPrimary)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.standard)
        .cardStyle()
    }
}

#Preview {
    ItemDetailView(item: MockWardrobeItem.sampleItems.first!)
}


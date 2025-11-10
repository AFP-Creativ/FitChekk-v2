//
//  OutfitBuilderFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class OutfitBuilderState {
    var selectedItems: [MockWardrobeItem] = []
    var outfitName: String = ""
    var occasion: OccasionType? = nil
    var notes: String = ""
    
    var availableItems: [MockWardrobeItem] = MockWardrobeItem.sampleItems
    
    var canSave: Bool {
        !selectedItems.isEmpty && !outfitName.isEmpty
    }
}

// MARK: - Actions

enum OutfitBuilderAction {
    case onAppear
    case itemSelected(MockWardrobeItem)
    case itemDeselected(MockWardrobeItem)
    case nameChanged(String)
    case occasionSelected(OccasionType?)
    case notesChanged(String)
    case saveTapped
    case cancelTapped
}

// MARK: - View

struct OutfitBuilderView: View {
    @State private var state = OutfitBuilderState()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.section) {
                    // Outfit Preview
                    outfitPreviewSection
                    
                    // Outfit Name
                    nameSection
                    
                    // Select Items by Category
                    itemsByCategorySection
                    
                    // Occasion & Notes
                    metadataSection
                }
                .padding(.horizontal, Spacing.screenMargin)
                .padding(.top, Spacing.topSafeArea)
                .padding(.bottom, Spacing.bottomSafeArea)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("New Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Save outfit
                        dismiss()
                    }
                    .disabled(!state.canSave)
                    .foregroundColor(state.canSave ? .accentPrimary : .textTertiary)
                }
            }
        }
    }
    
    // MARK: - Outfit Preview
    
    private var outfitPreviewSection: some View {
        VStack(spacing: Spacing.group) {
            Text("Outfit Preview")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if state.selectedItems.isEmpty {
                VStack(spacing: Spacing.group) {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.textTertiary)
                    
                    Text("Select items to build your outfit")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.generous)
                .cardStyle()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.group) {
                        ForEach(state.selectedItems) { item in
                            VStack(spacing: Spacing.verticalTight) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.backgroundSecondary)
                                        .frame(width: 100, height: 120)
                                    
                                    Image(systemName: item.imagePlaceholder)
                                        .font(.title)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                Text(item.name ?? "Item")
                                    .font(.caption)
                                    .foregroundColor(.textPrimary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.screenMargin)
                }
                .padding(.vertical, Spacing.standard)
                .cardStyle()
            }
        }
    }
    
    // MARK: - Name Section
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Outfit Name")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            TextField("e.g., Casual Friday", text: $state.outfitName)
                .textFieldStyle(.roundedBorder)
                .padding(Spacing.standard)
                .cardStyle()
        }
    }
    
    // MARK: - Items by Category
    
    private var itemsByCategorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            Text("Select Items")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ForEach(ItemCategory.allCases.prefix(4)) { category in
                categoryItemSection(category: category)
            }
        }
    }
    
    private func categoryItemSection(category: ItemCategory) -> some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(.accentPrimary)
                Text(category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.group) {
                    ForEach(state.availableItems.filter { $0.category == category }) { item in
                        ItemSelectionCard(
                            item: item,
                            isSelected: state.selectedItems.contains(where: { $0.id == item.id })
                        ) {
                            toggleItem(item)
                        }
                    }
                }
            }
        }
        .padding(.vertical, Spacing.standard)
        .cardStyle()
    }
    
    private func toggleItem(_ item: MockWardrobeItem) {
        if let index = state.selectedItems.firstIndex(where: { $0.id == item.id }) {
            state.selectedItems.remove(at: index)
        } else {
            state.selectedItems.append(item)
        }
    }
    
    // MARK: - Metadata Section
    
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Occasion")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.group) {
                    ForEach(OccasionType.allCases, id: \.rawValue) { occasion in
                        OccasionChip(
                            occasion: occasion,
                            isSelected: state.occasion == occasion
                        ) {
                            state.occasion = state.occasion == occasion ? nil : occasion
                        }
                    }
                }
            }
            
            Text("Notes (Optional)")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.group)
            
            TextField("Add notes about this outfit...", text: $state.notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
                .padding(Spacing.standard)
                .cardStyle()
        }
    }
}

// MARK: - Item Selection Card

struct ItemSelectionCard: View {
    let item: MockWardrobeItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.verticalTight) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundSecondary)
                        .frame(width: 80, height: 100)
                    
                    Image(systemName: item.imagePlaceholder)
                        .font(.title3)
                        .foregroundColor(.textSecondary)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accentPrimary)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            )
                            .offset(x: 30, y: -40)
                    }
                }
                
                Text(item.name ?? "Item")
                    .font(.caption2)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Occasion Chip

struct OccasionChip: View {
    let occasion: OccasionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(occasion.rawValue)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .padding(.horizontal, Spacing.standard)
                .padding(.vertical, Spacing.verticalTight)
                .background(isSelected ? Color.accentPrimary : Color.backgroundSecondary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    OutfitBuilderView()
}


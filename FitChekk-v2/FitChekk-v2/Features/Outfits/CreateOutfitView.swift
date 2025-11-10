//
//  CreateOutfitView.swift
//  FitChekk-v2
//
//  Create new outfit from wardrobe items
//

import SwiftUI

struct CreateOutfitView: View {
    @Environment(AppState.self) private var appState
    let onDismiss: () -> Void
    
    @State private var outfitName = ""
    @State private var selectedOccasion: OccasionType? = nil
    @State private var selectedItems: Set<UUID> = []
    @State private var notes = ""
    @State private var selectedCategory: ItemCategory? = nil
    
    var filteredItems: [WardrobeItem] {
        if let category = selectedCategory {
            return appState.wardrobeItems.filter { $0.category == category && !$0.isArchived }
        }
        return appState.wardrobeItems.filter { !$0.isArchived }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Selected items preview
                    if !selectedItems.isEmpty {
                        selectedItemsSection
                    }
                    
                    // Outfit details
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Name
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Outfit Name")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            TextField("e.g., Work from Home Chic", text: $outfitName)
                                .padding(Spacing.md)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.md)
                        }
                        
                        // Occasion
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Occasion (Optional)")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            
                            Picker("Occasion", selection: $selectedOccasion) {
                                Text("None").tag(nil as OccasionType?)
                                ForEach(OccasionType.allCases) { occasion in
                                    Text(occasion.displayName).tag(occasion as OccasionType?)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(Spacing.md)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.md)
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Notes (Optional)")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            TextEditor(text: $notes)
                                .frame(height: 80)
                                .padding(Spacing.sm)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.md)
                        }
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    
                    // Item selection
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Text("Select Items (\(selectedItems.count))")
                                .font(.displaySmall)
                                .foregroundColor(.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, Spacing.screenHorizontal)
                        
                        // Category filter
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
                                    isSelected: selectedItems.contains(item.id),
                                    onTap: {
                                        if selectedItems.contains(item.id) {
                                            selectedItems.remove(item.id)
                                        } else {
                                            selectedItems.insert(item.id)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, Spacing.screenHorizontal)
                    }
                    
                    // Action buttons
                    VStack(spacing: Spacing.sm) {
                        PrimaryButton(
                            title: "Create Outfit",
                            action: createOutfit,
                            isDisabled: selectedItems.count < 2
                        )
                        
                        SecondaryButton(title: "Cancel", action: onDismiss)
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                }
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Create Outfit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Selected Items Section
    
    private var selectedItemsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Selected Items")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(Array(selectedItems), id: \.self) { itemId in
                        if let item = appState.getItem(id: itemId) {
                            ZStack(alignment: .topTrailing) {
                                Color(hex: item.imageColor ?? "#D4C5B9")
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(CornerRadius.md)
                                
                                Button {
                                    selectedItems.remove(itemId)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color.accentPrimary))
                                }
                                .padding(4)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
    
    // MARK: - Actions
    
    private func createOutfit() {
        let newOutfit = Outfit(
            name: outfitName.isEmpty ? "Outfit \(appState.outfits.count + 1)" : outfitName,
            occasion: selectedOccasion,
            notes: notes.isEmpty ? nil : notes,
            aiGenerated: false,
            itemIds: Array(selectedItems)
        )
        
        appState.addOutfit(newOutfit)
        onDismiss()
    }
}

#Preview {
    CreateOutfitView(onDismiss: { })
        .environment(AppState())
}


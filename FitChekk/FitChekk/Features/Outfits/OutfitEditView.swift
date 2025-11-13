//
//  OutfitEditView.swift
//  FitChekk
//
//  View for editing existing outfits (reuses creation UI)
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct OutfitEditView: View {
    @Bindable var store: StoreOf<OutfitEditFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Form Section
                    formSection
                    
                    // Visual Outfit Canvas
                    outfitCanvasSection
                    
                    // Error Message
                    if let errorMessage = store.errorMessage {
                        errorBanner(message: errorMessage)
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Edit Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        store.send(.cancelTapped)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { store.send(.saveTapped) }, label: {
                        if store.isSaving {
                            ProgressView()
                                .tint(Color.accentPrimary)
                        } else {
                            Text("Save")
                                .fontWeight(.semibold)
                        }
                    })
                    .disabled(!store.isValid || store.isSaving)
                }
            }
            .sheet(isPresented: Binding(
                get: { store.isSelectingItems },
                set: { _ in }
            ), content: {
                WardrobeItemPickerView(
                    selectedItemIds: Set(store.selectedItems.map { $0.id }),
                    onItemsSelected: { items in
                        store.send(.itemsSelected(items))
                    },
                    onDismiss: {
                        store.send(.dismissItemPicker)
                    }
                )
            })
            .alert(
                "Discard Changes?",
                isPresented: Binding(
                    get: { store.showUnsavedChangesAlert },
                    set: { _ in }
                ),
                actions: {
                    Button("Cancel", role: .cancel) {
                        store.send(.dismissUnsavedChangesAlert)
                    }
                    Button("Discard", role: .destructive) {
                        store.send(.confirmCancel)
                    }
                },
                message: {
                    Text("Your unsaved changes will be lost.")
                }
            )
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    // MARK: - Form Section (Same as Creation)
    
    private var formSection: some View {
        VStack(spacing: Spacing.md) {
            // Outfit Name
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Outfit Name")
                    .font(Font.labelLarge)
                    .foregroundColor(Color.textSecondary)
                
                TextField(
                    "e.g., Date Night Look",
                    text: $store.outfitName.sending(\.outfitNameChanged)
                )
                .textFieldStyle(FitChekkTextFieldStyle())
            }
            
            // Occasion Picker
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Occasion (Optional)")
                    .font(Font.labelLarge)
                    .foregroundColor(Color.textSecondary)
                
                Picker(
                    selection: $store.occasion.sending(\.occasionChanged),
                    label: Text("Select Occasion"),
                    content: {
                        Text("None").tag(String?.none)
                        ForEach(OccasionType.allCases, id: \.self) { occasion in
                            Text(occasion.displayName).tag(String?.some(occasion.rawValue))
                        }
                    }
                )
                .pickerStyle(.menu)
                .padding(Spacing.sm)
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.md)
            }
            
            // Season Picker
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Season (Optional)")
                    .font(Font.labelLarge)
                    .foregroundColor(Color.textSecondary)
                
                Picker(
                    selection: $store.season.sending(\.seasonChanged),
                    label: Text("Select Season"),
                    content: {
                        Text("None").tag(String?.none)
                        ForEach(Season.allCases, id: \.self) { season in
                            Text(season.displayName).tag(String?.some(season.rawValue))
                        }
                    }
                )
                .pickerStyle(.segmented)
            }
            
            // Notes
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Notes (Optional)")
                    .font(Font.labelLarge)
                    .foregroundColor(Color.textSecondary)
                
                TextEditor(text: $store.notes.sending(\.notesChanged).defaultValue(""))
                    .frame(minHeight: 80)
                    .padding(Spacing.xs)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .stroke(Color.borderDefault, lineWidth: 1)
                    )
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    // MARK: - Outfit Canvas Section (Same as Creation)
    
    private var outfitCanvasSection: some View {
        VStack(spacing: Spacing.md) {
            // Header
            HStack {
                Text("Outfit Items")
                    .font(Font.headlineMedium)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Text("\(store.selectedItems.count) items")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
                
                if store.selectedItems.count < 2 {
                    Text("(min 2)")
                        .font(Font.captionRegular)
                        .foregroundColor(Color.error)
                }
            }
            
            if store.selectedItems.isEmpty {
                // Empty State
                emptyCanvasState
            } else {
                // Item Grid
                itemGridView
            }
            
            // Add Items Button
            SecondaryButton(
                title: store.selectedItems.isEmpty ? "Add Items" : "Add More Items",
                action: { store.send(.addItemsTapped) }
            )
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    private var emptyCanvasState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "tshirt")
                .font(.system(size: 60))
                .foregroundColor(Color.textTertiary)
            
            Text("No items in outfit")
                .font(Font.bodyLarge)
                .foregroundColor(Color.textSecondary)
            
            Text("Add items from your wardrobe")
                .font(Font.bodyRegular)
                .foregroundColor(Color.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }
    
    private var itemGridView: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.md),
                GridItem(.flexible(), spacing: Spacing.md)
            ],
            spacing: Spacing.md,
            content: {
                ForEach(store.selectedItems) { item in
                    itemCard(item: item)
                }
            }
        )
    }
    
    private func itemCard(item: WardrobeItem) -> some View {
        VStack(spacing: Spacing.xs) {
            // Image
            ZStack(alignment: .topTrailing) {
                if let imageURL = item.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { phase in
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
                
                // Remove Button
                Button(action: { store.send(.removeItem(item.id)) }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color.white)
                        .background(
                            Circle()
                                .fill(Color.error)
                                .frame(width: 24, height: 24)
                        )
                })
                .padding(Spacing.xs)
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            
            // Item Name
            Text(item.displayName)
                .font(Font.captionMedium)
                .foregroundColor(Color.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xs)
        .background(Color.backgroundPrimary)
        .cornerRadius(CornerRadius.md)
    }
    
    private func placeholderImage(for item: WardrobeItem) -> some View {
        ZStack {
            Color.backgroundSecondary
            
            Image(systemName: item.categoryEnum.icon)
                .font(.system(size: 40))
                .foregroundColor(Color.textTertiary)
        }
    }
    
    private func errorBanner(message: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.error)
            
            Text(message)
                .font(Font.bodyMedium)
                .foregroundColor(Color.error)
            
            Spacer()
        }
        .padding(Spacing.sm)
        .background(Color.error.opacity(0.1))
        .cornerRadius(CornerRadius.md)
    }
}

// MARK: - Preview

#Preview {
    OutfitEditView(
        store: Store(
            initialState: OutfitEditFeature.State(
                outfit: Outfit(
                    userId: UUID(),
                    name: "Summer Brunch",
                    occasion: "brunch",
                    season: "summer",
                    itemIds: [UUID(), UUID(), UUID()]
                )
            )
        ) {
            OutfitEditFeature()
        }
    )
}

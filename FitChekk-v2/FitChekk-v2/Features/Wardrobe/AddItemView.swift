//
//  AddItemView.swift
//  FitChekk-v2
//
//  Add new item to wardrobe
//

import SwiftUI

struct AddItemView: View {
    @Environment(AppState.self) private var appState
    let onDismiss: () -> Void
    
    @State private var selectedCategory: ItemCategory = .tops
    @State private var selectedSubCategory: ItemSubCategory = .graphicTees
    @State private var itemName = ""
    @State private var brand = ""
    @State private var selectedColor = "#D4C5B9"
    @State private var notes = ""
    @State private var isAnalyzing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Image placeholder
                    ZStack {
                        Color(hex: selectedColor)
                        
                        VStack(spacing: Spacing.md) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Tap to add photo")
                                .font(.bodyMedium)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(CornerRadius.xl)
                    .onTapGesture {
                        // Open camera/photo library
                    }
                    
                    // AI Analysis badge (for Premium users)
                    if appState.currentUser.subscriptionTier == .premium {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.accentPrimary)
                            Text("AI will categorize this item automatically")
                                .font(.labelLarge)
                                .foregroundColor(.textSecondary)
                            Spacer()
                        }
                        .padding(Spacing.md)
                        .background(Color.energySubtle.opacity(0.3))
                        .cornerRadius(CornerRadius.md)
                    }
                    
                    // Form fields
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Name
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Item Name")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            TextField("e.g., Navy Cable Knit Sweater", text: $itemName)
                                .padding(Spacing.md)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.md)
                        }
                        
                        // Category
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Category")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(ItemCategory.allCases) { category in
                                    Text(category.displayName).tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(Spacing.md)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.md)
                        }
                        
                        // Brand (optional)
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Brand (Optional)")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            TextField("e.g., J.Crew", text: $brand)
                                .padding(Spacing.md)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.md)
                        }
                        
                        // Color picker
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Primary Color")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Spacing.sm) {
                                    ForEach(colorOptions, id: \.self) { color in
                                        Circle()
                                            .fill(Color(hex: color))
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.accentPrimary, lineWidth: selectedColor == color ? 3 : 0)
                                            )
                                            .onTapGesture {
                                                selectedColor = color
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Notes (Optional)")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(Spacing.sm)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.md)
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: Spacing.sm) {
                        PrimaryButton(
                            title: isAnalyzing ? "Analyzing..." : "Add to Wardrobe",
                            action: addItem,
                            isLoading: isAnalyzing
                        )
                        
                        SecondaryButton(title: "Cancel", action: onDismiss)
                    }
                }
                .padding(Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Actions
    
    private func addItem() {
        isAnalyzing = true
        
        // Simulate AI analysis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let newItem = WardrobeItem(
                name: itemName.isEmpty ? nil : itemName,
                category: selectedCategory,
                subCategory: selectedSubCategory,
                brand: brand.isEmpty ? nil : brand,
                imageColor: selectedColor,
                aiGenerated: appState.currentUser.subscriptionTier == .premium,
                colors: [colorNames[selectedColor] ?? "neutral"],
                formality: .casual,
                styleTags: ["classic"],
                seasons: [.fall, .winter],
                aiConfidence: 0.92
            )
            
            appState.addWardrobeItem(newItem)
            isAnalyzing = false
            onDismiss()
        }
    }
    
    // MARK: - Color Options
    
    private let colorOptions = [
        "#2D2A27", // Black
        "#FAFAF9", // White
        "#1B3A5F", // Navy
        "#D4C5B9", // Camel/Tan
        "#8B8681", // Grey
        "#7A6F5F", // Brown
        "#C17B6F", // Terracotta
        "#7A8A5F", // Olive
        "#A8B89F", // Sage
        "#D7584D", // Red
    ]
    
    private let colorNames: [String: String] = [
        "#2D2A27": "black",
        "#FAFAF9": "white",
        "#1B3A5F": "navy",
        "#D4C5B9": "camel",
        "#8B8681": "grey",
        "#7A6F5F": "brown",
        "#C17B6F": "terracotta",
        "#7A8A5F": "olive",
        "#A8B89F": "sage",
        "#D7584D": "red",
    ]
}

#Preview {
    AddItemView(onDismiss: { })
        .environment(AppState())
}


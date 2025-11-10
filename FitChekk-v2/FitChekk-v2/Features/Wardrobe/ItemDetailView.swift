//
//  ItemDetailView.swift
//  FitChekk-v2
//
//  Detailed view of a wardrobe item
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let item: WardrobeItem
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Large item image
                    ZStack {
                        if let colorHex = item.imageColor {
                            Color(hex: colorHex)
                        } else {
                            Color.backgroundSecondary
                        }
                        
                        // Favorite badge
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    appState.toggleFavorite(item)
                                } label: {
                                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                        .font(.title2)
                                        .foregroundColor(item.isFavorite ? .accentPrimary : .white)
                                        .padding()
                                        .background(Circle().fill(Color.black.opacity(0.3)))
                                }
                                .padding()
                            }
                            Spacer()
                        }
                    }
                    .frame(height: 400)
                    .cornerRadius(CornerRadius.xl)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    
                    // Item details
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Name and category
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text(item.displayName)
                                .font(.displayMedium)
                                .foregroundColor(.textPrimary)
                            
                            HStack {
                                Text("\(item.category.displayName) • \(item.subCategory.displayName)")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                
                                if let brand = item.brand {
                                    Text("• \(brand)")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        
                        // Stats
                        VStack(spacing: Spacing.sm) {
                            InfoCard(
                                title: "Times Worn",
                                value: "\(item.timesWorn) times",
                                icon: "checkmark.circle"
                            )
                            
                            if let lastWorn = item.lastWornDate {
                                InfoCard(
                                    title: "Last Worn",
                                    value: lastWorn.formatted(date: .abbreviated, time: .omitted),
                                    icon: "clock"
                                )
                            }
                            
                            if let costPerWear = item.costPerWear {
                                InfoCard(
                                    title: "Cost Per Wear",
                                    value: "$\(costPerWear)",
                                    icon: "dollarsign.circle"
                                )
                            }
                        }
                        
                        // AI Attributes (if available)
                        if item.aiGenerated {
                            aiAttributesSection
                        }
                        
                        // Colors
                        if !item.colors.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Colors")
                                    .font(.headlineMedium)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: Spacing.xs) {
                                    ForEach(item.colors, id: \.self) { color in
                                        Text(color.capitalized)
                                            .font(.labelLarge)
                                            .padding(.horizontal, Spacing.sm)
                                            .padding(.vertical, Spacing.xxs)
                                            .background(Color.backgroundSecondary)
                                            .cornerRadius(CornerRadius.sm)
                                    }
                                }
                            }
                        }
                        
                        // Style tags
                        if !item.styleTags.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Style Tags")
                                    .font(.headlineMedium)
                                    .foregroundColor(.textPrimary)
                                
                                FlowLayout(spacing: Spacing.xs) {
                                    ForEach(item.styleTags, id: \.self) { tag in
                                        Text(tag.capitalized)
                                            .font(.labelLarge)
                                            .padding(.horizontal, Spacing.sm)
                                            .padding(.vertical, Spacing.xxs)
                                            .background(Color.accentPrimary.opacity(0.1))
                                            .foregroundColor(.accentPrimary)
                                            .cornerRadius(CornerRadius.sm)
                                    }
                                }
                            }
                        }
                        
                        // Seasons
                        if !item.seasons.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Best Seasons")
                                    .font(.headlineMedium)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: Spacing.xs) {
                                    ForEach(item.seasons, id: \.self) { season in
                                        HStack(spacing: 4) {
                                            Image(systemName: season.icon)
                                            Text(season.displayName)
                                        }
                                        .font(.labelLarge)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.xxs)
                                        .background(Color.backgroundSecondary)
                                        .foregroundColor(.textPrimary)
                                        .cornerRadius(CornerRadius.sm)
                                    }
                                }
                            }
                        }
                        
                        // Notes (if any)
                        if let notes = item.notes, !notes.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Notes")
                                    .font(.headlineMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Text(notes)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                    .padding(Spacing.md)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(CornerRadius.md)
                            }
                        }
                        
                        // Action buttons
                        VStack(spacing: Spacing.sm) {
                            PrimaryButton(title: "Create Outfit with This") {
                                // Navigate to outfit creation
                                dismiss()
                            }
                            
                            SecondaryButton(title: "Edit Item") {
                                // Show edit view
                            }
                            
                            Button(role: .destructive) {
                                appState.deleteWardrobeItem(item)
                                dismiss()
                            } label: {
                                Text("Delete Item")
                                    .font(.bodyMedium)
                                    .foregroundColor(.error)
                            }
                            .padding(.top, Spacing.sm)
                        }
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                }
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Share item
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    // MARK: - AI Attributes Section
    
    private var aiAttributesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("AI Analysis")
                    .font(.headlineMedium)
                    .foregroundColor(.textPrimary)
                
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.accentPrimary)
            }
            
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("Formality")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(item.formality.displayName)
                        .font(.bodyMedium.weight(.medium))
                        .foregroundColor(.textPrimary)
                }
                
                if let pattern = item.pattern {
                    HStack {
                        Text("Pattern")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(pattern.capitalized)
                            .font(.bodyMedium.weight(.medium))
                            .foregroundColor(.textPrimary)
                    }
                }
                
                if let material = item.materialType {
                    HStack {
                        Text("Material")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(material.capitalized)
                            .font(.bodyMedium.weight(.medium))
                            .foregroundColor(.textPrimary)
                    }
                }
                
                HStack {
                    Text("AI Confidence")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("\(Int(item.aiConfidence * 100))%")
                        .font(.bodyMedium.weight(.medium))
                        .foregroundColor(.success)
                }
            }
            .padding(Spacing.md)
            .background(Color.energySubtle.opacity(0.2))
            .cornerRadius(CornerRadius.md)
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        let height = rows.reduce(0) { $0 + $1.height }
        return CGSize(width: proposal.width ?? 0, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            for (index, size) in zip(row.indices, row.sizes) {
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row()
        var x: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > maxWidth && !currentRow.indices.isEmpty {
                rows.append(currentRow)
                currentRow = Row()
                x = 0
            }
            
            currentRow.indices.append(subviews.firstIndex(of: subview)!)
            currentRow.sizes.append(size)
            currentRow.height = max(currentRow.height, size.height + spacing)
            x += size.width + spacing
        }
        
        if !currentRow.indices.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    struct Row {
        var indices: [Int] = []
        var sizes: [CGSize] = []
        var height: CGFloat = 0
    }
}

#Preview {
    ItemDetailView(item: MockData.wardrobeItems[0])
        .environment(AppState())
}


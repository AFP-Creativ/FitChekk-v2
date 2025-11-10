//
//  OutfitDetailView.swift
//  FitChekk-v2
//
//  Detailed view of an outfit
//

import SwiftUI

struct OutfitDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let outfit: Outfit
    
    var outfitItems: [WardrobeItem] {
        outfit.itemIds.compactMap { appState.getItem(id: $0) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Outfit image
                    ZStack {
                        Color.backgroundSecondary
                        
                        HStack(spacing: 8) {
                            ForEach(outfitItems.prefix(3)) { item in
                                Color(hex: item.imageColor ?? "#D4C5B9")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(Spacing.xl)
                        
                        // AI badge
                        if outfit.aiGenerated {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("AI Suggested ✨")
                                        .font(.labelSmall.weight(.semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.xxs)
                                        .background(Color.accentPrimary)
                                        .cornerRadius(CornerRadius.sm)
                                        .padding()
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 400)
                    .cornerRadius(CornerRadius.xl)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    
                    // Outfit details
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Name and occasion
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text(outfit.name)
                                .font(.displayMedium)
                                .foregroundColor(.textPrimary)
                            
                            HStack(spacing: Spacing.sm) {
                                if let occasion = outfit.occasion {
                                    HStack(spacing: 4) {
                                        Image(systemName: occasion.icon)
                                        Text(occasion.displayName)
                                    }
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                }
                                
                                if outfit.timesWorn > 0 {
                                    Text("• Worn \(outfit.timesWorn)x")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textTertiary)
                                }
                            }
                        }
                        
                        // AI Reasoning
                        if outfit.aiGenerated, let reasoning = outfit.aiReasoning {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Text("Why This Works")
                                        .font(.headlineMedium)
                                        .foregroundColor(.textPrimary)
                                    
                                    Image(systemName: "sparkles")
                                        .font(.caption)
                                        .foregroundColor(.accentPrimary)
                                }
                                
                                Text(reasoning)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                    .padding(Spacing.md)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.energySubtle.opacity(0.3))
                                    .cornerRadius(CornerRadius.md)
                            }
                        }
                        
                        // Stats
                        if outfit.timesWorn > 0 || outfit.lastWornDate != nil || outfit.userRating != nil {
                            VStack(spacing: Spacing.sm) {
                                if outfit.timesWorn > 0 {
                                    InfoCard(
                                        title: "Times Worn",
                                        value: "\(outfit.timesWorn) times",
                                        icon: "checkmark.circle"
                                    )
                                }
                                
                                if let lastWorn = outfit.lastWornDate {
                                    InfoCard(
                                        title: "Last Worn",
                                        value: lastWorn.formatted(date: .abbreviated, time: .omitted),
                                        icon: "clock"
                                    )
                                }
                                
                                if let rating = outfit.userRating {
                                    InfoCard(
                                        title: "Your Rating",
                                        value: String(repeating: "⭐️", count: rating),
                                        icon: "star"
                                    )
                                }
                            }
                        }
                        
                        // Weather snapshot (if available)
                        if let weather = outfit.weatherSnapshot {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Weather When Created")
                                    .font(.headlineMedium)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: Spacing.md) {
                                    Image(systemName: weather.conditionIcon)
                                        .font(.title)
                                        .foregroundColor(.accentPrimary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(Int(weather.tempHigh))° / \(Int(weather.tempLow))°")
                                            .font(.bodyLarge.weight(.semibold))
                                            .foregroundColor(.textPrimary)
                                        
                                        Text(weather.condition)
                                            .font(.bodyMedium)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(Spacing.md)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.md)
                            }
                        }
                        
                        // Items in outfit
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("Items (\(outfitItems.count))")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: Spacing.gridGap),
                                    GridItem(.flexible(), spacing: Spacing.gridGap)
                                ],
                                spacing: Spacing.gridGap
                            ) {
                                ForEach(outfitItems) { item in
                                    Button {
                                        // View item detail
                                    } label: {
                                        VStack(spacing: Spacing.xs) {
                                            Color(hex: item.imageColor ?? "#D4C5B9")
                                                .frame(height: 120)
                                                .cornerRadius(CornerRadius.md)
                                            
                                            Text(item.displayName)
                                                .font(.caption)
                                                .foregroundColor(.textPrimary)
                                                .lineLimit(1)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        // Notes
                        if let notes = outfit.notes, !notes.isEmpty {
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
                        
                        // Actions
                        VStack(spacing: Spacing.sm) {
                            PrimaryButton(title: "Schedule to Calendar") {
                                // Schedule outfit
                                dismiss()
                            }
                            
                            SecondaryButton(title: "Wear Today") {
                                // Mark as worn
                                dismiss()
                            }
                            
                            Button(role: .destructive) {
                                appState.deleteOutfit(outfit)
                                dismiss()
                            } label: {
                                Text("Delete Outfit")
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
                        // Share outfit
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

#Preview {
    OutfitDetailView(outfit: MockData.outfits[0])
        .environment(AppState())
}


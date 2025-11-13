//
//  OutfitCard.swift
//  FitChekk
//
//  Reusable outfit card component with thumbnail collage
//

import SwiftUI
import ComposableArchitecture

struct OutfitCard: View {
    let outfit: Outfit
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap, label: {
            VStack(alignment: .leading, spacing: 0) {
                // Thumbnail Collage
                thumbnailPlaceholder
                    .frame(height: 180)
                    .clipped()
                
                // Outfit Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    // Name and AI Badge
                    HStack(spacing: Spacing.xs) {
                        Text(outfit.name)
                            .font(Font.headlineSmall)
                            .foregroundColor(Color.textPrimary)
                            .lineLimit(2)
                        
                        Spacer(minLength: 0)
                        
                        if outfit.aiGenerated {
                            HStack(spacing: 2) {
                                Text("AI")
                                Image(systemName: "sparkles")
                            }
                            .font(Font.captionMedium)
                            .foregroundColor(Color.accentPrimary)
                            .padding(.horizontal, Spacing.xs)
                            .padding(.vertical, 2)
                            .background(Color.accentPrimary.opacity(0.1))
                            .cornerRadius(CornerRadius.sm)
                        }
                    }
                    
                    // Metadata
                    HStack(spacing: Spacing.xs) {
                        // Item Count
                        Label("\(outfit.itemCount)", systemImage: "tshirt")
                            .font(Font.captionRegular)
                            .foregroundColor(Color.textSecondary)
                        
                        if let occasion = outfit.occasion {
                            Text("•")
                                .foregroundColor(Color.textTertiary)
                            
                            Text(occasion.capitalized)
                                .font(Font.captionRegular)
                                .foregroundColor(Color.textSecondary)
                        }
                        
                        if let seasonStr = outfit.season, let season = Season(rawValue: seasonStr) {
                            Text("•")
                                .foregroundColor(Color.textTertiary)
                            
                            Image(systemName: season.icon)
                                .font(Font.captionRegular)
                                .foregroundColor(Color.textSecondary)
                        }
                    }
                    .lineLimit(1)
                }
                .padding(Spacing.sm)
            }
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.lg)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        })
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: onTap, label: {
                Label("View Details", systemImage: "eye")
            })
            
            Button(role: .destructive, action: onDelete, label: {
                Label("Delete", systemImage: "trash")
            })
        }
    }
    
    // MARK: - Thumbnail Placeholder
    
    @ViewBuilder
    private var thumbnailPlaceholder: some View {
        ZStack {
            Color.backgroundSecondary
            
            VStack(spacing: Spacing.xs) {
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color.textTertiary)
                
                Text("\(outfit.itemCount) items")
                    .font(Font.captionRegular)
                    .foregroundColor(Color.textSecondary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        OutfitCard(
            outfit: Outfit(
                userId: UUID(),
                name: "Casual Weekend Look",
                occasion: "casual",
                aiGenerated: false,
                itemIds: [UUID(), UUID(), UUID()]
            ),
            onTap: {},
            onDelete: {}
        )
        .frame(width: 180)
        
        OutfitCard(
            outfit: Outfit(
                userId: UUID(),
                name: "AI Summer Outfit",
                occasion: "brunch",
                season: "summer",
                aiGenerated: true,
                aiStyleScore: 0.92,
                itemIds: [UUID(), UUID(), UUID(), UUID()]
            ),
            onTap: {},
            onDelete: {}
        )
        .frame(width: 180)
    }
    .padding()
}

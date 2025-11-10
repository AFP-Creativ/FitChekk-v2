//
//  Cards.swift
//  FitChekk-v2
//
//  Reusable card components
//

import SwiftUI

// MARK: - Item Card

struct ItemCard: View {
    let item: WardrobeItem
    let isSelected: Bool
    let onTap: () -> Void
    let onFavoriteToggle: (() -> Void)?
    
    init(
        item: WardrobeItem,
        isSelected: Bool = false,
        onTap: @escaping () -> Void,
        onFavoriteToggle: (() -> Void)? = nil
    ) {
        self.item = item
        self.isSelected = isSelected
        self.onTap = onTap
        self.onFavoriteToggle = onFavoriteToggle
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Item image placeholder
                ZStack {
                    if let colorHex = item.imageColor {
                        Color(hex: colorHex)
                    } else {
                        Color.backgroundSecondary
                    }
                    
                    // Favorite badge
                    if item.isFavorite {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.accentPrimary)
                                    .font(.system(size: 14))
                                    .padding(8)
                            }
                            Spacer()
                        }
                    }
                    
                    // Selection checkmark
                    if isSelected {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color.accentPrimary)
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.caption.weight(.bold))
                                            .foregroundColor(.white)
                                    )
                                    .padding(8)
                            }
                            Spacer()
                        }
                    }
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg, style: .continuous))
                
                // Item name
                Text(item.displayName)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.lg)
            .itemCardShadow(isSelected: isSelected)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(Color.accentPrimary, lineWidth: isSelected ? 2 : 0)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Outfit Card

struct OutfitCard: View {
    let outfit: Outfit
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                // Outfit image placeholder
                ZStack {
                    Color.backgroundSecondary
                    
                    // Simple placeholder grid representing outfit items
                    HStack(spacing: 4) {
                        Color.accentPrimary.opacity(0.3)
                        Color.accentPrimary.opacity(0.5)
                        Color.accentPrimary.opacity(0.4)
                    }
                    .padding(Spacing.xl)
                }
                .frame(height: 200)
                .cornerRadius(CornerRadius.xl)
                
                // Outfit info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(outfit.name)
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: Spacing.xs) {
                        if let occasion = outfit.occasion {
                            HStack(spacing: 4) {
                                Image(systemName: occasion.icon)
                                Text(occasion.displayName)
                            }
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                        }
                        
                        if outfit.timesWorn > 0 {
                            Text("• Worn \(outfit.timesWorn)x")
                                .font(.labelSmall)
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
                .padding(.horizontal, Spacing.sm)
            }
            .padding(Spacing.md)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.xl)
            .itemCardShadow()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Weather Card

struct WeatherCard: View {
    let weather: WeatherSnapshot
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(isToday ? "Today" : weather.date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.labelSmall)
                .foregroundColor(.textSecondary)
            
            Image(systemName: weather.conditionIcon)
                .font(.title3)
                .foregroundColor(.accentPrimary)
            
            Text(weather.displayTemp)
                .font(.bodyMedium.weight(.semibold))
                .foregroundColor(.textPrimary)
        }
        .frame(width: 60)
        .padding(.vertical, Spacing.sm)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.md)
    }
}

// MARK: - Info Card

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentPrimary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.labelLarge)
                    .foregroundColor(.textSecondary)
                Text(value)
                    .font(.headlineMedium)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.md)
    }
}

// MARK: - Previews

#Preview("Cards") {
    ScrollView {
        VStack(spacing: Spacing.lg) {
            // Item Card
            HStack(spacing: Spacing.md) {
                ItemCard(
                    item: MockData.wardrobeItems[0],
                    onTap: { }
                )
                ItemCard(
                    item: MockData.wardrobeItems[1],
                    isSelected: true,
                    onTap: { }
                )
            }
            
            // Outfit Card
            OutfitCard(
                outfit: MockData.outfits[0],
                onTap: { }
            )
            
            // Weather Cards
            HStack(spacing: Spacing.xs) {
                ForEach(Array(MockData.weekWeather.prefix(5).enumerated()), id: \.offset) { index, weather in
                    WeatherCard(weather: weather, isToday: index == 0)
                }
            }
            
            // Info Card
            InfoCard(
                title: "Times Worn",
                value: "12 times",
                icon: "checkmark.circle"
            )
        }
        .padding()
    }
    .background(Color.backgroundPrimary)
}


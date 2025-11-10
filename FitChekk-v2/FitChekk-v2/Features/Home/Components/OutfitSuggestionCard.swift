//
//  OutfitSuggestionCard.swift
//  FitChekk-v2
//
//  AI outfit suggestion display card
//

import SwiftUI

struct OutfitSuggestionCard: View {
    let suggestion: OutfitSuggestion
    let wardrobeItems: [WardrobeItem]
    let onUse: () -> Void
    let onSuggestAnother: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            HStack {
                Text("Today's Outfit")
                    .font(.headline)
                    .foregroundColor(.adaptiveText)

                Spacer()

                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                    Text("AI Suggested")
                        .font(.caption)
                }
                .foregroundColor(.terracotta)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, Spacing.xxs)
                .background(
                    Capsule()
                        .fill(Color.terracotta.opacity(0.15))
                )
            }

            // Outfit Visual (simplified for mockup)
            OutfitCompositeView(items: outfitItems)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(Color.backgroundElevated)
                )

            // AI Reasoning
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Image(systemName: "brain")
                        .font(.caption)
                        .foregroundColor(.terracotta)

                    Text("Why this works")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.adaptiveText)
                }

                Text(suggestion.reasoning)
                    .font(.callout)
                    .foregroundColor(.adaptiveTextSecondary)
                    .lineLimit(4)
            }
            .padding(Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(Color.softPeach.opacity(0.15))
            )

            // Action Buttons
            HStack(spacing: Spacing.md) {
                SecondaryButton(title: "Suggest Another", action: onSuggestAnother)
                PrimaryButton(title: "Use This Outfit", action: onUse)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.card)
                .fill(Color.backgroundSecondary)
        )
        .cardShadow()
    }

    private var outfitItems: [WardrobeItem] {
        suggestion.outfit.items(from: wardrobeItems)
    }
}

// MARK: - Outfit Composite View

struct OutfitCompositeView: View {
    let items: [WardrobeItem]

    var body: some View {
        if items.isEmpty {
            EmptyOutfitPlaceholder()
        } else {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    ForEach(items) { item in
                        ItemBadge(item: item)
                    }
                }
                .padding(Spacing.md)
            }
        }
    }
}

struct EmptyOutfitPlaceholder: View {
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "tshirt")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)

            Text("No items in outfit")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ItemBadge: View {
    let item: WardrobeItem

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Placeholder for item image
            RoundedRectangle(cornerRadius: CornerRadius.sm)
                .fill(item.primaryColor.swiftUIColor.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: item.category.icon)
                        .font(.title3)
                        .foregroundColor(item.primaryColor.swiftUIColor)
                )

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(item.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.adaptiveText)

                Text(item.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.adaptiveTextSecondary)
            }

            Spacer()
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.sm)
                .fill(Color.backgroundPrimary)
        )
    }
}

// MARK: - Helper Extension

extension ItemColor {
    var swiftUIColor: Color {
        switch self {
        case .black: return .black
        case .white: return Color(white: 0.95)
        case .gray: return .gray
        case .brown: return Color(hex: "8B4513")
        case .beige: return Color(hex: "F5F5DC")
        case .navy: return Color(hex: "000080")
        case .blue: return .blue
        case .red: return .red
        case .pink: return .pink
        case .purple: return .purple
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .multicolor: return .gray
        }
    }
}

// MARK: - Loading State

struct OutfitSuggestionLoadingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Generating outfit...")
                .font(.headline)
                .foregroundColor(.adaptiveText)

            LoadingSpinner(message: "Analyzing your wardrobe and today's weather...", size: 50)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.card)
                .fill(Color.backgroundSecondary)
        )
        .cardShadow()
    }
}

// MARK: - Preview

#Preview("Outfit Suggestion Card") {
    ScrollView {
        VStack(spacing: Spacing.xl) {
            OutfitSuggestionCard(
                suggestion: OutfitSuggestion(
                    outfit: PreviewData.outfits[0],
                    reasoning: PreviewData.outfits[0].aiReasoning ?? "Great outfit!"
                ),
                wardrobeItems: PreviewData.wardrobeItems,
                onUse: {},
                onSuggestAnother: {}
            )

            OutfitSuggestionLoadingCard()
        }
        .screenPadding()
        .padding(.vertical, Spacing.xl)
    }
    .background(Color.backgroundPrimary)
}

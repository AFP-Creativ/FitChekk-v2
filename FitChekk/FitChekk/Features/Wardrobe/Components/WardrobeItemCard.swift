//
//  WardrobeItemCard.swift
//  FitChekk
//
//  Reusable card component for displaying wardrobe items in grid
//

import SwiftUI

struct WardrobeItemCard: View {
    let item: WardrobeItem
    let onTap: () -> Void
    let onFavoriteTap: (() -> Void)?

    init(
        item: WardrobeItem,
        onTap: @escaping () -> Void,
        onFavoriteTap: (() -> Void)? = nil
    ) {
        self.item = item
        self.onTap = onTap
        self.onFavoriteTap = onFavoriteTap
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                // Image
                ZStack(alignment: .topTrailing) {
                    if let thumbnailURL = item.thumbnailURL {
                        AsyncImage(url: URL(string: thumbnailURL)) { phase in
                            switch phase {
                            case .empty:
                                placeholderView
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                placeholderView
                            @unknown default:
                                placeholderView
                            }
                        }
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        placeholderView
                    }

                    // Favorite Button
                    if let onFavoriteTap = onFavoriteTap {
                        Button(action: {
                            onFavoriteTap()
                        }) {
                            Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(item.isFavorite ? .red : .white)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                )
                                .shadow(radius: 2)
                        }
                        .padding(Spacing.xs)
                    }
                }

                // Item Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.displayName)
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: item.categoryEnum.icon)
                            .font(.system(size: 10))

                        Text(item.subCategoryEnum.displayName)
                            .font(Font.captionRegular)
                    }
                    .foregroundColor(Color.textSecondary)

                    // Colors
                    if !item.colors.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(item.colors.prefix(3), id: \.self) { colorName in
                                Circle()
                                    .fill(colorFromString(colorName))
                                    .frame(width: 12, height: 12)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.borderSubtle, lineWidth: 0.5)
                                    )
                            }

                            if item.colors.count > 3 {
                                Text("+\(item.colors.count - 3)")
                                    .font(Font.captionRegular)
                                    .foregroundColor(Color.textTertiary)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.xxs)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundSecondary)

            Image(systemName: item.categoryEnum.icon)
                .font(.system(size: 40))
                .foregroundColor(Color.textTertiary)
        }
        .frame(height: 180)
    }

    // Simple color mapping
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "brown": return .brown
        case "black": return .black
        case "white": return .white
        case "gray", "grey": return .gray
        case "navy": return Color(red: 0, green: 0, blue: 0.5)
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "cream": return Color(red: 1, green: 0.99, blue: 0.82)
        case "olive": return Color(red: 0.5, green: 0.5, blue: 0)
        case "maroon": return Color(red: 0.5, green: 0, blue: 0)
        case "teal": return Color(red: 0, green: 0.5, blue: 0.5)
        default: return .gray
        }
    }
}

// MARK: - Preview

#Preview("Wardrobe Item Card") {
    let sampleItem = WardrobeItem(
        userId: UUID(),
        name: "Blue Denim Jacket",
        category: .outerwear,
        subCategory: .jackets,
        brand: "Levi's",
        colors: ["Blue", "Black"],
        seasons: [.spring, .fall],
        isFavorite: true
    )

    return WardrobeItemCard(
        item: sampleItem,
        onTap: {},
        onFavoriteTap: {}
    )
    .frame(width: 180)
    .padding()
}

#Preview("Multiple Cards Grid") {
    let items = [
        WardrobeItem(
            userId: UUID(),
            name: "Blue Denim Jacket",
            category: .outerwear,
            subCategory: .jackets,
            colors: ["Blue"],
            isFavorite: true
        ),
        WardrobeItem(
            userId: UUID(),
            name: "White T-Shirt",
            category: .tops,
            subCategory: .basicTees,
            colors: ["White"]
        ),
        WardrobeItem(
            userId: UUID(),
            category: .bottoms,
            subCategory: .jeans,
            colors: ["Black", "Gray"],
            isFavorite: false
        ),
        WardrobeItem(
            userId: UUID(),
            category: .shoes,
            subCategory: .sneakers,
            colors: ["White", "Red", "Blue", "Black"]
        )
    ]

    return ScrollView {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.md),
                GridItem(.flexible(), spacing: Spacing.md)
            ],
            spacing: Spacing.md
        ) {
            ForEach(items, id: \.id) { item in
                WardrobeItemCard(
                    item: item,
                    onTap: {},
                    onFavoriteTap: {}
                )
            }
        }
        .padding(Spacing.md)
    }
}

//
//  ItemCard.swift
//  FitChekk-v2
//
//  Wardrobe item card for grid display
//

import SwiftUI

struct ItemCard: View {
    let item: WardrobeItem
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Spacing.xs) {
                // Item Image
                ZStack(alignment: .topTrailing) {
                    // Placeholder image (color-coded by category)
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(item.primaryColor.swiftUIColor.opacity(0.2))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            Image(systemName: item.category.icon)
                                .font(.system(size: 48))
                                .foregroundColor(item.primaryColor.swiftUIColor.opacity(0.6))
                        )

                    // Favorite indicator
                    if item.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.terracotta)
                            .padding(Spacing.xs)
                            .background(
                                Circle()
                                    .fill(Color.backgroundElevated)
                                    .shadow(color: .black.opacity(0.1), radius: 2)
                            )
                            .padding(Spacing.xs)
                    }
                }

                // Item Name
                Text(item.displayName)
                    .font(.caption)
                    .foregroundColor(.adaptiveText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Spacing.xxs)
            }
            .padding(Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.card)
                    .fill(Color.backgroundSecondary)
            )
            .cardShadow()
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .accessibilityLabel("\(item.displayName), \(item.category.rawValue)")
        .accessibilityHint("Double tap to view details")
    }
}

// MARK: - Context Menu Version

struct ItemCardWithMenu: View {
    let item: WardrobeItem
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onArchive: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ItemCard(item: item, onTap: onTap)
            .contextMenu {
                Button(action: onFavorite) {
                    Label(
                        item.isFavorite ? "Unfavorite" : "Favorite",
                        systemImage: item.isFavorite ? "heart.slash" : "heart"
                    )
                }

                Button(action: {}) {
                    Label("Create Outfit", systemImage: "square.stack.3d.up")
                }

                Divider()

                Button(action: onArchive) {
                    Label("Archive", systemImage: "archivebox")
                }

                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}

// MARK: - Preview

#Preview("Item Cards") {
    ScrollView {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 160), spacing: Spacing.md)
        ], spacing: Spacing.md) {
            ForEach(PreviewData.wardrobeItems.prefix(12)) { item in
                ItemCard(item: item, onTap: {})
            }
        }
        .screenPadding()
        .padding(.vertical, Spacing.xl)
    }
    .background(Color.backgroundPrimary)
}

#Preview("Item Card States") {
    VStack(spacing: Spacing.xl) {
        HStack(spacing: Spacing.md) {
            ItemCard(item: PreviewData.wardrobeItems[0], onTap: {})
            ItemCard(item: PreviewData.wardrobeItems[1], onTap: {})
        }

        ItemCardWithMenu(
            item: PreviewData.wardrobeItems[2],
            onTap: {},
            onFavorite: {},
            onArchive: {},
            onDelete: {}
        )
    }
    .screenPadding()
    .background(Color.backgroundPrimary)
}

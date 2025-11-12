//
//  WardrobeItemDetailView.swift
//  FitChekk
//
//  Detail view for a single wardrobe item with full metadata and actions
//

import SwiftUI

struct WardrobeItemDetailView: View {
    let item: WardrobeItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onFavoriteToggle: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Image Section
                imageSection

                // Metadata Section
                metadataSection

                // Action Buttons
                actionButtons
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.backgroundPrimary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(action: onFavoriteToggle) {
                        Label(
                            item.isFavorite ? "Unfavorite" : "Favorite",
                            systemImage: item.isFavorite ? "heart.slash" : "heart"
                        )
                    }

                    Button(action: { showShareSheet = true }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }

                    Divider()

                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = imageToShare {
                ShareSheet(items: [image])
            }
        }
    }

    // MARK: - Image Section

    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            if let imageURL = item.imageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        placeholderView
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onAppear {
                                // Store image for sharing
                                if let uiImage = ImageRenderer(content: image).uiImage {
                                    imageToShare = uiImage
                                }
                            }
                    case .failure:
                        placeholderView
                    @unknown default:
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }

            // Favorite Badge
            if item.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
                    .padding(Spacing.sm)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
                    .shadow(radius: 2)
                    .padding(Spacing.md)
            }
        }
        .frame(maxHeight: 400)
    }

    private var placeholderView: some View {
        ZStack {
            Color.backgroundSecondary

            Image(systemName: item.categoryEnum.icon)
                .font(.system(size: 80))
                .foregroundColor(Color.textTertiary)
        }
        .frame(height: 300)
    }

    // MARK: - Metadata Section

    private var metadataSection: some View {
        VStack(spacing: Spacing.md) {
            // Name
            VStack(spacing: Spacing.xs) {
                Text(item.displayName)
                    .font(Font.displaySmall)
                    .foregroundColor(Color.textPrimary)
                    .multilineTextAlignment(.center)

                if let brand = item.brand {
                    Text(brand)
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textSecondary)
                }
            }

            Divider()
                .padding(.horizontal, Spacing.md)

            // Details Grid
            VStack(spacing: Spacing.sm) {
                DetailRow(label: "Category", value: item.categoryEnum.displayName, icon: item.categoryEnum.icon)
                DetailRow(label: "Type", value: item.subCategoryEnum.displayName)

                if !item.colors.isEmpty {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "paintpalette")
                                .font(.system(size: 14))
                                .foregroundColor(Color.textTertiary)
                            Text("Colors")
                                .font(Font.captionMedium)
                                .foregroundColor(Color.textSecondary)
                        }
                        .frame(width: 100, alignment: .leading)

                        HStack(spacing: 6) {
                            ForEach(item.colors, id: \.self) { color in
                                Text(color)
                                    .font(Font.captionRegular)
                                    .foregroundColor(Color.textPrimary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.backgroundSecondary)
                                    .clipShape(Capsule())
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, Spacing.md)
                }

                if !item.seasonsEnum.isEmpty {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 14))
                                .foregroundColor(Color.textTertiary)
                            Text("Seasons")
                                .font(Font.captionMedium)
                                .foregroundColor(Color.textSecondary)
                        }
                        .frame(width: 100, alignment: .leading)

                        HStack(spacing: 6) {
                            ForEach(item.seasonsEnum, id: \.self) { season in
                                HStack(spacing: 4) {
                                    Image(systemName: season.icon)
                                        .font(.system(size: 10))
                                    Text(season.displayName)
                                        .font(Font.captionRegular)
                                }
                                .foregroundColor(Color.textPrimary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.backgroundSecondary)
                                .clipShape(Capsule())
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, Spacing.md)
                }

                DetailRow(label: "Formality", value: item.formalityEnum.displayName)

                // Date Added - Important field!
                DetailRow(
                    label: "Date Added",
                    value: item.createdAt.formatted(.relative(presentation: .named)),
                    icon: "calendar.badge.clock"
                )
            }

            Divider()
                .padding(.horizontal, Spacing.md)

            // Usage Statistics
            VStack(spacing: Spacing.sm) {
                Text("Usage Statistics")
                    .font(Font.headlineSmall)
                    .foregroundColor(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.md)

                HStack(spacing: Spacing.lg) {
                    StatCard(
                        value: "\(item.timesWorn)",
                        label: "Times Worn",
                        icon: "checkmark.circle"
                    )

                    if let lastWorn = item.lastWornDate {
                        StatCard(
                            value: lastWorn.formatted(.relative(presentation: .named)),
                            label: "Last Worn",
                            icon: "clock"
                        )
                    } else {
                        StatCard(
                            value: "Never",
                            label: "Last Worn",
                            icon: "clock"
                        )
                    }
                }
                .padding(.horizontal, Spacing.md)
            }

            // Notes
            if let notes = item.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Notes")
                        .font(Font.headlineSmall)
                        .foregroundColor(Color.textPrimary)

                    Text(notes)
                        .font(Font.bodyRegular)
                        .foregroundColor(Color.textSecondary)
                        .padding(Spacing.sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, Spacing.md)
            }

            // Purchase Info
            if item.purchaseDate != nil || item.purchasePrice != nil {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(spacing: Spacing.sm) {
                    Text("Purchase Info")
                        .font(Font.headlineSmall)
                        .foregroundColor(Color.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Spacing.md)

                    if let purchaseDate = item.purchaseDate {
                        DetailRow(
                            label: "Purchased",
                            value: purchaseDate.formatted(date: .abbreviated, time: .omitted),
                            icon: "cart"
                        )
                    }

                    if let displayPrice = item.displayPrice {
                        DetailRow(
                            label: "Price",
                            value: displayPrice,
                            icon: "dollarsign.circle"
                        )
                    }
                }
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: Spacing.sm) {
            PrimaryButton(
                title: "Edit Item",
                action: onEdit
            )

            SecondaryButton(
                title: item.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                action: onFavoriteToggle
            )
        }
        .padding(.horizontal, Spacing.md)
    }
}

// MARK: - Supporting Views

struct DetailRow: View {
    let label: String
    let value: String
    var icon: String?

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(Color.textTertiary)
                }
                Text(label)
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textSecondary)
            }
            .frame(width: 100, alignment: .leading)

            Text(value)
                .font(Font.bodyRegular)
                .foregroundColor(Color.textPrimary)

            Spacer()
        }
        .padding(.horizontal, Spacing.md)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.accentPrimary)

            Text(value)
                .font(Font.headlineSmall)
                .foregroundColor(Color.textPrimary)

            Text(label)
                .font(Font.captionRegular)
                .foregroundColor(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview("Wardrobe Item Detail") {
    NavigationStack {
        WardrobeItemDetailView(
            item: {
                let item = WardrobeItem(
                    userId: UUID(),
                    name: "Blue Denim Jacket",
                    category: .outerwear,
                    subCategory: .jackets,
                    brand: "Levi's",
                    colors: ["Blue", "Black"],
                    formality: .casual,
                    seasons: [.spring, .fall],
                    isFavorite: true,
                    notes: "Perfect for layering. Bought at the outlet store.",
                    timesWorn: 12
                )
                item.lastWornDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())
                return item
            }(),
            onEdit: {},
            onDelete: {},
            onFavoriteToggle: {}
        )
    }
}

#Preview("Minimal Item") {
    NavigationStack {
        WardrobeItemDetailView(
            item: WardrobeItem(
                userId: UUID(),
                category: .tops,
                subCategory: .basicTees,
                colors: ["White"]
            ),
            onEdit: {},
            onDelete: {},
            onFavoriteToggle: {}
        )
    }
}

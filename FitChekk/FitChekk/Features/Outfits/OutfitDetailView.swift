//
//  OutfitDetailView.swift
//  FitChekk
//
//  Detailed view of outfit with all metadata and actions
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct OutfitDetailView: View {
    @Bindable var store: StoreOf<OutfitDetailFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Outfit Collage
                    outfitCollageSection
                    
                    // AI Badge and Style Score
                    if store.outfit.aiGenerated {
                        aiBadgeSection
                    }
                    
                    // Metadata Cards
                    metadataSection
                    
                    // Items Section
                    itemsSection
                    
                    // AI Reasoning (if applicable)
                    if store.outfit.aiGenerated, let reasoning = store.outfit.aiReasoning {
                        aiReasoningSection(reasoning: reasoning)
                    }
                    
                    // Weather Snapshot
                    if store.outfit.hasWeatherData {
                        weatherSection
                    }
                    
                    // Notes
                    if let notes = store.outfit.notes, !notes.isEmpty {
                        notesSection(notes: notes)
                    }
                    
                    // Actions
                    actionsSection
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(store.outfit.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: { store.send(.editTapped) }, label: {
                            Label("Edit", systemImage: "pencil")
                        })
                        
                        Button(role: .destructive, action: { store.send(.deleteTapped) }, label: {
                            Label("Delete", systemImage: "trash")
                        })
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                    }
                }
            }
            // TODO: Re-enable after fixing dependency resolution
            // .sheet(
            //     item: $store.scope(state: \.outfitEdit, action: \.outfitEdit),
            //     content: { outfitEditStore in
            //         OutfitEditView(store: outfitEditStore)
            //     }
            // )
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    // MARK: - Outfit Collage Section
    
    private var outfitCollageSection: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.sm),
                GridItem(.flexible(), spacing: Spacing.sm)
            ],
            spacing: Spacing.sm,
            content: {
                ForEach(store.outfitItems) { item in
                    itemImageCard(item: item)
                }
            }
        )
        .padding(Spacing.sm)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    private func itemImageCard(item: WardrobeItem) -> some View {
        Group {
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
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
    
    private func placeholderImage(for item: WardrobeItem) -> some View {
        ZStack {
            Color.backgroundSecondary
            Image(systemName: item.categoryEnum.icon)
                .font(.system(size: 40))
                .foregroundColor(Color.textTertiary)
        }
    }
    
    // MARK: - AI Badge Section
    
    private var aiBadgeSection: some View {
        HStack(spacing: Spacing.sm) {
            HStack(spacing: 4) {
                Text("AI Generated")
                Image(systemName: "sparkles")
            }
            .font(Font.bodyMedium.weight(.medium))
            .foregroundColor(Color.accentPrimary)
            
            Spacer()
            
            if let styleScore = store.outfit.aiStyleScore {
                HStack(spacing: 4) {
                    Text("\(Int(styleScore * 100))%")
                        .font(Font.bodyMedium.weight(.semibold))
                    Text("Match")
                        .font(Font.bodyMedium)
                }
                .foregroundColor(Color.textSecondary)
            }
        }
        .padding(Spacing.sm)
        .background(Color.accentPrimary.opacity(0.1))
        .cornerRadius(CornerRadius.md)
    }
    
    // MARK: - Metadata Section
    
    private var metadataSection: some View {
        VStack(spacing: Spacing.sm) {
            // Occasion
            if let occasion = store.outfit.occasion {
                metadataRow(
                    icon: "calendar",
                    title: "Occasion",
                    value: occasion.capitalized
                )
            }
            
            // Season
            if let seasonStr = store.outfit.season, let season = Season(rawValue: seasonStr) {
                metadataRow(
                    icon: season.icon,
                    title: "Season",
                    value: season.displayName
                )
            }
            
            // Created Date
            metadataRow(
                icon: "clock",
                title: "Created",
                value: relativeDate(store.outfit.createdAt)
            )
            
            // Times Worn
            metadataRow(
                icon: "checkmark.circle",
                title: "Times Worn",
                value: "\(store.outfit.timesWorn)"
            )
            
            // Last Worn
            if let lastWorn = store.outfit.lastWornDate {
                metadataRow(
                    icon: "calendar.badge.clock",
                    title: "Last Worn",
                    value: relativeDate(lastWorn)
                )
            }
            
            // User Rating
            ratingRow
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    private func metadataRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color.accentPrimary)
                .frame(width: 24)
            
            Text(title)
                .font(Font.bodyMedium)
                .foregroundColor(Color.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(Font.bodyMedium.weight(.medium))
                .foregroundColor(Color.textPrimary)
        }
    }
    
    private var ratingRow: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "star")
                .font(.title3)
                .foregroundColor(Color.accentPrimary)
                .frame(width: 24)
            
            Text("Rating")
                .font(Font.bodyMedium)
                .foregroundColor(Color.textSecondary)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Button(action: {
                        store.send(.ratingChanged(index))
                    }, label: {
                        let isFilled = index <= (store.outfit.userRating ?? 0)
                        Image(systemName: isFilled ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundColor(isFilled ? Color.warning : Color.borderDefault)
                    })
                }
            }
        }
    }
    
    // MARK: - Items Section
    
    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Outfit Items (\(store.outfitItems.count))")
                .font(Font.headlineMedium)
                .foregroundColor(Color.textPrimary)
            
            ForEach(store.outfitItems) { item in
                itemRow(item: item)
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    private func itemRow(item: WardrobeItem) -> some View {
        HStack(spacing: Spacing.sm) {
            // Thumbnail
            Group {
                if let thumbnailURL = item.thumbnailURL {
                    AsyncImage(url: URL(string: thumbnailURL)) { phase in
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
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            
            // Item Info
            VStack(alignment: .leading, spacing: 2) {
                Text(item.displayName)
                    .font(Font.bodyMedium.weight(.medium))
                    .foregroundColor(Color.textPrimary)
                
                Text(item.categoryEnum.displayName)
                    .font(Font.captionRegular)
                    .foregroundColor(Color.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color.textTertiary)
        }
        .padding(Spacing.xs)
        .background(Color.backgroundPrimary)
        .cornerRadius(CornerRadius.md)
    }
    
    // MARK: - AI Reasoning Section
    
    private func aiReasoningSection(reasoning: String) -> some View {
        DisclosureGroup(
            content: {
                Text(reasoning)
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textPrimary)
                    .padding(.top, Spacing.sm)
            },
            label: {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(Color.warning)
                    
                    Text("Why this works?")
                        .font(Font.bodyMedium.weight(.medium))
                        .foregroundColor(Color.textPrimary)
                }
            }
        )
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
        .tint(Color.accentPrimary)
    }
    
    // MARK: - Weather Section
    
    private var weatherSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Weather Context")
                .font(Font.headlineSmall)
                .foregroundColor(Color.textPrimary)
            
            HStack(spacing: Spacing.md) {
                if let high = store.outfit.weatherTempHigh, let low = store.outfit.weatherTempLow {
                    Label("\(high)° / \(low)°", systemImage: "thermometer")
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textSecondary)
                }
                
                if let condition = store.outfit.weatherCondition {
                    Label(condition, systemImage: weatherIcon(for: condition))
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textSecondary)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    // MARK: - Notes Section
    
    private func notesSection(notes: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Notes")
                .font(Font.headlineSmall)
                .foregroundColor(Color.textPrimary)
            
            Text(notes)
                .font(Font.bodyMedium)
                .foregroundColor(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.lg)
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: Spacing.sm) {
            PrimaryButton(
                title: store.isUpdating ? "Updating..." : "Mark as Worn",
                action: { store.send(.markAsWornTapped) },
                isLoading: store.isUpdating,
                isDisabled: store.isUpdating
            )
            
            SecondaryButton(
                title: "Add to Calendar",
                action: {
                    // TODO: Navigate to planner with this outfit pre-selected
                }
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func weatherIcon(for condition: String) -> String {
        let lowercased = condition.lowercased()
        if lowercased.contains("sun") || lowercased.contains("clear") {
            return "sun.max"
        } else if lowercased.contains("cloud") {
            return "cloud"
        } else if lowercased.contains("rain") {
            return "cloud.rain"
        } else if lowercased.contains("snow") {
            return "snow"
        } else {
            return "cloud"
        }
    }
}

// MARK: - Preview

#Preview {
    OutfitDetailView(
        store: Store(
            initialState: OutfitDetailFeature.State(
                outfit: Outfit(
                    userId: UUID(),
                    name: "Summer Brunch Look",
                    occasion: "brunch",
                    season: "summer",
                    notes: "Perfect for outdoor gatherings!",
                    aiGenerated: true,
                    aiReasoning: """
                        This outfit combines comfort with style. The light colors work great in warm weather, \
                        and the casual vibe is perfect for a relaxed brunch setting.
                        """,
                    aiStyleScore: 0.89,
                    weatherTempHigh: 78,
                    weatherTempLow: 62,
                    weatherCondition: "Sunny",
                    itemIds: [UUID(), UUID(), UUID()]
                )
            )
        ) {
            OutfitDetailFeature()
        }
    )
}

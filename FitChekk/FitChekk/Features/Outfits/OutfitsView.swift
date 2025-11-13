//
//  OutfitsView.swift
//  FitChekk
//
//  Main outfit collection view with grid layout and filters
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct OutfitsView: View {
    @Bindable var store: StoreOf<OutfitsFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                if store.isLoading && store.outfits.isEmpty {
                    loadingView
                } else if store.outfits.isEmpty {
                    emptyStateView
                } else {
                    outfitGridView
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        createOutfitButton
                    }
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Outfits")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await store.send(.refresh).finish()
            }
            .alert(
                "Delete Outfit?",
                isPresented: Binding(
                    get: { store.showDeleteAlert },
                    set: { _ in }
                ),
                actions: {
                    Button("Cancel", role: .cancel) {
                        store.send(.cancelDelete)
                    }
                    Button("Delete", role: .destructive) {
                        store.send(.confirmDelete)
                    }
                },
                message: {
                    Text("This can't be undone. Your wardrobe items will not be affected.")
                }
            )
            .sheet(
                item: $store.scope(state: \.outfitCreation, action: \.outfitCreation),
                content: { outfitCreationStore in
                    OutfitCreationView(store: outfitCreationStore)
                }
            )
            .sheet(
                item: $store.scope(state: \.outfitDetail, action: \.outfitDetail),
                content: { outfitDetailStore in
                    OutfitDetailView(store: outfitDetailStore)
                }
            )
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    // MARK: - Outfit Grid View
    
    private var outfitGridView: some View {
        ScrollView {
            VStack(spacing: Spacing.md) {
                // Filter Pills
                filterPills
                
                // Results Count
                if store.selectedFilters.isActive {
                    resultsCount
                }
                
                // Outfit Grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: Spacing.md),
                        GridItem(.flexible(), spacing: Spacing.md)
                    ],
                    spacing: Spacing.md,
                    content: {
                        ForEach(store.filteredOutfits) { outfit in
                            OutfitCard(
                                outfit: outfit,
                                onTap: {
                                    store.send(.outfitTapped(outfit))
                                },
                                onDelete: {
                                    store.send(.deleteOutfitTapped(outfit))
                                }
                            )
                        }
                    }
                )
                .padding(.horizontal, Spacing.md)
                
                // No Results State
                if store.filteredOutfits.isEmpty && !store.outfits.isEmpty {
                    noResultsView
                }
            }
            .padding(.vertical, Spacing.md)
        }
    }
    
    // MARK: - Filter Pills
    
    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                // Clear Filters
                if store.selectedFilters.isActive {
                    filterPill(
                        title: "Clear",
                        count: nil,
                        isSelected: false,
                        action: { store.send(.clearFilters) }
                    )
                }
                
                // Occasion Filters
                ForEach(OccasionType.allCases, id: \.self) { occasion in
                    let count = store.occasionCounts[occasion.rawValue, default: 0]
                    filterPill(
                        title: occasion.displayName,
                        count: count,
                        isSelected: store.selectedFilters.occasion == occasion.rawValue,
                        action: {
                            if store.selectedFilters.occasion == occasion.rawValue {
                                store.send(.filterByOccasion(nil))
                            } else {
                                store.send(.filterByOccasion(occasion.rawValue))
                            }
                        }
                    )
                }
                
                // Season Filters
                ForEach(Season.allCases, id: \.self) { season in
                    let count = store.seasonCounts[season, default: 0]
                    filterPill(
                        title: season.displayName,
                        count: count,
                        isSelected: store.selectedFilters.season == season,
                        action: {
                            if store.selectedFilters.season == season {
                                store.send(.filterBySeason(nil))
                            } else {
                                store.send(.filterBySeason(season))
                            }
                        }
                    )
                }
                
                // AI Generated Filter
                filterPill(
                    title: "AI Generated",
                    count: store.aiGeneratedCount,
                    isSelected: store.selectedFilters.showAIOnly,
                    action: { store.send(.toggleAIOnly) }
                )
                
                // Manual Filter
                filterPill(
                    title: "Manual",
                    count: store.manualCount,
                    isSelected: store.selectedFilters.showManualOnly,
                    action: { store.send(.toggleManualOnly) }
                )
            }
            .padding(.horizontal, Spacing.md)
        }
    }
    
    private func filterPill(
        title: String,
        count: Int?,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action, label: {
            HStack(spacing: Spacing.xs) {
                Text(title)
                if let count, count > 0 {
                    Text("(\(count))")
                        .font(Font.captionMedium)
                }
            }
            .font(Font.bodyMedium)
            .foregroundColor(isSelected ? Color.white : Color.textPrimary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color.accentPrimary : Color.backgroundSecondary)
            .cornerRadius(CornerRadius.xl)
        })
    }
    
    // MARK: - Results Count
    
    private var resultsCount: some View {
        Text("\(store.filteredOutfits.count) \(store.filteredOutfits.count == 1 ? "outfit" : "outfits")")
            .font(Font.bodyMedium)
            .foregroundColor(Color.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.md)
    }
    
    // MARK: - Create Outfit Button
    
    private var createOutfitButton: some View {
        Button(action: { store.send(.createOutfitTapped) }, label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .frame(width: 56, height: 56)
                .background(Color.accentPrimary)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        })
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.accentPrimary)
            
            Text("Loading outfits...")
                .font(Font.bodyMedium)
                .foregroundColor(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "hanger")
                .font(.system(size: 80))
                .foregroundColor(Color.textTertiary)
            
            VStack(spacing: Spacing.xs) {
                Text("No Outfits Yet")
                    .font(Font.displaySmall)
                    .foregroundColor(Color.textPrimary)
                
                Text("Create your first outfit or generate one with AI")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)
            }
            
            VStack(spacing: Spacing.sm) {
                PrimaryButton(
                    title: "Create Outfit",
                    action: { store.send(.createOutfitTapped) }
                )
                .padding(.horizontal, Spacing.xxl)
                
                SecondaryButton(
                    title: "Generate with AI",
                    action: {
                        // TODO: Open AI outfit suggestion view
                    }
                )
                .padding(.horizontal, Spacing.xxl)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
    }
    
    // MARK: - No Results View
    
    private var noResultsView: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(Color.textTertiary)
            
            VStack(spacing: Spacing.xs) {
                Text("No Outfits Match")
                    .font(Font.headlineLarge)
                    .foregroundColor(Color.textPrimary)
                
                Text("Try adjusting your filters")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
            }
            
            SecondaryButton(
                title: "Clear Filters",
                action: { store.send(.clearFilters) }
            )
            .padding(.horizontal, Spacing.xxl)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }
}

// MARK: - Preview

#Preview {
    OutfitsView(
        store: Store(initialState: OutfitsFeature.State()) {
            OutfitsFeature()
        }
    )
}

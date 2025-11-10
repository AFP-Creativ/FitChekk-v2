//
//  OutfitsView.swift
//  FitChekk-v2
//
//  Outfits list view
//

import SwiftUI

struct OutfitsView: View {
    @Environment(AppState.self) private var appState
    @State private var showCreateOutfit = false
    @State private var selectedOutfit: Outfit? = nil
    @State private var selectedOccasion: OccasionType? = nil
    
    var filteredOutfits: [Outfit] {
        if let occasion = selectedOccasion {
            return appState.outfits.filter { $0.occasion == occasion }
        }
        return appState.outfits
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if appState.outfits.isEmpty {
                    EmptyOutfitsView {
                        showCreateOutfit = true
                    }
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.lg) {
                            // Occasion filter
                            occasionFilterSection
                            
                            // Outfits count
                            HStack {
                                Text("\(filteredOutfits.count) outfits")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                Spacer()
                            }
                            .padding(.horizontal, Spacing.screenHorizontal)
                            
                            // Outfits list
                            LazyVStack(spacing: Spacing.md) {
                                ForEach(filteredOutfits) { outfit in
                                    OutfitCard(outfit: outfit) {
                                        selectedOutfit = outfit
                                    }
                                }
                            }
                            .padding(.horizontal, Spacing.screenHorizontal)
                        }
                        .padding(.bottom, 100)
                    }
                }
                
                // Floating Add Button
                if !appState.outfits.isEmpty {
                    FloatingActionButton(icon: "plus") {
                        showCreateOutfit = true
                    }
                    .padding(Spacing.lg)
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("My Outfits")
            .sheet(isPresented: $showCreateOutfit) {
                CreateOutfitView(onDismiss: { showCreateOutfit = false })
            }
            .sheet(item: $selectedOutfit) { outfit in
                OutfitDetailView(outfit: outfit)
            }
        }
    }
    
    // MARK: - Occasion Filter
    
    private var occasionFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ChipButton(
                    title: "All",
                    isSelected: selectedOccasion == nil
                ) {
                    selectedOccasion = nil
                }
                
                ForEach(OccasionType.allCases) { occasion in
                    ChipButton(
                        title: occasion.displayName,
                        isSelected: selectedOccasion == occasion
                    ) {
                        selectedOccasion = occasion
                    }
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
}

#Preview {
    OutfitsView()
        .environment(AppState())
}


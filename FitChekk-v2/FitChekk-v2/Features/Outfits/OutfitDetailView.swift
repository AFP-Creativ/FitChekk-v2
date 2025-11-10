//
//  OutfitDetailFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class OutfitDetailState {
    let outfit: MockOutfit
    var isFavorite: Bool = false
    
    init(outfit: MockOutfit) {
        self.outfit = outfit
    }
}

// MARK: - Actions

enum OutfitDetailAction {
    case onAppear
    case useOutfitTapped
    case suggestAnotherTapped
    case toggleFavorite
    case scheduleTapped
    case shareTapped
}

// MARK: - View

struct OutfitDetailView: View {
    @State private var state: OutfitDetailState
    @Environment(\.dismiss) var dismiss
    
    init(outfit: MockOutfit) {
        _state = State(initialValue: OutfitDetailState(outfit: outfit))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.section) {
                    // Outfit Preview
                    outfitPreviewSection
                    
                    // AI Reasoning
                    reasoningSection
                    
                    // Items List
                    itemsSection
                    
                    // Weather Info
                    weatherSection
                    
                    // Actions
                    actionsSection
                }
                .padding(.horizontal, Spacing.screenMargin)
                .padding(.top, Spacing.topSafeArea)
                .padding(.bottom, Spacing.bottomSafeArea)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(state.outfit.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        state.isFavorite.toggle()
                    }) {
                        Image(systemName: state.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(state.isFavorite ? .accentPrimary : .textSecondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Outfit Preview
    
    private var outfitPreviewSection: some View {
        VStack(spacing: Spacing.group) {
            // Composite outfit image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: CardStyle.cornerRadiusLarge)
                    .fill(Color.backgroundSecondary)
                    .frame(height: 400)
                
                VStack(spacing: Spacing.group) {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.textTertiary)
                    
                    Text("Outfit Preview")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
            }
            .largeCardStyle()
        }
    }
    
    // MARK: - Reasoning Section
    
    private var reasoningSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.accentPrimary)
                Text("AI Reasoning")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            if let reasoning = state.outfit.aiReasoning {
                Text(reasoning)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
        }
        .padding(Spacing.standard)
        .cardStyle()
    }
    
    // MARK: - Items Section
    
    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Items")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.group) {
                ForEach(state.outfit.items) { item in
                    HStack(spacing: Spacing.group) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.backgroundSecondary)
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: item.imagePlaceholder)
                                .font(.title3)
                                .foregroundColor(.textSecondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name ?? "Item")
                                .font(.subheadline)
                                .foregroundColor(.textPrimary)
                            
                            Text(item.category.rawValue)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Replace")
                                .font(.caption)
                                .foregroundColor(.accentPrimary)
                                .padding(.horizontal, Spacing.standard)
                                .padding(.vertical, 6)
                                .background(Color.accentPrimary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(Spacing.standard)
                    .cardStyle()
                }
            }
        }
    }
    
    // MARK: - Weather Section
    
    private var weatherSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Weather")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if let weather = state.outfit.weatherSnapshot {
                HStack {
                    Image(systemName: "cloud.sun.fill")
                        .foregroundColor(.accentPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(Int(weather.tempHigh))° / \(Int(weather.tempLow))°")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                        
                        Text(weather.condition)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(Spacing.standard)
                .cardStyle()
            }
        }
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: Spacing.group) {
            Button(action: {}) {
                Text("Use This Outfit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.standard)
                    .background(Color.accentPrimary)
                    .cornerRadius(12)
            }
            
            HStack(spacing: Spacing.group) {
                Button(action: {}) {
                    Text("Suggest Another")
                        .font(.body)
                        .foregroundColor(.accentPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.standard)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Text("Schedule")
                        .font(.body)
                        .foregroundColor(.accentPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.standard)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                }
            }
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Outfit")
                }
                .font(.body)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.standard)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    OutfitDetailView(outfit: MockOutfit.sampleOutfits.first!)
}


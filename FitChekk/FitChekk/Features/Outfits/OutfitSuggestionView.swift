//
//  OutfitSuggestionView.swift
//  FitChekk
//
//  View for AI-generated outfit suggestions with weather context
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct OutfitSuggestionView: View {
    @Bindable var store: StoreOf<OutfitSuggestionFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    loadingView
                } else if let suggestions = store.suggestions, !suggestions.isEmpty {
                    suggestionView(suggestions: suggestions)
                } else if store.errorMessage != nil {
                    errorView
                } else {
                    EmptyView()
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Outfit Suggestions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.accentPrimary)
            
            VStack(spacing: Spacing.sm) {
                Text("Creating your outfits...")
                    .font(Font.headlineMedium)
                    .foregroundColor(Color.textPrimary)
                
                Text("Analyzing your wardrobe and weather")
                    .font(Font.bodyRegular)
                    .foregroundColor(Color.textSecondary)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Suggestion View
    
    private func suggestionView(suggestions: [OutfitSuggestion]) -> some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Weather Context
                if let weather = store.weather {
                    weatherCard(weather: weather)
                        .padding(.horizontal, Spacing.md)
                }
                
                // Outfit Suggestions
                ForEach(Array(suggestions.enumerated()), id: \.element.id) { index, suggestion in
                    outfitCard(suggestion: suggestion, index: index)
                        .padding(.horizontal, Spacing.md)
                }
                
                // Try Another Button
                SecondaryButton(
                    title: "Try Another Combination",
                    action: { store.send(.tryAnother) }
                )
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .padding(.vertical, Spacing.md)
        }
    }
    
    // MARK: - Weather Card
    
    private func weatherCard(weather: WeatherCondition) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: weather.conditionIcon)
                .font(.system(size: 32))
                .foregroundColor(Color.accentPrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Weather")
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textSecondary)
                
                HStack(spacing: Spacing.xs) {
                    Text("\(weather.tempHigh)°")
                        .font(Font.headlineLarge)
                        .foregroundColor(Color.textPrimary)
                    
                    Text(weather.condition)
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textSecondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Feels like")
                    .font(Font.captionRegular)
                    .foregroundColor(Color.textTertiary)
                
                Text("\(weather.feelsLike)°")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textPrimary)
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Outfit Card
    
    private func outfitCard(suggestion: OutfitSuggestion, index: Int) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            outfitHeader(suggestion: suggestion)
            itemsGrid(itemIds: suggestion.itemIds)
            outfitReasoning(suggestion: suggestion)
            
            // Actions
            HStack(spacing: Spacing.sm) {
                PrimaryButton(
                    title: "Save Outfit",
                    action: { store.send(.saveOutfit(suggestion)) }
                )
                
                SecondaryButton(
                    title: "Skip",
                    action: { /* Do nothing, just view */ }
                )
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func outfitHeader(suggestion: OutfitSuggestion) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(suggestion.name)
                    .font(Font.headlineMedium)
                    .foregroundColor(Color.textPrimary)
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 10))
                    Text("\(Int(suggestion.styleScore * 100))% match")
                        .font(Font.captionRegular)
                }
                .foregroundColor(Color.accentPrimary)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.borderDefault, lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: suggestion.styleScore)
                    .stroke(Color.accentPrimary, lineWidth: 4)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(suggestion.styleScore * 100))")
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textPrimary)
            }
        }
    }
    
    private func outfitReasoning(suggestion: OutfitSuggestion) -> some View {
        DisclosureGroup(
            isExpanded: .init(
                get: { store.expandedSuggestions.contains(suggestion.id) },
                set: { _ in store.send(.toggleReasoning(suggestion.id)) }
            )
        ) {
            Text(suggestion.reasoning)
                .font(Font.bodyRegular)
                .foregroundColor(Color.textSecondary)
                .padding(.top, Spacing.sm)
        } label: {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Why this works?")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textPrimary)
            }
        }
        .tint(Color.accentPrimary)
    }
    
    // MARK: - Items Grid
    
    private func itemsGrid(itemIds: [UUID]) -> some View {
        let items = store.wardrobe.filter { itemIds.contains($0.id) }
        
        return LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: Spacing.sm
        ) {
            ForEach(items, id: \.id) { item in
                VStack(spacing: Spacing.xs) {
                    if let thumbnailURL = item.thumbnailURL {
                        AsyncImage(url: URL(string: thumbnailURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.backgroundSecondary)
                        }
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Rectangle()
                            .fill(Color.backgroundSecondary)
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                Image(systemName: item.categoryEnum.icon)
                                    .foregroundColor(Color.textTertiary)
                            )
                    }
                    
                    Text(item.displayName)
                        .font(Font.captionRegular)
                        .foregroundColor(Color.textSecondary)
                        .lineLimit(1)
                }
            }
        }
    }
    
    // MARK: - Error View
    
    private var errorView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            VStack(spacing: Spacing.sm) {
                Text("Couldn't Generate Outfits")
                    .font(Font.headlineMedium)
                    .foregroundColor(Color.textPrimary)
                
                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .font(Font.bodyRegular)
                        .foregroundColor(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            PrimaryButton(
                title: "Try Again",
                action: { store.send(.tryAnother) }
            )
            .padding(.horizontal, Spacing.md)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - OutfitSuggestionFeature

@Reducer
struct OutfitSuggestionFeature {
    @ObservableState
    struct State: Equatable {
        var wardrobe: [WardrobeItem]
        var weather: WeatherCondition?
        var preferences: UserPreferences?
        var occasion: String?
        
        var isLoading = false
        var suggestions: [OutfitSuggestion]?
        var expandedSuggestions: Set<UUID> = []
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case generateSuggestions
        case suggestionsResponse(Result<[OutfitSuggestion], Error>)
        case toggleReasoning(UUID)
        case saveOutfit(OutfitSuggestion)
        case tryAnother
    }
    
    @Dependency(\.outfitService) var outfitService
    @Dependency(\.weatherService) var weatherService
    @Dependency(\.databaseService) var databaseService
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.generateSuggestions)
                
            case .generateSuggestions:
                state.isLoading = true
                state.errorMessage = nil
                state.suggestions = nil
                
                let wardrobe = state.wardrobe
                let weather = state.weather
                let preferences = state.preferences
                let occasion = state.occasion
                
                return .run { send in
                    do {
                        let suggestions = try await outfitService.suggestOutfits(
                            wardrobe: wardrobe,
                            weather: weather,
                            preferences: preferences,
                            occasion: occasion
                        )
                        await send(.suggestionsResponse(.success(suggestions)))
                    } catch {
                        await send(.suggestionsResponse(.failure(error)))
                    }
                }
                
            case let .suggestionsResponse(.success(suggestions)):
                state.isLoading = false
                state.suggestions = suggestions
                return .none
                
            case let .suggestionsResponse(.failure(error)):
                state.isLoading = false
                
                let errorMessage: String
                if let outfitError = error as? OutfitError {
                    switch outfitError {
                    case .insufficientItems:
                        errorMessage = "You need at least 2 items in your wardrobe to generate outfits."
                    case .networkError:
                        errorMessage = "Network error. Check your connection and try again."
                    case .apiLimitReached:
                        errorMessage = "AI limit reached. Please try again later."
                    default:
                        errorMessage = "Couldn't generate outfits. Please try again."
                    }
                } else {
                    errorMessage = "Couldn't generate outfits. Please try again."
                }
                
                state.errorMessage = errorMessage
                return .none
                
            case let .toggleReasoning(id):
                if state.expandedSuggestions.contains(id) {
                    state.expandedSuggestions.remove(id)
                } else {
                    state.expandedSuggestions.insert(id)
                }
                return .none
                
            case let .saveOutfit(suggestion):
                // Create outfit from suggestion
                let outfit = Outfit(
                    userId: state.wardrobe.first?.userId ?? UUID(),
                    name: suggestion.name,
                    occasion: suggestion.occasion,
                    aiGenerated: true,
                    aiReasoning: suggestion.reasoning,
                    aiStyleScore: suggestion.styleScore,
                    weatherTempHigh: state.weather?.tempHigh,
                    weatherTempLow: state.weather?.tempLow,
                    weatherCondition: state.weather?.condition,
                    itemIds: suggestion.itemIds
                )
                
                return .run { _ in
                    _ = try await databaseService.createOutfit(outfit)
                    await dismiss()
                }
                
            case .tryAnother:
                return .send(.generateSuggestions)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OutfitSuggestionView(
        store: Store(
            initialState: OutfitSuggestionFeature.State(
                wardrobe: [
                    WardrobeItem(
                        userId: UUID(),
                        category: .tops,
                        subCategory: .basicTees
                    )
                ],
                weather: WeatherCondition(
                    date: Date(),
                    tempHigh: 72,
                    tempLow: 58,
                    condition: "Partly Cloudy",
                    feelsLike: 68,
                    humidity: 55,
                    precipitation: 10
                )
            )
        ) {
            OutfitSuggestionFeature()
        }
    )
}

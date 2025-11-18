//
//  HomeView.swift
//  FitChekk
//
//  Home screen with weather and AI outfit suggestions
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

@MainActor
struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Weather Card
                    if let weather = store.weather {
                        weatherCard(weather: weather)
                    } else if store.isLoadingWeather {
                        weatherLoadingCard
                    }
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Generate Outfit CTA
                    generateOutfitButton
                    
                    // Create Manual Outfit
                    createOutfitButton
                    
                    // Recent Outfits
                    if !store.recentOutfits.isEmpty {
                        recentOutfitsSection
                    }
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("FitChekk")
            .sheet(isPresented: .init(
                get: { store.showingOutfitSuggestions },
                set: { if !$0 { store.send(.dismissOutfitSuggestions) } }
            )) {
                OutfitSuggestionView(
                    store: Store(
                        initialState: OutfitSuggestionFeature.State(
                            wardrobe: store.wardrobe,
                            weather: store.weather,
                            preferences: nil,
                            occasion: nil
                        )
                    ) {
                        OutfitSuggestionFeature()
                    }
                )
            }
        }
        .sheet(item: $store.scope(state: \.outfitCreation, action: \.outfitCreation)) { store in
            OutfitCreationView(store: store)
        }
        .alert(
            "Not Enough Items",
            isPresented: .init(
                get: { store.showInsufficientItemsAlert },
                set: { if !$0 { store.send(.dismissInsufficientItemsAlert) } }
            ),
            actions: {
                Button("OK", role: .cancel) {
                    store.send(.dismissInsufficientItemsAlert)
                }
            },
            message: {
                Text("You need at least 2 items in your wardrobe to create an outfit. Add some items first!")
            }
        )
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    // MARK: - Weather Card
    
    private func weatherCard(weather: WeatherCondition) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Today's Weather")
                    .font(Font.headlineMedium)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Button(
                    action: { store.send(.refreshWeather) },
                    label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color.accentPrimary)
                    }
                )
            }
            
            HStack(spacing: Spacing.md) {
                // Weather Icon
                Image(systemName: weather.conditionIcon)
                    .font(.system(size: 48))
                    .foregroundColor(Color.accentPrimary)
                
                // Temperature
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: Spacing.xs) {
                        Text("\(weather.tempHigh)°")
                            .font(Font.displayMedium)
                            .foregroundColor(Color.textPrimary)
                        
                        Text("/ \(weather.tempLow)°")
                            .font(Font.bodyLarge)
                            .foregroundColor(Color.textSecondary)
                    }
                    
                    Text(weather.condition)
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textSecondary)
                }
                
                Spacer()
                
                // Feels Like
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Feels like")
                        .font(Font.captionRegular)
                        .foregroundColor(Color.textTertiary)
                    
                    Text("\(weather.feelsLike)°")
                        .font(Font.headlineMedium)
                        .foregroundColor(Color.textPrimary)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var weatherLoadingCard: some View {
        HStack(spacing: Spacing.sm) {
            ProgressView()
            Text("Loading weather...")
                .font(Font.bodyMedium)
                .foregroundColor(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Quick Stats
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Your Wardrobe")
                .font(Font.headlineMedium)
                .foregroundColor(Color.textPrimary)
            
            HStack(spacing: Spacing.sm) {
                statCard(
                    title: "Items",
                    value: "\(store.wardrobeCount)",
                    icon: "tshirt"
                )
                
                statCard(
                    title: "Outfits",
                    value: "\(store.outfitsCount)",
                    icon: "sparkles"
                )
                
                statCard(
                    title: "AI Ready",
                    value: "\(store.aiCategorizedCount)",
                    icon: "wand.and.stars"
                )
            }
        }
    }
    
    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.accentPrimary)
            
            Text(value)
                .font(Font.headlineLarge)
                .foregroundColor(Color.textPrimary)
            
            Text(title)
                .font(Font.captionRegular)
                .foregroundColor(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Generate Outfit Button
    
    private var generateOutfitButton: some View {
        Button(
            action: { store.send(.generateOutfitTapped) },
            label: {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Generate Outfit")
                        .font(Font.headlineMedium)
                    
                    Text("AI-powered outfit suggestions based on weather")
                        .font(Font.captionRegular)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.white)
            .padding(Spacing.md)
            .background(
                LinearGradient(
                    colors: [Color.accentPrimary, Color.accentPrimary.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        )
        .disabled(store.wardrobe.count < 2)
    }
    
    // MARK: - Create Outfit Button

    private var createOutfitButton: some View {
        Button(
            action: {
                store.send(.createOutfitTapped)
            },
            label: {
                HStack {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Create Outfit")
                            .font(Font.headlineMedium)

                        Text("Build your outfit manually")
                            .font(Font.captionRegular)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.textPrimary)
                .padding(Spacing.md)
                .background(Color.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        )
    }
    
    // MARK: - Recent Outfits
    
    private var recentOutfitsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Recent Outfits")
                .font(Font.headlineMedium)
                .foregroundColor(Color.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(store.recentOutfits, id: \.id) { outfit in
                        outfitPreviewCard(outfit: outfit)
                    }
                }
            }
        }
    }
    
    private func outfitPreviewCard(outfit: Outfit) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Placeholder for outfit preview
            Rectangle()
                .fill(Color.backgroundSecondary)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    VStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 32))
                            .foregroundColor(Color.textTertiary)
                        
                        Text("\(outfit.itemIds.count) items")
                            .font(Font.captionRegular)
                            .foregroundColor(Color.textTertiary)
                    }
                )
            
            Text(outfit.name)
                .font(Font.captionMedium)
                .foregroundColor(Color.textPrimary)
                .lineLimit(1)
            
            if outfit.aiGenerated {
                HStack(spacing: 2) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 8))
                    Text("AI")
                        .font(Font.captionRegular)
                }
                .foregroundColor(Color.accentPrimary)
            }
        }
        .frame(width: 120)
    }
}

// MARK: - HomeFeature

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var weather: WeatherCondition?
        var isLoadingWeather = false
        var wardrobe: [WardrobeItem] = []
        var recentOutfits: [Outfit] = []
        var showingOutfitSuggestions = false
        var showInsufficientItemsAlert = false
        @Presents var outfitCreation: OutfitCreationFeature.State?
        
        var wardrobeCount: Int {
            wardrobe.count
        }
        
        var outfitsCount: Int {
            recentOutfits.count
        }
        
        var aiCategorizedCount: Int {
            wardrobe.filter { $0.aiGenerated }.count
        }
    }
    
    enum Action {
        case onAppear
        case loadWeather
        case weatherResponse(Result<WeatherCondition, Error>)
        case refreshWeather
        case loadData
        case dataLoaded(wardrobe: [WardrobeItem], outfits: [Outfit])
        case generateOutfitTapped
        case dismissOutfitSuggestions
        case createOutfitTapped
        case dismissInsufficientItemsAlert
        case outfitCreation(PresentationAction<OutfitCreationFeature.Action>)
    }
    
    @Dependency(\.weatherService) var weatherService
    @Dependency(\.databaseService) var databaseService
    @Dependency(\.authService) var authService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.loadWeather),
                    .send(.loadData)
                )
                
            case .loadWeather:
                state.isLoadingWeather = true
                
                return .run { send in
                    do {
                        let location = try await weatherService.getCurrentLocation()
                        let weather = try await weatherService.getCurrentWeather(location: location)
                        await send(.weatherResponse(.success(weather)))
                    } catch {
                        await send(.weatherResponse(.failure(error)))
                    }
                }
                
            case let .weatherResponse(.success(weather)):
                state.isLoadingWeather = false
                state.weather = weather
                return .none
                
            case .weatherResponse(.failure):
                state.isLoadingWeather = false
                // Silently fail - weather is optional
                return .none
                
            case .refreshWeather:
                return .send(.loadWeather)
                
            case .loadData:
                return .run { send in
                    // Load wardrobe and recent outfits
                    guard let user = try? await authService.getCurrentUser() else { return }
                    let wardrobe = try await databaseService.fetchWardrobeItems(userId: user.id)
                    let outfits = try await databaseService.fetchOutfits(userId: user.id)
                    let recentOutfits = Array(outfits.prefix(5))
                    
                    await send(.dataLoaded(wardrobe: wardrobe, outfits: recentOutfits))
                }
                
            case let .dataLoaded(wardrobe, outfits):
                state.wardrobe = wardrobe
                state.recentOutfits = outfits
                return .none
                
            case .generateOutfitTapped:
                guard state.wardrobe.count >= 2 else {
                    return .none
                }
                state.showingOutfitSuggestions = true
                return .none
                
            case .dismissOutfitSuggestions:
                state.showingOutfitSuggestions = false
                return .none
                
            case .createOutfitTapped:
                guard state.wardrobe.count >= 2 else {
                    state.showInsufficientItemsAlert = true
                    return .none
                }
                state.outfitCreation = OutfitCreationFeature.State()
                return .none

            case .dismissInsufficientItemsAlert:
                state.showInsufficientItemsAlert = false
                return .none

            case .outfitCreation(.presented(.delegate(.outfitSaved))):
                state.outfitCreation = nil
                return .send(.loadData)
                
            case .outfitCreation(.presented(.delegate(.cancelled))):
                state.outfitCreation = nil
                return .none
                
            case .outfitCreation:
                return .none
            }
        }
        .ifLet(\.$outfitCreation, action: \.outfitCreation) {
            OutfitCreationFeature()
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State(
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
            HomeFeature()
        }
    )
}

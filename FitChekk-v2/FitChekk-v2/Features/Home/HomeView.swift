//
//  HomeView.swift
//  FitChekk-v2
//
//  Home tab - Daily outfit suggestions and weather
//

import SwiftUI

// MARK: - Home State

@MainActor
class HomeState: ObservableObject {
    @Published var weather: WeatherSnapshot?
    @Published var forecast: [WeatherSnapshot] = []
    @Published var wardrobeItems: [WardrobeItem] = []
    @Published var suggestion: OutfitSuggestion?
    @Published var isLoadingWeather = false
    @Published var isLoadingSuggestion = false
    @Published var error: String?

    let weatherService: WeatherServiceProtocol
    let databaseService: DatabaseServiceProtocol
    let aiService: AIServiceProtocol
    let user: User

    init(
        weatherService: WeatherServiceProtocol = MockWeatherService.shared,
        databaseService: DatabaseServiceProtocol = MockDatabaseService.shared,
        aiService: AIServiceProtocol = MockAIService.shared,
        user: User
    ) {
        self.weatherService = weatherService
        self.databaseService = databaseService
        self.aiService = aiService
        self.user = user
    }

    func loadData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadWeather() }
            group.addTask { await self.loadWardrobe() }
        }

        // After loading wardrobe and weather, generate suggestion if premium
        if user.isPremium && weather != nil && !wardrobeItems.isEmpty {
            await generateSuggestion()
        }
    }

    func loadWeather() async {
        isLoadingWeather = true
        do {
            weather = try await weatherService.getCurrentWeather()
            forecast = try await weatherService.getForecast(days: 5)
        } catch {
            self.error = "Failed to load weather"
        }
        isLoadingWeather = false
    }

    func loadWardrobe() async {
        do {
            wardrobeItems = try await databaseService.fetchWardrobeItems()
        } catch {
            self.error = "Failed to load wardrobe"
        }
    }

    func generateSuggestion() async {
        guard let weather = weather else { return }

        isLoadingSuggestion = true
        do {
            suggestion = try await aiService.suggestOutfit(
                wardrobe: wardrobeItems,
                weather: weather,
                occasion: nil,
                preferences: user.preferences
            )
        } catch {
            self.error = "Failed to generate suggestion"
        }
        isLoadingSuggestion = false
    }

    func useOutfit() {
        // In real app, this would save to planner and mark for today
        print("Using outfit: \(suggestion?.outfit.name ?? "unknown")")
    }

    func suggestAnother() {
        Task {
            await generateSuggestion()
        }
    }
}

// MARK: - Home View

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var state: HomeState

    init(appState: AppState) {
        let user = appState.currentUser ?? PreviewData.premiumUser
        _state = StateObject(wrappedValue: HomeState(user: user))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Greeting Header
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(greetingText)
                            .font(.headline)
                            .foregroundColor(.adaptiveTextSecondary)

                        Text(dateText)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.adaptiveText)
                    }

                    // Weather Card
                    if let weather = state.weather {
                        WeatherCard(currentWeather: weather, forecast: state.forecast)
                    } else if state.isLoadingWeather {
                        ShimmerRectangle(cornerRadius: CornerRadius.card)
                            .frame(height: 200)
                    }

                    // AI Outfit Suggestion (Premium only)
                    if appState.isPremium {
                        if state.isLoadingSuggestion {
                            OutfitSuggestionLoadingCard()
                        } else if let suggestion = state.suggestion {
                            OutfitSuggestionCard(
                                suggestion: suggestion,
                                wardrobeItems: state.wardrobeItems,
                                onUse: state.useOutfit,
                                onSuggestAnother: state.suggestAnother
                            )
                        }
                    } else {
                        // Free user - upgrade CTA
                        PremiumFeatureCard()
                    }

                    // Quick Actions
                    QuickActionsGrid()
                }
                .screenPadding()
                .padding(.vertical, Spacing.xl)
            }
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await state.loadData()
            }
        }
        .task {
            await state.loadData()
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Good morning"
        } else if hour < 17 {
            return "Good afternoon"
        } else {
            return "Good evening"
        }
    }

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

// MARK: - Premium Feature Card

struct PremiumFeatureCard: View {
    var body: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                        Text("AI Outfit Suggestions")
                            .font(.headline)
                    }
                    .foregroundColor(.terracotta)

                    Text("Get personalized daily outfit suggestions based on weather, your wardrobe, and your style preferences.")
                        .font(.callout)
                        .foregroundColor(.adaptiveTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundColor(.terracotta.opacity(0.3))
            }

            PrimaryButton(title: "Upgrade to Premium", action: {})
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.card)
                .fill(Color.backgroundSecondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.card)
                .stroke(Color.terracotta.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Quick Actions Grid

struct QuickActionsGrid: View {
    let actions: [(icon: String, title: String, action: () -> Void)] = [
        ("plus.circle.fill", "Add Item", {}),
        ("tshirt.fill", "Browse Wardrobe", {}),
        ("square.stack.3d.up.fill", "View Outfits", {}),
        ("calendar", "Plan Week", {})
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.adaptiveText)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.md) {
                ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                    QuickActionButton(
                        icon: action.icon,
                        title: action.title,
                        action: action.action
                    )
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.terracotta)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.adaptiveText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .fill(Color.backgroundSecondary)
            )
            .subtleShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview("Home - Premium") {
    let appState = AppState.previewPremium
    return HomeView(appState: appState)
        .environmentObject(appState)
}

#Preview("Home - Free") {
    let appState = AppState.previewFree
    return HomeView(appState: appState)
        .environmentObject(appState)
}

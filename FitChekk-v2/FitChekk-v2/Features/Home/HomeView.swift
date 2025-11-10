//
//  HomeFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class HomeState {
    var greeting: String = "Good morning"
    var userName: String = "Emma"
    var currentDate: String = ""
    var weather: MockWeather = MockWeather.sample
    var suggestedOutfit: MockOutfit? = MockOutfit.sampleOutfits.first
    var isLoading: Bool = false
    
    init() {
        updateDate()
    }
    
    private func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        currentDate = formatter.string(from: Date())
    }
}

// MARK: - Actions

enum HomeAction {
    case onAppear
    case refreshWeather
    case useOutfitTapped
    case suggestAnotherTapped
    case startWithItemTapped
    case wardrobeTapped
    case plannerTapped
    case settingsTapped
}

// MARK: - View

struct HomeView: View {
    @State private var state = HomeState()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.section) {
                    // Header
                    headerSection
                    
                    // Weather Section
                    weatherSection
                    
                    // Outfit Suggestion Section
                    outfitSection
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding(.horizontal, Spacing.screenMargin)
                .padding(.top, Spacing.topSafeArea)
                .padding(.bottom, Spacing.bottomSafeArea)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.logoPrimary)
                        Text("FitChekk")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.verticalTight) {
            Text("\(state.greeting), \(state.userName)! 👋")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            Text(state.currentDate)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Weather Section
    
    private var weatherSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Weather")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.standard) {
                HStack {
                    Image(systemName: weatherIcon(for: state.weather.condition))
                        .font(.title)
                        .foregroundColor(.accentPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(Int(state.weather.tempHigh))°")
                            .font(.title)
                            .foregroundColor(.textPrimary)
                        Text(state.weather.condition)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        Text("Feels like \(Int(state.weather.feelsLike))°")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    
                    Spacer()
                }
                
                // 5-day forecast strip
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.group) {
                        ForEach(state.weather.forecast, id: \.day) { forecast in
                            VStack(spacing: 4) {
                                Text(forecast.day)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                Image(systemName: weatherIcon(for: forecast.condition))
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                Text("\(Int(forecast.temp))°")
                                    .font(.caption)
                                    .foregroundColor(.textPrimary)
                            }
                            .padding(.horizontal, Spacing.standard)
                            .padding(.vertical, Spacing.verticalTight)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(Spacing.standard)
            .cardStyle()
        }
    }
    
    // MARK: - Outfit Section
    
    private var outfitSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Today's Outfit")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if let outfit = state.suggestedOutfit {
                VStack(spacing: Spacing.standard) {
                    // Outfit preview
                    HStack(spacing: Spacing.group) {
                        ForEach(outfit.items.prefix(3)) { item in
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.backgroundSecondary)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: item.imagePlaceholder)
                                    .font(.title)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        if outfit.items.count > 3 {
                            Text("+\(outfit.items.count - 3)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                                .padding(8)
                                .background(Color.backgroundSecondary)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.vertical, Spacing.standard)
                    
                    // AI Reasoning
                    if let reasoning = outfit.aiReasoning {
                        Text(reasoning)
                            .font(.callout)
                            .foregroundColor(.textSecondary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Action Buttons
                    HStack(spacing: Spacing.group) {
                        Button(action: {}) {
                            Text("Use This Outfit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.standard)
                                .background(Color.accentPrimary)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            Text("Suggest Another")
                                .font(.body)
                                .foregroundColor(.accentPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.standard)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(Spacing.standard)
                .largeCardStyle()
            } else {
                // Empty state
                VStack(spacing: Spacing.group) {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.textTertiary)
                    
                    Text("No outfit suggested yet")
                        .font(.headline)
                        .foregroundColor(.textSecondary)
                    
                    Button(action: {}) {
                        Text("Start With An Item →")
                            .font(.body)
                            .foregroundColor(.accentPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.generous)
                .cardStyle()
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.group) {
                QuickActionButton(
                    icon: "camera.fill",
                    title: "Add Item",
                    color: .accentPrimary
                ) {}
                
                QuickActionButton(
                    icon: "tshirt.fill",
                    title: "Wardrobe",
                    color: .info
                ) {}
                
                QuickActionButton(
                    icon: "calendar",
                    title: "Planner",
                    color: .success
                ) {}
                
                QuickActionButton(
                    icon: "gearshape.fill",
                    title: "Settings",
                    color: .textSecondary
                ) {}
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func weatherIcon(for condition: String) -> String {
        let lowercased = condition.lowercased()
        if lowercased.contains("sunny") || lowercased.contains("clear") {
            return "sun.max.fill"
        } else if lowercased.contains("cloudy") {
            return "cloud.fill"
        } else if lowercased.contains("rain") {
            return "cloud.rain.fill"
        } else if lowercased.contains("snow") {
            return "cloud.snow.fill"
        } else {
            return "cloud.fill"
        }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.verticalTight) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 56, height: 56)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.standard)
            .cardStyle()
        }
    }
}

#Preview {
    HomeView()
}


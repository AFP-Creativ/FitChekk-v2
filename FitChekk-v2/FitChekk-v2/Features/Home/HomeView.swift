//
//  HomeView.swift
//  FitChekk-v2
//
//  Home screen showing weather and daily outfit suggestion
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var showPaywall = false
    
    var todayOutfit: Outfit? {
        appState.getPlannerEntry(for: Date())
            .flatMap { entry in
                entry.outfitId.flatMap { appState.getOutfit(id: $0) }
            }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Greeting
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Good \(greetingTime), \(appState.currentUser.displayName ?? "there")!")
                            .font(.displayMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text(Date().formatted(date: .complete, time: .omitted))
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, Spacing.md)
                    
                    // Weather Section
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Image(systemName: MockData.todayWeather.conditionIcon)
                                .font(.title)
                            Text("\(Int(MockData.todayWeather.tempHigh))°")
                                .font(.displayLarge)
                            Text(MockData.todayWeather.condition)
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                            Spacer()
                        }
                        .foregroundColor(.textPrimary)
                        
                        // 5-day forecast
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Spacing.xs) {
                                ForEach(Array(MockData.weekWeather.enumerated()), id: \.offset) { index, weather in
                                    WeatherCard(weather: weather, isToday: index == 0)
                                }
                            }
                        }
                    }
                    .padding(Spacing.lg)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.xl)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    
                    // Today's Outfit Section
                    if appState.currentUser.subscriptionTier == .premium {
                        premiumOutfitSection
                    } else {
                        freeUserSection
                    }
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Premium Section
    
    private var premiumOutfitSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Today's Outfit")
                .font(.displaySmall)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            if let outfit = todayOutfit {
                // Show scheduled outfit
                VStack(spacing: Spacing.lg) {
                    // Outfit visualization
                    ZStack {
                        Color.backgroundSecondary
                        
                        HStack(spacing: 8) {
                            ForEach(outfit.itemIds.prefix(3), id: \.self) { itemId in
                                if let item = appState.getItem(id: itemId) {
                                    Color(hex: item.imageColor ?? "#D4C5B9")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                }
                            }
                        }
                        .padding(Spacing.lg)
                    }
                    .frame(height: 280)
                    .cornerRadius(CornerRadius.xl)
                    
                    // AI Reasoning (if AI-generated)
                    if outfit.aiGenerated, let reasoning = outfit.aiReasoning {
                        Text(reasoning)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .padding(Spacing.md)
                            .background(Color.energySubtle.opacity(0.3))
                            .cornerRadius(CornerRadius.md)
                    }
                    
                    // Actions
                    HStack(spacing: Spacing.md) {
                        PrimaryButton(title: "Wear This Outfit") {
                            // Mark as worn
                        }
                        
                        SecondaryButton(title: "Suggest Another") {
                            // Get new suggestion
                        }
                    }
                }
                .padding(Spacing.lg)
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.xl)
                .padding(.horizontal, Spacing.screenHorizontal)
            } else {
                // No outfit scheduled - show AI suggestion
                VStack(spacing: Spacing.lg) {
                    // Mock AI suggestion using first outfit
                    let suggestion = MockData.outfits[0]
                    
                    ZStack {
                        Color.backgroundSecondary
                        
                        HStack(spacing: 8) {
                            ForEach(suggestion.itemIds.prefix(3), id: \.self) { itemId in
                                if let item = appState.getItem(id: itemId) {
                                    Color(hex: item.imageColor ?? "#D4C5B9")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                }
                            }
                        }
                        .padding(Spacing.lg)
                        
                        // AI badge
                        VStack {
                            HStack {
                                Spacer()
                                Text("AI Suggested ✨")
                                    .font(.labelSmall.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, Spacing.xxs)
                                    .background(Color.accentPrimary)
                                    .cornerRadius(CornerRadius.sm)
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                    .frame(height: 280)
                    .cornerRadius(CornerRadius.xl)
                    
                    // AI Reasoning
                    if let reasoning = suggestion.aiReasoning {
                        Text(reasoning)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .padding(Spacing.md)
                            .background(Color.energySubtle.opacity(0.3))
                            .cornerRadius(CornerRadius.md)
                    }
                    
                    // Actions
                    HStack(spacing: Spacing.md) {
                        PrimaryButton(title: "Use This Outfit") {
                            // Schedule outfit
                        }
                        
                        SecondaryButton(title: "Suggest Another") {
                            // Get new suggestion
                        }
                    }
                    
                    TextButton(title: "or start with an item →") {
                        // Go to wardrobe
                        appState.selectTab(.wardrobe)
                    }
                }
                .padding(Spacing.lg)
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.xl)
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
    
    // MARK: - Free User Section
    
    private var freeUserSection: some View {
        VStack(spacing: Spacing.lg) {
            Text("Today's Outfit")
                .font(.displaySmall)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Locked state
            VStack(spacing: Spacing.lg) {
                ZStack {
                    Color.backgroundSecondary
                    
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentPrimary.opacity(0.5))
                        
                        Text("Unlock AI Outfit Suggestions")
                            .font(.headlineLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text("Get daily personalized outfit suggestions based on weather and your style")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(Spacing.xxl)
                }
                .frame(height: 280)
                .cornerRadius(CornerRadius.xl)
                
                PrimaryButton(title: "Upgrade to Premium") {
                    showPaywall = true
                }
                
                TextButton(title: "or browse your wardrobe →") {
                    appState.selectTab(.wardrobe)
                }
            }
            .padding(Spacing.lg)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.xl)
        }
        .padding(.horizontal, Spacing.screenHorizontal)
        .sheet(isPresented: $showPaywall) {
            PaywallView(onDismiss: { showPaywall = false })
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Quick Actions")
                .font(.displaySmall)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "Add Item",
                    color: .accentPrimary
                ) {
                    appState.selectTab(.wardrobe)
                }
                
                QuickActionButton(
                    icon: "hanger",
                    title: "Create Outfit",
                    color: .logoPrimary
                ) {
                    appState.selectTab(.outfits)
                }
                
                QuickActionButton(
                    icon: "calendar",
                    title: "Plan Week",
                    color: .info
                ) {
                    appState.selectTab(.planner)
                }
                
                QuickActionButton(
                    icon: "chart.bar.fill",
                    title: "View Stats",
                    color: .success
                ) {
                    // Show stats
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
    
    // MARK: - Helpers
    
    private var greetingTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
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
            VStack(spacing: Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.bodyMedium.weight(.medium))
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.xl)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.md)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Paywall View (Placeholder)

struct PaywallView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xl) {
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundColor(.accentPrimary)
                
                Text("Unlock FitChekk Premium")
                    .font(.displayMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Get AI-powered outfit suggestions, unlimited wardrobe items, and calendar planning")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)
                
                VStack(spacing: Spacing.md) {
                    FeatureRow(icon: "brain", title: "AI Outfit Suggestions")
                    FeatureRow(icon: "infinity", title: "Unlimited Items")
                    FeatureRow(icon: "calendar", title: "Calendar Planning")
                    FeatureRow(icon: "chart.bar", title: "Style Analytics")
                }
                .padding(.horizontal, Spacing.xxl)
                
                Spacer()
                
                VStack(spacing: Spacing.sm) {
                    PrimaryButton(title: "Start 7-Day Free Trial") {
                        // Start trial
                    }
                    
                    Text("Then $7.99/month or $59.99/year")
                        .font(.labelSmall)
                        .foregroundColor(.textTertiary)
                }
                .padding(.horizontal, Spacing.xxl)
            }
            .padding(.vertical, Spacing.xxl)
            .background(Color.backgroundPrimary)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        onDismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentPrimary)
                .frame(width: 30)
            
            Text(title)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.body.weight(.semibold))
                .foregroundColor(.success)
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.md)
    }
}

#Preview {
    HomeView()
        .environment(AppState())
}


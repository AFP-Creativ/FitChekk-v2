//
//  OnboardingView.swift
//  FitChekk-v2
//
//  Onboarding and style quiz
//  (Bypassed for mockup, but included for completeness)
//

import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    @State private var selectedStyles: Set<String> = []
    @State private var selectedColors: Set<String> = []
    
    let totalPages = 5
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack(spacing: 4) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentPage ? Color.accentPrimary : Color.backgroundSecondary)
                        .frame(height: 4)
                }
            }
            .padding(Spacing.screenHorizontal)
            .padding(.top, Spacing.md)
            
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                welcomePage
                    .tag(0)
                
                // Page 2: Style preferences
                stylePage
                    .tag(1)
                
                // Page 3: Colors
                colorsPage
                    .tag(2)
                
                // Page 4: Lifestyle
                lifestylePage
                    .tag(3)
                
                // Page 5: Complete
                completePage
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Navigation buttons
            HStack(spacing: Spacing.md) {
                if currentPage > 0 {
                    SecondaryButton(title: "Back") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                }
                
                PrimaryButton(title: currentPage == totalPages - 1 ? "Get Started" : "Continue") {
                    if currentPage == totalPages - 1 {
                        onComplete()
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }
            }
            .padding(Spacing.screenHorizontal)
            .padding(.bottom, Spacing.lg)
        }
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - Pages
    
    private var welcomePage: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.accentPrimary)
            
            VStack(spacing: Spacing.md) {
                Text("Let's personalize FitChekk for you")
                    .font(.displayMedium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Answer a few quick questions to get AI suggestions that match your style")
                    .font(.bodyLarge)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.xxl)
            
            Spacer()
        }
    }
    
    private var stylePage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("What's your style?")
                        .font(.displaySmall)
                        .foregroundColor(.textPrimary)
                    
                    Text("Select all that apply")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.xl)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                    ForEach(["Minimalist", "Classic", "Preppy", "Boho", "Edgy", "Athletic", "Trendy", "Romantic"], id: \.self) { style in
                        StyleOption(
                            title: style,
                            icon: "checkmark.circle.fill",
                            isSelected: selectedStyles.contains(style)
                        ) {
                            if selectedStyles.contains(style) {
                                selectedStyles.remove(style)
                            } else {
                                selectedStyles.insert(style)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
    
    private var colorsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Favorite colors?")
                        .font(.displaySmall)
                        .foregroundColor(.textPrimary)
                    
                    Text("Choose 3-5 colors you wear most")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.xl)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: Spacing.md) {
                    ForEach(colorOptions, id: \.name) { colorOption in
                        ColorOption(
                            color: colorOption.color,
                            name: colorOption.name,
                            isSelected: selectedColors.contains(colorOption.name)
                        ) {
                            if selectedColors.contains(colorOption.name) {
                                selectedColors.remove(colorOption.name)
                            } else if selectedColors.count < 5 {
                                selectedColors.insert(colorOption.name)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
    
    private var lifestylePage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Your lifestyle?")
                        .font(.displaySmall)
                        .foregroundColor(.textPrimary)
                    
                    Text("Help us understand your daily routine")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.xl)
                
                VStack(spacing: Spacing.md) {
                    StyleOption(title: "Office Worker", icon: "briefcase", isSelected: false) { }
                    StyleOption(title: "Work from Home", icon: "house", isSelected: false) { }
                    StyleOption(title: "Student", icon: "book", isSelected: false) { }
                    StyleOption(title: "Entrepreneur", icon: "lightbulb", isSelected: false) { }
                    StyleOption(title: "Stay-at-Home Parent", icon: "figure.and.child.holdinghands", isSelected: false) { }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
    
    private var completePage: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.success)
            
            VStack(spacing: Spacing.md) {
                Text("You're all set!")
                    .font(.displayMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Now let's add your first wardrobe item to get started with AI suggestions")
                    .font(.bodyLarge)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.xxl)
            
            Spacer()
        }
    }
    
    // MARK: - Color Options
    
    private let colorOptions: [(name: String, color: String)] = [
        ("Black", "#2D2A27"),
        ("White", "#FAFAF9"),
        ("Navy", "#1B3A5F"),
        ("Camel", "#D4C5B9"),
        ("Grey", "#8B8681"),
        ("Brown", "#7A6F5F"),
        ("Red", "#D7584D"),
        ("Pink", "#F4C3B8"),
        ("Olive", "#7A8A5F"),
        ("Sage", "#A8B89F"),
    ]
}

// MARK: - Style Option

struct StyleOption: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .accentPrimary)
                
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(isSelected ? .white : .textPrimary)
                
                Spacer()
            }
            .padding(Spacing.md)
            .background(isSelected ? Color.accentPrimary : Color.backgroundSecondary)
            .cornerRadius(CornerRadius.md)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Color Option

struct ColorOption: View {
    let color: String
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Circle()
                    .fill(Color(hex: color))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color.accentPrimary, lineWidth: isSelected ? 3 : 0)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                Text(name)
                    .font(.labelSmall)
                    .foregroundColor(.textPrimary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView(onComplete: { })
}


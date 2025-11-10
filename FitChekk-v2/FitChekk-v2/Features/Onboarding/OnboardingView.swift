//
//  OnboardingFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class OnboardingState {
    var currentQuestion: Int = 0
    let totalQuestions: Int = 5
    
    // Question 1: Style preferences
    var selectedStyles: Set<String> = []
    
    // Question 2: Favorite colors
    var selectedColors: Set<String> = []
    
    // Question 3: Lifestyle
    var lifestyleType: String? = nil
    
    // Question 4: Occasions
    var selectedOccasions: Set<String> = []
    
    // Question 5: Climate
    var climateType: String? = nil
    var location: String = ""
    
    var canProceed: Bool {
        switch currentQuestion {
        case 0: return !selectedStyles.isEmpty
        case 1: return !selectedColors.isEmpty
        case 2: return lifestyleType != nil
        case 3: return !selectedOccasions.isEmpty
        case 4: return true // Climate can be auto-filled
        default: return false
        }
    }
}

// MARK: - Actions

enum OnboardingAction {
    case nextTapped
    case backTapped
    case skipTapped
    case styleSelected(String)
    case colorSelected(String)
    case lifestyleSelected(String)
    case occasionSelected(String)
    case climateSelected(String)
    case locationChanged(String)
    case complete
}

// MARK: - View

struct OnboardingView: View {
    @State private var state = OnboardingState()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            progressIndicator
            
            // Question content
            ScrollView {
                VStack(spacing: Spacing.section) {
                    questionContent
                }
                .padding(.horizontal, Spacing.screenMargin)
                .padding(.vertical, Spacing.generous)
            }
            
            // Navigation buttons
            navigationButtons
        }
        .background(Color.backgroundPrimary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Skip") {
                    // Skip onboarding
                }
            }
        }
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        VStack(spacing: Spacing.verticalTight) {
            HStack {
                ForEach(0..<state.totalQuestions, id: \.self) { index in
                    Rectangle()
                        .fill(index <= state.currentQuestion ? Color.accentPrimary : Color.backgroundSecondary)
                        .frame(height: 4)
                        .cornerRadius(2)
                }
            }
            
            Text("\(state.currentQuestion + 1) of \(state.totalQuestions)")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, Spacing.screenMargin)
        .padding(.vertical, Spacing.standard)
    }
    
    // MARK: - Question Content
    
    private var questionContent: some View {
        Group {
            switch state.currentQuestion {
            case 0:
                styleQuestion
            case 1:
                colorQuestion
            case 2:
                lifestyleQuestion
            case 3:
                occasionQuestion
            case 4:
                climateQuestion
            default:
                EmptyView()
            }
        }
    }
    
    // MARK: - Question 1: Style
    
    private var styleQuestion: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            Text("What's your go-to style?")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            Text("Select all that apply")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.group) {
                StyleCard(
                    title: "Minimalist",
                    icon: "square.grid.2x2",
                    isSelected: state.selectedStyles.contains("Minimalist")
                ) {
                    toggleStyle("Minimalist")
                }
                
                StyleCard(
                    title: "Classic",
                    icon: "book.closed",
                    isSelected: state.selectedStyles.contains("Classic")
                ) {
                    toggleStyle("Classic")
                }
                
                StyleCard(
                    title: "Boho",
                    icon: "sparkles",
                    isSelected: state.selectedStyles.contains("Boho")
                ) {
                    toggleStyle("Boho")
                }
                
                StyleCard(
                    title: "Preppy",
                    icon: "graduationcap",
                    isSelected: state.selectedStyles.contains("Preppy")
                ) {
                    toggleStyle("Preppy")
                }
            }
        }
    }
    
    private func toggleStyle(_ style: String) {
        if state.selectedStyles.contains(style) {
            state.selectedStyles.remove(style)
        } else {
            state.selectedStyles.insert(style)
        }
    }
    
    // MARK: - Question 2: Colors
    
    private var colorQuestion: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            Text("Favorite colors?")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            Text("Select 3-5 favorites")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.group) {
                ColorChip(color: "Navy", hex: "#1B3A5F", isSelected: state.selectedColors.contains("Navy")) {
                    toggleColor("Navy")
                }
                ColorChip(color: "White", hex: "#FFFFFF", isSelected: state.selectedColors.contains("White")) {
                    toggleColor("White")
                }
                ColorChip(color: "Camel", hex: "#C19A6B", isSelected: state.selectedColors.contains("Camel")) {
                    toggleColor("Camel")
                }
                ColorChip(color: "Black", hex: "#000000", isSelected: state.selectedColors.contains("Black")) {
                    toggleColor("Black")
                }
                ColorChip(color: "Gray", hex: "#808080", isSelected: state.selectedColors.contains("Gray")) {
                    toggleColor("Gray")
                }
                ColorChip(color: "Coral", hex: "#FF6B6B", isSelected: state.selectedColors.contains("Coral")) {
                    toggleColor("Coral")
                }
            }
        }
    }
    
    private func toggleColor(_ color: String) {
        if state.selectedColors.contains(color) {
            state.selectedColors.remove(color)
        } else if state.selectedColors.count < 5 {
            state.selectedColors.insert(color)
        }
    }
    
    // MARK: - Question 3: Lifestyle
    
    private var lifestyleQuestion: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            Text("What's your daily life like?")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.group) {
                LifestyleCard(
                    title: "Remote Worker",
                    description: "Work from home most days",
                    isSelected: state.lifestyleType == "Remote Worker"
                ) {
                    state.lifestyleType = "Remote Worker"
                }
                
                LifestyleCard(
                    title: "Office Worker",
                    description: "In-office 3+ days per week",
                    isSelected: state.lifestyleType == "Office Worker"
                ) {
                    state.lifestyleType = "Office Worker"
                }
                
                LifestyleCard(
                    title: "Student",
                    description: "Campus life and classes",
                    isSelected: state.lifestyleType == "Student"
                ) {
                    state.lifestyleType = "Student"
                }
            }
        }
    }
    
    // MARK: - Question 4: Occasions
    
    private var occasionQuestion: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            Text("Dress for what occasions?")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            Text("Select all that apply")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.group) {
                ForEach(OccasionType.allCases, id: \.rawValue) { occasion in
                    OccasionChip(
                        occasion: occasion,
                        isSelected: state.selectedOccasions.contains(occasion.rawValue)
                    ) {
                        toggleOccasion(occasion.rawValue)
                    }
                }
            }
        }
    }
    
    private func toggleOccasion(_ occasion: String) {
        if state.selectedOccasions.contains(occasion) {
            state.selectedOccasions.remove(occasion)
        } else {
            state.selectedOccasions.insert(occasion)
        }
    }
    
    // MARK: - Question 5: Climate
    
    private var climateQuestion: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            Text("What's your climate?")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            TextField("Enter your city", text: $state.location)
                .textFieldStyle(.roundedBorder)
                .padding(Spacing.standard)
                .cardStyle()
            
            Text("We'll use this for weather-based outfit suggestions")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Navigation Buttons
    
    private var navigationButtons: some View {
        HStack(spacing: Spacing.group) {
            if state.currentQuestion > 0 {
                Button(action: {
                    state.currentQuestion -= 1
                }) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.standard)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                }
            }
            
            Button(action: {
                if state.currentQuestion < state.totalQuestions - 1 {
                    state.currentQuestion += 1
                } else {
                    // Complete onboarding
                }
            }) {
                Text(state.currentQuestion < state.totalQuestions - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.standard)
                    .background(state.canProceed ? Color.accentPrimary : Color.textTertiary)
                    .cornerRadius(12)
            }
            .disabled(!state.canProceed)
        }
        .padding(.horizontal, Spacing.screenMargin)
        .padding(.vertical, Spacing.standard)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Style Card

struct StyleCard: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.group) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(isSelected ? .accentPrimary : .textSecondary)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.standard)
            .cardStyle(isSelected: isSelected)
        }
    }
}

// MARK: - Color Chip

struct ColorChip: View {
    let color: String
    let hex: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.accentPrimary : Color.clear, lineWidth: 3)
                    )
                
                Text(color)
                    .font(.caption2)
                    .foregroundColor(.textPrimary)
            }
        }
    }
}

// MARK: - Lifestyle Card

struct LifestyleCard: View {
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentPrimary)
                }
            }
            .padding(Spacing.standard)
            .cardStyle(isSelected: isSelected)
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}


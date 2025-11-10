//
//  EmptyStates.swift
//  FitChekk-v2
//
//  Reusable empty state views
//

import SwiftUI

// MARK: - Generic Empty State

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.accentPrimary.opacity(0.5))
            
            // Text
            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(.displaySmall)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            // Action button
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.md)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Specific Empty States

struct EmptyWardrobeView: View {
    let onAddItem: () -> Void
    
    var body: some View {
        EmptyStateView(
            icon: "tshirt",
            title: "Your wardrobe is empty",
            message: "Add your first item to get started with AI outfit suggestions",
            actionTitle: "Add Your First Item",
            action: onAddItem
        )
    }
}

struct EmptyOutfitsView: View {
    let onCreateOutfit: () -> Void
    
    var body: some View {
        EmptyStateView(
            icon: "hanger",
            title: "No outfits yet",
            message: "Create your first outfit or let AI suggest one based on your wardrobe and today's weather",
            actionTitle: "Create Outfit",
            action: onCreateOutfit
        )
    }
}

struct EmptyPlannerView: View {
    let onPlanOutfit: () -> Void
    
    var body: some View {
        EmptyStateView(
            icon: "calendar",
            title: "No outfits scheduled",
            message: "Plan your week ahead by scheduling outfits to specific dates",
            actionTitle: "Plan Your Week",
            action: onPlanOutfit
        )
    }
}

// MARK: - Loading View

struct LoadingView: View {
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .tint(.accentPrimary)
                .scaleEffect(1.5)
            
            Text(message)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary.opacity(0.8))
    }
}

// MARK: - Error View

struct ErrorView: View {
    let title: String
    let message: String
    let retryAction: (() -> Void)?
    
    init(
        title: String = "Something went wrong",
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.error)
            
            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(.displaySmall)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            if let retryAction = retryAction {
                PrimaryButton(title: "Try Again", action: retryAction)
                    .padding(.horizontal, Spacing.xl)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Previews

#Preview("Empty States") {
    TabView {
        EmptyWardrobeView(onAddItem: { })
            .tabItem { Label("Wardrobe", systemImage: "tshirt") }
        
        EmptyOutfitsView(onCreateOutfit: { })
            .tabItem { Label("Outfits", systemImage: "hanger") }
        
        EmptyPlannerView(onPlanOutfit: { })
            .tabItem { Label("Planner", systemImage: "calendar") }
        
        LoadingView(message: "Analyzing your wardrobe...")
            .tabItem { Label("Loading", systemImage: "hourglass") }
        
        ErrorView(
            message: "Could not connect to the server. Please check your internet connection.",
            retryAction: { }
        )
        .tabItem { Label("Error", systemImage: "exclamationmark.triangle") }
    }
}


//
//  EmptyStates.swift
//  FitChekk
//
//  Reusable empty state components
//  Ported from mockup
//

import SwiftUI

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)

            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(.displaySmall)
                    .foregroundColor(.textPrimary)

                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }

            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Loading State View

struct LoadingStateView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.accentPrimary)

            Text(message)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Error State View

struct ErrorStateView: View {
    let title: String
    let message: String
    var actionTitle: String = "Try Again"
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.error)

            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(.displaySmall)
                    .foregroundColor(.textPrimary)

                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }

            if let action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Preview

#Preview("Empty Wardrobe") {
    EmptyStateView(
        icon: "tshirt",
        title: "No Items Yet",
        message: "Start building your digital wardrobe by adding your first clothing item.",
        actionTitle: "Add First Item",
        action: {}
    )
}

#Preview("Empty Outfits") {
    EmptyStateView(
        icon: "hanger",
        title: "No Outfits Created",
        message: "Create your first outfit or let AI suggest one based on your wardrobe and today's weather.",
        actionTitle: "Create Outfit",
        action: {}
    )
}

#Preview("Loading State") {
    LoadingStateView(message: "Loading your wardrobe...")
}

#Preview("Error State") {
    ErrorStateView(
        title: "Connection Error",
        message: "We couldn't sync your data. Please check your internet connection and try again.",
        action: {}
    )
}

//
//  EmptyStateView.swift
//  FitChekk-v2
//
//  Reusable empty state component with icon, message, and optional action
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.terracotta.opacity(0.6))
                .padding(.bottom, Spacing.sm)

            // Title
            Text(title)
                .font(.title2)
                .foregroundColor(.adaptiveText)
                .multilineTextAlignment(.center)

            // Message
            Text(message)
                .font(.bodyText)
                .foregroundColor(.adaptiveTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)

            // Optional Action Button
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(
                    title: actionTitle,
                    action: action,
                    fullWidth: false
                )
                .padding(.top, Spacing.md)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary.opacity(0.5))
    }
}

// MARK: - Preview

#Preview("Empty States") {
    TabView {
        // Wardrobe Empty
        EmptyStateView(
            icon: "tshirt",
            title: "No Items Yet",
            message: "Start building your wardrobe by adding your first clothing item.",
            actionTitle: "Add Item",
            action: {}
        )
        .tabItem {
            Label("Wardrobe", systemImage: "tshirt")
        }

        // Outfits Empty
        EmptyStateView(
            icon: "square.stack.3d.up",
            title: "No Outfits Saved",
            message: "Create your first outfit combination or let AI suggest one for you.",
            actionTitle: "Create Outfit",
            action: {}
        )
        .tabItem {
            Label("Outfits", systemImage: "square.stack.3d.up")
        }

        // Planner Empty
        EmptyStateView(
            icon: "calendar",
            title: "No Planned Outfits",
            message: "Schedule outfits ahead of time and never worry about what to wear.",
            actionTitle: "Plan Outfit",
            action: {}
        )
        .tabItem {
            Label("Planner", systemImage: "calendar")
        }

        // Search Empty (no action)
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Try adjusting your search terms or filters."
        )
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
    }
}

#Preview("Empty States Dark") {
    EmptyStateView(
        icon: "tshirt",
        title: "No Items Yet",
        message: "Start building your wardrobe by adding your first clothing item.",
        actionTitle: "Add Item",
        action: {}
    )
    .preferredColorScheme(.dark)
}

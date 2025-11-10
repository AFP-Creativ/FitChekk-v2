//
//  LoadingView.swift
//  FitChekk-v2
//
//  Loading states with shimmer effect
//

import SwiftUI

// MARK: - Shimmer Effect

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .white.opacity(0.4),
                        .clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 500
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(Shimmer())
    }
}

// MARK: - Loading Skeleton Views

/// Generic shimmer rectangle
struct ShimmerRectangle: View {
    var cornerRadius: CGFloat = CornerRadius.md

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.backgroundSecondary)
            .shimmer()
    }
}

/// Loading card for wardrobe grid
struct LoadingItemCard: View {
    var body: some View {
        VStack(spacing: Spacing.xs) {
            // Image skeleton
            ShimmerRectangle(cornerRadius: CornerRadius.card)
                .aspectRatio(3/4, contentMode: .fit)

            // Title skeleton
            ShimmerRectangle(cornerRadius: 4)
                .frame(height: 12)
                .padding(.horizontal, Spacing.xs)
        }
        .padding(Spacing.xs)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.card)
                .fill(Color.backgroundElevated)
        )
    }
}

/// Loading grid of cards
struct LoadingGrid: View {
    var itemCount: Int = 6
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: Spacing.md)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Spacing.md) {
                ForEach(0..<itemCount, id: \.self) { _ in
                    LoadingItemCard()
                }
            }
            .padding(Spacing.screenPadding)
        }
    }
}

/// Generic loading spinner
struct LoadingSpinner: View {
    var message: String? = nil
    var size: CGFloat = 40

    var body: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .terracotta))
                .scaleEffect(size / 40)

            if let message = message {
                Text(message)
                    .font(.callout)
                    .foregroundColor(.adaptiveTextSecondary)
            }
        }
    }
}

/// Full screen loading overlay
struct LoadingOverlay: View {
    var message: String = "Loading..."

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: Spacing.md) {
                LoadingSpinner(size: 50)

                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(Color.backgroundPrimaryDark)
            )
        }
    }
}

// MARK: - Preview

#Preview("Loading Components") {
    TabView {
        // Shimmer Cards
        VStack(spacing: Spacing.xs) {
            Text("Loading Grid")
                .titleStyle()
                .padding(.top, Spacing.xl)

            LoadingGrid(itemCount: 8)
        }
        .background(Color.backgroundPrimary)
        .tabItem {
            Label("Grid", systemImage: "square.grid.2x2")
        }

        // Loading Spinner
        VStack {
            Spacer()

            LoadingSpinner(message: "Loading your wardrobe...")

            Spacer()

            LoadingSpinner(message: "Generating AI suggestion...", size: 60)

            Spacer()
        }
        .background(Color.backgroundPrimary)
        .tabItem {
            Label("Spinner", systemImage: "arrow.triangle.2.circlepath")
        }

        // Loading Overlay
        ZStack {
            // Fake content behind
            VStack {
                Text("Content Behind")
                    .titleStyle()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)

            LoadingOverlay(message: "Saving your outfit...")
        }
        .tabItem {
            Label("Overlay", systemImage: "square.stack")
        }

        // Skeleton Variations
        ScrollView {
            VStack(spacing: Spacing.xl) {
                Text("Skeleton Variations")
                    .titleStyle()

                // Card skeleton
                VStack(spacing: Spacing.md) {
                    ShimmerRectangle(cornerRadius: CornerRadius.card)
                        .frame(height: 200)

                    ShimmerRectangle(cornerRadius: 4)
                        .frame(height: 20)

                    ShimmerRectangle(cornerRadius: 4)
                        .frame(height: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 200)
                }
                .padding(Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.card)
                        .fill(Color.backgroundSecondary)
                )

                // List item skeleton
                HStack(spacing: Spacing.md) {
                    ShimmerRectangle(cornerRadius: CornerRadius.sm)
                        .frame(width: 60, height: 60)

                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        ShimmerRectangle(cornerRadius: 4)
                            .frame(height: 16)
                            .frame(maxWidth: 200)

                        ShimmerRectangle(cornerRadius: 4)
                            .frame(height: 12)
                            .frame(maxWidth: 120)
                    }

                    Spacer()
                }
                .padding(Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.card)
                        .fill(Color.backgroundSecondary)
                )
            }
            .padding(Spacing.screenPadding)
        }
        .background(Color.backgroundPrimary)
        .tabItem {
            Label("Skeletons", systemImage: "rectangle.3.group")
        }
    }
}

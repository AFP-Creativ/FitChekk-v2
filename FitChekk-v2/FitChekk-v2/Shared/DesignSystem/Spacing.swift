//
//  Spacing.swift
//  FitChekk-v2
//
//  Design System - Spacing System
//  Base Unit: 8pt for consistent, mathematical spacing
//

import SwiftUI

/// Spacing system based on 8pt base unit
enum Spacing {
    /// 4pt - Extra tight spacing (0.5 units)
    static let xxs: CGFloat = 4

    /// 8pt - Tight spacing (1 unit)
    static let xs: CGFloat = 8

    /// 12pt - Small spacing (1.5 units)
    static let sm: CGFloat = 12

    /// 16pt - Standard spacing (2 units) - Default padding
    static let md: CGFloat = 16

    /// 20pt - Medium-large spacing (2.5 units)
    static let lg: CGFloat = 20

    /// 24pt - Large spacing (3 units) - Section breaks
    static let xl: CGFloat = 24

    /// 32pt - Extra large spacing (4 units)
    static let xxl: CGFloat = 32

    /// 40pt - Huge spacing (5 units)
    static let xxxl: CGFloat = 40

    /// 48pt - Massive spacing (6 units)
    static let huge: CGFloat = 48

    /// 64pt - Extra massive spacing (8 units)
    static let giant: CGFloat = 64

    // MARK: - Semantic Spacing

    /// Standard horizontal screen padding (16pt)
    static let screenPadding: CGFloat = md

    /// Standard vertical spacing between elements (8pt)
    static let verticalPadding: CGFloat = xs

    /// Card internal padding (16pt)
    static let cardPadding: CGFloat = md

    /// Section spacing (24pt)
    static let sectionSpacing: CGFloat = xl

    /// Grid gap between items (16pt)
    static let gridGap: CGFloat = md

    /// Minimum touch target size (44pt - iOS standard)
    static let minTouchTarget: CGFloat = 44
}

// MARK: - Corner Radius

enum CornerRadius {
    /// Small corner radius (8pt)
    static let sm: CGFloat = 8

    /// Medium corner radius (12pt)
    static let md: CGFloat = 12

    /// Large corner radius (16pt)
    static let lg: CGFloat = 16

    /// Extra large corner radius (20pt)
    static let xl: CGFloat = 20

    /// Pill shape (very large, typically half of height)
    static let pill: CGFloat = 100

    // MARK: - Semantic Corner Radius

    /// Button corner radius (12pt)
    static let button: CGFloat = md

    /// Card corner radius (16pt)
    static let card: CGFloat = lg

    /// Chip corner radius (pill)
    static let chip: CGFloat = pill
}

// MARK: - View Extensions

extension View {
    /// Apply standard screen padding (16pt horizontal)
    func screenPadding() -> some View {
        self.padding(.horizontal, Spacing.screenPadding)
    }

    /// Apply card padding (16pt all sides)
    func cardPadding() -> some View {
        self.padding(Spacing.cardPadding)
    }

    /// Apply section spacing (24pt vertical)
    func sectionSpacing() -> some View {
        self.padding(.vertical, Spacing.sectionSpacing)
    }

    /// Apply custom spacing
    func spacing(_ value: CGFloat) -> some View {
        self.padding(value)
    }
}

// MARK: - Preview

struct SpacingPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                Text("Spacing System")
                    .displayStyle()

                Text("Base Unit: 8pt")
                    .subheadlineStyle()

                Divider()

                // Spacing Scale
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Spacing Scale")
                        .headlineStyle()

                    spacingItem("XXS", Spacing.xxs, "4pt")
                    spacingItem("XS", Spacing.xs, "8pt")
                    spacingItem("SM", Spacing.sm, "12pt")
                    spacingItem("MD", Spacing.md, "16pt")
                    spacingItem("LG", Spacing.lg, "20pt")
                    spacingItem("XL", Spacing.xl, "24pt")
                    spacingItem("XXL", Spacing.xxl, "32pt")
                    spacingItem("XXXL", Spacing.xxxl, "40pt")
                    spacingItem("Huge", Spacing.huge, "48pt")
                    spacingItem("Giant", Spacing.giant, "64pt")
                }

                Divider()

                // Corner Radius
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Corner Radius")
                        .headlineStyle()

                    cornerRadiusItem("Small", CornerRadius.sm, "8pt")
                    cornerRadiusItem("Medium", CornerRadius.md, "12pt")
                    cornerRadiusItem("Large", CornerRadius.lg, "16pt")
                    cornerRadiusItem("Extra Large", CornerRadius.xl, "20pt")
                }

                Divider()

                // Usage Examples
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Usage Examples")
                        .headlineStyle()

                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Card with standard padding")
                            .font(.caption)
                            .foregroundColor(.textSecondary)

                        RoundedRectangle(cornerRadius: CornerRadius.card)
                            .fill(Color.backgroundSecondary)
                            .frame(height: 100)
                            .overlay(
                                Text("Card Content")
                                    .bodyStyle()
                                    .cardPadding()
                            )
                    }
                }
            }
            .screenPadding()
            .padding(.vertical, Spacing.xl)
        }
        .background(Color.backgroundPrimary)
    }

    func spacingItem(_ name: String, _ value: CGFloat, _ label: String) -> some View {
        HStack(spacing: Spacing.md) {
            Rectangle()
                .fill(Color.terracotta)
                .frame(width: value, height: 24)

            Text(name)
                .font(.bodyText)
                .foregroundColor(.textPrimary)
                .frame(width: 60, alignment: .leading)

            Text(label)
                .font(.captionText)
                .foregroundColor(.textSecondary)

            Spacer()
        }
    }

    func cornerRadiusItem(_ name: String, _ value: CGFloat, _ label: String) -> some View {
        HStack(spacing: Spacing.md) {
            RoundedRectangle(cornerRadius: value)
                .fill(Color.terracotta)
                .frame(width: 60, height: 40)

            Text(name)
                .font(.bodyText)
                .foregroundColor(.textPrimary)
                .frame(width: 80, alignment: .leading)

            Text(label)
                .font(.captionText)
                .foregroundColor(.textSecondary)

            Spacer()
        }
    }
}

#Preview("Spacing") {
    SpacingPreview()
}

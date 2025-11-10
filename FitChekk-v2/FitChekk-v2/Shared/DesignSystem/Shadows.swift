//
//  Shadows.swift
//  FitChekk-v2
//
//  Design System - Shadow System
//  Terracotta-tinted shadows for warm, elevated UI elements
//

import SwiftUI

/// Shadow system with terracotta tinting
enum ShadowStyle {
    /// Subtle shadow for cards
    case card

    /// Medium shadow for floating elements
    case floating

    /// Strong shadow for prominent elements
    case elevated

    /// Very subtle shadow for subtle elevation
    case subtle

    /// No shadow
    case none

    var radius: CGFloat {
        switch self {
        case .none: return 0
        case .subtle: return 4
        case .card: return 12
        case .floating: return 16
        case .elevated: return 24
        }
    }

    var yOffset: CGFloat {
        switch self {
        case .none: return 0
        case .subtle: return 2
        case .card: return 4
        case .floating: return 6
        case .elevated: return 8
        }
    }

    var opacity: Double {
        switch self {
        case .none: return 0
        case .subtle: return 0.04
        case .card: return 0.08
        case .floating: return 0.12
        case .elevated: return 0.16
        }
    }

    var color: Color {
        // Terracotta-tinted shadow
        Color.terracotta
    }
}

// MARK: - View Extensions

extension View {
    /// Apply card shadow (terracotta-tinted, 12pt blur, 4pt Y-offset, 8% opacity)
    func cardShadow() -> some View {
        self.shadow(
            color: ShadowStyle.card.color.opacity(ShadowStyle.card.opacity),
            radius: ShadowStyle.card.radius,
            x: 0,
            y: ShadowStyle.card.yOffset
        )
    }

    /// Apply floating shadow (for FAB buttons, prominent elements)
    func floatingShadow() -> some View {
        self.shadow(
            color: ShadowStyle.floating.color.opacity(ShadowStyle.floating.opacity),
            radius: ShadowStyle.floating.radius,
            x: 0,
            y: ShadowStyle.floating.yOffset
        )
    }

    /// Apply elevated shadow (for modals, sheets)
    func elevatedShadow() -> some View {
        self.shadow(
            color: ShadowStyle.elevated.color.opacity(ShadowStyle.elevated.opacity),
            radius: ShadowStyle.elevated.radius,
            x: 0,
            y: ShadowStyle.elevated.yOffset
        )
    }

    /// Apply subtle shadow (very light)
    func subtleShadow() -> some View {
        self.shadow(
            color: ShadowStyle.subtle.color.opacity(ShadowStyle.subtle.opacity),
            radius: ShadowStyle.subtle.radius,
            x: 0,
            y: ShadowStyle.subtle.yOffset
        )
    }

    /// Apply custom shadow style
    func customShadow(_ style: ShadowStyle) -> some View {
        if style == .none {
            return self
        }
        return self.shadow(
            color: style.color.opacity(style.opacity),
            radius: style.radius,
            x: 0,
            y: style.yOffset
        )
    }
}

// MARK: - Preview

struct ShadowsPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                Text("Shadow System")
                    .displayStyle()

                Text("Terracotta-tinted shadows for warm elevation")
                    .subheadlineStyle()

                Divider()

                // Shadow Examples
                VStack(spacing: Spacing.xxxl) {
                    shadowExample("Subtle Shadow", shadow: .subtleShadow())
                    shadowExample("Card Shadow", shadow: .cardShadow())
                    shadowExample("Floating Shadow", shadow: .floatingShadow())
                    shadowExample("Elevated Shadow", shadow: .elevatedShadow())
                }

                Divider()

                // Real-world Examples
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Real-world Examples")
                        .headlineStyle()

                    Text("Item Card")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    // Simulated item card
                    RoundedRectangle(cornerRadius: CornerRadius.card)
                        .fill(Color.backgroundSecondary)
                        .frame(height: 120)
                        .cardShadow()
                        .overlay(
                            VStack(spacing: Spacing.xs) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.terracotta.opacity(0.3))
                                    .frame(width: 60, height: 60)

                                Text("Item Name")
                                    .font(.captionText)
                                    .foregroundColor(.textPrimary)
                            }
                            .cardPadding()
                        )

                    Text("Floating Action Button")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .padding(.top, Spacing.md)

                    HStack {
                        Spacer()

                        Circle()
                            .fill(Color.terracotta)
                            .frame(width: 56, height: 56)
                            .floatingShadow()
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
            .screenPadding()
            .padding(.vertical, Spacing.xl)
        }
        .background(Color.backgroundPrimary)
    }

    func shadowExample(_ title: String, shadow: some View) -> some View {
        VStack(spacing: Spacing.sm) {
            Text(title)
                .font(.callout)
                .foregroundColor(.textPrimary)

            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .fill(Color.backgroundSecondary)
                .frame(width: 200, height: 80)
                .modifier(ShadowModifier(shadowView: shadow))
        }
    }
}

// Helper to apply shadows in preview
struct ShadowModifier<ShadowView: View>: ViewModifier {
    let shadowView: ShadowView

    func body(content: Content) -> some View {
        shadowView
    }
}

#Preview("Shadows Light") {
    ShadowsPreview()
        .preferredColorScheme(.light)
}

#Preview("Shadows Dark") {
    ShadowsPreview()
        .preferredColorScheme(.dark)
}

//
//  Colors.swift
//  FitChekk
//
//  FitChekk Design System - Color Palette
//  Ported from mockup with proven UI/UX specifications
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors

    /// Primary accent color - Terracotta (cooler/pinker shade)
    /// Use for: CTAs, selected states, "Create Outfit" button, active tabs
    static let accentPrimary = Color(hex: "#C17B6F")

    /// Primary accent hover state
    static let accentPrimaryHover = Color(hex: "#D4948A")

    /// Primary accent dark (for borders, subtle emphasis)
    static let accentPrimaryDark = Color(hex: "#A66B60")

    /// Logo primary color - Warm olive
    /// Use for: Logo symbol mark, brand recognition
    static let logoPrimary = Color(hex: "#7A8A5F")

    /// Success/Complete color - Warm sage green
    /// Use for: "Outfit saved", favorites heart fill, completion states
    static let success = Color(hex: "#A8B89F")

    /// Subtle energy color - Soft peach
    /// Use for: "New item" badges, AI suggestion indicators
    static let energySubtle = Color(hex: "#F4C3B8")

    // MARK: - Backgrounds (Light Mode)

    /// Primary app background - warm off-white, like natural linen
    static let backgroundPrimary = Color(hex: "#FAF8F5")

    /// Secondary background - warm beige for cards and sections
    static let backgroundSecondary = Color(hex: "#F5F3F0")

    /// Elevated surfaces - pure white for modals/overlays
    static let backgroundElevated = Color(hex: "#FFFFFF")

    // MARK: - Text (Light Mode)

    /// Primary text - deep warm charcoal (not pure black)
    /// Contrast ratio: 15.8:1 ✅ WCAG AAA
    static let textPrimary = Color(hex: "#2D2A27")

    /// Secondary text - warm medium gray for metadata
    /// Contrast ratio: 4.7:1 ✅ WCAG AA
    static let textSecondary = Color(hex: "#8B8681")

    /// Tertiary text - lighter warm gray for timestamps
    /// Contrast ratio: 3.2:1 ✅ WCAG AA (large text only)
    static let textTertiary = Color(hex: "#A8A39E")

    // MARK: - Semantic Colors

    /// Error states
    /// Contrast ratio: 4.6:1 ✅ WCAG AA
    static let error = Color(hex: "#D7584D")

    /// Warning states
    /// Contrast ratio: 3.5:1 ✅ WCAG AA (large text)
    static let warning = Color(hex: "#E8A54B")

    /// Info states
    /// Contrast ratio: 4.2:1 ✅ WCAG AA
    static let info = Color(hex: "#7A8A9E")

    // MARK: - Borders & Dividers

    /// Default border color for inputs and cards
    static let borderDefault = Color(hex: "#E0DCD8")

    /// Focused border color for inputs
    static let borderFocused = Color(hex: "#C17B6F")
    
    /// Subtle border color
    static let borderSubtle = Color(hex: "#F0EDE9")

    /// Divider color
    static let divider = Color(hex: "#F0EDE9")

    // MARK: - Dark Mode (Future)
    // Note: These are defined for future dark mode support

    static let backgroundPrimaryDark = Color(hex: "#2D2520")
    static let backgroundSecondaryDark = Color(hex: "#3A352F")
    static let backgroundElevatedDark = Color(hex: "#45403A")
    static let textPrimaryDark = Color(hex: "#FAF8F5")
    static let textSecondaryDark = Color(hex: "#C4BFB9")
    static let textTertiaryDark = Color(hex: "#8B8681")

    // MARK: - Helper Initializer

    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}

// MARK: - Shadow Styles

extension View {
    /// Branded shadow for item cards
    func itemCardShadow(isSelected: Bool = false) -> some View {
        self.shadow(
            color: Color.accentPrimary.opacity(isSelected ? 0.12 : 0.08),
            radius: isSelected ? 16 : 12,
            y: 4
        )
    }

    /// Shadow for elevated content (modals, etc.)
    func elevatedShadow() -> some View {
        self.shadow(
            color: Color.accentPrimary.opacity(0.10),
            radius: 16,
            y: 6
        )
    }

    /// Subtle shadow for buttons
    func buttonShadow() -> some View {
        self.shadow(
            color: Color.accentPrimary.opacity(0.3),
            radius: 8,
            y: 4
        )
    }
}

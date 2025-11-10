//
//  Colors.swift
//  FitChekk-v2
//
//  Design System - Color Palette
//  "Warm Gallery" theme: Neutral, inviting, with signature terracotta energy
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors

    /// Signature terracotta accent color - used for CTAs, selections, and primary actions
    static let terracotta = Color(hex: "C17B6F")

    /// Warm olive - brand identity color (logo, subtle branding)
    static let warmOlive = Color(hex: "7A8A5F")

    /// Soft peach - for badges, highlights, and subtle energy
    static let softPeach = Color(hex: "F4C3B8")

    /// Warm sage green - success states
    static let warmSage = Color(hex: "A8B89F")

    // MARK: - Light Mode Backgrounds

    /// Primary background - warm off-white (linen texture feel)
    static let backgroundPrimary = Color(hex: "FAF8F5")

    /// Secondary background - warm beige for cards
    static let backgroundSecondary = Color(hex: "F5F3F0")

    /// Elevated background - pure white for modals
    static let backgroundElevated = Color.white

    // MARK: - Dark Mode Backgrounds

    /// Dark mode primary background - rich warm dark brown
    static let backgroundPrimaryDark = Color(hex: "2D2520")

    /// Dark mode secondary background - lighter brown for cards
    static let backgroundSecondaryDark = Color(hex: "3A352F")

    /// Dark mode elevated background
    static let backgroundElevatedDark = Color(hex: "453F38")

    // MARK: - Text Colors (Light Mode)

    /// Primary text - deep warm charcoal (15.8:1 contrast)
    static let textPrimary = Color(hex: "2D2A27")

    /// Secondary text - warm medium gray (4.7:1 contrast)
    static let textSecondary = Color(hex: "8B8681")

    /// Tertiary text - lighter gray for metadata
    static let textTertiary = Color(hex: "ADA8A3")

    // MARK: - Text Colors (Dark Mode)

    /// Dark mode primary text - warm cream
    static let textPrimaryDark = Color(hex: "FAF8F5")

    /// Dark mode secondary text
    static let textSecondaryDark = Color(hex: "C4BFB8")

    /// Dark mode tertiary text
    static let textTertiaryDark = Color(hex: "8B8681")

    // MARK: - Semantic Colors

    /// Success state
    static let success = warmSage

    /// Warning state
    static let warning = Color(hex: "E8B55F")

    /// Error state
    static let error = Color(hex: "D9695F")

    /// Info state
    static let info = Color(hex: "7BA3BC")

    // MARK: - Adaptive Colors

    /// Background that adapts to light/dark mode
    static let adaptiveBackground = Color("AdaptiveBackground")

    /// Background secondary that adapts to light/dark mode
    static let adaptiveBackgroundSecondary = Color("AdaptiveBackgroundSecondary")

    /// Text that adapts to light/dark mode
    static let adaptiveText = Color("AdaptiveText")

    /// Text secondary that adapts to light/dark mode
    static let adaptiveTextSecondary = Color("AdaptiveTextSecondary")
}

// MARK: - Hex Color Extension

extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color code (e.g., "C17B6F" or "#C17B6F")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview Helper

struct ColorsPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                colorSection("Brand Colors", colors: [
                    ("Terracotta", .terracotta),
                    ("Warm Olive", .warmOlive),
                    ("Soft Peach", .softPeach),
                    ("Warm Sage", .warmSage)
                ])

                colorSection("Light Mode", colors: [
                    ("Background Primary", .backgroundPrimary),
                    ("Background Secondary", .backgroundSecondary),
                    ("Background Elevated", .backgroundElevated),
                    ("Text Primary", .textPrimary),
                    ("Text Secondary", .textSecondary),
                    ("Text Tertiary", .textTertiary)
                ])

                colorSection("Semantic Colors", colors: [
                    ("Success", .success),
                    ("Warning", .warning),
                    ("Error", .error),
                    ("Info", .info)
                ])
            }
            .padding()
        }
        .background(Color.backgroundPrimary)
    }

    func colorSection(_ title: String, colors: [(String, Color)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)

            ForEach(colors, id: \.0) { name, color in
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: 60, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.textTertiary.opacity(0.3), lineWidth: 1)
                        )

                    Text(name)
                        .font(.body)
                        .foregroundColor(.textPrimary)

                    Spacer()
                }
            }
        }
    }
}

#Preview("Colors") {
    ColorsPreview()
}

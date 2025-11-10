//
//  DesignSystem.swift
//  FitChekk-v2
//
//  Created for UI Mockups
//

import SwiftUI

// MARK: - Color System

extension Color {
    // MARK: Background Colors
    
    /// Primary app background - warm off-white, like natural linen
    static let backgroundPrimary = Color(hex: "#FAF8F5")
    
    /// Secondary background - warm beige for cards and sections
    static let backgroundSecondary = Color(hex: "#F5F3F0")
    
    /// Elevated surfaces - pure white for modals/overlays when needed
    static let backgroundElevated = Color(hex: "#FFFFFF")
    
    // MARK: Text Colors
    
    /// Primary text - deep warm charcoal (not pure black)
    static let textPrimary = Color(hex: "#2D2A27")
    
    /// Secondary text - warm medium gray for metadata
    static let textSecondary = Color(hex: "#8B8681")
    
    /// Tertiary text - lighter warm gray for timestamps
    static let textTertiary = Color(hex: "#A8A39E")
    
    // MARK: Accent Colors
    
    /// PRIMARY ACCENT: Terracotta (cooler/pinker shade)
    /// The signature FitChekk color for energy and action
    static let accentPrimary = Color(hex: "#C17B6F")
    
    /// Primary accent hover/pressed state
    static let accentPrimaryHover = Color(hex: "#D4948A")
    
    /// Primary accent dark variant
    static let accentPrimaryDark = Color(hex: "#A66B60")
    
    // MARK: Success/Complete
    
    /// Success/Complete - Warm sage green
    static let success = Color(hex: "#A8B89F")
    
    // MARK: Subtle Energy
    
    /// Subtle energy - Soft peach (background only)
    static let energySubtle = Color(hex: "#F4C3B8")
    
    // MARK: Semantic Colors
    
    /// Error states
    static let error = Color(hex: "#D7584D")
    
    /// Warning states
    static let warning = Color(hex: "#E8A54B")
    
    /// Info states
    static let info = Color(hex: "#7A8A9E")
    
    // MARK: Logo Colors
    
    /// Logo primary - Warm olive
    static let logoPrimary = Color(hex: "#7A8A5F")
    
    /// Logo accent - Terracotta accent line
    static let logoAccent = Color(hex: "#C17B6F")
    
    // MARK: Dark Mode Colors
    
    /// Primary background (dark mode)
    static let backgroundPrimaryDark = Color(hex: "#2D2520")
    
    /// Secondary background (dark mode)
    static let backgroundSecondaryDark = Color(hex: "#3A352F")
    
    /// Elevated surfaces (dark mode)
    static let backgroundElevatedDark = Color(hex: "#45403A")
    
    /// Primary text (dark mode)
    static let textPrimaryDark = Color(hex: "#FAF8F5")
    
    /// Secondary text (dark mode)
    static let textSecondaryDark = Color(hex: "#C4BFB9")
    
    /// Tertiary text (dark mode)
    static let textTertiaryDark = Color(hex: "#8B8681")
    
    // MARK: Hex Initializer
    
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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography

extension Font {
    /// Display - Major page titles (34pt, Bold)
    static let display = Font.system(size: 34, weight: .bold, design: .default)
    
    /// Title - Section headers (28pt, Bold)
    static let title = Font.system(size: 28, weight: .bold, design: .default)
    
    /// Title 2 - Subsection headers (22pt, Bold)
    static let title2 = Font.system(size: 22, weight: .bold, design: .default)
    
    /// Body - Primary content (17pt, Regular)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    
    /// Callout - Secondary content (16pt, Regular)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    
    /// Subheadline - Metadata, labels (15pt, Regular)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    
    /// Caption - Timestamps, tertiary info (12pt, Regular)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    /// Caption 2 - Fine print (11pt, Regular)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    /// Headline - Emphasized body text (17pt, Semibold)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    
    /// Footnote - Footnotes, disclaimers (13pt, Regular)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
}

// MARK: - Spacing

struct Spacing {
    /// Base unit: 8pt
    static let base: CGFloat = 8
    
    /// Standard horizontal padding (2 units)
    static let horizontal: CGFloat = 16
    
    /// Tight vertical spacing (1 unit)
    static let verticalTight: CGFloat = 8
    
    /// Standard padding (2 units)
    static let standard: CGFloat = 16
    
    /// Generous padding (3 units)
    static let generous: CGFloat = 24
    
    /// Section spacing (3 units)
    static let section: CGFloat = 24
    
    /// Group spacing (2 units)
    static let group: CGFloat = 16
    
    /// Grid gap (2 units)
    static let grid: CGFloat = 16
    
    /// Stack spacing (1.5 units)
    static let stack: CGFloat = 12
    
    /// Screen margin (left/right)
    static let screenMargin: CGFloat = 20
    
    /// Top safe area padding
    static let topSafeArea: CGFloat = 16
    
    /// Bottom safe area padding
    static let bottomSafeArea: CGFloat = 16
}

// MARK: - Component Styles

struct ButtonStyles {
    /// Primary button style
    static func primary() -> some View {
        EmptyView() // Will be used as modifier
    }
}

// MARK: - Card Styles

struct CardStyle {
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusLarge: CGFloat = 20
    static let shadowRadius: CGFloat = 12
    static let shadowRadiusLarge: CGFloat = 16
    static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
    static let shadowOffsetLarge: CGSize = CGSize(width: 0, height: 6)
}

// MARK: - View Modifiers

extension View {
    /// Apply standard card styling
    func cardStyle(isSelected: Bool = false) -> some View {
        self
            .background(Color.backgroundSecondary)
            .cornerRadius(CardStyle.cornerRadius)
            .shadow(
                color: Color.accentPrimary.opacity(isSelected ? 0.12 : 0.08),
                radius: isSelected ? CardStyle.shadowRadiusLarge : CardStyle.shadowRadius,
                y: isSelected ? CardStyle.shadowOffsetLarge.height : CardStyle.shadowOffset.height
            )
            .overlay(
                RoundedRectangle(cornerRadius: CardStyle.cornerRadius)
                    .stroke(Color.accentPrimary, lineWidth: isSelected ? 2 : 0)
            )
    }
    
    /// Apply large card styling (for hero content)
    func largeCardStyle() -> some View {
        self
            .background(Color.backgroundSecondary)
            .cornerRadius(CardStyle.cornerRadiusLarge)
            .shadow(
                color: Color.accentPrimary.opacity(0.10),
                radius: CardStyle.shadowRadiusLarge,
                y: CardStyle.shadowOffsetLarge.height
            )
    }
}


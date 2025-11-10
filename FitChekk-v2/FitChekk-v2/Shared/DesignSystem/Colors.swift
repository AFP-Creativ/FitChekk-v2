import SwiftUI

enum AppColors {
    // Light mode
    static let backgroundPrimary = Color(hex: "#FAF8F5")
    static let backgroundSecondary = Color(hex: "#F5F3F0")
    static let backgroundElevated = Color(hex: "#FFFFFF")

    static let textPrimary = Color(hex: "#2D2A27")
    static let textSecondary = Color(hex: "#8B8681")
    static let textTertiary = Color(hex: "#A8A39E")

    static let accentPrimary = Color(hex: "#C17B6F")
    static let accentPrimaryHover = Color(hex: "#D4948A")
    static let accentPrimaryDark = Color(hex: "#A66B60")

    static let success = Color(hex: "#A8B89F")
    static let energySubtle = Color(hex: "#F4C3B8")

    static let error = Color(hex: "#D7584D")
    static let warning = Color(hex: "#E8A54B")
    static let info = Color(hex: "#7A8A9E")

    // Dark mode
    static let backgroundPrimaryDark = Color(hex: "#2D2520")
    static let backgroundSecondaryDark = Color(hex: "#3A352F")
    static let backgroundElevatedDark = Color(hex: "#45403A")

    static let textPrimaryDark = Color(hex: "#FAF8F5")
    static let textSecondaryDark = Color(hex: "#C4BFB9")
    static let textTertiaryDark = Color(hex: "#8B8681")

    // Brand
    static let logoPrimary = Color(hex: "#7A8A5F")
    static let logoAccent = Color(hex: "#C17B6F")
}

extension Color {
    static func backgroundPrimary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? AppColors.backgroundPrimaryDark : AppColors.backgroundPrimary
    }
    static func backgroundSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? AppColors.backgroundSecondaryDark : AppColors.backgroundSecondary
    }
    static func backgroundElevated(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? AppColors.backgroundElevatedDark : AppColors.backgroundElevated
    }
    static func textPrimary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? AppColors.textPrimaryDark : AppColors.textPrimary
    }
    static func textSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? AppColors.textSecondaryDark : AppColors.textSecondary
    }
    static var accentPrimary: Color { AppColors.accentPrimary }
}



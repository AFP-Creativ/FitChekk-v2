//
//  Typography.swift
//  FitChekk-v2
//
//  FitChekk Design System - Typography
//

import SwiftUI

extension Font {
    // MARK: - Display
    
    /// 34pt Bold - Major page titles
    static let displayLarge: Font = .system(size: 34, weight: .bold, design: .default)
    
    /// 28pt Bold - Section headers
    static let displayMedium: Font = .system(size: 28, weight: .bold, design: .default)
    
    /// 22pt Bold - Subsection headers
    static let displaySmall: Font = .system(size: 22, weight: .bold, design: .default)
    
    // MARK: - Body
    
    /// 17pt Regular - Primary content (default)
    static let bodyLarge: Font = .system(size: 17, weight: .regular, design: .default)
    
    /// 16pt Regular - Secondary content
    static let bodyMedium: Font = .system(size: 16, weight: .regular, design: .default)
    
    // MARK: - Supporting
    
    /// 15pt Regular - Metadata, labels
    static let labelLarge: Font = .system(size: 15, weight: .regular, design: .default)
    
    /// 12pt Regular - Timestamps, tertiary info
    static let labelSmall: Font = .system(size: 12, weight: .regular, design: .default)
    
    /// 11pt Regular - Fine print
    static let labelExtraSmall: Font = .system(size: 11, weight: .regular, design: .default)
    
    // MARK: - Special
    
    /// 17pt Semibold - Emphasized body text
    static let headlineLarge: Font = .system(size: 17, weight: .semibold, design: .default)
    
    /// 15pt Semibold - Emphasized labels
    static let headlineMedium: Font = .system(size: 15, weight: .semibold, design: .default)
    
    /// 13pt Regular - Footnotes, disclaimers
    static let footnote: Font = .system(size: 13, weight: .regular, design: .default)
}

// MARK: - Text Styles (Convenience)

struct TextStyles {
    /// Page title style
    static func pageTitle(_ text: String) -> some View {
        Text(text)
            .font(.displayLarge)
            .foregroundColor(.textPrimary)
    }
    
    /// Section header style
    static func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.displayMedium)
            .foregroundColor(.textPrimary)
    }
    
    /// Subsection header style
    static func subsectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.displaySmall)
            .foregroundColor(.textPrimary)
    }
    
    /// Body text style
    static func body(_ text: String) -> some View {
        Text(text)
            .font(.bodyLarge)
            .foregroundColor(.textPrimary)
    }
    
    /// Secondary body text style
    static func bodySecondary(_ text: String) -> some View {
        Text(text)
            .font(.bodyMedium)
            .foregroundColor(.textSecondary)
    }
    
    /// Label style
    static func label(_ text: String) -> some View {
        Text(text)
            .font(.labelLarge)
            .foregroundColor(.textSecondary)
    }
    
    /// Caption style
    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.labelSmall)
            .foregroundColor(.textTertiary)
    }
}


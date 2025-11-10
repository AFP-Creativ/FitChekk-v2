//
//  Typography.swift
//  FitChekk-v2
//
//  Design System - Typography Styles
//  System Font: SF Pro with Dynamic Type support
//

import SwiftUI

extension Font {
    // MARK: - Display

    /// Display style - 34pt Bold
    /// Use for: Page titles, hero text
    static let display = Font.system(size: 34, weight: .bold, design: .default)

    /// Display style with custom size
    static func display(_ size: CGFloat) -> Font {
        return Font.system(size: size, weight: .bold, design: .default)
    }

    // MARK: - Title

    /// Title style - 28pt Bold
    /// Use for: Section headers, feature titles
    static let title = Font.system(size: 28, weight: .bold, design: .default)

    /// Title 2 style - 22pt Bold
    /// Use for: Subsections, card titles
    static let title2 = Font.system(size: 22, weight: .bold, design: .default)

    /// Title 3 style - 20pt Semibold
    /// Use for: Smaller section headers
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)

    // MARK: - Body

    /// Headline style - 17pt Semibold
    /// Use for: Emphasized body text, list items
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)

    /// Body style - 17pt Regular (default)
    /// Use for: Primary content, default text
    static let bodyText = Font.system(size: 17, weight: .regular, design: .default)

    /// Callout style - 16pt Regular
    /// Use for: Secondary content, descriptions
    static let callout = Font.system(size: 16, weight: .regular, design: .default)

    // MARK: - Small Text

    /// Subheadline style - 15pt Regular
    /// Use for: Metadata, labels, secondary info
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)

    /// Footnote style - 13pt Regular
    /// Use for: Tertiary content, fine print
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)

    /// Caption style - 12pt Regular
    /// Use for: Timestamps, small labels
    static let captionText = Font.system(size: 12, weight: .regular, design: .default)

    /// Caption 2 style - 11pt Regular
    /// Use for: Smallest text, legal copy
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Text Styles (View Modifiers)

extension View {
    /// Apply display text style
    func displayStyle() -> some View {
        self
            .font(.display)
            .foregroundColor(.adaptiveText)
    }

    /// Apply title text style
    func titleStyle() -> some View {
        self
            .font(.title)
            .foregroundColor(.adaptiveText)
    }

    /// Apply title 2 text style
    func title2Style() -> some View {
        self
            .font(.title2)
            .foregroundColor(.adaptiveText)
    }

    /// Apply headline text style
    func headlineStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.adaptiveText)
    }

    /// Apply body text style
    func bodyStyle() -> some View {
        self
            .font(.bodyText)
            .foregroundColor(.adaptiveText)
    }

    /// Apply callout text style
    func calloutStyle() -> some View {
        self
            .font(.callout)
            .foregroundColor(.adaptiveTextSecondary)
    }

    /// Apply subheadline text style
    func subheadlineStyle() -> some View {
        self
            .font(.subheadline)
            .foregroundColor(.adaptiveTextSecondary)
    }

    /// Apply caption text style
    func captionStyle() -> some View {
        self
            .font(.captionText)
            .foregroundColor(.adaptiveTextSecondary)
    }
}

// MARK: - Preview

struct TypographyPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Group {
                    Text("Display (34pt Bold)")
                        .displayStyle()

                    Text("Title (28pt Bold)")
                        .titleStyle()

                    Text("Title 2 (22pt Bold)")
                        .title2Style()

                    Text("Title 3 (20pt Semibold)")
                        .font(.title3)
                        .foregroundColor(.adaptiveText)
                }

                Divider()

                Group {
                    Text("Headline (17pt Semibold)")
                        .headlineStyle()

                    Text("Body (17pt Regular) - This is the default text style for primary content. It should be comfortable to read for extended periods.")
                        .bodyStyle()

                    Text("Callout (16pt Regular) - Used for secondary content and descriptions that support the primary message.")
                        .calloutStyle()
                }

                Divider()

                Group {
                    Text("Subheadline (15pt Regular)")
                        .subheadlineStyle()

                    Text("Footnote (13pt Regular)")
                        .font(.footnote)
                        .foregroundColor(.adaptiveTextSecondary)

                    Text("Caption (12pt Regular)")
                        .captionStyle()

                    Text("Caption 2 (11pt Regular)")
                        .font(.caption2)
                        .foregroundColor(.textTertiary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Dynamic Type Support")
                        .font(.headline)
                        .foregroundColor(.adaptiveText)

                    Text("All text styles support Dynamic Type and will scale according to user preferences for accessibility.")
                        .font(.callout)
                        .foregroundColor(.adaptiveTextSecondary)
                }
            }
            .padding()
        }
        .background(Color.backgroundPrimary)
    }
}

#Preview("Typography") {
    TypographyPreview()
}

#Preview("Typography Dark") {
    TypographyPreview()
        .preferredColorScheme(.dark)
}

//
//  Spacing.swift
//  FitChekk
//
//  FitChekk Design System - Spacing System
//  Base unit: 8pt
//  Ported from mockup for consistency
//

import SwiftUI

enum Spacing {
    /// 4pt - Extra tight spacing
    static let xxs: CGFloat = 4

    /// 8pt - Tight spacing (1 unit)
    static let xs: CGFloat = 8

    /// 12pt - Small spacing (1.5 units)
    static let sm: CGFloat = 12

    /// 16pt - Standard spacing (2 units)
    static let md: CGFloat = 16

    /// 20pt - Medium-large spacing (2.5 units)
    static let lg: CGFloat = 20

    /// 24pt - Large spacing (3 units)
    static let xl: CGFloat = 24

    /// 32pt - Extra large spacing (4 units)
    static let xxl: CGFloat = 32

    /// 40pt - Huge spacing (5 units)
    static let xxxl: CGFloat = 40

    // MARK: - Semantic Spacing

    /// Standard padding for screen edges
    static let screenHorizontal: CGFloat = 20

    /// Standard padding for screen top/bottom
    static let screenVertical: CGFloat = 16

    /// Grid gap for item cards
    static let gridGap: CGFloat = 16

    /// Card internal padding
    static let cardPadding: CGFloat = 16

    /// Section spacing
    static let sectionSpacing: CGFloat = 24
}

// MARK: - Corner Radius

enum CornerRadius {
    /// 8pt - Small elements (chips, small buttons)
    static let sm: CGFloat = 8

    /// 12pt - Medium elements (standard buttons)
    static let md: CGFloat = 12

    /// 16pt - Large elements (item cards)
    static let lg: CGFloat = 16

    /// 20pt - Extra large elements (outfit cards, modals)
    static let xl: CGFloat = 20

    /// 24pt - Huge elements (hero cards)
    static let xxl: CGFloat = 24
}

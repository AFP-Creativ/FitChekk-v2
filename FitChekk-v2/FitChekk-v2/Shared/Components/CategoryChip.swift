//
//  CategoryChip.swift
//  FitChekk-v2
//
//  Filter chip component for category selection
//

import SwiftUI

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(textColor)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(
                    Capsule()
                        .fill(backgroundColor)
                )
                .overlay(
                    Capsule()
                        .stroke(strokeColor, lineWidth: isSelected ? 2 : 1)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.terracotta.opacity(0.15)
        }
        return Color.backgroundSecondary
    }

    private var textColor: Color {
        if isSelected {
            return Color.terracotta
        }
        return Color.textPrimary
    }

    private var strokeColor: Color {
        if isSelected {
            return Color.terracotta
        }
        return Color.textTertiary.opacity(0.3)
    }
}

// MARK: - Category Chip Row

/// Horizontal scrolling row of category chips
struct CategoryChipRow: View {
    let categories: [String]
    @Binding var selectedCategory: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: selectedCategory == category,
                        action: {
                            if selectedCategory == category {
                                selectedCategory = nil
                            } else {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
            .padding(.vertical, Spacing.xs)
        }
    }
}

// MARK: - Preview

#Preview("Category Chips") {
    VStack(spacing: Spacing.xl) {
        Text("Category Chips")
            .displayStyle()

        Divider()

        // Individual States
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("States")
                .headlineStyle()

            HStack(spacing: Spacing.md) {
                CategoryChip(title: "Unselected", isSelected: false, action: {})
                CategoryChip(title: "Selected", isSelected: true, action: {})
            }
        }

        Divider()

        // Interactive Row
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Interactive Row")
                .headlineStyle()

            CategoryChipRowPreview()
        }

        Spacer()
    }
    .screenPadding()
    .padding(.vertical, Spacing.xl)
    .background(Color.backgroundPrimary)
}

private struct CategoryChipRowPreview: View {
    @State private var selectedCategory: String? = "Tops"

    var body: some View {
        CategoryChipRow(
            categories: ["All", "Tops", "Bottoms", "Dresses", "Outerwear", "Shoes", "Accessories"],
            selectedCategory: $selectedCategory
        )
    }
}

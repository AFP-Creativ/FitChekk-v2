//
//  SecondaryButton.swift
//  FitChekk-v2
//
//  Secondary button with beige background and terracotta text
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var fullWidth: Bool = true

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(textColor)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .frame(height: Spacing.minTouchTarget)
                .padding(.horizontal, fullWidth ? Spacing.md : Spacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.button)
                        .fill(backgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.button)
                        .stroke(strokeColor, lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
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
        .accessibilityAddTraits(isDisabled ? [.isButton, .isNotEnabled] : .isButton)
    }

    private var backgroundColor: Color {
        if isDisabled {
            return Color.backgroundSecondary.opacity(0.5)
        }
        return Color.backgroundSecondary
    }

    private var textColor: Color {
        if isDisabled {
            return Color.textTertiary
        }
        return Color.terracotta
    }

    private var strokeColor: Color {
        if isDisabled {
            return Color.textTertiary.opacity(0.3)
        }
        return Color.terracotta.opacity(0.3)
    }
}

// MARK: - Preview

#Preview("Secondary Button States") {
    VStack(spacing: Spacing.xl) {
        Text("Secondary Button")
            .displayStyle()

        Divider()

        // Default State
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Default")
                .captionStyle()
            SecondaryButton(title: "Cancel", action: {})
        }

        // Disabled State
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Disabled")
                .captionStyle()
            SecondaryButton(title: "Cancel", action: {}, isDisabled: true)
        }

        // Not Full Width
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Not Full Width")
                .captionStyle()
            SecondaryButton(title: "Learn More", action: {}, fullWidth: false)
        }

        // Button Group Example
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Button Group")
                .captionStyle()

            HStack(spacing: Spacing.md) {
                SecondaryButton(title: "Cancel", action: {})
                PrimaryButton(title: "Save", action: {})
            }
        }

        Spacer()
    }
    .screenPadding()
    .padding(.vertical, Spacing.xl)
    .background(Color.backgroundPrimary)
}

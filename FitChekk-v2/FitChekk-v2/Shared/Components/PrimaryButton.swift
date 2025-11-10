//
//  PrimaryButton.swift
//  FitChekk-v2
//
//  Primary CTA button with terracotta background
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var fullWidth: Bool = true

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            action()
        }) {
            HStack(spacing: Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                }

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: Spacing.minTouchTarget)
            .padding(.horizontal, fullWidth ? Spacing.md : Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.button)
                    .fill(buttonColor)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled || isLoading)
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
        .accessibilityHint(isLoading ? "Loading" : "")
        .accessibilityAddTraits(isDisabled ? [.isButton, .isNotEnabled] : .isButton)
    }

    private var buttonColor: Color {
        if isDisabled {
            return Color.textTertiary
        }
        return Color.terracotta
    }
}

// MARK: - Preview

#Preview("Primary Button States") {
    VStack(spacing: Spacing.xl) {
        Text("Primary Button")
            .displayStyle()

        Divider()

        // Default State
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Default")
                .captionStyle()
            PrimaryButton(title: "Continue", action: {})
        }

        // Loading State
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Loading")
                .captionStyle()
            PrimaryButton(title: "Saving", action: {}, isLoading: true)
        }

        // Disabled State
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Disabled")
                .captionStyle()
            PrimaryButton(title: "Continue", action: {}, isDisabled: true)
        }

        // Not Full Width
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Not Full Width")
                .captionStyle()
            PrimaryButton(title: "Get Started", action: {}, fullWidth: false)
        }

        Spacer()
    }
    .screenPadding()
    .padding(.vertical, Spacing.xl)
    .background(Color.backgroundPrimary)
}

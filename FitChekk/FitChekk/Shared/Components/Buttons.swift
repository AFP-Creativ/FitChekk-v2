//
//  Buttons.swift
//  FitChekk
//
//  Reusable button components following design system
//  Ported from mockup
//

import SwiftUI

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(.bodyLarge.weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(isDisabled ? Color.textTertiary : Color.accentPrimary)
            .cornerRadius(CornerRadius.md)
        }
        .buttonShadow()
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.accentPrimary)
                }
                Text(title)
                    .font(.bodyLarge.weight(.semibold))
            }
            .foregroundColor(.accentPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.backgroundElevated)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(Color.accentPrimary, lineWidth: 2)
            )
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Text Button

struct TextButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyMedium.weight(.medium))
                .foregroundColor(.accentPrimary)
        }
    }
}

// MARK: - Icon Button

struct IconButton: View {
    let icon: String
    let action: () -> Void
    var size: CGFloat = 24
    var color: Color = .textPrimary

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
        }
    }
}

// MARK: - Preview

#Preview("Primary Button") {
    VStack(spacing: Spacing.lg) {
        PrimaryButton(title: "Create Outfit") {}
        PrimaryButton(title: "Loading", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Secondary Button") {
    VStack(spacing: Spacing.lg) {
        SecondaryButton(title: "Cancel") {}
        SecondaryButton(title: "Loading", action: {}, isLoading: true)
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Text & Icon Buttons") {
    VStack(spacing: Spacing.lg) {
        TextButton(title: "Skip for now") {}

        HStack(spacing: Spacing.md) {
            IconButton(icon: "heart", action: {})
            IconButton(icon: "heart.fill", action: {}, color: .success)
            IconButton(icon: "xmark", action: {})
        }
    }
    .padding()
    .background(Color.backgroundPrimary)
}

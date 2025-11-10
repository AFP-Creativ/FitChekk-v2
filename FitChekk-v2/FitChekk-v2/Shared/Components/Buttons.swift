//
//  Buttons.swift
//  FitChekk-v2
//
//  Reusable button components
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
            .padding(.vertical, Spacing.md)
            .background(isDisabled ? Color.textTertiary : Color.accentPrimary)
            .cornerRadius(CornerRadius.md)
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyLarge)
                .foregroundColor(isDisabled ? .textTertiary : .accentPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.md)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Text Button

struct TextButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyLarge)
                .foregroundColor(.accentPrimary)
        }
    }
}

// MARK: - Icon Button

struct IconButton: View {
    let icon: String
    let action: () -> Void
    var size: CGFloat = 44
    var color: Color = .accentPrimary
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size / 2.5, weight: .semibold))
                .foregroundColor(color)
                .frame(width: size, height: size)
        }
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentPrimary)
                .clipShape(Circle())
                .buttonShadow()
        }
    }
}

// MARK: - Chip Button (for filters/tags)

struct ChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.labelLarge)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(isSelected ? Color.accentPrimary : Color.backgroundSecondary)
                .cornerRadius(CornerRadius.sm)
        }
    }
}

// MARK: - Previews

#Preview("Buttons") {
    VStack(spacing: Spacing.lg) {
        PrimaryButton(title: "Primary Button", action: { })
        PrimaryButton(title: "Loading", action: { }, isLoading: true)
        PrimaryButton(title: "Disabled", action: { }, isDisabled: true)
        
        SecondaryButton(title: "Secondary Button", action: { })
        
        TextButton(title: "Text Button", action: { })
        
        HStack {
            IconButton(icon: "heart", action: { })
            IconButton(icon: "star.fill", action: { })
            IconButton(icon: "plus", action: { })
        }
        
        HStack {
            ChipButton(title: "Tops", isSelected: true, action: { })
            ChipButton(title: "Bottoms", isSelected: false, action: { })
            ChipButton(title: "Shoes", isSelected: false, action: { })
        }
        
        FloatingActionButton(icon: "plus", action: { })
    }
    .padding()
}


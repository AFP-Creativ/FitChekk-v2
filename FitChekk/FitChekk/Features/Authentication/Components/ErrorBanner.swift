//
//  ErrorBanner.swift
//  FitChekk
//
//  Error message banner component
//

import SwiftUI

struct ErrorBanner: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(Color.error)
            
            Text(message)
                .font(.footnote)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .padding(Spacing.md)
        .background(Color.error.opacity(0.1))
        .cornerRadius(CornerRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.sm)
                .stroke(Color.error.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        ErrorBanner(message: "Email or password is incorrect") {}
        ErrorBanner(message: "Check your internet connection") {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

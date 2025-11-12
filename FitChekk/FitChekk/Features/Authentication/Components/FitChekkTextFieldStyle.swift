//
//  FitChekkTextFieldStyle.swift
//  FitChekk
//
//  Custom text field style for authentication forms
//

import SwiftUI

struct FitChekkTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.bodyLarge)
            .padding(Spacing.md)
            .background(Color.backgroundElevated)
            .cornerRadius(CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(Color.borderDefault, lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        TextField("Email", text: .constant(""))
            .textFieldStyle(FitChekkTextFieldStyle())

        SecureField("Password", text: .constant(""))
            .textFieldStyle(FitChekkTextFieldStyle())
    }
    .padding()
    .background(Color.backgroundPrimary)
}

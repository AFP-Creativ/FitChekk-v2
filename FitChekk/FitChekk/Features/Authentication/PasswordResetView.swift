//
//  PasswordResetView.swift
//  FitChekk
//
//  Password reset screen
//

import ComposableArchitecture
import SwiftUI

struct PasswordResetView: View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    @FocusState private var emailFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.xs) {
                    Text("Reset password")
                        .font(.displayMedium)
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("We'll send you a link to reset your password")
                        .font(.bodyLarge)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, Spacing.xxl)
                .padding(.horizontal, Spacing.md)
                
                // Email Field
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Email")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(Color.textSecondary)
                    
                    TextField("your@email.com", text: $store.email.sending(\.emailChanged))
                        .textFieldStyle(FitChekkTextFieldStyle())
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($emailFieldFocused)
                        .submitLabel(.go)
                        .onSubmit {
                            store.send(.resetPasswordTapped)
                        }
                    
                    if let error = store.emailError {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(Color.error)
                    }
                }
                .padding(.top, Spacing.md)
                
                // Error Message
                if let error = store.errorMessage {
                    ErrorBanner(message: error) {
                        store.send(.clearError)
                    }
                }
                
                // Reset Button
                PrimaryButton(
                    title: "Send Reset Link",
                    action: {
                        store.send(.resetPasswordTapped)
                    },
                    isLoading: store.isLoading,
                    isDisabled: !store.canResetPassword
                )
                .padding(.top, Spacing.md)
                
                // Back to Sign In
                Button {
                    store.send(.showSignIn)
                } label: {
                    Text("Back to **Sign In**")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.top, Spacing.lg)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .background(Color.backgroundPrimary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.send(.showSignIn)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.textPrimary)
                }
            }
        }
        .onAppear {
            emailFieldFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        PasswordResetView(
            store: Store(
                initialState: AuthenticationFeature.State(authFlow: .passwordReset)
            ) {
                AuthenticationFeature()
            } withDependencies: {
                $0.authService = MockAuthService()
            }
        )
    }
}

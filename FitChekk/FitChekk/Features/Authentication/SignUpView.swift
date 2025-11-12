//
//  SignUpView.swift
//  FitChekk
//
//  Sign up screen with email/password and social auth
//

import ComposableArchitecture
import SwiftUI

struct SignUpView: View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    @FocusState private var focusedField: Field?

    enum Field {
        case displayName, email, password, confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.xs) {
                    Text("Create your account")
                        .font(.displayMedium)
                        .foregroundStyle(Color.textPrimary)

                    Text("Let's get you styled")
                        .font(.bodyLarge)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.top, Spacing.xxl)

                // Form Fields
                VStack(spacing: Spacing.lg) {
                    // Display Name Field
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Name")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(Color.textSecondary)

                        TextField("What should we call you?", text: $store.displayName.sending(\.displayNameChanged))
                            .textFieldStyle(FitChekkTextFieldStyle())
                            .textContentType(.name)
                            .focused($focusedField, equals: .displayName)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .email
                            }

                        if let error = store.displayNameError {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(Color.error)
                        }
                    }

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
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }

                        if let error = store.emailError {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(Color.error)
                        }
                    }

                    // Password Field
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Password")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(Color.textSecondary)

                        SecureField("At least 8 characters", text: $store.password.sending(\.passwordChanged))
                            .textFieldStyle(FitChekkTextFieldStyle())
                            .textContentType(.newPassword)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .confirmPassword
                            }

                        if let error = store.passwordError {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(Color.error)
                        }
                    }

                    // Confirm Password Field
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Confirm Password")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(Color.textSecondary)

                        SecureField(
                            "Re-enter your password",
                            text: $store.confirmPassword.sending(\.confirmPasswordChanged)
                        )
                        .textFieldStyle(FitChekkTextFieldStyle())
                        .textContentType(.newPassword)
                        .focused($focusedField, equals: .confirmPassword)
                        .submitLabel(.go)
                        .onSubmit {
                            store.send(.signUpTapped)
                        }

                        if let error = store.confirmPasswordError {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(Color.error)
                        }
                    }
                }
                .padding(.top, Spacing.md)

                // Error Message
                if let error = store.errorMessage {
                    ErrorBanner(message: error) {
                        store.send(.clearError)
                    }
                }

                // Sign Up Button
                PrimaryButton(
                    title: "Create Account",
                    action: {
                        store.send(.signUpTapped)
                    },
                    isLoading: store.isLoading,
                    isDisabled: !store.canSignUp
                )
                .padding(.top, Spacing.md)

                // Divider
                HStack(spacing: Spacing.md) {
                    Rectangle()
                        .fill(Color.borderDefault)
                        .frame(height: 1)

                    Text("or")
                        .font(.footnote)
                        .foregroundStyle(Color.textTertiary)

                    Rectangle()
                        .fill(Color.borderDefault)
                        .frame(height: 1)
                }
                .padding(.vertical, Spacing.md)

                // Social Auth Buttons
                SocialAuthButtons(store: store)

                // Sign In Link
                Button {
                    store.send(.showSignIn)
                } label: {
                    Text("Already have an account? **Sign In**")
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
                    store.send(.showWelcome)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.textPrimary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView(
            store: Store(
                initialState: AuthenticationFeature.State(authFlow: .signUp)
            ) {
                AuthenticationFeature()
            } withDependencies: {
                $0.authService = MockAuthService()
            }
        )
    }
}

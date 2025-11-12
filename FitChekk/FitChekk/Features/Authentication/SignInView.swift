//
//  SignInView.swift
//  FitChekk
//
//  Sign in screen with email/password and social auth
//

import ComposableArchitecture
import SwiftUI

struct SignInView: View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.xs) {
                    Text("Welcome back")
                        .font(.displayMedium)
                        .foregroundStyle(Color.textPrimary)

                    Text("Sign in to continue")
                        .font(.bodyLarge)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.top, Spacing.xxl)

                // Form Fields
                VStack(spacing: Spacing.lg) {
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

                        SecureField("••••••••", text: $store.password.sending(\.passwordChanged))
                            .textFieldStyle(FitChekkTextFieldStyle())
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit {
                                store.send(.signInTapped)
                            }

                        if let error = store.passwordError {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(Color.error)
                        }
                    }

                    // Forgot Password
                    HStack {
                        Spacer()
                        Button {
                            store.send(.showPasswordReset)
                        } label: {
                            Text("Forgot password?")
                                .font(.footnote)
                                .foregroundStyle(Color.accentPrimary)
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

                // Sign In Button
                PrimaryButton(
                    title: "Sign In",
                    action: {
                        store.send(.signInTapped)
                    },
                    isLoading: store.isLoading,
                    isDisabled: !store.canSignIn
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

                // Sign Up Link
                Button {
                    store.send(.showSignUp)
                } label: {
                    Text("Don't have an account? **Sign Up**")
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
        SignInView(
            store: Store(
                initialState: AuthenticationFeature.State(authFlow: .signIn)
            ) {
                AuthenticationFeature()
            } withDependencies: {
                $0.authService = MockAuthService()
            }
        )
    }
}

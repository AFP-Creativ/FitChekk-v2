//
//  AuthenticationFeature.swift
//  FitChekk
//
//  Authentication feature handling sign in, sign up, and social auth
//

import ComposableArchitecture
import Foundation

// MARK: - Auth Flow Type
enum AuthFlow: Equatable {
    case welcome, signIn, signUp, passwordReset
}

@Reducer
struct AuthenticationFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        // Auth Flow Type
        var authFlow: AuthFlow = .welcome

        // Form Fields
        var email = ""
        var password = ""
        var confirmPassword = ""
        var displayName = ""

        // Loading States
        var isLoading = false
        var isAppleSignInLoading = false
        var isGoogleSignInLoading = false

        // Error Handling
        var errorMessage: String?

        // Validation
        var emailError: String?
        var passwordError: String?
        var confirmPasswordError: String?
        var displayNameError: String?

        // Computed Properties
        var isEmailValid: Bool {
            email.contains("@") && email.contains(".")
        }

        var isPasswordValid: Bool {
            password.count >= 8
        }

        var doPasswordsMatch: Bool {
            password == confirmPassword
        }

        var canSignIn: Bool {
            !email.isEmpty && !password.isEmpty && !isLoading
        }

        var canSignUp: Bool {
            !displayName.isEmpty &&
                !email.isEmpty &&
                !password.isEmpty &&
                !confirmPassword.isEmpty &&
                isEmailValid &&
                isPasswordValid &&
                doPasswordsMatch &&
                !isLoading
        }

        var canResetPassword: Bool {
            !email.isEmpty && isEmailValid && !isLoading
        }
    }

    // MARK: - Actions

    enum Action: Equatable {
        // Navigation
        case showWelcome
        case showSignIn
        case showSignUp
        case showPasswordReset
        case dismissAuth

        // Form Field Changes
        case emailChanged(String)
        case passwordChanged(String)
        case confirmPasswordChanged(String)
        case displayNameChanged(String)

        // Authentication Actions
        case signInTapped
        case signUpTapped
        case signInWithAppleTapped
        case signInWithGoogleTapped
        case resetPasswordTapped

        // Response Handling
        case authResponse(Result<User, AuthError>)
        case passwordResetSuccess
        case passwordResetFailure(AuthError)

        // Error Handling
        case clearError
        case setError(String)

        // Validation
        case validateEmail
        case validatePassword
        case validateConfirmPassword
        case validateDisplayName
        case clearValidationErrors
    }

    // MARK: - Dependencies

    @Dependency(\.authService) var authService
    @Dependency(\.dismiss) var dismiss

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // MARK: - Navigation
            case .showWelcome:
                state.authFlow = .welcome
                state.errorMessage = nil
                return .none

            case .showSignIn:
                state.authFlow = .signIn
                state.errorMessage = nil
                return .send(.clearValidationErrors)

            case .showSignUp:
                state.authFlow = .signUp
                state.errorMessage = nil
                return .send(.clearValidationErrors)

            case .showPasswordReset:
                state.authFlow = .passwordReset
                state.errorMessage = nil
                return .send(.clearValidationErrors)

            case .dismissAuth:
                return .run { _ in
                    await dismiss()
                }

            // MARK: - Form Field Changes
            case let .emailChanged(email):
                state.email = email
                state.emailError = nil
                state.errorMessage = nil
                return .none

            case let .passwordChanged(password):
                state.password = password
                state.passwordError = nil
                state.errorMessage = nil
                return .none

            case let .confirmPasswordChanged(confirmPassword):
                state.confirmPassword = confirmPassword
                state.confirmPasswordError = nil
                state.errorMessage = nil
                return .none

            case let .displayNameChanged(displayName):
                state.displayName = displayName
                state.displayNameError = nil
                state.errorMessage = nil
                return .none

            // MARK: - Authentication Actions
            case .signInTapped:
                guard state.canSignIn else { return .none }

                state.isLoading = true
                state.errorMessage = nil

                let email = state.email
                let password = state.password

                return .run { send in
                    let result = await Result {
                        try await authService.signInWithEmail(email: email, password: password)
                    }
                    await send(.authResponse(result.mapError { $0 as? AuthError ?? .unknown }))
                }

            case .signUpTapped:
                // Validate fields first
                if state.displayName.isEmpty {
                    state.errorMessage = "What should we call you?"
                    return .none
                }

                if !state.isEmailValid {
                    state.errorMessage = "Hmm, that email doesn't look right"
                    return .none
                }

                if !state.isPasswordValid {
                    state.errorMessage = "Password needs to be at least 8 characters"
                    return .none
                }

                if !state.doPasswordsMatch {
                    state.errorMessage = "Passwords don't match"
                    return .none
                }

                guard state.canSignUp else { return .none }

                state.isLoading = true
                state.errorMessage = nil

                let email = state.email
                let password = state.password
                let displayName = state.displayName

                return .run { send in
                    let result = await Result {
                        try await authService.signUpWithEmail(
                            email: email,
                            password: password,
                            displayName: displayName
                        )
                    }
                    await send(.authResponse(result.mapError { $0 as? AuthError ?? .unknown }))
                }

            case .signInWithAppleTapped:
                state.isAppleSignInLoading = true
                state.errorMessage = nil

                return .run { send in
                    let result = await Result {
                        try await authService.signInWithApple()
                    }
                    await send(.authResponse(result.mapError { $0 as? AuthError ?? .unknown }))
                }

            case .signInWithGoogleTapped:
                state.isGoogleSignInLoading = true
                state.errorMessage = nil

                return .run { send in
                    let result = await Result {
                        try await authService.signInWithGoogle()
                    }
                    await send(.authResponse(result.mapError { $0 as? AuthError ?? .unknown }))
                }

            case .resetPasswordTapped:
                guard state.canResetPassword else { return .none }

                state.isLoading = true
                state.errorMessage = nil

                let email = state.email

                return .run { send in
                    do {
                        try await authService.resetPassword(email: email)
                        await send(.passwordResetSuccess)
                    } catch let error as AuthError {
                        await send(.passwordResetFailure(error))
                    } catch {
                        await send(.passwordResetFailure(.unknown))
                    }
                }

            // MARK: - Response Handling
            case .authResponse(.success):
                state.isLoading = false
                state.isAppleSignInLoading = false
                state.isGoogleSignInLoading = false
                state.errorMessage = nil

                // Clear form fields
                state.email = ""
                state.password = ""
                state.confirmPassword = ""
                state.displayName = ""

                // Dismiss auth flow - parent will handle navigation
                return .run { send in
                    await send(.dismissAuth)
                }

            case let .authResponse(.failure(error)):
                state.isLoading = false
                state.isAppleSignInLoading = false
                state.isGoogleSignInLoading = false
                state.errorMessage = error.userMessage
                return .none

            case .passwordResetSuccess:
                state.isLoading = false
                state.errorMessage = nil
                // Show success message and navigate back to sign in
                return .concatenate(
                    .send(.setError("Check your email for a reset link!")),
                    .run { send in
                        try await Task.sleep(for: .seconds(2))
                        await send(.showSignIn)
                    }
                )

            case let .passwordResetFailure(error):
                state.isLoading = false
                state.errorMessage = error.userMessage
                return .none

            // MARK: - Error Handling
            case .clearError:
                state.errorMessage = nil
                return .none

            case let .setError(message):
                state.errorMessage = message
                return .none

            // MARK: - Validation
            case .validateEmail:
                if !state.email.isEmpty && !state.isEmailValid {
                    state.emailError = "Hmm, that email doesn't look right"
                } else {
                    state.emailError = nil
                }
                return .none

            case .validatePassword:
                if !state.password.isEmpty && !state.isPasswordValid {
                    state.passwordError = "Password needs to be at least 8 characters"
                } else {
                    state.passwordError = nil
                }
                return .none

            case .validateConfirmPassword:
                if !state.confirmPassword.isEmpty && !state.doPasswordsMatch {
                    state.confirmPasswordError = "Passwords don't match"
                } else {
                    state.confirmPasswordError = nil
                }
                return .none

            case .validateDisplayName:
                if state.displayName.isEmpty {
                    state.displayNameError = "What should we call you?"
                } else {
                    state.displayNameError = nil
                }
                return .none

            case .clearValidationErrors:
                state.emailError = nil
                state.passwordError = nil
                state.confirmPasswordError = nil
                state.displayNameError = nil
                return .none
            }
        }
    }
}

// MARK: - AuthError Extension

extension AuthError {
    var userMessage: String {
        switch self {
        case .invalidCredentials:
            return "Email or password is incorrect"
        case .userNotFound:
            return "No account found with that email"
        case .emailAlreadyInUse:
            return "An account with this email already exists"
        case .weakPassword:
            return "Password needs to be stronger"
        case .invalidEmail:
            return "Hmm, that email doesn't look right"
        case .networkError:
            return "Check your internet connection"
        case .cancelled:
            return "Sign in was cancelled"
        case .unknown:
            return "Something went wrong. Please try again"
        case .notImplemented:
            return "This feature is coming soon"
        case .sessionExpired:
            return "Your session expired. Please sign in again"
        }
    }
}

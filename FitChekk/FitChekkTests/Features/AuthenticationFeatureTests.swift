//
//  AuthenticationFeatureTests.swift
//  FitChekkTests
//
//  Comprehensive tests for AuthenticationFeature using TCA TestStore
//

import ComposableArchitecture
import XCTest
@testable import FitChekk

@MainActor
final class AuthenticationFeatureTests: XCTestCase {
    
    // MARK: - Navigation Tests
    
    func testShowSignIn() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.showSignIn) {
            $0.authFlow = .signIn
            $0.errorMessage = nil
        }
        
        await store.receive(.clearValidationErrors) {
            $0.emailError = nil
            $0.passwordError = nil
            $0.confirmPasswordError = nil
            $0.displayNameError = nil
        }
    }
    
    func testShowSignUp() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.showSignUp) {
            $0.authFlow = .signUp
            $0.errorMessage = nil
        }
        
        await store.receive(.clearValidationErrors) {
            $0.emailError = nil
            $0.passwordError = nil
            $0.confirmPasswordError = nil
            $0.displayNameError = nil
        }
    }
    
    func testShowPasswordReset() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.showPasswordReset) {
            $0.authFlow = .passwordReset
            $0.errorMessage = nil
        }
        
        await store.receive(.clearValidationErrors) {
            $0.emailError = nil
            $0.passwordError = nil
            $0.confirmPasswordError = nil
            $0.displayNameError = nil
        }
    }
    
    // MARK: - Form Field Tests
    
    func testEmailChanged() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.emailChanged("test@example.com")) {
            $0.email = "test@example.com"
            $0.emailError = nil
            $0.errorMessage = nil
        }
    }
    
    func testPasswordChanged() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.passwordChanged("password123")) {
            $0.password = "password123"
            $0.passwordError = nil
            $0.errorMessage = nil
        }
    }
    
    func testConfirmPasswordChanged() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.confirmPasswordChanged("password123")) {
            $0.confirmPassword = "password123"
            $0.confirmPasswordError = nil
            $0.errorMessage = nil
        }
    }
    
    func testDisplayNameChanged() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.displayNameChanged("Test User")) {
            $0.displayName = "Test User"
            $0.displayNameError = nil
            $0.errorMessage = nil
        }
    }
    
    // MARK: - Sign In Tests
    
    func testSignInSuccess() async {
        let mockUser = User(
            id: UUID(),
            email: "test@example.com",
            displayName: "Test User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        
        let mockService = MockAuthService()
        mockService.mockUser = mockUser
        
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "test@example.com",
                password: "password123"
            )
        ) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signInTapped) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.success(mockUser))) {
            $0.isLoading = false
            $0.errorMessage = nil
            $0.email = ""
            $0.password = ""
            $0.confirmPassword = ""
            $0.displayName = ""
        }
        
        await store.receive(.dismissAuth)
    }
    
    func testSignInInvalidCredentials() async {
        let mockService = MockAuthService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidCredentials
        
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "test@example.com",
                password: "wrongpassword"
            )
        ) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signInTapped) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.failure(.invalidCredentials))) {
            $0.isLoading = false
            $0.errorMessage = "Email or password is incorrect"
        }
    }
    
    func testSignInEmptyFields() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        // Should not trigger any actions because canSignIn is false
        await store.send(.signInTapped)
    }
    
    // MARK: - Sign Up Tests
    
    func testSignUpSuccess() async {
        let mockUser = User(
            id: UUID(),
            email: "new@example.com",
            displayName: "New User",
            subscriptionTier: .free,
            subscriptionStatus: .trial,
            trialEndsAt: Date().addingTimeInterval(7 * 24 * 60 * 60)
        )
        
        let mockService = MockAuthService()
        mockService.mockUser = mockUser
        
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "new@example.com",
                password: "password123",
                confirmPassword: "password123",
                displayName: "New User"
            )
        ) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signUpTapped) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.success(mockUser))) {
            $0.isLoading = false
            $0.errorMessage = nil
            $0.email = ""
            $0.password = ""
            $0.confirmPassword = ""
            $0.displayName = ""
        }
        
        await store.receive(.dismissAuth)
    }
    
    func testSignUpInvalidEmail() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "invalid-email",
                password: "password123",
                confirmPassword: "password123",
                displayName: "New User"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.signUpTapped) {
            $0.errorMessage = "Hmm, that email doesn't look right"
        }
    }
    
    func testSignUpWeakPassword() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "new@example.com",
                password: "weak",
                confirmPassword: "weak",
                displayName: "New User"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.signUpTapped) {
            $0.errorMessage = "Password needs to be at least 8 characters"
        }
    }
    
    func testSignUpPasswordMismatch() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "new@example.com",
                password: "password123",
                confirmPassword: "different123",
                displayName: "New User"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.signUpTapped) {
            $0.errorMessage = "Passwords don't match"
        }
    }
    
    func testSignUpMissingDisplayName() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "new@example.com",
                password: "password123",
                confirmPassword: "password123",
                displayName: ""
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.signUpTapped) {
            $0.errorMessage = "What should we call you?"
        }
    }
    
    func testSignUpEmailAlreadyInUse() async {
        let mockService = MockAuthService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .emailAlreadyInUse
        
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "existing@example.com",
                password: "password123",
                confirmPassword: "password123",
                displayName: "New User"
            )
        ) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signUpTapped) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.failure(.emailAlreadyInUse))) {
            $0.isLoading = false
            $0.errorMessage = "An account with this email already exists"
        }
    }
    
    // MARK: - Social Auth Tests
    
    func testAppleSignInSuccess() async {
        let mockUser = User(
            id: UUID(),
            email: "apple@example.com",
            displayName: "Apple User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        
        let mockService = MockAuthService()
        mockService.mockUser = mockUser
        
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signInWithAppleTapped) {
            $0.isAppleSignInLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.success(mockUser))) {
            $0.isAppleSignInLoading = false
            $0.errorMessage = nil
            $0.email = ""
            $0.password = ""
            $0.confirmPassword = ""
            $0.displayName = ""
        }
        
        await store.receive(.dismissAuth)
    }
    
    func testAppleSignInCancelled() async {
        let mockService = MockAuthService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .cancelled
        
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signInWithAppleTapped) {
            $0.isAppleSignInLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.failure(.cancelled))) {
            $0.isAppleSignInLoading = false
            $0.errorMessage = "Something went wrong. Please try again"
        }
    }
    
    func testGoogleSignInSuccess() async {
        let mockUser = User(
            id: UUID(),
            email: "google@example.com",
            displayName: "Google User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        
        let mockService = MockAuthService()
        mockService.mockUser = mockUser
        
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.signInWithGoogleTapped) {
            $0.isGoogleSignInLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.authResponse(.success(mockUser))) {
            $0.isGoogleSignInLoading = false
            $0.errorMessage = nil
            $0.email = ""
            $0.password = ""
            $0.confirmPassword = ""
            $0.displayName = ""
        }
        
        await store.receive(.dismissAuth)
    }
    
    // MARK: - Password Reset Tests
    
    func testPasswordResetSuccess() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "test@example.com"
            )
        ) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
        }
        
        await store.send(.resetPasswordTapped) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.passwordResetResponse(.success(()))) {
            $0.isLoading = false
            $0.errorMessage = nil
        }
        
        await store.receive(.setError("Check your email for a reset link!")) {
            $0.errorMessage = "Check your email for a reset link!"
        }
        
        await store.receive(.showSignIn, timeout: .seconds(3)) {
            $0.authFlow = .signIn
            $0.errorMessage = nil
        }
        
        await store.receive(.clearValidationErrors) {
            $0.emailError = nil
            $0.passwordError = nil
            $0.confirmPasswordError = nil
            $0.displayNameError = nil
        }
    }
    
    func testPasswordResetInvalidEmail() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "invalid-email"
            )
        ) {
            AuthenticationFeature()
        }
        
        // Should not trigger action because canResetPassword is false
        await store.send(.resetPasswordTapped)
    }
    
    func testPasswordResetNetworkError() async {
        let mockService = MockAuthService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError
        
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "test@example.com"
            )
        ) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = mockService
        }
        
        await store.send(.resetPasswordTapped) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.passwordResetResponse(.failure(.networkError))) {
            $0.isLoading = false
            $0.errorMessage = "Check your internet connection"
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testClearError() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                errorMessage: "Some error"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.clearError) {
            $0.errorMessage = nil
        }
    }
    
    func testSetError() async {
        let store = TestStore(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        }
        
        await store.send(.setError("Custom error message")) {
            $0.errorMessage = "Custom error message"
        }
    }
    
    // MARK: - Validation Tests
    
    func testValidateEmailValid() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "valid@example.com"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validateEmail) {
            $0.emailError = nil
        }
    }
    
    func testValidateEmailInvalid() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                email: "invalid-email"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validateEmail) {
            $0.emailError = "Hmm, that email doesn't look right"
        }
    }
    
    func testValidatePasswordValid() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                password: "password123"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validatePassword) {
            $0.passwordError = nil
        }
    }
    
    func testValidatePasswordWeak() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                password: "weak"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validatePassword) {
            $0.passwordError = "Password needs to be at least 8 characters"
        }
    }
    
    func testValidateConfirmPasswordMatch() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                password: "password123",
                confirmPassword: "password123"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validateConfirmPassword) {
            $0.confirmPasswordError = nil
        }
    }
    
    func testValidateConfirmPasswordMismatch() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                password: "password123",
                confirmPassword: "different123"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validateConfirmPassword) {
            $0.confirmPasswordError = "Passwords don't match"
        }
    }
    
    func testValidateDisplayNameEmpty() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                displayName: ""
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.validateDisplayName) {
            $0.displayNameError = "What should we call you?"
        }
    }
    
    func testClearValidationErrors() async {
        let store = TestStore(
            initialState: AuthenticationFeature.State(
                emailError: "Email error",
                passwordError: "Password error",
                confirmPasswordError: "Confirm password error",
                displayNameError: "Display name error"
            )
        ) {
            AuthenticationFeature()
        }
        
        await store.send(.clearValidationErrors) {
            $0.emailError = nil
            $0.passwordError = nil
            $0.confirmPasswordError = nil
            $0.displayNameError = nil
        }
    }
    
    // MARK: - Computed Properties Tests
    
    func testIsEmailValid() {
        var state = AuthenticationFeature.State()
        
        state.email = "valid@example.com"
        XCTAssertTrue(state.isEmailValid)
        
        state.email = "invalid"
        XCTAssertFalse(state.isEmailValid)
        
        state.email = "no-at-symbol.com"
        XCTAssertFalse(state.isEmailValid)
    }
    
    func testIsPasswordValid() {
        var state = AuthenticationFeature.State()
        
        state.password = "password123"
        XCTAssertTrue(state.isPasswordValid)
        
        state.password = "short"
        XCTAssertFalse(state.isPasswordValid)
        
        state.password = ""
        XCTAssertFalse(state.isPasswordValid)
    }
    
    func testDoPasswordsMatch() {
        var state = AuthenticationFeature.State()
        
        state.password = "password123"
        state.confirmPassword = "password123"
        XCTAssertTrue(state.doPasswordsMatch)
        
        state.confirmPassword = "different"
        XCTAssertFalse(state.doPasswordsMatch)
    }
    
    func testCanSignIn() {
        var state = AuthenticationFeature.State()
        
        // Empty fields
        XCTAssertFalse(state.canSignIn)
        
        // Valid fields
        state.email = "test@example.com"
        state.password = "password123"
        XCTAssertTrue(state.canSignIn)
        
        // Loading
        state.isLoading = true
        XCTAssertFalse(state.canSignIn)
    }
    
    func testCanSignUp() {
        var state = AuthenticationFeature.State()
        
        // Empty fields
        XCTAssertFalse(state.canSignUp)
        
        // Valid fields
        state.displayName = "Test User"
        state.email = "test@example.com"
        state.password = "password123"
        state.confirmPassword = "password123"
        XCTAssertTrue(state.canSignUp)
        
        // Invalid email
        state.email = "invalid"
        XCTAssertFalse(state.canSignUp)
        
        // Weak password
        state.email = "test@example.com"
        state.password = "weak"
        state.confirmPassword = "weak"
        XCTAssertFalse(state.canSignUp)
        
        // Password mismatch
        state.password = "password123"
        state.confirmPassword = "different"
        XCTAssertFalse(state.canSignUp)
    }
    
    func testCanResetPassword() {
        var state = AuthenticationFeature.State()
        
        // Empty email
        XCTAssertFalse(state.canResetPassword)
        
        // Valid email
        state.email = "test@example.com"
        XCTAssertTrue(state.canResetPassword)
        
        // Invalid email
        state.email = "invalid"
        XCTAssertFalse(state.canResetPassword)
        
        // Loading
        state.email = "test@example.com"
        state.isLoading = true
        XCTAssertFalse(state.canResetPassword)
    }
}


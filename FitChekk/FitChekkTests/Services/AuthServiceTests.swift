//
//  AuthServiceTests.swift
//  FitChekkTests
//
//  Tests demonstrating MockAuthService usage patterns and error handling
//

import XCTest
@testable import FitChekk

@MainActor
final class AuthServiceTests: XCTestCase {
    
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
    }
    
    override func tearDown() {
        mockAuthService = nil
        super.tearDown()
    }
    
    // MARK: - Get Current User Tests
    
    func testGetCurrentUserWhenNotAuthenticated() async throws {
        // Given: No user is set
        mockAuthService.mockUser = nil
        
        // When: Getting current user
        let user = try await mockAuthService.getCurrentUser()
        
        // Then: Should return nil
        XCTAssertNil(user)
    }
    
    func testGetCurrentUserWhenAuthenticated() async throws {
        // Given: A user is set
        let testUser = User.sampleFreeUser()
        mockAuthService.mockUser = testUser
        
        // When: Getting current user
        let user = try await mockAuthService.getCurrentUser()
        
        // Then: Should return the user
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, testUser.id)
        XCTAssertEqual(user?.email, testUser.email)
    }
    
    func testGetCurrentUserThrowsError() async {
        // Given: Mock is configured to throw error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .networkError
        
        // When/Then: Should throw the configured error
        do {
            _ = try await mockAuthService.getCurrentUser()
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Sign In With Email Tests
    
    func testSignInWithEmailSuccess() async throws {
        // Given: Valid credentials
        let email = "test@example.com"
        let password = "password123"
        
        // When: Signing in
        let user = try await mockAuthService.signInWithEmail(email: email, password: password)
        
        // Then: Should return user with correct email
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.displayName, "Test User")
        XCTAssertEqual(user.subscriptionTierEnum, .free)
        
        // And: Mock user should be set
        XCTAssertNotNil(mockAuthService.mockUser)
        XCTAssertEqual(mockAuthService.mockUser?.email, email)
    }
    
    func testSignInWithEmailInvalidCredentials() async {
        // Given: Mock is configured to throw invalid credentials error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .invalidCredentials
        
        // When/Then: Should throw invalid credentials error
        do {
            _ = try await mockAuthService.signInWithEmail(
                email: "wrong@example.com",
                password: "wrongpassword"
            )
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidCredentials)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Sign Up With Email Tests
    
    func testSignUpWithEmailSuccess() async throws {
        // Given: Valid signup details
        let email = "newuser@example.com"
        let password = "securePassword123"
        let displayName = "New User"
        
        // When: Signing up
        let user = try await mockAuthService.signUpWithEmail(
            email: email,
            password: password,
            displayName: displayName
        )
        
        // Then: Should return user with correct details
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.displayName, displayName)
        XCTAssertEqual(user.subscriptionTierEnum, .free)
        XCTAssertEqual(user.subscriptionStatusEnum, .trial)
        XCTAssertNotNil(user.trialEndsAt)
        
        // And: Mock user should be set
        XCTAssertNotNil(mockAuthService.mockUser)
    }
    
    func testSignUpWithEmailAlreadyExists() async {
        // Given: Mock is configured to throw email already in use error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .emailAlreadyInUse
        
        // When/Then: Should throw email already in use error
        do {
            _ = try await mockAuthService.signUpWithEmail(
                email: "existing@example.com",
                password: "password123",
                displayName: "User"
            )
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .emailAlreadyInUse)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    func testSignUpWithWeakPassword() async {
        // Given: Mock is configured to throw weak password error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .weakPassword
        
        // When/Then: Should throw weak password error
        do {
            _ = try await mockAuthService.signUpWithEmail(
                email: "user@example.com",
                password: "123",
                displayName: "User"
            )
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .weakPassword)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Sign In With Apple Tests
    
    func testSignInWithAppleSuccess() async throws {
        // When: Signing in with Apple
        let user = try await mockAuthService.signInWithApple()
        
        // Then: Should return user with Apple email
        XCTAssertEqual(user.email, "apple@test.com")
        XCTAssertEqual(user.displayName, "Apple User")
        XCTAssertNotNil(mockAuthService.mockUser)
    }
    
    func testSignInWithAppleCancelled() async {
        // Given: Mock is configured to throw cancelled error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .cancelled
        
        // When/Then: Should throw cancelled error
        do {
            _ = try await mockAuthService.signInWithApple()
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .cancelled)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Sign In With Google Tests
    
    func testSignInWithGoogleSuccess() async throws {
        // When: Signing in with Google
        let user = try await mockAuthService.signInWithGoogle()
        
        // Then: Should return user with Google email
        XCTAssertEqual(user.email, "google@test.com")
        XCTAssertEqual(user.displayName, "Google User")
        XCTAssertNotNil(mockAuthService.mockUser)
    }
    
    func testSignInWithGoogleCancelled() async {
        // Given: Mock is configured to throw cancelled error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .cancelled
        
        // When/Then: Should throw cancelled error
        do {
            _ = try await mockAuthService.signInWithGoogle()
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .cancelled)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Sign Out Tests
    
    func testSignOutSuccess() async throws {
        // Given: A user is authenticated
        mockAuthService.mockUser = User.sampleFreeUser()
        XCTAssertNotNil(mockAuthService.mockUser)
        
        // When: Signing out
        try await mockAuthService.signOut()
        
        // Then: Mock user should be cleared
        XCTAssertNil(mockAuthService.mockUser)
    }
    
    func testSignOutThrowsError() async {
        // Given: Mock is configured to throw error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .networkError
        
        // When/Then: Should throw the configured error
        do {
            try await mockAuthService.signOut()
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Reset Password Tests
    
    func testResetPasswordSuccess() async throws {
        // Given: Valid email
        let email = "user@example.com"
        
        // When: Resetting password (should not throw)
        try await mockAuthService.resetPassword(email: email)
        
        // Then: No error should be thrown
        // Mock implementation is a no-op
    }
    
    func testResetPasswordUserNotFound() async {
        // Given: Mock is configured to throw user not found error
        mockAuthService.shouldThrowError = true
        mockAuthService.errorToThrow = .userNotFound
        
        // When/Then: Should throw user not found error
        do {
            try await mockAuthService.resetPassword(email: "nonexistent@example.com")
            XCTFail("Expected error to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .userNotFound)
        } catch {
            XCTFail("Expected AuthError, got \(error)")
        }
    }
    
    // MARK: - Error Handling Pattern Tests
    
    func testMultipleErrorTypes() async {
        let errors: [AuthError] = [
            .invalidCredentials,
            .userNotFound,
            .emailAlreadyInUse,
            .weakPassword,
            .networkError,
            .cancelled,
            .notImplemented
        ]
        
        for error in errors {
            mockAuthService.shouldThrowError = true
            mockAuthService.errorToThrow = error
            
            do {
                _ = try await mockAuthService.getCurrentUser()
                XCTFail("Expected error \(error) to be thrown")
            } catch let thrownError as AuthError {
                XCTAssertEqual(thrownError, error)
            } catch {
                XCTFail("Expected AuthError, got \(error)")
            }
        }
    }
    
    // MARK: - Async Operation Timing Tests
    
    func testAuthOperationsHaveReasonableDelay() async throws {
        // Measure time for auth operations
        let startTime = Date()
        
        _ = try await mockAuthService.signInWithEmail(
            email: "test@example.com",
            password: "password"
        )
        
        let duration = Date().timeIntervalSince(startTime)
        
        // Should take between 0.1 and 0.5 seconds
        XCTAssertGreaterThan(duration, 0.1)
        XCTAssertLessThan(duration, 0.5)
    }
}


import Foundation
import Dependencies

// MARK: - Protocol

/// Service for handling user authentication operations
protocol AuthService: Sendable {
    /// Get the currently authenticated user
    func getCurrentUser() async throws -> User?
    
    /// Sign in with email and password
    func signInWithEmail(email: String, password: String) async throws -> User
    
    /// Sign up with email, password, and display name
    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User
    
    /// Sign in with Apple
    func signInWithApple() async throws -> User
    
    /// Sign in with Google
    func signInWithGoogle() async throws -> User
    
    /// Sign out the current user
    func signOut() async throws
    
    /// Send password reset email
    func resetPassword(email: String) async throws
}

// MARK: - Dependency Key

private enum AuthServiceKey: DependencyKey {
    static let liveValue: AuthService = LiveAuthService()
    static let testValue: AuthService = MockAuthService()
}

extension DependencyValues {
    var authService: AuthService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveAuthService: AuthService {
    func getCurrentUser() async throws -> User? {
        // TODO: Implement with Supabase Auth in Phase 2
        nil
    }
    
    func signInWithEmail(email: String, password: String) async throws -> User {
        // TODO: Implement Supabase email auth
        throw AuthError.notImplemented
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User {
        // TODO: Implement Supabase email signup
        throw AuthError.notImplemented
    }
    
    func signInWithApple() async throws -> User {
        // TODO: Implement Sign in with Apple
        throw AuthError.notImplemented
    }
    
    func signInWithGoogle() async throws -> User {
        // TODO: Implement Google Sign-In
        throw AuthError.notImplemented
    }
    
    func signOut() async throws {
        // TODO: Implement sign out
    }
    
    func resetPassword(email: String) async throws {
        // TODO: Implement password reset
    }
}

// MARK: - Mock Implementation

final class MockAuthService: AuthService, @unchecked Sendable {
    var mockUser: User?
    var shouldThrowError = false
    var errorToThrow: AuthError = .invalidCredentials
    
    func getCurrentUser() async throws -> User? {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        return mockUser
    }
    
    func signInWithEmail(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }
        
        let user = User(
            id: UUID(),
            email: email,
            displayName: "Test User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        mockUser = user
        return user
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }
        
        let user = User(
            id: UUID(),
            email: email,
            displayName: displayName,
            subscriptionTier: .free,
            subscriptionStatus: .trial,
            trialEndsAt: Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days
        )
        mockUser = user
        return user
    }
    
    func signInWithApple() async throws -> User {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }
        
        let user = User(
            id: UUID(),
            email: "apple@test.com",
            displayName: "Apple User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        mockUser = user
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }
        
        let user = User(
            id: UUID(),
            email: "google@test.com",
            displayName: "Google User",
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
        mockUser = user
        return user
    }
    
    func signOut() async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        mockUser = nil
    }
    
    func resetPassword(email: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }
        // Mock implementation - no-op
    }
}

// MARK: - Errors

enum AuthError: Error, Equatable {
    case notImplemented
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case cancelled
}

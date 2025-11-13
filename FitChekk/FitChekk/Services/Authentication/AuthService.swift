import Foundation
import Dependencies
import Supabase
import SwiftData
import AuthenticationServices

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
    static let previewValue: AuthService = MockAuthService()
}

extension DependencyValues {
    var authService: AuthService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation

final class LiveAuthService: AuthService, @unchecked Sendable {
    private let client: SupabaseClient
    private var modelContext: ModelContext?

    init() {
        // Read Supabase configuration from Info.plist (populated from xcconfig)
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              let url = URL(string: supabaseURL) else {
            fatalError("Supabase configuration missing. Check Development.xcconfig and Info.plist.")
        }

        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
    }

    /// Configure ModelContext for SwiftData operations
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getCurrentUser() async throws -> User? {
        do {
            // Check if we have an active session
            let session = try await client.auth.session

            // Fetch user data from Supabase
            let authUser = session.user

            // Try to fetch from database
            let response: [UserDTO] = try await client
                .from("users")
                .select()
                .eq("id", value: authUser.id.uuidString)
                .execute()
                .value

            guard let userDTO = response.first else {
                // User exists in auth but not in database - create profile
                return try await createUserProfile(
                    authUserId: authUser.id,
                    email: authUser.email ?? "",
                    displayName: authUser.userMetadata["display_name"]?.stringValue
                )
            }

            // Convert DTO to User model
            let user = userDTO.toUser()

            // Save to SwiftData if available
            if let context = modelContext {
                try saveUserToSwiftData(user, context: context)
            }

            return user
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.networkError
        }
    }

    func signInWithEmail(email: String, password: String) async throws -> User {
        do {
            let session = try await client.auth.signIn(
                email: email,
                password: password
            )

            let authUser = session.user

            // Fetch user profile from database
            let response: [UserDTO] = try await client
                .from("users")
                .select()
                .eq("id", value: authUser.id.uuidString)
                .execute()
                .value

            guard let userDTO = response.first else {
                throw AuthError.userNotFound
            }

            let user = userDTO.toUser()

            // Save to SwiftData
            if let context = modelContext {
                try saveUserToSwiftData(user, context: context)
            }

            return user
        } catch let error as AuthError {
            throw error
        } catch {
            // Map Supabase errors to AuthError
            if let errorDescription = (error as NSError).userInfo["message"] as? String {
                if errorDescription.contains("Invalid") {
                    throw AuthError.invalidCredentials
                }
            }
            throw AuthError.networkError
        }
    }

    func signUpWithEmail(email: String, password: String, displayName: String) async throws -> User {
        do {
            // Sign up with Supabase Auth
            let session = try await client.auth.signUp(
                email: email,
                password: password,
                data: ["display_name": .string(displayName)]
            )

            let authUser = session.user

            // Create user profile in database
            let user = try await createUserProfile(
                authUserId: authUser.id,
                email: email,
                displayName: displayName
            )

            return user
        } catch let error as AuthError {
            throw error
        } catch {
            // Map Supabase errors to AuthError
            if let errorDescription = (error as NSError).userInfo["message"] as? String {
                if errorDescription.contains("already") {
                    throw AuthError.emailAlreadyInUse
                } else if errorDescription.contains("password") {
                    throw AuthError.weakPassword
                }
            }
            throw AuthError.networkError
        }
    }

    func signInWithApple() async throws -> User {
        do {
            // Create Apple Sign-In manager on main actor
            let manager = await MainActor.run { AppleSignInManager() }

            // Get Apple credential
            let credential = try await manager.signIn()

            // Extract identity token
            guard let identityTokenData = credential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8) else {
                throw AuthError.unknown
            }

            // Sign in with Supabase using Apple token
            let session = try await client.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple,
                    idToken: identityToken
                )
            )

            let authUser = session.user

            // Check if user profile exists
            let response: [UserDTO] = try await client
                .from("users")
                .select()
                .eq("id", value: authUser.id.uuidString)
                .execute()
                .value

            if let userDTO = response.first {
                // Existing user
                let user = userDTO.toUser()

                // Save to SwiftData
                if let context = modelContext {
                    try saveUserToSwiftData(user, context: context)
                }

                return user
            } else {
                // New user - create profile
                let displayName: String? = {
                    if let givenName = credential.fullName?.givenName,
                       let familyName = credential.fullName?.familyName {
                        return "\(givenName) \(familyName)"
                    } else if let givenName = credential.fullName?.givenName {
                        return givenName
                    }
                    return nil
                }()

                return try await createUserProfile(
                    authUserId: authUser.id,
                    email: authUser.email ?? credential.email ?? "",
                    displayName: displayName
                )
            }
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.unknown
        }
    }

    func signInWithGoogle() async throws -> User {
        // TODO: Implement Google Sign-In when GoogleSignIn SDK is added
        // For now, this is not implemented to avoid build errors
        // To add Google Sign-In:
        // 1. Add GoogleSignIn package via SPM: https://github.com/google/GoogleSignIn-iOS
        // 2. Configure Google OAuth client ID in Development.xcconfig
        // 3. Add URL scheme to Info.plist
        // 4. Uncomment GoogleSignInManager.swift
        // 5. Implement the full flow here
        throw AuthError.notImplemented
    }

    func signOut() async throws {
        do {
            try await client.auth.signOut()

            // Clear SwiftData user
            if let context = modelContext {
                let descriptor = FetchDescriptor<User>()
                let users = try context.fetch(descriptor)
                for user in users {
                    context.delete(user)
                }
                try context.save()
            }
        } catch {
            throw AuthError.networkError
        }
    }

    func resetPassword(email: String) async throws {
        do {
            try await client.auth.resetPasswordForEmail(email)
        } catch {
            throw AuthError.networkError
        }
    }

    // MARK: - Helper Methods

    private func createUserProfile(
        authUserId: UUID,
        email: String,
        displayName: String?
    ) async throws -> User {
        // Create user record in database
        let userDTO = UserDTO(
            id: authUserId,
            createdAt: Date(),
            updatedAt: Date(),
            email: email,
            displayName: displayName,
            subscriptionTier: "free",
            subscriptionStatus: "trial",
            trialEndsAt: Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days
        )

        let _: UserDTO = try await client
            .from("users")
            .insert(userDTO)
            .select()
            .single()
            .execute()
            .value

        // Create default preferences
        struct PreferencesInsert: Encodable {
            let user_id: UUID
            let style_preferences: [String]
            let favorite_colors: [String]
            let preferred_occasions: [String]
        }
        
        let preferencesData = PreferencesInsert(
            user_id: authUserId,
            style_preferences: [],
            favorite_colors: [],
            preferred_occasions: []
        )

        try await client
            .from("user_preferences")
            .insert(preferencesData)
            .execute()

        let user = userDTO.toUser()

        // Save to SwiftData
        if let context = modelContext {
            try saveUserToSwiftData(user, context: context)
        }

        return user
    }

    private func saveUserToSwiftData(_ user: User, context: ModelContext) throws {
        // Check if user already exists
        let userId = user.id
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { existingUser in
                existingUser.id == userId
            }
        )
        let existingUsers = try context.fetch(descriptor)

        // Remove existing users
        for existingUser in existingUsers {
            context.delete(existingUser)
        }

        // Insert new user
        context.insert(user)
        try context.save()
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
    case invalidEmail
    case networkError
    case sessionExpired
    case cancelled
    case unknown
}

import Foundation
import Dependencies
import UIKit
import Supabase

// MARK: - Protocol

/// Service for image storage and management in Supabase Storage
protocol StorageService: Sendable {
    /// Upload a full-size image for a wardrobe item
    func uploadImage(_ image: Data, userId: UUID, itemId: UUID) async throws -> String

    /// Upload a thumbnail image for a wardrobe item
    func uploadThumbnail(_ image: Data, userId: UUID, itemId: UUID) async throws -> String

    /// Download an image from storage
    func downloadImage(url: String) async throws -> Data

    /// Delete an image from storage
    func deleteImage(url: String) async throws

    /// Get public URL for an image path
    func getPublicURL(path: String) -> String
}

// MARK: - Dependency Key

private enum StorageServiceKey: DependencyKey {
    static let liveValue: StorageService = LiveStorageService()
    static let testValue: StorageService = MockStorageService()
}

extension DependencyValues {
    var storageService: StorageService {
        get { self[StorageServiceKey.self] }
        set { self[StorageServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation

final class LiveStorageService: StorageService, @unchecked Sendable {
    private let client: SupabaseClient
    private let bucketName = "wardrobe-images"

    init() {
        // Read Supabase configuration from Info.plist
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

    func uploadImage(_ image: Data, userId: UUID, itemId: UUID) async throws -> String {
        // Validate image size (max 10MB)
        guard image.count <= 10_000_000 else {
            throw StorageError.fileTooLarge
        }

        do {
            // Path format: {userId}/{itemId}.jpg
            let path = "\(userId.uuidString)/\(itemId.uuidString).jpg"

            // Upload to Supabase Storage
            try await client.storage
                .from(bucketName)
                .upload(
                    path,
                    data: image,
                    options: FileOptions(
                        contentType: "image/jpeg",
                        upsert: true
                    )
                )

            return path
        } catch {
            throw mapStorageError(error)
        }
    }

    func uploadThumbnail(_ image: Data, userId: UUID, itemId: UUID) async throws -> String {
        // Validate image size (max 2MB for thumbnails)
        guard image.count <= 2_000_000 else {
            throw StorageError.fileTooLarge
        }

        do {
            // Path format: {userId}/thumbnails/{itemId}.jpg
            let path = "\(userId.uuidString)/thumbnails/\(itemId.uuidString).jpg"

            // Upload to Supabase Storage
            try await client.storage
                .from(bucketName)
                .upload(
                    path,
                    data: image,
                    options: FileOptions(
                        contentType: "image/jpeg",
                        upsert: true
                    )
                )

            return path
        } catch {
            throw mapStorageError(error)
        }
    }

    func downloadImage(url: String) async throws -> Data {
        do {
            // Extract path from URL
            let path = extractPathFromURL(url)

            // Download from Supabase Storage
            let data = try await client.storage
                .from(bucketName)
                .download(path: path)

            return data
        } catch {
            throw mapStorageError(error)
        }
    }

    func deleteImage(url: String) async throws {
        do {
            // Extract path from URL
            let path = extractPathFromURL(url)

            // Delete from Supabase Storage
            try await client.storage
                .from(bucketName)
                .remove(paths: [path])
        } catch {
            // Silently fail on delete errors (file might not exist)
            // This is acceptable for cleanup operations
        }
    }

    func getPublicURL(path: String) -> String {
        // Construct public URL using Supabase client
        do {
            let url = try client.storage
                .from(bucketName)
                .getPublicURL(path: path)
            return url.absoluteString
        } catch {
            // Fallback to manual construction if getPublicURL fails
            guard let baseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String else {
                return ""
            }
            return "\(baseURL)/storage/v1/object/public/\(bucketName)/\(path)"
        }
    }

    // MARK: - Helper Methods

    private func extractPathFromURL(_ url: String) -> String {
        // Extract path from full URL
        // Format: https://{project}.supabase.co/storage/v1/object/public/wardrobe-images/{path}
        if let range = url.range(of: "/wardrobe-images/") {
            return String(url[range.upperBound...])
        }
        return url // Assume it's already just a path
    }

    private func mapStorageError(_ error: Error) -> StorageError {
        let errorDescription = error.localizedDescription.lowercased()

        if errorDescription.contains("not found") || errorDescription.contains("404") {
            return .notFound
        } else if errorDescription.contains("unauthorized") || errorDescription.contains("401") {
            return .unauthorized
        } else if errorDescription.contains("too large") || errorDescription.contains("413") {
            return .fileTooLarge
        } else if errorDescription.contains("quota") {
            return .quotaExceeded
        } else {
            return .networkError
        }
    }
}

// MARK: - Mock Implementation

final class MockStorageService: StorageService, @unchecked Sendable {
    var storedImages: [String: Data] = [:]
    var shouldThrowError = false
    var errorToThrow: StorageError = .networkError

    func uploadImage(_ image: Data, userId: UUID, itemId: UUID) async throws -> String {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3s delay
        if shouldThrowError { throw errorToThrow }

        let path = "\(userId.uuidString)/\(itemId.uuidString).jpg"
        storedImages[path] = image
        return path
    }

    func uploadThumbnail(_ image: Data, userId: UUID, itemId: UUID) async throws -> String {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }

        let path = "\(userId.uuidString)/thumbnails/\(itemId.uuidString).jpg"
        storedImages[path] = image
        return path
    }

    func downloadImage(url: String) async throws -> Data {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }

        // Extract path from URL
        let path = url.components(separatedBy: "/wardrobe-images/").last ?? url

        guard let data = storedImages[path] else {
            throw StorageError.notFound
        }
        return data
    }

    func deleteImage(url: String) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }

        // Extract path from URL
        let path = url.components(separatedBy: "/wardrobe-images/").last ?? url
        storedImages.removeValue(forKey: path)
    }

    func getPublicURL(path: String) -> String {
        "https://mock.supabase.co/storage/v1/object/public/wardrobe-images/\(path)"
    }
}

// MARK: - Errors

enum StorageError: Error, Equatable {
    case notImplemented
    case notFound
    case invalidImage
    case fileTooLarge
    case networkError
    case unauthorized
    case quotaExceeded
}

import Foundation
import Dependencies
import UIKit

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

// MARK: - Live Implementation (Placeholder)

final class LiveStorageService: StorageService {
    func uploadImage(_ image: Data, userId: UUID, itemId: UUID) async throws -> String {
        // TODO: Implement Supabase Storage upload
        // Path format: {userId}/{itemId}.jpg
        throw StorageError.notImplemented
    }
    
    func uploadThumbnail(_ image: Data, userId: UUID, itemId: UUID) async throws -> String {
        // TODO: Implement Supabase Storage upload
        // Path format: {userId}/thumbnails/{itemId}.jpg
        throw StorageError.notImplemented
    }
    
    func downloadImage(url: String) async throws -> Data {
        // TODO: Implement download from Supabase Storage
        throw StorageError.notImplemented
    }
    
    func deleteImage(url: String) async throws {
        // TODO: Implement Supabase Storage delete
    }
    
    func getPublicURL(path: String) -> String {
        // TODO: Construct public URL from Supabase project URL
        "https://placeholder.supabase.co/storage/v1/object/public/wardrobe-images/\(path)"
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

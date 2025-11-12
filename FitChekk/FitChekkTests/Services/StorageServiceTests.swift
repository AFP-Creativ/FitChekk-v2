//
//  StorageServiceTests.swift
//  FitChekkTests
//
//  Tests for StorageService implementations
//

import XCTest
import UIKit
@testable import FitChekk

final class StorageServiceTests: XCTestCase {
    
    let testUserId = UUID()
    let testItemId = UUID()
    
    // MARK: - Mock Service Tests
    
    func testUploadImageSuccess() async throws {
        let service = MockStorageService()
        let testImage = UIImage(systemName: "photo")!
        let imageData = testImage.jpegData(compressionQuality: 0.8)!
        
        let path = try await service.uploadImage(imageData, userId: testUserId, itemId: testItemId)
        
        XCTAssertEqual(path, "\(testUserId.uuidString)/\(testItemId.uuidString).jpg")
        XCTAssertEqual(service.storedImages.count, 1)
        XCTAssertNotNil(service.storedImages[path])
    }
    
    func testUploadThumbnailSuccess() async throws {
        let service = MockStorageService()
        let testImage = UIImage(systemName: "photo")!
        let imageData = testImage.jpegData(compressionQuality: 0.8)!
        
        let path = try await service.uploadThumbnail(imageData, userId: testUserId, itemId: testItemId)
        
        XCTAssertEqual(path, "\(testUserId.uuidString)/thumbnails/\(testItemId.uuidString).jpg")
        XCTAssertEqual(service.storedImages.count, 1)
        XCTAssertNotNil(service.storedImages[path])
    }
    
    func testUploadImageFailure() async {
        let service = MockStorageService()
        service.shouldThrowError = true
        service.errorToThrow = .networkError
        
        let testImage = UIImage(systemName: "photo")!
        let imageData = testImage.jpegData(compressionQuality: 0.8)!
        
        do {
            _ = try await service.uploadImage(imageData, userId: testUserId, itemId: testItemId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? StorageError, .networkError)
        }
    }
    
    func testDownloadImageSuccess() async throws {
        let service = MockStorageService()
        let testImage = UIImage(systemName: "photo")!
        let imageData = testImage.jpegData(compressionQuality: 0.8)!
        
        // Upload first
        let path = try await service.uploadImage(imageData, userId: testUserId, itemId: testItemId)
        let url = service.getPublicURL(path: path)
        
        // Download
        let downloadedData = try await service.downloadImage(url: url)
        
        XCTAssertEqual(downloadedData.count, imageData.count)
    }
    
    func testDownloadImageFailure() async {
        let service = MockStorageService()
        let url = service.getPublicURL(path: "nonexistent/path.jpg")
        
        do {
            _ = try await service.downloadImage(url: url)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? StorageError, .notFound)
        }
    }
    
    func testDeleteImageSuccess() async throws {
        let service = MockStorageService()
        let testImage = UIImage(systemName: "photo")!
        let imageData = testImage.jpegData(compressionQuality: 0.8)!
        
        // Upload first
        let path = try await service.uploadImage(imageData, userId: testUserId, itemId: testItemId)
        let url = service.getPublicURL(path: path)
        
        XCTAssertEqual(service.storedImages.count, 1)
        
        // Delete
        try await service.deleteImage(url: url)
        
        XCTAssertEqual(service.storedImages.count, 0)
    }
    
    func testGetPublicURL() {
        let service = MockStorageService()
        let path = "\(testUserId.uuidString)/\(testItemId.uuidString).jpg"
        
        let url = service.getPublicURL(path: path)
        
        XCTAssertTrue(url.contains("wardrobe-images"))
        XCTAssertTrue(url.contains(path))
    }
    
    func testMultipleUploads() async throws {
        let service = MockStorageService()
        let testImage = UIImage(systemName: "photo")!
        let imageData = testImage.jpegData(compressionQuality: 0.8)!
        
        let itemId1 = UUID()
        let itemId2 = UUID()
        
        _ = try await service.uploadImage(imageData, userId: testUserId, itemId: itemId1)
        _ = try await service.uploadThumbnail(imageData, userId: testUserId, itemId: itemId1)
        _ = try await service.uploadImage(imageData, userId: testUserId, itemId: itemId2)
        
        XCTAssertEqual(service.storedImages.count, 3)
    }
}


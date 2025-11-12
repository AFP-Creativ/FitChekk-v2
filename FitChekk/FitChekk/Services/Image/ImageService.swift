//
//  ImageService.swift
//  FitChekk
//
//  Service for image selection, compression, and thumbnail generation
//

import Foundation
import Dependencies
import UIKit
import PhotosUI
import SwiftUI

// MARK: - Protocol

protocol ImageService: Sendable {
    /// Compress an image for upload
    func compressImage(_ image: UIImage, maxWidth: CGFloat, quality: CGFloat) async -> Data?

    /// Generate a thumbnail from an image
    func generateThumbnail(from image: UIImage, size: CGSize) async -> UIImage?
}

// MARK: - Dependency Key

private enum ImageServiceKey: DependencyKey {
    static let liveValue: ImageService = LiveImageService()
    static let testValue: ImageService = MockImageService()
}

extension DependencyValues {
    var imageService: ImageService {
        get { self[ImageServiceKey.self] }
        set { self[ImageServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation

final class LiveImageService: ImageService, @unchecked Sendable {

    func compressImage(_ image: UIImage, maxWidth: CGFloat = 2048, quality: CGFloat = 0.8) async -> Data? {
        await Task.detached {
            // Calculate new size maintaining aspect ratio
            let scale = min(maxWidth / image.size.width, 1.0)
            let newSize = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )

            // Resize image
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // Compress as JPEG
            return resizedImage?.jpegData(compressionQuality: quality)
        }.value
    }

    func generateThumbnail(from image: UIImage, size: CGSize = CGSize(width: 300, height: 300)) async -> UIImage? {
        await Task.detached {
            return image.preparingThumbnail(of: size)
        }.value
    }
}

// MARK: - Mock Implementation

final class MockImageService: ImageService, @unchecked Sendable {
    var shouldThrowError = false

    func compressImage(_ image: UIImage, maxWidth: CGFloat, quality: CGFloat) async -> Data? {
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay

        if shouldThrowError {
            return nil
        }

        // Return mock data
        return image.jpegData(compressionQuality: quality)
    }

    func generateThumbnail(from image: UIImage, size: CGSize) async -> UIImage? {
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay

        if shouldThrowError {
            return nil
        }

        // Return resized image
        return image.preparingThumbnail(of: size)
    }
}

// MARK: - Errors

enum ImageServiceError: Error, Equatable {
    case compressionFailed
    case thumbnailGenerationFailed
    case invalidImage
    case cancelled
}

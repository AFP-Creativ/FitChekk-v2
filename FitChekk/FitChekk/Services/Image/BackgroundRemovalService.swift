//
//  BackgroundRemovalService.swift
//  FitChekk
//
//  Service for removing backgrounds from images using Vision framework
//

import Foundation
import Dependencies
import UIKit
import Vision
import CoreImage

// MARK: - Protocol

protocol BackgroundRemovalService: Sendable {
    /// Remove background from an image using Vision framework
    func removeBackground(from image: UIImage) async throws -> UIImage
}

// MARK: - Dependency Key

private enum BackgroundRemovalServiceKey: DependencyKey {
    static let liveValue: BackgroundRemovalService = LiveBackgroundRemovalService()
    static let testValue: BackgroundRemovalService = MockBackgroundRemovalService()
}

extension DependencyValues {
    var backgroundRemovalService: BackgroundRemovalService {
        get { self[BackgroundRemovalServiceKey.self] }
        set { self[BackgroundRemovalServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation

final class LiveBackgroundRemovalService: BackgroundRemovalService, @unchecked Sendable {

    @available(iOS 17.0, *)
    func removeBackground(from image: UIImage) async throws -> UIImage {
        guard let inputImage = CIImage(image: image) else {
            throw BackgroundRemovalError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            do {
                // Create the request
                let request = VNGenerateForegroundInstanceMaskRequest()

                // Perform the request
                let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])
                try handler.perform([request])

                // Get the result
                guard let result = request.results?.first else {
                    continuation.resume(throwing: BackgroundRemovalError.noMaskGenerated)
                    return
                }

                // Generate the masked image
                let maskedImage = try self.apply(mask: result, to: inputImage)

                // Convert CIImage to UIImage
                let context = CIContext()
                guard let cgImage = context.createCGImage(maskedImage, from: maskedImage.extent) else {
                    continuation.resume(throwing: BackgroundRemovalError.conversionFailed)
                    return
                }

                let outputImage = UIImage(
                    cgImage: cgImage,
                    scale: image.scale,
                    orientation: image.imageOrientation
                )
                continuation.resume(returning: outputImage)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    @available(iOS 17.0, *)
    private func apply(mask: VNInstanceMaskObservation, to image: CIImage) throws -> CIImage {
        // Generate mask image from observation using the correct API
        let handler = VNImageRequestHandler(ciImage: image)
        let maskPixelBuffer = try mask.generateScaledMaskForImage(
            forInstances: mask.allInstances,
            from: handler
        )
        let maskCIImage = CIImage(cvPixelBuffer: maskPixelBuffer)

        // Scale mask to match input image size
        let scaleX = image.extent.width / maskCIImage.extent.width
        let scaleY = image.extent.height / maskCIImage.extent.height
        let scaledMask = maskCIImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        // Create a transparent background
        let background = CIImage(color: .clear).cropped(to: image.extent)

        // Blend the original image with transparent background using the mask
        guard let blendFilter = CIFilter(name: "CIBlendWithMask") else {
            throw BackgroundRemovalError.filterCreationFailed
        }

        blendFilter.setValue(image, forKey: kCIInputImageKey)
        blendFilter.setValue(background, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(scaledMask, forKey: kCIInputMaskImageKey)

        guard let outputImage = blendFilter.outputImage else {
            throw BackgroundRemovalError.filterOutputFailed
        }

        return outputImage
    }
}

// MARK: - Mock Implementation

final class MockBackgroundRemovalService: BackgroundRemovalService, @unchecked Sendable {
    var shouldThrowError = false
    var errorToThrow: BackgroundRemovalError = .unsupported

    func removeBackground(from image: UIImage) async throws -> UIImage {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay to simulate processing

        if shouldThrowError {
            throw errorToThrow
        }

        // Return original image in mock (background removal simulation)
        return image
    }
}

// MARK: - Errors

enum BackgroundRemovalError: Error, Equatable, LocalizedError {
    case invalidImage
    case noMaskGenerated
    case conversionFailed
    case filterCreationFailed
    case filterOutputFailed
    case unsupported
    case processingFailed

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "The image format is not supported"
        case .noMaskGenerated:
            return "Could not detect the subject in the image"
        case .conversionFailed:
            return "Failed to process the image"
        case .filterCreationFailed, .filterOutputFailed:
            return "Image processing failed"
        case .unsupported:
            return "Background removal is not available on this device"
        case .processingFailed:
            return "Something went wrong while removing the background"
        }
    }

    var userFriendlyMessage: String {
        errorDescription ?? "Background removal failed"
    }
}

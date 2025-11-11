import Foundation
import Dependencies
import UIKit

// MARK: - Categorization Result

struct CategorizationResult: Equatable, Sendable {
    let category: ItemCategory
    let subCategory: ItemSubCategory
    let colors: [String]
    let pattern: String?
    let formality: FormalityLevel
    let seasons: [Season]
    let materialType: String?
    let confidence: Double // 0.0-1.0
    
    var needsHumanReview: Bool {
        confidence < 0.7
    }
}

// MARK: - Protocol

/// Service for AI-powered clothing item categorization using Gemini
protocol CategorizationService: Sendable {
    /// Analyze a clothing item image and extract attributes
    func categorizeItem(image: Data) async throws -> CategorizationResult
    
    /// Validate if categorization results need human review
    func validateCategories(_ result: CategorizationResult) -> Bool
}

// MARK: - Dependency Key

private enum CategorizationServiceKey: DependencyKey {
    static let liveValue: CategorizationService = LiveCategorizationService()
    static let testValue: CategorizationService = MockCategorizationService()
}

extension DependencyValues {
    var categorizationService: CategorizationService {
        get { self[CategorizationServiceKey.self] }
        set { self[CategorizationServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveCategorizationService: CategorizationService {
    func categorizeItem(image: Data) async throws -> CategorizationResult {
        // TODO: Implement in Phase 4
        // 1. Convert image to base64
        // 2. Send to Portkey/Gemini with categorization prompt
        // 3. Parse JSON response
        // 4. Return structured result
        throw CategorizationError.notImplemented
    }
    
    func validateCategories(_ result: CategorizationResult) -> Bool {
        // Check if confidence is high enough
        !result.needsHumanReview
    }
}

// MARK: - Mock Implementation

final class MockCategorizationService: CategorizationService, @unchecked Sendable {
    var mockResult: CategorizationResult?
    var shouldThrowError = false
    var errorToThrow: CategorizationError = .networkError
    var processingDelay: UInt64 = 1_000_000_000 // 1s default to simulate AI processing
    
    func categorizeItem(image: Data) async throws -> CategorizationResult {
        try await Task.sleep(nanoseconds: processingDelay)
        if shouldThrowError { throw errorToThrow }
        
        if let result = mockResult {
            return result
        }
        
        // Return realistic mock categorization
        let categories: [(ItemCategory, ItemSubCategory)] = [
            (.tops, .basicTees),
            (.tops, .sweaters),
            (.bottoms, .jeans),
            (.dresses, .casualDresses),
            (.outerwear, .jackets),
            (.shoes, .sneakers)
        ]
        
        let (category, subCategory) = categories.randomElement() ?? (.tops, .basicTees)
        
        return CategorizationResult(
            category: category,
            subCategory: subCategory,
            colors: ["Blue", "Navy"].filter { _ in Bool.random() },
            pattern: ["solid", "striped", "plaid", nil].randomElement() ?? nil,
            formality: [.veryCasual, .casual, .smartCasual].randomElement() ?? .casual,
            seasons: [.spring, .summer, .fall].shuffled().prefix(Int.random(in: 1...3)).map { $0 },
            materialType: ["cotton", "denim", "polyester", "wool"].randomElement(),
            confidence: Double.random(in: 0.75...0.95)
        )
    }
    
    func validateCategories(_ result: CategorizationResult) -> Bool {
        !result.needsHumanReview
    }
}

// MARK: - Errors

enum CategorizationError: Error, Equatable {
    case notImplemented
    case invalidImage
    case networkError
    case apiLimitReached
    case lowConfidence
    case processingFailed
    case timeout
}

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

// MARK: - Live Implementation

final class LiveCategorizationService: CategorizationService, @unchecked Sendable {
    private let portkeyService: PortkeyService
    
    init(portkeyService: PortkeyService? = nil) {
        self.portkeyService = portkeyService ?? PortkeyService()
    }
    
    func categorizeItem(image: Data) async throws -> CategorizationResult {
        let prompt = buildCategorizationPrompt()
        
        do {
            let response = try await portkeyService.sendGeminiRequest(
                prompt: prompt,
                imageData: image,
                maxTokens: 1024,
                temperature: 0.3 // Lower temperature for more consistent categorization
            )
            
            return try parseCategorizationResponse(response)
        } catch let error as PortkeyError {
            throw mapPortkeyError(error)
        } catch {
            throw CategorizationError.processingFailed
        }
    }

    func validateCategories(_ result: CategorizationResult) -> Bool {
        // Check if confidence is high enough
        !result.needsHumanReview
    }
    
    // MARK: - Private Helpers
    
    private func buildCategorizationPrompt() -> String {
        return """
        You are a fashion expert AI analyzing clothing items. Examine the provided image and categorize it:

        
        1. **Category**: Choose ONE from: tops, bottoms, dresses, outerwear, shoes, accessories
        
        2. **Sub-category**: Choose the most specific type based on the category:
           - tops: basic_tees, blouses, sweaters, hoodies, tank_tops, dress_shirts
           - bottoms: jeans, trousers, shorts, skirts, leggings
           - dresses: casual_dresses, formal_dresses, midi_dresses, maxi_dresses
           - outerwear: jackets, coats, blazers, vests
           - shoes: sneakers, boots, heels, flats, sandals
           - accessories: bags, jewelry, belts, hats, scarves
        
        3. **Colors**: List 1-3 dominant colors (common names: black, white, blue, red, green, yellow, etc.)
        
        4. **Pattern**: Identify: solid, striped, plaid, floral, polka_dot, geometric, animal_print, or null
        
        5. **Formality**: Rate on a scale:
           - 1 = Very casual (gym wear, loungewear)
           - 2 = Casual (everyday wear, jeans and tees)
           - 3 = Smart casual (dressed up but chill, nice jeans with blouse)
           - 4 = Business casual (office appropriate)
           - 5 = Formal (fancy, dressed up for special occasions)
        
        6. **Seasons**: Choose from: spring, summer, fall, winter (can be multiple)
        
        7. **Material Type**: If identifiable: cotton, denim, leather, wool, silk, linen, knit, or "unknown".
        
        8. **Confidence**: Your confidence level in this categorization (0.0 to 1.0):
           - 0.9-1.0: Very confident, clear image and obvious category
           - 0.7-0.89: Confident, some minor uncertainty
           - 0.5-0.69: Moderate confidence, recommend human review
           - Below 0.5: Low confidence, definitely needs human review
        
        **Important Guidelines:**
        - Be conservative with confidence scores - if you're unsure, lower the score
        - If multiple items are in the image, focus on the primary/largest item
        - If the image is unclear or shows something other than clothing, set confidence below 0.5
        - Use lowercase for all string values except color names (use title case)
        
        Return ONLY valid JSON with this EXACT structure (no additional text):
        {
          "category": "string",
          "subCategory": "string",
          "colors": ["string"],
          "pattern": "string or null",
          "formality": number,
          "seasons": ["string"],
          "materialType": "string",
          "confidence": number
        }
        """
    }
    
    private func parseCategorizationResponse(_ response: String) throws -> CategorizationResult {
        // Clean the response - sometimes AI adds markdown formatting
        var cleanedResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedResponse.hasPrefix("```json") {
            cleanedResponse = cleanedResponse
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        guard let data = cleanedResponse.data(using: .utf8) else {
            throw CategorizationError.processingFailed
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let aiResponse = try decoder.decode(AICategorizationResponse.self, from: data)
            return try convertToCategorizationResult(aiResponse)
        } catch {
            throw CategorizationError.processingFailed
        }
    }
    
    private func convertToCategorizationResult(_ response: AICategorizationResponse) throws -> CategorizationResult {
        // Map string values to enums
        guard let category = ItemCategory(rawValue: response.category) else {
            throw CategorizationError.processingFailed
        }
        
        guard let subCategory = ItemSubCategory(rawValue: response.subCategory) else {
            throw CategorizationError.processingFailed
        }
        
        guard let formality = FormalityLevel(rawValue: response.formality) else {
            throw CategorizationError.processingFailed
        }
        
        let seasons = response.seasons.compactMap { Season(rawValue: $0) }
        
        return CategorizationResult(
            category: category,
            subCategory: subCategory,
            colors: response.colors,
            pattern: response.pattern,
            formality: formality,
            seasons: seasons,
            materialType: response.materialType,
            confidence: response.confidence
        )
    }
    
    private func mapPortkeyError(_ error: PortkeyError) -> CategorizationError {
        switch error {
        case .invalidRequest, .decodingError:
            return .invalidImage
        case .networkError:
            return .networkError
        case .rateLimitExceeded:
            return .apiLimitReached
        case .unauthorized:
            return .processingFailed
        case .serverError, .httpError, .invalidResponse, .emptyResponse:
            return .processingFailed
        }
    }
}

// MARK: - AI Response Model

private struct AICategorizationResponse: Decodable {
    let category: String
    let subCategory: String
    let colors: [String]
    let pattern: String?
    let formality: Int
    let seasons: [String]
    let materialType: String
    let confidence: Double
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

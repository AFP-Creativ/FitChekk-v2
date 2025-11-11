import Foundation
import Dependencies

// MARK: - Outfit Suggestion

struct OutfitSuggestion: Equatable, Sendable {
    let id: UUID
    let name: String
    let itemIds: [UUID]
    let occasion: String
    let reasoning: String
    let styleScore: Double // 0.0-1.0
    let weatherAppropriate: Bool
}

// MARK: - Outfit Context

struct OutfitContext: Equatable, Sendable {
    let wardrobeItems: [WardrobeItem]
    let weather: WeatherCondition?
    let occasion: String?
    let stylePreferences: [String]
    let favoriteColors: [String]
}

// MARK: - Protocol

/// Service for AI-powered outfit suggestions using Claude
protocol OutfitService: Sendable {
    /// Generate outfit suggestions based on wardrobe and context
    func suggestOutfits(
        wardrobe: [WardrobeItem],
        weather: WeatherCondition?,
        preferences: UserPreferences?,
        occasion: String?
    ) async throws -> [OutfitSuggestion]
    
    /// Get detailed reasoning for why an outfit works
    func explainOutfit(outfit: Outfit) async throws -> String
    
    /// Record user feedback on outfit suggestions
    func rateOutfit(outfit: Outfit, rating: Int) async throws
}

// MARK: - Dependency Key

private enum OutfitServiceKey: DependencyKey {
    static let liveValue: OutfitService = LiveOutfitService()
    static let testValue: OutfitService = MockOutfitService()
}

extension DependencyValues {
    var outfitService: OutfitService {
        get { self[OutfitServiceKey.self] }
        set { self[OutfitServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveOutfitService: OutfitService {
    func suggestOutfits(
        wardrobe: [WardrobeItem],
        weather: WeatherCondition?,
        preferences: UserPreferences?,
        occasion: String?
    ) async throws -> [OutfitSuggestion] {
        // TODO: Implement in Phase 5
        // 1. Build context with wardrobe items, weather, preferences
        // 2. Send to Portkey/Claude with outfit suggestion prompt
        // 3. Parse JSON response with multiple outfit suggestions
        // 4. Return structured suggestions with reasoning
        []
    }
    
    func explainOutfit(outfit: Outfit) async throws -> String {
        // TODO: Implement Claude explanation for existing outfit
        throw OutfitError.notImplemented
    }
    
    func rateOutfit(outfit: Outfit, rating: Int) async throws {
        // TODO: Store rating for future ML improvements
    }
}

// MARK: - Mock Implementation

final class MockOutfitService: OutfitService, @unchecked Sendable {
    var mockSuggestions: [OutfitSuggestion]?
    var mockExplanation: String?
    var shouldThrowError = false
    var errorToThrow: OutfitError = .networkError
    var processingDelay: UInt64 = 2_000_000_000 // 2s default to simulate AI processing
    var recordedRatings: [(Outfit, Int)] = []
    
    func suggestOutfits(
        wardrobe: [WardrobeItem],
        weather: WeatherCondition?,
        preferences: UserPreferences?,
        occasion: String?
    ) async throws -> [OutfitSuggestion] {
        try await Task.sleep(nanoseconds: processingDelay)
        if shouldThrowError { throw errorToThrow }
        
        if let suggestions = mockSuggestions {
            return suggestions
        }
        
        // Generate realistic mock suggestions
        guard !wardrobe.isEmpty else {
            return []
        }
        
        let numberOfSuggestions = min(3, wardrobe.count / 2)
        var suggestions: [OutfitSuggestion] = []
        
        for index in 0..<numberOfSuggestions {
            let itemCount = min(Int.random(in: 2...4), wardrobe.count)
            let selectedItems = Array(wardrobe.shuffled().prefix(itemCount))
            
            let occasions = ["casual", "work", "date night", "brunch", "evening out"]
            let selectedOccasion = occasion ?? occasions.randomElement() ?? "casual"
            
            let suggestion = OutfitSuggestion(
                id: UUID(),
                name: "Outfit Idea \(index + 1)",
                itemIds: selectedItems.map { $0.id },
                occasion: selectedOccasion,
                reasoning: generateMockReasoning(items: selectedItems, weather: weather, occasion: selectedOccasion),
                styleScore: Double.random(in: 0.75...0.95),
                weatherAppropriate: weather != nil
            )
            suggestions.append(suggestion)
        }
        
        return suggestions
    }
    
    func explainOutfit(outfit: Outfit) async throws -> String {
        try await Task.sleep(nanoseconds: processingDelay / 2)
        if shouldThrowError { throw errorToThrow }
        
        if let explanation = mockExplanation {
            return explanation
        }
        
        return """
        This outfit works well because the pieces complement each other nicely. \
        The color combination is balanced and the formality levels match perfectly. \
        It's a great choice for \(outfit.occasion ?? "any occasion")!
        """
    }
    
    func rateOutfit(outfit: Outfit, rating: Int) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        recordedRatings.append((outfit, rating))
    }
    
    // MARK: - Helpers
    
    private func generateMockReasoning(items: [WardrobeItem], weather: WeatherCondition?, occasion: String) -> String {
        var reasons: [String] = []
        
        reasons.append("This combo brings together \(items.count) pieces that work great together")
        
        if let weather = weather {
            reasons.append("Perfect for \(weather.tempHigh)° weather")
        }
        
        let colors = items.flatMap { $0.colors }
        if !colors.isEmpty {
            reasons.append("Love how the \(colors.prefix(2).joined(separator: " and ")) coordinate")
        }
        
        reasons.append("Great for \(occasion)")
        
        return reasons.joined(separator: ". ") + "."
    }
}

// MARK: - Errors

enum OutfitError: Error, Equatable {
    case notImplemented
    case insufficientItems
    case networkError
    case apiLimitReached
    case processingFailed
    case timeout
}

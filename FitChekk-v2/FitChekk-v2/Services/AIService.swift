//
//  AIService.swift
//  FitChekk-v2
//
//  AI service protocol and mock implementation
//  Real implementation will use Portkey (Gemini for categorization, Claude for suggestions)
//

import Foundation

// MARK: - Outfit Suggestion

struct OutfitSuggestion: Identifiable, Codable, Equatable {
    let id: UUID
    let outfit: Outfit
    let reasoning: String
    let confidenceScore: Double // 0-1

    init(
        id: UUID = UUID(),
        outfit: Outfit,
        reasoning: String,
        confidenceScore: Double = 0.9
    ) {
        self.id = id
        self.outfit = outfit
        self.reasoning = reasoning
        self.confidenceScore = confidenceScore
    }
}

// MARK: - Protocol

protocol AIServiceProtocol {
    func categorizeItem(imageData: Data) async throws -> WardrobeItem
    func suggestOutfit(
        wardrobe: [WardrobeItem],
        weather: WeatherSnapshot,
        occasion: OutfitOccasion?,
        preferences: StylePreferences
    ) async throws -> OutfitSuggestion
}

// MARK: - Mock Implementation

class MockAIService: AIServiceProtocol {
    func categorizeItem(imageData: Data) async throws -> WardrobeItem {
        // Simulate AI processing time
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // Return a mock categorized item
        return WardrobeItem(
            name: "Categorized Item",
            category: .tops,
            subcategory: "T-Shirt",
            colors: [.blue],
            pattern: .solid,
            formality: .casual,
            seasons: [.spring, .summer],
            styleTags: ["casual", "comfortable"]
        )
    }

    func suggestOutfit(
        wardrobe: [WardrobeItem],
        weather: WeatherSnapshot,
        occasion: OutfitOccasion? = nil,
        preferences: StylePreferences = StylePreferences()
    ) async throws -> OutfitSuggestion {
        // Simulate AI processing
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

        // Generate a reasonable outfit from available items
        let tops = wardrobe.filter { $0.category == .tops }
        let bottoms = wardrobe.filter { $0.category == .bottoms }
        let shoes = wardrobe.filter { $0.category == .shoes }

        guard let top = tops.first,
              let bottom = bottoms.first,
              let shoe = shoes.first else {
            throw NSError(domain: "AIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not enough items to create outfit"])
        }

        // Build reasoning based on weather
        let reasoning = buildReasoning(weather: weather, occasion: occasion, top: top, bottom: bottom, shoe: shoe)

        let outfit = Outfit(
            name: "\(top.displayName) + \(bottom.displayName)",
            itemIDs: [top.id, bottom.id, shoe.id],
            occasion: occasion ?? .casual,
            season: currentSeason(for: weather),
            aiGenerated: true,
            aiReasoning: reasoning
        )

        return OutfitSuggestion(
            outfit: outfit,
            reasoning: reasoning,
            confidenceScore: 0.92
        )
    }

    private func buildReasoning(
        weather: WeatherSnapshot,
        occasion: OutfitOccasion?,
        top: WardrobeItem,
        bottom: WardrobeItem,
        shoe: WardrobeItem
    ) -> String {
        var reasoning = "Based on today's weather (\(Int(weather.temperature))°C, \(weather.condition.description)), "

        if weather.temperature < 15 {
            reasoning += "I recommend layering. "
        } else if weather.temperature > 25 {
            reasoning += "lightweight breathable pieces are ideal. "
        }

        reasoning += "The \(top.displayName.lowercased()) pairs well with \(bottom.displayName.lowercased()), "
        reasoning += "creating a balanced silhouette. "

        if let occasion = occasion {
            reasoning += "This combination is perfect for \(occasion.rawValue.lowercased()) occasions. "
        }

        reasoning += "Complete the look with \(shoe.displayName.lowercased()) for comfort and style."

        return reasoning
    }

    private func currentSeason(for weather: WeatherSnapshot) -> Season {
        let temp = weather.temperature
        if temp < 10 {
            return .winter
        } else if temp < 20 {
            return .spring
        } else if temp < 28 {
            return .summer
        } else {
            return .fall
        }
    }
}

// MARK: - Shared Instance

extension MockAIService {
    static let shared = MockAIService()
}

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

// MARK: - Live Implementation

final class LiveOutfitService: OutfitService, @unchecked Sendable {
    private let portkeyService: PortkeyService
    
    init(portkeyService: PortkeyService? = nil) {
        self.portkeyService = portkeyService ?? PortkeyService()
    }
    
    func suggestOutfits(
        wardrobe: [WardrobeItem],
        weather: WeatherCondition?,
        preferences: UserPreferences?,
        occasion: String?
    ) async throws -> [OutfitSuggestion] {
        // Validate we have enough items
        guard wardrobe.count >= 2 else {
            throw OutfitError.insufficientItems
        }
        
        // Build context and prompts
        let systemPrompt = buildSystemPrompt()
        let userPrompt = buildUserPrompt(
            wardrobe: wardrobe,
            weather: weather,
            preferences: preferences,
            occasion: occasion
        )
        
        do {
            let response = try await portkeyService.sendClaudeRequest(
                systemPrompt: systemPrompt,
                userPrompt: userPrompt,
                maxTokens: 4096,
                temperature: 0.7
            )
            
            return try parseOutfitSuggestions(response: response, wardrobe: wardrobe)
        } catch let error as PortkeyError {
            throw mapPortkeyError(error)
        } catch {
            throw OutfitError.processingFailed
        }
    }

    func explainOutfit(outfit: Outfit) async throws -> String {
        let systemPrompt = """
        You are a friendly personal stylist explaining fashion choices. Use a conversational, 
        approachable tone - like a knowledgeable friend giving advice, not a formal fashion expert.
        """
        
        let userPrompt = """
        Explain why this outfit works well. Keep it casual and friendly.
        
        Outfit: \(outfit.name)
        Occasion: \(outfit.occasion ?? "everyday wear")
        Number of items: \(outfit.itemIds.count)
        Weather context: \(outfit.weatherSummary ?? "N/A")
        
        In 2-3 sentences, explain why this outfit is a good choice. Be specific but friendly.
        """
        
        do {
            return try await portkeyService.sendClaudeRequest(
                systemPrompt: systemPrompt,
                userPrompt: userPrompt,
                maxTokens: 512,
                temperature: 0.8
            )
        } catch let error as PortkeyError {
            throw mapPortkeyError(error)
        } catch {
            throw OutfitError.processingFailed
        }
    }

    func rateOutfit(outfit: Outfit, rating: Int) async throws {
        // Store rating in the outfit model
        // In a full implementation, this would also log to analytics
        // For now, we just validate the rating range
        guard (1...5).contains(rating) else {
            throw OutfitError.processingFailed
        }
        // Rating will be stored by the caller
    }
    
    // MARK: - Private Helpers
    
    private func buildSystemPrompt() -> String {
        return """
        You are a personal stylist AI helping users create outfits from their wardrobe. 
        Your expertise includes:
        - Color coordination and complementary palettes
        - Matching formality levels appropriately
        - Considering weather conditions for comfort
        - Understanding different occasions and dress codes
        - Creating cohesive, stylish looks
        
        Your tone should be friendly, conversational, and helpful - like a knowledgeable friend 
        giving fashion advice, not a formal consultant. Use casual language that feels natural.
        
        When suggesting outfits:
        1. Prioritize wearability and practicality
        2. Consider weather conditions carefully
        3. Match formality levels of items
        4. Create balanced color palettes
        5. Explain your reasoning in simple terms
        
        Always return valid JSON with no additional text before or after.
        """
    }
    
    private func buildUserPrompt(
        wardrobe: [WardrobeItem],
        weather: WeatherCondition?,
        preferences: UserPreferences?,
        occasion: String?
    ) -> String {
        var prompt = "Create 3 outfit suggestions from the user's wardrobe.\n\n"
        
        // Add context
        if let weather = weather {
            prompt += """
            **Current Weather:**
            - Temperature: \(weather.tempHigh)°F (feels like \(weather.feelsLike)°F)
            - Conditions: \(weather.condition)
            - Humidity: \(weather.humidity)%
            
            """
        }
        
        if let occasion = occasion {
            prompt += "**Occasion:** \(occasion)\n\n"
        } else {
            prompt += "**Occasion:** Everyday/casual\n\n"
        }
        
        if let prefs = preferences, !prefs.stylePreferences.isEmpty {
            prompt += "**Style Preferences:** \(prefs.stylePreferences.joined(separator: ", "))\n\n"
        }
        
        // Add wardrobe items
        prompt += "**Available Wardrobe Items:**\n"
        for (index, item) in wardrobe.enumerated() {
            let colors = item.colors.isEmpty ? "unspecified" : item.colors.joined(separator: ", ")
            let category = item.category.camelCaseToWords()
            let subCategory = item.subCategory.camelCaseToWords()
            
            prompt += """
            \(index + 1). ID: \(item.id.uuidString)
               - Type: \(category) - \(subCategory)
               - Colors: \(colors)
               - Formality: \(item.formalityEnum.displayName)
               - Pattern: \(item.pattern ?? "solid")
            
            """
        }
        
        prompt += """
        
        **Instructions:**
        Generate exactly 3 outfit suggestions. For each outfit:
        1. Select 2-4 items that work well together
        2. Ensure formality levels match (don't mix gym wear with dress clothes)
        3. Create harmonious color combinations
        4. Consider the weather if provided
        5. Explain why the outfit works in 1-2 friendly sentences
        
        Return ONLY valid JSON with this structure:
        {
          "outfits": [
            {
              "name": "Casual Brunch Look",
              "itemIds": ["uuid1", "uuid2", "uuid3"],
              "reasoning": "This combo is perfect for today's weather...",
              "styleScore": 0.85,
              "occasion": "brunch"
            }
          ]
        }
        
        Use the EXACT UUIDs from the wardrobe items above.
        """
        
        return prompt
    }
    
    private func parseOutfitSuggestions(response: String, wardrobe: [WardrobeItem]) throws -> [OutfitSuggestion] {
        // Clean response
        var cleanedResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedResponse.hasPrefix("```json") {
            cleanedResponse = cleanedResponse
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        guard let data = cleanedResponse.data(using: .utf8) else {
            throw OutfitError.processingFailed
        }
        
        let decoder = JSONDecoder()
        
        do {
            let aiResponse = try decoder.decode(AIOutfitResponse.self, from: data)
            
            // Validate and convert to OutfitSuggestion
            var suggestions: [OutfitSuggestion] = []
            let wardrobeIds = Set(wardrobe.map { $0.id })
            
            for outfit in aiResponse.outfits {
                // Validate item IDs exist in wardrobe
                let validItemIds = outfit.itemIds.filter { wardrobeIds.contains($0) }
                
                guard validItemIds.count >= 2 else {
                    // Skip invalid outfits
                    continue
                }
                
                let suggestion = OutfitSuggestion(
                    id: UUID(),
                    name: outfit.name,
                    itemIds: validItemIds,
                    occasion: outfit.occasion,
                    reasoning: outfit.reasoning,
                    styleScore: outfit.styleScore,
                    weatherAppropriate: true
                )
                
                suggestions.append(suggestion)
            }
            
            return suggestions
        } catch {
            throw OutfitError.processingFailed
        }
    }
    
    private func mapPortkeyError(_ error: PortkeyError) -> OutfitError {
        switch error {
        case .networkError:
            return .networkError
        case .rateLimitExceeded:
            return .apiLimitReached
        case .unauthorized, .serverError, .httpError, .invalidResponse, .emptyResponse,
             .invalidRequest, .decodingError:
            return .processingFailed
        }
    }
}

// MARK: - AI Response Models

private struct AIOutfitResponse: Decodable {
    let outfits: [AIOutfit]
}

private struct AIOutfit: Decodable {
    let name: String
    let itemIds: [UUID]
    let reasoning: String
    let styleScore: Double
    let occasion: String
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

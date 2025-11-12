import XCTest
@testable import FitChekk

@MainActor
final class OutfitServiceTests: XCTestCase {
    var mockPortkey: MockPortkeyServiceForOutfits!
    var service: LiveOutfitService!
    var testWardrobe: [WardrobeItem]!
    var testWeather: WeatherCondition!
    
    override func setUp() {
        super.setUp()
        mockPortkey = MockPortkeyServiceForOutfits()
        service = LiveOutfitService(portkeyService: mockPortkey as! PortkeyService)
        
        // Create test wardrobe
        let userId = UUID()
        testWardrobe = [
            WardrobeItem(
                id: UUID(),
                userId: userId,
                category: .tops,
                subCategory: .basicTees,
                colors: ["Blue"],
                formality: .casual
            ),
            WardrobeItem(
                id: UUID(),
                userId: userId,
                category: .bottoms,
                subCategory: .jeans,
                colors: ["Blue"],
                formality: .casual
            ),
            WardrobeItem(
                id: UUID(),
                userId: userId,
                category: .shoes,
                subCategory: .sneakers,
                colors: ["White"],
                formality: .casual
            )
        ]
        
        testWeather = WeatherCondition(
            date: Date(),
            tempHigh: 72,
            tempLow: 58,
            condition: "Partly Cloudy",
            feelsLike: 68,
            humidity: 55,
            precipitation: 10
        )
    }
    
    override func tearDown() {
        mockPortkey = nil
        service = nil
        testWardrobe = nil
        testWeather = nil
        super.tearDown()
    }
    
    // MARK: - Successful Outfit Generation Tests
    
    func testGenerateOutfitsSuccess() async throws {
        // Given
        let mockResponse = """
        {
            "outfits": [
                {
                    "name": "Casual Day Look",
                    "itemIds": ["\(testWardrobe[0].id.uuidString)", "\(testWardrobe[1].id.uuidString)"],
                    "reasoning": "Perfect for 72° weather with a casual vibe",
                    "styleScore": 0.85,
                    "occasion": "casual"
                },
                {
                    "name": "Comfortable Outfit",
                    "itemIds": ["\(testWardrobe[0].id.uuidString)", "\(testWardrobe[1].id.uuidString)", "\(testWardrobe[2].id.uuidString)"],
                    "reasoning": "Great combination for a relaxed day",
                    "styleScore": 0.88,
                    "occasion": "everyday"
                }
            ]
        }
        """
        mockPortkey.mockClaudeResponse = mockResponse
        
        // When
        let suggestions = try await service.suggestOutfits(
            wardrobe: testWardrobe,
            weather: testWeather,
            preferences: nil,
            occasion: nil
        )
        
        // Then
        XCTAssertEqual(suggestions.count, 2)
        XCTAssertEqual(suggestions[0].name, "Casual Day Look")
        XCTAssertEqual(suggestions[0].itemIds.count, 2)
        XCTAssertEqual(suggestions[0].styleScore, 0.85)
        XCTAssertTrue(suggestions[0].weatherAppropriate)
    }
    
    func testGenerateOutfitsWithWeather() async throws {
        // Given
        let mockResponse = """
        {
            "outfits": [
                {
                    "name": "Weather-Smart Look",
                    "itemIds": ["\(testWardrobe[0].id.uuidString)", "\(testWardrobe[1].id.uuidString)"],
                    "reasoning": "Ideal for 72°F partly cloudy weather",
                    "styleScore": 0.90,
                    "occasion": "casual"
                }
            ]
        }
        """
        mockPortkey.mockClaudeResponse = mockResponse
        
        // When
        let suggestions = try await service.suggestOutfits(
            wardrobe: testWardrobe,
            weather: testWeather,
            preferences: nil,
            occasion: nil
        )
        
        // Then
        XCTAssertEqual(suggestions.count, 1)
        XCTAssertTrue(suggestions[0].weatherAppropriate)
        XCTAssertTrue(suggestions[0].reasoning.contains("72"))
    }
    
    func testGenerateOutfitsWithOccasion() async throws {
        // Given
        let mockResponse = """
        {
            "outfits": [
                {
                    "name": "Work Ready",
                    "itemIds": ["\(testWardrobe[0].id.uuidString)", "\(testWardrobe[1].id.uuidString)"],
                    "reasoning": "Professional yet comfortable for work",
                    "styleScore": 0.82,
                    "occasion": "work"
                }
            ]
        }
        """
        mockPortkey.mockClaudeResponse = mockResponse
        
        // When
        let suggestions = try await service.suggestOutfits(
            wardrobe: testWardrobe,
            weather: nil,
            preferences: nil,
            occasion: "work"
        )
        
        // Then
        XCTAssertEqual(suggestions.count, 1)
        XCTAssertEqual(suggestions[0].occasion, "work")
    }
    
    func testValidateItemIdsInOutfit() async throws {
        // Given - Response includes invalid item IDs
        let invalidId = UUID()
        let mockResponse = """
        {
            "outfits": [
                {
                    "name": "Test Outfit",
                    "itemIds": ["\(testWardrobe[0].id.uuidString)", "\(invalidId.uuidString)"],
                    "reasoning": "Test reasoning",
                    "styleScore": 0.85,
                    "occasion": "casual"
                }
            ]
        }
        """
        mockPortkey.mockClaudeResponse = mockResponse
        
        // When
        let suggestions = try await service.suggestOutfits(
            wardrobe: testWardrobe,
            weather: nil,
            preferences: nil,
            occasion: nil
        )
        
        // Then - Invalid item ID should be filtered out
        XCTAssertEqual(suggestions[0].itemIds.count, 1)
        XCTAssertEqual(suggestions[0].itemIds[0], testWardrobe[0].id)
    }
    
    func testSkipOutfitsWithTooFewItems() async throws {
        // Given - Response includes outfit with only 1 valid item
        let invalidId = UUID()
        let mockResponse = """
        {
            "outfits": [
                {
                    "name": "Invalid Outfit",
                    "itemIds": ["\(invalidId.uuidString)"],
                    "reasoning": "Test",
                    "styleScore": 0.85,
                    "occasion": "casual"
                },
                {
                    "name": "Valid Outfit",
                    "itemIds": ["\(testWardrobe[0].id.uuidString)", "\(testWardrobe[1].id.uuidString)"],
                    "reasoning": "Test",
                    "styleScore": 0.85,
                    "occasion": "casual"
                }
            ]
        }
        """
        mockPortkey.mockClaudeResponse = mockResponse
        
        // When
        let suggestions = try await service.suggestOutfits(
            wardrobe: testWardrobe,
            weather: nil,
            preferences: nil,
            occasion: nil
        )
        
        // Then - Should only include valid outfit
        XCTAssertEqual(suggestions.count, 1)
        XCTAssertEqual(suggestions[0].name, "Valid Outfit")
    }
    
    // MARK: - Error Handling Tests
    
    func testInsufficientItemsError() async throws {
        // Given - Only 1 item in wardrobe
        let smallWardrobe = [testWardrobe[0]]
        
        // When/Then
        do {
            _ = try await service.suggestOutfits(
                wardrobe: smallWardrobe,
                weather: nil,
                preferences: nil,
                occasion: nil
            )
            XCTFail("Should throw insufficient items error")
        } catch let error as OutfitError {
            XCTAssertEqual(error, .insufficientItems)
        }
    }
    
    func testNetworkError() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .networkError("Connection failed")
        
        // When/Then
        do {
            _ = try await service.suggestOutfits(
                wardrobe: testWardrobe,
                weather: nil,
                preferences: nil,
                occasion: nil
            )
            XCTFail("Should throw network error")
        } catch let error as OutfitError {
            XCTAssertEqual(error, .networkError)
        }
    }
    
    func testAPILimitReached() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .rateLimitExceeded
        
        // When/Then
        do {
            _ = try await service.suggestOutfits(
                wardrobe: testWardrobe,
                weather: nil,
                preferences: nil,
                occasion: nil
            )
            XCTFail("Should throw API limit error")
        } catch let error as OutfitError {
            XCTAssertEqual(error, .apiLimitReached)
        }
    }
    
    func testProcessingFailed() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .serverError(500)
        
        // When/Then
        do {
            _ = try await service.suggestOutfits(
                wardrobe: testWardrobe,
                weather: nil,
                preferences: nil,
                occasion: nil
            )
            XCTFail("Should throw processing failed error")
        } catch let error as OutfitError {
            XCTAssertEqual(error, .processingFailed)
        }
    }
    
    // MARK: - Outfit Explanation Tests
    
    func testExplainOutfit() async throws {
        // Given
        let outfit = Outfit(
            userId: UUID(),
            name: "Casual Look",
            occasion: "everyday",
            itemIds: [UUID(), UUID()]
        )
        
        mockPortkey.mockClaudeResponse = "This outfit works great because the colors complement each other perfectly!"
        
        // When
        let explanation = try await service.explainOutfit(outfit: outfit)
        
        // Then
        XCTAssertFalse(explanation.isEmpty)
        XCTAssertTrue(explanation.contains("outfit"))
    }
    
    // MARK: - Rating Tests
    
    func testRateOutfitSuccess() async throws {
        // Given
        let outfit = Outfit(
            userId: UUID(),
            name: "Test Outfit",
            itemIds: [UUID()]
        )
        
        // When/Then
        try await service.rateOutfit(outfit: outfit, rating: 5)
        // Should not throw
    }
    
    func testRateOutfitInvalidRating() async throws {
        // Given
        let outfit = Outfit(
            userId: UUID(),
            name: "Test Outfit",
            itemIds: [UUID()]
        )
        
        // When/Then
        do {
            try await service.rateOutfit(outfit: outfit, rating: 6)
            XCTFail("Should throw error for invalid rating")
        } catch {
            // Success
        }
    }
}

// MARK: - Mock Portkey Service for Outfits

class MockPortkeyServiceForOutfits: PortkeyService {
    var mockClaudeResponse: String?
    var shouldThrowError = false
    var errorToThrow: PortkeyError?
    
    override init(apiKey: String? = "test", baseURL: String = "https://test.com", session: URLSession = .shared) {
        super.init(apiKey: apiKey, baseURL: baseURL, session: session)
    }
    
    func sendClaudeRequest(
        systemPrompt: String,
        userPrompt: String,
        maxTokens: Int,
        temperature: Double
    ) async throws -> String {
        if shouldThrowError, let error = errorToThrow {
            throw error
        }
        
        return mockClaudeResponse ?? "{}"
    }
}


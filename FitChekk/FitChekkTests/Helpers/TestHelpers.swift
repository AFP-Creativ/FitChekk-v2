//
//  TestHelpers.swift
//  FitChekkTests
//
//  Reusable test utilities and sample data for FitChekk tests
//

import Foundation
@testable import FitChekk

// MARK: - Test Constants

enum TestConstants {
    // Predictable UUIDs for testing
    static let testUserId1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    static let testUserId2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
    static let testItemId1 = UUID(uuidString: "10000000-0000-0000-0000-000000000001")!
    static let testItemId2 = UUID(uuidString: "10000000-0000-0000-0000-000000000002")!
    static let testOutfitId1 = UUID(uuidString: "20000000-0000-0000-0000-000000000001")!
    static let testOutfitId2 = UUID(uuidString: "20000000-0000-0000-0000-000000000002")!
    
    // Test email addresses
    static let testEmail1 = "test1@example.com"
    static let testEmail2 = "test2@example.com"
    static let testEmail3 = "premium@example.com"
    
    // Test display names
    static let testDisplayName1 = "Test User"
    static let testDisplayName2 = "Premium User"
    static let testDisplayName3 = "Trial User"
}

// MARK: - Sample User Instances

extension User {
    /// Creates a sample free-tier user for testing
    static func sampleFreeUser() -> User {
        User(
            id: TestConstants.testUserId1,
            email: TestConstants.testEmail1,
            displayName: TestConstants.testDisplayName1,
            subscriptionTier: .free,
            subscriptionStatus: .active
        )
    }
    
    /// Creates a sample premium user for testing
    static func samplePremiumUser() -> User {
        User(
            id: TestConstants.testUserId2,
            email: TestConstants.testEmail3,
            displayName: TestConstants.testDisplayName2,
            subscriptionTier: .premium,
            subscriptionStatus: .active
        )
    }
    
    /// Creates a sample trial user for testing
    static func sampleTrialUser() -> User {
        User(
            id: TestConstants.testUserId2,
            email: TestConstants.testEmail2,
            displayName: TestConstants.testDisplayName3,
            subscriptionTier: .free,
            subscriptionStatus: .trial,
            trialEndsAt: Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days from now
        )
    }
    
    /// Creates a sample user with custom properties
    static func sampleUser(
        id: UUID = TestConstants.testUserId1,
        email: String = TestConstants.testEmail1,
        displayName: String = TestConstants.testDisplayName1,
        subscriptionTier: SubscriptionTier = .free,
        subscriptionStatus: SubscriptionStatus = .active
    ) -> User {
        User(
            id: id,
            email: email,
            displayName: displayName,
            subscriptionTier: subscriptionTier,
            subscriptionStatus: subscriptionStatus
        )
    }
}

// MARK: - Sample WardrobeItem Instances

extension WardrobeItem {
    /// Creates a sample wardrobe item for testing
    static func sampleItem(
        id: UUID = TestConstants.testItemId1,
        userId: UUID = TestConstants.testUserId1,
        name: String = "Test T-Shirt",
        category: ItemCategory = .tops,
        subCategory: ItemSubCategory = .tShirt,
        color: String = "Blue",
        season: Season = .allSeasons
    ) -> WardrobeItem {
        WardrobeItem(
            id: id,
            userId: userId,
            name: name,
            category: category,
            subCategory: subCategory,
            primaryColor: color,
            season: season
        )
    }
}

// MARK: - Sample Outfit Instances

extension Outfit {
    /// Creates a sample outfit for testing
    static func sampleOutfit(
        id: UUID = TestConstants.testOutfitId1,
        userId: UUID = TestConstants.testUserId1,
        name: String = "Test Outfit",
        occasion: String? = nil,
        season: String? = nil,
        notes: String? = nil,
        aiGenerated: Bool = false,
        aiReasoning: String? = nil,
        aiStyleScore: Double? = nil,
        itemIds: [UUID]? = nil
    ) -> Outfit {
        Outfit(
            id: id,
            userId: userId,
            name: name,
            occasion: occasion,
            season: season,
            notes: notes,
            aiGenerated: aiGenerated,
            aiReasoning: aiReasoning,
            aiStyleScore: aiStyleScore,
            itemIds: itemIds ?? [TestConstants.testItemId1, TestConstants.testItemId2]
        )
    }
    
    /// Creates a sample AI-generated outfit
    static func sampleAIOutfit(
        name: String = "AI Generated Outfit",
        occasion: String? = "casual",
        styleScore: Double = 0.87
    ) -> Outfit {
        Outfit(
            userId: TestConstants.testUserId1,
            name: name,
            occasion: occasion,
            season: "summer",
            aiGenerated: true,
            aiReasoning: "This outfit combines comfort and style perfectly for the weather.",
            aiStyleScore: styleScore,
            weatherTempHigh: 75,
            weatherTempLow: 62,
            weatherCondition: "Sunny",
            itemIds: [TestConstants.testItemId1, TestConstants.testItemId2]
        )
    }
    
    /// Creates a sample manual outfit
    static func sampleManualOutfit(
        name: String = "Manual Outfit",
        occasion: String? = "work"
    ) -> Outfit {
        Outfit(
            userId: TestConstants.testUserId1,
            name: name,
            occasion: occasion,
            season: "fall",
            notes: "Perfect for office meetings",
            aiGenerated: false,
            itemIds: [TestConstants.testItemId1, TestConstants.testItemId2]
        )
    }
}

// MARK: - Sample PlannerEntry Instances

extension PlannerEntry {
    /// Creates a sample planner entry for testing
    static func sampleEntry(
        userId: UUID = TestConstants.testUserId1,
        date: Date = Date(),
        occasion: String = "Work"
    ) -> PlannerEntry {
        PlannerEntry(
            userId: userId,
            date: date,
            occasion: occasion
        )
    }
}

// MARK: - Test Assertion Helpers

/// Helper functions for common test assertions
enum TestAssertions {
    /// Asserts that two dates are approximately equal (within 1 second)
    static func assertDatesApproximatelyEqual(
        _ date1: Date,
        _ date2: Date,
        accuracy: TimeInterval = 1.0,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let difference = abs(date1.timeIntervalSince(date2))
        if difference > accuracy {
            XCTFail(
                "Dates not approximately equal. Difference: \(difference)s",
                file: file,
                line: line
            )
        }
    }
}

// MARK: - Mock Data Generators

enum MockDataGenerator {
    /// Generates a random UUID string
    static func randomUUID() -> UUID {
        UUID()
    }
    
    /// Generates a test email address
    static func testEmail(prefix: String = "test") -> String {
        "\(prefix)\(Int.random(in: 1000...9999))@example.com"
    }
    
    /// Generates a test display name
    static func testDisplayName() -> String {
        let names = ["Alice", "Bob", "Charlie", "Diana", "Eve"]
        return names.randomElement() ?? "Test User"
    }
}

// MARK: - Sample CategorizationResult Instances

extension CategorizationResult {
    /// Creates a sample high-confidence categorization result
    static func sampleHighConfidence() -> CategorizationResult {
        CategorizationResult(
            category: .tops,
            subCategory: .basicTees,
            colors: ["Blue", "Navy"],
            pattern: "solid",
            formality: .casual,
            seasons: [.spring, .summer, .fall],
            materialType: "cotton",
            confidence: 0.92
        )
    }
    
    /// Creates a sample low-confidence categorization result
    static func sampleLowConfidence() -> CategorizationResult {
        CategorizationResult(
            category: .accessories,
            subCategory: .bags,
            colors: ["Brown"],
            pattern: nil,
            formality: .smartCasual,
            seasons: [.spring, .summer, .fall, .winter],
            materialType: "leather",
            confidence: 0.55
        )
    }
    
    /// Creates a sample categorization result with custom properties
    static func sample(
        category: ItemCategory = .tops,
        subCategory: ItemSubCategory = .basicTees,
        colors: [String] = ["Blue"],
        pattern: String? = "solid",
        formality: FormalityLevel = .casual,
        seasons: [Season] = [.spring, .summer],
        materialType: String? = "cotton",
        confidence: Double = 0.85
    ) -> CategorizationResult {
        CategorizationResult(
            category: category,
            subCategory: subCategory,
            colors: colors,
            pattern: pattern,
            formality: formality,
            seasons: seasons,
            materialType: materialType,
            confidence: confidence
        )
    }
}

// MARK: - Sample OutfitSuggestion Instances

extension OutfitSuggestion {
    /// Creates a sample outfit suggestion
    static func sampleSuggestion(
        name: String = "Casual Day Look",
        itemIds: [UUID]? = nil,
        occasion: String = "casual",
        reasoning: String = "Perfect for a relaxed day with great weather",
        styleScore: Double = 0.85,
        weatherAppropriate: Bool = true
    ) -> OutfitSuggestion {
        let ids = itemIds ?? [
            TestConstants.testItemId1,
            TestConstants.testItemId2
        ]
        
        return OutfitSuggestion(
            id: UUID(),
            name: name,
            itemIds: ids,
            occasion: occasion,
            reasoning: reasoning,
            styleScore: styleScore,
            weatherAppropriate: weatherAppropriate
        )
    }
    
    /// Creates multiple sample outfit suggestions
    static func sampleSuggestions(count: Int = 3) -> [OutfitSuggestion] {
        let occasions = ["casual", "work", "date night", "brunch", "evening out"]
        
        return (0..<count).map { index in
            OutfitSuggestion(
                id: UUID(),
                name: "Outfit Idea \(index + 1)",
                itemIds: [TestConstants.testItemId1, TestConstants.testItemId2],
                occasion: occasions[index % occasions.count],
                reasoning: "This outfit works great for \(occasions[index % occasions.count])",
                styleScore: Double.random(in: 0.75...0.95),
                weatherAppropriate: true
            )
        }
    }
}

// MARK: - Sample WeatherCondition Instances

extension WeatherCondition {
    /// Creates a sample weather condition
    static func sampleWeather(
        date: Date = Date(),
        tempHigh: Int = 72,
        tempLow: Int = 58,
        condition: String = "Partly Cloudy",
        feelsLike: Int = 68,
        humidity: Int = 55,
        precipitation: Int = 10
    ) -> WeatherCondition {
        WeatherCondition(
            date: date,
            tempHigh: tempHigh,
            tempLow: tempLow,
            condition: condition,
            feelsLike: feelsLike,
            humidity: humidity,
            precipitation: precipitation
        )
    }
    
    /// Creates a sample sunny weather condition
    static func sampleSunny() -> WeatherCondition {
        WeatherCondition(
            date: Date(),
            tempHigh: 78,
            tempLow: 62,
            condition: "Sunny",
            feelsLike: 75,
            humidity: 45,
            precipitation: 0
        )
    }
    
    /// Creates a sample rainy weather condition
    static func sampleRainy() -> WeatherCondition {
        WeatherCondition(
            date: Date(),
            tempHigh: 65,
            tempLow: 55,
            condition: "Rainy",
            feelsLike: 60,
            humidity: 80,
            precipitation: 70
        )
    }
    
    /// Creates a sample weather forecast
    static func sampleForecast(days: Int = 5) -> WeatherForecast {
        let current = sampleWeather()
        var daily: [WeatherCondition] = []
        
        for day in 0..<days {
            let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
            let condition = WeatherCondition(
                date: date,
                tempHigh: Int.random(in: 65...80),
                tempLow: Int.random(in: 50...65),
                condition: ["Sunny", "Partly Cloudy", "Cloudy", "Rainy"].randomElement() ?? "Sunny",
                feelsLike: Int.random(in: 55...75),
                humidity: Int.random(in: 40...70),
                precipitation: Int.random(in: 0...60)
            )
            daily.append(condition)
        }
        
        return WeatherForecast(current: current, daily: daily)
    }
}

// MARK: - Sample OutfitContext Instances

extension OutfitContext {
    /// Creates a sample outfit context for testing
    static func sampleContext(
        wardrobeItems: [WardrobeItem]? = nil,
        weather: WeatherCondition? = nil,
        occasion: String? = nil,
        stylePreferences: [String] = ["casual", "comfortable"],
        favoriteColors: [String] = ["Blue", "Black", "White"]
    ) -> OutfitContext {
        let items = wardrobeItems ?? [
            WardrobeItem(
                userId: TestConstants.testUserId1,
                category: .tops,
                subCategory: .basicTees
            ),
            WardrobeItem(
                userId: TestConstants.testUserId1,
                category: .bottoms,
                subCategory: .jeans
            )
        ]
        
        return OutfitContext(
            wardrobeItems: items,
            weather: weather ?? WeatherCondition.sampleWeather(),
            occasion: occasion,
            stylePreferences: stylePreferences,
            favoriteColors: favoriteColors
        )
    }
}

// MARK: - XCTest Extensions

import XCTest

extension XCTestCase {
    /// Waits for a short duration (useful for async operations in tests)
    func waitShort() async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
    
    /// Waits for a medium duration
    func waitMedium() async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    }
}


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
        style: OutfitStyle = .casual
    ) -> Outfit {
        Outfit(
            id: id,
            userId: userId,
            name: name,
            style: style
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


//
//  DatabaseServiceTests.swift
//  FitChekkTests
//
//  Tests for DatabaseService implementations
//

import XCTest
@testable import FitChekk

final class DatabaseServiceTests: XCTestCase {
    
    let testUserId = UUID()
    
    // MARK: - Wardrobe Items Tests
    
    func testFetchWardrobeItemsSuccess() async throws {
        let service = MockDatabaseService()
        let testItems = [
            WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees),
            WardrobeItem(userId: testUserId, category: .bottoms, subCategory: .jeans)
        ]
        service.wardrobeItems = testItems
        
        let items = try await service.fetchWardrobeItems(userId: testUserId)
        
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].userId, testUserId)
        XCTAssertEqual(items[1].userId, testUserId)
    }
    
    func testFetchWardrobeItemsFiltering() async throws {
        let service = MockDatabaseService()
        let userId1 = UUID()
        let userId2 = UUID()
        
        service.wardrobeItems = [
            WardrobeItem(userId: userId1, category: .tops, subCategory: .basicTees),
            WardrobeItem(userId: userId2, category: .bottoms, subCategory: .jeans),
            WardrobeItem(userId: userId1, category: .shoes, subCategory: .sneakers)
        ]
        
        let items = try await service.fetchWardrobeItems(userId: userId1)
        
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.allSatisfy { $0.userId == userId1 })
    }
    
    func testFetchWardrobeItemsFailure() async {
        let service = MockDatabaseService()
        service.shouldThrowError = true
        service.errorToThrow = .networkError
        
        do {
            _ = try await service.fetchWardrobeItems(userId: testUserId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DatabaseError, .networkError)
        }
    }
    
    func testCreateWardrobeItemSuccess() async throws {
        let service = MockDatabaseService()
        let testItem = WardrobeItem(
            userId: testUserId,
            name: "Test Item",
            category: .tops,
            subCategory: .basicTees,
            brand: "Test Brand",
            colors: ["Blue", "White"]
        )
        
        let createdItem = try await service.createWardrobeItem(testItem)
        
        XCTAssertEqual(service.wardrobeItems.count, 1)
        XCTAssertEqual(createdItem.id, testItem.id)
        XCTAssertEqual(createdItem.name, "Test Item")
        XCTAssertEqual(createdItem.brand, "Test Brand")
    }
    
    func testUpdateWardrobeItemSuccess() async throws {
        let service = MockDatabaseService()
        let originalItem = WardrobeItem(
            userId: testUserId,
            name: "Original",
            category: .tops,
            subCategory: .basicTees
        )
        service.wardrobeItems = [originalItem]
        
        var updatedItem = originalItem
        updatedItem.name = "Updated"
        updatedItem.brand = "New Brand"
        
        let result = try await service.updateWardrobeItem(updatedItem)
        
        XCTAssertEqual(result.name, "Updated")
        XCTAssertEqual(result.brand, "New Brand")
        XCTAssertEqual(service.wardrobeItems[0].name, "Updated")
    }
    
    func testUpdateNonexistentItem() async {
        let service = MockDatabaseService()
        let nonexistentItem = WardrobeItem(
            userId: testUserId,
            category: .tops,
            subCategory: .basicTees
        )
        
        do {
            _ = try await service.updateWardrobeItem(nonexistentItem)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DatabaseError, .notFound)
        }
    }
    
    func testDeleteWardrobeItemSuccess() async throws {
        let service = MockDatabaseService()
        let testItem = WardrobeItem(userId: testUserId, category: .tops, subCategory: .basicTees)
        service.wardrobeItems = [testItem]
        
        XCTAssertEqual(service.wardrobeItems.count, 1)
        
        try await service.deleteWardrobeItem(id: testItem.id)
        
        XCTAssertEqual(service.wardrobeItems.count, 0)
    }
    
    // MARK: - Outfits Tests
    
    func testFetchOutfitsSuccess() async throws {
        let service = MockDatabaseService()
        let testOutfits = [
            Outfit(userId: testUserId, name: "Casual Friday", itemIds: [UUID()]),
            Outfit(userId: testUserId, name: "Date Night", itemIds: [UUID(), UUID()])
        ]
        service.outfits = testOutfits
        
        let outfits = try await service.fetchOutfits(userId: testUserId)
        
        XCTAssertEqual(outfits.count, 2)
        XCTAssertEqual(outfits[0].name, "Casual Friday")
    }
    
    func testCreateOutfitSuccess() async throws {
        let service = MockDatabaseService()
        let testOutfit = Outfit(
            userId: testUserId,
            name: "Work Outfit",
            itemIds: [UUID(), UUID(), UUID()],
            occasion: "Work"
        )
        
        let createdOutfit = try await service.createOutfit(testOutfit)
        
        XCTAssertEqual(service.outfits.count, 1)
        XCTAssertEqual(createdOutfit.name, "Work Outfit")
        XCTAssertEqual(createdOutfit.itemIds.count, 3)
    }
    
    func testUpdateOutfitSuccess() async throws {
        let service = MockDatabaseService()
        let originalOutfit = Outfit(
            userId: testUserId,
            name: "Original",
            itemIds: [UUID()]
        )
        service.outfits = [originalOutfit]
        
        var updatedOutfit = originalOutfit
        updatedOutfit.name = "Updated"
        updatedOutfit.itemIds.append(UUID())
        
        let result = try await service.updateOutfit(updatedOutfit)
        
        XCTAssertEqual(result.name, "Updated")
        XCTAssertEqual(result.itemIds.count, 2)
    }
    
    func testDeleteOutfitSuccess() async throws {
        let service = MockDatabaseService()
        let testOutfit = Outfit(userId: testUserId, name: "Test", itemIds: [])
        service.outfits = [testOutfit]
        
        try await service.deleteOutfit(id: testOutfit.id)
        
        XCTAssertEqual(service.outfits.count, 0)
    }
    
    // MARK: - Planner Entries Tests
    
    func testFetchPlannerEntriesSuccess() async throws {
        let service = MockDatabaseService()
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        
        service.plannerEntries = [
            PlannerEntry(userId: testUserId, date: today),
            PlannerEntry(userId: testUserId, date: tomorrow),
            PlannerEntry(userId: testUserId, date: nextWeek)
        ]
        
        let entries = try await service.fetchPlannerEntries(
            userId: testUserId,
            startDate: today,
            endDate: tomorrow
        )
        
        XCTAssertEqual(entries.count, 2)
    }
    
    func testCreatePlannerEntrySuccess() async throws {
        let service = MockDatabaseService()
        let testEntry = PlannerEntry(
            userId: testUserId,
            date: Date(),
            outfitId: UUID(),
            occasion: "Work"
        )
        
        let createdEntry = try await service.createPlannerEntry(testEntry)
        
        XCTAssertEqual(service.plannerEntries.count, 1)
        XCTAssertEqual(createdEntry.occasion, "Work")
    }
    
    func testUpdatePlannerEntrySuccess() async throws {
        let service = MockDatabaseService()
        let originalEntry = PlannerEntry(
            userId: testUserId,
            date: Date(),
            isWorn: false
        )
        service.plannerEntries = [originalEntry]
        
        var updatedEntry = originalEntry
        updatedEntry.isWorn = true
        updatedEntry.moodRating = 5
        
        let result = try await service.updatePlannerEntry(updatedEntry)
        
        XCTAssertTrue(result.isWorn)
        XCTAssertEqual(result.moodRating, 5)
    }
    
    func testDeletePlannerEntrySuccess() async throws {
        let service = MockDatabaseService()
        let testEntry = PlannerEntry(userId: testUserId, date: Date())
        service.plannerEntries = [testEntry]
        
        try await service.deletePlannerEntry(id: testEntry.id)
        
        XCTAssertEqual(service.plannerEntries.count, 0)
    }
    
    // MARK: - User Preferences Tests
    
    func testFetchUserPreferencesSuccess() async throws {
        let service = MockDatabaseService()
        let testPreferences = UserPreferences(
            userId: testUserId,
            preferredStyles: ["Casual", "Sporty"],
            favoriteColors: ["Blue", "Black"],
            weatherSensitivity: 3
        )
        service.userPreferences[testUserId] = testPreferences
        
        let preferences = try await service.fetchUserPreferences(userId: testUserId)
        
        XCTAssertNotNil(preferences)
        XCTAssertEqual(preferences?.preferredStyles, ["Casual", "Sporty"])
        XCTAssertEqual(preferences?.weatherSensitivity, 3)
    }
    
    func testFetchUserPreferencesNotFound() async throws {
        let service = MockDatabaseService()
        
        let preferences = try await service.fetchUserPreferences(userId: UUID())
        
        XCTAssertNil(preferences)
    }
    
    func testUpdateUserPreferencesSuccess() async throws {
        let service = MockDatabaseService()
        let testPreferences = UserPreferences(
            userId: testUserId,
            preferredStyles: ["Updated"],
            favoriteColors: ["Red"],
            weatherSensitivity: 5
        )
        
        let updatedPreferences = try await service.updateUserPreferences(testPreferences)
        
        XCTAssertEqual(updatedPreferences.preferredStyles, ["Updated"])
        XCTAssertEqual(service.userPreferences[testUserId]?.weatherSensitivity, 5)
    }
    
    // MARK: - Error Handling Tests
    
    func testNetworkError() async {
        let service = MockDatabaseService()
        service.shouldThrowError = true
        service.errorToThrow = .networkError
        
        do {
            _ = try await service.fetchWardrobeItems(userId: testUserId)
            XCTFail("Expected error")
        } catch let error as DatabaseError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testUnauthorizedError() async {
        let service = MockDatabaseService()
        service.shouldThrowError = true
        service.errorToThrow = .unauthorized
        
        do {
            _ = try await service.fetchWardrobeItems(userId: testUserId)
            XCTFail("Expected error")
        } catch let error as DatabaseError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}


import Foundation
import Dependencies

// MARK: - Protocol

/// Service for database CRUD operations with Supabase
protocol DatabaseService: Sendable {
    // MARK: - Wardrobe Items
    func fetchWardrobeItems(userId: UUID) async throws -> [WardrobeItem]
    func createWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem
    func updateWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem
    func deleteWardrobeItem(id: UUID) async throws
    
    // MARK: - Outfits
    func fetchOutfits(userId: UUID) async throws -> [Outfit]
    func createOutfit(_ outfit: Outfit) async throws -> Outfit
    func updateOutfit(_ outfit: Outfit) async throws -> Outfit
    func deleteOutfit(id: UUID) async throws
    
    // MARK: - Planner Entries
    func fetchPlannerEntries(userId: UUID, startDate: Date, endDate: Date) async throws -> [PlannerEntry]
    func createPlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry
    func updatePlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry
    func deletePlannerEntry(id: UUID) async throws
    
    // MARK: - User Preferences
    func fetchUserPreferences(userId: UUID) async throws -> UserPreferences?
    func updateUserPreferences(_ preferences: UserPreferences) async throws -> UserPreferences
}

// MARK: - Dependency Key

private enum DatabaseServiceKey: DependencyKey {
    static let liveValue: DatabaseService = LiveDatabaseService()
    static let testValue: DatabaseService = MockDatabaseService()
}

extension DependencyValues {
    var databaseService: DatabaseService {
        get { self[DatabaseServiceKey.self] }
        set { self[DatabaseServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveDatabaseService: DatabaseService {
    func fetchWardrobeItems(userId: UUID) async throws -> [WardrobeItem] {
        // TODO: Implement Supabase query
        []
    }
    
    func createWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem {
        // TODO: Implement Supabase insert
        throw DatabaseError.notImplemented
    }
    
    func updateWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem {
        // TODO: Implement Supabase update
        throw DatabaseError.notImplemented
    }
    
    func deleteWardrobeItem(id: UUID) async throws {
        // TODO: Implement Supabase delete
    }
    
    func fetchOutfits(userId: UUID) async throws -> [Outfit] {
        // TODO: Implement Supabase query
        []
    }
    
    func createOutfit(_ outfit: Outfit) async throws -> Outfit {
        // TODO: Implement Supabase insert
        throw DatabaseError.notImplemented
    }
    
    func updateOutfit(_ outfit: Outfit) async throws -> Outfit {
        // TODO: Implement Supabase update
        throw DatabaseError.notImplemented
    }
    
    func deleteOutfit(id: UUID) async throws {
        // TODO: Implement Supabase delete
    }
    
    func fetchPlannerEntries(userId: UUID, startDate: Date, endDate: Date) async throws -> [PlannerEntry] {
        // TODO: Implement Supabase query with date range
        []
    }
    
    func createPlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry {
        // TODO: Implement Supabase insert
        throw DatabaseError.notImplemented
    }
    
    func updatePlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry {
        // TODO: Implement Supabase update
        throw DatabaseError.notImplemented
    }
    
    func deletePlannerEntry(id: UUID) async throws {
        // TODO: Implement Supabase delete
    }
    
    func fetchUserPreferences(userId: UUID) async throws -> UserPreferences? {
        // TODO: Implement Supabase query
        nil
    }
    
    func updateUserPreferences(_ preferences: UserPreferences) async throws -> UserPreferences {
        // TODO: Implement Supabase update
        throw DatabaseError.notImplemented
    }
}

// MARK: - Mock Implementation

final class MockDatabaseService: DatabaseService, @unchecked Sendable {
    var wardrobeItems: [WardrobeItem] = []
    var outfits: [Outfit] = []
    var plannerEntries: [PlannerEntry] = []
    var userPreferences: [UUID: UserPreferences] = [:]
    var shouldThrowError = false
    var errorToThrow: DatabaseError = .networkError
    
    func fetchWardrobeItems(userId: UUID) async throws -> [WardrobeItem] {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        return wardrobeItems.filter { $0.userId == userId }
    }
    
    func createWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        wardrobeItems.append(item)
        return item
    }
    
    func updateWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        
        if let index = wardrobeItems.firstIndex(where: { $0.id == item.id }) {
            wardrobeItems[index] = item
            return item
        }
        throw DatabaseError.notFound
    }
    
    func deleteWardrobeItem(id: UUID) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        wardrobeItems.removeAll { $0.id == id }
    }
    
    func fetchOutfits(userId: UUID) async throws -> [Outfit] {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        return outfits.filter { $0.userId == userId }
    }
    
    func createOutfit(_ outfit: Outfit) async throws -> Outfit {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        outfits.append(outfit)
        return outfit
    }
    
    func updateOutfit(_ outfit: Outfit) async throws -> Outfit {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
            return outfit
        }
        throw DatabaseError.notFound
    }
    
    func deleteOutfit(id: UUID) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        outfits.removeAll { $0.id == id }
    }
    
    func fetchPlannerEntries(userId: UUID, startDate: Date, endDate: Date) async throws -> [PlannerEntry] {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        
        return plannerEntries.filter { entry in
            entry.userId == userId &&
            entry.date >= startDate &&
            entry.date <= endDate
        }
    }
    
    func createPlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        plannerEntries.append(entry)
        return entry
    }
    
    func updatePlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        
        if let index = plannerEntries.firstIndex(where: { $0.id == entry.id }) {
            plannerEntries[index] = entry
            return entry
        }
        throw DatabaseError.notFound
    }
    
    func deletePlannerEntry(id: UUID) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        plannerEntries.removeAll { $0.id == id }
    }
    
    func fetchUserPreferences(userId: UUID) async throws -> UserPreferences? {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        return userPreferences[userId]
    }
    
    func updateUserPreferences(_ preferences: UserPreferences) async throws -> UserPreferences {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        userPreferences[preferences.userId] = preferences
        return preferences
    }
}

// MARK: - Errors

enum DatabaseError: Error, Equatable {
    case notImplemented
    case notFound
    case invalidData
    case networkError
    case unauthorized
    case conflict
}

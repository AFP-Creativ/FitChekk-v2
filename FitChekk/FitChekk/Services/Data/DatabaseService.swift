import Foundation
import Dependencies
import Supabase
import SwiftData

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

// MARK: - Live Implementation

final class LiveDatabaseService: DatabaseService, @unchecked Sendable {
    private let client: SupabaseClient
    private var modelContext: ModelContext?

    init() {
        // Read Supabase configuration from Info.plist
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              let url = URL(string: supabaseURL) else {
            fatalError("Supabase configuration missing. Check Development.xcconfig and Info.plist.")
        }

        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey
        )
    }

    /// Configure ModelContext for SwiftData operations
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Wardrobe Items

    func fetchWardrobeItems(userId: UUID) async throws -> [WardrobeItem] {
        do {
            let response: [WardrobeItemDTO] = try await client
                .from("wardrobe_items")
                .select()
                .eq("user_id", value: userId.uuidString)
                .order("created_at", ascending: false)
                .execute()
                .value

            // Convert DTOs to SwiftData models
            let items = response.map { dto in
                dto.toWardrobeItem()
            }

            // Sync to local SwiftData
            if let context = modelContext {
                for item in items {
                    context.insert(item)
                }
                try context.save()
            }

            return items
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func createWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem {
        do {
            let dto = WardrobeItemDTO(from: item)

            let response: WardrobeItemDTO = try await client
                .from("wardrobe_items")
                .insert(dto)
                .select()
                .single()
                .execute()
                .value

            let createdItem = response.toWardrobeItem()

            // Sync to local SwiftData
            if let context = modelContext {
                context.insert(createdItem)
                try context.save()
            }

            return createdItem
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func updateWardrobeItem(_ item: WardrobeItem) async throws -> WardrobeItem {
        do {
            var dto = WardrobeItemDTO(from: item)
            dto.updatedAt = Date()

            let response: WardrobeItemDTO = try await client
                .from("wardrobe_items")
                .update(dto)
                .eq("id", value: item.id.uuidString)
                .select()
                .single()
                .execute()
                .value

            let updatedItem = response.toWardrobeItem()

            // Sync to local SwiftData
            if let context = modelContext {
                // Find and update existing item
                let itemId = item.id
                let descriptor = FetchDescriptor<WardrobeItem>(
                    predicate: #Predicate<WardrobeItem> { $0.id == itemId }
                )
                if let existingItem = try context.fetch(descriptor).first {
                    // Update properties
                    existingItem.updatedAt = updatedItem.updatedAt
                    existingItem.name = updatedItem.name
                    existingItem.category = updatedItem.category
                    existingItem.subCategory = updatedItem.subCategory
                    existingItem.brand = updatedItem.brand
                    existingItem.imageURL = updatedItem.imageURL
                    existingItem.thumbnailURL = updatedItem.thumbnailURL
                    existingItem.colors = updatedItem.colors
                    existingItem.seasons = updatedItem.seasons
                    existingItem.formality = updatedItem.formality
                    existingItem.isFavorite = updatedItem.isFavorite
                    existingItem.notes = updatedItem.notes
                    existingItem.timesWorn = updatedItem.timesWorn
                    existingItem.lastWornDate = updatedItem.lastWornDate
                    try context.save()
                }
            }

            return updatedItem
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func deleteWardrobeItem(id: UUID) async throws {
        do {
            try await client
                .from("wardrobe_items")
                .delete()
                .eq("id", value: id.uuidString)
                .execute()

            // Delete from local SwiftData
            if let context = modelContext {
                let itemId = id
                let descriptor = FetchDescriptor<WardrobeItem>(
                    predicate: #Predicate<WardrobeItem> { $0.id == itemId }
                )
                if let item = try context.fetch(descriptor).first {
                    context.delete(item)
                    try context.save()
                }
            }
        } catch {
            throw mapSupabaseError(error)
        }
    }

    // MARK: - Outfits

    func fetchOutfits(userId: UUID) async throws -> [Outfit] {
        do {
            let response: [OutfitDTO] = try await client
                .from("outfits")
                .select()
                .eq("user_id", value: userId.uuidString)
                .order("created_at", ascending: false)
                .execute()
                .value

            return response.map { $0.toOutfit() }
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func createOutfit(_ outfit: Outfit) async throws -> Outfit {
        do {
            let dto = OutfitDTO(from: outfit)

            let response: OutfitDTO = try await client
                .from("outfits")
                .insert(dto)
                .select()
                .single()
                .execute()
                .value

            return response.toOutfit()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func updateOutfit(_ outfit: Outfit) async throws -> Outfit {
        do {
            var dto = OutfitDTO(from: outfit)
            dto.updatedAt = Date()

            let response: OutfitDTO = try await client
                .from("outfits")
                .update(dto)
                .eq("id", value: outfit.id.uuidString)
                .select()
                .single()
                .execute()
                .value

            return response.toOutfit()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func deleteOutfit(id: UUID) async throws {
        do {
            try await client
                .from("outfits")
                .delete()
                .eq("id", value: id.uuidString)
                .execute()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    // MARK: - Planner Entries

    func fetchPlannerEntries(userId: UUID, startDate: Date, endDate: Date) async throws -> [PlannerEntry] {
        do {
            let response: [PlannerEntryDTO] = try await client
                .from("planner_entries")
                .select()
                .eq("user_id", value: userId.uuidString)
                .gte("date", value: ISO8601DateFormatter().string(from: startDate))
                .lte("date", value: ISO8601DateFormatter().string(from: endDate))
                .order("date", ascending: true)
                .execute()
                .value

            return response.map { $0.toPlannerEntry() }
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func createPlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry {
        do {
            let dto = PlannerEntryDTO(from: entry)

            let response: PlannerEntryDTO = try await client
                .from("planner_entries")
                .insert(dto)
                .select()
                .single()
                .execute()
                .value

            return response.toPlannerEntry()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func updatePlannerEntry(_ entry: PlannerEntry) async throws -> PlannerEntry {
        do {
            var dto = PlannerEntryDTO(from: entry)
            dto.updatedAt = Date()

            let response: PlannerEntryDTO = try await client
                .from("planner_entries")
                .update(dto)
                .eq("id", value: entry.id.uuidString)
                .select()
                .single()
                .execute()
                .value

            return response.toPlannerEntry()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    func deletePlannerEntry(id: UUID) async throws {
        do {
            try await client
                .from("planner_entries")
                .delete()
                .eq("id", value: id.uuidString)
                .execute()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    // MARK: - User Preferences

    func fetchUserPreferences(userId: UUID) async throws -> UserPreferences? {
        do {
            let response: UserPreferencesDTO = try await client
                .from("user_preferences")
                .select()
                .eq("user_id", value: userId.uuidString)
                .single()
                .execute()
                .value

            return response.toUserPreferences()
        } catch {
            // Return nil if not found (user hasn't set preferences yet)
            return nil
        }
    }

    func updateUserPreferences(_ preferences: UserPreferences) async throws -> UserPreferences {
        do {
            var dto = UserPreferencesDTO(from: preferences)
            dto.updatedAt = Date()

            let response: UserPreferencesDTO = try await client
                .from("user_preferences")
                .upsert(dto)
                .select()
                .single()
                .execute()
                .value

            return response.toUserPreferences()
        } catch {
            throw mapSupabaseError(error)
        }
    }

    // MARK: - Error Mapping

    private func mapSupabaseError(_ error: Error) -> DatabaseError {
        // Map Supabase errors to DatabaseError enum
        let errorDescription = error.localizedDescription.lowercased()

        if errorDescription.contains("not found") || errorDescription.contains("404") {
            return .notFound
        } else if errorDescription.contains("unauthorized") || errorDescription.contains("401") {
            return .unauthorized
        } else if errorDescription.contains("conflict") || errorDescription.contains("409") {
            return .conflict
        } else if errorDescription.contains("invalid") || errorDescription.contains("400") {
            return .invalidData
        } else {
            return .networkError
        }
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

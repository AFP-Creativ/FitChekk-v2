import Foundation
import Dependencies

// MARK: - Protocol

/// Service for syncing local SwiftData changes with Supabase backend
protocol SyncService: Sendable {
    /// Sync wardrobe items that need syncing
    func syncWardrobeItems(userId: UUID) async throws -> SyncResult
    
    /// Sync outfits that need syncing
    func syncOutfits(userId: UUID) async throws -> SyncResult
    
    /// Sync planner entries that need syncing
    func syncPlannerEntries(userId: UUID) async throws -> SyncResult
    
    /// Sync user preferences
    func syncUserPreferences(userId: UUID) async throws -> SyncResult
    
    /// Sync all data for a user
    func syncAll(userId: UUID) async throws -> SyncResult
    
    /// Check if there are pending changes to sync
    func hasPendingChanges() async -> Bool
}

// MARK: - Sync Result

struct SyncResult: Equatable, Sendable {
    let itemsSynced: Int
    let itemsFailed: Int
    let errors: [SyncError]
    
    var success: Bool {
        itemsFailed == 0 && errors.isEmpty
    }
}

// MARK: - Dependency Key

private enum SyncServiceKey: DependencyKey {
    static let liveValue: SyncService = LiveSyncService()
    static let testValue: SyncService = MockSyncService()
}

extension DependencyValues {
    var syncService: SyncService {
        get { self[SyncServiceKey.self] }
        set { self[SyncServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveSyncService: SyncService {
    func syncWardrobeItems(userId: UUID) async throws -> SyncResult {
        // TODO: Implement SwiftData query for items with needsSync = true
        // TODO: Upload to Supabase via DatabaseService
        // TODO: Update local items to mark as synced
        SyncResult(itemsSynced: 0, itemsFailed: 0, errors: [])
    }
    
    func syncOutfits(userId: UUID) async throws -> SyncResult {
        // TODO: Implement outfit sync
        SyncResult(itemsSynced: 0, itemsFailed: 0, errors: [])
    }
    
    func syncPlannerEntries(userId: UUID) async throws -> SyncResult {
        // TODO: Implement planner entry sync
        SyncResult(itemsSynced: 0, itemsFailed: 0, errors: [])
    }
    
    func syncUserPreferences(userId: UUID) async throws -> SyncResult {
        // TODO: Implement preferences sync
        SyncResult(itemsSynced: 0, itemsFailed: 0, errors: [])
    }
    
    func syncAll(userId: UUID) async throws -> SyncResult {
        // TODO: Sync all data types
        // TODO: Aggregate results
        SyncResult(itemsSynced: 0, itemsFailed: 0, errors: [])
    }
    
    func hasPendingChanges() async -> Bool {
        // TODO: Query SwiftData for any items with needsSync = true
        false
    }
}

// MARK: - Mock Implementation

final class MockSyncService: SyncService {
    var pendingChanges = false
    var shouldThrowError = false
    var errorToThrow: SyncError = .networkError
    var syncDelay: UInt64 = 200_000_000 // 0.2s default
    
    // Track sync calls for testing
    var wardrobeItemsSyncCount = 0
    var outfitsSyncCount = 0
    var plannerEntriesSyncCount = 0
    var preferencesSyncCount = 0
    
    func syncWardrobeItems(userId: UUID) async throws -> SyncResult {
        try await Task.sleep(nanoseconds: syncDelay)
        wardrobeItemsSyncCount += 1
        
        if shouldThrowError {
            return SyncResult(itemsSynced: 0, itemsFailed: 5, errors: [errorToThrow])
        }
        
        return SyncResult(itemsSynced: 5, itemsFailed: 0, errors: [])
    }
    
    func syncOutfits(userId: UUID) async throws -> SyncResult {
        try await Task.sleep(nanoseconds: syncDelay)
        outfitsSyncCount += 1
        
        if shouldThrowError {
            return SyncResult(itemsSynced: 0, itemsFailed: 3, errors: [errorToThrow])
        }
        
        return SyncResult(itemsSynced: 3, itemsFailed: 0, errors: [])
    }
    
    func syncPlannerEntries(userId: UUID) async throws -> SyncResult {
        try await Task.sleep(nanoseconds: syncDelay)
        plannerEntriesSyncCount += 1
        
        if shouldThrowError {
            return SyncResult(itemsSynced: 0, itemsFailed: 2, errors: [errorToThrow])
        }
        
        return SyncResult(itemsSynced: 2, itemsFailed: 0, errors: [])
    }
    
    func syncUserPreferences(userId: UUID) async throws -> SyncResult {
        try await Task.sleep(nanoseconds: syncDelay)
        preferencesSyncCount += 1
        
        if shouldThrowError {
            return SyncResult(itemsSynced: 0, itemsFailed: 1, errors: [errorToThrow])
        }
        
        return SyncResult(itemsSynced: 1, itemsFailed: 0, errors: [])
    }
    
    func syncAll(userId: UUID) async throws -> SyncResult {
        let wardrobeResult = try await syncWardrobeItems(userId: userId)
        let outfitsResult = try await syncOutfits(userId: userId)
        let plannerResult = try await syncPlannerEntries(userId: userId)
        let prefsResult = try await syncUserPreferences(userId: userId)
        
        let totalSynced = wardrobeResult.itemsSynced + outfitsResult.itemsSynced +
                         plannerResult.itemsSynced + prefsResult.itemsSynced
        let totalFailed = wardrobeResult.itemsFailed + outfitsResult.itemsFailed +
                         plannerResult.itemsFailed + prefsResult.itemsFailed
        let allErrors = wardrobeResult.errors + outfitsResult.errors +
                       plannerResult.errors + prefsResult.errors
        
        return SyncResult(itemsSynced: totalSynced, itemsFailed: totalFailed, errors: allErrors)
    }
    
    func hasPendingChanges() async -> Bool {
        pendingChanges
    }
}

// MARK: - Errors

enum SyncError: Error, Equatable, Sendable {
    case networkError
    case conflict
    case unauthorized
    case dataCorrupted
    case quotaExceeded
}

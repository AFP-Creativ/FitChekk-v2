//
//  DatabaseService.swift
//  FitChekk-v2
//
//  Database service protocol and mock implementation
//  Real implementation will use SwiftData + Supabase
//

import Foundation

// MARK: - Protocol

protocol DatabaseServiceProtocol {
    func fetchWardrobeItems() async throws -> [WardrobeItem]
    func fetchOutfits() async throws -> [Outfit]
    func saveItem(_ item: WardrobeItem) async throws
    func saveOutfit(_ outfit: Outfit) async throws
    func deleteItem(_ id: UUID) async throws
    func deleteOutfit(_ id: UUID) async throws
}

// MARK: - Mock Implementation

class MockDatabaseService: DatabaseServiceProtocol {
    private var items: [WardrobeItem] = PreviewData.wardrobeItems
    private var outfits: [Outfit] = PreviewData.outfits

    func fetchWardrobeItems() async throws -> [WardrobeItem] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return items
    }

    func fetchOutfits() async throws -> [Outfit] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return outfits
    }

    func saveItem(_ item: WardrobeItem) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func saveOutfit(_ outfit: Outfit) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
        } else {
            outfits.append(outfit)
        }
    }

    func deleteItem(_ id: UUID) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        items.removeAll { $0.id == id }
    }

    func deleteOutfit(_ id: UUID) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        outfits.removeAll { $0.id == id }
    }
}

// MARK: - Shared Instance for Previews

extension MockDatabaseService {
    static let shared = MockDatabaseService()
}

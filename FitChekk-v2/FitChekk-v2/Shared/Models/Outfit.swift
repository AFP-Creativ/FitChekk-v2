//
//  Outfit.swift
//  FitChekk-v2
//
//  Model representing an outfit combination
//

import Foundation

enum OutfitOccasion: String, Codable, CaseIterable {
    case casual = "Casual"
    case work = "Work"
    case formal = "Formal"
    case date = "Date Night"
    case athletic = "Athletic"
    case travel = "Travel"
    case party = "Party"
    case outdoor = "Outdoor"
    case everyday = "Everyday"
}

struct Outfit: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var itemIDs: [UUID] // References to WardrobeItem IDs
    var occasion: OutfitOccasion?
    var season: Season?

    // AI-generated data
    var aiGenerated: Bool
    var aiReasoning: String? // Why this outfit works

    // User data
    var userRating: Int? // 1-5 stars
    var timesWorn: Int
    var lastWornDate: Date?
    var isFavorite: Bool
    var notes: String?

    // Sync
    var needsSync: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        itemIDs: [UUID],
        occasion: OutfitOccasion? = nil,
        season: Season? = nil,
        aiGenerated: Bool = false,
        aiReasoning: String? = nil,
        userRating: Int? = nil,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        isFavorite: Bool = false,
        notes: String? = nil,
        needsSync: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.itemIDs = itemIDs
        self.occasion = occasion
        self.season = season
        self.aiGenerated = aiGenerated
        self.aiReasoning = aiReasoning
        self.userRating = userRating
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.isFavorite = isFavorite
        self.notes = notes
        self.needsSync = needsSync
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // Helper to get items (requires wardrobe context)
    func items(from wardrobe: [WardrobeItem]) -> [WardrobeItem] {
        wardrobe.filter { itemIDs.contains($0.id) }
    }
}

// MARK: - Mock Extension

extension Outfit {
    static func mock(
        name: String = "Sample Outfit",
        itemIDs: [UUID] = [],
        occasion: OutfitOccasion? = .casual,
        aiGenerated: Bool = false,
        aiReasoning: String? = nil,
        timesWorn: Int = 0,
        isFavorite: Bool = false
    ) -> Outfit {
        Outfit(
            name: name,
            itemIDs: itemIDs,
            occasion: occasion,
            aiGenerated: aiGenerated,
            aiReasoning: aiReasoning,
            timesWorn: timesWorn,
            isFavorite: isFavorite
        )
    }
}

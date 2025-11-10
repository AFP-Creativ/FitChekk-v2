//
//  WardrobeItem.swift
//  FitChekk-v2
//
//  Model representing a single wardrobe item
//

import Foundation

struct WardrobeItem: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var subcategory: String?
    var brand: String?
    var purchaseDate: Date?
    var price: Double?

    // AI-generated attributes
    var colors: [ItemColor]
    var pattern: Pattern
    var formality: Formality
    var seasons: [Season]
    var styleTags: [String] // e.g., "minimalist", "bohemian", "preppy"

    // Images
    var imagePath: String? // Path to full image
    var thumbnailPath: String? // Path to thumbnail

    // User data
    var isFavorite: Bool
    var isArchived: Bool
    var timesWorn: Int
    var lastWornDate: Date?
    var notes: String?

    // Sync
    var needsSync: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        category: ItemCategory,
        subcategory: String? = nil,
        brand: String? = nil,
        purchaseDate: Date? = nil,
        price: Double? = nil,
        colors: [ItemColor] = [],
        pattern: Pattern = .solid,
        formality: Formality = .casual,
        seasons: [Season] = [.allSeason],
        styleTags: [String] = [],
        imagePath: String? = nil,
        thumbnailPath: String? = nil,
        isFavorite: Bool = false,
        isArchived: Bool = false,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        notes: String? = nil,
        needsSync: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.subcategory = subcategory
        self.brand = brand
        self.purchaseDate = purchaseDate
        self.price = price
        self.colors = colors
        self.pattern = pattern
        self.formality = formality
        self.seasons = seasons
        self.styleTags = styleTags
        self.imagePath = imagePath
        self.thumbnailPath = thumbnailPath
        self.isFavorite = isFavorite
        self.isArchived = isArchived
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.notes = notes
        self.needsSync = needsSync
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // Computed properties
    var costPerWear: Double? {
        guard let price = price, timesWorn > 0 else { return nil }
        return price / Double(timesWorn)
    }

    var primaryColor: ItemColor {
        colors.first ?? .black
    }

    var displayName: String {
        if name.isEmpty {
            return "\(primaryColor.rawValue) \(subcategory ?? category.rawValue)"
        }
        return name
    }
}

// MARK: - Mock Extension

extension WardrobeItem {
    static func mock(
        name: String = "Sample Item",
        category: ItemCategory = .tops,
        subcategory: String? = nil,
        colors: [ItemColor] = [.blue],
        pattern: Pattern = .solid,
        formality: Formality = .casual,
        seasons: [Season] = [.allSeason],
        isFavorite: Bool = false,
        timesWorn: Int = 0
    ) -> WardrobeItem {
        WardrobeItem(
            name: name,
            category: category,
            subcategory: subcategory,
            colors: colors,
            pattern: pattern,
            formality: formality,
            seasons: seasons,
            isFavorite: isFavorite,
            timesWorn: timesWorn
        )
    }
}

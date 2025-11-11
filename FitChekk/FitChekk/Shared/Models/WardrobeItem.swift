import Foundation
import SwiftData

@Model
final class WardrobeItem {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Foreign Key
    var userId: UUID
    
    // MARK: - Basic Info
    var name: String?
    var category: String  // Store as String, use computed property for enum
    var subCategory: String  // Store as String, use computed property for enum
    var brand: String?
    var purchaseDate: Date?
    var purchasePrice: Double?
    
    // MARK: - Images
    var imageURL: String?
    var thumbnailURL: String?
    
    // MARK: - AI Attributes
    var aiGenerated: Bool
    var colors: [String]
    var pattern: String?
    var formality: Int  // 1-5, use computed property for enum
    var styleTags: [String]
    var seasons: [String]  // Store as [String], use computed property for [Season]
    var materialType: String?
    var aiConfidence: Double  // 0.0-1.0
    
    // MARK: - User Metadata
    var isFavorite: Bool
    var notes: String?
    var isArchived: Bool
    
    // MARK: - Usage Stats
    var timesWorn: Int
    var lastWornDate: Date?
    
    // MARK: - Sync
    var needsSync: Bool
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        userId: UUID,
        name: String? = nil,
        category: ItemCategory,
        subCategory: ItemSubCategory,
        brand: String? = nil,
        purchaseDate: Date? = nil,
        purchasePrice: Double? = nil,
        imageURL: String? = nil,
        thumbnailURL: String? = nil,
        aiGenerated: Bool = false,
        colors: [String] = [],
        pattern: String? = nil,
        formality: FormalityLevel = .casual,
        styleTags: [String] = [],
        seasons: [Season] = [],
        materialType: String? = nil,
        aiConfidence: Double = 0.0,
        isFavorite: Bool = false,
        notes: String? = nil,
        isArchived: Bool = false,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        needsSync: Bool = false
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        self.name = name
        self.category = category.rawValue
        self.subCategory = subCategory.rawValue
        self.brand = brand
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
        self.imageURL = imageURL
        self.thumbnailURL = thumbnailURL
        self.aiGenerated = aiGenerated
        self.colors = colors
        self.pattern = pattern
        self.formality = formality.rawValue
        self.styleTags = styleTags
        self.seasons = seasons.map { $0.rawValue }
        self.materialType = materialType
        self.aiConfidence = aiConfidence
        self.isFavorite = isFavorite
        self.notes = notes
        self.isArchived = isArchived
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.needsSync = needsSync
    }
    
    // MARK: - Computed Properties
    var categoryEnum: ItemCategory {
        ItemCategory(rawValue: category) ?? .tops
    }
    
    var subCategoryEnum: ItemSubCategory {
        ItemSubCategory(rawValue: subCategory) ?? .basicTees
    }
    
    var formalityEnum: FormalityLevel {
        FormalityLevel(rawValue: formality) ?? .casual
    }
    
    var seasonsEnum: [Season] {
        seasons.compactMap { Season(rawValue: $0) }
    }
    
    var displayName: String {
        if let name = name, !name.isEmpty {
            return name
        }
        let colorPrefix = colors.first?.capitalized ?? ""
        let subCatName = subCategory.camelCaseToWords()
        return colorPrefix.isEmpty ? subCatName : "\(colorPrefix) \(subCatName)"
    }
    
    var displayPrice: String? {
        guard let price = purchasePrice else { return nil }
        return String(format: "$%.2f", price)
    }
    
    var isRecentlyWorn: Bool {
        guard let lastWorn = lastWornDate else { return false }
        let daysSinceWorn = Calendar.current.dateComponents([.day], from: lastWorn, to: Date()).day ?? 999
        return daysSinceWorn <= 7
    }
    
    var isPopular: Bool {
        timesWorn >= 5
    }
    
    var confidenceLevel: String {
        switch aiConfidence {
        case 0.8...1.0: return "High"
        case 0.5..<0.8: return "Medium"
        default: return "Low"
        }
    }
}

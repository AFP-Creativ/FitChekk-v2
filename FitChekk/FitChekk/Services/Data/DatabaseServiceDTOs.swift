//
//  DatabaseServiceDTOs.swift
//  FitChekk
//
//  Data transfer objects for database service
//

import Foundation

// MARK: - Wardrobe Item DTO

struct WardrobeItemDTO: Codable {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var userId: UUID
    var name: String?
    var category: String
    var subCategory: String
    var brand: String?
    var purchaseDate: Date?
    var purchasePrice: Double?
    var imageURL: String?
    var thumbnailURL: String?
    var aiGenerated: Bool
    var colors: [String]
    var pattern: String?
    var formality: Int
    var styleTags: [String]
    var seasons: [String]
    var materialType: String?
    var aiConfidence: Double
    var isFavorite: Bool
    var notes: String?
    var isArchived: Bool
    var timesWorn: Int
    var lastWornDate: Date?
    var needsSync: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case name
        case category
        case subCategory = "sub_category"
        case brand
        case purchaseDate = "purchase_date"
        case purchasePrice = "purchase_price"
        case imageURL = "image_url"
        case thumbnailURL = "thumbnail_url"
        case aiGenerated = "ai_generated"
        case colors
        case pattern
        case formality
        case styleTags = "style_tags"
        case seasons
        case materialType = "material_type"
        case aiConfidence = "ai_confidence"
        case isFavorite = "is_favorite"
        case notes
        case isArchived = "is_archived"
        case timesWorn = "times_worn"
        case lastWornDate = "last_worn_date"
        case needsSync = "needs_sync"
    }

    init(from item: WardrobeItem) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.updatedAt = item.updatedAt
        self.userId = item.userId
        self.name = item.name
        self.category = item.category
        self.subCategory = item.subCategory
        self.brand = item.brand
        self.purchaseDate = item.purchaseDate
        self.purchasePrice = item.purchasePrice
        self.imageURL = item.imageURL
        self.thumbnailURL = item.thumbnailURL
        self.aiGenerated = item.aiGenerated
        self.colors = item.colors
        self.pattern = item.pattern
        self.formality = item.formality
        self.styleTags = item.styleTags
        self.seasons = item.seasons
        self.materialType = item.materialType
        self.aiConfidence = item.aiConfidence
        self.isFavorite = item.isFavorite
        self.notes = item.notes
        self.isArchived = item.isArchived
        self.timesWorn = item.timesWorn
        self.lastWornDate = item.lastWornDate
        self.needsSync = item.needsSync
    }

    func toWardrobeItem() -> WardrobeItem {
        // Create item with rawValues since SwiftData model expects enums
        let categoryEnum = ItemCategory(rawValue: category) ?? .tops
        let subCategoryEnum = ItemSubCategory(rawValue: subCategory) ?? .basicTees
        let formalityEnum = FormalityLevel(rawValue: formality) ?? .casual
        let seasonsEnum = seasons.compactMap { Season(rawValue: $0) }

        let item = WardrobeItem(
            id: id,
            userId: userId,
            name: name,
            category: categoryEnum,
            subCategory: subCategoryEnum,
            brand: brand,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            imageURL: imageURL,
            thumbnailURL: thumbnailURL,
            aiGenerated: aiGenerated,
            colors: colors,
            pattern: pattern,
            formality: formalityEnum,
            styleTags: styleTags,
            seasons: seasonsEnum,
            materialType: materialType,
            aiConfidence: aiConfidence,
            isFavorite: isFavorite,
            notes: notes,
            isArchived: isArchived,
            timesWorn: timesWorn,
            lastWornDate: lastWornDate,
            needsSync: needsSync
        )

        // Override dates from server
        item.createdAt = createdAt
        item.updatedAt = updatedAt

        return item
    }
}

// MARK: - Outfit DTO

struct OutfitDTO: Codable {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var userId: UUID
    var name: String
    var itemIds: [UUID]
    var occasion: String?
    var season: String?
    var notes: String?
    var aiGenerated: Bool
    var aiReasoning: String?
    var aiStyleScore: Double?
    var weatherTempHigh: Int?
    var weatherTempLow: Int?
    var weatherCondition: String?
    var timesWorn: Int
    var lastWornDate: Date?
    var userRating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case name
        case itemIds = "item_ids"
        case occasion
        case season
        case notes
        case aiGenerated = "ai_generated"
        case aiReasoning = "ai_reasoning"
        case aiStyleScore = "ai_style_score"
        case weatherTempHigh = "weather_temp_high"
        case weatherTempLow = "weather_temp_low"
        case weatherCondition = "weather_condition"
        case timesWorn = "times_worn"
        case lastWornDate = "last_worn_date"
        case userRating = "user_rating"
    }
    
    init(from outfit: Outfit) {
        self.id = outfit.id
        self.createdAt = outfit.createdAt
        self.updatedAt = outfit.updatedAt
        self.userId = outfit.userId
        self.name = outfit.name
        self.itemIds = outfit.itemIds
        self.occasion = outfit.occasion
        self.season = outfit.season
        self.notes = outfit.notes
        self.aiGenerated = outfit.aiGenerated
        self.aiReasoning = outfit.aiReasoning
        self.aiStyleScore = outfit.aiStyleScore
        self.weatherTempHigh = outfit.weatherTempHigh
        self.weatherTempLow = outfit.weatherTempLow
        self.weatherCondition = outfit.weatherCondition
        self.timesWorn = outfit.timesWorn
        self.lastWornDate = outfit.lastWornDate
        self.userRating = outfit.userRating
    }
    
    func toOutfit() -> Outfit {
        let outfit = Outfit(
            id: id,
            userId: userId,
            name: name,
            occasion: occasion,
            season: season,
            notes: notes,
            aiGenerated: aiGenerated,
            aiReasoning: aiReasoning,
            aiStyleScore: aiStyleScore,
            weatherTempHigh: weatherTempHigh,
            weatherTempLow: weatherTempLow,
            weatherCondition: weatherCondition,
            timesWorn: timesWorn,
            lastWornDate: lastWornDate,
            userRating: userRating,
            itemIds: itemIds
        )
        
        // Override dates from server
        outfit.createdAt = createdAt
        outfit.updatedAt = updatedAt
        
        return outfit
    }
}

// MARK: - Planner Entry DTO

struct PlannerEntryDTO: Codable {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var userId: UUID
    var date: Date
    var outfitId: UUID?
    var isWorn: Bool
    var markedWornAt: Date?
    var weatherTempHigh: Int?
    var weatherTempLow: Int?
    var weatherCondition: String?
    var weatherFeelsLike: Int?
    var weatherHumidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case date
        case outfitId = "outfit_id"
        case isWorn = "is_worn"
        case markedWornAt = "marked_worn_at"
        case weatherTempHigh = "weather_temp_high"
        case weatherTempLow = "weather_temp_low"
        case weatherCondition = "weather_condition"
        case weatherFeelsLike = "weather_feels_like"
        case weatherHumidity = "weather_humidity"
    }
    
    init(from entry: PlannerEntry) {
        self.id = entry.id
        self.createdAt = entry.createdAt
        self.updatedAt = entry.updatedAt
        self.userId = entry.userId
        self.date = entry.date
        self.outfitId = entry.outfitId
        self.isWorn = entry.isWorn
        self.markedWornAt = entry.markedWornAt
        self.weatherTempHigh = entry.weatherTempHigh
        self.weatherTempLow = entry.weatherTempLow
        self.weatherCondition = entry.weatherCondition
        self.weatherFeelsLike = entry.weatherFeelsLike
        self.weatherHumidity = entry.weatherHumidity
    }
    
    func toPlannerEntry() -> PlannerEntry {
        let entry = PlannerEntry(
            id: id,
            userId: userId,
            date: date,
            outfitId: outfitId,
            isWorn: isWorn,
            markedWornAt: markedWornAt,
            weatherTempHigh: weatherTempHigh,
            weatherTempLow: weatherTempLow,
            weatherCondition: weatherCondition,
            weatherFeelsLike: weatherFeelsLike,
            weatherHumidity: weatherHumidity
        )
        
        // Override dates from server
        entry.createdAt = createdAt
        entry.updatedAt = updatedAt
        
        return entry
    }
}

// MARK: - User Preferences DTO

struct UserPreferencesDTO: Codable {
    var id: UUID
    var userId: UUID
    var createdAt: Date
    var updatedAt: Date
    var stylePreferences: [String]
    var favoriteColors: [String]
    var lifestyleType: String?
    var activityLevel: String?
    var occasions: [String]
    var climateType: String?
    var measurementSystem: String
    var enableNotifications: Bool
    var notificationTime: Date?
    var onboardingCompleted: Bool
    var needsSync: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case stylePreferences = "style_preferences"
        case favoriteColors = "favorite_colors"
        case lifestyleType = "lifestyle_type"
        case activityLevel = "activity_level"
        case occasions
        case climateType = "climate_type"
        case measurementSystem = "measurement_system"
        case enableNotifications = "enable_notifications"
        case notificationTime = "notification_time"
        case onboardingCompleted = "onboarding_completed"
        case needsSync = "needs_sync"
    }
    
    init(from preferences: UserPreferences) {
        self.id = preferences.id
        self.userId = preferences.userId
        self.createdAt = preferences.createdAt
        self.updatedAt = preferences.updatedAt
        self.stylePreferences = preferences.stylePreferences
        self.favoriteColors = preferences.favoriteColors
        self.lifestyleType = preferences.lifestyleType
        self.activityLevel = preferences.activityLevel
        self.occasions = preferences.occasions
        self.climateType = preferences.climateType
        self.measurementSystem = preferences.measurementSystem
        self.enableNotifications = preferences.enableNotifications
        self.notificationTime = preferences.notificationTime
        self.onboardingCompleted = preferences.onboardingCompleted
        self.needsSync = preferences.needsSync
    }
    
    func toUserPreferences() -> UserPreferences {
        let prefs = UserPreferences(
            id: id,
            userId: userId,
            stylePreferences: stylePreferences,
            favoriteColors: favoriteColors,
            lifestyleType: lifestyleType,
            activityLevel: activityLevel,
            occasions: occasions,
            climateType: climateType,
            measurementSystem: measurementSystem,
            enableNotifications: enableNotifications,
            notificationTime: notificationTime,
            onboardingCompleted: onboardingCompleted,
            needsSync: needsSync
        )
        
        // Override dates from server
        prefs.createdAt = createdAt
        prefs.updatedAt = updatedAt
        
        return prefs
    }
}

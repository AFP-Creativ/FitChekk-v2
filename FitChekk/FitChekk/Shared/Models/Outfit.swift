import Foundation
import SwiftData

@Model
final class Outfit: @unchecked Sendable {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Foreign Key
    var userId: UUID
    
    // MARK: - Basic Info
    var name: String
    var occasion: String?
    var season: String?
    var notes: String?
    
    // MARK: - AI Attributes
    var aiGenerated: Bool
    var aiReasoning: String?
    var aiStyleScore: Double?  // 0.0-1.0
    
    // MARK: - Weather Snapshot
    var weatherTempHigh: Int?
    var weatherTempLow: Int?
    var weatherCondition: String?
    
    // MARK: - Usage Stats
    var timesWorn: Int
    var lastWornDate: Date?
    var userRating: Int?  // 1-5
    
    // MARK: - Item References
    var itemIds: [UUID]
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        userId: UUID,
        name: String,
        occasion: String? = nil,
        season: String? = nil,
        notes: String? = nil,
        aiGenerated: Bool = false,
        aiReasoning: String? = nil,
        aiStyleScore: Double? = nil,
        weatherTempHigh: Int? = nil,
        weatherTempLow: Int? = nil,
        weatherCondition: String? = nil,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        userRating: Int? = nil,
        itemIds: [UUID] = []
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        self.name = name
        self.occasion = occasion
        self.season = season
        self.notes = notes
        self.aiGenerated = aiGenerated
        self.aiReasoning = aiReasoning
        self.aiStyleScore = aiStyleScore
        self.weatherTempHigh = weatherTempHigh
        self.weatherTempLow = weatherTempLow
        self.weatherCondition = weatherCondition
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.userRating = userRating
        self.itemIds = itemIds
    }
    
    // MARK: - Computed Properties
    var seasonEnum: Season? {
        guard let season = season else { return nil }
        return Season(rawValue: season)
    }
    
    var itemCount: Int {
        itemIds.count
    }
    
    var hasWeatherData: Bool {
        weatherTempHigh != nil || weatherTempLow != nil || weatherCondition != nil
    }
    
    var weatherSummary: String? {
        guard hasWeatherData else { return nil }
        
        var parts: [String] = []
        if let high = weatherTempHigh, let low = weatherTempLow {
            parts.append("\(high)°/\(low)°")
        } else if let high = weatherTempHigh {
            parts.append("\(high)°")
        }
        
        if let condition = weatherCondition {
            parts.append(condition)
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
    
    var isRecentlyWorn: Bool {
        guard let lastWorn = lastWornDate else { return false }
        let daysSinceWorn = Calendar.current.dateComponents([.day], from: lastWorn, to: Date()).day ?? 999
        return daysSinceWorn <= 7
    }
    
    var isPopular: Bool {
        timesWorn >= 3
    }
    
    var hasHighRating: Bool {
        guard let rating = userRating else { return false }
        return rating >= 4
    }
    
    var styleScoreDisplay: String? {
        guard let score = aiStyleScore else { return nil }
        return String(format: "%.0f%%", score * 100)
    }
}

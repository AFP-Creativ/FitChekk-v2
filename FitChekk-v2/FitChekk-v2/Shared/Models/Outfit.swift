//
//  Outfit.swift
//  FitChekk-v2
//
//  Model for outfit combinations
//

import Foundation

enum OccasionType: String, Codable, CaseIterable, Identifiable {
    case work, casual, date, athletic, formal, travel, weekend
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .work: return "briefcase"
        case .casual: return "figure.walk"
        case .date: return "heart"
        case .athletic: return "figure.run"
        case .formal: return "suit.club"
        case .travel: return "airplane"
        case .weekend: return "sun.max"
        }
    }
}

struct WeatherSnapshot: Codable, Equatable {
    var date: Date
    var tempHigh: Double
    var tempLow: Double
    var condition: String
    var feelsLike: Double
    var humidity: Double
    
    var displayTemp: String {
        "\(Int(tempHigh))°"
    }
    
    var conditionIcon: String {
        switch condition.lowercased() {
        case let c where c.contains("rain"): return "cloud.rain"
        case let c where c.contains("cloud"): return "cloud"
        case let c where c.contains("sun"), let c where c.contains("clear"): return "sun.max"
        case let c where c.contains("snow"): return "snow"
        case let c where c.contains("wind"): return "wind"
        default: return "cloud.sun"
        }
    }
}

struct Outfit: Identifiable, Codable, Equatable {
    // Identity
    let id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // Basic Info
    var name: String
    var occasion: OccasionType?
    var season: Season?
    var notes: String?
    
    // Images (mock)
    var imageName: String?
    
    // AI Metadata
    var aiGenerated: Bool
    var aiReasoning: String?
    var aiStyleScore: Double?
    var weatherSnapshot: WeatherSnapshot?
    
    // Usage
    var timesWorn: Int
    var lastWornDate: Date?
    var userRating: Int? // 1-5 stars
    
    // Relationships (item IDs)
    var itemIds: [UUID]
    
    // Sync
    var userId: UUID
    var needsSync: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        occasion: OccasionType? = nil,
        season: Season? = nil,
        notes: String? = nil,
        imageName: String? = nil,
        aiGenerated: Bool = false,
        aiReasoning: String? = nil,
        aiStyleScore: Double? = nil,
        weatherSnapshot: WeatherSnapshot? = nil,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        userRating: Int? = nil,
        itemIds: [UUID] = [],
        userId: UUID = UUID(),
        needsSync: Bool = false
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.name = name
        self.occasion = occasion
        self.season = season
        self.notes = notes
        self.imageName = imageName
        self.aiGenerated = aiGenerated
        self.aiReasoning = aiReasoning
        self.aiStyleScore = aiStyleScore
        self.weatherSnapshot = weatherSnapshot
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.userRating = userRating
        self.itemIds = itemIds
        self.userId = userId
        self.needsSync = needsSync
    }
}


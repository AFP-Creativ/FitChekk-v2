//
//  PlannerEntry.swift
//  FitChekk-v2
//
//  Calendar planner entry model
//

import Foundation

struct PlannerEntry: Identifiable, Codable, Equatable {
    // Date is normalized to 00:00:00
    let date: Date
    
    var id: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
    
    // Relationships
    var outfitId: UUID?
    
    // Metadata
    var isWorn: Bool
    var markedWornAt: Date?
    var notes: String?
    
    // Weather Cache
    var cachedWeather: WeatherSnapshot?
    
    // Sync
    var userId: UUID
    var needsSync: Bool
    
    init(
        date: Date,
        outfitId: UUID? = nil,
        isWorn: Bool = false,
        markedWornAt: Date? = nil,
        notes: String? = nil,
        cachedWeather: WeatherSnapshot? = nil,
        userId: UUID = UUID(),
        needsSync: Bool = false
    ) {
        // Normalize to start of day
        self.date = Calendar.current.startOfDay(for: date)
        self.outfitId = outfitId
        self.isWorn = isWorn
        self.markedWornAt = markedWornAt
        self.notes = notes
        self.cachedWeather = cachedWeather
        self.userId = userId
        self.needsSync = needsSync
    }
}


import Foundation
import SwiftData

@Model
final class PlannerEntry: @unchecked Sendable {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Foreign Keys
    var userId: UUID
    var outfitId: UUID?  // Optional reference to Outfit

    // MARK: - Basic Info
    var date: Date  // The planned date (unique per user in database)

    // MARK: - Status
    var isWorn: Bool
    var markedWornAt: Date?

    // MARK: - Cached Weather
    var weatherTempHigh: Int?
    var weatherTempLow: Int?
    var weatherCondition: String?
    var weatherFeelsLike: Int?
    var weatherHumidity: Int?

    // MARK: - Init
    init(
        id: UUID = UUID(),
        userId: UUID,
        date: Date,
        outfitId: UUID? = nil,
        isWorn: Bool = false,
        markedWornAt: Date? = nil,
        weatherTempHigh: Int? = nil,
        weatherTempLow: Int? = nil,
        weatherCondition: String? = nil,
        weatherFeelsLike: Int? = nil,
        weatherHumidity: Int? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        self.date = date
        self.outfitId = outfitId
        self.isWorn = isWorn
        self.markedWornAt = markedWornAt
        self.weatherTempHigh = weatherTempHigh
        self.weatherTempLow = weatherTempLow
        self.weatherCondition = weatherCondition
        self.weatherFeelsLike = weatherFeelsLike
        self.weatherHumidity = weatherHumidity
    }

    // MARK: - Computed Properties
    var hasOutfit: Bool {
        outfitId != nil
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

        if let feelsLike = weatherFeelsLike {
            parts.append("Feels like \(feelsLike)°")
        }

        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    var isFuture: Bool {
        Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
    }

    var isPast: Bool {
        Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending
    }

    var displayDate: String {
        let formatter = DateFormatter()
        if isToday {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }

    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full day name
        return formatter.string(from: date)
    }
}

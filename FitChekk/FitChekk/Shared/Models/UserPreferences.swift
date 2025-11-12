import Foundation
import SwiftData

@Model
final class UserPreferences: @unchecked Sendable {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Foreign Key
    var userId: UUID

    // MARK: - Style Preferences
    var stylePreferences: [String]
    var favoriteColors: [String]
    var lifestyleType: String?
    var activityLevel: String?
    var occasions: [String]
    var climateType: String?

    // MARK: - App Settings
    var measurementSystem: String  // 'imperial' or 'metric'
    var enableNotifications: Bool
    var notificationTime: Date?  // Store as Date, extract time component when needed

    // MARK: - Onboarding
    var onboardingCompleted: Bool

    // MARK: - Sync
    var needsSync: Bool

    // MARK: - Init
    init(
        id: UUID = UUID(),
        userId: UUID,
        stylePreferences: [String] = [],
        favoriteColors: [String] = [],
        lifestyleType: String? = nil,
        activityLevel: String? = nil,
        occasions: [String] = [],
        climateType: String? = nil,
        measurementSystem: String = "imperial",
        enableNotifications: Bool = true,
        notificationTime: Date? = nil,
        onboardingCompleted: Bool = false,
        needsSync: Bool = false
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        self.stylePreferences = stylePreferences
        self.favoriteColors = favoriteColors
        self.lifestyleType = lifestyleType
        self.activityLevel = activityLevel
        self.occasions = occasions
        self.climateType = climateType
        self.measurementSystem = measurementSystem
        self.enableNotifications = enableNotifications
        self.notificationTime = notificationTime
        self.onboardingCompleted = onboardingCompleted
        self.needsSync = needsSync
    }

    // MARK: - Computed Properties
    var isMetric: Bool {
        measurementSystem == "metric"
    }

    var hasStylePreferences: Bool {
        !stylePreferences.isEmpty || !favoriteColors.isEmpty
    }

    var displayLifestyleType: String {
        lifestyleType?.capitalized ?? "Not set"
    }

    var displayActivityLevel: String {
        activityLevel?.capitalized ?? "Not set"
    }
}

//
//  User.swift
//  FitChekk-v2
//
//  User profile and preferences model
//

import Foundation

enum SubscriptionTier: String, Codable {
    case free = "Free"
    case premium = "Premium"

    var itemLimit: Int? {
        switch self {
        case .free: return 50
        case .premium: return nil // Unlimited
        }
    }

    var hasAICategorization: Bool {
        self == .premium
    }

    var hasAISuggestions: Bool {
        self == .premium
    }

    var hasOutfitCreation: Bool {
        self == .premium
    }

    var hasCalendarPlanning: Bool {
        self == .premium
    }
}

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var email: String
    var displayName: String
    var photoURL: String?

    // Subscription
    var subscriptionTier: SubscriptionTier
    var subscriptionExpiryDate: Date?

    // Preferences
    var preferences: StylePreferences

    // Settings
    var notificationsEnabled: Bool
    var notificationTime: Date? // Daily notification time
    var usesMetricUnits: Bool
    var allowsBackgroundRemoval: Bool
    var allowsAIPersonalization: Bool

    // Metadata
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        email: String,
        displayName: String,
        photoURL: String? = nil,
        subscriptionTier: SubscriptionTier = .free,
        subscriptionExpiryDate: Date? = nil,
        preferences: StylePreferences = StylePreferences(),
        notificationsEnabled: Bool = true,
        notificationTime: Date? = nil,
        usesMetricUnits: Bool = false,
        allowsBackgroundRemoval: Bool = true,
        allowsAIPersonalization: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.subscriptionTier = subscriptionTier
        self.subscriptionExpiryDate = subscriptionExpiryDate
        self.preferences = preferences
        self.notificationsEnabled = notificationsEnabled
        self.notificationTime = notificationTime
        self.usesMetricUnits = usesMetricUnits
        self.allowsBackgroundRemoval = allowsBackgroundRemoval
        self.allowsAIPersonalization = allowsAIPersonalization
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var isPremium: Bool {
        subscriptionTier == .premium
    }

    var isSubscriptionActive: Bool {
        guard let expiryDate = subscriptionExpiryDate else {
            return subscriptionTier == .free
        }
        return expiryDate > Date()
    }
}

// MARK: - Style Preferences

struct StylePreferences: Codable, Equatable {
    var favoriteColors: [ItemColor]
    var favoriteStyles: [String] // e.g., "minimalist", "bohemian", "preppy"
    var lifestyleActivities: [String] // e.g., "office work", "gym", "outdoor activities"
    var preferredOccasions: [OutfitOccasion]
    var climateZone: String? // e.g., "temperate", "tropical", "cold"

    init(
        favoriteColors: [ItemColor] = [],
        favoriteStyles: [String] = [],
        lifestyleActivities: [String] = [],
        preferredOccasions: [OutfitOccasion] = [],
        climateZone: String? = nil
    ) {
        self.favoriteColors = favoriteColors
        self.favoriteStyles = favoriteStyles
        self.lifestyleActivities = lifestyleActivities
        self.preferredOccasions = preferredOccasions
        self.climateZone = climateZone
    }
}

// MARK: - Mock Extension

extension User {
    static func mockFree(name: String = "Alex Johnson") -> User {
        User(
            email: "alex@example.com",
            displayName: name,
            subscriptionTier: .free,
            preferences: StylePreferences(
                favoriteColors: [.blue, .black, .gray],
                favoriteStyles: ["minimalist", "casual"],
                lifestyleActivities: ["office work", "weekend casual"],
                preferredOccasions: [.casual, .work]
            )
        )
    }

    static func mockPremium(name: String = "Jordan Smith") -> User {
        User(
            email: "jordan@example.com",
            displayName: name,
            subscriptionTier: .premium,
            subscriptionExpiryDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()),
            preferences: StylePreferences(
                favoriteColors: [.navy, .white, .beige],
                favoriteStyles: ["smart casual", "preppy", "minimalist"],
                lifestyleActivities: ["office work", "gym", "social events"],
                preferredOccasions: [.casual, .work, .formal, .date],
                climateZone: "temperate"
            )
        )
    }
}

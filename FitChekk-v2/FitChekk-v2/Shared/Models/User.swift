//
//  User.swift
//  FitChekk-v2
//
//  User model and preferences
//

import Foundation

enum SubscriptionTier: String, Codable {
    case free
    case premium
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var canUseAI: Bool {
        self == .premium
    }
    
    var itemLimit: Int? {
        self == .free ? 50 : nil
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    var email: String?
    var displayName: String?
    var subscriptionTier: SubscriptionTier
    var subscriptionEndsAt: Date?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        email: String? = nil,
        displayName: String? = nil,
        subscriptionTier: SubscriptionTier = .free
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.subscriptionTier = subscriptionTier
        self.subscriptionEndsAt = subscriptionTier == .premium ? Calendar.current.date(byAdding: .month, value: 1, to: Date()) : nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct UserPreferences: Codable {
    var userId: UUID
    
    // Style quiz results
    var stylePreferences: [String] // ["minimalist", "classic"]
    var favoriteColors: [String] // ["navy", "white", "camel"]
    var lifestyleType: String?
    var activityLevel: String?
    var occasions: [String] // ["work", "casual", "date"]
    var climateType: String?
    
    // Location
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    
    // Settings
    var useBackgroundRemoval: Bool
    var useMetric: Bool
    var notificationsEnabled: Bool
    var notificationTime: Date?
    
    // Onboarding
    var onboardingCompleted: Bool
    
    init(
        userId: UUID = UUID(),
        stylePreferences: [String] = [],
        favoriteColors: [String] = [],
        lifestyleType: String? = nil,
        activityLevel: String? = nil,
        occasions: [String] = [],
        climateType: String? = nil,
        onboardingCompleted: Bool = false
    ) {
        self.userId = userId
        self.stylePreferences = stylePreferences
        self.favoriteColors = favoriteColors
        self.lifestyleType = lifestyleType
        self.activityLevel = activityLevel
        self.occasions = occasions
        self.climateType = climateType
        self.locationName = nil
        self.latitude = nil
        self.longitude = nil
        self.useBackgroundRemoval = true
        self.useMetric = false
        self.notificationsEnabled = false
        self.notificationTime = nil
        self.onboardingCompleted = onboardingCompleted
    }
}


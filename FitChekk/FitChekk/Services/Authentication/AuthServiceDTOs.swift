//
//  AuthServiceDTOs.swift
//  FitChekk
//
//  Data transfer objects for authentication service
//

import Foundation
import SwiftData

// MARK: - Data Transfer Objects

struct UserDTO: Codable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let email: String?
    let displayName: String?
    let subscriptionTier: String
    let subscriptionStatus: String?
    let trialEndsAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case email
        case displayName = "display_name"
        case subscriptionTier = "subscription_tier"
        case subscriptionStatus = "subscription_status"
        case trialEndsAt = "trial_ends_at"
    }
    
    func toUser() -> User {
        User(
            id: id,
            email: email,
            displayName: displayName,
            subscriptionTier: SubscriptionTier(rawValue: subscriptionTier) ?? .free,
            subscriptionStatus: subscriptionStatus.flatMap { SubscriptionStatus(rawValue: $0) },
            trialEndsAt: trialEndsAt
        )
    }
}

struct UserPreferencesDTO: Codable {
    let id: UUID
    let userId: UUID
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

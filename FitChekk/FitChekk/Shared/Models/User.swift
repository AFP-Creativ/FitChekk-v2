import Foundation
import SwiftData

@Model
final class User: @unchecked Sendable {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Profile
    var email: String?
    var displayName: String?

    // MARK: - Subscription
    var subscriptionTier: String  // Store as String, use computed property for enum
    var subscriptionStatus: String?  // Store as String, use computed property for enum
    var trialEndsAt: Date?

    // MARK: - Sync
    var needsSync: Bool

    // MARK: - Init
    init(
        id: UUID = UUID(),
        email: String? = nil,
        displayName: String? = nil,
        subscriptionTier: SubscriptionTier = .free,
        subscriptionStatus: SubscriptionStatus? = nil,
        trialEndsAt: Date? = nil,
        needsSync: Bool = false
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.email = email
        self.displayName = displayName
        self.subscriptionTier = subscriptionTier.rawValue
        self.subscriptionStatus = subscriptionStatus?.rawValue
        self.trialEndsAt = trialEndsAt
        self.needsSync = needsSync
    }

    // MARK: - Computed Properties
    var subscriptionTierEnum: SubscriptionTier {
        SubscriptionTier(rawValue: subscriptionTier) ?? .free
    }

    var subscriptionStatusEnum: SubscriptionStatus? {
        guard let status = subscriptionStatus else { return nil }
        return SubscriptionStatus(rawValue: status)
    }

    var displayNameOrEmail: String {
        displayName ?? email ?? "User"
    }

    var isPremium: Bool {
        subscriptionTierEnum == .premium
    }

    var isActiveSubscription: Bool {
        guard let status = subscriptionStatusEnum else { return false }
        return status == .active || status == .trial
    }
}

//
//  SubscriptionService.swift
//  FitChekk-v2
//
//  Subscription service protocol and mock implementation
//  Real implementation will use StoreKit 2
//

import Foundation

// MARK: - Subscription Plan

enum SubscriptionPlan: String, Codable, CaseIterable {
    case monthly = "Monthly"
    case annual = "Annual"

    var price: Double {
        switch self {
        case .monthly: return 7.99
        case .annual: return 59.99
        }
    }

    var priceString: String {
        return String(format: "$%.2f", price)
    }

    var savingsPercentage: Int? {
        switch self {
        case .monthly: return nil
        case .annual: return 37 // Compared to 12 months of monthly
        }
    }

    var duration: String {
        switch self {
        case .monthly: return "per month"
        case .annual: return "per year"
        }
    }
}

// MARK: - Protocol

protocol SubscriptionServiceProtocol {
    func getCurrentSubscription() async throws -> SubscriptionTier
    func purchase(plan: SubscriptionPlan) async throws -> Bool
    func restorePurchases() async throws -> SubscriptionTier
    func cancelSubscription() async throws
}

// MARK: - Mock Implementation

class MockSubscriptionService: SubscriptionServiceProtocol {
    private var currentTier: SubscriptionTier = .free

    func getCurrentSubscription() async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 300_000_000)
        return currentTier
    }

    func purchase(plan: SubscriptionPlan) async throws -> Bool {
        // Simulate purchase flow
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

        // For mockup, always succeed
        currentTier = .premium
        return true
    }

    func restorePurchases() async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // For mockup, randomly restore or not
        if Bool.random() {
            currentTier = .premium
        }

        return currentTier
    }

    func cancelSubscription() async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        currentTier = .free
    }

    // Helper for setting tier in previews
    func setTier(_ tier: SubscriptionTier) {
        currentTier = tier
    }
}

// MARK: - Shared Instance

extension MockSubscriptionService {
    static let shared = MockSubscriptionService()
}

//
//  SettingsFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class SettingsState {
    var user: MockUserPreferences = MockUserPreferences.sample
    var subscriptionTier: String = "Premium"
    var notificationsEnabled: Bool = true
    var useMetric: Bool = false
    var aiPersonalizationEnabled: Bool = true
}

// MARK: - Actions

enum SettingsAction {
    case onAppear
    case editProfileTapped
    case subscriptionTapped
    case notificationsToggled(Bool)
    case metricToggled(Bool)
    case aiPersonalizationToggled(Bool)
    case retakeQuizTapped
    case signOutTapped
}

// MARK: - View

struct SettingsView: View {
    @State private var state = SettingsState()
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    profileRow
                }
                
                // Subscription Section
                Section {
                    subscriptionRow
                }
                
                // Preferences Section
                Section("Preferences") {
                    Toggle("Notifications", isOn: $state.notificationsEnabled)
                    Toggle("Use Metric", isOn: $state.useMetric)
                    Toggle("AI Personalization", isOn: $state.aiPersonalizationEnabled)
                }
                
                // Account Section
                Section("Account") {
                    Button(action: {}) {
                        HStack {
                            Text("Retake Style Quiz")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
                
                // Sign Out Section
                Section {
                    Button(role: .destructive, action: {}) {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Profile Row
    
    private var profileRow: some View {
        HStack(spacing: Spacing.group) {
            Circle()
                .fill(Color.accentPrimary.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(state.user.displayName.prefix(1))
                        .font(.title2)
                        .foregroundColor(.accentPrimary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(state.user.displayName)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(state.user.location)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Edit")
                    .font(.subheadline)
                    .foregroundColor(.accentPrimary)
            }
        }
        .padding(.vertical, Spacing.verticalTight)
    }
    
    // MARK: - Subscription Row
    
    private var subscriptionRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(state.subscriptionTier)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("Active until Dec 2025")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Manage")
                    .font(.subheadline)
                    .foregroundColor(.accentPrimary)
            }
        }
        .padding(.vertical, Spacing.verticalTight)
    }
}

#Preview {
    SettingsView()
}


//
//  SettingsView.swift
//  FitChekk-v2
//
//  Settings screen
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showPaywall = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Profile section
                    profileSection
                    
                    // Subscription section
                    subscriptionSection
                    
                    // Preferences section
                    preferencesSection
                    
                    // Wardrobe stats
                    statsSection
                    
                    // About section
                    aboutSection
                    
                    // Sign out
                    signOutSection
                }
                .padding(.vertical, Spacing.lg)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Settings")
        }
    }
    
    // MARK: - Profile Section
    
    private var profileSection: some View {
        VStack(spacing: Spacing.md) {
            // Profile image placeholder
            Circle()
                .fill(Color.accentPrimary.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(appState.currentUser.displayName?.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentPrimary)
                )
            
            // Name and email
            VStack(spacing: 4) {
                Text(appState.currentUser.displayName ?? "User")
                    .font(.displaySmall)
                    .foregroundColor(.textPrimary)
                
                if let email = appState.currentUser.email {
                    Text(email)
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Edit profile button
            SecondaryButton(title: "Edit Profile") {
                // Edit profile
            }
            .padding(.horizontal, Spacing.xxl)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.xl)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.xl)
        .padding(.horizontal, Spacing.screenHorizontal)
    }
    
    // MARK: - Subscription Section
    
    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Subscription")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            VStack(spacing: 0) {
                if appState.currentUser.subscriptionTier == .premium {
                    // Premium user
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Premium")
                                    .font(.bodyLarge.weight(.semibold))
                                    .foregroundColor(.textPrimary)
                                
                                Image(systemName: "sparkles")
                                    .foregroundColor(.accentPrimary)
                            }
                            
                            if let expiryDate = appState.currentUser.subscriptionEndsAt {
                                Text("Renews \(expiryDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.md)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.md)
                    .onTapGesture {
                        // Manage subscription
                    }
                } else {
                    // Free user - upgrade prompt
                    Button {
                        showPaywall = true
                    } label: {
                        VStack(spacing: Spacing.md) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Free Plan")
                                        .font(.bodyLarge.weight(.semibold))
                                        .foregroundColor(.textPrimary)
                                    
                                    Text("Limited to 50 items")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                Spacer()
                            }
                            
                            PrimaryButton(title: "Upgrade to Premium") { }
                                .disabled(true) // Prevent double tap
                        }
                        .padding(Spacing.md)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.md)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(onDismiss: { showPaywall = false })
        }
    }
    
    // MARK: - Preferences Section
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Preferences")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "paintpalette",
                    title: "Style Preferences",
                    subtitle: "Update your style quiz"
                ) {
                    // Edit style preferences
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "location",
                    title: "Location",
                    subtitle: appState.userPreferences.locationName ?? "Not set"
                ) {
                    // Edit location
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "bell",
                    title: "Notifications",
                    subtitle: "Daily outfit reminders"
                ) {
                    // Edit notifications
                }
            }
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.md)
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Your Wardrobe")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                StatCard(
                    value: "\(appState.wardrobeItems.count)",
                    label: "Items",
                    icon: "tshirt",
                    color: .accentPrimary
                )
                
                StatCard(
                    value: "\(appState.outfits.count)",
                    label: "Outfits",
                    icon: "hanger",
                    color: .logoPrimary
                )
                
                StatCard(
                    value: "\(appState.wardrobeItems.filter(\.isFavorite).count)",
                    label: "Favorites",
                    icon: "heart.fill",
                    color: .error
                )
                
                StatCard(
                    value: "\(appState.wardrobeItems.reduce(0) { $0 + $1.timesWorn })",
                    label: "Total Wears",
                    icon: "checkmark.circle",
                    color: .success
                )
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
    
    // MARK: - About Section
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("About")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "questionmark.circle",
                    title: "Help & Support",
                    subtitle: nil
                ) {
                    // Open help
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "shield",
                    title: "Privacy Policy",
                    subtitle: nil
                ) {
                    // Open privacy policy
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Service",
                    subtitle: nil
                ) {
                    // Open terms
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "star",
                    title: "Rate FitChekk",
                    subtitle: nil
                ) {
                    // Open App Store rating
                }
            }
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.md)
            .padding(.horizontal, Spacing.screenHorizontal)
            
            // Version
            Text("Version 1.0.0")
                .font(.labelSmall)
                .foregroundColor(.textTertiary)
                .frame(maxWidth: .infinity)
                .padding(.top, Spacing.sm)
        }
    }
    
    // MARK: - Sign Out Section
    
    private var signOutSection: some View {
        Button {
            // Sign out
        } label: {
            Text("Sign Out")
                .font(.bodyLarge.weight(.semibold))
                .foregroundColor(.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.md)
        }
        .padding(.horizontal, Spacing.screenHorizontal)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.accentPrimary)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.labelLarge)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.md)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.displaySmall)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.md)
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}


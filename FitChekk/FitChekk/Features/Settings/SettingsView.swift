//
//  SettingsView.swift
//  FitChekk
//
//  Settings screen with AI preferences and account management
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                // AI Preferences Section
                Section {
                    Toggle("Enable AI Suggestions", isOn: .init(
                        get: { store.aiSuggestionsEnabled },
                        set: { store.send(.aiSuggestionsToggled($0)) }
                    ))
                    
                    Toggle("Auto-Categorize New Items", isOn: .init(
                        get: { store.autoCategorizeEnabled },
                        set: { store.send(.autoCategorizeToggled($0)) }
                    ))
                    .disabled(!store.aiSuggestionsEnabled)
                    
                    Toggle("Include Weather in Suggestions", isOn: .init(
                        get: { store.weatherInSuggestionsEnabled },
                        set: { store.send(.weatherInSuggestionsToggled($0)) }
                    ))
                    .disabled(!store.aiSuggestionsEnabled)
                    
                    Button(
                        action: { store.send(.recategorizeAllTapped) },
                        label: {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(Color.accentPrimary)
                                Text("Re-categorize All Items")
                                Spacer()
                            if store.uncategorizedCount > 0 {
                                Text("\(store.uncategorizedCount) items")
                                    .font(Font.captionRegular)
                                    .foregroundColor(Color.textSecondary)
                            }
                        }
                        }
                    )
                } header: {
                    Text("AI Preferences")
                } footer: {
                    Text("AI suggestions use advanced models to help you build outfits and categorize items.")
                }
                
                // Account Section
                Section("Account") {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(store.userEmail)
                            .foregroundColor(Color.textSecondary)
                    }
                    
                    HStack {
                        Text("Subscription")
                        Spacer()
                        Text(store.subscriptionStatus)
                            .foregroundColor(Color.textSecondary)
                    }
                }
                
                // Privacy Section
                Section("Privacy & Data") {
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink("Terms of Service") {
                        Text("Terms of Service")
                    }
                    
                    Button("Delete All Data") {
                        store.send(.deleteDataTapped)
                    }
                    .foregroundColor(.red)
                }
                
                // Sign Out
                Section {
                    Button("Sign Out") {
                        store.send(.signOutTapped)
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: .init(
                get: { store.showingBatchCategorization },
                set: { if !$0 { store.send(.dismissBatchCategorization) } }
            )) {
                if let items = store.itemsToRecategorize {
                    BatchCategorizationView(
                        store: Store(
                            initialState: BatchCategorizationFeature.State(
                                itemsToProcess: items
                            )
                        ) {
                            BatchCategorizationFeature()
                        }
                    )
                }
            }
            .alert(
                "Delete All Data?",
                isPresented: .init(
                    get: { store.showingDeleteConfirmation },
                    set: { if !$0 { store.send(.cancelDelete) } }
                ),
                actions: {
                    Button("Cancel", role: .cancel) {
                        store.send(.cancelDelete)
                    }
                    Button("Delete", role: .destructive) {
                        store.send(.confirmDelete)
                    }
                },
                message: {
                    Text("This will permanently delete all your wardrobe items, outfits, and data.")
                }
            )
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - SettingsFeature

@Reducer
struct SettingsFeature {
    @ObservableState
    struct State: Equatable {
        // AI Settings
        var aiSuggestionsEnabled = true
        var autoCategorizeEnabled = true
        var weatherInSuggestionsEnabled = true
        
        // User Info
        var userEmail = ""
        var subscriptionStatus = "Free"
        
        // Data
        var uncategorizedCount = 0
        var itemsToRecategorize: [WardrobeItem]?
        
        // UI State
        var showingBatchCategorization = false
        var showingDeleteConfirmation = false
    }
    
    enum Action: Equatable {
        case onAppear
        case loadUncategorizedCount
        case uncategorizedCountLoaded(Int)
        
        case aiSuggestionsToggled(Bool)
        case autoCategorizeToggled(Bool)
        case weatherInSuggestionsToggled(Bool)
        
        case recategorizeAllTapped
        case loadItemsToRecategorize
        case itemsToRecategorizeLoaded([WardrobeItem])
        case dismissBatchCategorization
        
        case deleteDataTapped
        case cancelDelete
        case confirmDelete
        
        case signOutTapped
    }
    
    @Dependency(\.databaseService) var databaseService
    @Dependency(\.authService) var authService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.loadUncategorizedCount),
                    .run { _ in
                        if (try? await authService.getCurrentUser()) != nil {
                            // Load user info (would be updated via state management in production)
                        }
                    }
                )
                
            case .loadUncategorizedCount:
                return .run { send in
                    guard let user = try? await authService.getCurrentUser() else { return }
                    let items = try await databaseService.fetchWardrobeItems(userId: user.id)
                    let uncategorizedCount = items.filter { !$0.aiGenerated }.count
                    await send(.uncategorizedCountLoaded(uncategorizedCount))
                }
                
            case let .uncategorizedCountLoaded(count):
                state.uncategorizedCount = count
                return .none
                
            case let .aiSuggestionsToggled(enabled):
                state.aiSuggestionsEnabled = enabled
                if !enabled {
                    state.autoCategorizeEnabled = false
                    state.weatherInSuggestionsEnabled = false
                }
                // In production, would save to UserPreferences
                return .none
                
            case let .autoCategorizeToggled(enabled):
                state.autoCategorizeEnabled = enabled
                // In production, would save to UserPreferences
                return .none
                
            case let .weatherInSuggestionsToggled(enabled):
                state.weatherInSuggestionsEnabled = enabled
                // In production, would save to UserPreferences
                return .none
                
            case .recategorizeAllTapped:
                return .send(.loadItemsToRecategorize)
                
            case .loadItemsToRecategorize:
                return .run { send in
                    guard let user = try? await authService.getCurrentUser() else { return }
                    let items = try await databaseService.fetchWardrobeItems(userId: user.id)
                    let uncategorized = items.filter { !$0.aiGenerated }
                    await send(.itemsToRecategorizeLoaded(uncategorized))
                }
                
            case let .itemsToRecategorizeLoaded(items):
                state.itemsToRecategorize = items
                state.showingBatchCategorization = !items.isEmpty
                return .none
                
            case .dismissBatchCategorization:
                state.showingBatchCategorization = false
                state.itemsToRecategorize = nil
                return .send(.loadUncategorizedCount)
                
            case .deleteDataTapped:
                state.showingDeleteConfirmation = true
                return .none
                
            case .cancelDelete:
                state.showingDeleteConfirmation = false
                return .none
                
            case .confirmDelete:
                state.showingDeleteConfirmation = false
                // In production, would delete all user data
                return .run { _ in
                    // Delete implementation would go here
                }
                
            case .signOutTapped:
                return .run { _ in
                    try await authService.signOut()
                    // App would handle navigation to auth screen
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        store: Store(
            initialState: SettingsFeature.State(
                userEmail: "user@example.com",
                uncategorizedCount: 12
            )
        ) {
            SettingsFeature()
        }
    )
}

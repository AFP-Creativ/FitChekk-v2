//
//  FitChekkApp.swift
//  FitChekk
//
//  Created by AI Development Team
//  Copyright © 2025 AFP Creativ. All rights reserved.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct FitChekkApp: App {
    // SwiftData container
    let modelContainer: ModelContainer

    // TCA store
    let store: StoreOf<AppFeature>

    init() {
        // Setup SwiftData
        do {
            let schema = Schema([
                // Models will be added as we create them
                // WardrobeItem.self,
                // Outfit.self,
                // PlannerEntry.self,
            ])

            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )

            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }

        // Setup TCA store
        store = Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
                .modelContainer(modelContainer)
        }
    }
}

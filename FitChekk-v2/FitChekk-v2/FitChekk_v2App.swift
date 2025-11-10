//
//  FitChekk_v2App.swift
//  FitChekk-v2
//
//  Created by Tom Foote on 11/9/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct FitChekk_v2App: App {
    var body: some Scene {
        WindowGroup {
            RootTabView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                }
            )
        }
    }
}

//
//  Store.swift
//  FitChekk-v2
//
//  Simplified TCA-like architecture for mockups
//  Can be easily replaced with actual TCA dependency later
//

import SwiftUI
import Observation

/// A simplified store pattern that mimics TCA
/// When ready to integrate TCA, replace this with: import ComposableArchitecture
@Observable
class Store<State, Action>: ObservableObject {
    var state: State
    private let reducer: (inout State, Action) -> Void
    
    init(initialState: State, reducer: @escaping (inout State, Action) -> Void) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&state, action)
    }
}

/// Protocol for defining feature reducers (TCA pattern)
protocol Reducer {
    associatedtype State
    associatedtype Action
    
    func reduce(state: inout State, action: Action)
}


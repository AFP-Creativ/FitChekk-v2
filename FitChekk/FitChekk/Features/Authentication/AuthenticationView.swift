//
//  AuthenticationView.swift
//  FitChekk
//
//  Root authentication view handling navigation between auth screens
//

import ComposableArchitecture
import SwiftUI

struct AuthenticationView: View {
    let store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        NavigationStack {
            Group {
                switch store.authFlow {
                case .welcome:
                    WelcomeView(store: store)
                case .signIn:
                    SignInView(store: store)
                case .signUp:
                    SignUpView(store: store)
                case .passwordReset:
                    PasswordResetView(store: store)
                }
            }
        }
    }
}

#Preview {
    AuthenticationView(
        store: Store(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
        }
    )
}

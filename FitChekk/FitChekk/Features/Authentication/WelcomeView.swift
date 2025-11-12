//
//  WelcomeView.swift
//  FitChekk
//
//  Welcome screen - first screen users see
//

import ComposableArchitecture
import SwiftUI

struct WelcomeView: View {
    let store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Branding Section
            VStack(spacing: Spacing.md) {
                // Logo or App Icon
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.accentPrimary)
                
                // App Name
                Text("FitChekk")
                    .font(.displayLarge)
                    .foregroundStyle(Color.textPrimary)
                
                // Tagline
                Text("Your personal wardrobe stylist")
                    .font(.bodyLarge)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.xl)
            
            Spacer()
            Spacer()
            
            // CTA Section
            VStack(spacing: Spacing.md) {
                // Primary CTA
                PrimaryButton(
                    title: "Get Started",
                    action: {
                        store.send(.showSignUp)
                    }
                )
                
                // Secondary CTA
                Button {
                    store.send(.showSignIn)
                } label: {
                    Text("Already have an account? **Sign In**")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.top, Spacing.xs)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    WelcomeView(
        store: Store(initialState: AuthenticationFeature.State()) {
            AuthenticationFeature()
        } withDependencies: {
            $0.authService = MockAuthService()
        }
    )
}

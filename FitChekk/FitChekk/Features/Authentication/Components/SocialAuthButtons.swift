//
//  SocialAuthButtons.swift
//  FitChekk
//
//  Social authentication buttons for Apple and Google
//

import ComposableArchitecture
import SwiftUI

struct SocialAuthButtons: View {
    let store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            // Apple Sign In
            Button {
                store.send(.signInWithAppleTapped)
            } label: {
                HStack(spacing: Spacing.sm) {
                    if store.isAppleSignInLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 20))
                    }
                    
                    Text("Continue with Apple")
                        .font(.bodyLarge.weight(.semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.black)
                .cornerRadius(CornerRadius.md)
            }
            .buttonShadow()
            .disabled(store.isAppleSignInLoading || store.isGoogleSignInLoading)
            
            // Google Sign In
            Button {
                store.send(.signInWithGoogleTapped)
            } label: {
                HStack(spacing: Spacing.sm) {
                    if store.isGoogleSignInLoading {
                        ProgressView()
                            .tint(Color.textPrimary)
                    } else {
                        // Google G logo using SF Symbol circle
                        Text("G")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.26, green: 0.52, blue: 0.96),
                                        Color(red: 0.22, green: 0.45, blue: 0.87)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                    
                    Text("Continue with Google")
                        .font(.bodyLarge.weight(.semibold))
                }
                .foregroundColor(Color.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.backgroundElevated)
                .cornerRadius(CornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .stroke(Color.borderDefault, lineWidth: 1)
                )
            }
            .buttonShadow()
            .disabled(store.isAppleSignInLoading || store.isGoogleSignInLoading)
        }
    }
}

#Preview {
    VStack(spacing: Spacing.xl) {
        // Normal state
        SocialAuthButtons(
            store: Store(initialState: AuthenticationFeature.State()) {
                AuthenticationFeature()
            }
        )
        
        // Loading states
        SocialAuthButtons(
            store: Store(
                initialState: AuthenticationFeature.State(
                    isAppleSignInLoading: true
                )
            ) {
                AuthenticationFeature()
            }
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}

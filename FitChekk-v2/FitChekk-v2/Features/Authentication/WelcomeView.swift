//
//  AuthFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class AuthState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

// MARK: - Actions

enum AuthAction {
    case signInWithAppleTapped
    case signInWithGoogleTapped
    case signInWithEmailTapped
    case onAppear
}

// MARK: - View

struct WelcomeView: View {
    @State private var state = AuthState()
    
    var body: some View {
        VStack(spacing: Spacing.section) {
            Spacer()
            
            // Logo and branding
            VStack(spacing: Spacing.group) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.logoPrimary)
                
                Text("FitChekk")
                    .font(.display)
                    .foregroundColor(.textPrimary)
                
                Text("Your AI stylist, in your pocket")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, Spacing.generous)
            
            Spacer()
            
            // Sign in options
            VStack(spacing: Spacing.group) {
                SignInButton(
                    title: "Sign in with Apple",
                    icon: "applelogo",
                    color: .textPrimary
                ) {
                    // Sign in with Apple
                }
                
                SignInButton(
                    title: "Continue with Google",
                    icon: "globe",
                    color: .textPrimary
                ) {
                    // Sign in with Google
                }
                
                SignInButton(
                    title: "Sign in with Email",
                    icon: "envelope.fill",
                    color: .accentPrimary
                ) {
                    // Sign in with Email
                }
            }
            .padding(.horizontal, Spacing.screenMargin)
            .padding(.bottom, Spacing.generous)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Sign In Button

struct SignInButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(color)
            .padding(.vertical, Spacing.standard)
            .padding(.horizontal, Spacing.standard)
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
        }
    }
}

#Preview {
    WelcomeView()
}


//
//  WelcomeView.swift
//  FitChekk-v2
//
//  Welcome and authentication screen
//  (Bypassed for mockup, but included for completeness)
//

import SwiftUI

struct WelcomeView: View {
    let onSignIn: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.xxl) {
                Spacer()
                
                // Logo and title
                VStack(spacing: Spacing.lg) {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.logoPrimary)
                    
                    VStack(spacing: Spacing.xs) {
                        Text("FitChekk")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Your AI Wardrobe Stylist")
                            .font(.bodyLarge)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Features
                VStack(spacing: Spacing.md) {
                    FeatureHighlight(
                        icon: "sparkles",
                        text: "AI-powered outfit suggestions"
                    )
                    
                    FeatureHighlight(
                        icon: "cloud.sun",
                        text: "Weather-aware recommendations"
                    )
                    
                    FeatureHighlight(
                        icon: "calendar",
                        text: "Plan your week ahead"
                    )
                }
                .padding(.horizontal, Spacing.xxl)
                
                Spacer()
                
                // Auth buttons
                VStack(spacing: Spacing.md) {
                    PrimaryButton(title: "Sign in with Apple") {
                        onSignIn()
                    }
                    
                    SecondaryButton(title: "Sign in with Google") {
                        onSignIn()
                    }
                    
                    TextButton(title: "or continue with email") {
                        onSignIn()
                    }
                }
                .padding(.horizontal, Spacing.xxl)
                
                // Terms
                Text("By continuing, you agree to our Terms & Privacy Policy")
                    .font(.labelSmall)
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)
                    .padding(.bottom, Spacing.lg)
            }
        }
    }
}

struct FeatureHighlight: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentPrimary)
                .frame(width: 32)
            
            Text(text)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeView(onSignIn: { })
}


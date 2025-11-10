//
//  View+Animations.swift
//  FitChekk-v2
//
//  Reusable animation extensions
//

import SwiftUI

extension View {
    // MARK: - Transition Animations
    
    /// Smooth fade and scale transition
    func fadeAndScaleTransition() -> some View {
        self.transition(.asymmetric(
            insertion: .scale(scale: 0.95).combined(with: .opacity),
            removal: .scale(scale: 0.95).combined(with: .opacity)
        ))
    }
    
    /// Slide from bottom transition
    func slideFromBottomTransition() -> some View {
        self.transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    /// Slide from top transition
    func slideFromTopTransition() -> some View {
        self.transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // MARK: - Tap Animations
    
    /// Scale down on press
    func scaleOnPress() -> some View {
        self.scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.2), value: UUID())
    }
    
    /// Bounce effect
    func bounceEffect(trigger: Bool) -> some View {
        self
            .scaleEffect(trigger ? 1.1 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: trigger)
    }
    
    // MARK: - Loading Animations
    
    /// Shimmer effect for loading states
    func shimmer() -> some View {
        self
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: -geometry.size.width)
                        .animation(
                            Animation
                                .linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: UUID()
                        )
                }
            )
            .clipped()
    }
    
    // MARK: - Attention Animations
    
    /// Pulse effect
    func pulse(isAnimating: Bool) -> some View {
        self
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .opacity(isAnimating ? 0.8 : 1.0)
            .animation(
                isAnimating ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default,
                value: isAnimating
            )
    }
    
    /// Shake effect (for errors)
    func shake(trigger: Int) -> some View {
        self
            .offset(x: CGFloat(trigger * 10))
            .animation(
                .default.repeatCount(3, autoreverses: true).speed(6),
                value: trigger
            )
    }
    
    // MARK: - Appear Animations
    
    /// Fade in on appear
    func fadeInOnAppear(duration: Double = 0.3, delay: Double = 0) -> some View {
        self
            .opacity(0)
            .onAppear {
                withAnimation(.easeIn(duration: duration).delay(delay)) {
                    // Trigger opacity change
                }
            }
    }
    
    /// Slide and fade in on appear
    func slideAndFadeInOnAppear(edge: Edge = .bottom, distance: CGFloat = 20, duration: Double = 0.3, delay: Double = 0) -> some View {
        self
            .opacity(0)
            .offset(y: edge == .bottom ? distance : -distance)
            .onAppear {
                withAnimation(.easeOut(duration: duration).delay(delay)) {
                    // Trigger animation
                }
            }
    }
}

// MARK: - Animation Presets

extension Animation {
    /// Smooth default animation
    static var smooth: Animation {
        .easeInOut(duration: 0.3)
    }
    
    /// Quick animation
    static var quick: Animation {
        .easeInOut(duration: 0.2)
    }
    
    /// Bouncy spring
    static var bouncy: Animation {
        .spring(response: 0.4, dampingFraction: 0.6)
    }
    
    /// Gentle spring
    static var gentle: Animation {
        .spring(response: 0.5, dampingFraction: 0.8)
    }
}

// MARK: - Button Style with Animation

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.quick, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == AnimatedButtonStyle {
    static var animated: AnimatedButtonStyle {
        AnimatedButtonStyle()
    }
}


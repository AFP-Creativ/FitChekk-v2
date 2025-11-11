//
//  Cards.swift
//  FitChekk
//
//  Reusable card components following design system
//  Ported from mockup
//

import SwiftUI

// MARK: - Basic Card

struct Card<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.cardPadding)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.lg)
    }
}

// MARK: - Elevated Card

struct ElevatedCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.cardPadding)
            .background(Color.backgroundElevated)
            .cornerRadius(CornerRadius.lg)
            .elevatedShadow()
    }
}

// MARK: - Item Card

struct ItemCard: View {
    let title: String
    let subtitle: String?
    let imageURL: String?
    var isSelected: Bool = false
    var isFavorite: Bool = false
    let onTap: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                // Image placeholder
                ZStack {
                    Rectangle()
                        .fill(Color.backgroundSecondary)
                        .aspectRatio(1, contentMode: .fit)

                    if let imageURL = imageURL {
                        // AsyncImage will go here when we have real images
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.textTertiary)
                    } else {
                        Image(systemName: "tshirt")
                            .font(.system(size: 40))
                            .foregroundColor(.textTertiary)
                    }

                    // Favorite button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: onFavorite) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(isFavorite ? .success : .white)
                                    .padding(Spacing.xs)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                    }
                    .padding(Spacing.xs)
                }
                .cornerRadius(CornerRadius.md)

                // Title
                Text(title)
                    .font(.headlineMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                // Subtitle
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.backgroundElevated)
        .cornerRadius(CornerRadius.lg)
        .itemCardShadow(isSelected: isSelected)
    }
}

// MARK: - Weather Card Snapshot

struct WeatherSnapshot: Equatable {
    let date: Date
    let tempHigh: Double
    let tempLow: Double
    let condition: String
    let feelsLike: Double
    let humidity: Double

    var conditionIcon: String {
        switch condition.lowercased() {
        case let cond where cond.contains("clear"): return "sun.max.fill"
        case let cond where cond.contains("cloud"): return "cloud.fill"
        case let cond where cond.contains("rain"): return "cloud.rain.fill"
        case let cond where cond.contains("snow"): return "snow"
        default: return "cloud.fill"
        }
    }
}

struct WeatherCard: View {
    let weather: WeatherSnapshot
    let isToday: Bool

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(isToday ? "Today" : weather.date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.labelSmall)
                .foregroundColor(.textSecondary)

            Image(systemName: weather.conditionIcon)
                .font(.title3)
                .foregroundColor(.textPrimary)

            Text("\(Int(weather.tempHigh))°")
                .font(.bodyLarge.weight(.semibold))
                .foregroundColor(.textPrimary)

            Text("\(Int(weather.tempLow))°")
                .font(.labelSmall)
                .foregroundColor(.textSecondary)
        }
        .frame(width: 70)
        .padding(.vertical, Spacing.sm)
        .background(isToday ? Color.accentPrimary.opacity(0.1) : Color.backgroundSecondary)
        .cornerRadius(CornerRadius.md)
    }
}

// MARK: - Preview

#Preview("Basic Card") {
    Card {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Card Title")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
            Text("This is some content inside a basic card component.")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Item Cards") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: Spacing.gridGap)]) {
        ItemCard(
            title: "Blue Sweater",
            subtitle: "Sweaters",
            imageURL: nil,
            isFavorite: true,
            onTap: {},
            onFavorite: {}
        )

        ItemCard(
            title: "Black Jeans",
            subtitle: "Bottoms",
            imageURL: nil,
            isSelected: true,
            onTap: {},
            onFavorite: {}
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Weather Cards") {
    HStack(spacing: Spacing.xs) {
        WeatherCard(
            weather: WeatherSnapshot(
                date: Date(),
                tempHigh: 72,
                tempLow: 58,
                condition: "Partly Cloudy",
                feelsLike: 68,
                humidity: 55
            ),
            isToday: true
        )

        WeatherCard(
            weather: WeatherSnapshot(
                date: Date().addingTimeInterval(86400),
                tempHigh: 68,
                tempLow: 55,
                condition: "Cloudy",
                feelsLike: 65,
                humidity: 60
            ),
            isToday: false
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}

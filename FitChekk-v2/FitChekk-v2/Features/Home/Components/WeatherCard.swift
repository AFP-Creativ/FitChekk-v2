//
//  WeatherCard.swift
//  FitChekk-v2
//
//  Weather display card with current conditions and forecast
//

import SwiftUI

struct WeatherCard: View {
    let currentWeather: WeatherSnapshot
    let forecast: [WeatherSnapshot]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Current Weather
            HStack(alignment: .top, spacing: Spacing.md) {
                Image(systemName: currentWeather.condition.icon)
                    .font(.system(size: 48))
                    .foregroundColor(.terracotta)
                    .frame(width: 60)

                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(currentWeather.temperature(inMetric: false))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.adaptiveText)

                    Text(currentWeather.condition.description)
                        .font(.callout)
                        .foregroundColor(.adaptiveTextSecondary)

                    Text("Feels like \(currentWeather.feelsLikeTemperature(inMetric: false))")
                        .font(.caption)
                        .foregroundColor(.adaptiveTextSecondary)
                }

                Spacer()
            }

            Divider()
                .padding(.vertical, Spacing.xs)

            // 5-Day Forecast Strip
            if !forecast.isEmpty {
                ForecastStrip(forecast: forecast)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.card)
                .fill(Color.backgroundSecondary)
        )
        .cardShadow()
    }
}

// MARK: - Forecast Strip

struct ForecastStrip: View {
    let forecast: [WeatherSnapshot]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                ForEach(forecast) { weather in
                    ForecastDayView(weather: weather)
                }
            }
        }
    }
}

struct ForecastDayView: View {
    let weather: WeatherSnapshot

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(dayLabel)
                .font(.caption)
                .foregroundColor(.adaptiveTextSecondary)

            Image(systemName: weather.condition.icon)
                .font(.system(size: 24))
                .foregroundColor(.terracotta.opacity(0.8))
                .frame(height: 30)

            Text(weather.temperature(inMetric: false))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.adaptiveText)
        }
        .frame(width: 60)
    }

    private var dayLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: weather.date)
    }
}

// MARK: - Preview

#Preview("Weather Card") {
    ScrollView {
        VStack(spacing: Spacing.xl) {
            WeatherCard(
                currentWeather: PreviewData.currentWeather,
                forecast: PreviewData.forecast
            )

            WeatherCard(
                currentWeather: .mockRainy(),
                forecast: PreviewData.forecast
            )

            WeatherCard(
                currentWeather: .mockCold(),
                forecast: PreviewData.forecast
            )
        }
        .screenPadding()
        .padding(.vertical, Spacing.xl)
    }
    .background(Color.backgroundPrimary)
}

//
//  WeatherSnapshot.swift
//  FitChekk-v2
//
//  Weather data model
//

import Foundation

enum WeatherCondition: String, Codable, CaseIterable {
    case clear = "Clear"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rain = "Rain"
    case heavyRain = "Heavy Rain"
    case snow = "Snow"
    case thunderstorm = "Thunderstorm"
    case fog = "Fog"
    case windy = "Windy"

    var icon: String {
        switch self {
        case .clear: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .heavyRain: return "cloud.heavyrain.fill"
        case .snow: return "cloud.snow.fill"
        case .thunderstorm: return "cloud.bolt.fill"
        case .fog: return "cloud.fog.fill"
        case .windy: return "wind"
        }
    }

    var description: String {
        rawValue
    }
}

struct WeatherSnapshot: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var temperature: Double // In Celsius
    var feelsLike: Double // In Celsius
    var condition: WeatherCondition
    var humidity: Double // Percentage
    var windSpeed: Double // km/h
    var precipitationChance: Double // Percentage

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        temperature: Double,
        feelsLike: Double,
        condition: WeatherCondition,
        humidity: Double = 50,
        windSpeed: Double = 10,
        precipitationChance: Double = 0
    ) {
        self.id = id
        self.date = date
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.condition = condition
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.precipitationChance = precipitationChance
    }

    // Computed properties
    var temperatureFahrenheit: Double {
        (temperature * 9/5) + 32
    }

    var feelsLikeFahrenheit: Double {
        (feelsLike * 9/5) + 32
    }

    var windSpeedMPH: Double {
        windSpeed * 0.621371
    }

    func temperature(inMetric: Bool) -> String {
        let temp = inMetric ? temperature : temperatureFahrenheit
        let unit = inMetric ? "°C" : "°F"
        return String(format: "%.0f%@", temp, unit)
    }

    func feelsLikeTemperature(inMetric: Bool) -> String {
        let temp = inMetric ? feelsLike : feelsLikeFahrenheit
        let unit = inMetric ? "°C" : "°F"
        return String(format: "%.0f%@", temp, unit)
    }

    // Weather-based outfit suggestions
    var suggestedLayers: Int {
        if temperature < 5 {
            return 3 // Heavy layering
        } else if temperature < 15 {
            return 2 // Medium layering
        } else if temperature < 25 {
            return 1 // Light layering
        } else {
            return 0 // No layers needed
        }
    }

    var needsRainGear: Bool {
        precipitationChance > 30 || condition == .rain || condition == .heavyRain
    }

    var needsWarmOuterwear: Bool {
        temperature < 10
    }
}

// MARK: - Mock Extension

extension WeatherSnapshot {
    static func mock(
        temperature: Double = 20,
        condition: WeatherCondition = .clear,
        date: Date = Date()
    ) -> WeatherSnapshot {
        WeatherSnapshot(
            date: date,
            temperature: temperature,
            feelsLike: temperature - 2,
            condition: condition,
            humidity: 55,
            windSpeed: 15,
            precipitationChance: condition == .rain ? 80 : 10
        )
    }

    static func mockSunny(date: Date = Date()) -> WeatherSnapshot {
        mock(temperature: 24, condition: .clear, date: date)
    }

    static func mockCloudy(date: Date = Date()) -> WeatherSnapshot {
        mock(temperature: 18, condition: .cloudy, date: date)
    }

    static func mockRainy(date: Date = Date()) -> WeatherSnapshot {
        WeatherSnapshot(
            date: date,
            temperature: 15,
            feelsLike: 13,
            condition: .rain,
            humidity: 85,
            windSpeed: 25,
            precipitationChance: 80
        )
    }

    static func mockCold(date: Date = Date()) -> WeatherSnapshot {
        mock(temperature: 5, condition: .partlyCloudy, date: date)
    }

    static func mockHot(date: Date = Date()) -> WeatherSnapshot {
        mock(temperature: 32, condition: .clear, date: date)
    }

    /// Generate a 5-day forecast
    static func mockForecast(startingFrom date: Date = Date()) -> [WeatherSnapshot] {
        let conditions: [WeatherCondition] = [.clear, .partlyCloudy, .cloudy, .rain, .clear]
        let temperatures: [Double] = [22, 20, 18, 16, 23]

        return (0..<5).map { index in
            guard let futureDate = Calendar.current.date(byAdding: .day, value: index, to: date) else {
                return mock(date: date)
            }
            return mock(
                temperature: temperatures[index],
                condition: conditions[index],
                date: futureDate
            )
        }
    }
}

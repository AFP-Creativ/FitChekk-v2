import Foundation
import Dependencies
import CoreLocation

// MARK: - Weather Data Models

struct WeatherCondition: Equatable, Sendable {
    let date: Date
    let tempHigh: Int
    let tempLow: Int
    let condition: String
    let feelsLike: Int
    let humidity: Int
    let precipitation: Int // Percentage
    
    var conditionIcon: String {
        switch condition.lowercased() {
        case let cond where cond.contains("sun") || cond.contains("clear"):
            return "sun.max.fill"
        case let cond where cond.contains("cloud"):
            return "cloud.fill"
        case let cond where cond.contains("rain"):
            return "cloud.rain.fill"
        case let cond where cond.contains("snow"):
            return "cloud.snow.fill"
        case let cond where cond.contains("storm") || cond.contains("thunder"):
            return "cloud.bolt.fill"
        default:
            return "cloud.fill"
        }
    }
}

struct WeatherForecast: Equatable, Sendable {
    let current: WeatherCondition
    let daily: [WeatherCondition]
}

// MARK: - Protocol

/// Service for weather data using WeatherKit
protocol WeatherService: Sendable {
    /// Get current weather conditions for a location
    func getCurrentWeather(location: CLLocation) async throws -> WeatherCondition
    
    /// Get weather forecast for multiple days
    func getForecast(location: CLLocation, days: Int) async throws -> WeatherForecast
    
    /// Request location permission from user
    func requestLocationPermission() async throws -> Bool
    
    /// Get the user's current location
    func getCurrentLocation() async throws -> CLLocation
}

// MARK: - Dependency Key

private enum WeatherServiceKey: DependencyKey {
    static let liveValue: WeatherService = LiveWeatherService()
    static let testValue: WeatherService = MockWeatherService()
}

extension DependencyValues {
    var weatherService: WeatherService {
        get { self[WeatherServiceKey.self] }
        set { self[WeatherServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation (Placeholder)

final class LiveWeatherService: WeatherService {
    func getCurrentWeather(location: CLLocation) async throws -> WeatherCondition {
        // TODO: Implement WeatherKit integration in Phase 7
        throw WeatherError.notImplemented
    }
    
    func getForecast(location: CLLocation, days: Int) async throws -> WeatherForecast {
        // TODO: Implement WeatherKit forecast
        throw WeatherError.notImplemented
    }
    
    func requestLocationPermission() async throws -> Bool {
        // TODO: Implement CLLocationManager authorization
        false
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        // TODO: Implement location fetching with CLLocationManager
        throw WeatherError.notImplemented
    }
}

// MARK: - Mock Implementation

final class MockWeatherService: WeatherService, @unchecked Sendable {
    var mockLocation: CLLocation?
    var mockWeather: WeatherCondition?
    var mockForecast: [WeatherCondition]?
    var shouldThrowError = false
    var errorToThrow: WeatherError = .networkError
    var hasLocationPermission = true
    
    func getCurrentWeather(location: CLLocation) async throws -> WeatherCondition {
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15s delay
        if shouldThrowError { throw errorToThrow }
        
        if let weather = mockWeather {
            return weather
        }
        
        // Return realistic mock data
        return WeatherCondition(
            date: Date(),
            tempHigh: 72,
            tempLow: 58,
            condition: "Partly Cloudy",
            feelsLike: 68,
            humidity: 55,
            precipitation: 10
        )
    }
    
    func getForecast(location: CLLocation, days: Int) async throws -> WeatherForecast {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s delay
        if shouldThrowError { throw errorToThrow }
        
        let current = try await getCurrentWeather(location: location)
        
        if let forecast = mockForecast {
            return WeatherForecast(current: current, daily: forecast)
        }
        
        // Generate mock forecast
        var daily: [WeatherCondition] = []
        for day in 0..<days {
            let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
            let condition = WeatherCondition(
                date: date,
                tempHigh: Int.random(in: 65...80),
                tempLow: Int.random(in: 50...65),
                condition: ["Sunny", "Partly Cloudy", "Cloudy", "Rainy"].randomElement() ?? "Sunny",
                feelsLike: Int.random(in: 55...75),
                humidity: Int.random(in: 40...70),
                precipitation: Int.random(in: 0...60)
            )
            daily.append(condition)
        }
        
        return WeatherForecast(current: current, daily: daily)
    }
    
    func requestLocationPermission() async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        return hasLocationPermission
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
        if shouldThrowError { throw errorToThrow }
        
        if let location = mockLocation {
            return location
        }
        
        // Return mock location (San Francisco)
        return CLLocation(latitude: 37.7749, longitude: -122.4194)
    }
}

// MARK: - Errors

enum WeatherError: Error, Equatable {
    case notImplemented
    case networkError
    case locationPermissionDenied
    case locationUnavailable
    case invalidLocation
    case apiLimitReached
}

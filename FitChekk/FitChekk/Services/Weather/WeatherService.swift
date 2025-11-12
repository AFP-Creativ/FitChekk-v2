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
    static let liveValue: any WeatherService = {
        MainActor.assumeIsolated {
            LiveWeatherService()
        }
    }()
    static let testValue: any WeatherService = MockWeatherService()
    static let previewValue: any WeatherService = MockWeatherService()
}

extension DependencyValues {
    var weatherService: WeatherService {
        get { self[WeatherServiceKey.self] }
        set { self[WeatherServiceKey.self] = newValue }
    }
}

// MARK: - Live Implementation

@MainActor
final class LiveWeatherService: NSObject, WeatherService {
    private let locationManager: CLLocationManager
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    private var authorizationContinuation: CheckedContinuation<Bool, Error>?
    
    // Weather cache
    private var cachedWeather: WeatherCondition?
    private var cacheTimestamp: Date?
    private let cacheExpirationInterval: TimeInterval = 15 * 60 // 15 minutes
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func getCurrentWeather(location: CLLocation) async throws -> WeatherCondition {
        // Check cache first
        if let cached = cachedWeather,
           let timestamp = cacheTimestamp,
           Date().timeIntervalSince(timestamp) < cacheExpirationInterval {
            return cached
        }
        
        // Fetch fresh weather data
        do {
            let weather = try await fetchWeatherFromWeatherKit(location: location)
            
            // Update cache
            cachedWeather = weather
            cacheTimestamp = Date()
            
            return weather
        } catch {
            throw WeatherError.networkError
        }
    }

    func getForecast(location: CLLocation, days: Int) async throws -> WeatherForecast {
        do {
            let current = try await getCurrentWeather(location: location)
            let dailyForecasts = try await fetchForecastFromWeatherKit(location: location, days: days)
            
            return WeatherForecast(current: current, daily: dailyForecasts)
        } catch {
            throw WeatherError.networkError
        }
    }

    func requestLocationPermission() async throws -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            return try await withCheckedThrowingContinuation { continuation in
                self.authorizationContinuation = continuation
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .denied, .restricted:
            throw WeatherError.locationPermissionDenied
        @unknown default:
            throw WeatherError.locationUnavailable
        }
    }

    func getCurrentLocation() async throws -> CLLocation {
        // Check authorization first
        let isAuthorized = try await requestLocationPermission()
        guard isAuthorized else {
            throw WeatherError.locationPermissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.locationManager.requestLocation()
        }
    }
    
    // MARK: - WeatherKit Integration
    
    private func fetchWeatherFromWeatherKit(location: CLLocation) async throws -> WeatherCondition {
        // Note: WeatherKit requires iOS 16+ and proper entitlements
        // For now, we'll use a simulated implementation that would be replaced with real WeatherKit
        // In production, this would use: import WeatherKit and WeatherService.shared.weather(for:)
        
        // Simulated weather data based on location
        // In production, replace with:
        // let weather = try await WeatherService.shared.weather(for: location)
        
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
    
    private func fetchForecastFromWeatherKit(location: CLLocation, days: Int) async throws -> [WeatherCondition] {
        // In production, replace with WeatherKit forecast API
        // let forecast = try await WeatherService.shared.dailyForecast(for: location)
        
        var forecasts: [WeatherCondition] = []
        let calendar = Calendar.current
        
        for day in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: day, to: Date()) else {
                continue
            }
            
            let condition = WeatherCondition(
                date: date,
                tempHigh: Int.random(in: 65...80),
                tempLow: Int.random(in: 50...65),
                condition: ["Sunny", "Partly Cloudy", "Cloudy", "Rainy"].randomElement() ?? "Sunny",
                feelsLike: Int.random(in: 55...75),
                humidity: Int.random(in: 40...70),
                precipitation: Int.random(in: 0...60)
            )
            
            forecasts.append(condition)
        }
        
        return forecasts
    }
}

// MARK: - CLLocationManagerDelegate

extension LiveWeatherService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        Task { @MainActor in
            self.locationContinuation?.resume(returning: location)
            self.locationContinuation = nil
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locationContinuation?.resume(throwing: WeatherError.locationUnavailable)
            self.locationContinuation = nil
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        Task { @MainActor in
            guard let continuation = self.authorizationContinuation else { return }
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                continuation.resume(returning: true)
            case .denied, .restricted:
                continuation.resume(throwing: WeatherError.locationPermissionDenied)
            case .notDetermined:
                // Still waiting for user decision
                return
            @unknown default:
                continuation.resume(throwing: WeatherError.locationUnavailable)
            }
            
            self.authorizationContinuation = nil
        }
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

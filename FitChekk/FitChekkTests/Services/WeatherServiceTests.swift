import XCTest
import CoreLocation
@testable import FitChekk

@MainActor
final class WeatherServiceTests: XCTestCase {
    var mockService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - Get Current Weather Tests
    
    func testGetCurrentWeatherSuccess() async throws {
        // Given
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedWeather = WeatherCondition(
            date: Date(),
            tempHigh: 75,
            tempLow: 60,
            condition: "Sunny",
            feelsLike: 72,
            humidity: 50,
            precipitation: 0
        )
        mockService.mockWeather = expectedWeather
        
        // When
        let weather = try await mockService.getCurrentWeather(location: testLocation)
        
        // Then
        XCTAssertEqual(weather.tempHigh, 75)
        XCTAssertEqual(weather.tempLow, 60)
        XCTAssertEqual(weather.condition, "Sunny")
        XCTAssertEqual(weather.feelsLike, 72)
        XCTAssertEqual(weather.humidity, 50)
    }
    
    func testGetCurrentWeatherNetworkError() async throws {
        // Given
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        // When/Then
        do {
            _ = try await mockService.getCurrentWeather(location: testLocation)
            XCTFail("Should throw network error")
        } catch let error as WeatherError {
            XCTAssertEqual(error, .networkError)
        }
    }
    
    // MARK: - Get Forecast Tests
    
    func testGetForecastSuccess() async throws {
        // Given
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let mockForecastData = [
            WeatherCondition(
                date: Date(),
                tempHigh: 75,
                tempLow: 60,
                condition: "Sunny",
                feelsLike: 72,
                humidity: 50,
                precipitation: 0
            ),
            WeatherCondition(
                date: Date().addingTimeInterval(86400),
                tempHigh: 78,
                tempLow: 62,
                condition: "Partly Cloudy",
                feelsLike: 75,
                humidity: 55,
                precipitation: 10
            )
        ]
        mockService.mockForecast = mockForecastData
        
        // When
        let forecast = try await mockService.getForecast(location: testLocation, days: 5)
        
        // Then
        XCTAssertEqual(forecast.daily.count, 2)
        XCTAssertEqual(forecast.current.tempHigh, 75)
        XCTAssertEqual(forecast.daily[1].tempHigh, 78)
    }
    
    func testGetForecastNetworkError() async throws {
        // Given
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        // When/Then
        do {
            _ = try await mockService.getForecast(location: testLocation, days: 5)
            XCTFail("Should throw network error")
        } catch let error as WeatherError {
            XCTAssertEqual(error, .networkError)
        }
    }
    
    // MARK: - Location Permission Tests
    
    func testRequestLocationPermissionGranted() async throws {
        // Given
        mockService.hasLocationPermission = true
        
        // When
        let granted = try await mockService.requestLocationPermission()
        
        // Then
        XCTAssertTrue(granted)
    }
    
    func testRequestLocationPermissionDenied() async throws {
        // Given
        mockService.hasLocationPermission = false
        mockService.shouldThrowError = true
        mockService.errorToThrow = .locationPermissionDenied
        
        // When/Then
        do {
            _ = try await mockService.requestLocationPermission()
            XCTFail("Should throw permission denied error")
        } catch let error as WeatherError {
            XCTAssertEqual(error, .locationPermissionDenied)
        }
    }
    
    // MARK: - Get Current Location Tests
    
    func testGetCurrentLocationSuccess() async throws {
        // Given
        let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        mockService.mockLocation = expectedLocation
        mockService.hasLocationPermission = true
        
        // When
        let location = try await mockService.getCurrentLocation()
        
        // Then
        XCTAssertEqual(location.coordinate.latitude, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(location.coordinate.longitude, -122.4194, accuracy: 0.0001)
    }
    
    func testGetCurrentLocationUnavailable() async throws {
        // Given
        mockService.shouldThrowError = true
        mockService.errorToThrow = .locationUnavailable
        
        // When/Then
        do {
            _ = try await mockService.getCurrentLocation()
            XCTFail("Should throw location unavailable error")
        } catch let error as WeatherError {
            XCTAssertEqual(error, .locationUnavailable)
        }
    }
    
    // MARK: - Weather Condition Icon Tests
    
    func testWeatherConditionIcons() {
        let conditions: [(String, String)] = [
            ("Sunny", "sun.max.fill"),
            ("Clear", "sun.max.fill"),
            ("Cloudy", "cloud.fill"),
            ("Partly Cloudy", "cloud.fill"),
            ("Rainy", "cloud.rain.fill"),
            ("Rain", "cloud.rain.fill"),
            ("Snowy", "cloud.snow.fill"),
            ("Snow", "cloud.snow.fill"),
            ("Thunderstorm", "cloud.bolt.fill"),
            ("Storm", "cloud.bolt.fill")
        ]
        
        for (condition, expectedIcon) in conditions {
            let weather = WeatherCondition(
                date: Date(),
                tempHigh: 70,
                tempLow: 55,
                condition: condition,
                feelsLike: 65,
                humidity: 50,
                precipitation: 0
            )
            
            XCTAssertEqual(weather.conditionIcon, expectedIcon, "Icon for \(condition) should be \(expectedIcon)")
        }
    }
    
    // MARK: - Weather Caching Tests (for LiveWeatherService)
    
    func testWeatherCaching() async throws {
        // Note: This would test the actual LiveWeatherService caching
        // For now, we document the expected behavior
        
        // Given: Weather is fetched at time T
        // When: Weather is requested again within 15 minutes
        // Then: Cached weather should be returned (no API call)
        
        // When: Weather is requested after 15 minutes
        // Then: Fresh weather should be fetched (new API call)
        
        // This test would require a real LiveWeatherService instance
        // with dependency injection for time and cache management
    }
}


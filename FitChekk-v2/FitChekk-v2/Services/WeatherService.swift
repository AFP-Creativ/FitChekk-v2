//
//  WeatherService.swift
//  FitChekk-v2
//
//  Weather service protocol and mock implementation
//  Real implementation will use WeatherKit
//

import Foundation

// MARK: - Protocol

protocol WeatherServiceProtocol {
    func getCurrentWeather() async throws -> WeatherSnapshot
    func getForecast(days: Int) async throws -> [WeatherSnapshot]
}

// MARK: - Mock Implementation

class MockWeatherService: WeatherServiceProtocol {
    func getCurrentWeather() async throws -> WeatherSnapshot {
        try await Task.sleep(nanoseconds: 300_000_000)
        return PreviewData.currentWeather
    }

    func getForecast(days: Int = 5) async throws -> [WeatherSnapshot] {
        try await Task.sleep(nanoseconds: 400_000_000)
        return Array(PreviewData.forecast.prefix(days))
    }
}

// MARK: - Shared Instance

extension MockWeatherService {
    static let shared = MockWeatherService()
}

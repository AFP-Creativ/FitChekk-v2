//
//  MockData.swift
//  FitChekk-v2
//
//  Created for UI Mockups
//

import Foundation
import SwiftUI

// MARK: - Mock Models

struct MockWardrobeItem: Identifiable, Hashable {
    let id: UUID
    let name: String?
    let category: ItemCategory
    let subCategory: ItemSubCategory
    let colors: [String]
    let isFavorite: Bool
    let timesWorn: Int
    let lastWornDate: Date?
    let imagePlaceholder: String // SF Symbol name for placeholder
    
    static let sampleItems: [MockWardrobeItem] = [
        MockWardrobeItem(
            id: UUID(),
            name: "Navy Sweater",
            category: .tops,
            subCategory: .sweaters,
            colors: ["navy", "cream"],
            isFavorite: true,
            timesWorn: 12,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
            imagePlaceholder: "tshirt.fill"
        ),
        MockWardrobeItem(
            id: UUID(),
            name: "Black Jeans",
            category: .bottoms,
            subCategory: .jeans,
            colors: ["black"],
            isFavorite: false,
            timesWorn: 8,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            imagePlaceholder: "figure.walk"
        ),
        MockWardrobeItem(
            id: UUID(),
            name: "White Button-Down",
            category: .tops,
            subCategory: .buttonDowns,
            colors: ["white"],
            isFavorite: true,
            timesWorn: 15,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
            imagePlaceholder: "tshirt.fill"
        ),
        MockWardrobeItem(
            id: UUID(),
            name: "Camel Chinos",
            category: .bottoms,
            subCategory: .dressPants,
            colors: ["camel", "tan"],
            isFavorite: false,
            timesWorn: 6,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
            imagePlaceholder: "figure.walk"
        ),
        MockWardrobeItem(
            id: UUID(),
            name: "Gray Sneakers",
            category: .footwear,
            subCategory: .sneakers,
            colors: ["gray", "white"],
            isFavorite: true,
            timesWorn: 20,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
            imagePlaceholder: "shoe.fill"
        ),
        MockWardrobeItem(
            id: UUID(),
            name: "Denim Jacket",
            category: .outerwear,
            subCategory: .jackets,
            colors: ["blue", "denim"],
            isFavorite: false,
            timesWorn: 4,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
            imagePlaceholder: "jacket.fill"
        )
    ]
}

struct MockOutfit: Identifiable {
    let id: UUID
    let name: String
    let items: [MockWardrobeItem]
    let aiReasoning: String?
    let weatherSnapshot: MockWeather?
    let timesWorn: Int
    let lastWornDate: Date?
    
    static let sampleOutfits: [MockOutfit] = [
        MockOutfit(
            id: UUID(),
            name: "Casual Friday",
            items: [
                MockWardrobeItem.sampleItems[0], // Navy Sweater
                MockWardrobeItem.sampleItems[1], // Black Jeans
                MockWardrobeItem.sampleItems[4]  // Gray Sneakers
            ],
            aiReasoning: "This navy sweater pairs beautifully with your camel chinos for today's 72° weather. The casual-smart vibe is perfect for your work-from-home video calls, and you haven't worn this combination in 2 weeks.",
            weatherSnapshot: MockWeather.sample,
            timesWorn: 3,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -14, to: Date())
        )
    ]
}

struct MockWeather {
    let tempHigh: Double
    let tempLow: Double
    let condition: String
    let feelsLike: Double
    let humidity: Double
    let forecast: [DailyForecast]
    
    struct DailyForecast {
        let day: String
        let temp: Double
        let condition: String
    }
    
    static let sample = MockWeather(
        tempHigh: 72,
        tempLow: 58,
        condition: "Partly Cloudy",
        feelsLike: 68,
        humidity: 65,
        forecast: [
            DailyForecast(day: "Tue", temp: 68, condition: "Sunny"),
            DailyForecast(day: "Wed", temp: 65, condition: "Cloudy"),
            DailyForecast(day: "Thu", temp: 70, condition: "Partly Cloudy"),
            DailyForecast(day: "Fri", temp: 74, condition: "Sunny")
        ]
    )
}

struct MockUserPreferences {
    let displayName: String
    let styles: [String]
    let favoriteColors: [String]
    let lifestyleType: String
    let location: String
    
    static let sample = MockUserPreferences(
        displayName: "Emma",
        styles: ["Minimalist", "Classic"],
        favoriteColors: ["navy", "white", "camel"],
        lifestyleType: "Remote Worker",
        location: "San Francisco, CA"
    )
}

// MARK: - Enums

enum ItemCategory: String, CaseIterable, Identifiable {
    case tops = "Tops"
    case bottoms = "Bottoms"
    case dresses = "Dresses"
    case outerwear = "Outerwear"
    case accessories = "Accessories"
    case jewelry = "Jewelry"
    case footwear = "Footwear"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .tops: return "tshirt.fill"
        case .bottoms: return "figure.walk"
        case .dresses: return "dress.fill"
        case .outerwear: return "jacket.fill"
        case .accessories: return "bag.fill"
        case .jewelry: return "sparkles"
        case .footwear: return "shoe.fill"
        }
    }
}

enum ItemSubCategory: String, CaseIterable {
    // Tops
    case graphicTees = "Graphic Tees"
    case dressedUpTops = "Dressed Up Tops"
    case sweaters = "Sweaters"
    case bodysuits = "Bodysuits"
    case activewear = "Activewear"
    case buttonDowns = "Button-Downs"
    case tanks = "Tanks"
    
    // Bottoms
    case jeans = "Jeans"
    case shorts = "Shorts"
    case skirts = "Skirts"
    case leggings = "Leggings"
    case dressPants = "Dress Pants"
    
    // Dresses
    case dayDresses = "Day Dresses"
    case partyDresses = "Party Dresses"
    case rompers = "Rompers"
    case maxiDresses = "Maxi Dresses"
    case casualDresses = "Casual Dresses"
    
    // Outerwear
    case jackets = "Jackets"
    case coats = "Coats"
    case blazers = "Blazers"
    case rainJackets = "Rain Jackets"
    
    // Accessories
    case hats = "Hats"
    case bags = "Bags"
    case belts = "Belts"
    case sunglasses = "Sunglasses"
    case scarves = "Scarves"
    
    // Jewelry
    case necklaces = "Necklaces"
    case bracelets = "Bracelets"
    case rings = "Rings"
    case earrings = "Earrings"
    case watches = "Watches"
    
    // Footwear
    case heels = "Heels"
    case flats = "Flats"
    case sneakers = "Sneakers"
    case boots = "Boots"
    case socks = "Socks"
}

enum OccasionType: String, CaseIterable {
    case work = "Work"
    case casual = "Casual"
    case date = "Date"
    case athletic = "Athletic"
    case formal = "Formal"
    case travel = "Travel"
    case weekend = "Weekend"
}


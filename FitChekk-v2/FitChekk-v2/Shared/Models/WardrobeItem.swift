//
//  WardrobeItem.swift
//  FitChekk-v2
//
//  Core data model for wardrobe items
//

import Foundation
import SwiftUI

// MARK: - Enums

enum ItemCategory: String, Codable, CaseIterable, Identifiable {
    case tops, bottoms, dresses, outerwear, accessories, jewelry, footwear
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "figure.walk"
        case .dresses: return "figure.dress.line.vertical.figure"
        case .outerwear: return "coat"
        case .accessories: return "bag"
        case .jewelry: return "sparkles"
        case .footwear: return "shoe"
        }
    }
}

enum ItemSubCategory: String, Codable {
    // Tops
    case graphicTees, dressedUpTops, sweaters, bodysuits, activewear, buttonDowns, tanks
    // Bottoms
    case jeans, shorts, skirts, leggings, dressPants
    // Dresses
    case dayDresses, partyDresses, rompers, maxiDresses, casualDresses
    // Outerwear
    case jackets, coats, blazers, rainJackets
    // Accessories
    case hats, bags, belts, sunglasses, scarves
    // Jewelry
    case necklaces, bracelets, rings, earrings, watches
    // Footwear
    case heels, flats, sneakers, boots, socks
    
    var displayName: String {
        rawValue.camelCaseToWords()
    }
}

enum FormalityLevel: Int, Codable, CaseIterable {
    case casual = 1
    case smartCasual = 2
    case businessCasual = 3
    case business = 4
    case formal = 5
    
    var displayName: String {
        switch self {
        case .casual: return "Casual"
        case .smartCasual: return "Smart Casual"
        case .businessCasual: return "Business Casual"
        case .business: return "Business"
        case .formal: return "Formal"
        }
    }
}

enum Season: String, Codable, CaseIterable {
    case spring, summer, fall, winter
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .fall: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

// MARK: - Main Model

struct WardrobeItem: Identifiable, Codable, Equatable {
    // Identity
    let id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // Basic Info
    var name: String?
    var category: ItemCategory
    var subCategory: ItemSubCategory
    var brand: String?
    var purchaseDate: Date?
    var purchasePrice: Decimal?
    
    // Images (for mockup, we'll use color placeholders)
    var imageName: String? // Mock image name
    var imageColor: String? // Hex color for placeholder
    
    // AI-Generated Attributes
    var aiGenerated: Bool
    var colors: [String]
    var pattern: String?
    var formality: FormalityLevel
    var styleTags: [String]
    var seasons: [Season]
    var materialType: String?
    var aiConfidence: Double
    
    // User Metadata
    var isFavorite: Bool
    var notes: String?
    var isArchived: Bool
    
    // Usage Statistics
    var timesWorn: Int
    var lastWornDate: Date?
    
    // Sync
    var userId: UUID
    var needsSync: Bool
    
    init(
        id: UUID = UUID(),
        name: String? = nil,
        category: ItemCategory,
        subCategory: ItemSubCategory,
        brand: String? = nil,
        imageName: String? = nil,
        imageColor: String? = nil,
        aiGenerated: Bool = false,
        colors: [String] = [],
        pattern: String? = nil,
        formality: FormalityLevel = .casual,
        styleTags: [String] = [],
        seasons: [Season] = [],
        materialType: String? = nil,
        aiConfidence: Double = 0.0,
        isFavorite: Bool = false,
        notes: String? = nil,
        isArchived: Bool = false,
        timesWorn: Int = 0,
        lastWornDate: Date? = nil,
        userId: UUID = UUID(),
        needsSync: Bool = false
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.name = name
        self.category = category
        self.subCategory = subCategory
        self.brand = brand
        self.imageName = imageName
        self.imageColor = imageColor
        self.aiGenerated = aiGenerated
        self.colors = colors
        self.pattern = pattern
        self.formality = formality
        self.styleTags = styleTags
        self.seasons = seasons
        self.materialType = materialType
        self.aiConfidence = aiConfidence
        self.isFavorite = isFavorite
        self.notes = notes
        self.isArchived = isArchived
        self.timesWorn = timesWorn
        self.lastWornDate = lastWornDate
        self.userId = userId
        self.needsSync = needsSync
    }
    
    var displayName: String {
        name ?? "\(colors.first?.capitalized ?? "") \(subCategory.displayName)"
    }
    
    var costPerWear: Decimal? {
        guard let price = purchasePrice, timesWorn > 0 else { return nil }
        return price / Decimal(timesWorn)
    }
}

// MARK: - String Extension

extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") { result, char in
            if CharacterSet.uppercaseLetters.contains(char) {
                return result + " " + String(char)
            }
            return result + String(char)
        }.trimmingCharacters(in: .whitespaces).capitalized
    }
}


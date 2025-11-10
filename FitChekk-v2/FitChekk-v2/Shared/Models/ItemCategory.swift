//
//  ItemCategory.swift
//  FitChekk-v2
//
//  Categories for wardrobe items
//

import Foundation

enum ItemCategory: String, Codable, CaseIterable, Identifiable {
    case tops = "Tops"
    case bottoms = "Bottoms"
    case dresses = "Dresses"
    case outerwear = "Outerwear"
    case shoes = "Shoes"
    case accessories = "Accessories"
    case activewear = "Activewear"
    case swimwear = "Swimwear"
    case sleepwear = "Sleepwear"
    case underwear = "Underwear"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "line.3.horizontal"
        case .dresses: return "figure.dress.line.vertical.figure"
        case .outerwear: return "wind"
        case .shoes: return "shoe"
        case .accessories: return "bag"
        case .activewear: return "figure.walk"
        case .swimwear: return "drop"
        case .sleepwear: return "moon"
        case .underwear: return "circle.grid.2x2"
        }
    }

    /// Subcategories for each main category
    var subcategories: [String] {
        switch self {
        case .tops:
            return ["T-Shirt", "Shirt", "Blouse", "Tank Top", "Sweater", "Hoodie", "Polo"]
        case .bottoms:
            return ["Jeans", "Pants", "Shorts", "Skirt", "Leggings", "Chinos"]
        case .dresses:
            return ["Casual", "Formal", "Cocktail", "Maxi", "Mini", "Midi"]
        case .outerwear:
            return ["Jacket", "Coat", "Blazer", "Cardigan", "Vest", "Raincoat"]
        case .shoes:
            return ["Sneakers", "Boots", "Heels", "Flats", "Sandals", "Loafers"]
        case .accessories:
            return ["Hat", "Scarf", "Belt", "Bag", "Jewelry", "Sunglasses", "Watch"]
        case .activewear:
            return ["Sports Bra", "Athletic Top", "Athletic Bottom", "Gym Shoes"]
        case .swimwear:
            return ["Swimsuit", "Bikini", "Trunks", "Cover-up"]
        case .sleepwear:
            return ["Pajamas", "Nightgown", "Robe"]
        case .underwear:
            return ["Bra", "Underwear", "Socks", "Tights"]
        }
    }
}

/// Formality level (1-5 scale)
enum Formality: Int, Codable, CaseIterable {
    case veryCanual = 1
    case casual = 2
    case smartCasual = 3
    case formal = 4
    case veryFormal = 5

    var description: String {
        switch self {
        case .veryCanual: return "Very Casual"
        case .casual: return "Casual"
        case .smartCasual: return "Smart Casual"
        case .formal: return "Formal"
        case .veryFormal: return "Very Formal"
        }
    }
}

/// Season suitability
enum Season: String, Codable, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
    case allSeason = "All Season"
}

/// Color options (simplified for mockup)
enum ItemColor: String, Codable, CaseIterable {
    case black = "Black"
    case white = "White"
    case gray = "Gray"
    case brown = "Brown"
    case beige = "Beige"
    case navy = "Navy"
    case blue = "Blue"
    case red = "Red"
    case pink = "Pink"
    case purple = "Purple"
    case green = "Green"
    case yellow = "Yellow"
    case orange = "Orange"
    case multicolor = "Multicolor"
}

/// Pattern types
enum Pattern: String, Codable, CaseIterable {
    case solid = "Solid"
    case striped = "Striped"
    case plaid = "Plaid"
    case floral = "Floral"
    case geometric = "Geometric"
    case animal = "Animal Print"
    case polkaDot = "Polka Dot"
    case abstract = "Abstract"
}

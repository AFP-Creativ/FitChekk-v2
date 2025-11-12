import Foundation

// MARK: - Item Category
enum ItemCategory: String, Codable, CaseIterable {
    case tops
    case bottoms
    case dresses
    case outerwear
    case shoes
    case accessories

    var displayName: String {
        switch self {
        case .tops: return "Tops"
        case .bottoms: return "Bottoms"
        case .dresses: return "Dresses"
        case .outerwear: return "Outerwear"
        case .shoes: return "Shoes"
        case .accessories: return "Accessories"
        }
    }

    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "figure.walk"
        case .dresses: return "figure.dress.line.vertical.figure"
        case .outerwear: return "coat"
        case .shoes: return "shoe"
        case .accessories: return "bag"
        }
    }
}

// MARK: - Item Sub-Category
enum ItemSubCategory: String, Codable, CaseIterable {
    // Tops
    case graphicTees, basicTees, dressedUpTops, sweaters, bodysuits
    case activewear, buttonDowns, tanks, croppedTops

    // Bottoms
    case jeans, shorts, skirts, leggings, dressPants, casualPants

    // Dresses
    case dayDresses, partyDresses, rompers, maxiDresses, casualDresses

    // Outerwear
    case jackets, coats, blazers, rainJackets, vests

    // Shoes
    case heels, flats, sneakers, boots, sandals

    // Accessories
    case hats, bags, belts, sunglasses, scarves, jewelry

    var displayName: String {
        rawValue.camelCaseToWords()
    }

    var category: ItemCategory {
        // Map each subcategory to its parent category
        switch self {
        case .graphicTees, .basicTees, .dressedUpTops, .sweaters, .bodysuits,
             .activewear, .buttonDowns, .tanks, .croppedTops:
            return .tops
        case .jeans, .shorts, .skirts, .leggings, .dressPants, .casualPants:
            return .bottoms
        case .dayDresses, .partyDresses, .rompers, .maxiDresses, .casualDresses:
            return .dresses
        case .jackets, .coats, .blazers, .rainJackets, .vests:
            return .outerwear
        case .heels, .flats, .sneakers, .boots, .sandals:
            return .shoes
        case .hats, .bags, .belts, .sunglasses, .scarves, .jewelry:
            return .accessories
        }
    }
}

// MARK: - Formality Level
enum FormalityLevel: Int, Codable, CaseIterable {
    case veryCasual = 1
    case casual = 2
    case smartCasual = 3
    case business = 4
    case formal = 5

    var displayName: String {
        switch self {
        case .veryCasual: return "Super casual"
        case .casual: return "Everyday casual"
        case .smartCasual: return "Dressed up but chill"
        case .business: return "Office appropriate"
        case .formal: return "Fancy occasion"
        }
    }
}

// MARK: - Season
enum Season: String, Codable, CaseIterable {
    case spring
    case summer
    case fall
    case winter

    var displayName: String { rawValue.capitalized }

    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .fall: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

// MARK: - Subscription Tier
enum SubscriptionTier: String, Codable, CaseIterable {
    case free
    case premium

    var displayName: String { rawValue.capitalized }
}

// MARK: - Subscription Status
enum SubscriptionStatus: String, Codable, CaseIterable {
    case active
    case canceled
    case expired
    case trial

    var displayName: String { rawValue.capitalized }
}

// MARK: - String Extensions
extension String {
    func camelCaseToWords() -> String {
        unicodeScalars.reduce("") { result, char in
            if CharacterSet.uppercaseLetters.contains(char) {
                return result + " " + String(char)
            }
            return result + String(char)
        }.trimmingCharacters(in: .whitespaces).capitalized
    }
}

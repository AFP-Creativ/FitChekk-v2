//
//  PreviewData.swift
//  FitChekk-v2
//
//  Comprehensive mock data for previews and testing
//

import Foundation

struct PreviewData {
    // MARK: - Users

    static let freeUser = User.mockFree()
    static let premiumUser = User.mockPremium()

    // MARK: - Wardrobe Items

    static let wardrobeItems: [WardrobeItem] = [
        // Tops
        WardrobeItem(
            name: "Navy Crew Neck Sweater",
            category: .tops,
            subcategory: "Sweater",
            brand: "Uniqlo",
            colors: [.navy],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.fall, .winter, .spring],
            styleTags: ["minimalist", "casual"],
            isFavorite: true,
            timesWorn: 12,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())
        ),
        WardrobeItem(
            name: "White Oxford Shirt",
            category: .tops,
            subcategory: "Shirt",
            brand: "Brooks Brothers",
            colors: [.white],
            pattern: .solid,
            formality: .formal,
            seasons: [.allSeason],
            styleTags: ["classic", "professional"],
            timesWorn: 24,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
        ),
        WardrobeItem(
            name: "Striped T-Shirt",
            category: .tops,
            subcategory: "T-Shirt",
            colors: [.white, .navy],
            pattern: .striped,
            formality: .casual,
            seasons: [.spring, .summer],
            styleTags: ["casual", "nautical"],
            timesWorn: 8
        ),
        WardrobeItem(
            name: "Black Turtleneck",
            category: .tops,
            subcategory: "Sweater",
            brand: "Everlane",
            colors: [.black],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.fall, .winter],
            styleTags: ["minimalist", "sophisticated"],
            isFavorite: true,
            timesWorn: 15
        ),
        WardrobeItem(
            name: "Gray Hoodie",
            category: .tops,
            subcategory: "Hoodie",
            colors: [.gray],
            pattern: .solid,
            formality: .casual,
            seasons: [.fall, .spring],
            styleTags: ["athletic", "casual"],
            timesWorn: 20
        ),
        WardrobeItem(
            name: "Floral Blouse",
            category: .tops,
            subcategory: "Blouse",
            colors: [.pink, .white],
            pattern: .floral,
            formality: .smartCasual,
            seasons: [.spring, .summer],
            styleTags: ["feminine", "romantic"],
            timesWorn: 6
        ),

        // Bottoms
        WardrobeItem(
            name: "Dark Wash Jeans",
            category: .bottoms,
            subcategory: "Jeans",
            brand: "Levi's",
            colors: [.blue],
            pattern: .solid,
            formality: .casual,
            seasons: [.allSeason],
            styleTags: ["classic", "versatile"],
            isFavorite: true,
            timesWorn: 30,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())
        ),
        WardrobeItem(
            name: "Black Dress Pants",
            category: .bottoms,
            subcategory: "Pants",
            brand: "Theory",
            colors: [.black],
            pattern: .solid,
            formality: .formal,
            seasons: [.allSeason],
            styleTags: ["professional", "tailored"],
            timesWorn: 18
        ),
        WardrobeItem(
            name: "Khaki Chinos",
            category: .bottoms,
            subcategory: "Chinos",
            brand: "J.Crew",
            colors: [.beige],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.spring, .summer, .fall],
            styleTags: ["preppy", "smart casual"],
            timesWorn: 14
        ),
        WardrobeItem(
            name: "Blue Midi Skirt",
            category: .bottoms,
            subcategory: "Skirt",
            colors: [.blue],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.spring, .summer, .fall],
            styleTags: ["feminine", "elegant"],
            timesWorn: 7
        ),
        WardrobeItem(
            name: "Black Leggings",
            category: .bottoms,
            subcategory: "Leggings",
            colors: [.black],
            pattern: .solid,
            formality: .casual,
            seasons: [.allSeason],
            styleTags: ["athletic", "comfortable"],
            timesWorn: 25
        ),

        // Dresses
        WardrobeItem(
            name: "Navy Wrap Dress",
            category: .dresses,
            subcategory: "Casual",
            colors: [.navy],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.spring, .summer, .fall],
            styleTags: ["classic", "flattering"],
            isFavorite: true,
            timesWorn: 10
        ),
        WardrobeItem(
            name: "Black Cocktail Dress",
            category: .dresses,
            subcategory: "Formal",
            colors: [.black],
            pattern: .solid,
            formality: .formal,
            seasons: [.allSeason],
            styleTags: ["elegant", "sophisticated"],
            timesWorn: 5,
            notes: "Perfect for events"
        ),
        WardrobeItem(
            name: "Floral Maxi Dress",
            category: .dresses,
            subcategory: "Maxi",
            colors: [.multicolor],
            pattern: .floral,
            formality: .casual,
            seasons: [.summer],
            styleTags: ["bohemian", "relaxed"],
            timesWorn: 8
        ),

        // Outerwear
        WardrobeItem(
            name: "Navy Peacoat",
            category: .outerwear,
            subcategory: "Coat",
            brand: "J.Crew",
            colors: [.navy],
            pattern: .solid,
            formality: .formal,
            seasons: [.fall, .winter],
            styleTags: ["classic", "preppy"],
            timesWorn: 22
        ),
        WardrobeItem(
            name: "Gray Wool Blazer",
            category: .outerwear,
            subcategory: "Blazer",
            brand: "Banana Republic",
            colors: [.gray],
            pattern: .solid,
            formality: .formal,
            seasons: [.allSeason],
            styleTags: ["professional", "polished"],
            timesWorn: 16
        ),
        WardrobeItem(
            name: "Black Leather Jacket",
            category: .outerwear,
            subcategory: "Jacket",
            colors: [.black],
            pattern: .solid,
            formality: .casual,
            seasons: [.fall, .spring],
            styleTags: ["edgy", "cool"],
            isFavorite: true,
            timesWorn: 13
        ),
        WardrobeItem(
            name: "Beige Cardigan",
            category: .outerwear,
            subcategory: "Cardigan",
            colors: [.beige],
            pattern: .solid,
            formality: .casual,
            seasons: [.spring, .fall],
            styleTags: ["cozy", "relaxed"],
            timesWorn: 19
        ),

        // Shoes
        WardrobeItem(
            name: "White Sneakers",
            category: .shoes,
            subcategory: "Sneakers",
            brand: "Common Projects",
            colors: [.white],
            pattern: .solid,
            formality: .casual,
            seasons: [.allSeason],
            styleTags: ["minimalist", "versatile"],
            isFavorite: true,
            timesWorn: 45
        ),
        WardrobeItem(
            name: "Black Ankle Boots",
            category: .shoes,
            subcategory: "Boots",
            brand: "Stuart Weitzman",
            colors: [.black],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.fall, .winter, .spring],
            styleTags: ["classic", "versatile"],
            timesWorn: 28
        ),
        WardrobeItem(
            name: "Brown Leather Loafers",
            category: .shoes,
            subcategory: "Loafers",
            brand: "Cole Haan",
            colors: [.brown],
            pattern: .solid,
            formality: .formal,
            seasons: [.spring, .summer, .fall],
            styleTags: ["preppy", "polished"],
            timesWorn: 14
        ),
        WardrobeItem(
            name: "Navy Flats",
            category: .shoes,
            subcategory: "Flats",
            colors: [.navy],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.spring, .summer, .fall],
            styleTags: ["comfortable", "professional"],
            timesWorn: 22
        ),

        // Accessories
        WardrobeItem(
            name: "Brown Leather Belt",
            category: .accessories,
            subcategory: "Belt",
            colors: [.brown],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.allSeason],
            styleTags: ["classic"],
            timesWorn: 40
        ),
        WardrobeItem(
            name: "Black Tote Bag",
            category: .accessories,
            subcategory: "Bag",
            brand: "Longchamp",
            colors: [.black],
            pattern: .solid,
            formality: .smartCasual,
            seasons: [.allSeason],
            styleTags: ["professional", "practical"],
            timesWorn: 60
        ),
        WardrobeItem(
            name: "Silk Scarf",
            category: .accessories,
            subcategory: "Scarf",
            colors: [.multicolor],
            pattern: .geometric,
            formality: .smartCasual,
            seasons: [.spring, .fall],
            styleTags: ["elegant", "feminine"],
            timesWorn: 8
        )
    ]

    // MARK: - Outfits

    static let outfits: [Outfit] = [
        Outfit(
            name: "Smart Casual Office",
            itemIDs: [
                wardrobeItems[1].id, // White Oxford Shirt
                wardrobeItems[7].id, // Black Dress Pants
                wardrobeItems[19].id  // Brown Leather Loafers
            ],
            occasion: .work,
            season: .allSeason,
            aiGenerated: true,
            aiReasoning: "This classic combination balances professionalism with comfort. The white oxford shirt provides a crisp, polished look, while the black dress pants maintain formality. Brown leather loafers add a touch of sophistication and work well with the neutral palette.",
            timesWorn: 8,
            isFavorite: true
        ),
        Outfit(
            name: "Weekend Casual",
            itemIDs: [
                wardrobeItems[2].id, // Striped T-Shirt
                wardrobeItems[6].id, // Dark Wash Jeans
                wardrobeItems[17].id  // White Sneakers
            ],
            occasion: .casual,
            season: .spring,
            aiGenerated: false,
            timesWorn: 12,
            isFavorite: true
        ),
        Outfit(
            name: "Cozy Fall Look",
            itemIDs: [
                wardrobeItems[0].id, // Navy Crew Neck Sweater
                wardrobeItems[8].id, // Khaki Chinos
                wardrobeItems[18].id  // Black Ankle Boots
            ],
            occasion: .casual,
            season: .fall,
            aiGenerated: true,
            aiReasoning: "Perfect for crisp fall days. The navy sweater provides warmth while maintaining a clean, minimalist aesthetic. Khaki chinos offer a neutral complement, and black ankle boots add a touch of edge while keeping you comfortable for all-day wear.",
            timesWorn: 6
        ),
        Outfit(
            name: "Date Night Chic",
            itemIDs: [
                wardrobeItems[3].id, // Black Turtleneck
                wardrobeItems[9].id, // Blue Midi Skirt
                wardrobeItems[18].id  // Black Ankle Boots
            ],
            occasion: .date,
            season: .fall,
            aiGenerated: true,
            aiReasoning: "A sophisticated and modern look. The black turtleneck creates a sleek silhouette, while the blue midi skirt adds a pop of color and feminine touch. Ankle boots complete the look with contemporary edge.",
            userRating: 5,
            timesWorn: 3,
            isFavorite: true
        ),
        Outfit(
            name: "Professional Meeting",
            itemIDs: [
                wardrobeItems[1].id, // White Oxford Shirt
                wardrobeItems[14].id, // Gray Wool Blazer
                wardrobeItems[7].id, // Black Dress Pants
                wardrobeItems[19].id  // Brown Leather Loafers
            ],
            occasion: .work,
            season: .allSeason,
            aiGenerated: false,
            userRating: 4,
            timesWorn: 5
        ),
        Outfit(
            name: "Casual Friday",
            itemIDs: [
                wardrobeItems[4].id, // Gray Hoodie
                wardrobeItems[6].id, // Dark Wash Jeans
                wardrobeItems[17].id  // White Sneakers
            ],
            occasion: .work,
            season: .spring,
            aiGenerated: true,
            aiReasoning: "Relaxed yet put-together for casual workplace environments. The gray hoodie keeps it comfortable, while dark jeans maintain a polished appearance. White sneakers tie everything together with a clean, modern vibe.",
            timesWorn: 7
        )
    ]

    // MARK: - Weather Data

    static let currentWeather = WeatherSnapshot.mockSunny()
    static let forecast = WeatherSnapshot.mockForecast()

    // MARK: - Planner Entries

    static func plannerEntries() -> [Date: UUID] {
        var entries: [Date: UUID] = [:]
        let calendar = Calendar.current

        // Today's outfit
        if let today = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) {
            entries[today] = outfits[0].id
        }

        // Tomorrow's outfit
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()),
           let tomorrowStart = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) {
            entries[tomorrowStart] = outfits[2].id
        }

        // Day after tomorrow
        if let dayAfter = calendar.date(byAdding: .day, value: 2, to: Date()),
           let dayAfterStart = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dayAfter) {
            entries[dayAfterStart] = outfits[1].id
        }

        return entries
    }

    // MARK: - Helper Methods

    /// Get items by category
    static func items(for category: ItemCategory) -> [WardrobeItem] {
        wardrobeItems.filter { $0.category == category }
    }

    /// Get favorite items
    static var favoriteItems: [WardrobeItem] {
        wardrobeItems.filter { $0.isFavorite }
    }

    /// Get recently worn items
    static var recentlyWornItems: [WardrobeItem] {
        wardrobeItems
            .filter { $0.lastWornDate != nil }
            .sorted { ($0.lastWornDate ?? .distantPast) > ($1.lastWornDate ?? .distantPast) }
            .prefix(10)
            .map { $0 }
    }

    /// Get outfit by ID
    static func outfit(withID id: UUID) -> Outfit? {
        outfits.first { $0.id == id }
    }

    /// Get items for an outfit
    static func items(for outfit: Outfit) -> [WardrobeItem] {
        outfit.items(from: wardrobeItems)
    }
}

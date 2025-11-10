//
//  MockData.swift
//  FitChekk-v2
//
//  Realistic mock data for UI testing
//

import Foundation

struct MockData {
    // MARK: - Users
    
    static let currentUser = User(
        id: UUID(),
        email: "emma@example.com",
        displayName: "Emma",
        subscriptionTier: .premium
    )
    
    static let freeUser = User(
        id: UUID(),
        email: "david@example.com",
        displayName: "David",
        subscriptionTier: .free
    )
    
    static let userPreferences = UserPreferences(
        userId: currentUser.id,
        stylePreferences: ["Minimalist", "Classic", "Preppy"],
        favoriteColors: ["navy", "white", "camel", "black"],
        lifestyleType: "remote_worker",
        activityLevel: "moderate",
        occasions: ["work", "casual", "date"],
        climateType: "temperate_four_seasons",
        onboardingCompleted: true
    )
    
    // MARK: - Wardrobe Items
    
    static let wardrobeItems: [WardrobeItem] = [
        // Tops
        WardrobeItem(
            name: "Navy Cable Knit Sweater",
            category: .tops,
            subCategory: .sweaters,
            brand: "J.Crew",
            imageColor: "#1B3A5F",
            aiGenerated: true,
            colors: ["navy", "cream"],
            pattern: "cable knit",
            formality: .smartCasual,
            styleTags: ["classic", "preppy", "cozy"],
            seasons: [.fall, .winter, .spring],
            materialType: "wool",
            aiConfidence: 0.94,
            isFavorite: true,
            timesWorn: 12,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())
        ),
        WardrobeItem(
            name: "White Linen Button-Down",
            category: .tops,
            subCategory: .buttonDowns,
            brand: "Everlane",
            imageColor: "#FAFAF9",
            aiGenerated: true,
            colors: ["white"],
            pattern: "solid",
            formality: .businessCasual,
            styleTags: ["minimalist", "clean", "professional"],
            seasons: [.spring, .summer],
            materialType: "linen",
            aiConfidence: 0.96,
            isFavorite: false,
            timesWorn: 8,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())
        ),
        WardrobeItem(
            name: "Black Cashmere Turtleneck",
            category: .tops,
            subCategory: .sweaters,
            brand: "Uniqlo",
            imageColor: "#2D2A27",
            aiGenerated: true,
            colors: ["black"],
            pattern: "solid",
            formality: .smartCasual,
            styleTags: ["minimalist", "elegant", "versatile"],
            seasons: [.fall, .winter],
            materialType: "cashmere",
            aiConfidence: 0.98,
            isFavorite: true,
            timesWorn: 15,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
        ),
        WardrobeItem(
            name: "Striped Breton Top",
            category: .tops,
            subCategory: .graphicTees,
            brand: "Saint James",
            imageColor: "#1B3A5F",
            aiGenerated: true,
            colors: ["navy", "white"],
            pattern: "striped",
            formality: .casual,
            styleTags: ["nautical", "classic", "french"],
            seasons: [.spring, .summer, .fall],
            materialType: "cotton",
            aiConfidence: 0.92,
            isFavorite: false,
            timesWorn: 6,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -14, to: Date())
        ),
        WardrobeItem(
            name: "Cream Silk Blouse",
            category: .tops,
            subCategory: .dressedUpTops,
            brand: "Madewell",
            imageColor: "#FAF8F5",
            aiGenerated: true,
            colors: ["cream", "ivory"],
            pattern: "solid",
            formality: .businessCasual,
            styleTags: ["elegant", "professional", "soft"],
            seasons: [.spring, .summer, .fall],
            materialType: "silk",
            aiConfidence: 0.90,
            isFavorite: false,
            timesWorn: 4,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -21, to: Date())
        ),
        
        // Bottoms
        WardrobeItem(
            name: "Dark Wash Straight Jeans",
            category: .bottoms,
            subCategory: .jeans,
            brand: "Levi's",
            imageColor: "#3A352F",
            aiGenerated: true,
            colors: ["indigo", "blue"],
            pattern: "solid",
            formality: .casual,
            styleTags: ["classic", "versatile", "everyday"],
            seasons: [.fall, .winter, .spring],
            materialType: "denim",
            aiConfidence: 0.95,
            isFavorite: true,
            timesWorn: 20,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())
        ),
        WardrobeItem(
            name: "Camel Chinos",
            category: .bottoms,
            subCategory: .dressPants,
            brand: "Bonobos",
            imageColor: "#D4C5B9",
            aiGenerated: true,
            colors: ["camel", "tan", "beige"],
            pattern: "solid",
            formality: .smartCasual,
            styleTags: ["preppy", "clean", "versatile"],
            seasons: [.spring, .summer, .fall],
            materialType: "cotton",
            aiConfidence: 0.93,
            isFavorite: true,
            timesWorn: 18,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())
        ),
        WardrobeItem(
            name: "Black Ankle Pants",
            category: .bottoms,
            subCategory: .dressPants,
            brand: "Everlane",
            imageColor: "#2D2A27",
            aiGenerated: true,
            colors: ["black"],
            pattern: "solid",
            formality: .businessCasual,
            styleTags: ["minimalist", "professional", "tailored"],
            seasons: [.fall, .winter, .spring],
            materialType: "wool blend",
            aiConfidence: 0.97,
            isFavorite: false,
            timesWorn: 10,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())
        ),
        WardrobeItem(
            name: "Navy Wool Trousers",
            category: .bottoms,
            subCategory: .dressPants,
            brand: "Theory",
            imageColor: "#1B3A5F",
            aiGenerated: true,
            colors: ["navy"],
            pattern: "solid",
            formality: .business,
            styleTags: ["professional", "tailored", "classic"],
            seasons: [.fall, .winter, .spring],
            materialType: "wool",
            aiConfidence: 0.96,
            isFavorite: false,
            timesWorn: 7,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())
        ),
        
        // Outerwear
        WardrobeItem(
            name: "Navy Peacoat",
            category: .outerwear,
            subCategory: .coats,
            brand: "J.Crew",
            imageColor: "#1B3A5F",
            aiGenerated: true,
            colors: ["navy"],
            pattern: "solid",
            formality: .smartCasual,
            styleTags: ["classic", "nautical", "warm"],
            seasons: [.fall, .winter],
            materialType: "wool",
            aiConfidence: 0.98,
            isFavorite: true,
            timesWorn: 14,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())
        ),
        WardrobeItem(
            name: "Tan Trench Coat",
            category: .outerwear,
            subCategory: .coats,
            brand: "Burberry",
            imageColor: "#D4C5B9",
            aiGenerated: true,
            colors: ["camel", "tan"],
            pattern: "solid",
            formality: .business,
            styleTags: ["classic", "elegant", "timeless"],
            seasons: [.spring, .fall],
            materialType: "cotton gabardine",
            aiConfidence: 0.99,
            isFavorite: true,
            timesWorn: 8,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -12, to: Date())
        ),
        WardrobeItem(
            name: "Grey Wool Blazer",
            category: .outerwear,
            subCategory: .blazers,
            brand: "Banana Republic",
            imageColor: "#8B8681",
            aiGenerated: true,
            colors: ["grey", "charcoal"],
            pattern: "solid",
            formality: .businessCasual,
            styleTags: ["professional", "versatile", "tailored"],
            seasons: [.fall, .winter, .spring],
            materialType: "wool",
            aiConfidence: 0.95,
            isFavorite: false,
            timesWorn: 6,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -20, to: Date())
        ),
        
        // Footwear
        WardrobeItem(
            name: "White Leather Sneakers",
            category: .footwear,
            subCategory: .sneakers,
            brand: "Common Projects",
            imageColor: "#FAFAF9",
            aiGenerated: true,
            colors: ["white"],
            pattern: "solid",
            formality: .casual,
            styleTags: ["minimalist", "clean", "versatile"],
            seasons: [.spring, .summer, .fall],
            materialType: "leather",
            aiConfidence: 0.97,
            isFavorite: true,
            timesWorn: 25,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
        ),
        WardrobeItem(
            name: "Black Chelsea Boots",
            category: .footwear,
            subCategory: .boots,
            brand: "Blundstone",
            imageColor: "#2D2A27",
            aiGenerated: true,
            colors: ["black"],
            pattern: "solid",
            formality: .smartCasual,
            styleTags: ["versatile", "sturdy", "classic"],
            seasons: [.fall, .winter, .spring],
            materialType: "leather",
            aiConfidence: 0.98,
            isFavorite: true,
            timesWorn: 16,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())
        ),
        WardrobeItem(
            name: "Brown Leather Loafers",
            category: .footwear,
            subCategory: .flats,
            brand: "Cole Haan",
            imageColor: "#7A6F5F",
            aiGenerated: true,
            colors: ["brown", "cognac"],
            pattern: "solid",
            formality: .businessCasual,
            styleTags: ["professional", "comfortable", "classic"],
            seasons: [.spring, .summer, .fall],
            materialType: "leather",
            aiConfidence: 0.94,
            isFavorite: false,
            timesWorn: 9,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())
        ),
        
        // Accessories
        WardrobeItem(
            name: "Tan Leather Tote",
            category: .accessories,
            subCategory: .bags,
            brand: "Cuyana",
            imageColor: "#D4C5B9",
            aiGenerated: true,
            colors: ["tan", "camel"],
            pattern: "solid",
            formality: .businessCasual,
            styleTags: ["minimalist", "professional", "versatile"],
            seasons: [.spring, .summer, .fall, .winter],
            materialType: "leather",
            aiConfidence: 0.96,
            isFavorite: true,
            timesWorn: 30,
            lastWornDate: Date()
        ),
        WardrobeItem(
            name: "Cashmere Scarf",
            category: .accessories,
            subCategory: .scarves,
            brand: "Everlane",
            imageColor: "#D4C5B9",
            aiGenerated: true,
            colors: ["camel", "cream"],
            pattern: "solid",
            formality: .casual,
            styleTags: ["cozy", "elegant", "soft"],
            seasons: [.fall, .winter],
            materialType: "cashmere",
            aiConfidence: 0.92,
            isFavorite: false,
            timesWorn: 12,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())
        )
    ]
    
    // MARK: - Outfits
    
    static let outfits: [Outfit] = [
        Outfit(
            name: "Work from Home Chic",
            occasion: .work,
            season: .fall,
            notes: "Perfect for video calls - professional on top, comfy on bottom",
            aiGenerated: true,
            aiReasoning: "This navy sweater pairs beautifully with your camel chinos for today's 72° weather. The casual-smart vibe is perfect for your work-from-home video calls, and you haven't worn this combination in 2 weeks.",
            aiStyleScore: 0.94,
            weatherSnapshot: WeatherSnapshot(
                date: Date(),
                tempHigh: 72,
                tempLow: 58,
                condition: "Partly Cloudy",
                feelsLike: 68,
                humidity: 55
            ),
            timesWorn: 3,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()),
            userRating: 5,
            itemIds: [wardrobeItems[0].id, wardrobeItems[6].id, wardrobeItems[13].id]
        ),
        Outfit(
            name: "Casual Weekend",
            occasion: .weekend,
            season: .fall,
            aiGenerated: false,
            timesWorn: 5,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
            userRating: 4,
            itemIds: [wardrobeItems[3].id, wardrobeItems[5].id, wardrobeItems[12].id]
        ),
        Outfit(
            name: "Date Night",
            occasion: .date,
            season: .fall,
            notes: "Got compliments!",
            aiGenerated: false,
            timesWorn: 2,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -21, to: Date()),
            userRating: 5,
            itemIds: [wardrobeItems[2].id, wardrobeItems[7].id, wardrobeItems[13].id]
        ),
        Outfit(
            name: "Professional Meeting",
            occasion: .work,
            season: .fall,
            aiGenerated: true,
            aiReasoning: "A polished combination for important meetings. The blazer elevates the look while remaining comfortable.",
            aiStyleScore: 0.91,
            timesWorn: 4,
            lastWornDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
            userRating: 4,
            itemIds: [wardrobeItems[1].id, wardrobeItems[8].id, wardrobeItems[11].id, wardrobeItems[14].id]
        )
    ]
    
    // MARK: - Weather
    
    static let todayWeather = WeatherSnapshot(
        date: Date(),
        tempHigh: 72,
        tempLow: 58,
        condition: "Partly Cloudy",
        feelsLike: 68,
        humidity: 55
    )
    
    static let weekWeather: [WeatherSnapshot] = [
        todayWeather,
        WeatherSnapshot(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            tempHigh: 68,
            tempLow: 55,
            condition: "Cloudy",
            feelsLike: 65,
            humidity: 60
        ),
        WeatherSnapshot(
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            tempHigh: 65,
            tempLow: 52,
            condition: "Light Rain",
            feelsLike: 62,
            humidity: 75
        ),
        WeatherSnapshot(
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            tempHigh: 70,
            tempLow: 56,
            condition: "Sunny",
            feelsLike: 68,
            humidity: 50
        ),
        WeatherSnapshot(
            date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
            tempHigh: 74,
            tempLow: 60,
            condition: "Sunny",
            feelsLike: 72,
            humidity: 45
        )
    ]
    
    // MARK: - Planner Entries
    
    static let plannerEntries: [PlannerEntry] = [
        PlannerEntry(
            date: Date(),
            outfitId: outfits[0].id,
            isWorn: false,
            cachedWeather: todayWeather
        ),
        PlannerEntry(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            outfitId: outfits[1].id,
            isWorn: false,
            cachedWeather: weekWeather[1]
        ),
        PlannerEntry(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            outfitId: outfits[2].id,
            isWorn: true,
            markedWornAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        )
    ]
}


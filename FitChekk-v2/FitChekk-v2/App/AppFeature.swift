//
//  AppFeature.swift
//  FitChekk-v2
//
//  Root app feature managing navigation and global state
//

import SwiftUI
import Observation

// MARK: - App State

@Observable
class AppState {
    enum Tab: String, CaseIterable {
        case home, wardrobe, outfits, planner, settings
        
        var title: String {
            rawValue.capitalized
        }
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .wardrobe: return "tshirt"
            case .outfits: return "hanger"
            case .planner: return "calendar"
            case .settings: return "gear"
            }
        }
        
        var iconFilled: String {
            switch self {
            case .home: return "house.fill"
            case .wardrobe: return "tshirt.fill"
            case .outfits: return "hanger"
            case .planner: return "calendar"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    // MARK: - State
    
    var selectedTab: Tab = .home
    var currentUser: User = MockData.currentUser
    var userPreferences: UserPreferences = MockData.userPreferences
    var isAuthenticated: Bool = true // Mock authentication state
    var hasCompletedOnboarding: Bool = true // For mockup, we'll bypass onboarding by default
    
    // Feature states
    var wardrobeItems: [WardrobeItem] = MockData.wardrobeItems
    var outfits: [Outfit] = MockData.outfits
    var plannerEntries: [PlannerEntry] = MockData.plannerEntries
    
    // MARK: - Actions
    
    func selectTab(_ tab: Tab) {
        selectedTab = tab
    }
    
    func addWardrobeItem(_ item: WardrobeItem) {
        wardrobeItems.append(item)
    }
    
    func updateWardrobeItem(_ item: WardrobeItem) {
        if let index = wardrobeItems.firstIndex(where: { $0.id == item.id }) {
            wardrobeItems[index] = item
        }
    }
    
    func deleteWardrobeItem(_ item: WardrobeItem) {
        wardrobeItems.removeAll { $0.id == item.id }
    }
    
    func toggleFavorite(_ item: WardrobeItem) {
        if let index = wardrobeItems.firstIndex(where: { $0.id == item.id }) {
            wardrobeItems[index].isFavorite.toggle()
        }
    }
    
    func addOutfit(_ outfit: Outfit) {
        outfits.append(outfit)
    }
    
    func updateOutfit(_ outfit: Outfit) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
        }
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        outfits.removeAll { $0.id == outfit.id }
    }
    
    func schedulePlannerEntry(_ entry: PlannerEntry) {
        // Remove existing entry for this date if any
        plannerEntries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: entry.date) }
        plannerEntries.append(entry)
    }
    
    func getOutfit(id: UUID) -> Outfit? {
        outfits.first { $0.id == id }
    }
    
    func getItem(id: UUID) -> WardrobeItem? {
        wardrobeItems.first { $0.id == id }
    }
    
    func getPlannerEntry(for date: Date) -> PlannerEntry? {
        plannerEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}


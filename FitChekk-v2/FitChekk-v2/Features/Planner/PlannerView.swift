//
//  PlannerView.swift
//  FitChekk-v2
//
//  Calendar planner for scheduling outfits
//

import SwiftUI

struct PlannerView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @State private var showDateDetail = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Month navigation
                    monthNavigation
                    
                    // Calendar
                    calendarGrid
                    
                    // Selected date detail
                    if showDateDetail {
                        selectedDateSection
                    }
                    
                    // Quick actions
                    quickPlanningSection
                }
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Outfit Planner")
        }
    }
    
    // MARK: - Month Navigation
    
    private var monthNavigation: some View {
        HStack {
            Button {
                withAnimation {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.accentPrimary)
            }
            
            Spacer()
            
            Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                .font(.displaySmall)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button {
                withAnimation {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.accentPrimary)
            }
        }
        .padding(.horizontal, Spacing.screenHorizontal)
    }
    
    // MARK: - Calendar Grid
    
    private var calendarGrid: some View {
        VStack(spacing: Spacing.sm) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.labelSmall.weight(.semibold))
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, Spacing.xs)
            
            // Days grid
            let daysInMonth = getDaysInMonth()
            let startingSpaces = getStartingSpaces()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                // Empty spaces for days before month starts
                ForEach(0..<startingSpaces, id: \.self) { _ in
                    Color.clear
                        .frame(height: 60)
                }
                
                // Days of month
                ForEach(1...daysInMonth, id: \.self) { day in
                    let date = getDate(for: day)
                    let entry = appState.getPlannerEntry(for: date)
                    let isToday = Calendar.current.isDateInToday(date)
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    
                    DayCell(
                        day: day,
                        isToday: isToday,
                        isSelected: isSelected,
                        hasOutfit: entry?.outfitId != nil,
                        isWorn: entry?.isWorn ?? false
                    ) {
                        withAnimation {
                            selectedDate = date
                            showDateDetail = true
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.screenHorizontal)
    }
    
    // MARK: - Selected Date Section
    
    private var selectedDateSection: some View {
        VStack(spacing: Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedDate.formatted(date: .complete, time: .omitted))
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)
                    
                    // Weather
                    if let weather = MockData.weekWeather.first(where: {
                        Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: weather.conditionIcon)
                            Text("\(Int(weather.tempHigh))° / \(Int(weather.tempLow))°")
                            Text("•")
                            Text(weather.condition)
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            // Scheduled outfit or empty state
            if let entry = appState.getPlannerEntry(for: selectedDate),
               let outfitId = entry.outfitId,
               let outfit = appState.getOutfit(id: outfitId) {
                // Show scheduled outfit
                OutfitCard(outfit: outfit) {
                    // View outfit detail
                }
                
                HStack(spacing: Spacing.sm) {
                    if !entry.isWorn {
                        PrimaryButton(title: "Mark as Worn") {
                            // Mark worn
                        }
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.success)
                            Text("Worn")
                                .font(.bodyLarge.weight(.semibold))
                                .foregroundColor(.success)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.md)
                        .background(Color.success.opacity(0.1))
                        .cornerRadius(CornerRadius.md)
                    }
                    
                    SecondaryButton(title: "Change") {
                        // Change outfit
                    }
                }
            } else {
                // No outfit scheduled
                VStack(spacing: Spacing.md) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.textTertiary)
                    
                    Text("No outfit scheduled")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    
                    if appState.currentUser.subscriptionTier == .premium {
                        PrimaryButton(title: "Get AI Suggestion") {
                            // Get AI suggestion for this date
                        }
                        
                        SecondaryButton(title: "Choose Outfit") {
                            // Pick from existing outfits
                        }
                    } else {
                        PrimaryButton(title: "Upgrade for AI Suggestions") {
                            // Show paywall
                        }
                    }
                }
                .padding(.vertical, Spacing.xl)
            }
        }
        .padding(Spacing.lg)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.xl)
        .padding(.horizontal, Spacing.screenHorizontal)
    }
    
    // MARK: - Quick Planning
    
    private var quickPlanningSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Quick Actions")
                .font(.displaySmall)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenHorizontal)
            
            VStack(spacing: Spacing.sm) {
                Button {
                    // Plan this week
                } label: {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.accentPrimary)
                        Text("Plan This Week")
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.md)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.md)
                }
                
                Button {
                    // Plan next week
                } label: {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.logoPrimary)
                        Text("Plan Next Week")
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.md)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.md)
                }
                
                Button {
                    // Clear schedule
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.error)
                        Text("Clear This Week")
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.md)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.md)
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
    
    // MARK: - Helper Functions
    
    private func getDaysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: currentMonth)
        return range?.count ?? 30
    }
    
    private func getStartingSpaces() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        let firstOfMonth = Calendar.current.date(from: components) ?? currentMonth
        let weekday = Calendar.current.component(.weekday, from: firstOfMonth)
        return weekday - 1
    }
    
    private func getDate(for day: Int) -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        var dayComponents = components
        dayComponents.day = day
        return Calendar.current.date(from: dayComponents) ?? Date()
    }
}

// MARK: - Day Cell

struct DayCell: View {
    let day: Int
    let isToday: Bool
    let isSelected: Bool
    let hasOutfit: Bool
    let isWorn: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.bodyMedium.weight(isToday ? .bold : .regular))
                    .foregroundColor(isSelected ? .white : .textPrimary)
                
                if hasOutfit {
                    Circle()
                        .fill(isWorn ? Color.success : Color.accentPrimary)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(isSelected ? Color.accentPrimary : (isToday ? Color.accentPrimary.opacity(0.1) : Color.clear))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PlannerView()
        .environment(AppState())
}


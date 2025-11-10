//
//  PlannerFeature.swift
//  FitChekk-v2
//
//  Created for UI Mockups - TCA Structure
//

import SwiftUI

// MARK: - State

@Observable
class PlannerState {
    var selectedDate: Date = Date()
    var plannedOutfits: [Date: MockOutfit] = [:]
    var calendarMonth: Date = Date()
    
    var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: calendarMonth)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: calendarMonth))!
        
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }
    }
    
    func outfitForDate(_ date: Date) -> MockOutfit? {
        let key = Calendar.current.startOfDay(for: date)
        return plannedOutfits[key]
    }
    
    func hasOutfit(_ date: Date) -> Bool {
        outfitForDate(date) != nil
    }
}

// MARK: - Actions

enum PlannerAction {
    case onAppear
    case dateSelected(Date)
    case monthChanged(Date)
    case addOutfitTapped(Date)
    case getAISuggestionTapped(Date)
}

// MARK: - View

struct PlannerView: View {
    @State private var state = PlannerState()
    @State private var showingDayDetail = false
    @State private var selectedDay: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Calendar Header
                calendarHeader
                
                // Calendar Grid
                calendarGrid
                
                // Selected Day Detail
                if showingDayDetail {
                    dayDetailSection
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Planner")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        selectedDay = Date()
                        showingDayDetail = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.accentPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Calendar Header
    
    private var calendarHeader: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.accentPrimary)
            }
            
            Spacer()
            
            Text(monthYearString)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.accentPrimary)
            }
        }
        .padding(.horizontal, Spacing.screenMargin)
        .padding(.vertical, Spacing.standard)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: state.calendarMonth)
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: state.calendarMonth) {
            state.calendarMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: state.calendarMonth) {
            state.calendarMonth = newDate
        }
    }
    
    // MARK: - Calendar Grid
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, Spacing.verticalTight)
            
            // Calendar days
            let calendar = Calendar.current
            let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: state.calendarMonth))!
            let firstWeekday = calendar.component(.weekday, from: firstDay)
            let adjustedFirstWeekday = (firstWeekday + 5) % 7 // Convert to 0-6 (Sun=0)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                // Empty cells for days before month starts
                ForEach(0..<adjustedFirstWeekday, id: \.self) { _ in
                    Color.clear
                        .frame(height: 50)
                }
                
                // Calendar days
                ForEach(state.daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDay),
                        hasOutfit: state.hasOutfit(date),
                        isToday: Calendar.current.isDateInToday(date)
                    ) {
                        selectedDay = date
                        showingDayDetail = true
                    }
                }
            }
            .padding(.horizontal, Spacing.screenMargin)
        }
    }
    
    // MARK: - Day Detail Section
    
    private var dayDetailSection: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            // Day header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dayString)
                        .font(.title2)
                        .foregroundColor(.textPrimary)
                    
                    Text(dateString)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Button(action: { showingDayDetail = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.horizontal, Spacing.screenMargin)
            .padding(.top, Spacing.standard)
            
            // Weather preview
            weatherPreview
            
            // Outfit section
            if let outfit = state.outfitForDate(selectedDay) {
                plannedOutfitSection(outfit: outfit)
            } else {
                noOutfitSection
            }
        }
        .padding(.bottom, Spacing.bottomSafeArea)
        .background(Color.backgroundPrimary)
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: selectedDay)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: selectedDay)
    }
    
    private var weatherPreview: some View {
        HStack {
            Image(systemName: "cloud.sun.fill")
                .foregroundColor(.accentPrimary)
            Text("72° Partly Cloudy")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, Spacing.screenMargin)
    }
    
    private func plannedOutfitSection(outfit: MockOutfit) -> some View {
        VStack(alignment: .leading, spacing: Spacing.group) {
            Text("Planned Outfit")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenMargin)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.group) {
                    ForEach(outfit.items) { item in
                        ItemCardView(item: item)
                            .frame(width: 120)
                    }
                }
                .padding(.horizontal, Spacing.screenMargin)
            }
        }
    }
    
    private var noOutfitSection: some View {
        VStack(spacing: Spacing.group) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)
            
            Text("No outfit planned")
                .font(.headline)
                .foregroundColor(.textSecondary)
            
            HStack(spacing: Spacing.group) {
                Button(action: {}) {
                    Text("Add Outfit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.standard)
                        .padding(.vertical, Spacing.verticalTight)
                        .background(Color.accentPrimary)
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Text("Get AI Suggestion")
                        .font(.headline)
                        .foregroundColor(.accentPrimary)
                        .padding(.horizontal, Spacing.standard)
                        .padding(.vertical, Spacing.verticalTight)
                        .background(Color.accentPrimary.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.generous)
        .cardStyle()
        .padding(.horizontal, Spacing.screenMargin)
    }
}

// MARK: - Calendar Day View

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasOutfit: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(dayNumber)")
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white : (isToday ? .accentPrimary : .textPrimary))
                
                if hasOutfit {
                    Circle()
                        .fill(isSelected ? .white : .accentPrimary)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 44, height: 44)
            .background(isSelected ? Color.accentPrimary : Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday && !isSelected ? Color.accentPrimary : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
}

#Preview {
    PlannerView()
}


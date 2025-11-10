import SwiftUI
import ComposableArchitecture

struct PlannerView: View {
    @Bindable var store: StoreOf<PlannerFeature>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                calendarGrid
            }
            .background(Color.backgroundPrimary(for: colorScheme).ignoresSafeArea())
            .navigationTitle("Planner")
            .sheet(item: $store.scope(state: \.dayDetail, action: \.dayDetail)) { store in
                DayDetailView(store: store)
            }
        }
        .task { store.send(.onAppear) }
    }

    private var header: some View {
        HStack {
            Button(action: { store.send(.previousMonth) }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(store.currentMonth.formatted(.dateTime.month().year()))
                .font(.headline)
            Spacer()
            Button(action: { store.send(.nextMonth) }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(16)
    }

    private var calendarGrid: some View {
        let weeks = makeCalendar(for: store.currentMonth)
        return VStack(spacing: 8) {
            HStack {
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { d in
                    Text(d)
                        .font(.caption)
                        .foregroundColor(Color.textSecondary(for: colorScheme))
                        .frame(maxWidth: .infinity)
                }
            }
            ForEach(weeks, id: \.self) { week in
                HStack(spacing: 8) {
                    ForEach(week, id: \.self) { date in
                        Button {
                            store.send(.selectDate(date))
                        } label: {
                            Text("\(Calendar.current.component(.day, from: date))")
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .foregroundColor(Color.textPrimary(for: colorScheme))
                                .background(Color.backgroundSecondary(for: colorScheme))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 12)
    }

    private func makeCalendar(for month: Date) -> [[Date]] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Sunday
        let range = calendar.range(of: .day, in: .month, for: month)!
        let components = calendar.dateComponents([.year, .month], from: month)
        let firstOfMonth = calendar.date(from: components)!

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        var days: [Date] = []

        // Pad with previous month's days to align start
        if firstWeekday > 1 {
            for i in stride(from: firstWeekday - 2, through: 0, by: -1) {
                if let date = calendar.date(byAdding: .day, value: -i - 1, to: firstOfMonth) {
                    days.append(date)
                }
            }
        }

        // Current month days
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }

        // Chunk into weeks of 7
        var weeks: [[Date]] = []
        var index = 0
        while index < days.count {
            let end = min(index + 7, days.count)
            weeks.append(Array(days[index..<end]))
            index = end
        }
        return weeks
    }
}

struct DayDetailView: View {
    @Bindable var store: StoreOf<DayDetailFeature>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(store.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.title2.bold())
                    .foregroundColor(Color.textPrimary(for: colorScheme))

                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.accentPrimary)
                    Text("74°, Sunny")
                        .foregroundColor(Color.textSecondary(for: colorScheme))
                }

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundSecondary(for: colorScheme))
                    .frame(height: 160)
                    .overlay(
                        VStack {
                            Image(systemName: "tshirt.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.accentPrimary)
                            Text("No outfit planned")
                                .foregroundColor(Color.textSecondary(for: colorScheme))
                        }
                    )

                Button("Get AI Suggestion") { }
                    .buttonStyle(PrimaryButtonStyle())
                Button("Choose Existing Outfit") { }
                    .buttonStyle(PrimaryBorderedButtonStyle())
            }
            .padding(20)
            .navigationTitle("Day")
        }
    }
}

#Preview {
    PlannerView(
        store: Store(initialState: PlannerFeature.State()) {
            PlannerFeature()
        }
    )
}



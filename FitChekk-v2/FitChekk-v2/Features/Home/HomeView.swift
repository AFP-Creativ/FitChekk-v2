import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    weatherStrip
                    outfitCard
                    quickActions
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.backgroundPrimary(for: colorScheme).ignoresSafeArea())
            .navigationTitle("")
            .navigationBarHidden(true)
            .task { store.send(.onAppear) }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Good morning, \(store.userFirstName)! 👋")
                .font(.title.bold())
                .foregroundColor(Color.textPrimary(for: colorScheme))
            Text(store.dateString)
                .font(.subheadline)
                .foregroundColor(Color.textSecondary(for: colorScheme))
        }
    }

    private var weatherStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weather")
                .font(.headline)
                .foregroundColor(Color.textPrimary(for: colorScheme))
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .foregroundColor(.accentPrimary)
                Text(store.weatherSummary)
                    .foregroundColor(Color.textPrimary(for: colorScheme))
                Spacer()
            }
            .padding(16)
            .background(Color.backgroundSecondary(for: colorScheme))
            .cornerRadius(16)

            HStack(spacing: 12) {
                ForEach(Array(store.weatherForecast.enumerated()), id: \.offset) { _, temp in
                    VStack {
                        Text("\(temp)°")
                            .font(.subheadline)
                            .foregroundColor(Color.textSecondary(for: colorScheme))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var outfitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Outfit")
                .font(.headline)
                .foregroundColor(Color.textPrimary(for: colorScheme))

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.backgroundSecondary(for: colorScheme))
                    .shadow(color: Color.accentPrimary.opacity(0.10), radius: 16, y: 6)
                VStack(spacing: 16) {
                    Image(systemName: "tshirt.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .foregroundColor(Color.accentPrimary)
                        .padding(.top, 20)

                    Text("“\(store.outfitReasoning)”")
                        .font(.body)
                        .foregroundColor(Color.textPrimary(for: colorScheme))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)

                    VStack(spacing: 12) {
                        Button("Use This Outfit") {
                            store.send(.useThisTapped)
                        }
                        .font(.body.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.accentPrimary)
                        .cornerRadius(12)

                        Button("Suggest Another") {
                            store.send(.suggestAnotherTapped)
                        }
                        .font(.body)
                        .foregroundColor(.accentPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.backgroundElevated)
                        .cornerRadius(12)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 340)
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(Color.textPrimary(for: colorScheme))
            HStack(spacing: 16) {
                QuickActionButton(title: "Add Item", systemName: "camera.fill")
                QuickActionButton(title: "Wardrobe", systemName: "hanger")
                QuickActionButton(title: "Planner", systemName: "calendar")
                QuickActionButton(title: "Settings", systemName: "gear")
            }
        }
    }
}

private struct QuickActionButton: View {
    let title: String
    let systemName: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemName)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentPrimary)
                .clipShape(Circle())
                .shadow(color: Color.accentPrimary.opacity(0.3), radius: 8, y: 4)

            Text(title)
                .font(.caption)
                .foregroundColor(Color.textSecondary(for: colorScheme))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    )
}



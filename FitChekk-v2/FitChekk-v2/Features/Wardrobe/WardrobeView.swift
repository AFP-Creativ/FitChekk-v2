import SwiftUI
import ComposableArchitecture

struct WardrobeView: View {
    @Bindable var store: StoreOf<WardrobeFeature>
    @Environment(\.colorScheme) private var colorScheme

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(store.items) { item in
                        ItemCard(item: item)
                            .onTapGesture { store.send(.itemTapped(item)) }
                            .contextMenu {
                                Button(item.isFavorite ? "Unfavorite" : "Favorite") {
                                    store.send(.toggleFavorite(item))
                                }
                            }
                    }
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary(for: colorScheme).ignoresSafeArea())
            .navigationTitle("My Closet")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Image(systemName: "plus")
                }
            }
            .searchable(
                text: $store.searchQuery.sending(\.searchQueryChanged),
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Search items")
            )
            .sheet(item: $store.scope(state: \.itemDetail, action: \.itemDetail)) { store in
                ItemDetailView(store: store)
            }
        }
    }
}

private struct ItemCard: View {
    let item: WardrobeItemModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "\(item.imageSystemName).fill")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding(16)
                .foregroundColor(.accentPrimary)
                .frame(maxWidth: .infinity)

            HStack {
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(Color.textPrimary(for: colorScheme))
                    .lineLimit(1)
                Spacer()
                if item.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.accentPrimary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color.backgroundSecondary(for: colorScheme))
        .cornerRadius(16)
        .shadow(color: Color.accentPrimary.opacity(0.08), radius: 12, y: 4)
    }
}

struct ItemDetailView: View {
    @Bindable var store: StoreOf<ItemDetailFeature>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.backgroundSecondary(for: colorScheme))
                        Image(systemName: "tshirt.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentPrimary)
                            .padding(40)
                    }
                    .frame(height: 280)

                    infoRow(title: "Category", value: "Tops > Sweaters")
                    infoRow(title: "Colors", value: "Navy, White")
                    infoRow(title: "Season", value: "Fall, Winter")
                    infoRow(title: "Formality", value: "Casual (2/5)")

                    HStack(spacing: 12) {
                        Button("♥ Favorite") { }
                            .buttonStyle(PrimaryBorderedButtonStyle())
                        Button("Create Outfit") { }
                            .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(20)
            }
            .background(Color.backgroundPrimary(for: colorScheme).ignoresSafeArea())
            .navigationTitle(store.item.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { }
                }
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text("\(title):")
                .foregroundColor(Color.textSecondary(for: colorScheme))
            Text(value)
                .foregroundColor(Color.textPrimary(for: colorScheme))
            Spacer()
        }
        .font(.subheadline)
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.accentPrimary.opacity(configuration.isPressed ? 0.9 : 1.0))
            .cornerRadius(12)
    }
}

private struct PrimaryBorderedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundColor(.accentPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentPrimary, lineWidth: 2)
            )
    }
}

#Preview {
    WardrobeView(
        store: Store(initialState: WardrobeFeature.State()) {
            WardrobeFeature()
        }
    )
}



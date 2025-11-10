import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $store.notificationsEnabled.sending(\.toggleNotifications)) {
                        Text("Notifications")
                    }
                    Toggle(isOn: $store.useMetric.sending(\.toggleMetric)) {
                        Text("Use Metric Units")
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(
        store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    )
}



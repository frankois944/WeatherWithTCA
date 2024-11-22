//
//  SettingsView.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    
    @Bindable var store: StoreOf<SettingsFeature>
    
    
    
    init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Behaviour")) {
                    Picker(selection: $store.weatherConfig.unit.sending(\.setTemperatureUnit),
                           label: Text("Unit")) {
                        Text("Celsius").tag(TemperatureUnit.celsius)
                        Text("Fahrenheit").tag(TemperatureUnit.faranheit)
                        Text("Kelvin").tag(TemperatureUnit.kelvin)
                    }.pickerStyle(.automatic)
                }
                Section(header: Text("Location")) {
                    if let location = store.weatherConfig.location {
                        LabeledContent(location.name) {
                            Button("Change") {
                                store.send(.setLocationTapped)
                            }
                        }
                    } else {
                        Button("Select a location") {
                            store.send(.setLocationTapped)
                        }
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.setLocation, action: \.setLocation)) { locationStore in
            NavigationStack {
                WeatherLocationSelectorView(store: locationStore)
            }
        }
    }
}

#Preview {
    SettingsView(store: .init(initialState: SettingsFeature.State(), reducer: {
        SettingsFeature()
    }))
}


#Preview {
    SettingsView(store: .init(initialState: SettingsFeature.State(),  reducer: {
        SettingsFeature()
    }))
}

//
//  RootView.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        NavigationStack {
            TabView {
                WeatherView(store: store.scope(state: \.tab1, action: \.tab1))
                    .tabItem {
                        Image(systemName: "cloud.sun")
                        Text("Weather")
                    }
                NavigationView {
                    SettingsView(store: store.scope(state: \.tab2, action: \.tab2))
                        .navigationTitle("Settings")
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .sheet(item: $store.scope(state: \.setLocation, action: \.setLocation)) { locationStore in
                NavigationStack {
                    WeatherLocationSelectorView(store: locationStore)
                        .interactiveDismissDisabled()
                }
            }
            .task {
                await store.send(.onAppear).finish()
            }
        }
    }
}

#Preview {
    RootView(store: .init(initialState: RootFeature.State()) {
        RootFeature()
    })
}

#Preview {
    @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init(location: .init(name: "Paris MOCK", lon: 10, lat: 10), unit: .faranheit)
    
    RootView(store: .init(initialState: RootFeature.State()) {
        return RootFeature()
    })
}

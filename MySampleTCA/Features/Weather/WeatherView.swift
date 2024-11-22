//
//  MainView.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 20/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct WeatherView: View {
    @Bindable var store: StoreOf<WeatherFeature>
    
    var body: some View {
        VStack {
            if let location = store.weatherConfig.location {
                Text(location.name)
                if store.weatherData.lastUpdate != nil {
                    Text("\(store.weatherData.temperature)")
                }
                if store.isLoading {
                    ProgressView("Loading weather")
                }
            }
        }
    }
}

#Preview {
    WeatherView(
        store: Store(initialState: WeatherFeature.State()) {
            WeatherFeature()
        }
    )
}

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
            if store.weatherConfig.location != nil, store.weatherData.lastUpdate != nil {
                GeometryReader { proxy in
                    ScrollView {
                        WeatherContent(weatherData: store.weatherData,
                                       weatherConfig: store.weatherConfig)
                        .frame(height: proxy.size.height)
                    }
                    .refreshable {
                        await Task.detached {
                            await store.send(.startRequest(store.weatherConfig)).finish()
                        }.value
                    }
                }.ignoresSafeArea()
            }
        }.overlay {
            if store.isLoading {
                ProgressView("Loading weather")
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

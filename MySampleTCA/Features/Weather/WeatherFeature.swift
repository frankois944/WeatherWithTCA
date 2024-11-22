//
//  Untitled.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 20/11/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WeatherFeature {

    @Dependency(\.weatherFinder) var weatherFinder

    @ObservableState
    struct State: Equatable {
        @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init()
        @Shared(.storedWeatherData) var weatherData: WeatherData = .init()
        var isLoading = false
        var error: String? = nil
    }

    enum Action: Equatable {
        case startRequest(WeatherConfig)
        case endRequest(WeatherData?)
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startRequest(let config):
                guard let location = config.location else { return .none }
                state.isLoading = true
                state.error = nil
                return .run { send in
                    let result = await weatherFinder.findWeather(request: .init(unit: config.unit,
                                                                                lat: location.lat,
                                                                                lon: location.lon)
                    )
                    await send(.endRequest(result))
                }
            case .endRequest(let data):
                state.isLoading = false
                guard let data else { return .none }
                state.weatherData = data
                return .none
            case .onAppear:
                return .publisher {
                    state.$weatherConfig.publisher.map(Action.startRequest)
                }.merge(with: .send(.startRequest(state.weatherConfig)))
            }
        }
    }

}


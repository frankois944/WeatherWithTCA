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
    }
    
    enum Action: Equatable {
        case startRequest(WeatherConfig)
        case endRequest(WeatherData)
        case failedRequest(String)
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startRequest(let config):
                guard let location = config.location else { return .none }
                state.isLoading = true
                return .run { send in
                    do {
                        let result = try await weatherFinder.findWeather(request: .init(unit: config.unit,
                                                                                        lat: location.lat,
                                                                                        lon: location.lon)
                        )
                        await send(.endRequest(result))
                    } catch {
                        await send(.failedRequest(error.localizedDescription))
                    }
                }
            case .failedRequest(let error):
                print("findWeather: \(error)")
                state.isLoading = false
                return .none
            case .endRequest(let data):
                state.isLoading = false
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


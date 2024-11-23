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
    
    // MARK: - Dependency
    
    @Dependency(\.weatherFinder) var weatherFinder
    
    // MARK: - State
    
    @ObservableState
    struct State: Equatable {
        @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init()
        @Shared(.storedWeatherData) var weatherData: WeatherData = .init()
        var isLoading = false
    }
    
    
    // MARK: - Action
    
    enum Action: Equatable {
        
        // MARK: Weather
        
        case startRequest(WeatherConfig)
        case endRequest(WeatherData)
        case failedRequest(String)
        
        // MARK: Lifecycle
        
        case onAppear
    }
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
                // MARK: Weather
                
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
                
                // MARK: Lifecycle
                
            case .onAppear:
                return .publisher {
                    state.$weatherConfig.publisher.map(Action.startRequest)
                }.merge(with: .send(.startRequest(state.weatherConfig)))
            }
        }
    }
    
}


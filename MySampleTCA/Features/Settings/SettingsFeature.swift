//
//  SettingsFeature.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SettingsFeature {
    
    // MARK: - Dependency
    
    @Dependency(\.locationFinder) var locationFinder
    
    // MARK: - State
    
    @ObservableState
    struct State: Equatable {
        @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init()
        
        // MARK: Location
        
        @Presents var setLocation: WeatherLocationSelectorFeature.State?
    }
    
    // MARK: - Action
    
    enum Action {
        
        // MARK: Temperature
        
        case setTemperatureUnit(TemperatureUnit)
        
        // MARK: Location
        
        case setLocationTapped
        case setLocation(PresentationAction<WeatherLocationSelectorFeature.Action>)
    }
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
                // MARK: Temperature
                
            case let .setTemperatureUnit(unit):
                state.weatherConfig.unit = unit
                return .none
                
                // MARK: Location
                
            case .setLocationTapped:
                state.setLocation = WeatherLocationSelectorFeature.State()
                return .none
            case .setLocation(.presented(.delegate(.onSelectedLocationEvent(location: let location)))):
                state.weatherConfig.location = location
                return .none
            case .setLocation:
                return .none
            }
        }
        .ifLet(\.$setLocation, action: \.setLocation) {
            WeatherLocationSelectorFeature()
        }
    }
}

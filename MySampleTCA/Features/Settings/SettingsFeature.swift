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
    
    @Dependency(\.locationFinder) var locationFinder
    
    @ObservableState
    struct State: Equatable {
        @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init()
        @Presents var setLocation: WeatherLocationSelectorFeature.State?
    }
    
    enum Action {
        case setTemperatureUnit(TemperatureUnit)
        case setLocationTapped
        case setLocation(PresentationAction<WeatherLocationSelectorFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setTemperatureUnit(unit):
                state.weatherConfig.unit = unit
                return .none
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

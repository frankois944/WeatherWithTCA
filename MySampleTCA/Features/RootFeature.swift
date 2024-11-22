//
//  RootFeaturez.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct RootFeature {
    
    // MARK: - Dependency
    
    @Dependency(\.locationFinder) var locationFinder
    
    // MARK: - State
    
    @ObservableState
    struct State: Equatable {
        var tab1 = WeatherFeature.State()
        var tab2 = SettingsFeature.State()
        @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init()
        @Presents var setLocation: WeatherLocationSelectorFeature.State?
    }
    
    // MARK: - Action
    
    enum Action {
        
        // MARK: Tabs
        
        case tab1(WeatherFeature.Action)
        case tab2(SettingsFeature.Action)
        
        // MARK: Location
        
        case setLocation(PresentationAction<WeatherLocationSelectorFeature.Action>)
        
        // MARK: Lifecycle
        
        case onAppear
    }
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            WeatherFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
                
                // MARK: Location
                
            case .setLocation(.presented(.delegate(.onSelectedLocationEvent(location: let location)))):
                state.weatherConfig.location = location
                return .none
            case .setLocation:
                return .none
                
                // MARK: Lifecycle
                
            case .onAppear:
                defer {
                    if (state.weatherConfig.location == nil) {
                        state.setLocation = WeatherLocationSelectorFeature.State(firstTime: true)
                    }
                }
                state.tab1.$weatherConfig = state.$weatherConfig
                state.tab2.$weatherConfig = state.$weatherConfig
                return WeatherFeature()
                    .reduce(into: &state.tab1, action: .onAppear)
                    .map { .tab1($0) }
                
                // MARK: Tabs
                
            case .tab1:
                return .none
            case .tab2:
                return .none
            }
        }
        .ifLet(\.$setLocation, action: \.setLocation) {
            WeatherLocationSelectorFeature()
        }
    }
}

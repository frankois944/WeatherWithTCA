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
    
    @Dependency(\.locationFinder) var locationFinder
    
    @ObservableState
    struct State: Equatable {
        var tab1 = WeatherFeature.State()
        var tab2 = SettingsFeature.State()
        @Shared(.storedWeatherConfig) var weatherConfig: WeatherConfig = .init()
    }
    
    enum Action {
        case tab1(WeatherFeature.Action)
        case tab2(SettingsFeature.Action)
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            WeatherFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.tab1.$weatherConfig = state.$weatherConfig
                state.tab2.$weatherConfig = state.$weatherConfig
                return WeatherFeature()
                    .reduce(into: &state.tab1, action: .onAppear)
                    .map { .tab1($0) }
            case .tab1:
                return .none
            case .tab2:
                return .none
            }
        }
    }
}

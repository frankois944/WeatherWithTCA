//
//  WeatherLocationSelectorFeature.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WeatherLocationSelectorFeature {
    
    @Dependency(\.dismiss) var dismiss

    @Dependency(\.locationFinder) var locationFinder
    
    @ObservableState
    struct State: Equatable {
        var firstTime: Bool = false
        var isLoading: Bool = false
        var error: String? = nil
        var locations: IdentifiedArrayOf<WeatherLocation> = []
    }
    
    enum Action {
        case startRequest(request: String)
        case endRequest(response: [WeatherLocation])
        case selectLocation(location: WeatherLocation)
        case cancelTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case onSelectedLocationEvent(location: WeatherLocation)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startRequest(let request):
                state.isLoading = true
                return .run { send in
                    let result = await locationFinder.findLocation(request: .init(text: request))
                    await send(.endRequest(response: result))
                }
            case .endRequest(let response):
                state.locations = .init(uniqueElements: response)
                state.isLoading = false
                return .none
            case .selectLocation(let location):
                return .run { send in
                    await send(.delegate(.onSelectedLocationEvent(location: location)))
                    await self.dismiss()
                }
            case .cancelTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}

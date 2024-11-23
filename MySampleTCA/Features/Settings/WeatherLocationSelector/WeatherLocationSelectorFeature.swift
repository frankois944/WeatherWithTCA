//
//  WeatherLocationSelectorFeature.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct WeatherLocationSelectorFeature {
    
    // MARK: Dependency
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.locationFinder) var locationFinder
    @Dependency(\.myLocationFinder) var myLocationFinder
    
    // MARK: - State
    
    private static let myLocationItem = WeatherLocation(name: "My Location", lon: -1, lat: -1)
    
    @ObservableState
    struct State: Equatable {
        var firstTime: Bool = false
        var isLoading: Bool = false
        var locations: IdentifiedArrayOf<WeatherLocation> = [myLocationItem]
        @Presents var myLocationErrorDialog: AlertState<Action.MyLocationErrorDialog>?
    }
    
    
    // MARK: - Action
    
    enum Action {
        
        // MARK: Location Lookup
        
        case startRequest(request: String)
        case endRequest(response: [WeatherLocation])
        case selectLocation(location: WeatherLocation)
        case cancelTapped
        
        // MARK: Delegation
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case onSelectedLocationEvent(location: WeatherLocation)
        }
        
        // MARK: My Location
        
        case setMyLocationTapped
        case myLocationFailed(NSError)
        
        // MARK: My Location Error
        
        case myLocationErrorDialog(PresentationAction<MyLocationErrorDialog>)
        case showMyLocationErrorDialog(NSError)
        @CasePathable
        enum MyLocationErrorDialog: Equatable {
            case cancelTapped
            case goToParameterTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
                // MARK: Location Lookup
                
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
                    if location == WeatherLocationSelectorFeature.myLocationItem {
                        await send(.setMyLocationTapped)
                    } else {
                        await send(.delegate(.onSelectedLocationEvent(location: location)))
                        await self.dismiss()
                    }
                }
            case .cancelTapped:
                return .run { _ in await self.dismiss() }
                
                // MARK: My Location
                
            case .setMyLocationTapped:
                return .run { send in
                    do {
                        await send(.selectLocation(location: try await myLocationFinder.getLatestLocation()))
                    } catch {
                        await send(.myLocationFailed(error as NSError))
                    }
                }
            case .myLocationFailed(let error):
                if error.code == 4 {
                    return .none
                } else {
                    return .send(.showMyLocationErrorDialog(error))
                }
                
                // MARK: My Location Error
                
            case .showMyLocationErrorDialog(let error):
                state.myLocationErrorDialog = AlertState(title: {
                    TextState("Can't get my location")
                }, actions: {
                    ButtonState(role: .cancel, action: .cancelTapped) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .goToParameterTapped) {
                        TextState("Go to settings")
                    }
                }, message: {
                    TextState(error.localizedDescription)
                })
                return .none
            case .myLocationErrorDialog(.presented(.cancelTapped)):
                return .none
            case .myLocationErrorDialog(.presented(.goToParameterTapped)):
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                return .none
            case .myLocationErrorDialog:
                return .none
                
                // MARK: Delegation
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$myLocationErrorDialog, action: \.myLocationErrorDialog)
    }
}

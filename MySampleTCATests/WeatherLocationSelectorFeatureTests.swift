//
//  WeatherLocationSelectorFeatureTests.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 24/11/2024.
//

import Testing
import ComposableArchitecture
import ViewInspector
import Foundation

@testable import MySampleTCA

struct WeatherLocationSelectorFeatureTests {
    
    let testData: [WeatherLocation] = [
        .init(name: "VILLE1", lon: 1, lat: 1),
        .init(name: "VILLE2", lon: 1, lat: 1),
        .init(name: "VILLE3", lon: 1, lat: 1)
    ]
    
    let myLocationTestData = WeatherLocation(name: "My Location", lon: 42, lat: 42)
    
    @Test func searchLocation() async {
        let store = await TestStore(initialState: WeatherLocationSelectorFeature.State())  {
            WeatherLocationSelectorFeature()
        } withDependencies: {
            $0.locationFinder.findLocation = { request in
                try await Task.sleep(for: .seconds(1))
                return testData.filter {
                    $0.name.localizedCaseInsensitiveContains(request.text)
                }
            }
        }
        
        await store.send(.startRequest(request: "2")) {
            $0.isLoading = true
        }
        
        await store.receive(\.endRequest, timeout: Duration.seconds(2)) {
            $0.isLoading = false
            $0.locations = [testData[1]]
        }
        
        await store.send(.startRequest(request: "5")) {
            $0.isLoading = true
        }
        
        await store.receive(\.endRequest, timeout: Duration.seconds(2)) {
            $0.isLoading = false
            $0.locations = []
        }
    }
    
    @Test func searchMyLocation() async {
        let store = await TestStore(initialState: WeatherLocationSelectorFeature.State())  {
            WeatherLocationSelectorFeature()
        } withDependencies: {
            $0.myLocationFinder.getLatestLocation = {
                myLocationTestData
            }
        }
        
        await store.send(.selectLocation(location: WeatherLocation.MyLocation))
        
        await store.receive(\.setMyLocationTapped)
        
        await store.receive(\.selectLocation)
        
        await store.receive(\.delegate.onSelectedLocationEvent, myLocationTestData)
    }
    
    @Test func searchMyLocationRequestPermission() async {
        
        let error = NSError(domain: "Location denied", code: 2)
        
        let store = await TestStore(initialState: WeatherLocationSelectorFeature.State())  {
            WeatherLocationSelectorFeature()
        } withDependencies: {
            $0.myLocationFinder.getLatestLocation = {
                throw error
            }
        }
        
        await store.send(.selectLocation(location: WeatherLocation.MyLocation))
        
        await store.receive(\.setMyLocationTapped)
        
        await store.receive(\.myLocationFailed, error)
        
        await store.receive(\.showMyLocationErrorDialog) {
            $0.myLocationErrorDialog =  AlertState(title: {
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
        }
        await store.send(\.myLocationErrorDialog.cancelTapped) {
            $0.myLocationErrorDialog = nil
        }
    }
}

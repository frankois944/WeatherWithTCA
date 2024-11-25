//
//  MyLocation.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import Foundation
import ComposableArchitecture
import CoreLocation

@DependencyClient
struct MyLocation {
    
    private static let myLocationService = MyLocationService()
    
    var getLatestLocation: @Sendable () async throws -> WeatherLocation
}

extension DependencyValues {
    var myLocationFinder: MyLocation {
        get { self[MyLocation.self] }
        set { self[MyLocation.self] = newValue }
    }
}

extension MyLocation : DependencyKey {
    static var liveValue = Self(
        getLatestLocation: {
            try await myLocationService.getLatestLocation()
        }
    )
}

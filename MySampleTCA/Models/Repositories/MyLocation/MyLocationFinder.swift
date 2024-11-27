//
//  MyLocation.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import ComposableArchitecture

@DependencyClient
struct MyLocationFinder {
    
    private static let myLocationService = MyLocationService()
    
    var getLatestLocation: @Sendable () async throws -> WeatherLocation
}

extension DependencyValues {
    var myLocationFinder: MyLocationFinder {
        get { self[MyLocationFinder.self] }
        set { self[MyLocationFinder.self] = newValue }
    }
}

extension MyLocationFinder : DependencyKey {
    static var liveValue = Self(
        getLatestLocation: {
            try await myLocationService.getLatestLocation()
        }
    )
}

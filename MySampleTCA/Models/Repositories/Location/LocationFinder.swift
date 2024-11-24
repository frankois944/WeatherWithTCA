//
//  Untitled.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Foundation
import Dependencies
import ComposableArchitecture

@DependencyClient
struct LocationFinder {
    var findLocation: @Sendable (LocationRequest) async throws -> [WeatherLocation]
}

extension DependencyValues {
    var locationFinder: LocationFinder {
        get { self[LocationFinder.self] }
        set { self[LocationFinder.self] = newValue }
    }
}

extension LocationFinder: DependencyKey {
    
    static var liveValue = Self(
        findLocation: { request in
            print("LocationFinder: \(request.query)")
            let response = try await URLSession.shared.data(from: request.query)
            let data = try JSONDecoder().decode(LocationResponse.self, from: response.0)
            print("LocationFinder: \(data)")
            return data.results.map {
                .init(
                    name: $0.formatted,
                    lon: $0.lon,
                    lat: $0.lat
                )
            }
        }
    )
}

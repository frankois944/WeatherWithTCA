//
//  WeatherFinder.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct WeatherFinder {
    var findWeather: @Sendable (WeatherRequest) async throws -> WeatherData
}

extension DependencyValues {
    var weatherFinder: WeatherFinder {
        get { self[WeatherFinder.self] }
        set { self[WeatherFinder.self] = newValue }
    }
}

extension WeatherFinder: DependencyKey {
    
    static var liveValue = Self(
        findWeather: { request in
            print("WeatherFinder: \(request.query)")
            let response = try await URLSession.shared.data(from: request.query)
            let data = try JSONDecoder().decode(WeatherResponse.self, from: response.0)
            print("LocationFinder: \(data)")
            return .init(lastUpdate: Date(), content: data)
        }
    )
}

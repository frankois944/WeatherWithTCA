//
//  WeatherFinder.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import Foundation
import Dependencies

extension DependencyValues {
  var weatherFinder: WeatherFinder {
    get { self[WeatherFinder.self] }
    set { self[WeatherFinder.self] = newValue }
  }
}

actor WeatherFinder: DependencyKey {
    
    static var liveValue = WeatherFinder()
    
    private init() {}
    
    func findWeather(request: WeatherRequest) async -> WeatherData? {
        do {
            print("WeatherFinder: \(request.query)")
            let response = try await URLSession.shared.data(from: request.query)
            let data = try JSONDecoder().decode(WeatherResponse.self, from: response.0)
            print("LocationFinder: \(data)")
            return .init(lastUpdate: Date(), temperature: data.main.temp)
        } catch {
            print("WeatherFinder: \(error)")
        }
        return nil
    }
}

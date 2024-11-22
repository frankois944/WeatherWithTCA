//
//  WeatherConfig.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import Foundation
import ComposableArchitecture

struct WeatherConfig: Equatable, Hashable, Codable {
    var location: WeatherLocation?
    var unit: TemperatureUnit = TemperatureUnit(rawValue: UnitTemperature(forLocale: Locale.current).symbol)!
}

struct WeatherConfigPersistenceKey: PersistenceKey, Equatable {
    let id: String
    
    func load(initialValue: WeatherConfig? = .init())-> WeatherConfig? {
        if let data = UserDefaults.standard.data(forKey: "CurrentWeatherConfig") {
            return (try? JSONDecoder().decode(WeatherConfig.self, from: data)) ?? .init()
        }
        return .init()
    }
    
    func save(_ value: WeatherConfig) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: "CurrentWeatherConfig")
        }
    }
}

extension PersistenceReaderKey where Self == WeatherConfigPersistenceKey {
    static var storedWeatherConfig: WeatherConfigPersistenceKey {
        .init(id: "weatherConfigPersistenceKey")
    }
}

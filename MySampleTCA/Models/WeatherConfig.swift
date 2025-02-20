//
//  WeatherConfig.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import Foundation
import ComposableArchitecture

struct WeatherConfig: Hashable, Codable, Equatable {
    var location: WeatherLocation?
    var unit: TemperatureUnit = TemperatureUnit(rawValue: UnitTemperature(forLocale: Locale.current).symbol)!
}

struct WeatherConfigPersistenceKey: SharedKey {

    let id: String
    
    static var inMemoryValue: WeatherConfig? = .init()
    
    func subscribe(context: Sharing.LoadContext<WeatherConfig>, subscriber: Sharing.SharedSubscriber<WeatherConfig>) -> Sharing.SharedSubscription {
        .init {
            
        }
    }
    
    func load(context: LoadContext<WeatherConfig>, continuation: LoadContinuation<WeatherConfig>) {
        var value: WeatherConfig? = context.initialValue
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
            value = WeatherConfigPersistenceKey.inMemoryValue
        } else if let data = UserDefaults.standard.data(forKey: id) {
            value = (try? JSONDecoder().decode(WeatherConfig.self, from: data))
        }
        continuation.resume(returning: value ?? .init())
    }
    
    func save(_ value: WeatherConfig, context: SaveContext, continuation: SaveContinuation) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
            WeatherConfigPersistenceKey.inMemoryValue = value
        } else if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: id)
        }
        continuation.resume()
    }
}

extension SharedReaderKey where Self == WeatherConfigPersistenceKey {
    static var storedWeatherConfig: WeatherConfigPersistenceKey {
        .init(id: "CurrentWeatherConfig")
    }
}


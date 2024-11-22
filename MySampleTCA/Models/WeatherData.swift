//
//  WeatherData.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Foundation
import ComposableArchitecture

struct WeatherData: Equatable, Hashable, Codable {
    let lastUpdate: Date?
    let content: WeatherResponse?
    
    init(lastUpdate: Date? = nil, content: WeatherResponse? = nil) {
        self.lastUpdate = lastUpdate
        self.content = content
    }
}


struct WeatherDataPersistenceKey: PersistenceKey, Equatable {
    let id: String
    
    func load(initialValue: WeatherData? = .init())-> WeatherData? {
        if let data = UserDefaults.standard.data(forKey: "CurrentWeatherData") {
            return (try? JSONDecoder().decode(WeatherData.self, from: data)) ?? .init()
        }
        return .init()
    }
    
    func save(_ value: WeatherData) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: "CurrentWeatherData")
        }
    }
}

extension PersistenceReaderKey where Self == WeatherDataPersistenceKey {
    static var storedWeatherData: WeatherDataPersistenceKey {
        .init(id: "WeatherDataPersistenceKey")
    }
}
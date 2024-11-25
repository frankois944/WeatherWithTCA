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
    
    let name: String
    let icon: Int
    let temp: Double
    let description: String
    let feelsLike: Double
    let humidity: Int
    let wind: Double
    let clouds: Int
    
    init(lastUpdate: Date?, name: String, icon: Int, temp: Double, description: String, feelsLike: Double, humidity: Int, wind: Double, clouds: Int) {
        self.lastUpdate = lastUpdate
        self.name = name
        self.icon = icon
        self.temp = temp
        self.description = description
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.wind = wind
        self.clouds = clouds
    }
    
    init(lastUpdate: Date? = nil, content: WeatherResponse? = nil) {
        self.lastUpdate = lastUpdate
        self.name = content?.name ?? "N/A"
        self.icon = content?.weather.first?.id ?? 0
        self.temp = content?.main.temp ?? 0
        self.description = content?.weather.first?.description ?? "N/A"
        self.feelsLike = content?.main.feelsLike ?? 0
        self.humidity = content?.main.humidity ?? 0
        self.wind = content?.wind.speed ?? 0
        self.clouds = content?.clouds.all ?? 0
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

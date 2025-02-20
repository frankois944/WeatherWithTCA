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


struct WeatherDataPersistenceKey: SharedKey {

    let id: String
    
    static var inMemoryValue: WeatherData = .init()
    
    
    func subscribe(context: Sharing.LoadContext<WeatherData>, subscriber: Sharing.SharedSubscriber<WeatherData>) -> Sharing.SharedSubscription {
        .init {
            
        }
    }
    
    func load(context: LoadContext<WeatherData>, continuation: LoadContinuation<WeatherData>) {
        var value: WeatherData? = context.initialValue
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
            value = WeatherDataPersistenceKey.inMemoryValue
        } else if let data = UserDefaults.standard.data(forKey: id) {
            value = (try? JSONDecoder().decode(WeatherData.self, from: data))
        }
        continuation.resume(returning: value ?? .init())
    }
    
    func save(_ value: WeatherData, context: SaveContext, continuation: SaveContinuation) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
            WeatherDataPersistenceKey.inMemoryValue = value
        } else if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: id)
        }
        continuation.resume()
    }
}

extension SharedReaderKey where Self == WeatherDataPersistenceKey {
    static var storedWeatherData: WeatherDataPersistenceKey {
        .init(id: "CurrentWeatherConfig")
    }
}

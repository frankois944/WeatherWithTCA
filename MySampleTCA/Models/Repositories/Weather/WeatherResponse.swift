//
//  WeatherResponse.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: WeatherCoord
    let weather: [Weather]
    let base: String
    let main: WeatherMain
    let visibility: Int
    let wind: WeatherWind
    let rain: WeatherRain?
    let clouds: WeatherClouds
    let dt: Int
    let sys: WeatherSys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct WeatherClouds: Codable {
    let all: Int
}

// MARK: - Coord
struct WeatherCoord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct WeatherMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct WeatherRain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct WeatherSys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct WeatherWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

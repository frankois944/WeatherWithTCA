//
//  WeatherSettings.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

enum TemperatureUnit: String, Equatable, Hashable, Codable {
    case celsius = "°C", faranheit = "°F", kelvin = "K"
    
    var identifier: String {
        switch self {
        case .celsius:
            return "metric"
        case .faranheit:
            return "imperial"
        case .kelvin:
            return "standard"
        }
    }
}

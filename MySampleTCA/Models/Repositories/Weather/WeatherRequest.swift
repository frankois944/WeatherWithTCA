//
//  WeatherRequest.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import Foundation

struct WeatherRequest {
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&lang={lang}&units={units}
    let url = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey: String = "21348ee62c1f20ff000d533d6e37f011"
    let lang: String = Locale.current.language.languageCode?.identifier ?? "en"
    let unit: TemperatureUnit
    let lat: Double
    let lon: Double
    
    var query: URL {
        var urlComponents = URLComponents(string: url)
        urlComponents!.queryItems = [
            .init(name: "appid", value: apiKey),
            .init(name: "lang", value: lang),
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lon", value: "\(lon)"),
            .init(name: "units", value: unit.identifier),
        ]
        return urlComponents!.url!
    }
}

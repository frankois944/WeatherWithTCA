//
//  WeatherLocationData.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Foundation
import ComposableArchitecture

struct WeatherLocation: Equatable, Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let lon: Double
    let lat: Double
    
    init(id: UUID = UUID(), name: String, lon: Double, lat: Double) {
        self.id = id
        self.name = name
        self.lon = lon
        self.lat = lat
    }
}

extension WeatherLocation {
    static let MyLocation = WeatherLocation(name: "My Location", lon: -1, lat: -1)
}

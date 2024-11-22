//
//  LocationResponse.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

// MARK: - LocationResponse
struct LocationResponse: Codable {
    let results: [LocationResult]
}

// MARK: - Result
struct LocationResult: Codable {
    let country: String
    let city: String
    let formatted: String
    let lon: Double
    let lat: Double
}

//
//  LocationRequest.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Foundation

struct LocationRequest {
    // https://api.geoapify.com/v1/geocode/autocomplete?text=YOUR_TEXT&lang=fr&limit=5&type=city&format=json&apiKey=YOUR_API_KEY
    let url = "https://api.geoapify.com/v1/geocode/autocomplete"
    let apiKey: String = "4fc1d29d06304d7bb03a151484c61032"
    let type: String = "city"
    let lang: String = Locale.current.language.languageCode?.identifier ?? "en"
    let text: String
    
    var query: URL {
        var urlComponents = URLComponents(string: url)
        urlComponents!.queryItems = [
            .init(name: "limit", value: "10"),
            .init(name: "apiKey", value: apiKey),
            .init(name: "type", value: type),
            .init(name: "lang", value: lang),
            .init(name: "text", value: text),
            .init(name: "format", value: "json"),
        ]
        return urlComponents!.url!
    }
}

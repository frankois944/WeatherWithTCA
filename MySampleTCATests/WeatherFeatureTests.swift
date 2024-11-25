//
//  WeatherFeatureTests.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 24/11/2024.
//

import Testing
import ComposableArchitecture
import ViewInspector
import SnapshotTesting
import Foundation

@testable import MySampleTCA

struct WeatherFeatureTests {
    
    @Test func testContentView() async throws {
        let sut = WeatherContent(weatherData: .init(lastUpdate: nil, name: "MOCK", icon: 200, temp: 42, description: "MOCK DATA", feelsLike: -42, humidity: 20, wind: 5, clouds: 10),
                                 weatherConfig: .init(location: .init(name: "MOCK", lon: 0, lat: 0), unit: .celsius))
        try await ViewHosting.host(sut) { hostedView in
            try await hostedView.inspection.inspect { view in
                assertSnapshot(of: try view.actualView().body, as: .image(layout: .device(config: .iPhoneSe)))
            }
        }
    }
}

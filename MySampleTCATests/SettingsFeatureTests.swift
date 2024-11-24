//
//  SettingsFeatureTests.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 24/11/2024.
//


import Testing
import ComposableArchitecture

@testable import MySampleTCA

struct SettingsFeatureTests {

    @Test func changeTemperatureUnit() async throws {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        
        await store.send(\.tab2.setFaranheit) {
            $0.tab2.isCelsius = false
        }
    }

}

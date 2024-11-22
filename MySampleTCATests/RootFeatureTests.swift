//
//  MySampleTCATests.swift
//  MySampleTCATests
//
//  Created by Francois Dabonot on 21/11/2024.
//

import Testing
import ComposableArchitecture

@testable import MySampleTCA

struct RootFeatureTests {

    @Test func changeTemperatureUnit() async throws {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        
        await store.send(\.tab2.setFaranheit) {
            $0.tab2.isCelsius = false
        }
    }

}

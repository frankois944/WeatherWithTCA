//
//  MySampleTCAApp.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 19/11/2024.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct MySampleTCAApp: App {
    
    @Environment(\.colorScheme) var colorScheme
    
    static let store = Store(initialState: RootFeature.State()) {
        RootFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: MySampleTCAApp.store)
        }.environment(\.colorScheme, colorScheme)
    }
}

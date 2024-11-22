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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let store = Store(initialState: RootFeature.State()) {
        RootFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: MySampleTCAApp.store)
        }
        .modelContainer(sharedModelContainer)
    }
}

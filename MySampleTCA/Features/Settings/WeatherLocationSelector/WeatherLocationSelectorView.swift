//
//  WeatherLocationSelectorView.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 21/11/2024.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct WeatherLocationSelectorView: View {
    
    let store: StoreOf<WeatherLocationSelectorFeature>
    let searchTextPublisher = PassthroughSubject<String, Never>()
    
    @State var searchQuery: String
    @State private var selectedLocation: WeatherLocation?
    
    init(store: StoreOf<WeatherLocationSelectorFeature>, searchQuery: String = "") {
        self.store = store
        self.searchQuery = searchQuery
    }
    
    var body: some View {
        List(selection: $selectedLocation) {
            ForEach(store.locations.elements) { item in
                Text(item.name)
                    .onTapGesture {
                        store.send(.selectLocation(location: item))
                    }
            }
        }
        .searchable(
            text: $searchQuery,
            placement: .automatic,
            prompt: "Search a location..."
        )
        .onChange(of: searchQuery) { _, searchText in
            searchTextPublisher.send(searchText)
        }
        .onReceive(
            searchTextPublisher
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
        ) { debouncedSearchText in
            store.send(.startRequest(request: debouncedSearchText))
        }
        .overlay {
            if store.isLoading {
                ProgressView("Searching Location...")
            } else if store.locations.isEmpty && !searchQuery.isEmpty && !store.isLoading {
                ContentUnavailableView(
                    "No Location found",
                    systemImage: "magnifyingglass",
                    description: Text("No results for **\(searchQuery)**")
                )
            }
        }
        .toolbar {
            if !store.firstTime {
                ToolbarItem {
                    Button("Cancel") {
                        store.send(.cancelTapped)
                    }
                }
            }
        }
        .navigationTitle("Location")
    }
}


#Preview {
    NavigationStack {
        WeatherLocationSelectorView(store: .init(initialState: WeatherLocationSelectorFeature.State(), reducer: {
            WeatherLocationSelectorFeature()
        }))
    }
}

#Preview {
    NavigationStack {
        WeatherLocationSelectorView(store: .init(initialState: WeatherLocationSelectorFeature.State(locations: [
            .init(id: UUID(), name: "Paris, France", lon: 0, lat: 0)
        ]), reducer: {
            WeatherLocationSelectorFeature()
        }))
    }
}


#Preview {
    NavigationStack {
        WeatherLocationSelectorView(store: .init(initialState: WeatherLocationSelectorFeature.State(), reducer: {
            WeatherLocationSelectorFeature()
        }), searchQuery: "MOCK")
    }
}


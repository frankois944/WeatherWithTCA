//
//  MyLocationService.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 25/11/2024.
//

import Foundation
import ComposableArchitecture
import CoreLocation

class MyLocationService : NSObject, CLLocationManagerDelegate {

    private var manager = CLLocationManager()
    private var continutation: CheckedContinuation<WeatherLocation, any Error>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func getLatestLocation() async throws -> WeatherLocation {
        try await withCheckedThrowingContinuation { continuation in
            continutation = continuation
            checkLocationAuthorization()
        }
    }

    private func checkLocationAuthorization() {
        manager.startUpdatingLocation()
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            continutation?.resume(throwing: NSError(domain: "Authorization required", code: 4))
            continutation = nil
        case .restricted:
            continutation?.resume(throwing: NSError(domain: "Location restricted", code: 1))
            continutation = nil
        case .denied:
            continutation?.resume(throwing: NSError(domain: "Location denied", code: 2))
            continutation = nil
        case .authorizedWhenInUse, .authorizedAlways:
            guard let location = manager.location?.coordinate else { return }
            continutation?
                .resume(returning: .init(name: "My Location", lon: location.longitude, lat: location.latitude))
            continutation = nil
            manager.stopUpdatingLocation()
        @unknown default:
            continutation?.resume(throwing: NSError(domain: "Location service disabled", code: 3))
            continutation = nil
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

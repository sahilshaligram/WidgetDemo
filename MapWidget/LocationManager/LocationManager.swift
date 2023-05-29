//
//  LocationManager.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    // MARK: - Config

    private enum Config {
        static let activityType: CLActivityType = .automotiveNavigation
        static let desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        static let storageKey = "lastLocation"
    }

    // MARK: - Types
    typealias RequestLocationCompletionHandler = (Result<CLLocation, Error>) -> Void
    // MARK: - Private properties
    private var requestLocationCompletionHandlers = [RequestLocationCompletionHandler]()
    // MARK: - Dependencies
    private var locationManager: CLLocationManager?
    private let locationStorageManager: LocationStorageManaging

    // MARK: - Initializer

    init(locationStorageManager: LocationStorageManaging) {
        self.locationStorageManager = locationStorageManager
        super.init()
        setupLocationManager()
    }
    // MARK: - Public methods

    func requestLocation(_ completionHandler: @escaping RequestLocationCompletionHandler) {
        requestLocationCompletionHandlers.append(completionHandler)

        guard let locationManager = locationManager else {
            "Expect to have a valid `locationManager` instance at this point!"
                .log(level: .error)
            return
        }

        if locationManager.authorizationStatus.isAuthorized {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - Private properties

    private func setupLocationManager() {
        DispatchQueue.main.async {
            let locationManager = CLLocationManager()
            self.locationManager = locationManager

            locationManager.activityType = Config.activityType
            locationManager.desiredAccuracy = Config.desiredAccuracy
            locationManager.delegate = self
        }
    }

    private func resolveRequestLocationCompletionHandlers(with result: Result<CLLocation, Error>) {
        requestLocationCompletionHandlers.forEach { $0(result) }
        requestLocationCompletionHandlers.removeAll()
    }
}

// MARK: - CLLocationManagerDelegate -
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus.isAuthorized else {
            return
        }

        guard !requestLocationCompletionHandlers.isEmpty else {
            return
        }

        locationManager?.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else {
            return
        }
        locationStorageManager.set(location: userLocation, forKey: Config.storageKey)
        resolveRequestLocationCompletionHandlers(with: .success(userLocation))
        MapWidget.main()
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        if let locationError = error as? CLError, locationError.code == CLError.Code.locationUnknown {
            return
        }
        if let lastKnownUserLocation = locationStorageManager.location(forKey: Config.storageKey) {
            resolveRequestLocationCompletionHandlers(with: .success(lastKnownUserLocation))
        } else {
            resolveRequestLocationCompletionHandlers(with: .failure(error))
        }
    }
}

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        isAny(of: .authorizedAlways, .authorizedWhenInUse)
    }
}

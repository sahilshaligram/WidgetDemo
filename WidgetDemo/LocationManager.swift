//
//  LocationManager.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import Foundation
import CoreLocation
import MapKit

public typealias LocationHandler = (_ manager: CLLocationManager, _ location: CLLocation) -> Void

//MARK: - From here we are managing to get current location and location permission. -
//MARK: - This is a singleton class. -

class LocationManager: NSObject , CLLocationManagerDelegate {
    
    // MARK: - Dependencies -
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    var locationHandler: LocationHandler!
    let regionRadius: CLLocationDistance = 1000

    // MARK: - Public methods -
    func locationAccessPermissions() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocation(_ completionHandler: @escaping LocationHandler) {
        locationHandler = completionHandler
    }
}

//MARK: - Location Manager Methods -
extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationHandler(manager, locations.first ?? CLLocation())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

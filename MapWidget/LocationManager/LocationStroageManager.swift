//
//  LocationStroageManager.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import Foundation
import CoreLocation

protocol LocationStorageManaging {
    func set(location: CLLocation, forKey key: String)
    func location(forKey key: String) -> CLLocation?
}

extension UserDefaults: LocationStorageManaging {
    func set(location: CLLocation, forKey key: String) {
        do {
            let encodedLocationData = try NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: true)
            set(encodedLocationData, forKey: key)
        } catch {
            "Could not store location in user-defaults: \(error.localizedDescription)".log(level: .error)
        }
    }

    func location(forKey key: String) -> CLLocation? {
        guard let decodedLocationData = data(forKey: key) else {
            "Couldn't find location data for key \(key)".log(level: .error)
            return nil
        }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: CLLocation.self, from: decodedLocationData)
        } catch {
            "Couldn't decode location: \(error.localizedDescription)".log(level: .error)
            return nil
        }
    }
}

//
//  MapVC.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    //MARK: - Variables -
    var locationManager = LocationManager.shared
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.locationAccessPermissions()
        locationManager.getCurrentLocation { manager, location in
            self.addPinAtSelectedLocation(location)
        }
    }
    
    //MARK: - Add Pin at current location and zoom on there. -
    func addPinAtSelectedLocation(_ location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView.addAnnotation(pin)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

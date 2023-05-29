//
//  SnapShotManager.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class MapSnapshotManager {
    // MARK: - Types -
    typealias SnapshotCompletionHandler = (Result<Image, Error>) -> Void
    
    enum SnapshotError: Error {
        case noSnapshotImage
    }
    
    // MARK: - Config -
    enum Config {
        static let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005 )
    }
    
    // MARK: - Public methods -
    func snapshot(at centerCoordinate: CLLocationCoordinate2D,
                  completionHandler: @escaping SnapshotCompletionHandler) {
        let coordinateRegion = MKCoordinateRegion(center: centerCoordinate,
                                                  span: Config.coordinateSpan)
        let options = MKMapSnapshotter.Options()
        options.region = coordinateRegion
        MKMapSnapshotter(options: options).start { snapshot, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                completionHandler(.failure(SnapshotError.noSnapshotImage))
                return
            }
            let image = Image(uiImage: snapshot.image)
            completionHandler(.success(image))
        }
    }
}

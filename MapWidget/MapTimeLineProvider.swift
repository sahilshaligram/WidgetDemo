//
//  MapTimeLineProvider.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    // MARK: - Config -
    private enum Config {
        static let refreshTimeInterval: TimeInterval = 0
    }
    
    // MARK: - Dependencies -
    private let locationManager: LocationManager
    private let mapSnapshotManager: MapSnapshotManager
    
    // MARK: - Initializer -
    init(locationManager: LocationManager, mapSnapshotManager: MapSnapshotManager) {
        self.locationManager = locationManager
        self.mapSnapshotManager = mapSnapshotManager
    }
    
    // MARK: - Public methods -
    func placeholder(in _: Context) -> MapTimelineEntry {
        MapTimelineEntry(date: Date(), state: .placeholder)
    }
    
    func getSnapshot(in _: Context,
                     completion: @escaping (MapTimelineEntry) -> Void) {
        mapSnapshotForUserLocation { mapSnapshotResult in
            let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                    state: MapTimelineEntry.State(result: mapSnapshotResult))
            completion(mapTimelineEntry)
        }
    }
    
    func getTimeline(in _: Context,
                     completion: @escaping (Timeline<MapTimelineEntry>) -> Void) {
        mapSnapshotForUserLocation { mapSnapshotResult in
            let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                    state: MapTimelineEntry.State(result: mapSnapshotResult))
            let refreshDate = Date(timeIntervalSinceNow: Config.refreshTimeInterval)
            let timeline = Timeline(entries: [mapTimelineEntry],
                                    policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    // MARK: - Private methods -
    private func mapSnapshotForUserLocation(_ completionHandler: @escaping (Result<MapSnapshot, Error>) -> Void) {
        "Start requesting map snapshot for user location..."
            .log(level: .info)
        locationManager.requestLocation { locationResult in
            switch locationResult {
            case let .success(userLocation):
                "Received user location: \(userLocation)"
                    .log(level: .info)
                mapSnapshotManager.snapshot(at: userLocation.coordinate) { mapSnapshotResult in
                    switch mapSnapshotResult {
                    case let .success(mapImage):
                        "Successfully created map image.".log(level: .info)
                        let mapSnapshot = MapSnapshot(userLocation: userLocation, image: mapImage)
                        completionHandler(.success(mapSnapshot))
                    case let .failure(error):
                        "Failed to get map snapshot: \(error.localizedDescription)".log(level: .error)
                        completionHandler(.failure(error))
                    }
                }
            case let .failure(error):
                "Failed to get user location: \(error.localizedDescription)".log(level: .error)
                completionHandler(.failure(error))
            }
        }
    }
}

// MARK: - Helpers
private extension MapTimelineEntry.State {
    /// Maps the given result to our own state.
    ///
    /// - Parameter result: Swift's result type that represents either a successfully created map-snapshot or an occurred error.
    init(result: Result<MapSnapshot, Error>) {
        switch result {
        case let .success(mapSnapshot):
            self = .success(mapSnapshot)
            
        case let .failure(error):
            self = .failure(error)
        }
    }
}

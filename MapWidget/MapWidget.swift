//
//  MapWidget.swift
//  MapWidget
//
//  Created by Sahil Thaker on 24/05/23.
//

import WidgetKit
import SwiftUI
import CoreLocation

@main
struct MapWidget: Widget {
    // MARK: - Config -
    private enum Config {
        /// The name shown for a widget when a user adds or edits it.
        static let displayName = "Map Widget"
        /// The description shown for a widget when a user adds or edits it.
        static let description = "This is an example widget showing your current location."
        /// The sizes that our widget supports.
        static let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium]
    }
    
    // MARK: - Public properties -
    let kind: String = "MapWidget"
    
    // MARK: - Dependencies -
    private let locationManager = LocationManager(locationStorageManager: UserDefaults.standard)
    private let mapSnapshotManager = MapSnapshotManager()
    
    // MARK: - Render -
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider(locationManager: locationManager,
                                                          mapSnapshotManager: mapSnapshotManager)) { entry in
            MapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Config.displayName)
        .description(Config.description)
        .supportedFamilies(Config.supportedFamilies)
    }
}

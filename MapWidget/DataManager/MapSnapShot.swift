//
//  MapSnapShot.swift
//  WidgetDemo
//
//  Created by Sahil Thaker on 24/05/23.
//

import Foundation
import CoreLocation
import SwiftUI
import WidgetKit

//MARK: - In this structure i am passing user's location and the snapshot image to show in the widget. -
struct MapSnapshot {
    let userLocation: CLLocation
    let image: Image
}

struct MapTimelineEntry: TimelineEntry {
    // MARK: - Public properties -
    let date: Date
    let state: State
    
    
    // MARK: - Types -
    enum State {
        case placeholder
        case success(MapSnapshot)
        case failure(Error)
    }
}

//
//  WidgetView.swift
//  MapWidgetExtension
//
//  Created by Sahil Thaker on 24/05/23.
//

import Foundation
import SwiftUI
import CoreLocation
import WidgetKit

struct MapWidgetEntryView : View {
    
    // MARK: - Public properties -
    let entry: Provider.Entry
    
    // MARK: - Render -
    var body: some View {
        switch entry.state {
        case let .success(mapSnapshot):
            MapUserLocationView(mapSnapshot: mapSnapshot)
            
        case let .failure(error):
            ErrorView(errorMessage: error.localizedDescription)
            
        case .placeholder:
            ErrorView(errorMessage: nil)
        }
    }
}

private struct MapUserLocationView: View {
    
    // MARK: - Config -
    private enum Config {
        static let userLocationDotSize: CGFloat = 20
        static let validUserLocationTimeInterval: TimeInterval = 5 * 60
    }
    
    // MARK: - Public properties -
    let mapSnapshot: MapSnapshot
    
    // MARK: - Private properties -
    var circleFillColor: Color {
        mapSnapshot.userLocation.timestamp > Date(timeIntervalSinceNow: -Config.validUserLocationTimeInterval)
            ? .blue
            : .gray
    }
    
    // MARK: - Render -
    var body: some View {
        ZStack {
            mapSnapshot.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Circle()
                .foregroundColor(circleFillColor)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .frame(width: Config.userLocationDotSize,
                       height: Config.userLocationDotSize)
        }
    }
}

private struct ErrorView: View {
    
    // MARK: - Config -
    private enum Config {
        static let fallbackColor = Color(red: 225 / 255,
                                         green: 239 / 255,
                                         blue: 210 / 255)
    }
    
    // MARK: - Public properties -
    let errorMessage: String?
    
    // MARK: - Render -
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Config.fallbackColor
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .padding()
            }
        }
    }
}

struct MapWidget_Previews: PreviewProvider {
    static var previews: some View {
        let appleParkLocation = CLLocation(latitude: 20.593683, longitude: 78.962883)
        let mapSnapshot = MapSnapshot(userLocation: appleParkLocation,
                                      image: Image("bgImage"))
        let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                state: .success(mapSnapshot))
        return Group {
            MapWidgetEntryView(entry: mapTimelineEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MapWidgetEntryView(entry: mapTimelineEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}

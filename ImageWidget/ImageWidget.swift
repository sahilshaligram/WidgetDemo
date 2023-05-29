//
//  ImageWidget.swift
//  ImageWidget
//
//  Created by Sahil Thaker on 23/05/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ImageWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        //MARK: - Here is a simple demo of showing an image from assets file. -
        ZStack {
            Image("bgImage")
                .resizable()
                .frame(alignment: .center)
            Text("Sahil")
                .font(.largeTitle)
                .bold()
        }
    }
}

@main
struct ImageWidget: Widget {
    let kind: String = "ImageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ImageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ImageWidget_Previews: PreviewProvider {
    static var previews: some View {
        ImageWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}

//
//  FlipWidget.swift
//  FlipWidget
//
//  Created by Jesal Patel on 7/25/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), yearlyRead: 20)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), yearlyRead: getYearlyRead())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), yearlyRead: getYearlyRead())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func getYearlyRead() -> Int {
        let dataController = DataController()
        let yearlyRead = dataController.yearlyReadCount()
        return yearlyRead
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let yearlyRead: Int
}

struct FlipWidgetEntryView: View {
    var entry: Provider.Entry

    @AppStorage(
        "themeChoice",
        store: UserDefaults(suiteName: "group.dev.jesal.Flip")
    ) var themeChoice: Color.ThemeChoice = .mint
    @AppStorage(
        "readingGoal",
        store: UserDefaults(suiteName: "group.dev.jesal.Flip")
    ) var readingGoal = 0

    var body: some View {
        VStack {
            Text("Color theme: \(themeChoice.rawValue)")
            Text("Reading Goal: \(entry.yearlyRead) of \(readingGoal)")
        }
    }
}

@main
struct FlipWidget: Widget {
    let kind: String = "FlipWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FlipWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FlipWidget_Previews: PreviewProvider {
    static var previews: some View {
        FlipWidgetEntryView(entry: SimpleEntry(date: Date(), yearlyRead: 20))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

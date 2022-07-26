//
//  ReadingGoalWidget.swift
//  FlipWidgetExtension
//
//  Created by Jesal Patel on 7/25/22.
//

import SwiftUI
import WidgetKit

struct ReadingGoalWidgetEntryView: View {
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

struct ReadingGoalWidget: Widget {
    let kind: String = "FlipWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ReadingGoalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FlipWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReadingGoalWidgetEntryView(entry: SimpleEntry(date: Date(), yearlyRead: 20))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

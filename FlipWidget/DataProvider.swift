//
//  DataProvider.swift
//  FlipWidgetExtension
//
//  Created by Jesal Patel on 7/25/22.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

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

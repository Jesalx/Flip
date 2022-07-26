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

    @Environment(\.sizeCategory) var sizeCategory

    @AppStorage(
        "themeChoice",
        store: UserDefaults(suiteName: "group.dev.jesal.Flip")
    ) var themeChoice: Color.ThemeChoice = .mint
    @AppStorage(
        "readingGoal",
        store: UserDefaults(suiteName: "group.dev.jesal.Flip")
    ) var readingGoal = 0

    var progress: Double {
        Double(entry.yearlyRead) / Double(readingGoal)
    }

    var completionPercentage: String {
        if progress > 9.98 { return "999%" }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumIntegerDigits = 3
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: progress as NSNumber) ?? "0%"
    }

    var fontTitleSize: Font {
        if sizeCategory > .extraLarge { return .caption.weight(.bold) }
        return .headline
    }

    var fontInnerSize: Font {
        if sizeCategory > .extraLarge { return .headline }
        return .title2
    }

    var body: some View {
        if readingGoal == 0 {
            Text("No reading goal")
                .font(.title2)
        } else {
            VStack {
                Text("Reading Goal")
                    .font(fontTitleSize)
                ZStack {
                    CircularProgressView(progress: progress, color: Color.getThemeColor(themeChoice))
                    Text(completionPercentage)
                        .monospacedDigit()
                        .font(fontInnerSize)
                }
                .padding(.top, 3)
            }
            .padding()
        }
    }
}

struct ReadingGoalWidget: Widget {
    let kind: String = "FlipWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ReadingGoalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Reading Goal")
        .description("Check in on your reading goal.")
        .supportedFamilies([.systemSmall])
    }
}

struct FlipWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReadingGoalWidgetEntryView(entry: SimpleEntry(date: Date(), yearlyRead: 20))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 15)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}
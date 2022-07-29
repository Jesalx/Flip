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

    @Environment(\.widgetFamily) var widgetFamily
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

    var currentYear: String {
        Date.now.formatted(.dateTime.year())
    }

    var completionPercentage: String {
        if progress > 9.98 { return "999%" }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumIntegerDigits = 3
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: progress as NSNumber) ?? "0%"
    }

    var fontTitleStyle: Font {
        if sizeCategory > .extraLarge {
            return .system(.caption, design: .rounded, weight: .bold)
        }
        return .system(.headline, design: .rounded)
    }

    var fontInnerStyle: Font {
        var fontStyle: Font.TextStyle
        fontStyle = sizeCategory > .extraLarge ? .headline : .title2
        return .system(fontStyle, design: .rounded)
    }

    var mediumWidget: some View {
        VStack(spacing: 20) {
            Text("\(currentYear) Reading Goal")
                .font(.system(.title2, design: .rounded))

            ProgressView(value: Double(min(entry.yearlyRead, readingGoal)), total: Double(readingGoal))
                .progressViewStyle(BarProgressViewStyle(barColor: Color.getThemeColor(themeChoice)))

            Text("\(entry.yearlyRead) out of \(readingGoal) books")
        }
        .padding()
    }

    var smallWidget: some View {
        VStack {
            Text("Reading Goal")
                .font(fontTitleStyle)
            ZStack {
                ProgressView(value: Double(entry.yearlyRead), total: Double(readingGoal))
                    .progressViewStyle(
                        CircularCompletionProgressViewStyle(
                            strokeColor: Color.getThemeColor(themeChoice),
                            strokeWidth: 15
                        )
                    )
                Text(completionPercentage)
                    .monospacedDigit()
                    .font(fontInnerStyle)
            }
            .padding(.top, 3)
        }
        .padding()
    }

    var body: some View {
        if readingGoal == 0 {
            Text("No reading goal")
                .font(.system(.title2, design: .rounded))
        } else if widgetFamily == .systemSmall {
            smallWidget
        } else {
            mediumWidget
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
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct FlipWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReadingGoalWidgetEntryView(entry: SimpleEntry(date: Date(), yearlyRead: 20))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct CircularCompletionProgressViewStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 15.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim()
                .stroke(strokeColor.opacity(0.2), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct BarProgressViewStyle: ProgressViewStyle {
    var barColor = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 250, height: 15)
                .foregroundColor(barColor.opacity(0.2))
            RoundedRectangle(cornerRadius: 14)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 250, height: 15)
                .foregroundColor(barColor)
        }
    }
}

//
//  StatsWeekView.swift
//  Flip
//
//  Created by Jesal Patel on 7/19/22.
//

import Charts
import SwiftUI

struct StatsWeekView: View {
    let weekDays: [Int: Int]
    let timeRange = StatsView.ChartsRange.all
    let bookCount: Int

    init(books: [Book]) {
        var weekDays = [Int: Int]()
        for book in books {
            let day = book.weekDayNumber
            weekDays[day] = (weekDays[day] ?? 0) + 1
        }
        self.weekDays = weekDays
        self.bookCount = books.count
    }

    var chart: some View {
        Chart {
            ForEach(0...6, id: \.self) { number in
                BarMark(
                    x: .value("Weekday", Calendar.current.shortWeekdaySymbols[number]),
                    y: .value("Count", weekDays[number] ?? 0)
                )
            }
        }
        .chartPlotStyle { plotArea in
            plotArea.background(Color.accentColor.opacity(0.07))
        }
    }

    var noInfo: some View {
        ZStack {
            Color.secondary.opacity(0.2)
            Text("Weekday Chart\nRead some books to view this chart")
                .italic()
                .multilineTextAlignment(.center)
        }
        .cornerRadius(20)
    }

    var body: some View {
        if bookCount == 0 {
            noInfo
        } else {
            chart
        }
    }
}

struct StatsWeekView_Previews: PreviewProvider {
    static var previews: some View {
        StatsWeekView(books: [Book.example])
    }
}

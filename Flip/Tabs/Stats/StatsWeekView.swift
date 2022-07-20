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

    init(books: [Book]) {
        var weekDays = [Int: Int]()
        for book in books {
            let day = book.weekDayNumber
            weekDays[day] = (weekDays[day] ?? 0) + 1
        }
        self.weekDays = weekDays
    }

    var body: some View {
        Chart {
            ForEach(0...6, id: \.self) { number in
                // Regular
                BarMark(
                    x: .value("Weekday", Calendar.current.shortWeekdaySymbols[number]),
                    y: .value("Count", weekDays[number] ?? 0)
                )
                // Weird
//                AreaMark(
//                    x: .value("Weekday", Calendar.current.shortWeekdaySymbols[number]),
//                    y: .value("Count", weekDays[number] ?? 0)
//                )
                // Interesting
//                LineMark(
//                    x: .value("Weekday", Calendar.current.shortWeekdaySymbols[number]),
//                    y: .value("Count", weekDays[number] ?? 0)
//                )
//                PointMark(
//                    x: .value("Weekday", Calendar.current.shortWeekdaySymbols[number]),
//                    y: .value("Count", weekDays[number] ?? 0)
//                )
            }
        }
    }
}

struct StatsWeekView_Previews: PreviewProvider {
    static var previews: some View {
        StatsWeekView(books: [Book.example])
    }
}

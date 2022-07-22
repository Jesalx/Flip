//
//  StatsMonthView.swift
//  Flip
//
//  Created by Jesal Patel on 7/19/22.
//

import Charts
import SwiftUI

struct StatsMonthView: View {
    let months: [Int: Int]
    let bookCount: Int

    init(books: [Book]) {
        var months = [Int: Int]()
        for book in books {
            let month = book.monthNumber
            months[month] = (months[month] ?? 0) + 1
        }
        self.months = months
        self.bookCount = books.count
    }

    var chart: some View {
        Chart {
            ForEach(0...11, id: \.self) { number in
                BarMark(
                    x: .value("Month", Calendar.current.shortMonthSymbols[number]),
                    y: .value("Count", months[number] ?? 0)
                )
            }
        }
    }

    var noInfo: some View {
        ZStack {
            Color.secondary.opacity(0.2)
            Text("Month Chart\nRead some books to view this chart")
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
                .chartPlotStyle { plotArea in
                    plotArea.background(Color.accentColor.opacity(0.07))
                }
        }
    }
}

struct StatsMonthView_Previews: PreviewProvider {
    static var previews: some View {
        StatsMonthView(books: [Book.example])
    }
}

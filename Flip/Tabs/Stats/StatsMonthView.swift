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

    init(books: [Book]) {
        var months = [Int: Int]()
        for book in books {
            let month = book.monthNumber
            months[month] = (months[month] ?? 0) + 1
        }
        self.months = months
    }

    var body: some View {
        Chart {
            ForEach(0...11, id: \.self) { number in
                BarMark(
                    x: .value("Month", Calendar.current.shortMonthSymbols[number]),
                    y: .value("Count", months[number] ?? 0)
                )
//                )
            }
        }
    }
}

struct StatsMonthView_Previews: PreviewProvider {
    static var previews: some View {
        StatsMonthView(books: [Book.example])
    }
}

//
//  StatsRatingView.swift
//  Flip
//
//  Created by Jesal Patel on 7/21/22.
//

import Charts
import SwiftUI

struct StatsRatingView: View {
    let ratings: [Int: Int]
    let bookCount: Int

    init(books: [Book]) {
        var ratings = [Int: Int]()
        for book in books {
            let rating = book.bookRating
            ratings[rating] = (ratings[rating] ?? 0) + 1
        }
        self.ratings = ratings
        self.bookCount = books.count
    }

    var chart: some View {
        Chart {
            ForEach(1...5, id: \.self) { number in
                LineMark(
                    x: .value("Rating", "\(number)"),
                    y: .value("Count", ratings[number] ?? 0)
                )
                PointMark(
                    x: .value("Rating", "\(number)"),
                    y: .value("Count", ratings[number] ?? 0)
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
            Text("Ratings Chart\nRate some books to view this chart")
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

struct StatsRatingView_Previews: PreviewProvider {
    static var previews: some View {
        StatsRatingView(books: [Book.example])
    }
}

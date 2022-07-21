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

    init(books: [Book]) {
        var ratings = [Int: Int]()
        for book in books {
            let rating = book.bookRating
            ratings[rating] = (ratings[rating] ?? 0) + 1
        }
        self.ratings = ratings
    }

    var body: some View {
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
    }
}

struct StatsRatingView_Previews: PreviewProvider {
    static var previews: some View {
        StatsRatingView(books: [Book.example])
    }
}

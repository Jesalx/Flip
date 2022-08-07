//
//  StatsRowView.swift
//  Flip
//
//  Created by Jesal Patel on 7/16/22.
//

import SwiftUI

struct StatsRowView: View {
    let booksRequest: FetchRequest<Book>
    let titleString: String

    var pagesRead: Int {
        booksRequest.wrappedValue.reduce(0) { $0 + $1.bookPageCount }
    }

    var booksRead: Int {
        booksRequest.wrappedValue.count
    }

    var bookWord: String {
        return booksRead == 1 ? "Book" : "Books"
    }

    var pageWord: String {
        return pagesRead == 1 ? "Page" : "Pages"
    }

    init(filter: Book.BookFilter) {
        let titleString: String
        switch filter {
        case .allBooks:
            titleString = "All"
        case .readBooks:
            titleString = "Lifetime"
        case .unreadBooks:
            titleString = "Unread"
        case .unratedBooks:
            titleString = "Unrated"
        case .yearlyBooks:
            titleString = Date().formatted(.dateTime.year())
        case .monthlyBooks:
            titleString = Date().formatted(.dateTime.month(.wide))
        case let .specificYear(year):
            titleString = String(year)
        case let .specificRating(rating):
            titleString = rating == 0 ? "Unrated" : "\(rating) Stars"
        }
        self.titleString = titleString

        booksRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: [],
            predicate: Book.getPredicate(filter)
        )
    }

    var body: some View {
        HStack {
            Text(titleString)
                .font(.title.weight(.semibold))
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Text("\(booksRead) \(bookWord) read")
                    .font(.headline)
                Text("\(pagesRead) \(pageWord) read")
                    .font(.headline)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundColor(.primary)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(20)
    }
}

struct StatsRowView_Previews: PreviewProvider {
    static var previews: some View {
        StatsRowView(filter: .readBooks)
    }
}

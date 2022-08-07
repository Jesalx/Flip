//
//  StatsBookListView.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import SwiftUI

struct StatsBookListView: View {
    let bookFilter: Book.BookFilter
    let titleString: String

    let booksRequest: FetchRequest<Book>
    var books: [Book] {
        Array(booksRequest.wrappedValue)
    }

    init(bookFilter: Book.BookFilter) {
        switch bookFilter {
        case .allBooks:
            self.titleString = "All"
        case .readBooks:
            self.titleString = "Read"
        case .unreadBooks:
            self.titleString = "Unread"
        case .ratedBooks:
            self.titleString = "Rated"
        case .unratedBooks:
            self.titleString = "Unrated"
        case .yearlyBooks:
            self.titleString = Date.now.formatted(.dateTime.year())
        case .monthlyBooks:
            self.titleString = Date.now.formatted(.dateTime.month(.wide))
        case let .specificYear(year):
            self.titleString = String(year)
        case let .specificRating(rating):
            self.titleString = rating == 0 ? "Unrated" : "\(rating) Stars"
        }

        self.bookFilter = bookFilter

        let readPredicate = Book.getPredicate(.readBooks)
        let timePredicate = Book.getPredicate(bookFilter)
        let predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [readPredicate, timePredicate]
        )

        booksRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: Book.getSort(.readDate),
            predicate: predicate,
            animation: .default
        )
    }

    var body: some View {
        BookListView(
            books: books,
            canToggleRead: true,
            searchBarDisplayMode: .automatic
        ) { book in
            NavigationLink(value: StatsRoute.book(book)) {
                LibraryRowView(book: book)
            }
        }
        .navigationTitle(titleString)
    }
}

struct StatsBookListView_Previews: PreviewProvider {
    static var previews: some View {
        StatsBookListView(bookFilter: .yearlyBooks)
    }
}

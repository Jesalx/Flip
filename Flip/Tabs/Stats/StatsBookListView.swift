//
//  StatsBookListView.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import SwiftUI

struct StatsBookListView: View {
    let bookFilter: Book.BookFilter
    let dateString: String

    let booksRequest: FetchRequest<Book>
    var books: [Book] {
        Array(booksRequest.wrappedValue)
    }

    init(bookFilter: Book.BookFilter) {
        switch bookFilter {
        case .yearlyBooks:
            self.dateString = Date.now.formatted(.dateTime.year())
        case .monthlyBooks:
            self.dateString = Date.now.formatted(.dateTime.month(.wide))
        case let .specificYear(year):
            self.dateString = String(year)
        default:
            self.dateString = Date.now.formatted(.dateTime.year())
        }

        self.bookFilter = bookFilter
        let sortOrder = Book.SortOrder.readDate

        let readPredicate = Book.getPredicate(.readBooks)
        let timePredicate = Book.getPredicate(bookFilter)
        let predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [readPredicate, timePredicate]
        )

        booksRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: Book.getSort(sortOrder),
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
        .navigationTitle(dateString)
    }
}

struct StatsBookListView_Previews: PreviewProvider {
    static var previews: some View {
        StatsBookListView(bookFilter: .yearlyBooks)
    }
}

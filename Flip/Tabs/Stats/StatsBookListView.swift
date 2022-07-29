//
//  StatsBookListView.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import SwiftUI

struct StatsBookListView: View {
    let bookFilter: Book.BookFilter
    let dateStyle: Date.FormatStyle

    let booksRequest: FetchRequest<Book>
    var books: [Book] {
        Array(booksRequest.wrappedValue)
    }

    init(bookFilter: Book.BookFilter) {
        switch bookFilter {
        case .yearlyBooks:
            self.dateStyle = .dateTime.year()
        case .monthlyBooks:
            self.dateStyle = .dateTime.month(.wide)
        default:
            self.dateStyle = .dateTime.year()
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
        // Right now there is a bug where on loading this view the search bar will
        // flash onto a book before disappearing. Allowing BookListView to accept
        // a parameter to choose the search display mode is part of alleviating this
        // issue because keeping the bar always visible fixes the issue. Another
        // alternative might be to disallow searching on this specific page. Check
        // periodically if an .automatic searchBarDisplayMode still has this glitch.
        BookListView(
            books: books,
            canToggleRead: true,
            searchBarDisplayMode: .automatic
        ) { book in
            NavigationLink(value: StatsRoute.book(book)) {
                LibraryRowView(book: book)
            }
        }
        .navigationTitle(Date().formatted(dateStyle))
    }
}

struct StatsBookListView_Previews: PreviewProvider {
    static var previews: some View {
        StatsBookListView(bookFilter: .yearlyBooks)
    }
}

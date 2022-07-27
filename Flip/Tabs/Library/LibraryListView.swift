//
//  LibraryListView.swift
//  Flip
//
//  Created by Jesal Patel on 7/19/22.
//

import SwiftUI

struct LibraryListView: View {
    let sortOrder: Book.SortOrder
    let bookFilter: Book.BookFilter

    let booksRequest: FetchRequest<Book>
    var books: [Book] {
        Array(booksRequest.wrappedValue)
    }

    init(sortOrder: Book.SortOrder, bookFilter: Book.BookFilter) {
        self.sortOrder = sortOrder
        self.bookFilter = bookFilter

        booksRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: Book.getSort(sortOrder),
            predicate: Book.getPredicate(bookFilter),
            animation: .default
        )
    }

    var body: some View {
        BookListView(books: books, canToggleRead: bookFilter == .allBooks) { book in
            NavigationLink(value: book) {
                LibraryRowView(book: book)
            }
        }
    }
}

struct LibraryListView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        LibraryListView(sortOrder: .author, bookFilter: .allBooks)
    }
}

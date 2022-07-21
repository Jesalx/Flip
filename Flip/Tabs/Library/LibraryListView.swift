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

    @EnvironmentObject var dataController: DataController
    @AppStorage("defaultRating") var defaultRating = 3

    let booksRequest: FetchRequest<Book>
    var books: [Book] {
        Array(booksRequest.wrappedValue)

    }
    var searchedBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.bookTitle.contains(searchText) || $0.bookAuthor.contains(searchText) }
        }
    }

    @State private var searchText = ""

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
        List {
            ForEach(searchedBooks) { book in
                NavigationLink(value: book) {
                    LibraryRowView(book: book)
                }
                .swipeActions(edge: .leading) {
                    if !book.read && bookFilter == .allBooks {
                        Button("Read") { markRead(book) }.tint(.purple)
                    }
                }
            }
            .onDelete { offsets in
                delete(offsets)
            }
        }
        .searchable(text: $searchText, prompt: "Search")
    }

    func markRead(_ book: Book) {
        book.objectWillChange.send()
        book.read = true
        book.dateRead = Date.now
        book.rating = Int16(defaultRating)
    }

    func delete(_ offsets: IndexSet) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        for offset in offsets {
            let book = searchedBooks[offset]
            dataController.delete(book)
        }
        dataController.save()
    }
}

struct LibraryListView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        LibraryListView(sortOrder: .author, bookFilter: .allBooks)
            .environmentObject(dataController)
    }
}

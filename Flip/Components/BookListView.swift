//
//  BookList.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import SwiftUI

struct BookListView: View {
    @EnvironmentObject var dataController: DataController
    @AppStorage("defaultRating") var defaultRating = 0

    let books: [Book]
    let canToggleRead: Bool

    @State private var searchText = ""
    var searchedBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { book in
                let search = searchText.lowercased()
                return (book.bookTitle.lowercased().contains(search) ||
                        book.bookAuthor.lowercased().contains(search) ||
                        book.bookGenreString.lowercased().contains(search))
            }
        }
    }

    var body: some View {
        List {
            ForEach(searchedBooks) { book in
                NavigationLink(value: book) {
                    LibraryRowView(book: book)
                }
                .contextMenu {
                    Button {
                        toggleRead(book)
                    } label: {
                        if book.read {
                            Label("Mark Unread", systemImage: "bookmark.slash")
                        } else {
                            Label("Mark Read", systemImage: "bookmark")
                        }
                    }
                    ShareLink(item: book.copyText)
                    Button {
                        book.copyToClipboard()
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
                .swipeActions(edge: .leading) {
                    if !book.read && canToggleRead {
                        Button("Read") { toggleRead(book) }.tint(.purple)
                    }
                }
            }
            .onDelete { offsets in
                delete(offsets)
            }
        }
        .searchable(text: $searchText, prompt: "Search")
    }

    func toggleRead(_ book: Book) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        book.objectWillChange.send()
        book.read.toggle()
        book.dateRead = Date.now
        book.rating = Int16(defaultRating)
        dataController.update(book)
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

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(books: [Book.example], canToggleRead: true)
    }
}

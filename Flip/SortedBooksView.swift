//
//  SortedBooksView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct SortedBooksView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var books: FetchedResults<Book>
    let sortOrder: Book.SortOrder
    let bookFilter: Book.BookFilter
    
    init(sortOrder: Book.SortOrder, bookFilter: Book.BookFilter) {
        self.sortOrder = sortOrder
        self.bookFilter = bookFilter
        var sortDescriptor: NSSortDescriptor
        var predicate: NSPredicate
        
        switch bookFilter {
        case .allBooks:
            predicate = NSPredicate(value: true)
        case .readBooks:
            predicate = NSPredicate(format: "read = true")
        case .unreadBooks:
            predicate = NSPredicate(format: "read = false")
        }
        
        switch sortOrder {
        case .title:
            sortDescriptor = NSSortDescriptor(keyPath: \Book.title, ascending: true)
        case .author:
            sortDescriptor = NSSortDescriptor(keyPath: \Book.author, ascending: true)
        case .readDate:
            sortDescriptor = NSSortDescriptor(keyPath: \Book.dateRead, ascending: true)
        case .publicationDate:
            sortDescriptor = NSSortDescriptor(keyPath: \Book.publicationDate, ascending: true)
        }
        _books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
    }
    
    var body: some View {
        Group {
            if books.isEmpty {
                Text(emptyBooksText())
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(books) { book in
                        LibraryRowView(book: book)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let book = books[offset]
                            dataController.delete(book)
                        }
                        dataController.save()
                    }
                }
            }
        }
    }
    
    func emptyBooksText() -> String {
        switch bookFilter {
        case .allBooks:
            return "Your library is empty."
        case .readBooks:
            return "You don't have any read books."
        case .unreadBooks:
            return "You don't have any unread books."
        }
    }
}

struct SortedBooksView_Previews: PreviewProvider {
    static var previews: some View {
        SortedBooksView(sortOrder: .author, bookFilter: .allBooks)
    }
}

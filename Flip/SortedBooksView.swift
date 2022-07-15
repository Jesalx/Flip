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
    
    init(sortOrder: Book.SortOrder) {
        var sortDescriptor: NSSortDescriptor
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
        _books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [sortDescriptor])
    }
    
    var body: some View {
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

struct SortedBooksView_Previews: PreviewProvider {
    static var previews: some View {
        SortedBooksView(sortOrder: .author)
    }
}

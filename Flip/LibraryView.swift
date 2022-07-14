//
//  LibraryView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct LibraryView: View {
    static let tag: String = "Library"
    
    let showOnlyReadBooks: Bool
    let books: FetchRequest<Book>
    
    init(showOnlyReadBooks: Bool) {
        self.showOnlyReadBooks = showOnlyReadBooks
        books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Book.title, ascending: true)
        ], predicate: NSPredicate(format: "read = %d", showOnlyReadBooks))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books.wrappedValue) { book in
                    NavigationLink(destination: LibraryBookView(book: book)) {
                        Text(book.bookTitle)
                    }
                }
            }
            //.navigationTitle(showOnlyReadBooks ? "Read Books" : "Unread Books")
            .navigationTitle("Library")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        LibraryView(showOnlyReadBooks: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

//
//  BooksView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct BooksView: View {
    let showOnlyReadBooks: Bool
    let books: FetchRequest<Book>
    
    init(showOnlyReadBooks: Bool) {
        self.showOnlyReadBooks = showOnlyReadBooks
        books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Book.title, ascending: true)
        ], predicate: NSPredicate(format: "read = %d", showOnlyReadBooks))
        // ], predicate: NSPredicate(format: "read = %d", showOnlyReadBooks))
        
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books.wrappedValue) { book in
                    NavigationLink(book.title ?? "Unknown") {
                        Text(book.title ?? "Unknown")
                    }
                }
            }
            //.navigationTitle(showOnlyReadBooks ? "Read Books" : "Unread Books")
            .navigationTitle("Library")
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        BooksView(showOnlyReadBooks: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

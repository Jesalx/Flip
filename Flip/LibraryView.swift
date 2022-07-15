//
//  LibraryView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct LibraryView: View {
    static let tag: String = "Library"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Book.SortOrder.author
    
    let showOnlyReadBooks: Bool
    let books: FetchRequest<Book>
    
    init(showOnlyReadBooks: Bool) {
        self.showOnlyReadBooks = showOnlyReadBooks
        books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Book.title, ascending: true)
        ])
//        ], predicate: NSPredicate(format: "read = %d", showOnlyReadBooks))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books.wrappedValue) { book in
                    LibraryRowView(book: book)
                }
                .onDelete { offsets in
                    for offset in offsets {
                        let book = books.wrappedValue[offset]
                        dataController.delete(book)
                    }
                    dataController.save()
                }
            }
            //.navigationTitle(showOnlyReadBooks ? "Read Books" : "Unread Books")
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .confirmationDialog("Sort Books", isPresented: $showingSortOrder) {
                Button("Author") { sortOrder = .author }
                Button("Title") { sortOrder = .title }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Sort Books")
            }
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

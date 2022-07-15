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
    @State private var sortDescriptor: NSSortDescriptor = NSSortDescriptor(keyPath: \Book.author, ascending: true)
    
//    let showOnlyReadBooks: Bool
//    let books: FetchRequest<Book>
//
//    init(showOnlyReadBooks: Bool) {
//        self.showOnlyReadBooks = showOnlyReadBooks
//        books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [
//            NSSortDescriptor(keyPath: \Book.author, ascending: true)
//        ])
////        ], predicate: NSPredicate(format: "read = %d", showOnlyReadBooks))
//    }
    
    var body: some View {
        NavigationView {
            List {
                SortedBooksView(sortDescriptor: sortDescriptor)
            }
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
                Button("Author") { sortDescriptor = NSSortDescriptor(keyPath: \Book.author, ascending: true)}
                Button("Title") { sortDescriptor = NSSortDescriptor(keyPath: \Book.title, ascending: true)}
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
        LibraryView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

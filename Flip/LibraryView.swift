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
    @State private var sortOrder: Book.SortOrder = .author
    @State private var bookFilter: Book.BookFilter = .allBooks
    
    var body: some View {
        NavigationView {
            List {
                SortedBooksView(sortOrder: sortOrder, bookFilter: bookFilter)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("All Items") { bookFilter = .allBooks }
                        Button("Read") { bookFilter = .readBooks }
                        Button("Unread") { bookFilter = .unreadBooks }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .confirmationDialog("Sort Books", isPresented: $showingSortOrder) {
                Button("Author") { sortOrder = .author }
                Button("Title") { sortOrder = .title }
                Button("Finish Date") { sortOrder = .readDate }
                Button("Publication Date") { sortOrder = .publicationDate }
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

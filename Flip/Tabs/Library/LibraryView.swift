//
//  LibraryView.swift
//  Flip
//
//

import SwiftUI

struct LibraryView: View {
    static let tag: String = "Library"

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\Book.author, order: .forward)]
    ) private var books: FetchedResults<Book>

    @State private var showingSortOrder = false
    @State private var sortOrder: Book.SortOrder = .author
    @State private var bookFilter: Book.BookFilter = .allBooks
    @State private var searchText = ""
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            searchText = newValue
            books.nsPredicate = newValue.isEmpty
            ? nil
            : NSPredicate(format: "title CONTAINS[c] %@ OR author CONTAINS[c] %@", newValue, newValue)
        }
    }

    var filterToolbarItem: some View {
        Button {
            hapticFeedback(style: .light)
            showingSortOrder.toggle()
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
    }

    var sortToolbarItem: some View {
        Menu {
            Button("All Items") { bookFilter = .allBooks }
            Button("Read") { bookFilter = .readBooks }
            Button("Unread") { bookFilter = .unreadBooks }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
        .onTapGesture {
            hapticFeedback(style: .light)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    LibraryRowView(book: book)
                }
                .onDelete { offsets in
                    delete(offsets)
                }
            }
            .navigationTitle(navigationTitleText())
            .searchable(text: query, prompt: "Search")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    filterToolbarItem
                    sortToolbarItem
                }
            }
            .confirmationDialog("Sort Books", isPresented: $showingSortOrder) {
                Button("Author") { sortOrder = .author }
                Button("Title") { sortOrder = .title }
                Button("Page Count") { sortOrder = .pageCount }
                Button("Finish Date") { sortOrder = .readDate }
                Button("Publication Date") { sortOrder = .publicationDate }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Sort Books")
            }
            .onChange(of: sortOrder) { _ in updateSort() }
            .onChange(of: bookFilter) { _ in updateFilter() }
            EmptySelectionView()
        }
    }

    func delete(_ offsets: IndexSet) {
        hapticFeedback(style: .medium)
        for offset in offsets {
            let book = books[offset]
            dataController.delete(book)
        }
        dataController.save()
    }

    func updateFilter() {
        var predicate: NSPredicate
        switch bookFilter {
        case .allBooks:
            predicate = NSPredicate(value: true)
        case .readBooks:
            predicate = NSPredicate(format: "read = true")
        case .unreadBooks:
            predicate = NSPredicate(format: "read = false")
        }
        books.nsPredicate = predicate
    }

    func updateSort() {
        var descriptor: [SortDescriptor<Book>]
        switch sortOrder {
        case .title:
            descriptor = [SortDescriptor(\Book.title, order: .forward)]
        case .author:
            descriptor = [SortDescriptor(\Book.author, order: .forward)]
        case .pageCount:
            descriptor = [SortDescriptor(\Book.pageCount, order: .forward)]
        case .readDate:
            descriptor = [SortDescriptor(\Book.dateRead, order: .forward)]
        case .publicationDate:
            descriptor = [SortDescriptor(\Book.publicationDate, order: .forward)]
        }
        books.sortDescriptors = descriptor
    }

    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func navigationTitleText() -> String {
        switch bookFilter {
        case .allBooks:
            return "Library"
        case .readBooks:
            return "Read"
        case .unreadBooks:
            return "Unread"
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

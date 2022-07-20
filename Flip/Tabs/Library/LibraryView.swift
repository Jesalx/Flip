//
//  LibraryView.swift
//  Flip
//
//

import CoreSpotlight
import SwiftUI

struct LibraryView: View {
    static let tag: String = "Library"

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\Book.author, order: .forward)]
    ) private var books: FetchedResults<Book>

    @State private var showingSortOrder = false
//    @SceneStorage("sortOrder") private var sortOrder: Book.SortOrder = .author
//    @SceneStorage("bookFilter") private var bookFilter: Book.BookFilter = .allBooks
    @State private var sortOrder: Book.SortOrder = .author
    @State private var bookFilter: Book.BookFilter = .allBooks
    @State private var selectedBook: Book?
    @State private var searchText = ""
    @State private var path = [Book]()

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
        NavigationStack(path: $path) {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        LibraryRowView(book: book)
                    }
                }
                .onDelete { offsets in
                    delete(offsets)
                }
            }
            .navigationTitle(navigationTitleText())
            .navigationDestination(for: Book.self) { book in
                LibraryBookView(book: book)
            }
            .searchable(text: query, prompt: "Search")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    filterToolbarItem
                    sortToolbarItem
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightBook)
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

    func selectBook(with identifier: String) {
        selectedBook = dataController.book(with: identifier)
        if let book = selectedBook {
            path.append(book)
        }
    }

    func loadSpotlightBook(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            selectBook(with: uniqueIdentifier)
        }
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

//
//  LibraryView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import CoreSpotlight
import SwiftUI

struct LibraryView: View {
    static let tag: String = "Library"

    @EnvironmentObject var dataController: DataController

    @SceneStorage("sortOrder") private var sortOrder: Book.SortOrder = .author
    @SceneStorage("bookFilter") private var bookFilter: Book.BookFilter = .allBooks

    @State private var path = [Book]()
    @State private var selectedBook: Book?
    @State private var showingSortOrder = false

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
            LibraryListView(sortOrder: sortOrder, bookFilter: bookFilter)
                .navigationTitle(navigationTitleText())
                .navigationDestination(for: Book.self) { book in
                    LibraryBookView(book: book)
                }
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
            }
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
            .environmentObject(dataController)
    }
}

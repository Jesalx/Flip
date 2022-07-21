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
            Button("All Items") { changeFilter(to: .allBooks) }
            Button("Read") { changeFilter(to: .readBooks) }
            Button("Unread") { changeFilter(to: .unreadBooks) }
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
                    Button("Author") { changeSort(to: .author) }
                    Button("Title") { changeSort(to: .title) }
                    Button("Page Count") { changeSort(to: .pageCount) }
                    Button("Finish Date") { changeSort(to: .readDate) }
                    Button("Publication Date") { changeSort(to: .publicationDate) }
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

    func changeFilter(to filter: Book.BookFilter) {
        withAnimation {
            bookFilter = filter
        }
    }

    func changeSort(to sort: Book.SortOrder) {
        // I don't this adds an animation, even when sorting at the moment. Find out why
        withAnimation {
            sortOrder = sort
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

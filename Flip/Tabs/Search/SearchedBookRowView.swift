//
//  SearchedBookRowView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookRowView: View {
    let item: GoogleBook

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest private var books: FetchedResults<Book>

    var bookExists: Bool {
        guard books.first != nil else { return false }
        return true
    }

    init(item: GoogleBook) {
        self.item = item
        let predicate = NSPredicate(format: "id == %@", item.id)
        let fetchRequest = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [], predicate: predicate)
        _books = fetchRequest
    }

    var swipeButtons: some View {
        bookExists
        ? Button("Delete") { deleteBook() }.tint(.red)
        : Button("Add") { saveBook() }.tint(.brown)
    }

    var body: some View {
        NavigationLink(value: item) {
            HStack {
                CoverView(url: item.volumeInfo.wrappedSmallThumbnail)
                    .frame(width: 45, height: 70)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(item.volumeInfo.wrappedTitle)
                        .font(.headline)
                    Text(item.volumeInfo.wrappedFirstAuthor)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "bookmark")
                    .foregroundColor(bookExists ? .accentColor : .clear)
            }
        }
        .contextMenu {
            Button {
                bookExists ? deleteBook() : saveBook()
            } label: {
                if bookExists {
                    Label("Remove From Library", systemImage: "bookmark.slash")
                } else {
                    Label("Add To Library", systemImage: "bookmark")
                }
            }
            ShareLink(item: item.volumeInfo.copyText)
            Button {
                copyToClipboard()
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            swipeButtons
        }
    }

    func saveBook() {
        if books.first != nil { return }
        item.saveGoogleBook(dataController: dataController)
    }

    func deleteBook() {
        if let book = books.first {
            dataController.delete(book)
            dataController.save()
            return
        }
    }

    func copyToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = item.volumeInfo.copyText
    }
}

struct SearchedBookRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedBookRowView(item: GoogleBook.example)
    }
}

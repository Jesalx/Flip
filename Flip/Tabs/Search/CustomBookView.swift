//
//  CustomBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/22/22.
//

import SwiftUI

struct CustomBookView: View {

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) private var dismiss

    @AppStorage("defaultRating") var defaultRating = 0

    @State private var bookTitle = ""
    @State private var bookAuthor = ""
    @State private var bookPublisher = ""
    @State private var unknownPublicationDate = false
    @State private var publicationDate = Date.now
    @State private var pageCount: Int = 0
    @State private var genres = ""
    @State private var description = ""
    @State private var isbn10 = ""
    @State private var isbn13 = ""
    @State private var thumbnail = ""

    var body: some View {
        BookEditView(
            bookTitle: $bookTitle,
            bookAuthor: $bookAuthor,
            bookPublisher: $bookPublisher,
            unknownPublicationDate: $unknownPublicationDate,
            publicationDate: $publicationDate,
            pageCount: $pageCount,
            genres: $genres,
            description: $description,
            isbn10: $isbn10,
            isbn13: $isbn13,
            thumbnail: $thumbnail) {
                saveBook()
            }
        .navigationTitle("Create Book")
    }

    func disableCriteria() -> Bool {
        return bookTitle.isEmpty || bookAuthor.isEmpty
    }

    func saveBook() {
        let book = Book(context: managedObjectContext)
        book.id = UUID().uuidString
        book.title = Book.cleanedBookString(string: bookTitle)
        book.author = Book.cleanedBookString(string: bookAuthor)
        book.summary = Book.cleanedBookString(string: description)
        book.read = false

        book.publishingCompany = Book.cleanedBookString(string: bookPublisher)

        if unknownPublicationDate {
            book.publicationDate = nil
        } else {
            book.publicationDate = publicationDate
        }

        book.genres = Book.cleanedBookString(string: genres)

        book.pageCount = Int16(pageCount)
        book.rating = Int16(defaultRating)
        book.dateRead = Date.distantFuture

        book.isbn10 = Book.cleanedBookString(string: isbn10)
        book.isbn13 = Book.cleanedBookString(string: isbn13)

        if let cleanedThumbnail = Book.cleanedBookString(string: thumbnail) {
            book.thumbnail = URL(string: cleanedThumbnail)
        } else {
            book.thumbnail = nil
        }

        dataController.save()
        dataController.update(book)
        dismiss()
    }
}

struct CustomBookView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBookView()
    }
}

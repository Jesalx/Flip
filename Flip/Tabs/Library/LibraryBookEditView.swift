//
//  LibraryBookEditView.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import SwiftUI

struct LibraryBookEditView: View {
    @ObservedObject var book: Book

    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) private var dismiss

    @State private var bookTitle: String
    @State private var bookAuthor: String
    @State private var bookPublisher: String
    @State private var unknownPublicationDate: Bool
    @State private var publicationDate: Date
    @State private var pageCount: Int
    @State private var genres: String
    @State private var description: String
    @State private var isbn10: String
    @State private var isbn13: String
    @State private var thumbnail: String

    init(book: Book) {
        self.book = book
        _bookTitle = State(wrappedValue: book.title ?? "")
        _bookAuthor = State(wrappedValue: book.author ?? "")
        _bookPublisher = State(wrappedValue: book.publishingCompany ?? "")
        _unknownPublicationDate = State(wrappedValue: book.publicationDate == nil)
        _publicationDate = State(wrappedValue: book.publicationDate ?? Date.now)
        _pageCount = State(wrappedValue: book.bookPageCount)
        _genres = State(wrappedValue: book.genres ?? "")
        _description = State(wrappedValue: book.summary ?? "")
        _isbn10 = State(wrappedValue: book.isbn10 ?? "")
        _isbn13 = State(wrappedValue: book.isbn13 ?? "")
        _thumbnail = State(wrappedValue: book.thumbnail?.absoluteString ?? "")
    }

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
                update()
            }
            .navigationTitle("Editing \(book.bookTitle)")
            .navigationBarTitleDisplayMode(.inline)
    }

    func update() {
        book.objectWillChange.send()
//        book.title = bookTitle.isEmpty ? nil : bookTitle
        book.title = Book.cleanedBookString(string: bookTitle)
        book.author = Book.cleanedBookString(string: bookAuthor)
        book.publishingCompany = Book.cleanedBookString(string: bookPublisher)
        if unknownPublicationDate {
            book.publicationDate = nil
        } else {
            book.publicationDate = publicationDate
        }
        book.pageCount = Int16(pageCount)
        book.genres = Book.cleanedBookString(string: genres)
        book.summary = Book.cleanedBookString(string: description)
        book.isbn10 = Book.cleanedBookString(string: isbn10)
        book.isbn13 = Book.cleanedBookString(string: isbn13)

        if let cleanedThumbnail = Book.cleanedBookString(string: thumbnail) {
            book.thumbnail = URL(string: cleanedThumbnail)
        } else {
            book.thumbnail = nil
        }

        dataController.update(book)
        dismiss()
    }
}

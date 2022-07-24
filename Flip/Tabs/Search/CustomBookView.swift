//
//  CustomBookView.swift
//  Flip
//
//  Created by Jesal Patel on 7/22/22.
//

import SwiftUI

struct CustomBookView: View {
    let pageCountFormatter: NumberFormatter

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) private var dismiss

    @AppStorage("defaultRating") var defaultRating = 0

    @State private var bookTitle = ""
    @State private var bookAuthor = ""
    @State private var bookPublisher = ""
    @State private var publicationDate = Date.now
    @State private var pageCount: Int = 0
    @State private var genres = ""
    @State private var description = ""
    @State private var isbn10 = ""
    @State private var isbn13 = ""

    init() {
        let pageCountFormatter = NumberFormatter()
        pageCountFormatter.maximum = 30000
        pageCountFormatter.minimum = 0
        self.pageCountFormatter = pageCountFormatter
    }

    var body: some View {
        Form {
            Section("Title") {
                TextField("Title", text: $bookTitle, axis: .vertical)
                    .lineLimit(1...3)
            }

            Section("Authors") {
                TextField("Author1, Author2, ...", text: $bookAuthor, axis: .vertical)
                    .textInputAutocapitalization(.words)
                    .lineLimit(1...3)
            }

            Section("Publisher") {
                TextField("Publisher", text: $bookPublisher, axis: .vertical)
                    .textInputAutocapitalization(.words)
                    .lineLimit(1...3)
                DatePicker("Publication Date",
                           selection: $publicationDate,
                           displayedComponents: .date
                )
            }
            Section("Page Count") {
                TextField("Page Count", value: $pageCount, formatter: pageCountFormatter)
                    .keyboardType(.numberPad)
            }

            Section("Genres") {
                TextField("Genre1, Genre2, ...", text: $genres, axis: .vertical)
                    .textInputAutocapitalization(.words)
                    .lineLimit(1...3)
            }

            Section("Description") {
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(1...5)
            }

            Section("ISBN") {
                TextField("ISBN 10", text: $isbn10, axis: .horizontal)
                TextField("ISBN 13", text: $isbn13, axis: .horizontal)
            }

            Button("Save") {
                saveBook()
            }
            .disabled(disableCriteria())

        }
        .navigationTitle("Create Book")
    }

    func disableCriteria() -> Bool {
        return bookTitle.isEmpty || bookAuthor.isEmpty
    }

    func saveBook() {
        let book = Book(context: managedObjectContext)
        book.id = UUID().uuidString
        book.title = bookTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        book.author = bookAuthor.trimmingCharacters(in: .whitespacesAndNewlines)
        book.summary = description.isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines)
        book.read = false

        book.publishingCompany = bookPublisher.isEmpty
            ? nil
            : bookPublisher.trimmingCharacters(in: .whitespacesAndNewlines)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        book.publicationDate = dateFormatter.string(from: publicationDate)

        book.genres = genres.isEmpty ? nil : genres.trimmingCharacters(in: .whitespacesAndNewlines)

        book.pageCount = Int16(pageCount)
        book.rating = Int16(defaultRating)
        book.dateRead = Date.distantFuture

        book.isbn10 = isbn10.isEmpty ? nil : isbn10.trimmingCharacters(in: .whitespacesAndNewlines)
        book.isbn13 = isbn13.isEmpty ? nil : isbn13.trimmingCharacters(in: .whitespacesAndNewlines)

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

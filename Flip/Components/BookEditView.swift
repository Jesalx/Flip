//
//  BookEditView.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import SwiftUI

struct BookEditView: View {
    @Binding var bookTitle: String
    @Binding var bookAuthor: String
    @Binding var bookPublisher: String
    @Binding var unknownPublicationDate: Bool
    @Binding var publicationDate: Date
    @Binding var pageCount: Int
    @Binding var genres: String
    @Binding var description: String
    @Binding var isbn10: String
    @Binding var isbn13: String
    @Binding var thumbnail: String

    let saveFunction: () -> Void

    let pageCountFormatter: NumberFormatter

    init(
        bookTitle: Binding<String>,
        bookAuthor: Binding<String>,
        bookPublisher: Binding<String>,
        unknownPublicationDate: Binding<Bool>,
        publicationDate: Binding<Date>,
        pageCount: Binding<Int>,
        genres: Binding<String>,
        description: Binding<String>,
        isbn10: Binding<String>,
        isbn13: Binding<String>,
        thumbnail: Binding<String>,
        saveFunction: @escaping () -> Void
    ) {
        self._bookTitle = bookTitle
        self._bookAuthor = bookAuthor
        self._bookPublisher = bookPublisher
        self._unknownPublicationDate = unknownPublicationDate
        self._publicationDate = publicationDate
        self._pageCount = pageCount
        self._genres = genres
        self._description = description
        self._isbn10 = isbn10
        self._isbn13 = isbn13
        self._thumbnail = thumbnail

        self.saveFunction = saveFunction

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
                Toggle("Unknown Publication Date", isOn: $unknownPublicationDate.animation())
                if !unknownPublicationDate {
                    DatePicker("Publication Date",
                               selection: $publicationDate,
                               displayedComponents: .date
                    )
                }
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

            Section {
                TextField("Thumbnail URL", text: $thumbnail, axis: .horizontal)
                    .keyboardType(.URL)
                    .textContentType(.URL)
            } header: {
                Text("Thumbnail URL")
            } footer: {
                Text("If no thumbnail is provided then Flip will attempt to display one using one of the ISBN numbers.")
            }

            Button("Save") {
                saveFunction()
            }
            .disabled(disableCriteria())
        }
    }

    func disableCriteria() -> Bool {
        return bookTitle.isEmpty || bookAuthor.isEmpty
    }
}

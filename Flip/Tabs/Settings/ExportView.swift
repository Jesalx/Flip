//
//  ExportView.swift
//  Flip
//
//  Created by Jesal Patel on 7/24/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {

    @FetchRequest(sortDescriptors: []) private var books: FetchedResults<Book>

    @State private var showingExport = false
    @State private var csvContents: String?

    var body: some View {
        Form {
            Button("Export") {
                saveCSV()
            }
        }
        .navigationTitle("Export")
        .fileExporter(
            isPresented: $showingExport,
            document: CSVFile(initialText: csvContents ?? ""),
            contentType: .plainText, defaultFilename: "flip_export.csv") { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func saveCSV() {
        csvContents = createCSV()
        showingExport = true
    }

    func createCSV() -> String {
        // swiftlint:disable:next line_length
        var rows = ["id,title,author,publisher,publication date,isbn10,isbn13,rating,finished reading,date finished,page count,thumbnail,genres,summary"]

        for book in books {
            let id = exportString(book.bookId)
            let title = exportString(book.bookTitle)
            let author = exportString(book.bookAuthor)
            let publisher = exportString(book.publishingCompany)
            let publicationDate = exportString(book.publicationDate)
            let isbn10 = exportString(book.isbn10)
            let isbn13 = exportString(book.isbn13)
            let read = book.bookRead
            let dateFinished = read ? ISO8601DateFormatter().string(from: book.bookDateRead) : ""
            let rating = read ? book.bookRating : 0
            let pageCount = book.bookPageCount
            let thumbnail = book.thumbnail != nil ? book.thumbnail!.absoluteString : ""
            let genres = book.genres ?? ""
            var summary = book.summary ?? ""
            summary.replace("\"", with: "'")

            // swiftlint:disable:next line_length
            let bookRow = "\(id),\"\(title)\",\"\(author)\",\"\(publisher)\",\(publicationDate),\(isbn10),\(isbn13),\(rating),\(read),\(dateFinished),\(pageCount),\(thumbnail),\"\(genres)\",\"\(summary)\""
            rows.append(bookRow)
        }

        let csvString = rows.joined(separator: "\n")
        return csvString
    }

    func exportString(_ str: String?) -> String {
        guard let str = str else { return "" }
        var cleanedString = str.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        cleanedString = cleanedString.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanedString
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView()
    }
}

struct CSVFile: FileDocument {
    static var readableContentTypes = [UTType.plainText]

    var text = ""

    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

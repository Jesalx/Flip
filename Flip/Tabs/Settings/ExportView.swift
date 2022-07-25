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
    @State private var csvString: String?

    var body: some View {
        Form {
            Button("Export") {
                saveCSV()
            }
        }
        .navigationTitle("Export")
        .fileExporter(
            isPresented: $showingExport,
            document: CSVFile(initialText: csvString ?? ""),
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
        csvString = createCSV()
        showingExport = true
    }

    func createCSV() -> String {
        var rows = ["id,title,author,publisher,publication date,isbn10,isbn13,rating,finished reading,date finished,page count,genres"]

        for book in books {
            let id = exportString(book.bookId)
            let title = exportString(book.bookTitle)
            let author = exportString(book.bookAuthor)
            let publisher = exportString(book.bookPublisher)
            let publicationDate = exportString(book.bookPublicationDate)
            let isbn10 = exportString(book.isbn10)
            let isbn13 = exportString(book.isbn13)
            let read = book.bookRead
            let dateFinished = read ? ISO8601DateFormatter().string(from: book.bookDateRead) : ""
            let rating = read ? book.bookRating : 0
            let pageCount = book.bookPageCount
            let genres = book.bookGenres.joined(separator: ", ")

            let bookRow = "\(id),\"\(title)\",\"\(author)\",\"\(publisher)\",\(publicationDate),\(isbn10),\(isbn13),\(rating),\(read),\(dateFinished),\(pageCount),\"\(genres)\""
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

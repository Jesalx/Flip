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
            Section {
                Button("Export") { saveCSV() }
            } header: {
                Text("Flip Export")
            } footer: {
                // swiftlint:disable:next line_length
                Text("Exporting from Flip produces a CSV file that may be useful as an additional backup of your Flip library or to import into another service.")
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
            let flipBook = FlipBook(book: book)
            let bookRow = flipBook.createCsvRow()
            rows.append(bookRow)
        }

        let csvString = rows.joined(separator: "\n")
        return csvString
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

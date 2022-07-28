//
//  ImportView.swift
//  Flip
//
//  Created by Jesal Patel on 7/23/22.
//

import SwiftCSV
import SwiftUI

struct ImportView: View {

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var showingImport = false
    @State private var fileName = ""
    @State private var fileUrl: URL?
    @State private var addingBooks = false
    @State private var importOnlyValidDates = false
    @State private var showingFlipImportConfirmation = false
    @State private var showingGoodreadsImportConfirmation = false

    var body: some View {
        Form {
            Section("Select File") {
                Button("Select file") {
                    showingImport = true
                }
                if !fileName.isEmpty {
                    Text(fileName)
                }
            }

            Section("Flip") {
                Button("Import from Flip") {
                    showingFlipImportConfirmation = true
                }
                .disabled(fileUrl == nil || addingBooks)
            }

            Section {
                Toggle("Only Valid Read Dates", isOn: $importOnlyValidDates)

                Button("Import from Goodreads") {
                    showingGoodreadsImportConfirmation = true
                }
                .disabled(fileUrl == nil || addingBooks)
            } header: {
                Text("Goodreads")
            } footer: {
                // swiftlint:disable:next line_length
                Text("Goodreads doesn't always accurately provide the date that user's mark a book read or ISBN numbers. Flip will only import books with a valid ISBN and provides an option to choose whether you would like to import only books with valid read dates. Books without valid read dates will have their read dates marked as today.")
            }
        }
        .navigationTitle("Import")
        .fileImporter(
            isPresented: $showingImport,
            allowedContentTypes: [.commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                guard url.startAccessingSecurityScopedResource() else { return }
                fileName = url.lastPathComponent
                fileUrl = url
            case .failure(let error):
                print("Import CSV Error: \(error)")
            }
        }
        .confirmationDialog("Import", isPresented: $showingFlipImportConfirmation) {
            Button("Import") {
                addingBooks = true
                makeFlipBooks()
                addingBooks = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to import '\(fileName)' as a Flip import?")
        }
        .confirmationDialog("Import", isPresented: $showingGoodreadsImportConfirmation) {
            Button("Import") {
                addingBooks = true
                makeGoodreadsBooks()
                addingBooks = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to import '\(fileName)' as a Goodreads import?")
        }
    }

    func makeFlipBooks() {
        guard let csv = try? getCsvFromUrl(url: fileUrl) else { return }
        fileUrl = nil
        for row in csv.rows {
            if let book = FlipBook(row: row) {
                book.saveFlipBook(dataController: dataController)
            }
        }
    }

    func makeGoodreadsBooks() {
        guard let csv = try? getCsvFromUrl(url: fileUrl) else { return }
        fileUrl = nil
        for row in csv.rows {
            if let book = GoodreadsBook(row: row) {
                book.saveGoodreadsBook(dataController: dataController, onlyValidDates: importOnlyValidDates)
            }
        }
    }

    func getCsvFromUrl(url: URL?) throws -> EnumeratedCSV? {
        guard let url = url else { return nil }
        if let payload = try? String(contentsOf: url) {
            let csv = try? EnumeratedCSV(string: payload, delimiter: .comma, loadColumns: false)
            return csv
        }
        return nil
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}

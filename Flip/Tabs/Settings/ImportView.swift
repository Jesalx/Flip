//
//  ImportView.swift
//  Flip
//
//  Created by Jesal Patel on 7/23/22.
//

import SwiftCSV
import SwiftUI

struct ImportView: View {
    enum ImportOption: String, CaseIterable {
        case flip, goodreads
    }

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var importType: ImportOption = .flip
    @State private var showingImport = false
    @State private var fileName = ""
    @State private var fileUrl: URL?
    @State private var addingBooks = false
    @State private var importOnlyValidDates = false
    @State private var showingImportConfirmation = false
    @State private var showingFinishAlert = false
    @State private var booksImported = 0
    @State private var totalBooks = 0

    var body: some View {
        Form {
            Section {
                Picker("Import Type", selection: $importType.animation()) {
                    ForEach(ImportOption.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                if importType == .goodreads {
                    Toggle("Only Valid Read Dates", isOn: $importOnlyValidDates)
                }
            } header: {
                Text("Import Options")
            } footer: {
                if importType == .goodreads {
                    // swiftlint:disable:next line_length
                    Text("Goodreads doesn't always accurately provide the date that user's mark a book read or ISBN numbers. Flip will only import books with a valid ISBN and provides an option to choose whether you would like to import only books with valid read dates. Books without valid read dates will have their read dates marked as today.")
                }
            }
            
            Section("Select File") {
                Button("Select file") {
                    showingImport = true
                }
                if !fileName.isEmpty {
                    Text(fileName)
                }
            }
            
            Section("Import") {
                Button("Import from \(importType.rawValue.capitalized)") { showingImportConfirmation = true }
                    .disabled(fileUrl == nil || addingBooks)
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
        .confirmationDialog("Import", isPresented: $showingImportConfirmation) {
            Button("Import") {
                addingBooks = true
                makeBooks()
                addingBooks = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to import '\(fileName)' as a \(importType.rawValue.capitalized) import?")
        }
        .alert("Import Status", isPresented: $showingFinishAlert) {
            Button("OK") { }
        } message: {
            Text("Imported \(booksImported) of \(totalBooks) books.")
        }
    }

    func makeBooks() {
        booksImported = 0
        totalBooks = 0
        switch importType {
        case .flip:
            makeFlipBooks()
        case .goodreads:
            makeGoodreadsBooks()
        }
        showingFinishAlert = true
    }

    func makeFlipBooks() {
        guard let csv = try? getCsvFromUrl(url: fileUrl) else { return }
        fileUrl = nil
        for row in csv.rows {
            totalBooks += 1
            if let book = FlipBook(row: row) {
                booksImported += book.saveFlipBook(dataController: dataController)
            }
        }
    }

    func makeGoodreadsBooks() {
        guard let csv = try? getCsvFromUrl(url: fileUrl) else { return }
        fileUrl = nil
        for row in csv.rows {
            totalBooks += 1
            if let book = GoodreadsBook(row: row) {
                booksImported += book.saveGoodreadsBook(dataController: dataController, onlyValidDates: importOnlyValidDates)
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

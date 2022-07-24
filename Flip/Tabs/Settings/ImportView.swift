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

    var body: some View {
        Form {
            Section {
                Button("Select file") {
                    showingImport = true
                }
                if !fileName.isEmpty {
                    Text(fileName)
                }
                Button("Import") {
                    try? makeBooks(url: fileUrl)
                }
                .disabled(fileUrl == nil || addingBooks)
            }
        }
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
    }

    func makeBooks(url: URL?) throws {
        guard let url = url else { return }
        addingBooks = true
        let payload = try String(contentsOf: url)
        let csv = try EnumeratedCSV(string: payload, delimiter: .comma, loadColumns: false)
        for row in csv.rows {
            let book = GoodreadsBook(line: row)
            book.saveGoodreadsBook(dataController: dataController)
        }
        addingBooks = false
        fileUrl = nil
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}

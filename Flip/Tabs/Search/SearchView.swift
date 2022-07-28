//
//  SearchView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct SearchView: View {
    enum SearchStatus {
        case prompt, searching, success, noResults, failed
    }

    static let tag: String = "Search"

    @State private var searchedBooks: [GoogleBook] = []
    @State private var searchText = ""
    @State private var searchStatus = SearchStatus.prompt

    var optionalSearchView: some View {
        Group {
            switch searchStatus {
            case .prompt:
                Text("")
            case .searching:
                ProgressView()
            case .success:
                 List(searchedBooks) { item in
                     SearchedBookRowView(item: item)
                         .task { submitPaginationRequest(item: item) }
                 }
            case .noResults:
                Text("No results found.")
                    .foregroundColor(.secondary)
            case .failed:
                Text("Could not connect to Google Books.\nPlease try again later.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }

    var body: some View {
        NavigationStack {
            optionalSearchView
            .navigationTitle("Search")
            .navigationDestination(for: GoogleBook.self) { item in
                SearchedBookView(item: item)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomBookView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search Google Books")
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
            submitSearch()
        }
    }

    func submitSearch() {
        Task { @MainActor in
            searchStatus = .searching
            await loadBooks()
        }
    }
    
    func submitPaginationRequest(item: GoogleBook) {
        guard item == searchedBooks[searchedBooks.count - 5] else { return }
        // Only load a maximum of 60 books
        guard searchedBooks.count <= 40 else { return }
        Task { @MainActor in
            await loadAdditionalBooks()
        }
    }
    
    func loadBooks() async {
        let strippedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedQuery = strippedQuery.replacingOccurrences(of: " ", with: "+")
        let queryUrl = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&printType=books&maxResults=20"
        guard let url = URL(string: queryUrl) else {
            print("Invalid search URL")
            searchStatus = .noResults
            return
        }
        searchedBooks = await getRequestedBooks(url: url, updateStatus: true)
    }

    func loadAdditionalBooks() async {
        let strippedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedQuery = strippedQuery.replacingOccurrences(of: " ", with: "+")
        // swiftlint:disable:next line_length
        let queryUrl = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&printType=books&startIndex=\(searchedBooks.count + 1)&maxResults=20"
        guard let url = URL(string: queryUrl) else { return }
        searchedBooks.append(contentsOf: await getRequestedBooks(url: url, updateStatus: false))
    }
    
    func getRequestedBooks(url: URL, updateStatus: Bool) async -> [GoogleBook] {
        var resultBooks: [GoogleBook] = []
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(GoogleBooksResponse.self, from: data) {
                resultBooks = decodedResponse.items ?? []
                if updateStatus { searchStatus = decodedResponse.totalItems == 0 ? .noResults : .success }
            } else {
                print("Failed to decode")
                if updateStatus { searchStatus = .failed }
            }
        } catch {
            print("Invalid search data")
            if updateStatus { searchStatus = .failed }
        }
        return resultBooks
    }
}

struct SearchView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        SearchView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

//
//  SearchView.swift
//  Flip
//
//

import SwiftUI

struct SearchView: View {
    enum SearchStatus {
        case prompt, searching, success, noResults, failed
    }

    static let tag: String = "Search"

    @State private var searchedBooks: [Item] = []
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
                     NavigationLink(value: item) {
                         SearchedBookRowView(item: item)
                     }
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
            .navigationDestination(for: Item.self) { item in
                SearchedBookView(item: item)
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
            print("Here")
            searchStatus = .searching
            await loadData()
        }
    }

    func loadData() async {
        let strippedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedQuery = strippedQuery.replacingOccurrences(of: " ", with: "+")
        let queryUrl = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&printType=books&maxResults=20"
        guard let url = URL(string: queryUrl) else {
            print("Invalid search URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)
            if let decodedResponse = try? decoder.decode(SearchResponse.self, from: data) {
                searchedBooks = decodedResponse.items ?? []
                searchStatus = decodedResponse.totalItems == 0 ? .noResults : .success
            } else {
                searchedBooks = []
                searchStatus = .failed
            }
        } catch {
            print("Invalid search data")
            searchedBooks = []
            searchStatus = .failed
        }
        print(searchStatus)
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

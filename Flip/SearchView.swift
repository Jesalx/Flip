//
//  SearchView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct SearchView: View {
    enum SearchStatus {
        case prompt, searching, success, failed
    }
    
    static let tag: String = "Search"
    
    @State private var searchedBooks: [Item] = []
    @State private var searchText = ""
    @State private var searchStatus = SearchStatus.prompt
    
    var OptionalSearchView: some View {
        Group {
            switch searchStatus {
            case .prompt:
                Text("")
            case .searching:
                ProgressView()
            case .success:
                 List(searchedBooks) { item in
                    SearchedBookRowView(item: item)
                 }
            case .failed:
                Text("Something went wrong. Try again later.")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            OptionalSearchView
            .navigationTitle("Search")
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
            await loadData()
        }
    }
    
    func loadData() async {
        let strippedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedQuery = strippedQuery.replacingOccurrences(of: " ", with: "+")
        let urlstring = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&printType=books&maxResults=20"
        guard let url = URL(string: urlstring) else {
            print("Invalid search URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)
            if let decodedResponse = try? decoder.decode(Response.self, from: data) {
                searchedBooks = decodedResponse.items
                searchStatus = .success
            } else {
                searchedBooks = []
                searchStatus = .failed
            }
        } catch {
            print("Invalid search data")
            searchedBooks = []
            searchStatus = .failed
        }
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

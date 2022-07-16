//
//  SearchView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct SearchView: View {
    static let tag: String = "Search"
    
    @State private var searchedBooks: [Item] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(searchedBooks) { item in
                SearchedBookRowView(volumeInfo: item.volumeInfo)
            }
            .navigationTitle("Search")
        }
        .searchable(text: $searchText, prompt: "Search Google Books")
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
            Task { @MainActor in
                await loadData()
            }
        }
    }
    
    func loadData() async {
        let strippedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedQuery = strippedQuery.replacingOccurrences(of: " ", with: "+")
        let urlstring = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&printType=books&maxResults=20"
//        let urlstring = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&filter=ebooks&printType=books&maxResults=20"
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
            } else {
                searchedBooks = []
            }
        } catch {
            print("Invalid search data")
                searchedBooks = []
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

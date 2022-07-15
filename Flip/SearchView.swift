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
                VStack(alignment: .leading) {
                    Text(item.volumeInfo.title ?? "None")
                }
            }
            .navigationTitle("Search")
        }
        .searchable(text: $searchText, prompt: "Search Google Books")
        .onSubmit(of: .search) {
            Task { @MainActor in
                await loadData()
            }
        }
    }
    
    func loadData() async {
        let formattedQuery = searchText.replacingOccurrences(of: " ", with: "+")
        let urlstring = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&printType=books&maxResults=20"
        guard let url = URL(string: urlstring) else {
            print("Invalid search URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                searchedBooks = decodedResponse.items
            } else {
                searchedBooks = []
            }
        } catch {
            print("Invalid search data")
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

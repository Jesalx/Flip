//
//  ContentView.swift
//  Flip
//
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView = LibraryView.tag

    var body: some View {
        TabView(selection: $selectedView) {
            LibraryView()
                .tag(LibraryView.tag)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }

            SearchView()
                .tag(SearchView.tag)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

             StatsView()
                .tag(StatsView.tag)
                .tabItem {
                    Image(systemName: "hourglass")
                    Text("Stats")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
    }

    func moveToHome(_ input: Any) {
        selectedView = LibraryView.tag
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

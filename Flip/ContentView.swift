//
//  ContentView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
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
                    Image(systemName: "list.clipboard")
                    Text("Stats")
                }

            SettingsView()
                .tag(SettingsView.tag)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .accentColor(.mint)
        .tint(.mint)
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

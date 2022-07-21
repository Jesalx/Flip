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
    @AppStorage("themeChoice") var themeChoice: Color.ThemeChoice = .mint
    @AppStorage("defaultRating") var defaultRating: Int = 3
    @AppStorage("readingGoal") var readingGoal: Int = 0

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
        .accentColor(Color.getThemeColor(themeChoice))
        .tint(Color.getThemeColor(themeChoice))
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

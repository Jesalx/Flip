//
//  ContentView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView = LibraryView.tag
    
    var body: some View {
        TabView(selection: $selectedView) {
//            HomeView()
//                .tag(HomeView.tag)
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
            
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
            
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
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

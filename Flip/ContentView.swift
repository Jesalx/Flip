//
//  ContentView.swift
//  Flip
//
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView = LibraryView.tag

    @State private var tappedTwice = false

    var handler: Binding<String> {
        Binding(
            get: { selectedView },
            set: {
                if $0 == selectedView {
                    tappedTwice = true
                }
                selectedView = $0
            }
        )
    }

    var body: some View {
        ScrollViewReader { proxy in
            TabView(selection: handler) {
                LibraryView()
                    .onChange(of: tappedTwice) { tapped in
                        guard tapped else { return }
                        withAnimation {
                            proxy.scrollTo(LibraryView.topId)
                        }
                        self.tappedTwice = false
                    }
                    .tag(LibraryView.tag)
                    .tabItem {
                        Image(systemName: "books.vertical.fill")
                        Text("Library")
                    }

                SearchView()
                    .onChange(of: tappedTwice) { tapped in
                        guard tapped else { return }
                        withAnimation {
                            proxy.scrollTo(SearchView.topId)
                        }
                        self.tappedTwice = false
                    }
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

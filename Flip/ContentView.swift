//
//  ContentView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import CoreSpotlight
import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @SceneStorage("selectedView") var selectedView = LibraryView.tag
    @AppStorage("themeChoice") var themeChoice: Color.ThemeChoice = .mint
    @AppStorage("defaultRating") var defaultRating: Int = 0
    @AppStorage("readingGoal") var readingGoal: Int = 0
    @AppStorage("lockingEnabled") var lockingEnabled = false

    @State private var isUnlocked = true
    @State private var showingFailure = false
    @State private var contentBlur: Double = 0

    init() {
        let unlocked = lockingEnabled ? false : true
        _isUnlocked = State(wrappedValue: unlocked)
        _contentBlur = State(wrappedValue: unlocked ? 0 : 15)
    }

    var retry: some View {
        ZStack {
            Button("Unlock Flip") { authenticate() }
                .padding()
                .buttonStyle(.borderedProminent)
        }
        .opacity(showingFailure ? 1 : 0)
    }

    var appContent: some View {
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
    }

    var body: some View {
        ZStack {
            appContent
                .blur(radius: contentBlur)
                .allowsHitTesting(isUnlocked)
            retry
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onChange(of: scenePhase, perform: performLockActions)
        .accentColor(Color.getThemeColor(themeChoice))
        .tint(Color.getThemeColor(themeChoice))
    }

    func moveToHome(_ input: Any) {
        selectedView = LibraryView.tag
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Unlock Flip."
            context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                    unlockAnimation()
                    showingFailure = false
                } else {
                    // Failed to authenticate
                    showingFailure = true
                    if let error = authenticationError {
                        print("Error Unlocking: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // On device without biometrics or no biometrics enrolled
        }
    }

    func performLockActions(_ phase: ScenePhase) {
        guard lockingEnabled == true else { return }
        switch phase {
        case .background:
            contentBlur = 10
            isUnlocked = false
            lockAnimation()
        case .active:
            unlockAnimation()
            if !isUnlocked && !showingFailure { authenticate() }
        case .inactive:
            lockAnimation()
        @unknown default:
            return
        }
    }

    func unlockAnimation() {
        guard isUnlocked == true else { return }
        // Setting a blur of 0 causes a serious bug where either the navigation bar
        // items get pushed upwards so they are not clickable or that tab bar items
        // get pushed down so they are not clickable. Setting the blur extremely close
        // to zero avoids this bug for some reason. Look into other ways to fix this or
        // remember to check if this bug has been fixed.
        withAnimation { contentBlur = 0.0000000000001 }
    }

    func lockAnimation() {
        withAnimation { contentBlur = 15 }
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

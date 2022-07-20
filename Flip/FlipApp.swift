//
//  FlipApp.swift
//  Flip
//
//

import SwiftUI

@main
struct FlipApp: App {
    @StateObject var dataController = DataController()

//    init() {
//        let dataController = DataController()
//        _dataController = StateObject(wrappedValue: dataController)
//    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: UIApplication.willResignActiveNotification), perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}

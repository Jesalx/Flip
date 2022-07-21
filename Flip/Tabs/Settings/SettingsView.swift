//
//  SettingsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/20/22.
//

import SwiftUI

struct SettingsView: View {
    static let tag: String = "Settings"

    let emailString: String = "mailto:contact@jesal.dev?subject=Flip App"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let privacyPolicyUrl: String = "https://www.jesal.dev/flip/privacy_policy/"

    @EnvironmentObject var dataController: DataController
    @AppStorage("defaultRating") var defaultRating: Int = 3

    @State private var refresh = true
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Library") {
                    Stepper("Default Rating: \(defaultRating)",
                            value: $defaultRating,
                            in: 1...5
                    )
//                    .foregroundColor(.accentColor)
                }

                Section("Stats") {

                }

                Section("Appearance") {
                    NavigationLink(destination: ThemePickerView()) {
                        Text("Accent Color")
//                            .foregroundColor(.accentColor)
                    }
                }

                Section("About") {
                    Link("Send Email", destination: URL(string: emailString)!)
                    Link("Privacy Policy", destination: URL(string: privacyPolicyUrl)!)
                }

                Section("Debug") {
                    // DON'T INCLUDE IN RELEASE
                    Button("Delete Library", role: .destructive) { showingDeleteConfirmation = true }
                        .confirmationDialog("Delete Library", isPresented: $showingDeleteConfirmation) {
                            Button("Delete Library", role: .destructive) { dataController.deleteAll() }
                        } message: {
                            // swiftlint:disable:next line_length
                            Text("Are you sure you want to delete all the books in your library? This action cannot be undone.")
                        }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
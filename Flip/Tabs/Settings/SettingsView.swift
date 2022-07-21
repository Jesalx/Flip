//
//  SettingsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/20/22.
//

import SwiftUI

struct SettingsView: View {
    static let tag: String = "Settings"
    let emailString: String = "mailto:flip@jesal.dev?subject=Flip App"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let privacyPolicyUrl: String = "https://www.jesal.dev/flip/privacy_policy/"

    @State private var refresh = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Library") {
//                    Toggle("Refresh cover images", isOn: $refresh)
                }

                Section("Stats") {

                }

                Section("Appearance") {

                }

                Section("About") {
                    Link("Email me", destination: URL(string: emailString)!)
                    Link("Privacy Policy", destination: URL(string: privacyPolicyUrl)!)
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

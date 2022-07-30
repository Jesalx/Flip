//
//  WelcomeScreenView.swift
//  Flip
//
//  Created by Jesal Patel on 7/29/22.
//

import SwiftUI

struct WelcomeScreenView: View {

    @Environment(\.dismiss) private var dismiss
    @AppStorage("seenWelcome") var seenWelcome = false

    var body: some View {
        ScrollView {
            VStack {
                Text("Welcome to Flip")
                    .font(.title.weight(.semibold))
                    .padding(.top, 50)
                    .padding(.bottom, 30)

                VStack(alignment: .leading, spacing: 20) {
                    WelcomeCategoryView(
                        icon: Image(systemName: "text.book.closed.fill"),
                        iconColor: .indigo,
                        title: "Library",
                        content: "Keeps up with books you've read and want to read in the Library tab."
                    )

                    WelcomeCategoryView(
                        icon: Image(systemName: "magnifyingglass"),
                        iconColor: .orange,
                        title: "Search",
                        // swiftlint:disable:next line_length
                        content: "Search for new books and add them to the library in the Search tab. Add your own custom books by clicking the plus icon at the top of the page."
                    )

                    WelcomeCategoryView(
                        icon: Image(systemName: "chart.bar.xaxis"),
                        iconColor: .blue,
                        title: "Stats",
                        content: "Check out some interesting info about your reading habits in the Stats tab."
                    )

                    WelcomeCategoryView(
                        icon: Image(systemName: "calendar"),
                        iconColor: .green,
                        title: "Reading Goal",
                        // swiftlint:disable:next line_length
                        content: "Keep up with how many books you want to read this year by setting a reading goal in the Stats tab by clicking the calendar icon at the top of the page."
                    )

                    WelcomeCategoryView(
                        icon: Image(systemName: "paintpalette"),
                        iconColor: .red,
                        title: "Appearance",
                        content: "Customize your app by picking a color in the Settings tab (garbage)."
                    )
                }
                Button {
                    // Set to not pop-up again after first time
                    seenWelcome = true
                    dismiss()
                } label: {
                    HStack {
                        Text("Continue")
                        // This method of setting the width is deprecated. Find a better way
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.8, minHeight: 32)
                    }
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .cornerRadius(10)
                .padding(.top, 45)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct WelcomeCategoryView: View {
    let icon: Image
    let iconColor: Color
    let title: String
    let content: String

    var body: some View {
        HStack {
            icon
                .font(.system(size: 35, weight: .semibold))
                .frame(width: 55)
                .padding(.leading, 15)
                .padding(.trailing, 0)
                .foregroundColor(iconColor)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(content)
                    .font(.subheadline)
            }
            .padding(.trailing)
        }
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}

//
//  WelcomeScreenView.swift
//  Flip
//
//  Created by Jesal Patel on 7/29/22.
//

import SwiftUI

struct WelcomeScreenView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Welcome to Flip")
                    .font(.title.weight(.semibold))
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 20) {
                    WelcomeCategoryView(
                        icon: Image(systemName: "calendar"),
                        title: "Reading Goal",
                        content: "You can set a reading goal in the Stats tab. Blah blah blah"
                    )
                    
                    WelcomeCategoryView(
                        icon: Image(systemName: "chart.bar.xaxis"),
                        title: "Stats",
                        content: "View interesting information about your reading stuff in the Stats tab."
                    )
                    
                    
                }
                Button {
                    print("tapped")
                } label: {
                    HStack {
                        Text("Continue")
                            // This method of setting the width is deprecated. Find a better way
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    }
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(10)
                .padding(.top, 25)
            }
        }
    }
}

struct WelcomeCategoryView: View {
    let icon: Image
    let title: String
    let content: String

    var body: some View {
        HStack {
            
            icon
                .font(.system(size: 30, weight: .semibold))
                .padding(.leading)
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

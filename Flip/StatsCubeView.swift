//
//  StatsCubeView.swift
//  Flip
//
//  Created by Jesal Patel on 7/16/22.
//

import SwiftUI

struct StatsCubeView: View {
    let titleText: String
    let upperText: String
    let lowerText: String
    var body: some View {
        HStack() {
            Text(titleText)
                .font(.title.weight(.semibold))
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Text(upperText)
                    .font(.subheadline)
                Text(lowerText)
                    .font(.subheadline)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.secondary.opacity(0.2))
        .cornerRadius(20)
    }
}

struct StatsCubeView_Previews: PreviewProvider {
    static var previews: some View {
        StatsCubeView(titleText: "2022", upperText: "14 books read", lowerText: "14,000 pages read")
    }
}

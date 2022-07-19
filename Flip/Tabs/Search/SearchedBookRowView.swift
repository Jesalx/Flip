//
//  SearchedBookRowView.swift
//  Flip
//
//

import SwiftUI

struct SearchedBookRowView: View {
    let item: Item

    var body: some View {
        HStack {
            CoverView(url: item.volumeInfo.wrappedSmallThumbnail)
            .frame(width: 45, height: 70)
            .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(item.volumeInfo.wrappedTitle)
                    .font(.headline)

                Text(item.volumeInfo.wrappedFirstAuthor)
                    .font(.subheadline)
            }
        }
    }
}

struct SearchedBookRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedBookRowView(item: Item.example)
    }
}

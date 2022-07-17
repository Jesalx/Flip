//
//  SearchedBookRowView.swift
//  Flip
//
//  Created by Jesal Patel on 7/15/22.
//

import SwiftUI

struct SearchedBookRowView: View {
    let item: Item

    var body: some View {
        NavigationLink(destination: SearchedBookView(item: item)) {
            HStack {
                AsyncImage(url: item.volumeInfo.wrappedSmallThumbnail) { phase in
                    thumbnailImage(phase)
                }
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

    func thumbnailImage(_ phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty, .failure:
            return Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
        case .success(let image):
            return image
                .resizable()
                .scaledToFit()
        @unknown default:
            return Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
        }
    }
}

struct SearchedBookRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedBookRowView(item: Item.example)
    }
}

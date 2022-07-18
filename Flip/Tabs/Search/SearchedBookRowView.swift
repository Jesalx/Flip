//
//  SearchedBookRowView.swift
//  Flip
//
//

import SwiftUI
import CachedAsyncImage

struct SearchedBookRowView: View {
    let item: Item

    var body: some View {
        NavigationLink(destination: SearchedBookView(item: item)) {
            HStack {
                CachedAsyncImage(url: item.volumeInfo.wrappedSmallThumbnail) { phase in
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
        Group {
            switch phase {
            case .empty, .failure:
                Image(systemName: "book.closed")
                    .resizable()
                    .font(.body.weight(.ultraLight))
                    .scaledToFit()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            @unknown default:
                Image(systemName: "book.closed")
                    .resizable()
                    .font(.body.weight(.ultraLight))
                    .scaledToFit()
            }
        }
    }
}

struct SearchedBookRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedBookRowView(item: Item.example)
    }
}

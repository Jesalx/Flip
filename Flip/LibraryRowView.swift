//
//  LibraryRowView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct LibraryRowView: View {
    @ObservedObject var book: Book

    var body: some View {
        NavigationLink(destination: LibraryBookView(book: book)) {
            HStack {
                AsyncImage(url: book.thumbnail) { phase in
                    ThumbnailImage(phase)
                }
                .frame(width: 45, height: 70)
                .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(book.bookTitle)
                        .font(.headline)

                    Text(book.bookFirstAuthor)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "checkmark.circle")
                    .foregroundColor(book.bookRead ? .primary : .clear)
            }
        }
    }

    func ThumbnailImage(_ phase: AsyncImagePhase) -> some View {
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

struct LibraryRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                LibraryRowView(book: Book.example)
            }
        }
    }
}

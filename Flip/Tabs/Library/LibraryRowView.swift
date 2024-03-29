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
        HStack {
            CoverView(url: book.bookThumbnail)
            .frame(width: 45, height: 70)
            .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(book.bookTitle)
                    .font(.headline)

                Text(book.bookFirstAuthor)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: "book")
                .foregroundColor(book.bookRead ? .accentColor : .clear)
        }
    }
}

struct LibraryRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                LibraryRowView(book: Book.example)
            }
        }
    }
}

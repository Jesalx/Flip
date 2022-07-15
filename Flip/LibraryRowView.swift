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
                VStack(alignment: .leading) {
                    Text(book.bookTitle)
                        .font(.headline)
                    Text(book.bookAuthor)
                        .font(.subheadline)
                }
            }
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

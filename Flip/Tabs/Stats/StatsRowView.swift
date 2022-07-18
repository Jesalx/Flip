//
//  StatsRowView.swift
//  Flip
//
//

import SwiftUI

struct StatsRowView: View {
    let books: [Book]
    let dateStyle: Date.FormatStyle

    var pagesRead: Int {
        books.reduce(0) { $0 + $1.bookPageCount}
    }

    var booksRead: Int {
        books.count
    }

    var bookWord: String {
        return booksRead == 1 ? "Book" : "Books"
    }

    var pageWord: String {
        return pagesRead == 1 ? "Page" : "Pages"
    }

    var body: some View {
        HStack {
            Text(Date().formatted(dateStyle))
                .font(.title.weight(.semibold))
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Text("\(booksRead) \(bookWord) read")
                    .font(.headline)
                Text("\(pagesRead) \(pageWord) read")
                    .font(.headline)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(20)
    }
}

struct StatsRowView_Previews: PreviewProvider {
    static var previews: some View {
        StatsRowView(books: [Book.example], dateStyle: .dateTime.month(.wide))
    }
}

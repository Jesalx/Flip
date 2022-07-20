//
//  StatsRowView.swift
//  Flip
//
//

import SwiftUI

struct StatsRowView: View {
    let dateStyle: Date.FormatStyle
    let pagesRead: Int
    let booksRead: Int

    var bookWord: String {
        return booksRead == 1 ? "Book" : "Books"
    }

    var pageWord: String {
        return pagesRead == 1 ? "Page" : "Pages"
    }

    init(books: [Book], dateStyle: Date.FormatStyle) {
        self.dateStyle = dateStyle
        self.pagesRead = books.reduce(0) { $0 + $1.bookPageCount }
        self.booksRead = books.count
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

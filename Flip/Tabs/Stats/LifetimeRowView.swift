//
//  LifetimeStatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/18/22.
//

import SwiftUI

struct LifetimeRowView: View {
    let pagesRead: Int
    let booksRead: Int

    var bookWord: String {
        return booksRead == 1 ? "Book" : "Books"
    }

    var pageWord: String {
        return pagesRead == 1 ? "Page" : "Pages"
    }

    init(books: [Book]) {
        self.pagesRead = books.reduce(0) { $0 + $1.bookPageCount }
        self.booksRead = books.count
    }

    var body: some View {
        HStack {
            Text("Lifetime")
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
        .foregroundColor(.primary)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(20)
    }
}

struct LifetimeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        LifetimeRowView(books: [Book.example])
    }
}

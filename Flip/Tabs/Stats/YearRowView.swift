//
//  YearRowView.swift
//  Flip
//
//  Created by Jesal Patel on 7/30/22.
//

import SwiftUI

struct YearRowView: View {
    let booksRequest: FetchRequest<Book>
    let year: Int

    var pagesRead: Int {
        booksRequest.wrappedValue.reduce(0) { $0 + $1.bookPageCount }
    }

    var booksRead: Int {
        booksRequest.wrappedValue.count
    }

    var bookWord: String {
        return booksRead == 1 ? "Book" : "Books"
    }

    var pageWord: String {
        return pagesRead == 1 ? "Page" : "Pages"
    }

    init(year: Int) {
        self.year = year
        booksRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: [],
            predicate: Book.getPredicate(.specificYear(year))
        )
    }

    var body: some View {
        HStack {
            Text("\(String(year))")
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

struct YearRowView_Previews: PreviewProvider {
    static var previews: some View {
        YearRowView(year: 2022)
    }
}

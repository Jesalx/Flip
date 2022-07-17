//
//  StatsMonthView.swift
//  Flip
//
//

import SwiftUI

struct StatsMonthView: View {
    let books: [Book]

    init(books: [Book]) {
        let comp = Calendar.current.dateComponents([.year, .month], from: Date())
        let startOfMonth = Calendar.current.date(from: comp) ?? Date()
        self.books = books.filter { $0.bookDateRead > startOfMonth && $0.bookRead }
    }

    var pagesRead: Int {
        books.reduce(0) { $0 + $1.bookPageCount}
    }

    var booksRead: Int {
        books.count
    }

    var body: some View {
        HStack {
            Text(Date().formatted(.dateTime.month(.wide)))
                .font(.title.weight(.semibold))
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Text("\(booksRead) books read")
                    .font(.subheadline)
                Text("\(pagesRead) pages read")
                    .font(.subheadline)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(20)
    }
}

struct StatsMonthView_Previews: PreviewProvider {
    static var previews: some View {
        StatsMonthView(books: [Book.example])
    }
}

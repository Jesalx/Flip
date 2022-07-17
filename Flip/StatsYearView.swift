//
//  StatsYearView.swift
//  Flip
//
//  Created by Jesal Patel on 7/16/22.
//

import SwiftUI

struct StatsYearView: View {
//    let titleText: String
//    let upperText: String
//    let lowerText: String
    
    let pagesRead: Int
    let booksRead: Int
    let currentDate = Date()
    
    init(books: [Book]) {
        let comp = Calendar.current.dateComponents([.year], from: Date())
        let startOfYear = Calendar.current.date(from: comp) ?? Date()
        let yearBooks = books.filter { $0.bookDateRead > startOfYear && $0.bookRead }
        self.pagesRead = yearBooks.reduce(0) { $0 + $1.bookPageCount}
        self.booksRead = yearBooks.count
    }
    
    var body: some View {
        HStack() {
            Text(Date().formatted(.dateTime.year()))
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
        .background(.secondary.opacity(0.2))
        .cornerRadius(20)
    }
}

struct StatsYearView_Previews: PreviewProvider {
    static var previews: some View {
        StatsYearView(books: [Book.example])
    }
}

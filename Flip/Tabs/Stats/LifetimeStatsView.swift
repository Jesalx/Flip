//
//  LifetimeStatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/18/22.
//

import SwiftUI

struct LifetimeStatsView: View {
    let booksRead: Int
    let pagesRead: Int

    init(books: [Book]) {
        self.pagesRead = books.reduce(0) { $0 + $1.bookPageCount }
        self.booksRead = books.count
    }

    var body: some View {
        Group {
            VStack(alignment: .center) {
                Text("Lifetime Books Read")
                    .font(.title.weight(.semibold))
                Text("\(booksRead)")
                    .font(.title.weight(.semibold))
            }
            .padding()
            VStack {
                Text("Lifetime Pages Read")
                    .font(.title.weight(.semibold))
                Text("\(pagesRead)")
                    .font(.title.weight(.semibold))
            }
            .padding()
            Spacer()
        }
    }
}

struct LifetimeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        LifetimeStatsView(books: [Book.example])
    }
}

//
//  LifetimeStatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/18/22.
//

import SwiftUI

struct LifetimeStatsView: View {
    let books: [Book]

    var booksRead: Int {
        books.count
    }

    var pagesRead: Int {
        books.reduce(0) { $0 + $1.bookPageCount}
    }

    var body: some View {
        Group {
            VStack(alignment: .center) {
                Text("Lifetime Books Read")
                    .font(.title)
                Text("\(booksRead)")
                    .font(.title2)
            }
            .padding()
            VStack {
                Text("Lifetime Pages Read")
                    .font(.title)
                Text("\(pagesRead)")
                    .font(.title2)
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

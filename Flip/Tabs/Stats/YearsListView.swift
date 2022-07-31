//
//  YearsListView.swift
//  Flip
//
//  Created by Jesal Patel on 7/30/22.
//

import SwiftUI

struct YearsListView: View {

    let booksRequest: FetchRequest<Book>

    var yearsWithReadBooks: [Int] {
        Array(Set(booksRequest.wrappedValue.map { $0.dateRead?.year ?? 0})).sorted()
    }

    init() {
        booksRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: [],
            predicate: Book.getPredicate(.readBooks)
        )
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(yearsWithReadBooks, id: \.self) { year in
                    NavigationLink(value: StatsRoute.list(.specificYear(year))) {
                        YearRowView(year: year)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Years")
    }
}

struct YearsListView_Previews: PreviewProvider {
    static var previews: some View {
        YearsListView()
    }
}

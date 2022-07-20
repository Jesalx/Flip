//
//  StatsView.swift
//  Flip
//
//

import SwiftUI

struct StatsView: View {
    static let tag: String = "Stats"

    let columns = [GridItem(.flexible(minimum: 80), spacing: 15), GridItem(.flexible(minimum: 80), spacing: 15)]

    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "read = True")
    ) private var books: FetchedResults<Book>

    var readBooks: [Book] {
        let readBooks = books.filter { $0.bookRead }
        return readBooks
    }

    var yearlyReadBooks: [Book] {
        let comp = Calendar.current.dateComponents([.year], from: Date())
        let startOfYear = Calendar.current.date(from: comp) ?? Date()
        return readBooks.filter { $0.bookDateRead > startOfYear }
    }

    var monthlyReadBooks: [Book] {
        let comp = Calendar.current.dateComponents([.year, .month], from: Date())
        let startOfMonth = Calendar.current.date(from: comp) ?? Date()
        return books.filter { $0.bookDateRead > startOfMonth }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    VStack {
                        StatsRowView(books: yearlyReadBooks, dateStyle: .dateTime.year())
                        StatsRowView(books: monthlyReadBooks, dateStyle: .dateTime.month(.wide))
                    }
                    .padding()
                    StatsWeekView(books: readBooks)
                        .foregroundStyle(.green)
                        .frame(height: 100)
                        .padding()
                    StatsMonthView(books: readBooks)
                        .foregroundStyle(.cyan)
                        .frame(height: 100)
                        .frame(height: 100)
                        .padding()
                    LifetimeStatsView(books: readBooks)
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        StatsView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
}

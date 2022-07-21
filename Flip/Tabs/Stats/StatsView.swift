//
//  StatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct StatsView: View {
    enum ChartsRange {
        case all, year
    }

    static let tag: String = "Stats"

    let columns = [GridItem(.flexible(minimum: 80), spacing: 15), GridItem(.flexible(minimum: 80), spacing: 15)]

    @State private var timeRange = ChartsRange.all
    @State private var showingUpdateReadingGoal = false

    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "read = True")
    ) private var books: FetchedResults<Book>

    var readBooks: [Book] {
        let readBooks = books.filter { $0.bookRead }
        return readBooks
    }

    var yearlyReadBooks: [Book] {
        let comp = Calendar.current.dateComponents([.year], from: Date.now)
        let startOfYear = Calendar.current.date(from: comp) ?? Date.now
        return readBooks.filter { $0.bookDateRead >= startOfYear }
    }

    var monthlyReadBooks: [Book] {
        let comp = Calendar.current.dateComponents([.year, .month], from: Date.now)
        let startOfMonth = Calendar.current.date(from: comp) ?? Date.now
        return books.filter { $0.bookDateRead >= startOfMonth }
    }

    var chartBooks: [Book] {
        switch timeRange {
        case .all:
            return readBooks
        case .year:
            return yearlyReadBooks
        }
    }

    var readingGoalToolbarItem: some View {
        Button {
            showingUpdateReadingGoal = true
        } label: {
            Image(systemName: "calendar")
        }
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
                    VStack {
                        Picker("Time Range", selection: $timeRange.animation()) {
                            Text("All Years").tag(ChartsRange.all)
                            Text("Current Year").tag(ChartsRange.year)
                        }
                        .pickerStyle(.segmented)
                        .padding([.horizontal, .top])
                        VStack {
                            Text("Date Finished").font(.caption.weight(.semibold))
                            StatsWeekView(books: chartBooks)
                                .frame(height: 100)
                                .padding()
                            StatsMonthView(books: chartBooks)
                                .frame(height: 100)
                                .padding()
                        }
                        .padding(.top, 8)
                        VStack {
                            Text("Ratings").font(.caption.weight(.semibold))
                            StatsRatingView(books: chartBooks)
                                .frame(height: 100)
                                .padding()
                        }
                        .padding(.top, 4)
                    }
                    LifetimeStatsView(books: readBooks)
                }
            }
            .navigationTitle("Stats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    readingGoalToolbarItem
                }
            }
            .sheet(isPresented: $showingUpdateReadingGoal) {
                UpdateGoalView()
                    .presentationDetents([.medium, .large])
            }
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

//
//  StatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

enum StatsRoute: Hashable {
    case yearList
    case list(Book.BookFilter)
    case book(Book)
}

struct StatsView: View {
    static let tag: String = "Stats"
    enum ChartsRange {
        case all, year
    }

    @AppStorage("readingGoal", store: UserDefaults(suiteName: "group.dev.jesal.Flip")) var readingGoal = 0
    @AppStorage("showLifetimeBooksRead") var showLifetimeBooksRead = true

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
        let startOfYear = Calendar.current.startOfYear(for: Date.now)
        return readBooks.filter { $0.bookDateRead >= startOfYear }
    }

    var monthlyReadBooks: [Book] {
        let startOfMonth = Calendar.current.startOfMonth(for: Date.now)
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
                    ReadingGoalView(yearRead: yearlyReadBooks.count)
                    VStack {
                        if showLifetimeBooksRead {
                            NavigationLink(value: StatsRoute.yearList) {
                                LifetimeRowView(books: readBooks)
                            }
                        }

                        NavigationLink(value: StatsRoute.list(.yearlyBooks)) {
                            StatsRowView(books: yearlyReadBooks, dateStyle: .dateTime.year())
                        }
                        NavigationLink(value: StatsRoute.list(.monthlyBooks)) {
                            StatsRowView(books: monthlyReadBooks, dateStyle: .dateTime.month(.wide))
                        }
                    }
                    .navigationDestination(for: StatsRoute.self) { route in
                        switch route {
                        case .yearList:
                            YearsListView()
                        case let .list(bookFilter):
                            StatsBookListView(bookFilter: bookFilter)
                        case let .book(book):
                            LibraryBookView(book: book)
                        }
                    }
                    .padding()
                    VStack {
                        Picker("Time Range", selection: $timeRange.animation()) {
                            Text("All Years").tag(ChartsRange.all)
                            Text("Current Year").tag(ChartsRange.year)
                        }
                        .pickerStyle(.segmented)
                        .padding([.horizontal, .top])
                        VStack(alignment: .leading) {
                            Text("Weekday Finished").font(.caption.weight(.semibold)).padding(.horizontal)
                            StatsWeekView(books: chartBooks)
                                .frame(height: 100)
                                .padding(.horizontal)
                            Text("Month Finished").font(.caption.weight(.semibold)).padding(.horizontal)
                            StatsMonthView(books: chartBooks)
                                .frame(height: 100)
                                .padding(.horizontal)
                        }
                        .padding(.top, 6)
                        VStack(alignment: .leading) {
                            Text("Ratings").font(.caption.weight(.semibold)).padding(.horizontal)
                            StatsRatingView(books: chartBooks)
                                .frame(height: 100)
                                .padding(.horizontal)
                        }
                    }
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

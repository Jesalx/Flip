//
//  StatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct StatsView: View {
    static let tag: String = "Stats"
    
    let columns = [GridItem(.flexible(minimum: 80), spacing: 15), GridItem(.flexible(minimum: 80), spacing: 15)]
   
    @FetchRequest private var books: FetchedResults<Book>
    
    var readBooks: [Book] {
        let readBooks = books.filter { $0.bookRead }
        return readBooks
    }
    
    var lifetimeBooks: Int {
        return readBooks.count
    }
    
    var lifetimePages: Int {
        return readBooks.reduce(0) { $0 + $1.bookPageCount}
    }
    
    init() {
        _books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [])
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    VStack() {
                        StatsYearView(books: readBooks)
                        StatsMonthView(books: readBooks)
                    }
                    .padding()
                    
                    VStack(alignment: .center) {
                        Text("Lifetime Books Read")
                            .font(.title)
                        Text("\(lifetimeBooks)")
                            .font(.title2)
                    }
                    .padding()
                    VStack {
                        Text("Lifetime Pages Read")
                            .font(.title)
                        Text("\(lifetimePages)")
                            .font(.title2)
                    }
                    .padding()
                    Spacer()
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

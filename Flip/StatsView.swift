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
//    let columns = [GridItem(.fixed(100), spacing: 10), GridItem(.fixed(100), spacing: 10)]
    
    @FetchRequest private var books: FetchedResults<Book>
    
    init() {
        _books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [])
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    VStack() {
                        StatsCubeView(titleText: "2022", upperText: "14 books read", lowerText: "140,000 pages read")
                        StatsCubeView(titleText: "July", upperText: "4 books read", lowerText: "437 pages read")
                    }
                    .padding()
                    
                    VStack(alignment: .center) {
                        Text("Lifetime Books Read")
                            .font(.title)
                        Text("14")
                            .font(.title2)
                    }
                    .padding()
                    VStack {
                        Text("Lifetime Pages Read")
                            .font(.title)
                        Text("96,000")
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

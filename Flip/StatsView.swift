//
//  StatsView.swift
//  Flip
//
//  Created by Jesal Patel on 7/14/22.
//

import SwiftUI

struct StatsView: View {
    static let tag: String = "Stats"
    
    @FetchRequest private var books: FetchedResults<Book>
    
    init() {
        _books = FetchRequest<Book>(entity: Book.entity(), sortDescriptors: [])
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        NavigationView {
            StatsView()
        }
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
}

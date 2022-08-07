//
//  RatingsListView.swift
//  Flip
//
//  Created by Jesal Patel on 8/7/22.
//

import SwiftUI

struct RatingsListView: View {

    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(value: StatsRoute.list(.specificRating(5))) {
                    StatsRowView(filter: .specificRating(5))
                }
                NavigationLink(value: StatsRoute.list(.specificRating(4))) {
                    StatsRowView(filter: .specificRating(4))
                }
                NavigationLink(value: StatsRoute.list(.specificRating(3))) {
                    StatsRowView(filter: .specificRating(3))
                }
                NavigationLink(value: StatsRoute.list(.specificRating(2))) {
                    StatsRowView(filter: .specificRating(2))
                }
                NavigationLink(value: StatsRoute.list(.specificRating(1))) {
                    StatsRowView(filter: .specificRating(1))
                }
                NavigationLink(value: StatsRoute.list(.specificRating(0))) {
                    StatsRowView(filter: .specificRating(0))
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Ratings")
    }
}

struct RatingsListView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsListView()
    }
}

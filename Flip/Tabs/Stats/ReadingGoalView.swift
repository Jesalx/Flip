//
//  ReadingGoalView.swift
//  Flip
//
//  Created by Jesal Patel on 7/24/22.
//

import SwiftUI

struct ReadingGoalView: View {

    let yearRead: Int

    @AppStorage("readingGoal") var readingGoal = 20
    @AppStorage("showReadingGoalProgress") var showReadingGoalProgress = true

    var body: some View {
        if readingGoal == 0 || !showReadingGoalProgress {
            EmptyView()
        } else {
            VStack(alignment: .center) {
                Text("\(Date.now.formatted(.dateTime.year())) Reading Goal")
                    .font(.title.weight(.semibold))
                HStack {
                    ProgressView(value: Double(min(yearRead, readingGoal)), total: Double(readingGoal))
                        .tint(.accentColor)
                        .padding(.leading)
                    Text("\(yearRead) / \(readingGoal)")
                        .font(.subheadline.weight(.semibold))
                        .monospacedDigit()
                        .padding(.leading)
                }
                .padding(.horizontal)
            }
            .padding(.top, 8)
        }
    }
}

struct ReadingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingGoalView(yearRead: 12)
    }
}

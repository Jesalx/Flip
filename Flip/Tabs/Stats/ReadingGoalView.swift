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
    
    var body: some View {
        if readingGoal == 0 {
            EmptyView()
        } else {
            VStack(alignment: .center) {
                Text("2022 Reading Goal")
                    .font(.title)
                HStack {
                    ProgressView(value: Double(min(yearRead, readingGoal)), total: Double(readingGoal))
                        .tint(.accentColor)
                        .padding(.leading)
                    Text("\(yearRead) / \(readingGoal)")
                        .monospacedDigit()
                        .padding(.leading)
                }
                .padding(.horizontal)
                
            }
        }
    }
}

struct ReadingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingGoalView(yearRead: 12)
    }
}

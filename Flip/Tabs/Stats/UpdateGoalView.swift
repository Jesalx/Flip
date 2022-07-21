//
//  UpdateGoalView.swift
//  Flip
//
//  Created by Jesal Patel on 7/21/22.
//

import SwiftUI

struct UpdateGoalView: View {

    @AppStorage("readingGoal") var readingGoal = 0

    let formatter: NumberFormatter

    init() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = false
        formatter.maximum = 2500
        formatter.minimum = 0
        self.formatter = formatter
    }

    var body: some View {
        VStack {
            Text("Reading Goal")
                .font(.title)
            Form {
                Section {
                    TextField("Reading Goal", value: $readingGoal, formatter: formatter)
                        .keyboardType(.numberPad)
                } footer: {
                    Text("Some text here that could talk about your reading goal or something. Blah blah blah")
                        .padding(.top, 5)
                }
            }
            Spacer()
        }
        .padding(.vertical, 30)
    }
}

struct UpdateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateGoalView()
    }
}

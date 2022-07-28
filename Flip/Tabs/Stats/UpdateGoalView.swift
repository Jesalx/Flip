//
//  UpdateGoalView.swift
//  Flip
//
//  Created by Jesal Patel on 7/21/22.
//

import SwiftUI
import WidgetKit

struct UpdateGoalView: View {

    @AppStorage("readingGoal", store: UserDefaults(suiteName: "group.dev.jesal.Flip")) var readingGoal = 0

    let formatter: NumberFormatter
    // swiftlint:disable:next line_length
    let readingGoalCaption = "Setting a reading goal can be a fun way to challenge yourself to read more books this year."
    let year: String

    init() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.allowsFloats = false
        numberFormatter.maximum = 2500
        numberFormatter.minimum = 0
        self.formatter = numberFormatter

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        self.year = dateFormatter.string(from: Date.now)
    }

    var body: some View {
        VStack {
            Text("\(year) Reading Goal")
                .font(.title.weight(.semibold))
            TextField("Reading Goal", value: $readingGoal.animation(), formatter: formatter)
                .padding(6)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.numberPad)
            Text(readingGoalCaption)
                .font(.caption)
                .padding(.horizontal)
                .padding(.top, 4)
            Spacer()
        }
        .onChange(of: readingGoal) { _ in WidgetCenter.shared.reloadAllTimelines() }
        .padding(30)
    }
}

struct UpdateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateGoalView()
    }
}

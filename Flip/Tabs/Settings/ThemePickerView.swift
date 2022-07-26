//
//  ThemePickerView.swift
//  Flip
//
//  Created by Jesal Patel on 7/21/22.
//

import SwiftUI
import WidgetKit

struct ThemePickerView: View {

    @AppStorage(
        "themeChoice",
        store: UserDefaults(suiteName: "group.dev.jesal.Flip")
    ) var themeChoice: Color.ThemeChoice = .mint

    var body: some View {
        Form {
            ForEach(Color.ThemeChoice.allCases, id: \.self) { choice in
                Button {
                    changeTheme(to: choice)
                } label: {
                    HStack {
                        Color.getThemeColor(choice)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(width: 40, height: 40)
                        Text(choice.rawValue.capitalized)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(choice == themeChoice ? .accentColor : .clear)
                    }
                }
            }
        }
        .onChange(of: themeChoice) { _ in WidgetCenter.shared.reloadAllTimelines() }
        .navigationTitle("Color Options")
    }

    func changeTheme(to choice: Color.ThemeChoice) {
        themeChoice = choice
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
